/**
##
# Copyright (c) 2013-2014 Apple Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##
*/

/** A generic container for an iCalendar component
 *
 * @param caldata jcal or data for jcal
 * @param parent of this component
 */
CalendarComponent = function(caldata, parent) {
	this.data = (caldata instanceof jcal ? caldata : new jcal(caldata));
	this.parent = parent;
};

// Maintain a registry of component types so the right class can be created when parsing
CalendarComponent.createComponentType = {};

CalendarComponent.registerComponentType = function(name, cls) {
	CalendarComponent.createComponentType[name] = cls;
};

CalendarComponent.buildComponentType = function(caldata, parent) {
	return new CalendarComponent.createComponentType[caldata.name()](caldata, parent);
};

CalendarComponent.prototype.duplicate = function(parent) {
	if (parent === undefined) {
		parent = this.parent;
	}
	return CalendarComponent.buildComponentType(this.data.duplicate(), parent);
};

CalendarComponent.prototype.toString = function() {
	return this.data.toString();
};

// Tell component whether it has changed or not
CalendarComponent.prototype.changed = function(value) {
	if (value === undefined) {
		return this.parent ? this.parent.changed() : false;
	} else {
		if (this.parent) {
			this.parent.changed(value);
		}
	}
};

CalendarComponent.prototype.uid = function() {
	return this.data.getPropertyValue("uid");
};

CalendarComponent.prototype.isTask = function() {
  return this.data.isTask();
};

// Indicate whether this object is owned by the current user.
CalendarComponent.prototype.isOwned = function() {
  var owner = this.getOwner()
  if (owner === null) {
    return false;
  }
	return gSession.currentPrincipal
                 .matchingAddress(owner.getCalendarAddress());
};

CalendarComponent.prototype.organizer = function() {
	return this.getOwner();
};

CalendarComponent.prototype.organizerDisplayName = function() {
	var owner = this.getOwner();
  if (owner === null) {
    return "?";
  }
  return new CalendarParticipant(owner.data, this).nameOrAddress();
};

CalendarComponent.prototype.status = function() {
	return this.data.getPropertyValue("status");
};

CalendarComponent.prototype.description = function(value) {
  if (value === undefined) {
    return this.data.getPropertyValue("description");
  }

  var val = checkStr(value);
  if (this.description() !== val) {
    this.data.updateProperty("description", val, {}, "text");
    this.changed(true);
  }
};

CalendarComponent.prototype.summary = function(value) {
	if (value === undefined) {
    return this.data.getPropertyValue("summary");
  }

  var val = checkStr(value);
  if (this.summary() !== val) {
    this.data.updateProperty("summary", val, {}, "text");
    this.changed(true);
  }
};

CalendarComponent.prototype.duration = function(value) {
  if (value === undefined) {
    return this.data.getPropertyValue("duration");
  }

  if (this.duration() !== value) {
    this.data.updateProperty("duration", value, {}, "duration");
    this.changed(true);
  }
};

/**
 *
 * @returns {JcalDtTime} representing the start time of the entity
 */
CalendarComponent.prototype.start = function() {
  if (this.startObj === undefined) {
    this.startObj = JcalDtTime.fromProperty(hour24, this.data.getProperty("dtstart"));
  }

  this.startObj.fieldType = "date";

  return this.startObj;
};

/**
 *
 * @returns {JcalDtTime} representing the end time of the entity
 */
CalendarComponent.prototype.end = function() {
  if (this.endObj !== undefined) {
    return this.endObj;
  }

  var pname = "dtend";
  if (this.isTask()) {
    pname = "due";
  }
  var dtend = this.data.getPropertyValue(pname);
  if (dtend !== null) {
    this.endObj = JcalDtTime.fromProperty(hour24, this.data.getProperty("dtend"));

    return this.endObj;
  }

  this.endObj = this.start().duplicateAs("end");

  var duration = this.duration();
  if (duration === null) {
    /* No dtend or duration -
       below is wrong - it's appropriate for DATE but for DATETIME
       it should be the same as the start,
       */
    if (this.endObj.allDay) {
      this.endObj.addDays(1);
    }
    this.endObj.fieldType = preferredEndType;
  } else {
    var offset = Jcalduration.parseText(duration).getTotalSeconds();
    this.endObj.addSeconds(offset);
    this.endObj.fieldType = "duration";
  }
  return this.endObj;
};

