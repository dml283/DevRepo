@isTest
public class RESTMerchantTemperatureAPITest {

  static testMethod void testMerchantTemperaturePOSTReturnsMerchantTemperatureWhenGivenValidCreateRequest() {

    // Given an account
    Account account = LibraryRESTControllerTestHelpers.buildAccount(); 
    insert account;

    // Provide POST params for a MerchantTemperature
    String AccountId = account.Id;
    Integer ranking = 2;
    String comments = 'awesome';
    
    // call the REST controller method
    Merchant_Temperature__c returnedMerchantTemperature = RESTMerchantTemperatureAPI.createNewMerchantTemperature(AccountId, ranking, comments);

    // assertion
    System.assertEquals(ranking, returnedMerchantTemperature.Overall_Experience_Ranking__c );
    System.assertEquals(comments, returnedMerchantTemperature.Overall_Experience_Comments__c );
  }
}