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

  <!--++++++++++++++++++ Manage Events List ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <h2><xsl:copy-of select="$bwStr-Head-ManageEvents"/></h2>

    <div id="bwEventListControls">
      <xsl:call-template name="eventListControls">
        <xsl:with-param name="sort" select="$sort"/>
      </xsl:call-template><!--
        -->
      <form name="bwManageEventListControls"
            id="bwManageEventListControls"
            method="get"
            action="{$event-initUpdateEvent}">
        <input type="hidden" name="listMode" value="true"/>
        <!-- following params set by JavaScript -->
        <input type="hidden" name="fexpr" value=""/>
        <input type="hidden" name="setappvar" id="appvar" value=""/>
        <input type="hidden" name="ignoreCreator" id="ignoreCreator" value="{$isSuperUser}"/><!--
             Start date -->
        <div id="bwEventListStart">
          <label for="bwListWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
          <input id="bwListWidgetStartDate" type="text" class="noFocus" name="start" size="10"
                 onchange="setEventList(this.form,'date', this.value);"/>
          <input id="bwListWidgetToday" type="submit" value="{$bwStr-EvLs-Today}"
                 onclick="setEventList(this.form, 'today', '{$today}');"/>
        </div><!--
                     sort -->
        <div id="bwEventListSort">
          <label for="listEventsSort"><xsl:copy-of select="$bwStr-EvLs-SortBy"/></label>
          <select name="sort"
                  onchange="setEventList(this.form,'sort');"
                  id="listEventsSort">
            <option value="dtstart.utc:asc">
              <xsl:copy-of select="$bwStr-EvLs-SortByStart"/>
            </option>
            <option value="created:desc">
              <xsl:if test="/bedework/appvar[key='sort']/value = 'created:desc'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-EvLs-SortByCreated"/>
            </option>
            <option value="last_modified:desc">
              <xsl:if test="/bedework/appvar[key='sort']/value = 'last_modified:desc'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-EvLs-SortByModified"/>
            </option>
          </select>
        </div><!--
                     colpath -->
        <div id="bwEventListCol">
          <xsl:choose>
            <xsl:when test="count(/bedework/calendars/calendar) > 1">
              <label for="colPathSetter"><xsl:copy-of select="$bwStr-EvLs-Calendar"/></label>
              <select name="colPath"
                      onchange="setEventList(this.form,'calPath');"
                      id="colPathSetter">
                <xsl:for-each select="/bedework/calendars/calendar">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
                    <xsl:if test="$calendarPath = path">
                      <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="path"/>
                  </option>
                </xsl:for-each>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <input type="hidden" name="colPath">
                <xsl:attribute name="value"><xsl:value-of select="$calendarPath"/>
                </xsl:attribute>
              </input>
            </xsl:otherwise>
          </xsl:choose>
        </div><!--
                             query -->
        <xsl:variable name="queryVal">
          <xsl:choose>
            <xsl:when test="/bedework/appvar[key='query']">
              <xsl:value-of select="/bedework/appvar[key='query']/value"/>
            </xsl:when>
            <xsl:otherwise><xsl:text/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <div id="bwEventListQuery">
          <label for="query">
            <xsl:copy-of select="$bwStr-Srch-Search"/>
          </label>
          <input type="text" name="query"
                 onchange="setEventList(this.form,'query');"
                 id="query" size="27">
            <xsl:attribute name="value"><xsl:value-of select="$queryVal"/></xsl:attribute>
            <xsl:attribute name="class">noFocus</xsl:attribute>
          </input>
        </div><!--
                     groups -->
        <div id="bwEventListGroups">
          <label for="listEventsGroupFilter"><xsl:copy-of select="$bwStr-EvLs-FilterBy"/></label>
          <select name="groupFilter"
                  onchange="setEventList(this.form,'group');"
                  id="listEventsGroupFilter">
            <option value="">
              <xsl:copy-of select="$bwStr-EvLs-SelectGroup"/>
            </option>
            <xsl:for-each select="/bedework/groups/group">
              <xsl:sort select="value"/>
              <xsl:variable name="groupRef" select="ownerHref"/>
              <option>
                <xsl:attribute name="value"><xsl:value-of select="$groupRef"/></xsl:attribute>
                <xsl:if test="/bedework/appvar[key='groupFilter']/value = $groupRef">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="name"/>
              </option>
            </xsl:for-each>
          </select><!--
            -->
          <xsl:if test="not($isSuperUser)">
            <input type="checkbox" name="sg" id="listEventsAllGroups" value="true" onchange="setEventList(this.form,'allGroups');">
              <xsl:if test="/bedework/appvar[key='groupFilter']/value = '**allGroups**'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="listEventsAllGroups"><xsl:copy-of select="$bwStr-Srch-ScopeAll"/></label>
          </xsl:if><!--
            -->
          <xsl:if test="/bedework/appvar[key='groupFilter'] and /bedework/appvar[key='groupFilter']/value != ''">
            <input type="button" value="{$bwStr-EvLs-ClearFilter}" onclick="clearGroup(this.form);"/>
          </xsl:if>
        </div><!--
                     categories -->
        <div id="bwEventListCats">
          <label for="listEventsCatFilter"><xsl:copy-of select="$bwStr-EvLs-FilterBy"/></label>
          <select name="catFilter"
                  onchange="setEventList(this.form,'cat');"
                  id="listEventsCatFilter">
            <option value="">
              <xsl:copy-of select="$bwStr-EvLs-SelectCategory"/>
            </option>
            <xsl:for-each select="/bedework/categories/category">
              <xsl:sort select="value"/>
              <xsl:variable name="catPathName"><xsl:value-of select="colPath"/><xsl:value-of select="name"/></xsl:variable>
              <option>
                <xsl:attribute name="value"><xsl:value-of select="$catPathName"/></xsl:attribute>
                <xsl:if test="/bedework/appvar[key='catFilter']/value = $catPathName">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="value"/>
              </option>
            </xsl:for-each>
          </select>
          <xsl:if test="/bedework/appvar[key='catFilter'] and /bedework/appvar[key='catFilter']/value != ''">
            <input type="button" value="{$bwStr-EvLs-ClearFilter}" onclick="clearCat(this.form);"/>
          </xsl:if>
        </div>
      </form>
    </div>
    <xsl:call-template name="eventListCommon"/>

    <xsl:call-template name="eventListControls">
      <xsl:with-param name="sort" select="$sort"/>
      <xsl:with-param name="bottom">true</xsl:with-param>
    </xsl:call-template>

    <div id="bwPublicEventLinkBox" class="popup invisible">
      <h2><xsl:copy-of select="$bwStr-EvLs-PublicUrl"/></h2>
      <div id="bwPublicEventLink"><xsl:text> </xsl:text></div>
      <div class="container">
        <input id="bwPublicEventLinkInput" value=""/>
      </div>
    </div>

  </xsl:template>

  <xsl:template name="buildListDays">
    <xsl:param name="index">1</xsl:param>
    <xsl:variable name="max" select="/bedework/maxdays"/>
    <xsl:if test="number($index) &lt; number($max)">
      <option value="{$index}">
        <xsl:if test="$index = $curListDays"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:value-of select="$index"/>
      </option>
      <xsl:call-template name="buildListDays">
        <xsl:with-param name="index"><xsl:value-of select="number($index)+1"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>