CalendarComponent.prototype.locationProp = function(value) {
  if (value === undefined) {
    return this.data.getPropertyValue("location");
  } else {
    if (this.location() !== value) {
      this.data.updateProperty("location", value, {}, "text");
      this.changed(true);
    }
  }
};

CalendarComponent.prototype.pollitemid = function(value) {
	if (value === undefined) {
		return this.data.getPropertyValue("poll-item-id");
	} else {
		if (this.pollitemid() !== value) {
			this.data.updateProperty("poll-item-id", value, {}, "integer");
			this.changed(true);
		}
	}
};

// A container class for VCALENDAR objects
CalendarObject = function(caldata) {
	CalendarComponent.call(this, caldata, null);
	this.changed(false);
};

CalendarObject.prototype = new CalendarComponent();
CalendarObject.prototype.constructor = CalendarObject;
CalendarComponent.registerComponentType("vcalendar", CalendarObject);

// A container class for VCARD objects
CardObject = function(cutype, cuaddr, carddata) {
  CalendarComponent.call(this, carddata, null);
  this.changed(false);
  this.cutype = cutype;
  this.cuaddr = cuaddr;
};

CardObject.prototype.cutype = function() {
  return this.cutype;
};

CardObject.prototype.cuaddr = function() {
  return this.cuaddr;
};

/**
 * If this is a group returns an array of members
 */
CardObject.prototype.members = function() {
};

CardObject.prototype = new CalendarComponent();
CardObject.prototype.constructor = CardObject;
CalendarComponent.registerComponentType("vcard", CardObject);

// This is the top-level object for changing tracking
CalendarObject.prototype.changed = function(value) {
	if (value === undefined) {
		return this._changed;
	} else {
		this._changed = value;
	}
};

// Get the main component type as one of our model classes
CalendarObject.prototype.mainComponent = function() {
	var main = this.data.mainComponent();
	return new CalendarComponent.buildComponentType(main, this);
};

// A container class for VPOLL objects
CalendarPoll = function(caldata, parent) {
	CalendarComponent.call(this, caldata, parent);
};

CalendarPoll.prototype = new CalendarComponent();
CalendarPoll.prototype.constructor = CalendarPoll;
CalendarComponent.registerComponentType("vpoll",  CalendarPoll);

// Create a brand new poll, defaulting various properties
CalendarPoll.newPoll = function(title) {
	var calendar = jcal.newCalendar();
	var vpoll = calendar.newComponent("vpoll", true);
	vpoll.newProperty("summary", title);
	vpoll.newProperty("poll-mode", "BASIC");
	vpoll.newProperty("poll-properties", ["DTSTART","DTEND"]);

  var poll = new CalendarPoll(vpoll, null);

  var owner = poll.data.newComponent("participant", true);
  owner.newProperty("calendar-address", gSession.currentPrincipal.defaultAddress(), {}, "cal-address");
  owner.newProperty("participant-type", "VOTER,OWNER");
  owner.newProperty("name", gSession.currentPrincipal.cn);
  owner.newProperty("participation-status", "ACCEPTED");

	return new CalendarObject(calendar);
};

// Whether or not current user can make changes (depends on their role as owner too)
CalendarPoll.prototype.editable = function() {
	var status = this.status();
	return status ? status === "IN-PROCESS" : true;
};

