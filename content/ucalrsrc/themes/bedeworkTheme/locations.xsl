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
  
  <!--==== MANAGE LOCATIONS ====-->
  <xsl:template name="locationList">
    <h2>
      <xsl:copy-of select="$bwStr-LocL-ManagePreferences"/>
    </h2>
    <ul class="submenu">
      <li>
        <a href="{$prefs-fetchForUpdate}"><xsl:copy-of select="$bwStr-LocL-General"/></a>
      </li>
      <li>
        <a href="{$category-initUpdate}"><xsl:copy-of select="$bwStr-LocL-Categories"/></a>
      </li>
      <li class="selected"><xsl:copy-of select="$bwStr-LocL-Locations"/></li>
      <li>
        <a href="{$prefs-fetchSchedulingForUpdate}"><xsl:copy-of select="$bwStr-LocL-SchedulingMeetings"/></a>
      </li>
    </ul>
    <table class="common" id="manage" cellspacing="0">
      <tr>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-LocL-ManageLocations"/></th>
      </tr>
      <tr>
        <td>
          <input type="button" name="return" value="{$bwStr-LocL-AddNewLocation}" onclick="javascript:location.replace('{$location-initAdd}')" class="titleButton"/>
          <xsl:if test="/bedework/locations/location">
            <ul>
              <xsl:for-each select="/bedework/locations/location">
                <xsl:sort select="."/>
                <li>
                  <xsl:variable name="uid" select="uid"/>
                  <a href="{$location-fetchForUpdate}&amp;uid={$uid}"><xsl:value-of select="address"/></a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="modLocation">
    <h2>
      <xsl:copy-of select="$bwStr-ModL-ManagePreferences"/>
    </h2>
    <ul class="submenu">
      <li>
        <a href="{$prefs-fetchForUpdate}"><xsl:copy-of select="$bwStr-ModL-General"/></a>
      </li>
      <li>
        <a href="{$category-initUpdate}"><xsl:copy-of select="$bwStr-ModL-Categories"/></a>
      </li>
      <li class="selected">
        <a href="{$location-initUpdate}"><xsl:copy-of select="$bwStr-ModL-Locations"/></a>
      </li>
      <li>
        <a href="{$prefs-fetchSchedulingForUpdate}"><xsl:copy-of select="$bwStr-ModL-SchedulingMeetings"/></a>
      </li>
    </ul>
    <xsl:choose>
      <xsl:when test="/bedework/creating = 'true'">
        <form name="addLocationForm" method="post" action="{$location-update}" id="standardForm">
          <table class="common" cellspacing="0">
            <tr>
              <th class="commonHeader" colspan="2"><xsl:copy-of select="$bwStr-ModL-AddLocation"/></th>
            </tr>
            <tr>
              <td class="fieldname">
                <xsl:copy-of select="$bwStr-ModL-MainAddress"/>
              </td>
              <td>
                <input size="60" name="locationAddress.value" type="text" id="bwLocMainAddress"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname">
                <xsl:copy-of select="$bwStr-ModL-SubAddress"/>
              </td>
              <td>
                <input size="60" name="locationSubaddress.value" type="text"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname">
                <xsl:copy-of select="$bwStr-ModL-LocationLink"/>
              </td>
              <td>
                <input size="60" name="location.link" type="text"/>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input name="submit" type="submit" value="{$bwStr-ModL-SubmitLocation}"/>
                <input name="cancelled" type="submit" value="{$bwStr-ModL-Cancel}"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <form name="editLocationForm" method="post" action="{$location-update}" id="standardForm">
          <input type="hidden" name="updateLocation" value="true"/>
          <table class="common" cellspacing="0">
            <tr>
              <th colspan="2" class="commonHeader">
                <xsl:copy-of select="$bwStr-ModL-EditLocation"/>
              </th>
            </tr>
            <tr>
              <td class="fieldName">
                <label for="locationAddressField"><xsl:copy-of select="$bwStr-MoLo-Name"/></label>
              </td>
              <td>
                <input type="text" name="location.addressField" id="locationAddressField" size="40" value="">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/addressField"/></xsl:attribute>
                  <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Address-Placeholder"/></xsl:attribute>
                </input>
                <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Required"/></span>
              </td>
            </tr>
            <tr class="optional">
              <td class="fieldName">
                <label for="locationRoomField"><xsl:copy-of select="$bwStr-MoLo-Room"/></label>
              </td>
              <td>
                <input type="text" name="location.roomField" id="locationRoomField" size="40" value="">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/roomField"/></xsl:attribute>
                  <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Room-Placeholder"/></xsl:attribute>
                </input>
                <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
              </td>
            </tr>
            <tr id="bw-location-address" class="optional">
              <td class="fieldName">
                <xsl:copy-of select="$bwStr-MoLo-Address"/>
              </td>
              <td>
                <fieldset>
                  <label for="locationStreet"><xsl:copy-of select="$bwStr-MoLo-Street"/></label>
                  <input type="text" name="location.street" id="locationStreet" size="40">
                    <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/street"/></xsl:attribute>
                    <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Street-Placeholder"/></xsl:attribute>
                  </input>
                  <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>

                  <br/>

                  <label for="locationCity"><xsl:copy-of select="$bwStr-MoLo-City"/></label>
                  <input type="text" name="location.city" id="locationCity" size="40">
                    <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/city"/></xsl:attribute>
                    <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-City-Placeholder"/></xsl:attribute>
                  </input>

                  <br/>

                  <label for="locationState"><xsl:copy-of select="$bwStr-MoLo-State"/></label>
                  <input type="text" name="location.state" id="locationState" size="2">
                    <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/state"/></xsl:attribute>
                    <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-State-Placeholder"/></xsl:attribute>
                  </input>
                  <label for="locationPostalCode" class="inline"><xsl:copy-of select="$bwStr-MoLo-PostalCode"/></label>
                  <input type="text" name="location.zip" id="locationPostalCode" size="10">
                    <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/zip"/></xsl:attribute>
                    <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-PostalCode-Placeholder"/></xsl:attribute>
                  </input>
                </fieldset>

              </td>
            </tr>
            <!-- Subfield2 - used by default for full URL to Map -->
            <tr class="optional">
              <td class="fieldName">
                <label for="locationSubField2"><xsl:copy-of select="$bwStr-MoLo-SubField2"/></label>
              </td>
              <td>
                <input type="text" name="location.subField2" id="locationSubField2" size="40">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/subField2"/></xsl:attribute>
                  <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubField2-Placeholder"/></xsl:attribute>
                </input>
                <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
              </td>
            </tr>
            <tr class="optional">
              <td class="fieldName">
                <label for="locationUrl"><xsl:copy-of select="$bwStr-MoLo-LocationURL"/></label>
              </td>
              <td>
                <input type="text" name="location.link" id="locationUrl" size="40">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/link"/></xsl:attribute>
                  <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-LocationURL-Placeholder"/></xsl:attribute>
                </input>
                <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
              </td>
            </tr>
            <tr class="optional">
              <td class="fieldName">
                <label for="geoUri"><xsl:copy-of select="$bwStr-MoLo-GeoUri"/></label>
              </td>
              <td>
                <input type="text" name="location.geouri" id="geoUri" size="40">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/currentLocation/geouri"/></xsl:attribute>
                  <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-GeoUri-Placeholder"/></xsl:attribute>
                </input>
                <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input name="submit" type="submit" value="{$bwStr-ModL-SubmitLocation}"/>
                <input name="cancelled" type="submit" value="{$bwStr-ModL-Cancel}"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="{$bwStr-ModL-DeleteLocation}"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="deleteLocationConfirm">
    <h2><xsl:copy-of select="$bwStr-OKDL-OKToDeleteLocation"/></h2>

    <table class="common" cellspacing="0">
      <tr>
        <th class="commonHeader" colspan="2"><xsl:copy-of select="$bwStr-OKDL-DeleteLocation"/></th>
      </tr>
      <tr>
        <td class="fieldname">
          <xsl:copy-of select="$bwStr-OKDL-MainAddress"/>
        </td>
        <td align="left">
          <xsl:value-of select="/bedework/currentLocation/address"/>
        </td>
      </tr>
      <tr>
        <td class="fieldname">
          <xsl:copy-of select="$bwStr-OKDL-Subaddress"/>
        </td>
        <td align="left">
          <xsl:value-of select="/bedework/currentLocation/subaddress"/>
        </td>
      </tr>
      <tr>
        <td class="fieldname">
          <xsl:copy-of select="$bwStr-OKDL-LocationLink"/>
        </td>
        <td>
          <xsl:variable name="link" select="/bedework/currentLocation/link"/>
          <a href="{$link}"><xsl:value-of select="$link"/></a>
        </td>
      </tr>
    </table>

    <form action="{$location-delete}" method="post">
      <input type="submit" name="updateCategory" value="{$bwStr-OKDL-YesDeleteLocation}"/>
      <input type="submit" name="cancelled" value="{$bwStr-OKDL-Cancel}"/>
    </form>
  </xsl:template>

  
</xsl:stylesheet>