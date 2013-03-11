@RestResource(urlMapping='/v1.0/merchant_temperature')
global class RESTMerchantTemperatureAPI {

@HttpPost
global static Merchant_Temperature__c createNewMerchantTemperature(String AccountId, Integer ranking, String comments) {
     System.debug('Temperature ranking: '+ranking);
     System.debug('Temperature comments: '+comments);
     String CleansedAccountId = EncodingUtil.urlDecode(AccountId, 'UTF-8');
        
     Merchant_Temperature__c temp = new Merchant_Temperature__c();
     temp.Account__c = CleansedAccountId;
     temp.Overall_Experience_Comments__c = comments;
     temp.Overall_Experience_Ranking__c = ranking;
     temp.Merchant_Temperature_Date__c = Date.today();
     insert temp;
     
     return temp;
    
  }
}