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

/* NOTE: this file is different between Bedework web applications and is
   therefore not currently interchangable between apps.  This will be normalized
   in the coming versions, but for now don't try to exchange them. */

/* Global variables / properties */
// URLs
const timezoneUrl = "/tzsvr/?names";
const carddavUrl = "/ucarddav/find";

/* javascript debugging switch for Bedework Admin Client.  When true,
 debugging statements will be placed in console.log. If no console is
 available, force debugging off so we don't do any debug processing at all. */
let bwJsDebug = true;
if (!window.console) {
  bwJsDebug = false;
}

/* COMMON and GENERAL FUNCTIONS */

function changeClass(id, newClass) {
  const identity = document.getElementById(id);
  if (identity == null) {
    alert("No element with id: " + id + " to set to class: " + newClass);
  }
  identity.className=newClass;
}
// set a field's value by ID
// typically used to set the value of a hidden field
function setField(id,val) {
  document.getElementById(id).value = val;
}

// show hide items using a checkbox
function swapVisible(obj,id) {
  if (obj.checked) {
    changeClass(id,'visible');
  } else {
    changeClass(id,'invisible');
  }
}
// hide a group of items
// send IDs as parameters
function hide() {
  if (arguments.length !== 0) {
    for (let i = 0; i < arguments.length; i++) {
      changeClass(arguments[i],'invisible');
    }
  }
}
// show a group of items
// send IDs as parameters
function show() {
  if (arguments.length !== 0) {
    for (let i = 0; i < arguments.length; i++) {
      changeClass(arguments[i],'visible');
    }
  }
}
// show and hide an item based on its current
// visibility; if visible, hide it; if invisible
// show it.
function toggleVisibility(id,newClass) {
  if (document.getElementById(id).className === 'invisible') {
    if (newClass !== "") {
      changeClass(id,newClass);
    } else {
      changeClass(id,'visible');
    }
  } else {
    changeClass(id,'invisible');
  }
}
function setTab(listId,listIndex) {
  const list = document.getElementById(listId);
  const elementArray = [];
  for (let i = 0; i < list.childNodes.length; i++) {
    if (list.childNodes[i].nodeName === "LI") {
      elementArray.push(list.childNodes[i]);
    }
  }
  for (let i = 0; i < elementArray.length; i++) {
    if (i === listIndex) {
      elementArray[i].className = 'selected';
    } else {
      elementArray[i].className = '';
    }
  }
}
function getSelectedRadioButtonVal(radioCollection) {
  for (let i = 0; i < radioCollection.length; i++) {
    if (radioCollection[i].checked) {
       return radioCollection[i].value;
    }
  }
}
// returns an array of collected checkbox values
function collectRecurChkBoxVals(valArray,chkBoxes,dayPos) {
  if (chkBoxes) {
    if (typeof chkBoxes.length != 'undefined') {
      for (let i = 0; i < chkBoxes.length; i++) {
        if (chkBoxes[i].checked === true) {
          if (dayPos) {
            valArray.push(dayPos + chkBoxes[i].value);
          } else {
            valArray.push(chkBoxes[i].value);
          }
        }
      }
    }
  }
  return valArray;
}

