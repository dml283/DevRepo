@RestResource(urlMapping='/v1.0/m3/place')

/**
 * The main REST endpoint for Merchant Data Places / Salesforce Merchant locations.
 *
 * Contact Taylor Raack or Chris Bland for support
**/
global class RESTm3PlaceAPI{

    // Get place information
    
    @HttpGET
    global static Place get() {
        Place place = null;
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        
        if(req.params.containsKey('id')) {
            // if we have an id, grab the place by that id
            place = new Place(req.params.get('id'));
            if(place.preExistingMerchantAddress == null) {
                res.StatusCode = 404;
                res.responseBody = Blob.valueof('Merchant Address with id ' + req.params.get('id') + ' could not be found');
            }
        } else {
            // if no id, then return Not Found
            res.StatusCode = 400;
            res.responseBody = Blob.valueof('Missing id parameter in request');
        }
        return place;
    }
    
    
    // Update place information
    @HttpPOST
    global static void put(Place place) {
        RestResponse res = RestContext.Response;
    
        // the place object json fields will be populated automatically via Salesforce
        
        if(place != null) {
            String error = place.save();
            if(error == null) {
                res.StatusCode = 200;
            } else {
                res.StatusCode = 400;
                res.responseBody = Blob.valueof(error);
            }
        } else {
            res.StatusCode = 400;
            res.responseBody = Blob.valueof('No place object sent in request');
        }
    }
}