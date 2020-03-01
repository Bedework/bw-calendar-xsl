/*
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
*/

// Specialty output for featured events resources
function writeFeaturedEventsXml() {
  var feXml = "<featuredEvents>\n";
  feXml += "  <featuresOn><![CDATA[" + $("#featuredEventsForm input:radio[name='enabled']:checked").val() + "]]></featuresOn> <!-- true to use features, false to use generic placeholders -->\n";
  feXml += "  <singleMode><![CDATA[" + $("#featuredEventsForm input:radio[name='singleMode']:checked").val() + "]]></singleMode> <!-- true for a single pane (single), false for a triptych (group) -->\n";
  feXml += "  <features>\n";
  feXml += "    <group>\n";
  for(i=1; i < 4; i++) {  
    feXml += "      <image>\n";
    feXml += "        <url><![CDATA[" + $("#featuredEventsForm #image" + i + "-url").val() + "]]></url>\n";
    feXml += "        <link><![CDATA[" + $("#featuredEventsForm #image" + i + "-link").val() + "]]></link>\n";
    feXml += "        <alt><![CDATA[" + $("#featuredEventsForm #image" + i + "-alt").val() + "]]></alt>\n";
    feXml += "        <title><![CDATA[" + $("#featuredEventsForm #image" + i + "-title").val() + "]]></title>\n";
    feXml += "        <caption><![CDATA[" + $("#featuredEventsForm #image" + i + "-caption").val() + "]]></caption>\n";
    feXml += "      </image>\n";
  }
  feXml += "    </group>\n";
  feXml += "    <single>\n";
  feXml += "      <image>\n";
  feXml += "        <url><![CDATA[" + $("#featuredEventsForm #singleImage-url").val() + "]]></url>\n";
  feXml += "        <link><![CDATA[" + $("#featuredEventsForm #singleImage-link").val() + "]]></link>\n";
  feXml += "        <alt><![CDATA[" + $("#featuredEventsForm #singleImage-alt").val() + "]]></alt>\n";
  feXml += "      </image>\n";
  feXml += "    </single>\n";
  feXml += "  </features>\n";
  feXml += "  <generics>\n";
  feXml += "    <group>\n";
  for(i=1; i < 4; i++) {  
    feXml += "      <image>\n";
    feXml += "        <url><![CDATA[" + $("#featuredEventsForm #genImage" + i + "-url").val() + "]]></url>\n";
    feXml += "        <link><![CDATA[" + $("#featuredEventsForm #genImage" + i + "-link").val() + "]]></link>\n";
    feXml += "        <alt><![CDATA[" + $("#featuredEventsForm #genImage" + i + "-alt").val() + "]]></alt>\n";
    feXml += "      </image>\n";
  }
  feXml += "    </group>\n";
  feXml += "  </generics>\n";
  feXml += "</featuredEvents>\n";
  
  $("#resourceContent").val(feXml);
  return true;
}
