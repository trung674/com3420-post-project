//= require underscore
//= require gmaps


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