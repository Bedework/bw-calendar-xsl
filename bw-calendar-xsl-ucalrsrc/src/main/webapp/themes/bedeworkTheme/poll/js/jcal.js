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

gProdID = "-//bedework.org//jcal v1//EN";

jcalparser = {
	PARSER_ALLOW : 0, 	// Pass the "suspect" data through to the object model
	PARSER_IGNORE : 1, 	// Ignore the "suspect" data
	PARSER_FIX: 2, 		// Fix (or if not possible ignore) the "suspect" data
	PARSER_RAISE: 3 	// Raise an exception
}

// Some clients escape ":" - fix
jcalparser.INVALID_COLON_ESCAPE_SEQUENCE = jcalparser.PARSER_FIX;

// Other escape sequences - raise
jcalparser.INVALID_ESCAPE_SEQUENCES = jcalparser.PARSER_RAISE;

// Some client generate empty lines in the body of the data
jcalparser.BLANK_LINES_IN_DATA = jcalparser.PARSER_FIX;

// Some clients still generate vCard 2 parameter syntax
jcalparser.VCARD_2_NO_PARAMETER_VALUES = jcalparser.PARSER_ALLOW;

// Use this to fix v2 BASE64 to v3 ENCODING=b - only PARSER_FIX or PARSER_ALLOW
jcalparser.VCARD_2_BASE64 = jcalparser.PARSER_FIX;

// Allow DATE values when DATETIME specified (and vice versa)
jcalparser.INVALID_DATETIME_VALUE = jcalparser.PARSER_FIX;

// Allow slightly invalid DURATION values
jcalparser.INVALID_DURATION_VALUE = jcalparser.PARSER_FIX;

// Truncate over long ADR and N values
jcalparser.INVALID_ADR_N_VALUES = jcalparser.PARSER_FIX;

// REQUEST-STATUS values with \; as the first separator or single element
jcalparser.INVALID_REQUEST_STATUS_VALUE = jcalparser.PARSER_FIX;

// Remove \-escaping in URI values when parsing - only PARSER_FIX or PARSER_ALLOW
jcalparser.BACKSLASH_IN_URI_VALUE = jcalparser.PARSER_FIX;

/** This class represent an icalendar object in json.
 * The top level is represented by an array with 3 elements:
 *
 * 1.  A string with the name of the iCalendar component, but in lowercase.
 *
 * 2.  An array of jCal properties as described in Section 3.4.
 *
 * 3.  An array of jCal components, representing the sub-components of
 * the component in question.
 *
 * @param caldata - the above 3 element array
 */
jcal = function(caldata) {
	this.caldata = caldata;
};

jcal.newCalendar = function() {
	var calendar = new jcal(["vcalendar", [], []]);
	calendar.newProperty("version", "2.0");
	calendar.newProperty("prodid", gProdID);
	return calendar;
};

jcal.fromString = function(data) {
	return new jcal($.parseJSON(data));
};

jcal.prototype.toString = function() {
	return JSON.stringify(this.caldata);
};

jcal.prototype.duplicate = function() {
	return new jcal($.parseJSON(this.toString()));
};

jcal.prototype.name = function() {
	return this.caldata[0];
};

jcal.prototype.isEvent = function() {
  return this.name() === "vevent";
};

jcal.prototype.isTask = function() {
  return this.name() === "vtodo";
};

jcal.prototype.isParticipant = function() {
  return this.name() === "participant";
};

// Return the primary (master) component
// TODO: currently ignores recurrence - i.e. assumes one top-level component only
jcal.prototype.mainComponent = function() {
	var results = $.grep(this.caldata[2], function(component, index) {
		return (component[0] !== "vtimezone");
	});
	return (results.length === 1) ? new jcal(results[0]) : null;
};

function makeJcal(name, defaultProperties) {
  var jcomp = new jcal([name.toLowerCase(), [], []]);
  if (defaultProperties) {
    // Add UID and DTSTAMP
    jcomp.newProperty("uid", generateUUID());
    jcomp.newProperty("dtstamp", jcalTimestamp(), {}, "date-time");
  }
  return jcomp;
}

jcal.prototype.newComponent = function(name, defaultProperties) {
  return this.addComponent(makeJcal(name, defaultProperties));
};

jcal.prototype.addComponent = function(component) {
	this.caldata[2].push(component.caldata);
	return component;
};

// Get one component
jcal.prototype.getComponent = function(name) {
	name = name.toLowerCase();
	var results = $.grep(this.caldata[2], function(component, index) {
		return (component[0] == name);
	});
	return (results.length == 1) ? new jcal(results[0]) : null;
};

// Get all matching components
jcal.prototype.components = function(name) {
	name = name.toLowerCase();
	var results = $.grep(this.caldata[2], function(component, index) {
		return (component[0] == name);
	});
	return $.map(results, function(component, index) {
		return new jcal(component);
	});
};

