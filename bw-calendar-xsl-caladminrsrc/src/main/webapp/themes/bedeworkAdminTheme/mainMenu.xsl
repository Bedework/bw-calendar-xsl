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

  <!--+++++++++++++++ Main Menu Tab ++++++++++++++++++++-->
  <xsl:template name="mainMenu">

    <div class="notes">
      <xsl:if test="$isSuperUser">
        <p class="note">
          <strong><xsl:copy-of select="$bwStr-MMnu-LoggedInAs"/></strong>
        </p>
      </xsl:if>
    </div>

    <div id="mainMenu">
      <xsl:choose>
        <!-- superusers have 8 buttons -->
        <xsl:when test="$isSuperUser">
          <xsl:attribute name="class">mainMenuFull</xsl:attribute>
        </xsl:when>
        <!-- so do calendar suite administrators when workflow isn't turned on -->
        <xsl:when test="$inThisGroup and not($workflowEnabled)">
          <xsl:if test="$canWrite">
            <xsl:attribute name="class">mainMenuFull</xsl:attribute>
          </xsl:if>
        </xsl:when>
        <!-- regular admins have 6 buttons when workflow isn't turned on -->
        <xsl:when test="not($workflowEnabled)">
          <xsl:attribute name="class">mainMenuMost</xsl:attribute>
        </xsl:when>
        <!-- when using workflow, both calsuite admins and regular admins have one or two buttons in a single row -->
        <!-- <xsl:when test="$isApproverUser">
          <xsl:attribute name="class">mainMenuInline</xsl:attribute>
        </xsl:when> -->
      </xsl:choose>
      <ul class="mainMenuRow" id="mainMenuRow1">
        <!--
        <li>
          <a id="addEventLink" href="{$event-initAddEvent}">
            <xsl:if test="not(/bedework/currentCalSuite/name)">
              <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
            </xsl:if>
            <img src="/images/caladmin/bwAdminAddEventIcon.jpg" width="140" height="140" alt=""/>
            <br/><xsl:copy-of select="$bwStr-MMnu-AddEvent"/>
          </a>
        </li>
        -->
        <xsl:if test="not($workflowEnabled) or $isApproverUser">
          <li>
            <a id="addContactLink" href="{$contact-initAdd}">
              <img src="/images/caladmin/bwAdminAddContactIcon.jpg" width="100" height="100" alt=""/><!-- alt tag empty for accessibility -->
              <br/><xsl:copy-of select="$bwStr-MMnu-AddContact"/>
            </a>
          </li>
          <li>
            <a id="addLocationLink" href="{$location-initAdd}">
              <img src="/images/caladmin/bwAdminAddLocationIcon.jpg" width="100" height="100" alt=""/><!-- alt tag empty for accessibility -->
              <br/><xsl:copy-of select="$bwStr-MMnu-AddLocation"/>
            </a>
          </li>
          <xsl:if test="$inThisGroup">
            <xsl:if test="$canWrite">
              <!--
                Category management is a  super-user and calsuite admin feature;
                Categories underlie much of the single calendar and filtering model.-->
              <li>
                <a id="addCategoryLink" href="{$category-initAdd}">
                  <img src="/images/caladmin/bwAdminAddCategoryIcon.jpg" width="100" height="100" alt=""/>
                  <br/><xsl:copy-of select="$bwStr-MMnu-AddCategory"/>
                </a>
              </li>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </ul>
      <xsl:if test="not($workflowEnabled) or $isApproverUser">
        <ul class="mainMenuRow" id="mainMenuRow2">
          <!--
          <li>
            <a  id="manageEventsLink" href="{$event-initUpdateEvent}">
              <xsl:attribute name="href"><xsl:value-of select="$event-initUpdateEvent"/>&amp;listMode=true&amp;start=<xsl:value-of select="$curListDate"/>&amp;fexpr=(colPath="<xsl:value-of select="$calendarPath"/>" and (entity_type="event" or entity_type="todo"))&amp;sort=<xsl:value-of select="$eventListSort"/>&amp;setappvar=catFilter()</xsl:attribute>
              <xsl:if test="not(/bedework/currentCalSuite/name)">
                <xsl:attribute name="onclick">alert("<xsl:copy-of select="$bwStr-MMnu-YouMustBeOperating"/>");return false;</xsl:attribute>
              </xsl:if>
              <img src="/images/caladmin/bwAdminManageEventsIcon.jpg" width="100" height="73" alt=""/>
              <br/><xsl:copy-of select="$bwStr-MMnu-ManageEvents"/>
            </a>
          </li> -->
          <xsl:if test="not($workflowEnabled) or $isApproverUser">
            <li>
              <a href="{$contact-initUpdate}">
                <img src="/images/caladmin/bwAdminManageContactsIcon.jpg" width="100" height="73" alt=""/><!-- alt tag empty for accessibility -->
                <br/><xsl:copy-of select="$bwStr-MMnu-ManageContacts"/>
              </a>
            </li>
            <li>
              <a href="{$location-initUpdate}">
                <img src="/images/caladmin/bwAdminManageLocsIcon.jpg" width="100" height="73" alt=""/><!-- alt tag empty for accessibility -->
                <br/><xsl:copy-of select="$bwStr-MMnu-ManageLocations"/>
              </a>
            </li>
            <xsl:if test="$inThisGroup">
              <xsl:if test="$canWrite">
                <!--
                  Category management is a super-user and calsuite admin feature;
                  Categories underlie much of the new single calendar and filtering model.-->
                <li>
                  <a href="{$category-initUpdate}">
                    <img src="/images/caladmin/bwAdminManageCatsIcon.jpg" width="100" height="73" alt=""/><!-- alt tag empty for accessibility -->
                    <br/><xsl:copy-of select="$bwStr-MMnu-ManageCategories"/>
                  </a>
                </li>
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </ul>
      </xsl:if>
    </div>

    <!-- Original main menu search form: you can restore this if you wish. -->
    <!--
    <div id="mainMenuEventSearch">
      <form name="searchForm" method="post" action="{$search}" id="searchForm">
        <label for="bwSearchQuery" class="bwSearchTitle"><xsl:copy-of select="$bwStr-MMnu-EventSearch"/></label>
        <input type="text" name="query" id="bwSearchQuery" size="30">
          <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
        </input>
        <input type="submit" name="submit" value="{$bwStr-MMnu-Go}"/>
        <fieldset id="searchFields">
          <legend><xsl:copy-of select="$bwStr-MMnu-Limit"/></legend>
          <input type="radio" name="searchLimits" id="bwSearchFromToday" value="fromToday" checked="checked"/>
          <label for="bwSearchFromToday">
            <xsl:copy-of select="$bwStr-MMnu-TodayForward"/>
          </label>
          <input type="radio" name="searchLimits" id="bwSearchPastDates" value="beforeToday"/>
          <label for="bwSearchPastDates">
            <xsl:copy-of select="$bwStr-MMnu-PastDates"/>
          </label>
          <input type="radio" name="searchLimits" id="bwSearchAllDates" value="none"/>
          <label for="bwSearchAllDates">
            <xsl:copy-of select="$bwStr-MMnu-AddDates"/>
          </label>
        </fieldset>
      </form>
    </div>
    -->
  </xsl:template>

</xsl:stylesheet>