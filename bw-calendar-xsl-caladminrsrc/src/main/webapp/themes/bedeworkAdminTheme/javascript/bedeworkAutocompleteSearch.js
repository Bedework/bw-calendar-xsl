//
// Implement autocomplete for location and contacts using
// searches of data
//
$(function() {
  // Location autocomplete
  $("#bwLocationSearch").autocomplete({
    minLength: 2,
    appendTo: "#bwLocationSearchResults",
    source: function (request, response) {
      let searchResult = [];
      $.ajax({
        url: '/cal/location/all.gdo',
        method: 'get',
        dataType: 'json',
        contentType: 'application/json',
        data: 'fexpr=loc_all%3d\'' + request.term + '\'',
        success: function (result) {
          if (result !== undefined) {
            if (result.status === 'ok' && result.locations[0]) {
              searchResult = result.locations;
              console.log("found this first: " + searchResult[0].addressField + " - " + searchResult[0].roomField);
              response(searchResult);
            }
          }
        },
        error: function (xhr, status, err) {
          console.error('/cal/location/all.gdo', status, err.toString());
        }
      })
    },
    focus: function (event, ui) {
      // do nothing on focus event
      return false;
    },
    select: function (event, ui) {
      console.log("selected: " + ui.item.href);
      //$(this).val(ui.item.href).removeClass("ui-autocomplete-loading");

      let resultString = ui.item.addressField; // this must exist
      if (ui.item.roomField !== undefined &&
          ui.item.roomField !== "") {
        resultString += " - " + ui.item.roomField;
      }

      $("#bwLocationUid").val(ui.item.uid);
      $("#bwLocationSearch").val(resultString);
      return false;
    }
  }).autocomplete("instance")._renderItem = function (ul, item) {
    let resultString = '<div class="loc-result-address">' + item.addressField + '</div>'; // this must exist
    if (item.roomField !== undefined && item.roomField !== "") {
      resultString += '<div class="loc-result-room">' + item.roomField + '</div>';
    }
    if ((item.street !== undefined && item.street !== "") || (item.city !== undefined && item.city !== "")) {
      resultString += '<div class="loc-result-street-address">';
      if (item.street !== undefined && item.street !== "") {
        resultString += '<span class="loc-result-street">' + item.street;
        if (item.city !== undefined && item.city !== "") {
          resultString += ', ';
        }
        resultString += '</span>';
      }
      if (item.city !== undefined && item.city !== "") {
        resultString += '<span class="loc-result-city">' + item.city + '</span>';
      }
    }

    return $('<li class="loc-result">').append(resultString).appendTo(ul);

  };

  // Contact autocomplete
  $("#bwContactSearch").autocomplete({
    minLength: 2,
    appendTo: "#bwContactSearchResults",
    source: function (request, response) {
      let searchResult = [];
      $.ajax({
        url: '/cal/contact/all.gdo',
        method: 'get',
        dataType: 'json',
        contentType: 'application/json',
        data: 'fexpr=contact_all%3d\'' + request.term + '\'',
        success: function (result) {
          if (result !== undefined) {
            if (result.status === 'ok' && result.contacts[0]) {
              searchResult = result.contacts;
              console.log("found this first: " + searchResult[0].cn.value);
              response(searchResult);
            }
          }
        },
        error: function (xhr, status, err) {
          console.error('/cal/contact/all.gdo', status, err.toString());
        }
      })
    },
    focus: function (event, ui) {
      // do nothing on focus event
      return false;
    },
    select: function (event, ui) {
      console.log("selected: " + ui.item.uid);
      //$(this).val(ui.item.href).removeClass("ui-autocomplete-loading");

      var resultString = ui.item.cn.value; // this must exist

      $("#bwContactUid").val(ui.item.uid);
      $("#bwContactSearch").val(resultString);
      return false;
    }
  }).autocomplete("instance")._renderItem = function (ul, item) {
    var resultString = item.cn.value; // this must exist
    return $("<li>").append("<div>" + resultString + "</div>").appendTo(ul);
  };

});
