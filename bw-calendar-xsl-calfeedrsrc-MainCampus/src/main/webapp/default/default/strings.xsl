<?xml version="1.0" encoding="UTF-8"?>
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

  <!-- xsl:template match="/" -->
  <xsl:variable name="bwStr-Root-PageTitle">Bedework Events Calendar</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">generate link to this event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">link to this event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELED:</xsl:variable>
  <!--Link, add master event reference to a calendar, add this event reference to a calendar, add event reference to a calendar -->
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Download</xsl:variable>
  <!--public, private -->
  <xsl:variable name="bwStr-SgEv-When">When:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(all day)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Floating time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Local time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">End:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">add to my calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Add event to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Where:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Cost:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">See:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contact:</xsl:variable>
  <!--Recipients:, recipient -->
  <xsl:variable name="bwStr-SgEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comments:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Topical Area:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">today</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Add event to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">description</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contact:</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">TENTATIVE:</xsl:variable>

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(cont)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">all day:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Time:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Topical Area:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Export Calendars as iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Calendar to export:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Path:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Event date limits:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">all dates</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">date range</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>End:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">export</xsl:variable>

</xsl:stylesheet>
