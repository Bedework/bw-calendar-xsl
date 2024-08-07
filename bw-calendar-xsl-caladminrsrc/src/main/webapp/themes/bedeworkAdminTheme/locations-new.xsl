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

  <!--+++++++++++++++ Locations ++++++++++++++++++++-->
  <!-- templates:
         - locationList
         - modLocation (add/edit location form)
         - deleteLocationConfirm
         - locationReferenced (displayed when trying to delete a location in use)
   -->

  <!-- Locations listing -->
  <xsl:template name="locationList">
    <div class="mgmtHeading">
      <h2><xsl:copy-of select="$bwStr-LoLi-ManageLocations"/></h2>
      <input type="button" name="return" value="{$bwStr-LoLi-AddNewLocation}" onclick="javascript:location.replace('{$location-initAdd}')"/>
      <p>
        <xsl:copy-of select="$bwStr-LoLi-SelectLocationToUpdate"/>
      </p>
    </div>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-LoLi-Address"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-SubAddress"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-URL"/></th>
      </tr>

      <xsl:for-each select="/bedework/locations/location">
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:copy-of select="address/*"/>
          </td>
          <td>
            <xsl:value-of select="subaddress"/>
          </td>
          <td>
            <xsl:variable name="link" select="link" />
            <a href="{$link}" target="linktest">
              <xsl:value-of select="link" />
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Locations add/modify form -->
  <xsl:template name="modLocation">
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
        <h2><xsl:copy-of select="$bwStr-MoLo-AddLocation"/></h2>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-MoLo-UpdateLocation"/></h2>
      </xsl:otherwise>
    </xsl:choose>

    <form action="{$location-update}" id="bwModLocationForm" method="post">
      <table id="commonFormTable">
        <tr>
          <td class="fieldName">
            <label for="locationAddressField"><xsl:copy-of select="$bwStr-MoLo-Address"/></label>
          </td>
          <td>
            <!-- value is set by javascript -->
            <input type="text" name="location.addressField" id="locationAddressField" size="40" value="">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/addressField/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Address-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Address-Info"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="locationRoomField"><xsl:copy-of select="$bwStr-MoLo-Address2"/></label>
          </td>
          <td>
            <!-- value is set by javascript -->
            <input type="text" name="location.roomField" id="locationRoomField" size="40" value="">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/roomField/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Address2-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="locationSubField1"><xsl:copy-of select="$bwStr-MoLo-SubField1"/></label>
          </td>
          <td>
            <input type="text" name="location.subField1" id="locationSubField1" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/subField1/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubField1-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="locationSubField2"><xsl:copy-of select="$bwStr-MoLo-SubField2"/></label>
          </td>
          <td>
            <input type="text" name="location.subField2" id="locationSubField2" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/subField2/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubField2-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="locationSubAddress"><xsl:copy-of select="$bwStr-MoLo-SubAddress"/></label>
          </td>
          <td>
            <input type="text" name="locationSubaddress.value" id="locationSubAddress2" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/subaddress/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubAddress-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="locationUrl"><xsl:copy-of select="$bwStr-MoLo-LocationURL"/></label>
          </td>
          <td>
            <input type="text" name="location.link" id="locationUrl" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/link/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-LocationURL-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
          </td>
          <td>
            <input type="checkbox" name="location.accessible" id="locationAccessible">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/accessible/input/@value"/></xsl:attribute>
            </input>
            <label for="locationAccessible"><xsl:copy-of select="$bwStr-MoLo-LocationAccessible"/></label>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
      </table>

      <div class="submitBox">
        <xsl:choose>
          <xsl:when test="/bedework/creating='true'">
            <input type="submit" name="addLocation" value="{$bwStr-MoLo-AddLocation}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoLo-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateLocation" value="{$bwStr-MoLo-UpdateLocation}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoLo-Cancel}"/>
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-MoLo-DeleteLocation}"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <!-- Locations deletion confirmation page -->
  <xsl:template name="deleteLocationConfirm">
    <h2><xsl:copy-of select="$bwStr-DeLC-OkDeleteLocation"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-Address"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-SubAddress"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-LocationURL"/>
          </td>
        <td>
          <xsl:variable name="link" select="/bedework/location/link"/>
          <a href="{$link}">
            <xsl:value-of select="/bedework/location/link"/>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Locations referenced notice -->
  <xsl:template name="locationReferenced">
    <h2><xsl:copy-of select="$bwStr-DeLR-LocationInUse"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-Address"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-SubAddress"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-LocationURL"/>
          </td>
        <td>
          <xsl:variable name="link" select="/bedework/location/link"/>
          <a href="{$link}">
            <xsl:value-of select="/bedework/location/link"/>
          </a>
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DeLR-LocationInUseBy"/>
    </p>

    <xsl:if test="$superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DeLR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the location -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DeLR-Collections"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'true']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}">
                  <xsl:value-of select="path"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <!-- List events that reference the location -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DeLR-Events"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'false']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <xsl:variable name="guid" select="uid"/>
                <!-- only returns the master event -->
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId=">
                  <xsl:value-of select="uid"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

