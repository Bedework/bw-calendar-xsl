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

  <!--++++ SEARCH ++++-->
  <!-- templates:
         - upperSearchForm
   -->

  <xsl:template name="upperSearchForm">
    <xsl:param name="toggleLimits">false</xsl:param>

    <xsl:variable name="bwQueryQuery">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='bwQuery']">
          <xsl:value-of select="substring-before(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|')"/>
        </xsl:when>
        <xsl:otherwise><xsl:text/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="bwQueryScope">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='bwQuery']">
          <xsl:value-of select="substring-before(substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|'),'|')"/>
        </xsl:when>
        <xsl:otherwise>local</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="bwQueryColScope">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='bwQuery']">
          <xsl:value-of select="substring-after(substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|'),'|')"/>
        </xsl:when>
        <xsl:otherwise>main</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div id="searchFilter">
      <form name="searchForm" method="post" action="{$search}" onsubmit="return setBwQuery(this);">
        <div class="searchQueryBlock">
          <label for="query">
            <xsl:copy-of select="$bwStr-Srch-Search"/>
          </label>
          <xsl:text> </xsl:text>
          <input type="text" name="query" id="query" size="27">
            <xsl:attribute name="value"><xsl:value-of select="$bwQueryQuery"/></xsl:attribute>
            <xsl:attribute name="class">noFocus</xsl:attribute>
          </input>
          <input type="hidden" name="count" value="{$searchResultSize}"/>
          <input type="hidden" name="listMode" value="true"/>
          <input type="hidden" name="start" value="today"/>
          <input type="hidden" name="sort" value="dtstart.utc:asc"/>
          <input type="hidden" name="ignoreCreator" value="true"/>
          <input type="hidden" name="setappvar" value="bwQuery()"/>
          <input type="submit" name="submit" value="{$bwStr-Srch-Go}" class="noFocus"/>

          <div id="searchScope">
            <xsl:choose>
              <xsl:when test="$isSuperUser">
                <input type="radio" name="colscope" id="colScope-all"
                       value="all">
                  <xsl:if test="$bwQueryColScope = 'all'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>

                <label for="colScope-all"><xsl:value-of select="$bwStr-Srch-ColScopeAll"/></label>
                <input type="radio" name="colscope" id="colScope-main" value="main">
                  <xsl:if test="$bwQueryColScope = 'main'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="colScope-main"><xsl:value-of select="$bwStr-Srch-ColScopeMain"/></label>

                <xsl:text> | </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <div class="invisible">
                  <input type="radio" name="colscope" id="colScope-all"/>
                  <input type="radio" name="colscope" id="colScope-main" value="main">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </input>
                </div>
              </xsl:otherwise>
            </xsl:choose>

            <input type="radio" name="fexpr" id="searchScope-local">
              <xsl:attribute name="value">(creator="/principals/users/<xsl:value-of select="/bedework/userInfo/user"/>" and colPath="/public/cals/MainCal" and (entity_type="event" or entity_type="todo"))</xsl:attribute>
              <xsl:if test="$bwQueryScope = 'local'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="searchScope-local"><xsl:value-of select="$bwStr-Srch-ScopeLocal"/></label>

            <input type="radio" name="fexpr" id="searchScope-mine">
              <xsl:attribute name="value">
                <xsl:choose>
                  <xsl:when test="$superUser = 'true'">(colPath="/public/cals/MainCal" and (entity_type="event" or entity_type="todo"))</xsl:when>
                  <xsl:when test="/bedework/userInfo/oneGroup = 'true'">(creator="/principals/users/<xsl:value-of select="/bedework/userInfo/user"/>" and colPath="/public/cals/MainCal" and (entity_type="event" or entity_type="todo"))</xsl:when>
                  <xsl:otherwise>((<xsl:for-each select="/bedework/userInfo/groups/group">creator="<xsl:value-of select="ownerHref"/>"<xsl:if test="position() != last()"> or </xsl:if></xsl:for-each>) and colPath="/public/cals/MainCal" and (entity_type="event" or entity_type="todo"))</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:if test="$bwQueryScope = 'mine'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="searchScope-mine"><xsl:value-of select="$bwStr-Srch-ScopeMine"/></label>

            <input type="radio" name="fexpr" id="searchScope-all">
              <xsl:attribute name="value">(colPath="/public/cals/MainCal" and (entity_type="event" or entity_type="todo"))</xsl:attribute>
              <xsl:if test="$bwQueryScope = 'all'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="searchScope-all"><xsl:value-of select="$bwStr-Srch-ScopeAll"/></label>

          </div>
        </div>

      </form>
    </div>
  </xsl:template>
</xsl:stylesheet>