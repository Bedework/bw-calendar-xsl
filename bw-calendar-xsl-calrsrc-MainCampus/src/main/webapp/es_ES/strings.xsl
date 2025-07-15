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

  <!-- Most text exposed by the stylesheets is set here. -->
  <!-- To change the language of a web client, translate the strings file. -->

  <xsl:variable name="bwStr-Root-PageTitle">Agenda de Eventos Bedework</xsl:variable>
  <xsl:variable name="bwStr-Error">Error:</xsl:variable>
  <xsl:variable name="bwStr-Error-NoPage">No hay ninguna página para visualizar</xsl:variable>
  <xsl:variable name="bwStr-Error-PageNotDefined">La Página "<xsl:value-of select="/bedework/appvar[key='page']/value"/>" no está definida.</xsl:variable>
  <xsl:variable name="bwStr-Error-IframeUnsupported">Su navegador no soporta marcos.</xsl:variable>
  <xsl:variable name="bwStr-Error-NoScript">Su navegador no soporta JavaScript!</xsl:variable>

  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-SiteTitle">Agenda Pública BEDEWORK</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Página de Inicio de la Universidad</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Otro Enlace</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExportSubscribe">Exportar/Suscribirse</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">Información del Evento</xsl:variable>
  <xsl:variable name="bwStr-HdBr-BackLink">(volver a los eventos)</xsl:variable>

  <!-- ongoing events -->
  <xsl:variable name="bwStr-Ongoing-Title">Eventos Activos</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-NoEvents">No hay eventos activos en este intervalo de tiempo o en esta vista</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-Ends">Termina</xsl:variable>

  <!-- deadlines -->
  <xsl:variable name="bwStr-Deadline-Title">Fechas límite</xsl:variable>
  <xsl:variable name="bwStr-Deadline-NoEvents">No hay fechas límite en este intervalo de tiempo o en esta vista</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">conectado como</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">desconectar</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Today">HOY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">PRÓXIMOS</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DÍA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">SEMANA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MES</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">AÑO</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Search">buscar</xsl:variable>
  <xsl:variable name="bwStr-Tabs-AdvSearch">avanzada</xsl:variable>
  <xsl:variable name="bwStr-Tabs-JumpToDate">Jump To Date</xsl:variable>

  <!--  xsl:template name="datePicker" -->
  <xsl:variable name="bwStr-DatePicker-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Upcoming">próximos</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Range">rango</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Day">día</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Week">semana</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Month">mes</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-StartDate">Fecha de inicio:</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Menu">menú</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Semana de</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-SearchForEvents">Búsqueda de eventos:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ApplyFilter">aplicar filtro</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">CAL</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">SUMARIO</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETALLES</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Summary">Sumario</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Details">Detalles</xsl:variable>

  <!--  xsl:template name="leftColumnText" -->
  <xsl:variable name="bwStr-LCol-DownloadCalendars">Descargar Calendarios</xsl:variable>
  <xsl:variable name="bwStr-LCol-Options">OPCIONES:</xsl:variable>
  <xsl:variable name="bwStr-LCol-ManageEvents">Gestionar Eventos</xsl:variable>
  <xsl:variable name="bwStr-LCol-Submit">Enviar un Evento</xsl:variable>
  <xsl:variable name="bwStr-LCol-Help">Ayuda</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EventLink">Evento Enlace:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">Cuándo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Hora flotante (Floating time)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Hora local</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Fin:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DueBy">Gracias a</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">añadir a mi agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Añadir a MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToFacebook">Añadir a Facebook</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToGoogleCalendar">Añadir a Google Calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Dónde:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Location-Accessible">This venue is wheelchair accessible</xsl:variable> <!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Location-Map">map</xsl:variable><!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Estado:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Coste:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">Ver:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-VirtualReg">Virtual Registration Link:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comentarios:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Etiquetas:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Áreas Temáticas:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendars">Agendas:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No se han encontrado eventos. Por favor, inténtelo con una vista o un intervalo de tiempo distintos.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplayWithOngoing">No se han encontrado eventos inactivos. Por favor, inténtelo con una vista o un intervalo de tiempo distintos en la lista de eventos activos.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsFromSelection">Su selección no devuelve resultados.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">añadir...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">Todo el Día</xsl:variable>
  <xsl:variable name="bwStr-LsVw-At">a las</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Hoy</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Añadir a MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForCal">Mostrando Eventos para la Agenda</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForView">Mostrando Eventos para la Vista</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ShowAll">(mostrar todas)</xsl:variable>
  <xsl:variable name="bwStr-LsVw-TopicalArea">Áreas Temáticas:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Cost">Coste:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Link">Enlace:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ListWithinTimeRange">Lista de eventos dentro de un rango de tiempo</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Event">evento</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Events">eventos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">Siguientes 7 Días</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No eventos para mostrar.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ContinueFrom">Continue from </xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-ShowMore">Show more events</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ReturnToToday">Return to Today</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-Calendars">Agendas:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearFilters">(borrar toda)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Filter">Filtro:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearSearch">(borrar)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">INTENTO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-EventList">Lista de Eventos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Upcoming">Próximos Eventos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Starting">A partir</xsl:variable>

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">INTENTO:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(cont)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">todo el día:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Hora:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">todo el día</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Área Temática:</xsl:variable>

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-DownloadCalendars">Download Calendars</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectCalendar">Seleccionar una agenda para descargar sus eventos en formato ical.</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Exportar la Agenda en formato iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Exportando:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">rango de fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Inicio:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Fin:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">exportar</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limitar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">fechas pasadas</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResults">Resultados de la Búsqueda</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoQuery">no hay consulta</xsl:variable>
  <xsl:variable name="bwStr-Srch-Result">resultado</xsl:variable>
  <xsl:variable name="bwStr-Srch-Results">resultados</xsl:variable>
  <xsl:variable name="bwStr-Srch-ReturnedFor">devueltos para:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Rank">Rango</xsl:variable>
  <xsl:variable name="bwStr-Srch-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Sumario</xsl:variable>
  <xsl:variable name="bwStr-Srch-Pages">Página:</xsl:variable>
  <xsl:variable name="bwStr-Srch-AdvancedSearch">Búsqueda Avanzada</xsl:variable>
  <xsl:variable name="bwStr-Srch-CatsToSearch">Seleccionar Categorías a Buscar (Opcional)</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchTermNotice">No es necesario un término de búsqueda si se ha seleccionado al menos una categoría.</xsl:variable>

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">Estadísticas del Sistema</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Colección de estadísticas:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">activar</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">desactivar</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">recopilar estadísticas</xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">volcar estadísticas al log</xsl:variable>

  <!--  xsl:template name="exportSubscribe" -->
  <xsl:variable name="bwStr-exSu-ExportSubscribe">Export / Subscribe</xsl:variable>
  <xsl:variable name="bwStr-exSu-CurrentFiltersColon">Current Filters:</xsl:variable>
  <xsl:variable name="bwStr-exSu-FeedOrWidget">Event feed or embeddable widget?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Feed">Feed</xsl:variable>
  <xsl:variable name="bwStr-exSu-Widget">Widget (code to copy and paste onto a website)</xsl:variable>
  <xsl:variable name="bwStr-exSu-DataFormat">Data format?</xsl:variable>
  <xsl:variable name="bwStr-exSu-HTMLList">HTML list (copy &amp; paste into Word, etc.)</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCount">Event count</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCountTotal">Total number of events returned:</xsl:variable>
  <xsl:variable name="bwStr-exSu-IncludeDownloadLink">Include download link?</xsl:variable>
  <xsl:variable name="bwStr-exSu-True">True</xsl:variable>
  <xsl:variable name="bwStr-exSu-False">False</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDetailsOrSummary">Show details or summary?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Details">Details</xsl:variable>
  <xsl:variable name="bwStr-exSu-Summary">Summary</xsl:variable>
  <xsl:variable name="bwStr-exSu-Timeframe">Time frame</xsl:variable>
  <xsl:variable name="bwStr-exSu-UseDefaultListing">Use the default listing, limit the number of days (from the current date), or provide a start date and an end date.</xsl:variable>
  <xsl:variable name="bwStr-exSu-Default">Default</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitTo">Limit to</xsl:variable>
  <xsl:variable name="bwStr-exSu-DaysFromToday">days from "today"</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeColon">Date Range:</xsl:variable>
  <xsl:variable name="bwStr-exSu-StartDateColon">Start Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-EndDateColon">End Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeNote">Note: Event count takes precedence over date range!</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetOptions">Widget Options</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitEvents">Limit the number of events listed?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultFalse">(default: false)</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitToColon">Limit to:</xsl:variable>
  <xsl:variable name="bwStr-exSu-Events">events</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowTitle">Show a title above event list?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultTrue">(default: true)</xsl:variable>
  <xsl:variable name="bwStr-exSu-TitleColon">Title:</xsl:variable>
  <xsl:variable name="bwStr-exSu-UpcomingEvents">Upcoming Events</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultUpcomingEvents">(default: "Upcoming Events")</xsl:variable>
  <xsl:variable name="bwStr-exSu-HighlightDatesOrTitles">Highlight event dates or event titles?</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByTitle">By title</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByDate">By date</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultByTitle">(default 'by title')</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDescription">Show description in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayEndDate">Display end date in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTime">Display time in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayLocation">Display location in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayDetailsInline">Display event details inline?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayContact">Display contact in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayCost">>Display cost in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTags">Display tags in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTimezone">Display timezone in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-URL">Your URL:</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetCode">Widget Code:</xsl:variable>
  <xsl:variable name="bwStr-exSu-Close">Close</xsl:variable>

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basado en el</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Sistema de Agenda Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Ejemplos en Producción</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Mostrar XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">Refrescar XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-Credits">Este tema está basado en el trabajo de las Universidades Duke y Yale, agradeciendo igualmente la colaboración de la Universidad de Chicago</xsl:variable>

</xsl:stylesheet>