CalendarComponent.prototype.pollwinner = function(value) {
	if (value === undefined) {
		return this.data.getPropertyValue("poll-winner");
	} else {
		if (this.pollwinner() !== value) {
			this.data.updateProperty("poll-winner", parseInt(value), {}, "integer");
			this.changed(true);
		}
	}
};

CalendarComponent.prototype.ispollwinner = function() {
	var pollid = this.pollitemid();
	return pollid === undefined ? false : pollid === this.parent.pollwinner();
};

/** Get an array of choices in the VPOLL
 *
 */
CalendarPoll.prototype.choices = function() {
	var this_vpoll = this;
	return $.map(this.data.getComponents(), function(compData, index) {
    var comp = new jcal(compData);

    if (comp.name() === "participant") {
      return null;
    }

    var pi = comp.getPropertyValue("poll-item-id");
    if (pi === null) {
      return null;
    }

    if (comp.name() === "vevent") {
      return new CalendarEvent(comp, this_vpoll);
    }

    if (comp.name() === "vtodo") {
      return new CalendarTask(comp, this_vpoll);
    }

    console.warn("Unknown choice type: " + comp.name())
    return null;
	});
};

/** Get the designated choice
 *
 * @param itemId poll-item-id value
 * @returns {*}
 */
CalendarPoll.prototype.getChoice = function(itemId) {
  var comps = this.data.getComponents();
  for (var i = 0; i < comps.length; i++) {
    var comp = new jcal(comps[i]);

    var pi = comp.getPropertyValue("poll-item-id");
    if (pi === null) {
      continue;
    }

    if (parseInt(pi) === itemId) {
      if (comp.name() === "vevent") {
        return new CalendarEvent(comp, this);
      }

      return new CalendarTask(comp, this);
    }
  }

  return null;
};

/*
CalendarComponent.prototype.voter_responses = function() {
  var voter_results = {};
  $.each(this.voters(), function(index, voter) {
    var voter = voter.voter();
    voter_results[voter[3]] = parseInt(voter[1]["response"]);
  });
  return voter_results;
};
*/
/** remove the indexed choice
 *
 * @param index 0 based
 * @return {boolean} true if removed
 */
CalendarPoll.prototype.removeIndexedChoice = function(index) {
  var cs = this.choices();

  if (cs.length <= index) {
    return false;
  }

  var choice = cs[index];

  var pi = choice.pollitemid();
  if (pi === null) {
    return false;
  }

  this.removeChoice(parseInt(pi));
  return true;
};

/** remove the designated choice by poll item id
 *
 * @param itemId poll-item-id value
 */
CalendarPoll.prototype.removeChoice = function(itemId) {
  var thisComp = this;
  var results = $.grep(this.data.getComponents(),
      function(compData, index) {
        var comp = new jcal(compData);

        var pi = comp.getPropertyValue("poll-item-id");
        if (pi === null) {
          return true;
        }

        if (parseInt(pi) === itemId) {
          thisComp.changed(true);
          return false;
        }

        return true;
      });
  this.data.setComponents(results);
};

/** Make a new choice for the VPOLL
 *
 * @param type
 * @param start
 * @param end
 * @returns {*}
 */
CalendarPoll.prototype.makeChoice = function(type, start, end) {
	//this.changed(true);
	var compData = makeJcal(type, true);

  var dtPars = {"tzid": defaultTzid};

  start.updateProperty(compData);
  end.updateProperty(compData, start);

	compData.newProperty("summary", this.summary());
  compData.newProperty("organizer", gSession.currentPrincipal.defaultAddress());

  var choice;

  if (compData.isEvent()) {
    choice = new CalendarEvent(compData, this);
  } else {
    choice = new CalendarTask(compData, this);
  }

  this.syncAttendees(choice);
  choice.startObj = start;
  choice.endObj = end;

  return choice;
};

/** Get an array of voters in the VPOLL
 *
 */
