@RestResource(urlMapping='/v1.0/merchant/salesforce/*')
/*
API Version 1.0
Author: Chris Bland
Support: CBland@groupon.com
Classes included: 
##########
===Methods===

*/

global class RESTmerchantAPIv_10{
@HttpGet
  global static MerchantAPI.merchant getMerchant(RestRequest req, RestResponse res) {
  
    //get the ID of the Salesforce Opportunity
    string theId = req.params.get('account_id');
    
    //Create an instance of the Merchant API 
    MerchantAPI api = new MerchantAPI();
    MerchantAPI.merchant merchant = MerchantAPI.getMerchant(theId);
    //Create an instance of the Deals API Deal Object
    //Call our method and get the Deal
    try{
            return merchant;
        }catch(exception e){
                            string ErrorString = 'There was an error with your request and it was: '+e;
                            return merchant;
                            }     
  }

}