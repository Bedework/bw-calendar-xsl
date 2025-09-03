# Release Notes

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Virtually every release involves updating any dependencies.

Only major change summaries are shown below. Read the git log for details.

## Unreleased (5.1.0-SNAPSHOT)

## [5.0.1] - 2025-08-08
* Reinstate old spinner and move bootstrap to common

## [5.0.0] - 2025-08-04

### Changed
- Fixed paths to some images
- Show current location and contact in search box 
- Moved javascript, images and css to bedework-content and upgrade to jquery 3

### Removed
- magnific 
 
## [4.1.3] - 2025-02-06

### Changed
- Add an "attachments" tab to event add/update 
- Use eventreg web service for forms list. Restructure web service 

## [4.1.2] - 2024-12-07

### Changed
- Changes to help in tests - mainly add ids to elements 
- Add an id to the registration iframe 

## [4.1.1] - 2024-11-30

### Changed
- Mistyped id name for contacts 
- VPOLL: Don't sort the choices. Other code (highlighting best etc) use the order in the poll. To sort, we need to use poll item id as key everywhere.
- Fix issue with autocomplete of contacts. Added an id to the outer div to match locations. 
- Moved currentTab into globals. Moved ref out of all jsp files and into header.jsp 
- Added a refresh operation to the synch engine

## [4.1.0] - 2024-04-01

### Added
- Add guid and recurrenceId as hidden fields in the event form. Will allow checking that we still have the same event.

### Changed
- Add information to the view data so that we can sort on the displayed field rather than the path. 
- Remove limits on display of pending events. Previously anything in the past wasn't visible.
- Fix up the showing of current tab to refresh the search result each time. May result in some inefficiencies but it now shows changes as they are made. 
- Add a primaryCollection flag to allow us to locate the actual main calendar collection. 

### Removed
- Sharethis: there are many privacy issues associated with this.
- The ability to select the calendar path in the admin client. There is never any need to do this and it caused many problems over time.

## [4.0.0] - 2022-02-12

### Changed
- Restructure XSL into individual wars. Allows feature pack to use artifacts. 
- Remove duplicate inclusions - they are in globals.xsl
- Fix invalid XSL which was allowed through by older implementations.

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