CalendarPoll.prototype.getVoters = function() {
  var this_vpoll = this;
  return $.map(this.data.getComponents(), function(compData, index) {
    var comp = new jcal(compData);

    if (comp.isParticipant()) {
      var part = new CalendarParticipant(comp, this_vpoll);
      if (part.getPtypes().includes("voter")) {
        return part;
      }
    }

    return null;
  });
};

/** Get the participant designated as the owner
 *
 * @returns owner participant or null
 */
CalendarComponent.prototype.getOwner = function() {
  var this_vpoll = this;
  var comps = this.data.getComponents();
  for (var i = 0; i < comps.length; i++) {
    var comp = new jcal(comps[i]);

    if (comp.isParticipant()) {
      var part = new CalendarParticipant(comp, this_vpoll);
      if (part.getPtypes().includes("owner")) {
        return part;
      }
    }
  }

  return null;
};

/** Get the designated voter element
 *
 * @param cua - the voter cuaddr or absent for current
 * @returns {*}
 */
CalendarPoll.prototype.getVoter = function(cua) {
  var voters = this.getVoters();

  for (var i = 0; i < voters.length; i++) {
    var voter = voters[i];
    var vcua = voter.getCalendarAddress();
    if (cua === undefined) {
      if (gSession.currentPrincipal.matchingAddress(vcua)) {
        return voter;
      }
    } else {
      if (vcua === cua) {
        return voter;
      }
    }
  }

  return null;
};

/** Change active user's response in this object
 *
 * @param itemId
 * @param response - normalised response value
 */
CalendarPoll.prototype.changeVoterResponse = function(itemId, response) {
  /* Locate the current users voter entry */

  var voters = this.getVoters();
  var matches = $.grep(voters, function(voter, index) {
    return gSession.currentPrincipal.matchingAddress(
        voter.getCalendarAddress());
  });

  if (matches.length === 0) {
    alert("No voter entry for " + gSession.currentPrincipal.defaultAddress());
    return;
  }

  if (matches.length !== 1) {
    alert("Multiple voter entries for " + gSession.currentPrincipal.defaultAddress());
    return;
  }

  /* matchs[0] is a voter */
  var vote = matches[0].addVote(itemId);
  var presp = vote.response();

  if ((presp !== null) &&
      (normaliseVpollResponse(parseInt(presp)) === response)) {
    // Don't change
    return;
  }

  vote.response(unnormaliseVpollResponse(response));
};

/** Add a voter to the VPOLL
 *
 * @returns {CalendarParticipant}
 */
CalendarPoll.prototype.addVoter = function(caladdr) {
  this.changed(true);
  var comp = this.data.newComponent("participant", false);
  comp.newProperty("calendar-address", caladdr, {}, "cal-address");
  comp.newProperty("participant-type", "VOTER", {}, "text");

  return new CalendarParticipant(comp, this);
};

/** Remove nth voter from the VPOLL
 *
 * @returns {CalendarUser}
 */
CalendarPoll.prototype.removeVoter = function(address) {
  if (this.getVoters().length === 1) {
    alert("Must have at least 1 voter");
  }
  this.changed(true);
  this.data.removeComponentMatching(address, voterMatcher);
};

function voterMatcher(compData, key, compIndex) {
  var comp = new CalendarComponent(compData);

  if (comp.data.name().toLowerCase() !== "participant") {
    return false;
  }

  var matches = key === comp.data.getPropertyValue("calendar-address");

  return matches;
}

// Mark current user as accepted
CalendarPoll.prototype.acceptInvite = function() {
  if (!this.isOwned()) {
    var voter = this.getVoter();
    voter.setStatus("ACCEPTED");
    voter.data.removeProperties("expect-reply");
  }
};

/** Get the next free poll-item-id
 *
 * @returns int
 */
CalendarPoll.prototype.nextPollItemId = function() {
  return this.data.nextPollItemId()
};

/** Save a choice in the VPOLL
 *
 * @param comp - the choice
 */
CalendarPoll.prototype.saveChoice = function(comp) {
  // May already be there
  if (this.getChoice(comp.pollitemid()) != null) {
    return;
  }

  this.data.addComponent(comp.data);
  this.changed(true);
};

