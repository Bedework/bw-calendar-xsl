/*
   Licensed to Jasig under one or more contributor license
   agreements. See the NOTICE file distributed with this work
   for additional information regarding copyright ownership.
   Jasig licenses this file to you under the Apache License,
   Version 2.0 (the "License"); you may not use this file
   except in compliance with the License. You may obtain a
   copy of the License at:

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing,
   software distributed under the License is distributed on
   an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied. See the License for the
   specific language governing permissions and limitations
   under the License.
*/

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}
// show hide items using a checkbox
function swapVisible(obj,id) {
  if (obj.checked) {
    changeClass(id,'shown');
  } else {
    changeClass(id,'invisible');
  }
}
function swapAllDayEvent(obj) {
  let allDayStartDateField = document.getElementById("allDayStartDateField");
  let allDayEndDateField = document.getElementById("allDayEndDateField");
  if (obj.checked) {
    //let's keep it simple for now: just show or hide time fields
    changeClass('startTimeFields','invisible');
    changeClass('endTimeFields','invisible');
    changeClass('durationHrMin','invisible');
    allDayStartDateField.value = "on";
    allDayEndDateField.value = "on";
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('durationHrMin','shown');
    allDayStartDateField.value = "off";
    allDayEndDateField.value = "off";
  }
}
function swapFloatingTime(obj) {
  const startTimezone = document.getElementById("startTzid");
  const endTimezone = document.getElementById("endTzid");
  const startFloating = document.getElementById("startFloating");
  const endFloating = document.getElementById("endFloating");
  if (obj.checked) {
    document.getElementById("storeUTCFlag").checked = false;
    startTimezone.disabled = true;
    endTimezone.disabled = true;
    startFloating.value = "on";
    endFloating.value = "on";
  } else {
    startTimezone.disabled = false;
    endTimezone.disabled = false;
    startFloating.value = "off";
    endFloating.value = "off";
  }
}
function swapStoreUTC(obj) {
  const startTimezone = document.getElementById("startTzid");
  const endTimezone = document.getElementById("endTzid");
  const startStoreUTC = document.getElementById("startStoreUTC");
  const endStoreUTC = document.getElementById("endStoreUTC");
  if (obj.checked) {
    document.getElementById("floatingFlag").checked = false;
    startTimezone.disabled = false;
    endTimezone.disabled = false;
    startStoreUTC.value = "on";
    endStoreUTC.value = "on";
  } else {
    startStoreUTC.value = "off";
    endStoreUTC.value = "off";
  }
}
function swapDurationType(type) {
  // get the components we need to manipulate
  const daysDurationElement = document.getElementById("durationDays");
  const hoursDurationElement = document.getElementById("durationHours");
  const minutesDurationElement = document.getElementById("durationMinutes");
  const weeksDurationElement = document.getElementById("durationWeeks");
  if (type === 'week') {
    weeksDurationElement.disabled = false;
    daysDurationElement.disabled = true;
    hoursDurationElement.disabled = true;
    minutesDurationElement.disabled = true;
  } else {
    daysDurationElement.disabled = false;
    hoursDurationElement.disabled = false;
    minutesDurationElement.disabled = false;
    // we are using day, hour, minute -- zero out the weeks.
    weeksDurationElement.value = "0";
    weeksDurationElement.disabled = true;
  }
}
function swapRecurrence(obj) {
  if (obj.checked) {
    changeClass('recurrenceFields','dateStartEndBox');
    changeClass('recurrenceUiSwitch','shown');
  } else {
    changeClass('recurrenceFields','invisible');
    changeClass('recurrenceUiSwitch','invisible');
  }
}
// reveal and hide recurrence fields
function showRecurrence(freq) {
  changeClass('recurrenceUntilRules','shown');

  if (freq === 'NONE') {
    changeClass('noneRecurrenceRules','shown');
    changeClass('recurrenceUntilRules','invisible');
  } else {
    changeClass('noneRecurrenceRules','invisible');
  }
  if (freq === 'HOURLY') {
    changeClass('hourlyRecurrenceRules','shown');
  } else {
    changeClass('hourlyRecurrenceRules','invisible');
  }
  if (freq === 'DAILY') {
    changeClass('dailyRecurrenceRules','shown');
  } else {
    changeClass('dailyRecurrenceRules','invisible');
  }
  if (freq === 'WEEKLY') {
    changeClass('weeklyRecurrenceRules','shown');
  } else {
    changeClass('weeklyRecurrenceRules','invisible');
  }
  if (freq === 'MONTHLY') {
    changeClass('monthlyRecurrenceRules','shown');
  } else {
    changeClass('monthlyRecurrenceRules','invisible');
  }
  if (freq === 'YEARLY') {
    changeClass('yearlyRecurrenceRules','shown');
  } else {
    changeClass('yearlyRecurrenceRules','invisible');
  }
}
function recurSelectWeekends(id) {
  const chkBoxCollection = document.getElementById(id).getElementsByTagName('input');
  if (chkBoxCollection) {
    if (typeof chkBoxCollection.length != 'undefined') {
      for (i = 0; i < chkBoxCollection.length; i++) {
        if (chkBoxCollection[i].value === 'SU' || chkBoxCollection[i].value === 'SA') {
           chkBoxCollection[i].checked = true;
        } else {
          chkBoxCollection[i].checked = false;
        }
      }
    }
  }
}
function recurSelectWeekdays(id) {
  const chkBoxCollection = document.getElementById(id).getElementsByTagName('input');
  if (chkBoxCollection) {
    if (typeof chkBoxCollection.length != 'undefined') {
      for (i = 0; i < chkBoxCollection.length; i++) {
        if (chkBoxCollection[i].value === 'SU' || chkBoxCollection[i].value === 'SA') {
           chkBoxCollection[i].checked = false;
        } else {
          chkBoxCollection[i].checked = true;
        }
      }
    }
  }
}
function selectRecurCountUntil(id) {
  document.getElementById(id).checked = true;
}
// Assemble the recurrence rules if recurrence is specified.
// Request params to set ('freq' is always set):
// interval, count, until (count OR until, not both)
// possibly: byday, bymonthday, bymonth, byyearday
function setRecurrence(formObj) {
  if (formObj.recurrenceFlag.checked) {
    var freq = getSelectedRadioButtonVal(formObj.freq);
    if (freq !== 'NONE') {
      // build up recurrence rules
      switch (freq) {
        case "DAILY":
          var bymonth = [];
          // get the bymonth values
          bymonth = collectRecurChkBoxVals(bymonth,document.getElementById('dayMonthCheckBoxList').getElementsByTagName('input'),false);
          // set the form values
          formObj.bymonth.value = bymonth.join(',');
          formObj.interval.value = formObj.dailyInterval.value;
          break;
        case "WEEKLY":
          var byday = [];
          byday = collectRecurChkBoxVals(byday, document.getElementById('weekRecurFields').getElementsByTagName('input'),false);
          formObj.byday.value = byday.join(',');
          if (formObj.weekWkst.selectedIndex !== -1) {
            formObj.wkst.value = formObj.weekWkst[formObj.weekWkst.selectedIndex].value;
          }
          formObj.interval.value = formObj.weeklyInterval.value;
          break;
        case "MONTHLY":
          var i = 1;
          var monthByDayId = 'monthRecurFields' + i;
          var byday = new Array();
          var bymonthday = new Array();
          var byyearday = new Array();
          // get the byday values
          while (document.getElementById(monthByDayId)) {
            var monthFields = document.getElementById(monthByDayId);
            var dayPosSelect = monthFields.getElementsByTagName('select');
            var dayPos = dayPosSelect[0][dayPosSelect[0].selectedIndex].value;
            if (dayPos) {
              byday = collectRecurChkBoxVals(byday,monthFields.getElementsByTagName('input'),dayPos);
            }
            monthByDayId = monthByDayId.substring(0,monthByDayId.length-1) + ++i;
          }
          // get the bymonthday values
          bymonthday = collectRecurChkBoxVals(bymonthday,document.getElementById('monthDaysCheckBoxList').getElementsByTagName('input'),false);
          // set the form values
          formObj.byday.value = byday.join(',');
          formObj.bymonthday.value = bymonthday.join(',');
          formObj.interval.value = formObj.monthlyInterval.value;
          break;
        case "YEARLY":
          var i = 1;
          var yearByDayId = 'yearRecurFields' + i;
          var byday = [];
          var bymonthday = [];
          var bymonth = [];
          var byweekno = [];
          var byyearday = [];
          // get the byday values
          while (document.getElementById(yearByDayId)) {
            var yearFields = document.getElementById(yearByDayId);
            var dayPosSelect = yearFields.getElementsByTagName('select');
            var dayPos = dayPosSelect[0][dayPosSelect[0].selectedIndex].value;
            if (dayPos) {
              byday = collectRecurChkBoxVals(byday,yearFields.getElementsByTagName('input'),dayPos);
            }
            yearByDayId = yearByDayId.substring(0,yearByDayId.length-1) + ++i;
          }
          // get the bymonth values
          bymonth = collectRecurChkBoxVals(bymonth,document.getElementById('yearMonthCheckBoxList').getElementsByTagName('input'),false);
          // get the bymonthday values
          bymonthday = collectRecurChkBoxVals(bymonthday,document.getElementById('yearMonthDaysCheckBoxList').getElementsByTagName('input'),false);
          // get the byweekno values
          byweekno = collectRecurChkBoxVals(byweekno,document.getElementById('yearWeeksCheckBoxList').getElementsByTagName('input'),false);
          // get the byyearday values
          byyearday = collectRecurChkBoxVals(byyearday,document.getElementById('yearDaysCheckBoxList').getElementsByTagName('input'),false);

          // set the form values
          formObj.byday.value = byday.join(',');
          formObj.bymonth.value = bymonth.join(',');
          formObj.bymonthday.value = bymonthday.join(',');
          formObj.byweekno.value = byweekno.join(',');
          formObj.byyearday.value = byyearday.join(',');
          if (formObj.yearWkst.selectedIndex !== -1) {
            formObj.wkst.value = formObj.yearWkst[formObj.yearWkst.selectedIndex].value;
          }
          formObj.interval.value = formObj.yearlyInterval.value;
          break;
      }
      // build up count or until values
      var recur = getSelectedRadioButtonVal(formObj.recurCountUntil);
      switch (recur) {
        case "forever":
          // do nothing
          break;
        case "count":
          formObj.count.value = formObj.countHolder.value;
          break;
        case "until":
          // pad the month and day with zeros if only a single digit
          var paddedMonth = (formObj.untilMonth.value < 10) ? '0'+formObj.untilMonth.value : formObj.untilMonth.value;
          var paddedDay = (formObj.untilDay.value < 10) ? '0'+formObj.untilDay.value : formObj.untilDay.value;
          formObj.until.value = formObj.untilYear.value + paddedMonth + paddedDay;
          break;
      }
    }
  }
  if (bwJsDebug) {
    console.log("frequency: " + freq + "\ninterval: " + formObj.interval.value + "\ncount: " + formObj.count.value + "\nuntil: " + formObj.until.value + "\nbyday: " + formObj.byday.value + "\nbymonthday: " + formObj.bymonthday.value + "\nbymonth: " + formObj.bymonth.value + "\nbyyearday: " + formObj.byyearday.value + "\nwkst: " + formObj.wkst.value);
  }
  return true;
}