// launch a simple window for displaying information; no header or status bar
function launchSimpleWindow(URL) {
  let simpleWindow = window.open(URL, "simpleWindow", "width=800,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  simpleWindow.focus();
}

// launch a size parameterized window for displaying information; no header or status bar
function launchSizedWindow(URL,width,height) {
  let paramStr = "width=" + width + ",height=" + height + ",scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=yes,toolbar=yes";
  let sizedWindow = window.open(URL, "sizedWindow", paramStr);
  sizedWindow.focus();
}

// launches new browser window with print-friendly version of page when
// print icon is clicked
function launchPrintWindow(URL) {
  let printWindow = window.open(URL, "printWindow", "width=640,height=500,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=yes,toolbar=yes");
  printWindow.focus();
}
// launch the calSelect pop-up window for selecting a calendar when creating,
// editing, and importing events
function launchCalSelectWindow(URL) {
  let calSelect = window.open(URL, "calSelect", "width=500,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  calSelect.focus();
}
// used to update the calendar in various forms from
// the calSelect pop-up window.  We must do two things: update the hidden calendar
// input field and update the displayed text.
function updateEventFormCalendar(newCalPath,calDisplay) {
  if (window.opener.document.eventForm) {
    window.opener.document.eventForm.newCalPath.value = newCalPath;
    bwCalDisplay = window.opener.document.getElementById("bwEventCalDisplay");
    bwCalDisplay.innerHTML = calDisplay;
  } else {
    alert("The event form is not available.");
  }
  window.close();
}
// used to update a calendar subscription (alias) We must do two things: update the hidden
// calendar input field and update the displayed text
function updatePublicCalendarAlias(newCalPath,calDisplay,calendarCollection) {
  const calendarAliasHolder = document.getElementById("publicAliasHolder");
  const bwCalDisplay = document.getElementById("bwPublicCalDisplay");
  calendarAliasHolder.value = newCalPath;
  bwCalDisplay.innerHTML = '<strong>' + calDisplay + '</strong> <button type="button" onclick="showPublicCalAliasTree();">change</button>';
  changeClass("publicSubscriptionTree","invisible");
}
function showPublicCalAliasTree() {
  changeClass("publicSubscriptionTree","calendarTree");
}
// set the subscription URI when creating or updating a subscription
function setCalendarAlias(formObj) {
  if (!formObj) {
    alert("The subscription form is not available.");
    return false;
  }

  // check first to make sure we have a valid calendar system name:
  if (validateCalName(formObj['calendar.name'])) {

    // set the aliasUri to an empty string.  Only set it if user
    // has requested a subscription.
    formObj.aliasUri.value = "";

    if (formObj.type.value === "folder") {
      formObj.calendarCollection.value = "false";
    } else if (formObj.type.value === "subscription") {
      switch (formObj.subType.value) {
        case "publicTree":
          // do nothing: when adding a subscription to the public tree, we set the fields directly.
          break;
        case "public":
          formObj.aliasUri.value = "bwcal://" + formObj.publicAliasHolder.value;
          break;
        case "user":
          //the "/user/" string is temporary; it needs to be passed as a param.
          formObj.aliasUri.value = "bwcal:///user/" + formObj.userIdHolder.value + "/" + formObj.userCalHolder.value;
          break;
        case "external":
          formObj.aliasUri.value = formObj.aliasUriHolder.value;
          break;
      }
    }
    return true;
  } else {
    return false;
  }
}
function exportCalendar(formId,name,calPath) {
  const formObj = document.getElementById(formId);
  formObj.calPath.value = calPath;
  formObj.contentName.value = name + '.ics';
  formObj.submit();
}

// checkboxes for all categories and preferred categories are on the page
// simultaneously.  The use can toggle between which is shown and which is
// hidden.  When a checkbox from one collection is changed, the corresponding
// checkbox should be changed in the other set if it exists.
function setCatChBx(thiscat,othercat) {
  let thisCatCheckBox = document.getElementById(thiscat);
  let otherCatCheckBox;
  if (document.getElementById(othercat)) {
    otherCatCheckBox = document.getElementById(othercat);
    otherCatCheckBox.checked = thisCatCheckBox.checked;
  }
}
function checkPrefCategories(formObj){
  let hasACat = false;

  if (typeof formObj.defaultCategory.length != 'undefined') {
    for (let i = 0; i < formObj.defaultCategory.length; i++) {
      if (formObj.defaultCategory[i].checked) {
        hasACat = true;
        break;
      }
    }
  }
  if (!hasACat) {
    // no category is checked;
    // create an empty catUid element to alert the backend
    // so we can clear the cats
    const hiddenCat = document.createElement("div");
    hiddenCat.innerHTML = '<input type="hidden" name="defaultCategory" value=""/>';
    formObj.appendChild(hiddenCat);
  }
}
// Stop user from entering invalid characters in calendar names
// As of 3.6 this will only test for & ' " and /
// In future releases, we will go further and only allow
// alphanumerics and dashes and underscores.
function validateCalName(nameObj) {
  const nmVal = nameObj.value;
  if (nmVal.indexOf("'") === -1 &&
    nmVal.indexOf('"') === -1 &&
    nmVal.indexOf("&") === -1 &&
    nmVal.indexOf("/") === -1) {
    return true;
  }

  // we have bad characters
  let badChars = "";
  if (nmVal.indexOf("'") !== -1) {
    badChars += " ' ";
  }
  if (nmVal.indexOf('"') !== -1) {
    badChars += ' \" ';
  }
  if (nmVal.indexOf("&") !== -1) {
    badChars += " & ";
  }
  if (nmVal.indexOf("/") !== -1) {
    badChars += " / ";
  }
  alert("System Names may not include the following characters: " + badChars);
  nameObj.focus();
  return false;
}
// set category filters on calendar collections
function setCatFilters(formObj) {
  if (typeof formObj.filterCatUid.length != 'undefined') {
    let filterExpression = "catuid=(";
    let filterExists = false;
    for (let i = 0; i < formObj.filterCatUid.length; i++) {
      if (formObj.filterCatUid[i].checked) {
        filterExists = true;
        filterExpression += "'" + formObj.filterCatUid[i].value + "',";
      }
    }
    if (filterExists) {
      // remove the last comma and close off the expression
      filterExpression = filterExpression.substring(0,filterExpression.length-1) + ")";
      // set the form value
      formObj.fexpr.value = filterExpression;
    }
  }
}
// set the calendar summary to the calendar name in the form if summary is empty
function setCalSummary(val,summaryField) {
  if (summaryField.value === '') {
    summaryField.value = val;
  }
}
function setSuggestListDate(formObj,dateString) {
  $("#appvar").val("curListDate(" + dateString + ")");
  formObj.fexpr.value = '(colPath="' + formObj.colPath.value + '" and (entity_type="event" or entity_type="todo") and suggested-to="' + formObj.suggestedListType.value + ':' + formObj.suggestedTo.value + '")';
  formObj.submit();
}
function setSuggestListDateToday(dateString,formObj) {
  // note that the today button is a submit, so no need to submit it via JS
  $("#bwListWidgetStartDate").val(dateString);
  $("#appvar").val("curListDate(" + dateString + ")");
  formObj.fexpr.value = '(colPath="' + formObj.colPath.value + '" and (entity_type="event" or entity_type="todo") and suggested-to="' + formObj.suggestedListType.value + ':' + formObj.suggestedTo.value + '")';
}
// Change the event list widgets (for the main modify events listing)
function setEventList(formObj, changed, value) {
  let fa=formObj.appvar;
  let doSubmit = true;
  let catFilter = "";
  let groupFilter = "";
  if (formObj.catFilter.value !== "") {
    catFilter = "categories.href=\"" + formObj.catFilter.value + "\" and ";
  }
  if (formObj.groupFilter.value !== "") {
    groupFilter = "creator=\"" + formObj.groupFilter.value + "\" and ";
    formObj.ignoreCreator.value = "true";
  }
  formObj.fexpr.value = '(' + catFilter + groupFilter + 'colPath="' + formObj.colPath.value + '" and (entity_type="event" or entity_type="todo"))';
  switch (changed) {
    case "allGroups":
      let val;
      if (formObj.sg.checked) {
        val = "**allGroups**";
      } else {
        val = "";
      }

      fa.value = "groupFilter(" + val + ")";
      break;
    case "calPath":
      fa.value = "calendarPath(" + formObj.colPath.value + ")";
      break;
    case "cat":
      fa.value = "catFilter(" + formObj.catFilter.value + ")";
      break;
    case "date":
      fa.value = "curListDate(" + value + ")";
      //doSubmit = false;// today button is a submit
      break
    case "group":
      fa.value = "groupFilter(" + formObj.groupFilter.value + ")";
      break;
    case "query":
      fa.value = "query(" + formObj.query.value + ")";
      break;
    case "sort":
      fa.value = "sort(" + formObj.sort.value + ")";
      break;
    case "today":
      $("#bwListWidgetStartDate").val(value);
      fa.value = "curListDate(" + value + ")";
      doSubmit = false;// today button is a submit
      break
  }
  if (doSubmit) {
    formObj.submit();
  }
}
function setGroupFilter(formObj, value) {
  let element = formObj.groupFilter;
  element.value = value;
  element.dispatchEvent(new Event('change'))
}
function setCatFilter(formObj, value) {
  let element = formObj.catFilter;
  element.value = value;
  element.dispatchEvent(new Event('change'))
}
// Clear the group filter
function clearGroup(formObj) {
  formObj.groupFilter.value = null;
  setEventList(formObj, 'group');
}
// Clear the category filter
function clearCat(formObj) {
  formObj.catFilter.value = null;
  setEventList(formObj, 'cat');
}
// Stand-alone sort for pending queue
function setListSort(formObj,sortVal) {
  formObj.fexpr.value = '(colPath="' + formObj.colPath.value + '" and (entity_type="event" or entity_type="todo"))';
  formObj.appvar.value = "sort(" + sortVal + ")";
  formObj.submit();
}
// Set
function setSuggestListType(formObj,suggestType) {
  $("#appvar").val("suggestType(" + suggestType + ")");
  formObj.fexpr.value = '(colPath="' + formObj.colPath.value + '" and (entity_type="event" or entity_type="todo") and suggested-to="' + suggestType + ':' + formObj.suggestedTo.value + '")';
  formObj.submit();
}