/** Get all components
 *
 * @returns {*}
 */
jcal.prototype.getComponents = function() {
  return this.caldata[2];
};

/** Set all components
 *
 * @returns {*}
 */
jcal.prototype.setComponents = function(comps) {
  this.caldata[2] = comps;
};

// Get the next pollItemId
jcal.prototype.nextPollItemId = function() {
    var pid = 0;
    $.each(this.caldata[2], function(index, component) {
        var itemid = new jcal(component).getPropertyValue("poll-item-id");
        if (itemid != null) {
            if  (itemid > pid) {
                pid = itemid;
            }
        }
    });
    return parseInt(pid) + 1;
};

// Remove all matching components
jcal.prototype.removeComponents = function(name) {
	name = name.toLowerCase();
	this.caldata[2] = $.grep(this.caldata[2], function(comp, index) {
		return comp[0] != name;
	});
};

/**
 * remove nth (starting at 0) component with given name
 * @param key for matcher
 * @param matcher function with 3 parameters -
 * 						component data
 * 					  key value
 * 						index in array
 *           return true for a match.
 */
jcal.prototype.removeComponentMatching = function(key, matcher) {
  this.caldata[2] = $.grep(this.caldata[2], function(compdata, index) {
		return !matcher(compdata, key, index);
  });
};

jcal.prototype.newProperty = function(name, value, params, value_type) {
	var prop = [name.toLowerCase(), params === undefined ? {} : params, value_type == undefined ? "text" : value_type];
	if (value instanceof Array) {
		$.each(value, function(index, single) {
			prop.push(single);
		});
	} else {
		prop.push(value);
	}
	this.caldata[1].push(prop);
	return prop;
};

jcal.prototype.copyProperty = function(name, component) {
	var propdata = component.getProperty(name);
	this.caldata[1].push([propdata[0], propdata[1], propdata[2], propdata[3]]);
	return propdata;
};

jcal.prototype.hasProperty = function(name) {
	var result = false;
	name = name.toLowerCase();
	$.each(this.caldata[1], function(index, property) {
		if (property[0] === name) {
			result = true;
			return false;
		}
	});
	return result;
};

jcal.prototype.getProperty = function(name) {
	var result = null;
	name = name.toLowerCase();
	$.each(this.caldata[1], function(index, property) {
		if (property[0] === name) {
			result = property;
			return false;
		}
	});
	return result;
};

jcal.prototype.getPropertyValue = function(name) {
	var result = null;
	name = name.toLowerCase();
	$.each(this.caldata[1], function(index, propdata) {
		if (propdata[0] === name) {
			result = propdata[3];
			return false;
		}
	});
	return result;
};

jcal.prototype.updateProperty = function(name, value, params, valueType) {
	if (params === undefined) {
		params = {};
	}
	if (valueType === undefined) {
		valueType = "text";
	}
	var props = this.properties(name);
	if (props.length === 1) {
		props[0][1] = params;
		props[0][2] = valueType;
		props[0][3] = value;

		return props[0];
	}

  if (props.length == 0) {
		return this.newProperty(name, value, params, valueType);
	}
};

jcal.prototype.properties = function(name) {
	return $.grep(this.caldata[1], function(propdata, index) {
		return propdata[0] == name;
	});
};

jcal.prototype.removeProperties = function(name) {
	name = name.toLowerCase();
	this.caldata[1] = $.grep(this.caldata[1], function(propdata, index) {
		return propdata[0] != name;
	});
};

/**
 * remove nth (starting at 0) property with given name
 * @param name
 * @param index
 */
jcal.prototype.removePropertyMatching = function(name, indexToRemove) {
  name = name.toLowerCase();
  var i = 0;
  this.caldata[1] = $.grep(this.caldata[1], function(propdata, index) {
    if (propdata[0] !== name) {
      return true;
    }

    i++;

    return indexToRemove !== (i - 1);
  });
};

// Remove properties for which test() returns true
jcal.prototype.removePropertiesMatching = function(test) {
	this.caldata[1] = $.grep(this.caldata[1], function(propdata, index) {
		return !test(propdata);
	});
};

function digits2(val) {
  var i = parseInt(val);
  if (i > 9) {
    return val;
  }

  return "0" + i;
}

function digits4(val) {
  return ("000" + val).substr(-4);
}

function jcalTimestamp() {
  return new Date().toISOString().substr(0, 19) + "Z";
}

// Duration utility functions
Jcalduration = function(duration) {

	if (duration === undefined) {
		this.mForward = true;

		this.mWeeks = 0;
		this.mDays = 0;

		this.mHours = 0;
		this.mMinutes = 0;
		this.mSeconds = 0;
	} else {
		this.setDuration(duration);
	}
};

Jcalduration.parseText = function(data) {
	var duration = new Jcalduration();
	duration.parse(data);
	return duration;
};

