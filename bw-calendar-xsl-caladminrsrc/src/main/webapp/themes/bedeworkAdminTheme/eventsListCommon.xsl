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

  <!--++++++++++++++++++ Events List Common ++++++++++++++++++++-->
  <!--            included in most event listings               -->

  <xsl:template name="changeStatusButton">
    <xsl:param name="href"/>
    <xsl:param name="newStatus"/>
    <xsl:param name="name"/><!--
    -->
    <xsl:variable name="updateStatusHref">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'displayEventForNonApprover'">
          <xsl:value-of select="$event-updateStatusFromSearch"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$event-updateStatus"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <button type="button" class="next" onclick="location.href='{$updateStatusHref}&amp;href={$href}&amp;status={$newStatus}'">
        <xsl:copy-of select="$name"/>
      </button>
    </div>
  </xsl:template>

  <xsl:template name="changeStatusCancelled">
    <xsl:param name="href"/>
    <xsl:call-template name="changeStatusButton">
      <xsl:with-param name="href" select="$href"/>
      <xsl:with-param name="newStatus" select="CANCELLED" />
      <xsl:with-param name="name"
                      select="$bwStr-EvLC-SetCancelled"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="changeStatusConfirmed">
    <xsl:param name="href"/>
    <xsl:call-template name="changeStatusButton">
      <xsl:with-param name="href" select="$href"/>
      <xsl:with-param name="newStatus" select="CONFIRMED" />
      <xsl:with-param name="name"
                      select="$bwStr-EvLC-SetConfirmed"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="changeStatusTentative">
    <xsl:param name="href"/>
    <xsl:call-template name="changeStatusButton">
      <xsl:with-param name="href" select="$href"/>
      <xsl:with-param name="newStatus" select="TENTATIVE" />
      <xsl:with-param name="name"
                      select="$bwStr-EvLC-SetTentative"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="changeStatusButtons">
    <xsl:param name="status"/>
    <xsl:param name="href"/>
    <xsl:choose>
      <xsl:when test="$status = 'CANCELLED'"><!--
            CONFIRMED and TENTATIVE buttons -->
        <xsl:call-template name="changeStatusConfirmed">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template><!--
             -->
        <xsl:call-template name="changeStatusTentative">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$status = 'TENTATIVE'"><!--
            CONFIRMED and CANCELLED buttons -->
        <xsl:call-template name="changeStatusConfirmed">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template><!--
             -->
        <xsl:call-template name="changeStatusCancelled">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><!--
            CANCELLED and TENTATIVE buttons -->
        <xsl:call-template name="changeStatusCancelled">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template><!--
             -->
        <xsl:call-template name="changeStatusTentative">
          <xsl:with-param name="href" select="$href"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><!--
  -->
  <xsl:template name="eventListTitleCell">
    <xsl:variable name="eventTitle">
      <xsl:choose>
        <xsl:when test="summary != ''">
          <xsl:value-of select="summary"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;em&gt;<xsl:copy-of select="$bwStr-EvLC-NoTitle"/>&lt;/em&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable><!--
    -->
    <xsl:variable name="calPath"
                  select="calendar/encodedPath"/><!--
    -->
    <xsl:variable name="eventEditLabel">
      <xsl:choose>
        <xsl:when test="recurrenceId = ''"><xsl:copy-of select="$bwStr-EvLC-EditEvent"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-EvLC-EditInstance"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable><!--
    -->
    <xsl:variable name="evCreator" select="creator"/><!--
    -->
    <xsl:variable name="canEdit"
                  select="$isSuperUser or
                  (($isApproverUser or $isApprovalQueueTab) and
                     (/bedework/userInfo/groups/group[ownerHref = $evCreator]))"/><!--
    -->
    <td>
      <xsl:if test="deleted = 'true'">
        <div>
          <xsl:copy-of select="$bwStr-EvLC-EventDeleted"/>
          <br/>
        </div>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$isPendingQueueTab">
          <xsl:variable name="isSubmissionClaimant"
                        select="not(xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT) or xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text = /bedework/userInfo/group"/><!--
           -->
          <xsl:if test="not($isSubmissionClaimant)">
            <div>
              <button type="button" class="next" onclick="location.href='{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={guid}&amp;recurrenceId={recurrenceId}'">
                <xsl:copy-of select="$eventEditLabel"/>
              </button>
            </div>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise><!-- NOT pending queue -->
          <xsl:choose>
            <xsl:when test="status = 'CANCELLED'"><strong><xsl:copy-of select="$bwStr-EvLC-Cancelled"/></strong><br/></xsl:when>
            <xsl:when test="status = 'TENTATIVE'"><xsl:copy-of select="$bwStr-EvLC-Tentative"/><br/></xsl:when>
          </xsl:choose><!--
          Add an edit event link if appropriate -->
          <xsl:choose>
            <xsl:when test="$canEdit">
              <!-- suggestion queue can only edit master -->
              <xsl:if test="not($isSuggestionQueueTab)
                          or recurrenceId = ''">
                <!-- edit event/instance -->
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$event-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:copy-of select="$eventEditLabel"/>
                  </xsl:attribute>
                  <xsl:copy-of select="$eventTitle"/>
                </a>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise><!--
               non-approver or not ours -
               can only display event or instance -->
              <xsl:variable name="eventDisplayLabel">
                <xsl:choose>
                  <xsl:when test="recurrenceId = ''"><xsl:copy-of select="$bwStr-EvLC-DisplayEvent"/></xsl:when>
                  <xsl:otherwise><xsl:copy-of select="$bwStr-EvLC-DisplayInstance"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable><!--
            -->
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$event-displayEventForNonApprover"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:copy-of select="$eventDisplayLabel"/>
                </xsl:attribute>
                <xsl:copy-of select="$eventTitle"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="not($isApprovalQueueTab)">
            <!-- generate a public link; for now always expose in the main suite. -->
            <xsl:variable name="publicLink">/cal/event/eventView.do?href=<xsl:value-of select="encodedHref"/></xsl:variable>
            <a class="bwPublicLink"  target="_blank" rel="noopener noreferrer">
              <xsl:attribute name="href"><xsl:value-of select="$publicLink"/></xsl:attribute>
              <span class="ui-icon ui-icon-link"></span>
            </a>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="($canEdit
                and ((recurring = 'true') or (recurrenceId != '')))">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$event-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="guid"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$bwStr-EvLC-EditMaster"/>
          </xsl:attribute>
          <xsl:value-of select="$bwStr-EvLC-EditMaster"/>
        </a>
      </xsl:if>
    </td>
  </xsl:template><!--
  -->
  <xsl:template name="eventListCommon">
    <table id="commonListTable" title="event listing">
      <thead>
        <tr>
          <th><xsl:copy-of select="$bwStr-EvLC-Title"/></th>
          <th><xsl:copy-of select="$bwStr-EvLC-Master"/></th>
          <th><xsl:copy-of select="$bwStr-EvLC-DateTime"/></th>
          <xsl:if test="$isSuggestionQueueTab">
            <th><xsl:copy-of select="$bwStr-EvLC-AcceptQuery"/></th>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-EvLC-Group"/></th>
          <xsl:if test="$isPendingQueueTab">
            <th><xsl:copy-of select="$bwStr-EvLC-CalSuite"/></th>
            <th><xsl:copy-of select="$bwStr-EvLC-ClaimedBy"/></th>
          </xsl:if>
          <xsl:if test="not($isSuggestionQueueTab)">
            <th>
              <xsl:if test="$isPendingQueueTab"><xsl:copy-of select="$bwStr-EvLC-Suggested"/><xsl:text> </xsl:text></xsl:if>
              <xsl:copy-of select="$bwStr-EvLC-TopicalAreas"/>
            </th>
          </xsl:if>
          <xsl:if test="not($isPendingQueueTab)">
            <th><xsl:copy-of select="$bwStr-EvLC-Categories"/></th>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-EvLC-Author"/></th>
          <xsl:if test="$evlistShowDescription">
            <th><xsl:copy-of select="$bwStr-EvLC-Description"/></th>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-EvLC-Lastmod"/></th>
          <th><xsl:copy-of select="$bwStr-EvLC-Created"/></th>
          <th><xsl:copy-of select="$bwStr-EvLC-Actions"/></th>
        </tr>
      </thead>
      <tbody id="commonListTableBody">
        <xsl:apply-templates select="/bedework/events/event"
                             mode="eventListCommon"/>
        <xsl:if test="not(/bedework/events/event)">
          <tr>
            <td colspan="7">
              <!--xsl:if test="$isPendingQueueTab or $isApprovalQueueTab or $isSuggestionQueueTab">
                <xsl:attribute name="colspan">7</xsl:attribute>
              </xsl:if-->
              <xsl:copy-of select="$bwStr-EvLC-NoEvents"/>
              <xsl:if test="not($isPendingQueueTab)">
                (<xsl:value-of select="/bedework/maxdays"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$bwStr-EvLC-DayWindow"/>)
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>

    <xsl:if test="/bedework/events/event">
      <xsl:variable name="resultSize" 
                    select="/bedework/events/resultSize"/>
      <xsl:variable name="pageSize" 
                    select="/bedework/events/pageSize"/>
      <xsl:variable name="offset">
        <xsl:choose>
          <xsl:when test="/bedework/events/curOffset = $resultSize">0</xsl:when>
          <xsl:otherwise><xsl:value-of select="/bedework/events/curOffset"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="totalPages"><xsl:value-of select="ceiling($resultSize div $pageSize)"/></xsl:variable>
      <xsl:variable name="curPage"><xsl:value-of select="floor($offset div $pageSize) + 1"/></xsl:variable>
      <xsl:variable name="firstOfOffset">
        <xsl:choose>
          <xsl:when test="$resultSize = 0">0</xsl:when>
          <xsl:otherwise><xsl:value-of select="$offset + 1"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="lastOfOffset">
        <xsl:choose>
          <xsl:when test="$offset + $pageSize &gt; $resultSize"><xsl:value-of select="$resultSize"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$offset + $pageSize"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <div id="eventListMetaData">
        <xsl:value-of select="$bwStr-EvLC-Page"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$curPage"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-Of"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$totalPages"/>,
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-Viewing"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$firstOfOffset"/>-<xsl:value-of select="$lastOfOffset"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-Of"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="/bedework/events/resultSize"/>
        <xsl:text> </xsl:text>
        <xsl:if test="not($isPendingQueueTab)">
          <xsl:value-of select="$bwStr-EvLC-EventsInA"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="/bedework/maxdays"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$bwStr-EvLC-DayWindow"/>
        </xsl:if>
        <xsl:if test="$isPendingQueueTab">
          <xsl:value-of select="$bwStr-EvLC-Events"/>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="event" mode="eventListCommon">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="href" select="encodedHref"/>
    <xsl:variable name="calSuite" select="calSuite"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="i" select="position()"/><!--
    -->
    <xsl:variable name="claimedPending">
      <xsl:choose>
        <xsl:when test="$isPendingQueueTab and xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable><!--
    -->
    <tr>
      <!-- First set some attributes ==>
      <xsl:attribute name="id">suggestionRow<xsl:value-of select="$i"/></xsl:attribute>
      -->
      <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if><!--
      -->
      <xsl:if test="$isPendingQueueTab and not(xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT)">
        <xsl:attribute name="class">highlight</xsl:attribute>
      </xsl:if><!--
      -->
      <xsl:if test="status = 'TENTATIVE'">
        <xsl:attribute name="class">tentative</xsl:attribute>
      </xsl:if><!--
      -->
      <xsl:if test="status = 'CANCELLED'">
        <xsl:attribute name="class">cancelled</xsl:attribute>
      </xsl:if><!--
             =========== Title and master cells -->
      <xsl:call-template name="eventListTitleCell"/><!--
      End of title cell --><!--
            =============================  DateTime -->
      <td>
        <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
        <xsl:if test="start/allday = 'false'">
          <span class="time"><xsl:value-of select="start/time"/></span>
        </xsl:if>
        <xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if>
        <xsl:if test="end/longdate != start/longdate">
          <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="start/allday = 'true'">
            <span class="time"><em><xsl:copy-of select="$bwStr-DsEv-AllDay"/></em></span>
          </xsl:when>
          <xsl:when test="end/longdate != start/longdate">
            <span class="time"><xsl:value-of select="end/time"/></span>
          </xsl:when>
          <xsl:when test="end/time != start/time">
            <span class="time"><xsl:value-of select="end/time"/></span>
          </xsl:when>
        </xsl:choose>
      </td>
      <xsl:if test="$isPendingQueueTab and $isApproverUser">
        <td>
          <div class="recurrenceEditLinks">
            <xsl:choose>
              <xsl:when test="$claimedPending = 'true'">
                <button type="button" class="next" onclick="location.href='{$event-fetchForApprovePublish}&amp;calPath={$calPath}&amp;guid={$guid}'">
                  <xsl:copy-of select="$bwStr-EvLC-ApproveDDD"/>
                </button>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$bwStr-EvLC-ClaimBeforeApprove"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </xsl:if><!--
                ======== Approve/publish button -->
      <xsl:if test="$isApprovalQueueTab and $isApproverUser">
        <td>
          <div class="recurrenceEditLinks">
            <button type="button" class="next" onclick="location.href='{$event-fetchForApprovePublish}&amp;calPath={$calPath}&amp;guid={$guid}'">
              <xsl:copy-of select="$bwStr-EvLC-ApproveDDD"/>
            </button>
          </div>
        </td>
      </xsl:if>
      <xsl:if test="$isSuggestionQueueTab">
        <td>
          <xsl:variable name="actionPrefix"><xsl:value-of select="$suggest-setStatus"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:variable>
          <button onclick="setSuggestionRowStatus('accept','{$actionPrefix}','suggestionRow{$i}','{$bwStr-EvLC-NoEvents}')">
            <xsl:value-of select="$bwStr-SEBu-Accept"/>
          </button>
          <button onclick="setSuggestionRowStatus('reject','{$actionPrefix}','suggestionRow{$i}','{$bwStr-EvLC-NoEvents}')">
            <xsl:value-of select="$bwStr-SEBu-Reject"/>
          </button>
        </td>
      </xsl:if>
      <xsl:if test="$isPendingQueueTab">
        <td>
          <xsl:value-of select="calSuite"/>
        </td>
        <xsl:choose>
          <xsl:when test="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT">
            <td>
              <xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text"/>
              <xsl:text> </xsl:text>
              (<xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/parameters/X-BEDEWORK-SUBMISSION-CLAIMANT-USER"/>)
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td class="unclaimed"><xsl:copy-of select="$bwStr-EvLC-Unclaimed"/></td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if> <!--
      =============================  Group -->
      <td>
        <a title = "{$bwStr-EvLs-SelectThisGroup}"
           onclick = 'setGroupFilter(document.getElementById("bwManageEventListControls"), "{creatorGroup/ownerHref}")'>
          <xsl:value-of select="creatorGroup/name"/>
        </a>
      </td>
      <xsl:if test="not($isSuggestionQueueTab)">
        <!-- List topical areas for pending (suggested) and approval -->
        <td class="calcat">
          <xsl:choose>
            <xsl:when test="$isPendingQueueTab">
              <xsl:if test="xproperties/X-BEDEWORK-SUBMIT-ALIAS">
                <ul>
                  <xsl:for-each select="xproperties/X-BEDEWORK-SUBMIT-ALIAS">
                    <li><xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/></li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="xproperties/X-BEDEWORK-ALIAS[contains(values/text,/bedework/currentCalSuite/resourcesHome)]">
                <ul>
                  <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS[contains(values/text,/bedework/currentCalSuite/resourcesHome)]">
                    <li><xsl:value-of select="substring-after(values/text,/bedework/currentCalSuite/resourcesHome)"/></li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
              <xsl:if test="xproperties/X-BEDEWORK-ALIAS[not(contains(values/text,/bedework/currentCalSuite/resourcesHome))]">
                <xsl:variable name="tagsId">bwTags-<xsl:value-of select="guid"/></xsl:variable>
                <div class="bwEventListOtherGroupTags">
                  <div class="otherTagsControls">
                    <strong><xsl:copy-of select="$bwStr-EvLC-ThisEventCrossTagged"/></strong><br/>
                    <input type="checkbox" name="tagsToggle" id="tagsToggle-{$tagsId}" value="" onclick="toggleVisibility('{$tagsId}','bwOtherTags')"/>
                    <label for="tagsToggle-{$tagsId}"><xsl:copy-of select="$bwStr-EvLC-ShowTagsByOtherGroups"/></label>
                  </div>
                  <ul id="{$tagsId}" class="invisible">
                    <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS[not(contains(values/text,/bedework/currentCalSuite/resourcesHome))]">
                      <li><xsl:value-of select="values/text"/></li>
                    </xsl:for-each>
                  </ul>
                </div>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </xsl:if>
      <!-- Don't list categories for pending -->
      <xsl:if test="not($isPendingQueueTab)">
        <td class="calcat">
          <xsl:if test="categories/category">
            <ul>
              <xsl:for-each select="categories/category">
                <li>
                  <a title = "{$bwStr-EvLs-SelectThisCategory}"
                     onclick = 'setCatFilter(document.getElementById("bwManageEventListControls"), "{href}")'>
                    <xsl:value-of select="value"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </td>
      </xsl:if>
      <td>
        <xsl:choose>
          <!-- submitted by: Use entire value for pending - up to blank for the rest -->
          <xsl:when test="$isPendingQueueTab">
            <xsl:value-of select="xproperties/X-BEDEWORK-SUBMITTEDBY/values/text"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before(xproperties/X-BEDEWORK-SUBMITTEDBY/values/text,' ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="$evlistShowDescription">
        <td class="description">
          <xsl:value-of select="description"/>
        </td>
      </xsl:if><!--
          Lastmod -->
      <td>
        <xsl:value-of select="substring(lastmod,1,4)"/>-<xsl:value-of select="substring(lastmod,5,2)"/>-<xsl:value-of select="substring(lastmod,7,2)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(lastmod,10,2)"/>:<xsl:value-of select="substring(lastmod,12,2)"/> utc
      </td><!--
          Created -->
      <td>
        <xsl:value-of select="substring(created,1,4)"/>-<xsl:value-of select="substring(created,5,2)"/>-<xsl:value-of select="substring(created,7,2)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(created,10,2)"/>:<xsl:value-of select="substring(created,12,2)"/> utc
      </td>
      <td class="statusButtons">
        <xsl:call-template name="changeStatusButtons">
          <xsl:with-param name="status" select="status"/>
          <xsl:with-param name="href" select="$href" />
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>