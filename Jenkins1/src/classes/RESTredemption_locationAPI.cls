@RestResource(urlMapping='/v1.0/redemption_location')

global class RESTredemption_locationAPI{

@HttpGET
global static DealAPI.location getLocation(){
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    DealAPI.location addy;
    address__c a = new address__c();
    string record_id = EncodingUtil.urlDecode(req.params.get('salesforce_id'),'UTF-8'); 
    system.debug('ENDPOINT Request : ' + record_id);
    
    
    try{
    a = [SELECT Street_Line_1__c, Street_Line_2__c, Type__c, Venue_Name__c, state__c, Phone_Number__c, Zip_Postal_Code__c, City__c, country__c, Phone__c, Merchant_Addresses__r.neighborhood__c, Merchant_Addresses__r.Longitude__c, Merchant_Addresses__r.Latitude__c FROM Address__C WHERE id =: record_id LIMIT 1];    
    }catch(exception e){}
    try{
    addy = new DealAPI.location(a);
    }catch(exception e){}
    if(addy.salesforce_id == null){
          res.statusCode = 404;
         }
    return addy;
    }
private static testMethod void myTest() {
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    opportunity o = new opportunity();
    o.name='location api test';
    o.stageName = 'prospecting';
    o.closedate = system.today();
    insert o;
        
    address__c a = new address__c();
    a.opportunity__c = o.id;
    insert a;
    
    req.addParameter('salesforce_id',a.id);
    RestContext.request = req;
    RestContext.response = res;

    DealAPI.location test_location = RESTredemption_locationAPI.getLocation();
    system.assertEquals(test_location.salesforce_id,a.id);

    }        
}