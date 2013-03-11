@RestResource(urlMapping='/v1.0/merchant_address')
global class RESTMerchantAddress {

@HttpPost
global static updateResult postMerhantAddress(Merchant_addresses__c merchant_address){
        Database.SaveResult result = Database.Update(merchant_address,false);
        return new UpdateResult(result);
    }
global class updateResult{
    public Merchant_addresses__c merchant_address {get;set;}
    public string status {get;set;}
    public string error {get;set;}
    
    public updateResult(Database.SaveResult result){
       if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                this.error = errs[0].message;
                this.status = 'FAIL';
            }else{
                this.status = 'Success';
                this.merchant_address = [select id, Enrollment_Feedback__c, Enrollment_Status__c, Rewards_Transaction_Qualification_Status__c, Rewards_Transaction_Tracking_Status__c FROM Merchant_addresses__c WHERE id = :result.id LIMIT 1];
            }
    }    
 }
}