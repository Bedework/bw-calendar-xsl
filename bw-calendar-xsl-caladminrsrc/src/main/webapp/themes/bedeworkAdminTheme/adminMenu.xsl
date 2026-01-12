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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--==== BANNER and MENU TABS  ====-->

  <xsl:template name="adminMenu">
    <ul id="bwAdminMenu">
      <li>
        <xsl:if test="$isHomePage">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a id="homeLink">
          <xsl:attribute name="href"><xsl:value-of select="$showHomePage"/></xsl:attribute>
          <xsl:copy-of select="$bwStr-Head-HomePage"/>
        </a>
      </li><!--
               Add event -->
      <li>
        <xsl:if test="$isAddEventTab">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a id="addEventLink">
          <xsl:attribute name="href"><xsl:value-of select="$event-initAddEvent"/></xsl:attribute>
          <xsl:if test="not(/bedework/currentCalSuite/name)">
            <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="$bwStr-EvLs-AddEvent"/>
        </a>
      </li><!--
               Approval queue -->
      <xsl:if test="$workflowEnabled">
        <li>
          <xsl:if test="$isApprovalQueueTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$initApprovalQueueTab"/>&amp;listMode=true&amp;fexpr=(colPath="<xsl:value-of select="$workflowRootEncoded"/>")&amp;sort=dtstart.utc:asc</xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-ApprovalQueueEvents"/>
          </a>
        </li>
      </xsl:if><!--
               Manage events -->
      <li>
        <xsl:if test="$isEventsTab">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <xsl:variable name="creator">
          <xsl:choose>
            <xsl:when test="$isSuperUser"></xsl:when>
            <xsl:when test="/bedework/userInfo/oneGroup = 'true'">(creator="<xsl:value-of select="/bedework/userInfo/userRef"/>") and </xsl:when>
            <xsl:otherwise>(<xsl:for-each select="/bedework/userInfo/groups/group">(creator="<xsl:value-of select="ownerHref"/>")<xsl:if test="position() != last()"> or </xsl:if></xsl:for-each>) and </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a id="manageEventsLink">
        <xsl:attribute name="href"><xsl:value-of select="$initEventList"/>&amp;ignoreCreator=true&amp;listMode=true&amp;start=<xsl:value-of select="$curListDate"/>&amp;fexpr=(<xsl:value-of select="$creator"/>colPath="<xsl:value-of select="$calendarPath"/>" and (entity_type="event" or entity_type="todo"))&amp;sort=<xsl:value-of select="$sort"/>&amp;setappvar=catFilter()</xsl:attribute>
          <xsl:if test="not(/bedework/currentCalSuite/name)">
            <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="$bwStr-Head-ManageEvents"/>
        </a>
      </li><!--
               Suggestion queue -->
      <xsl:if test="$suggestionEnabled and $isApproverUser">
        <li>
          <xsl:if test="$isSuggestionQueueTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <xsl:variable name="suggestedListType">
            <xsl:choose>
              <xsl:when test="/bedework/appvar[key='suggestType']/value = 'A'">A</xsl:when>
              <xsl:when test="/bedework/appvar[key='suggestType']/value = 'R'">R</xsl:when>
              <xsl:otherwise>P</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$initSuggestionQueueTab"/>&amp;listMode=true&amp;sg=true&amp;start=<xsl:value-of select="$curListDate"/>&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event" or entity_type="todo") and suggested-to="<xsl:value-of select="$suggestedListType"/>:<xsl:value-of
                    select="/bedework/currentCalSuite/groupHref"/>")&amp;master=true&amp;sort=dtstart.utc:asc</xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-SuggestionQueueEvents"/>
          </a>
        </li>
      </xsl:if><!--
               Pending queue -->
      <xsl:if test="$isApproverUser">
        <li>
          <xsl:if test="$isPendingQueueTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a>
            <xsl:variable name="calSuite" select="/bedework/calSuiteName"/>
            <xsl:variable name="calSuiteLimit">
              <xsl:choose>
                <xsl:when test="$isSuperUser"></xsl:when>
                <xsl:otherwise> and calSuite='<xsl:value-of select="$calSuite"/>'</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="href"><xsl:value-of select="$initPendingTab"/>&amp;listMode=true&amp;sg=true&amp;searchLimits=none&amp;fexpr=%28colPath%3d"<xsl:value-of select="$submissionsRootEncoded"/>" and %28entity_type="event" or entity_type="todo"%29<xsl:value-of select="$calSuiteLimit"/>%29&amp;sort=dtstart.utc:asc</xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-PendingEvents"/>
          </a>
        </li>
      </xsl:if><!--
               Contacts -->
      <xsl:if test="$isApproverUser">
        <li>
          <xsl:if test="$isContactsTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$showContactsTab"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-Contacts"/>
          </a>
        </li><!--
               Locations -->
        <li>
          <xsl:if test="$isLocationsTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$showLocationsTab"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-Locations"/>
          </a>
        </li>
      </xsl:if>
      <xsl:if test="$inThisGroup and $canWrite"><!--
               Categories -->
        <li>
          <xsl:if test="$isCategoriesTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showCategoriesTab}">
            <xsl:copy-of select="$bwStr-Head-Categories"/>
          </a>
        </li><!--
               Calsuite -->
        <li>
          <xsl:if test="$isCalsuiteTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showCalsuiteTab}">
            <xsl:copy-of select="$bwStr-Head-CalendarSuite"/>
          </a>
        </li>
      </xsl:if>
      <xsl:if test="$isSuperUser"><!--
               Users -->
        <li>
          <xsl:if test="$isUsersTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showUsersTab}">
            <xsl:copy-of select="$bwStr-Head-Users"/>
          </a>
        </li><!--
               System -->
        <li>
          <xsl:if test="$isSystemTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showSystemTab}">
            <xsl:copy-of select="$bwStr-Head-System"/>
          </a>
        </li>
      </xsl:if><!--
          help page -->
      <li>
        <xsl:if test="$isHelpPage">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a id="helpLink">
          <xsl:attribute name="href"><xsl:value-of select="$showHelpPage"/></xsl:attribute>
          <xsl:copy-of select="$bwStr-Head-HelpPage"/>
        </a>
      </li>
    </ul>
    <xsl:call-template name="messagesAndErrors"/>
  </xsl:template>

</xsl:stylesheet>