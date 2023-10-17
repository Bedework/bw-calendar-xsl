<!--
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
-->
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- Most text exposed by the stylesheets is set here. -->
  <!-- To change the language of a web client, translate the strings file. -->

  <xsl:variable name="bwStr-Root-PageTitle">Bedework Veranstaltungskalender</xsl:variable>
  <xsl:variable name="bwStr-Error">Fehler:</xsl:variable>
  <xsl:variable name="bwStr-Error-NoPage">Keine Seite anzeigbar</xsl:variable>
  <xsl:variable name="bwStr-Error-PageNotDefined">Seite "<xsl:value-of select="/bedework/appvar[key='page']/value"/>" is not defined.</xsl:variable>
  <xsl:variable name="bwStr-Error-IframeUnsupported">Ihr Browser unterst&#252;tzt keine iframes.</xsl:variable>
  <xsl:variable name="bwStr-Error-NoScript">Ihr Browser unterst&#252;tzt keine JavaScript!</xsl:variable>

  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-SiteTitle">Bedework &#214;ffentlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Startseite Universit&#228;t</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Andere Verkn&#252;pfungen</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExportSubscribe">Export/Abonnieren</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">Veranstaltung Information</xsl:variable>
  <xsl:variable name="bwStr-HdBr-BackLink">(zur&#252;ck zur Veranstaltung)</xsl:variable>

  <!-- ongoing events -->
  <xsl:variable name="bwStr-Ongoing-Title">Aktuell</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-NoEvents">Keine laufenden Veranstaltungen in diesem Zeitraum oder dieser Ansicht</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-Ends">Ende</xsl:variable>

  <!-- deadlines -->
  <xsl:variable name="bwStr-Deadline-Title">Deadlines</xsl:variable>
  <xsl:variable name="bwStr-Deadline-NoEvents">Keine Fristen in diesem Zeitraum oder dieser Ansicht</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">angemeldet als</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">abmelden</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Today">HEUTE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">AKTUELLE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">TAG</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">WOCHE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MONAT</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">JAHR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Search">suchen</xsl:variable>
  <xsl:variable name="bwStr-Tabs-AdvSearch">erweitere</xsl:variable>
  <xsl:variable name="bwStr-Tabs-JumpToDate">Jump To Date</xsl:variable>

  <!--  xsl:template name="datePicker" -->
  <xsl:variable name="bwStr-DatePicker-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Upcoming">Aktuelle</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Range">Zeitraum</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Day">Tag</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Week">Woche</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Month">Monat</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-StartDate">Anfang-Datum:</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Menu">Menü</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Woche ab</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-Add">hinzuf&#252;gen...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ApplyFilter">Filter anwenden</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTE</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">KALENDER</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">KURZFASSUNG</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETAILS</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Summary">Kurzfassung</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Details">Details</xsl:variable>

  <!--  xsl:template name="leftColumnText" -->
  <xsl:variable name="bwStr-LCol-DownloadCalendars">Herunterladen Kalender</xsl:variable>
  <xsl:variable name="bwStr-LCol-Options">OPTIONEN:</xsl:variable>
  <xsl:variable name="bwStr-LCol-ManageEvents">Veranstaltung verwalten</xsl:variable>
  <xsl:variable name="bwStr-LCol-Submit">Veranstaltung einreichen</xsl:variable>
  <xsl:variable name="bwStr-LCol-Help">Hilfe</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-Canceled">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EventLink">Verweis zur Veranstaltung:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">Wann:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(ganzt&#228;gig)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">jeweilige Zeitzone</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Ortszeit</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Ende:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DueBy">Eintrag von</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">Zu meinem Kalender hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Eintragen in Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToFacebook">Eintragen in Facebook</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToGoogleCalendar">Eintragen in Google Calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Wo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Location-Accessible">This venue is wheelchair accessible</xsl:variable> <!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Location-Map">map</xsl:variable><!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Kosten:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">Einsehen:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-VirtualReg">Virtual Registration Link:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Kommentar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Themengebiet:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendars">Kalender:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">Keine Veranstaltung gefunden. Bitte versuchen sie einen anderen Zeitraum oder eine andere Ansicht.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplayWithOngoing">Keine laufenden Veranstaltung gefunden. Bitte versuchen sie einen anderen Zeitraum oder eine andere Ansicht oder schauen sie in die Liste der laufenden Veranstaltungen.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsFromSelection">Ihre Auswahl liefert keine Ergebnisse.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">hinzuf&#252;gen...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">Ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-LsVw-At">am</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Eintragen in Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Herunterladen als ical</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForCal">Darstellung der Veranstaltung im Kalender</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForView">Darstellung der Veranstaltung in der Ansicht</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ShowAll">(alles anzeigen)</xsl:variable>
  <xsl:variable name="bwStr-LsVw-TopicalArea">Themengebiete:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Cost">Kosten:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Link">Verkn&#252;pfung:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ListWithinTimeRange">Liste von Ereignissen innerhalb einer Zeitreihe</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Events">Veranstaltungen</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">N&#228;chsten 7 Tage</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">Keine Veranstaltung darstellbar.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ContinueFrom">Continue from </xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-ShowMore">Show more events</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ReturnToToday">Return to Today</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-Calendars">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearFilters">(Alle löschen)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Search">Suchen:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Filter">Filter:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearSearch">(löschen)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Herunterladen als ical</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">ENTWURF:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-EventList">Veranstaltungsliste</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Upcoming">Aktuelle Veranstaltungen</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Starting">Beginnend</xsl:variable>

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">ENTWURF:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(andauernd)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">ganzt&#228;gig:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Zeit:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Themengebiete:</xsl:variable>

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-DownloadCalendars">Herunterladen Kalender</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectCalendar">Wählen Sie einen Kalender zum Herunterladen als ical.</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Kalender ausgeben als iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Ausgeben:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">ab Heute</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">jeden Tag</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">zeitraum</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Ende:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">ausgeben</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Suchen:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">weiter</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">ab Heute</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">vorherige Tage</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">jeden Tag</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResults">Suchergebnis</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoQuery">keine Abfrage</xsl:variable>
  <xsl:variable name="bwStr-Srch-Result">Ergebnis</xsl:variable>
  <xsl:variable name="bwStr-Srch-Results">Ergebnisse</xsl:variable>
  <xsl:variable name="bwStr-Srch-ReturnedFor">R&#252;ckgabe:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Rank">Rang</xsl:variable>
  <xsl:variable name="bwStr-Srch-Date">Datum</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Kurzfassung</xsl:variable>
  <xsl:variable name="bwStr-Srch-Pages">Seite:</xsl:variable>
  <xsl:variable name="bwStr-Srch-AdvancedSearch">Erweiterte Suche</xsl:variable>
  <xsl:variable name="bwStr-Srch-CatsToSearch">Kategorien ausw&#228;hlen f&#252;r die Suche (Optional)</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchTermNotice">Ein Suchbegriff ist nicht erfordertlich wenn eine Kategorie ausgew#228;hlt wurde.</xsl:variable>

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">System Statistiken</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Sammlung der Statistiken:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">einschalten</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">ausschalten</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">Statistiken sammeln></xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">Statistiken wegschreiben</xsl:variable>

  <!--  xsl:template name="exportSubscribe" -->
  <xsl:variable name="bwStr-exSu-ExportSubscribe">Export / Subscribe</xsl:variable>
  <xsl:variable name="bwStr-exSu-CurrentFiltersColon">Current Filters:</xsl:variable>
  <xsl:variable name="bwStr-exSu-FeedOrWidget">Event feed or embeddable widget?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Feed">Feed</xsl:variable>
  <xsl:variable name="bwStr-exSu-Widget">Widget (code to copy and paste onto a website)</xsl:variable>
  <xsl:variable name="bwStr-exSu-DataFormat">Data format?</xsl:variable>
  <xsl:variable name="bwStr-exSu-HTMLList">HTML list (copy &amp; paste into Word, etc.)</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCount">Event count</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCountTotal">Total number of events returned:</xsl:variable>
  <xsl:variable name="bwStr-exSu-IncludeDownloadLink">Include download link?</xsl:variable>
  <xsl:variable name="bwStr-exSu-True">True</xsl:variable>
  <xsl:variable name="bwStr-exSu-False">False</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDetailsOrSummary">Show details or summary?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Details">Details</xsl:variable>
  <xsl:variable name="bwStr-exSu-Summary">Summary</xsl:variable>
  <xsl:variable name="bwStr-exSu-Timeframe">Time frame</xsl:variable>
  <xsl:variable name="bwStr-exSu-UseDefaultListing">Use the default listing, limit the number of days (from the current date), or provide a start date and an end date.</xsl:variable>
  <xsl:variable name="bwStr-exSu-Default">Default: </xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitTo">Limit to</xsl:variable>
  <xsl:variable name="bwStr-exSu-DaysFromToday">days from "today"</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeColon">Date Range:</xsl:variable>
  <xsl:variable name="bwStr-exSu-StartDateColon">Start Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-EndDateColon">End Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeNote">Note: Event count takes precedence over date range!</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetOptions">Widget Options</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitEvents">Limit the number of events listed?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultFalse">(default: false)</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitToColon">Limit to:</xsl:variable>
  <xsl:variable name="bwStr-exSu-Events">events</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowTitle">Show a title above event list?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultTrue">(default: true)</xsl:variable>
  <xsl:variable name="bwStr-exSu-TitleColon">Title:</xsl:variable>
  <xsl:variable name="bwStr-exSu-UpcomingEvents">Upcoming Events</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultUpcomingEvents">(default: "Upcoming Events")</xsl:variable>
  <xsl:variable name="bwStr-exSu-HighlightDatesOrTitles">Highlight event dates or event titles?</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByTitle">By title</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByDate">By date</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultByTitle">(default 'by title')</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDescription">Show description in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayEndDate">Display end date in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTime">Display time in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayLocation">Display location in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayDetailsInline">Display event details inline?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayContact">Display contact in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayCost">>Display cost in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTags">Display tags in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTimezone">Display timezone in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-URL">Your URL:</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetCode">Widget Code:</xsl:variable>

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basierend auf</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Bedework im Einsatz</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Anzeigen XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">Aktualisieren XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-Credits">Dieses Thema basiert auf der Duke and Yale Universities mit besonderem Dank an die University of Chicago</xsl:variable>

</xsl:stylesheet>
