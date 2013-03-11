@istest
public class RESTm3PlaceAPITest {

    @istest
    public static void testCanGetPlace() {
        
    }
    
    @istest
    public static void testReturns400WhenGettingPlaceWithMissingIdParameter() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
    
        RESTm3PlaceAPI.get();
        
        System.assertEquals(400,RestContext.response.statusCode);
        System.assertEquals('Missing id parameter in request', System.RestContext.response.responseBody.toString());
    }
    
    @istest
    public static void testReturns404WhenGettingNonExistentPlace() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        req.addParameter('id','a03c0000000zGAyAAM');
    
        RESTm3PlaceAPI.get();
        
        System.assertEquals(404,RestContext.response.statusCode);
        System.assertEquals('Merchant Address with id a03c0000000zGAyAAM could not be found', System.RestContext.response.responseBody.toString());  
    }
    
    @istest
    public static void testCanInsertNewReviewForUnconvertedLead() {

        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead
        Lead lead = util.createLead();
        
        insert lead;
    
        // method under test
        ExternalReferenceSource source = new ExternalReferenceSource();
        source.source_id = '11';
        
        ExternalReference facebookReference = new ExternalReference();
        facebookReference.external_reference_id = '11';
        facebookReference.external_reference_source = source;
        facebookReference.number_of_reviews = 57;
        facebookReference.average_rating = 3.5;
        
        ExternalReferenceSource source2 = new ExternalReferenceSource();
        source2.source_id = '4';
        
        ExternalReference leadReference = new ExternalReference();
        leadReference.external_reference_id = lead.Id;
        leadReference.external_reference_source = source2;
        
        Map<String,ExternalReference> externalReferenceMap = new Map<String,ExternalReference>();
        externalReferenceMap.put('11',facebookReference);
        externalReferenceMap.put('4',leadReference);
        
        Place place = new Place();
        
        place.external_reference_map = externalReferenceMap;
        
        // method under test
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
    
        RESTm3PlaceAPI.put(place);
        
        System.assertEquals(200,RestContext.response.statusCode);
        
        // verify that fields on the place are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals(lead.Id, reviewToCheck.Lead__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
    }
    
    
    
    @istest
    public static void testReturnsUnprocessableEntityIfMissingMerchantLocationInformation () {

        // method under test
        ExternalReferenceSource source = new ExternalReferenceSource();
        source.source_id = '11';
        
        ExternalReference facebookReference = new ExternalReference();
        facebookReference.external_reference_id = '11';
        facebookReference.external_reference_source = source;
        facebookReference.number_of_reviews = 57;
        facebookReference.average_rating = 3.5;
        
        Map<String,ExternalReference> externalReferenceMap = new Map<String,ExternalReference>();
        externalReferenceMap.put('11',facebookReference);
        
        Place place = new Place();
        
        place.external_reference_map = externalReferenceMap;
        
        // method under test
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
    
        RESTm3PlaceAPI.put(place);
        
        System.assertEquals(400,RestContext.response.statusCode);
        
        System.assertEquals('Cannot find lead or merchant address external reference for this place', System.RestContext.response.responseBody.toString());
    }
}