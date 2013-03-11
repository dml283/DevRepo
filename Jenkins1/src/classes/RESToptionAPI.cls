@RestResource(urlMapping='/v1.0/deal/option/*')
/*
API Version 1.0
Author: Chris Bland
Support: CBland@groupon.com
Classes included: DealAPI.cls <==where the magic happens

##########
===Methods===
httpGet = /deal/option?id= salesforce opportunity || salesforce option id
returns a JSON Obj that is ready for Deal Import
*/

global class RESToptionAPI{
@HttpGet
  global static DealAPI.Option getDealJSON(RestRequest req, RestResponse res) {
  
    //get the ID of the Salesforce Opportunity
    string theId = req.params.get('id');
    
    //Create an instance of the Deals API 
    DealAPI deal_api = new DealAPI();
    //Create an instance of the Deals API Deal Object
    DealAPI.Option option = new DealAPI.Option();
    //Call our method and get the Deal
    try{
            option = deal_api.getOptionById(theId);
            if(option.salesforce_id ==null){
               res.statusCode = 404;
               }
            return option;
        }catch(exception e){
                            if(option.salesforce_id ==null){
                               res.statusCode = 404;
                              }
                            return option;
                            }     
  }

}