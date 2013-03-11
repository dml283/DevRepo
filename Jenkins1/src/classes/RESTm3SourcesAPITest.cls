@IsTest
public class RESTm3SourcesAPITest {

    @istest
    public static void testCanUpdateSources() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestBody = Blob.valueof('[{ "source_id" : "2f17a870-b57b-11e1-bf3d-3c0754656b18", "name" : "yelp", "meta_data" : { "website" : "http://www.yelp.com/", "m3_id" : 7, "salesforce_source_name" : "Yelp" } },{ "source_id" : "30a5e990-b57b-11e1-ad3b-3c0754656b18", "name" : "tripadvisor", "meta_data" : { "website" : "http://www.tripadvisor.com/", "m3_id" : 21, "salesforce_source_name" : "Citygrid" } }]');
        
        RestContext.request = req;
        RestContext.response = res;
    
        RESTm3SourcesAPI.post();
        
        System.assertEquals(200,RestContext.response.statusCode);
        System.assertEquals('{"7":"Yelp","21":"Citygrid"}', System.RestContext.response.responseBody.toString());
    }
    
    @istest
    public static void testCanGetSources() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestBody = Blob.valueof('[{ "source_id" : "2f17a870-b57b-11e1-bf3d-3c0754656b18", "name" : "yelp", "meta_data" : { "website" : "http://www.yelp.com/", "m3_id" : 7, "salesforce_source_name" : "Yelp" } },{ "source_id" : "30a5e990-b57b-11e1-ad3b-3c0754656b18", "name" : "tripadvisor", "meta_data" : { "website" : "http://www.tripadvisor.com/", "m3_id" : 21, "salesforce_source_name" : "Citygrid" } }]');
        
        RestContext.request = req;
        RestContext.response = res;
    
        RESTm3SourcesAPI.post();
        
        
        req = new RestRequest(); 
        res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        RESTm3SourcesAPI.get();
        
        System.assertEquals(200,RestContext.response.statusCode);
        System.assertEquals('{"7":"Yelp","21":"Citygrid"}', System.RestContext.response.responseBody.toString());
    }
}