// launch a size parameterized window for displaying information; no header or status bar
function launchSizedWindow(URL,width,height) {
  paramStr = "width=" + width + ",height=" + height + ",scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no";
  sizedWindow = window.open(URL, "sizedWindow", paramStr);
  window.sizedWindow.focus();
}

function startDateCalWidgetCallback(date, month, year) {
  today = new Date();
  if (year < today.getFullYear()) {
    alert("You may not use this widget to \n create an event in a previous year.");
  } else {
    document.peForm['eventStartDate.month'].value = month;
    document.peForm['eventStartDate.day'].value = date;
    document.peForm['eventStartDate.year'].value = year;
  }
}
function endDateCalWidgetCallback(date, month, year) {
  today = new Date();
  if (year < today.getFullYear()) {
    alert("You may not use this widget to \n create an event in a previous year.");
  } else {
    document.peForm['eventEndDate.month'].value = month;
    document.peForm['eventEndDate.day'].value = date;
    document.peForm['eventEndDate.year'].value = year;
  }
}
function untilDateCalWidgetCallback(date, month, year) {
  if (year < today.getFullYear()) {
    alert("You may not use this widget to \n create an event in a previous year.");
  } else {
    document.peForm['untilMonth'].value = month;
    document.peForm['untilDay'].value = date;
    document.peForm['untilYear'].value = year;
    selectRecurCountUntil('recurUntil');
  }
}
