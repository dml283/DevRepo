/*
* ===================================================================
* RESTPaymentsAPI.cls
* @author.....: 
* @email......: 
* @date.......: 
* @Last Change: Added permalink modification change by Dharmesh on 03/05/2013
* Description.: REST service to update payment status and permalink on Account
* @param......: salesforce_id, payment_status or permalink
* @return.....: Account Object
* ===================================================================
*/

@RestResource(urlMapping='/v1.0/merchant/payment-status/*')

global class RESTpaymentsAPI{

/** Class Modfied by :Dharmesh Gohil to accomodate REST request to update the permalink/merchant_key
    This method is called from the MasterMerchant using REST. There are two different methods in mastermechant calling this method
    1) to update the payment status 
    2) to update the permalink which is merchant key in mastermerchant
    
**/
@HttpPOST
global static account addPaymentStatus(){
     RestRequest req = RestContext.request;
     RestResponse res = new RestResponse();
     Account a = new Account();
     string theId;
     string paymentStatus;
     String merchantKey; // this will be the permalink in salesforce
     if(req.params.containsKey('salesforce_id')&& (req.params.containsKey('payment_status')
                                                 ||req.params.containsKey('merchant_key'))){
         theId = EncodingUtil.urlDecode(req.params.get('salesforce_id'),'UTF-8');
         a = [select id, Payments_Product_Sales_Status__c,Merchant_Permalink__c from Account where ID = :theId];
         if(req.params.containsKey('payment_status')){
            paymentStatus = EncodingUtil.urlDecode(req.params.get('payment_status'),'UTF-8');
            a.Payments_Product_Sales_Status__c = paymentStatus;
         }
         if(req.params.containsKey('merchant_key')){
            merchantKey = EncodingUtil.urlDecode(req.params.get('merchant_key'),'UTF-8');
            a.Merchant_Permalink__c=merchantKey;
         }
         try{
             update a;
             }catch(exception e){
                 res.statusCode=500;
             }
         }else{
            res.statusCode=400;
         }
     RestContext.response = res;    
     return a;
    }
}