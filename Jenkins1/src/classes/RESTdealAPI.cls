@RestResource(urlMapping='/v1.0/deal/*')
/*
API Version 1.0
Author: Chris Bland
Support: CBland@groupon.com
Classes included: DealAPI.cls <==where the magic happens

##########
===Methods===
httpGet = Deals?id={SALESFORCE OPPORTUNITY ID}
returns a JSON Obj that is ready for Deal Import
*/

global class RESTdealAPI{
@HttpGet
  global static DealAPI.Deal getDealJSON(RestRequest req, RestResponse res) {
    //get the ID of the Salesforce Opportunity
    string theId = req.params.get('id');
    //Create an instance of the Deals API 
    DealAPI deal_api = new DealAPI();
    //Create an instance of the Deals API Deal Object
    DealAPI.deal deal = new DealAPI.Deal();
    //Call our method and get the Deal
    try{
        deal = deal_api.JSONResponse(theId);
        if(deal.salesforce_id ==null){
          res.statusCode = 404;
          }
         return deal;
        }catch(exception e){
          string ErrorString = 'There was an error with your request and it was: '+e;
          if(deal.salesforce_id ==null){
            res.statusCode = 404;
            }
          return deal;
         }     
  }

}