@RestResource(urlMapping='/v1.0/m3/sources')

/**
 * The main REST endpoint for Merchant Data Source info.
 *
**/
global class RESTm3SourcesAPI{

    // Get source information
    @HttpGET
    global static void get() {
        RestResponse res = RestContext.Response;
        
        res.responseBody = Blob.valueof(JSON.serialize(ExternalReferenceSource.getAllSourceData()));
        res.StatusCode = 200;
    }

    // Update source information
    @HttpPOST
    global static void post() {
    
        String sourcesJson = RestContext.Request.requestBody.toString();
    
        List<Object> sources = (List<Object>)JSON.deserializeUntyped(sourcesJson);
        
        RestResponse res = RestContext.Response;
        
        res.StatusCode = 200;
        res.responseBody = Blob.valueof(JSON.serialize(ExternalReferenceSource.updateSourceIdMap(sources)));
    }
}