/** Make component attendees match poll voters
 *
 * @param choice jcal object
 */
CalendarPoll.prototype.syncAttendees = function(choice) {
  if (choice === undefined) {
    // Do all choices
    var thisVpoll = this;

    // Flag this with an x-prop
    this.data.updateProperty("x-bw-syncattendees", "on");

    $.each(this.choices(), function(index, choice) {
      thisVpoll.syncAttendees(choice);
    });
    return;
  }

  choice.data.removeProperties("attendee");
  var voters = this.getVoters();
  $.each(voters, function(index, voter) {
    var vca = voter.getCalendarAddress();
    var attP = choice.data.newProperty(
        "attendee",
        vca,
        {},
        "cal-address"
    );

    var attendee = new CalendarUser(attP, null);
    attendee.cn(voter.getName());
    attendee.cutype(voter.getKind());

    if (gSession.currentPrincipal
                .matchingAddress(voter.getCalendarAddress())) {
      voter.setStatus("ACCEPTED");
    } else {
      voter.setStatus("NEEDS-ACTION");
//      attendee.rsvp(true);
    }
  });
};

// An actual VEVENT object we can manipulate
CalendarEvent = function(caldata, parent) {
	CalendarComponent.call(this, caldata, parent);
};

CalendarEvent.prototype = new CalendarComponent();
CalendarEvent.prototype.constructor = CalendarEvent;
CalendarComponent.registerComponentType("vevent", CalendarEvent);

CalendarTask = function(caldata, parent) {
  CalendarComponent.call(this, caldata, parent);
};

CalendarTask.prototype = new CalendarComponent();
CalendarTask.prototype.constructor = CalendarTask;
CalendarComponent.registerComponentType("vtodo", CalendarTask);

/** A participant component
 *
 * @param caldata - the data for this component
 * @param parent - a poll
 * @constructor
 */
CalendarParticipant = function(caldata, parent) {
  CalendarComponent.call(this, caldata, parent);
};

CalendarParticipant.prototype = new CalendarComponent();
CalendarParticipant.prototype.constructor = CalendarParticipant;
CalendarComponent.registerComponentType("participant", CalendarParticipant);

/** Get a participant calendar-address value
 *
 * @returns {*}
 */
CalendarParticipant.prototype.getCalendarAddress = function() {
  return this.data.getPropertyValue("calendar-address");
};

CalendarParticipant.prototype.addressDescription = function(value) {
  if (value === undefined) {
    var ad = this.getCalendarAddress() ? this.getCalendarAddress() + " " : "";
    return addressDescription(ad, this.getName());
  }

  if (this.addressDescription() !== value) {
    var splits = splitAddressDescription(value);
    if (splits[0]) {
      this.setName(splits[0]);
    } else {
      this.data.removeProperties("name");
    }
    this.data.updateProperty("calendar-address", splits[1],
        {}, "cal-address");
    if (this.parent != null) {
      this.parent.changed(true);
    }
  }
};

/** Get an array of votes in the VPOLL
 *
 */
CalendarParticipant.prototype.getVotes = function() {
  var this_voter = this;
  return $.map(this.data.getComponents(), function(compData, index) {
    var comp = new jcal(compData);

    if (comp.name() === "vote") {
      return new CalendarVote(comp, this_voter);
    }

    return null;
  });
};

// Get the name for this user
CalendarParticipant.prototype.getName = function() {
  return this.data.getPropertyValue("name");
};

// Set the name for this user
CalendarParticipant.prototype.setName = function(val) {
  return this.data.updateProperty("name", val);
};

// Get the kind for this user
CalendarParticipant.prototype.getKind = function() {
  return this.data.getPropertyValue("kind");
};

