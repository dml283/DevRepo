@RestResource(urlMapping='/v1.0/calendar/status')

global class RESTcalendarStatusAPI{

@HttpGET
global static calendar.status getMyDealStatus(){
    RestRequest req = RestContext.request;
    //string category = EncodingUtil.urlDecode(req.params.get('category'),'UTF-8');
    return calendar.getMyDealStatus();
    

    }
private static testMethod void myTest() {
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    RestContext.request = req;
    RestContext.response = res;
    string endcoded = EncodingUtil.urlencode('Food & Drink','UTF-8');
    RestContext.request.addParameter('category', endcoded);

    }        
}