Jcalduration.prototype.getTotalSeconds = function() {
	return (this.mForward ? 1 : -1) * (this.mSeconds + (this.mMinutes + (this.mHours + (this.mDays + (this.mWeeks * 7)) * 24) * 60) * 60);
};

Jcalduration.prototype.setDuration = function(seconds) {
	this.mForward = seconds >= 0;

	var remainder = seconds;
	if (remainder < 0) {
		remainder = -remainder;
	}

	// Is it an exact number of weeks - if so use the weeks value, otherwise
	// days, hours, minutes, seconds
	if (remainder % (7 * 24 * 60 * 60) == 0) {
		this.mWeeks = remainder / (7 * 24 * 60 * 60);
		this.mDays = 0;

		this.mHours = 0;
		this.mMinutes = 0;
		this.mSeconds = 0;
	} else {
		this.mSeconds = remainder % 60;
		remainder -= this.mSeconds;
		remainder /= 60;

		this.mMinutes = remainder % 60;
		remainder -= this.mMinutes;
		remainder /= 60;

		this.mHours = remainder % 24;
		remainder -= this.mHours;

		this.mDays = remainder / 24;

		this.mWeeks = 0;
	}
};

Jcalduration.prototype.parse = function(data) {
	// parse format ([+]/-) "P" (dur-date / dur-time / dur-week)
	try {
		var offset = 0;
		var maxoffset = data.length;

		// Look for +/-
		this.mForward = true;
		if (data[offset] == '+') {
			this.mForward = true;
			offset += 1;
		} else if (data[offset] == '-') {
			this.mForward = false;
			offset += 1;
		}

		// Must have a 'P'
		if (data[offset] != "P")
			throw "Invalid duration";
		offset += 1;

		// Look for time
		if (data[offset] != "T") {
			// Must have a number
			var strnum = data.strtoul(offset);
			var num = strnum.num;
			offset = strnum.offset;

			// Now look at character
			if (data[offset] == "W") {
				// Have a number of weeks
				this.mWeeks = num;
				offset += 1;

				// There cannot be anything else after this so just exit
				if (offset != maxoffset) {
					if (ParserContext.INVALID_DURATION_VALUE != ParserContext.PARSER_RAISE)
						return;
					throw "Invalid duration";
				}
				return;
			} else if (data[offset] == "D") {
				// Have a number of days
				this.mDays = num;
				offset += 1;

				// Look for more data - exit if none
				if (offset == maxoffset)
					return;

				// Look for time - exit if none
				if (data[offset] != "T")
					throw "Invalid duration";
			} else {
				// Error in format
				throw "Invalid duration";
			}
		}

		// Have time
		offset += 1;

		// Strictly speaking T must always be followed by time values, but some clients
		// send T with no additional text
		if (offset == maxoffset) {
			if (jcalparser.INVALID_DURATION_VALUE == jcalparser.PARSER_RAISE)
				throw "Invalid duration";
			else
				return;
		}
		var strnum = data.strtoul(offset);
		var num = strnum.num;
		offset = strnum.offset;

		// Look for hour
		if (data[offset] == "H") {
			// Get hours
			this.mHours = num;
			offset += 1;

			// Look for more data - exit if none
			if (offset == maxoffset)
				return;

			// Parse the next number
			strnum = data.strtoul(offset);
			num = strnum.num;
			offset = strnum.offset;
		}

		// Look for minute
		if (data[offset] == "M") {
			// Get hours
			this.mMinutes = num;
			offset += 1;

			// Look for more data - exit if none
			if (offset == maxoffset)
				return;

			// Parse the next number
			strnum = data.strtoul(offset);
			num = strnum.num;
			offset = strnum.offset;
		}

		// Look for seconds
		if (data[offset] == "S") {
			// Get hours
			this.mSeconds = num;
			offset += 1;

			// No more data - exit
			if (offset == maxoffset)
				return;
		}

		throw "Invalid duration";
	} catch(err) {
		throw "Invalid duration";
	}
};

Jcalduration.prototype.generate = function(self, os) {
	var result = "";

	if (!this.mForward && (this.mWeeks || this.mDays || this.mHours || this.mMinutes || this.mSeconds)) {
		result += "-";
	}
	result += "P";

	if (this.mWeeks != 0) {
		result += this.mWeeks + "W";
	} else {
		if (this.mDays != 0) {
			result += this.mDays + "D";
		}

		if (this.mHours != 0 || this.mMinutes != 0 || this.mSeconds != 0) {
			result += "T";

			if (this.mHours != 0) {
				result += this.mHours + "H";
			}

			if ((this.mMinutes != 0) || ((this.mHours != 0) && (this.mSeconds != 0))) {
				result += this.mMinutes + "M";
			}

			if (this.mSeconds != 0) {
				result += this.mSeconds + "S";
			}
		} else if (this.mDays == 0) {
			result += "T0S";
		}
	}

	return result;
}