// Set the kind for this user
CalendarParticipant.prototype.setKind = function(val) {
  var ps = this.data
      .getPropertyValue("kind");

  if (ps === null) {
    this.data.newProperty("kind", val, {}, "text");
  } else {
    this.data.updateProperty("kind", val, {}, "text");
  }
};

// Get a suitable display string for this user
CalendarParticipant.prototype.nameOrAddress = function() {
  var name = this.data.getPropertyValue("name");

  if (name !== null) {
    return name;
  }

  return this.data.getPropertyValue("calendar-address");
};

/** Get an array of participant types
 *
 */
CalendarParticipant.prototype.getPtypes = function() {
  var ptype = this.data.getPropertyValue("participant-type");
  if (ptype === null) {
    return [];
  }

  return ptype.trim().toLowerCase().split(/\s*,\s*/);
};

/** Add a participant type
 *
 */
CalendarParticipant.prototype.addPtype = function(val) {
  var ptype = this.data.getPropertyValue("participant-type");
  var ptypes;
  if (ptype === null) {
    ptypes = [];
  } else {
    ptypes = ptype.trim().toLowerCase().split(/\s*,\s*/);
  }
  if (ptypes.includes(val, 0)) {
    return;
  }

  this.data.updateProperty("participant-type", val, {}, ptype +
      "," + val);
};

/** Update status
 *
 */
CalendarParticipant.prototype.setStatus = function(val) {
  var ps = this.data
      .getPropertyValue("participation-status");

  if (ps === null) {
    this.data.newProperty("participation-status", val, {}, "text");
  } else {
    this.data.updateProperty("participation-status", val, {}, "text");
  }
};

/** Get the designated vote element
 *
 * @param itemId poll-item-id value
 * @returns {*}
 */
CalendarParticipant.prototype.getVote = function(itemId) {
  var votes = this.getVotes();
  for (var i = 0; i < votes.length; i++) {
    if (votes[i].pollitemid() === itemId) {
      return votes[i];
    }
  }

  return null;
};

/** Get the designated response normalised to small values
 *
 * @param itemId poll-item-id
 * @returns int response value normalised
 */
CalendarParticipant.prototype.getResponseNormalised = function(itemId) {
  var vote = this.getVote(itemId);
  var response = null;
  if (vote !== null) {
    response = parseInt(vote.response());
  }

  return normaliseVpollResponse(response);
};

/** Add the designated vote element
 *
 * @param itemId poll-item-id value
 * @returns {CalendarVote} added or existing
 */
CalendarParticipant.prototype.addVote = function(itemId) {
  var votes = this.getVotes();
  for (var i = 0; i < votes.length; i++) {
    if (votes[i].pollitemid() === itemId) {
      return votes[i];
    }
  }

  this.changed(true);
  var comp = this.data.newComponent("vote", false);
  var vote = new CalendarVote(comp, this);

  vote.pollitemid(itemId);

  return vote;
};

/** A vote component - one of these per choice in a voter
 *
 * @param caldata - the data for this component
 * @param parent - a voter
 * @constructor
 */
CalendarVote = function(caldata, parent) {
  CalendarComponent.call(this, caldata, parent);
};

CalendarVote.prototype = new CalendarComponent();
CalendarVote.prototype.constructor = CalendarVote;
CalendarComponent.registerComponentType("vote", CalendarVote);

/**
 *
 * @param val - response value
 * @returns {*|string}
 */
CalendarVote.prototype.response = function(val) {
  if (val === undefined) {
    return this.data.getPropertyValue("response");
  }

  if (this.response() !== val) {
    this.data.updateProperty("response", val, {}, "integer");
    this.changed(true);
  }
};

