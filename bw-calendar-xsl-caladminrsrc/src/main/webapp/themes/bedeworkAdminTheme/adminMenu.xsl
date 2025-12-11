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
        <button type="button"
                onclick="location.href='{$showHomePage}'">
          <xsl:copy-of select="$bwStr-Head-HomePage"/>
        </button>
      </li>
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
        <button type="button" id="manageEventsLink"
                onclick="location.href='{$initEventList}&amp;ignoreCreator=true&amp;listMode=true&amp;start={$curListDate}&amp;fexpr=({$creator}colPath=&quot;{$calendarPath}&quot; and (entity_type=&quot;event&quot; or entity_type=&quot;todo&quot;))&amp;sort={$sort}&amp;setappvar=catFilter()'">
          <xsl:if test="not(/bedework/currentCalSuite/name)">
            <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="$bwStr-Head-Events"/>
        </button>
      </li><!--
               Approval queue -->
      <xsl:if test="$workflowEnabled">
        <li>
          <xsl:if test="$isApprovalQueueTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button" onclick="location.href='{$initApprovalQueueTab}&amp;listMode=true&amp;fexpr=(colPath=&quot;{$workflowRootEncoded}&quot;)&amp;sort=dtstart.utc:asc'">
            <xsl:copy-of select="$bwStr-Head-ApprovalQueueEvents"/>
          </button>
        </li>
      </xsl:if><!--
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
          <xsl:variable name="suggestedListHref"
                        select="/bedework/currentCalSuite/groupHref"/>
          <button type="button" onclick="location.href='{$initSuggestionQueueTab}&amp;listMode=true&amp;sg=true&amp;start={$curListDate}&amp;fexpr=(colPath=&quot;/public/cals/MainCal&quot; and (entity_type=&quot;event&quot; or entity_type=&quot;todo&quot;) and suggested-to=&quot;{$suggestedListType}:{$suggestedListHref}&quot;)&amp;master=true&amp;sort=dtstart.utc:asc'">
            <xsl:copy-of select="$bwStr-Head-SuggestionQueueEvents"/>
          </button>
        </li>
      </xsl:if><!--
               Pending queue -->
      <xsl:if test="$isApproverUser">
        <li>
          <xsl:if test="$isPendingQueueTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <xsl:variable name="calSuite" select="/bedework/calSuiteName"/>
          <xsl:variable name="calSuiteLimit">
            <xsl:choose>
              <xsl:when test="$isSuperUser"></xsl:when>
              <xsl:otherwise> and calSuite="<xsl:value-of select="$calSuite"/>"</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <button type="button" onclick="location.href='{$initPendingTab}&amp;listMode=true&amp;sg=true&amp;searchLimits=none&amp;fexpr=%28colPath%3d&quot;{$submissionsRootEncoded}&quot; and %28entity_type=&quot;event&quot; or entity_type=&quot;todo&quot;%29{$calSuiteLimit}%29&amp;sort=dtstart.utc:asc'">
            <xsl:copy-of select="$bwStr-Head-PendingEvents"/>
          </button>
        </li>
      </xsl:if><!--
               Contacts -->
      <xsl:if test="$isApproverUser">
        <li>
          <xsl:if test="$isContactsTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button"
                  onclick="location.href='{$showContactsTab}'">
            <xsl:copy-of select="$bwStr-Head-Contacts"/>
          </button>
        </li><!--
               Locations -->
        <li>
          <xsl:if test="$isLocationsTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button"
                  onclick="location.href='{$showLocationsTab}'">
            <xsl:copy-of select="$bwStr-Head-Locations"/>
          </button>
        </li>
      </xsl:if>
      <xsl:if test="$inThisGroup and $canWrite"><!--
               Categories -->
        <li>
          <xsl:if test="$isCategoriesTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button"
                  onclick="location.href='{$showCategoriesTab}'">
            <xsl:copy-of select="$bwStr-Head-Categories"/>
          </button>
        </li><!--
               Calsuite -->
        <li>
          <xsl:if test="$isCalsuiteTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button"
                  onclick="location.href='{$showCalsuiteTab}'">
            <xsl:copy-of select="$bwStr-Head-CalendarSuite"/>
          </button>
        </li>
      </xsl:if>
      <xsl:if test="$isSuperUser"><!--
               Users -->
        <li>
          <xsl:if test="$isUsersTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button"
                  onclick="location.href='{$showUsersTab}'">
            <xsl:copy-of select="$bwStr-Head-Users"/>
          </button>
        </li><!--
               System -->
        <li>
          <xsl:if test="$isSystemTab">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <button type="button"
                  onclick="location.href='{$showSystemTab}'">
            <xsl:copy-of select="$bwStr-Head-System"/>
          </button>
        </li>
      </xsl:if>
    </ul>
    <xsl:call-template name="messagesAndErrors"/>
  </xsl:template>

</xsl:stylesheet>