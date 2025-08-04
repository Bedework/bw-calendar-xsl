# Release Notes

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased (5.1.0-SNAPSHOT)

## [5.0.0] - 2025-08-04
* Mostly related to relocation of javascript and upgrade to jquery 3
* A number of changes related to upgrading to jquery 3.x. 
* Remove magnific from user calendar 
* Remove magnific from admin and public web clients 
* Fix submissions root variable 
* Encode URL to make it legal 
* Fix image handling 
* Fix path to some images 
* Encode '=' in urls 
* Add id to logout link 
* Update web.xml for jakarta 
* Remove extra "/". Add msg to alert 
* Add url for eventreg ws to jsp. 
* Fix bad xsl after image changes 
* Show current location and contact in search box 
* Move most images into bedework-content in images directory. 
* Move common javascript and css into bedework-content out of xsl-common. Update to latest of ones we had. Need to upgrade jquery. 

## [4.1.3] - 2025-02-06
* Remove all unnecessary refs to CalFacadeException. Move error codes out of CalFacadeException into CalFacadeErrorCode. 
* Preparing for jakarta... Update parent to latest snapshot for all modules. Work to update hibernate second level cache to ehcache 3 + jcache. 
    * Update configs 
    * Update to new ehcache.xml 
    * Update deployed hibernate module 
* Add an attachments tab to event add/update 
* New urls. 
* Add url for new event reg web service to configs. Use it in client to post notifications. 
* Use eventreg web service for forms list. Restructure web service 

## [4.1.2] - 2024-12-07
* Changes for updated deployment 
* Changes to help in tests - mainly add ids to elements 
* Add an id to the registration iframe 
* This was breaking the form on update. Not sure what the intent was. 

## [4.1.1] - 2024-11-30
* Update parent version 
* make debugging easier 
* Need to update dtstamp on save 
* Much tidying up and bug fixes. 
* Mistyped id name 
* Don't sort the choices. Other code (highlighting best etc) use the order in the poll. To sort we need to use poll item id as key everywhere.
* Use getParticpantAddrs for BwCalDAVEvent.getAttendeeUris 
* Wrong field type 
* Mostly fixes to the new code. Replies not getting through for a number of reasons. Rename some methods. Try to clarify handling of xproperties 
* Changes related to using participants. At least puts up the display. 
  expression testing wrong variable. Submitted aliases weren't recognized 
* Site logo overlaps logout button. Move up a little 
* Add prefix "/user" to match admin client 
* Add id to logout button/link 
* Remove blank line 
* Same typo in js as for admin client 
* Rename tab "users and Groups" 
* Use variable to check for approver/super user etc. 
* Need ignoreCreator for approval queue 
* Fix issue with autocomplete of contacts. Added an id to the outer div to match locations. Made a few changes after prompting by intellij. 
* Moved currentTab into globals. Moved ref out of all jsp files and into header.jsp 
* Remove old commented out code 
* Added a refresh operation to the synch engine and added associated code to the client side. 
* Missing display checkbox when creating 
* Fix up javascript for move from vvoter. 

## [4.1.0] - 2024-04-01
* Add error message 
* Update parent version 
* Add missing string value to German 
* Wrong header for exdates 
* Align German and Spanish strings with default 
* Add information to the view data so that we can sort on the displayed field rather than the path. 
* Fix handling of pending submissions- add button to allow accepting 
* Fix list-html for new xsl parser 
* Fix the display of map icon 
* Remove limits on display of pending events. 
* Rename theme directory to something generic 
* Not toggling the filter visibility 
* Make it full width 
* Fix approval/publish action and xsl. Only approvers are valid. 
* Field is called "alt" 
* Don't display start date for fetch more events 
* Remove sharethis 
* Use "button" rather than "a" for filter and view navigation. 
* Suppress "Approve" button for non-approvers 
* Same message for all recurring events 
* Add event button on approval q for non-approvers 
* Fix up the showing of current tab to refresh the search result each time. May result in some inefficiencies but it now shows changes as they are made. 
* Added page to handle approve/delete. Mostly working. 
* Move "Edit master" to a button in a right hand column 
* Remove last of tab specific stuff. 
* Redo tab management for admin client. Add a currentTab form variable and output that in the jsp <tab> element. 
* Use a variable for the event title 
* Add methods to client to allow determination of approver status and return the current authorised user. Change validation - reversed sense of check. 
* Fix setting of calendar path in InitAddEventAction 
* Make the first step to simplifying the setting of calendar collections when adding/updating events. 
* Add a primaryCollection flag to allow us to locate the actual main calendar collection. 
* Add a primaryCollection flag to allow us to locate the actual main calendar collection. 
* Add a comment 
* Use grid layout to produce a more compact topical areas display. 
* Try to make display of topical areas more robust. May need some tweaks to handle no top level collection aliases. 
* Fix xsl for saxon 
* Fix directory names 
* Saxon xsl compatibility 
* Should be xsl:value-of NOT xsl:variable 
* Deleted old PDA directory 
* Deleted old files 
* Intellij files were deleted 
* Upgrade to opensearch 2.1.0 
* iml files 
* recurrence info not being saved 
* cancel needs to be a submit to work 
* Add guid and recurrenceId as hidden fields in the event form. Will allow checking that we still have the same event. 
* Add guid and recurrenceId as hidden fields in the event form. Will allow checking that we still have the same event. 
* put the timezones stuff back but without the form for updating timezones
* Fix dependencies on parent to be consistent. 
* Add a missing space 
* Remove unused uploadtimezones 
* Add a duplicate resource message and output it in add resource. 
* Add code to suppress no duration/end and forever recurrences. 

## [4.0.0] - 2022-02-12
* Update to latest wildfly.
* All calendar client wars broken out so they can be deployed independently 
* Move all variable out of web app files. 
* Restructure XSL into individual wars. Allows feature pack to use artifacts. 
* Reduce parent version to simple number 
* Fixes to xsl 
* Use variable where possible.
* Fix base path 
* Further changes for ro calendar system. Now builds a wildfly instance and runs. 
* Now deploys - fails to start due to missing versions. 
* Reinstate scm section in poms 
* Use bedework-parent for builds. 
* Give superuser ability to search all calendar collections rather than just the main collection. 
* Add campusgroups support to synch engine. 
* Pass class loader as parameter when creating new objects. JMX interactions were failing. 
* Updated library versions. Moved wfmodules into bw-wfmodules 
* Add virtual reg link
* Moved the remainder into RW or admin.
* Remove some references to read-write actions.
* Remove duplicate inclusions - they are in globals.xsl
* Fix invalid XSL which was allowed through by older implementations.

## [3.13.2] - 2020-03-23
* Add single page submission client theme.
* Fix update/add locations in user client
* Add all the extra fields to the user client. Still need to fix styles
* Fix up location styles in user client
* Arlen updates for featured events.

## [3.13.1] - 2019-10-16
* Use combined values from location and implement NO-LINK for map urls.
* change | operator to "or"

## [3.13.0] - 2019-08-27
* Less noise in logs.

## [3.12.5] - 2019-06-27
* Use deployment base for base.

## [3.12.4] - 2019-04-15
* Update dependencies
* Missed file

## [3.12.3] - 2019-01-07
* Copy in location and contact search for admin client. Also location/contact changes for main client.

## [3.12.2] - 2018-11-28
* Fix jsonTz to use new form of expand.
* Prefix hrefs with /approot
 
## [3.12.1] - 2018-05-22
* First identifiable release.