// Duplicate this component as the poll winner
CalendarComponent.prototype.pickAsWinner = function() {
	// Adjust VPOLL to mark winner and set status
	var vpoll = this.parent;
	vpoll.data.updateProperty("status", "CONFIRMED");
	vpoll.data.newProperty("poll-winner", this.pollitemid());
	vpoll.changed(true);

  // Create the new event resource
  var calendar = new CalendarObject(jcal.newCalendar());

  var winner = this.duplicate();

  calendar.data.addComponent(winner.data);
  calendar.changed(true);
  var eventCal;

  if (gSession.currentPrincipal.defaultEventCalendar !== null) {
    eventCal = gSession.currentPrincipal.defaultEventCalendar;
  } else {
    eventCal = gSession.currentPrincipal.eventCalendars[0];
  }

	return new CalendarResource(eventCal, null, null, calendar);
};

// Get an array of attendees
CalendarComponent.prototype.attendees = function() {
  var thisComp = this;
  return $.map(this.data.properties("attendee"), function(attendee) {
    return new CalendarUser(attendee, thisComp);
  });
};

// Get an array of recurrence info
CalendarComponent.prototype.rrules = function(val) {
  if (val === undefined) {
    return $.map(this.data.properties("rrule"), function (rrule) {
      return rrule;
    });
  }

  this.data.updateProperty("rrule", val, {}, "recur");
};

// Get an array of rdates
CalendarComponent.prototype.rdates = function() {
  return $.map(this.data.properties("rdate"), function(val) {
    return val;
  });
};

// Get an array of rdates
CalendarComponent.prototype.exdates = function() {
  return $.map(this.data.properties("exdate"), function(val) {
    return val;
  });
};

/** An iCalendar property
 *
 * @param caldata - [name, params, type, value]
 * @param parent
 * @constructor
 */
CalendarProperty = function(caldata, parent) {
  this.data = caldata;
  this.parent = parent;
};

/** update this from the value
 *
 * @param value
 */
CalendarProperty.prototype.updateFrom = function(value) {
  this.data[1] = value.data[1];
  this.data[2] = value.data[2];
  this.data[3] = value.data[3];
};

// An iCalendar calendar user (ORGANIZER/ATTENDEE/VOTER) property
CalendarUser = function(caldata, parent) {
	this.data = caldata;
	this.parent = parent;
};

// Get or set the user name and/or cu-address

/** Get or set the user name and/or cu-address
 *
 * @param value  name<addr> or addr
 * @returns {*}
 */
CalendarUser.prototype.addressDescription = function(value) {
	if (value === undefined) {
		var cn = this.data[1]["cn"] ? this.data[1]["cn"] + " " : "";
		return addressDescription(cn, this.data[3]);
	}

  if (this.addressDescription() !== value) {
    var splits = splitAddressDescription(value);
    if (splits[0]) {
      this.data[1]["cn"] = splits[0];
    } else {
      delete this.data[1]["cn"];
    }
    this.data[3] = splits[1];
    if (this.parent != null) {
      this.parent.changed(true);
    }
  }
};

// Get or set the user cutype
CalendarUser.prototype.cutype = function(value) {
  var cur = this.data[1]["cutype"];

  if (value === undefined) {
    return cur;
  }

  // We don't want cutype present if it's default of individual
  var isDefault = value === "INDIVIDUAL";

  if (cur === undefined) {
    if (!isDefault) {
      this.data[1]["cutype"] = value;
    }
    return;
  }

  if (isDefault) {
    delete this.data[1]["cutype"];
    return;
  }

  this.data[1]["cutype"] = value;
};

// Get a suitable display string for this user
CalendarUser.prototype.nameOrAddress = function() {
  var cn = this.cn();

  if (cn != null) {
    return cn;
  }

	return this.data[3];
};

/** Get the common name
 *
 * @returns {*}
 */
CalendarUser.prototype.cn = function(value) {
  if (value === undefined) {
    return this.data[1]["cn"];
  }

  if (this.cn() !== value) {
    if (!value) {
      delete this.data[1]["cn"];
    } else {
      this.data[1]["cn"] = value;
    }
    if (this.parent != null) {
      this.parent.changed(true);
    }
  }
};

CalendarUser.prototype.cuaddr = function() {
	return this.data[3];
};
