//= require underscore
//= require gmaps
//= require bootstrap-datepicker

//This is the helper function for the click event on the map.
//Removes old marker and adds a new one.
function placeMarker(latLng){
    map.removeMarkers();
    map.addMarker({position:latLng});
    GMaps.geocode({
        latLng: latLng,
        callback: function(results, status) {
            if (status == 'OK') {
                //This is to prevent house numbers appearing, as much as possible.
                //Still occurs sometimes due to ranges of house numbers appearing
                if (parseInt(results[0].address_components[0].long_name)) {
                    var location = results[0].formatted_address.substring(2);
                    //if ($('#location-field').val().length <= 1){
                    $('#location-field').val(location);
                    //}
                } else {
                    var location = results[0].formatted_address;
                    //if ($('#location-field').val().length <= 1){
                    $('#location-field').val(location);
                    //}
                }
            }
        }
    });

    // Fills two hidden fields in the form which is submitted to the controller
    $("#latitude-input").val(latLng.lat());
    $("#longitude-input").val(latLng.lng());
}

//This filters the map by date
function dateFilter() {
    var returnMarkers = []
    if (document.getElementById("date_t").value != "") {
        if (document.getElementById("before").checked && !document.getElementById("after").checked){
            for (i = 0; i < markers.length; i++) {
                if (markers[i].date != "" && new Date(markers[i].date) < new Date(document.getElementById("date_t").value)){
                    returnMarkers.push(markers[i]);
                }
            }
        } else if (document.getElementById("after").checked && !document.getElementById("before").checked){
            for (i = 0; i < markers.length; i++) {
                if (markers[i].date != "" && new Date(markers[i].date) > new Date(document.getElementById("date_t").value)){
                    returnMarkers.push(markers[i]);
                }
            }
        } else if (!document.getElementById("before").checked && !document.getElementById("after").checked) {
            for (i = 0; i < markers.length; i++) {
                if (markers[i].date != "" && new Date(markers[i].date) == new Date(document.getElementById("date_t").value)){
                    returnMarkers.push(markers[i]);
                }
            }
        } else {
            returnMarkers = markers
        }
        map.removeMarkers();
        map.addMarkers(returnMarkers);
    }
}

$(function() {
    $('input.datepicker').data({behaviour: "datepicker"}).datepicker({
        format: "yyyy-mm-dd",
        onSelect: function(date) {
            dateFilter();
        },
        onClose: function(date) {
            dateFilter();
        },
        onClick: function(date) {
            $('before').prop('checked', false);
            $('after').prop('checked', false);
        },
        onChange: function(date) {
            dateFilter();
        }
    });

});

//This filters by type
function selectBox() {
    var returnMarkers = [];
    if (document.getElementById("rec_cb").checked) {
        for (i = 0; i < markers.length; i++) {
            if (markers[i].type == "Recording"){
                returnMarkers.push(markers[i]);
            }
        }
    }
    if (document.getElementById("doc_cb").checked) {
        for (i = 0; i < markers.length; i++) {
            if (markers[i].type == "Document"){
                returnMarkers.push(markers[i]);
            }
        }
    }
    if (document.getElementById("img_cb").checked) {
        for (i = 0; i < markers.length; i++) {
            if (markers[i].type == "Image"){
                returnMarkers.push(markers[i]);
            }
        }
    }
    if (document.getElementById("txt_cb").checked) {
        for (i = 0; i < markers.length; i++) {
            if (markers[i].type == "Text"){
                returnMarkers.push(markers[i]);
            }
        }
    }
    map.removeMarkers();
    map.addMarkers(returnMarkers);
}