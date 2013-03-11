@isTest
public class AM_workbenchMerchantTemperatureTest {
  private static User createTestUser(String alias, String email) {
    Profile p = [select id from profile where name='System Administrator'];
    User usr = new User(alias=alias, email=email,
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username=email);
    insert usr;
    return usr;
  }

  private static User createTestAccountManager() {
    return createTestUser('standard', 'standarduser@groupon.com');
  }

  private static User createTestMerchant() {
    return createTestUser('merchant', 'merchantuser@groupon.com');
  }

  private static Account createTestAccount(User usr) {
    Account acct = new Account();
    acct.name = 'testing account';
    acct.Account_Manager__c = usr.id;
    acct.BillingStreet = '123456 test';
    acct.BillingCity = 'Chicago';
    acct.BillingState = 'IL';
    acct.BillingPostalCode = '60640';
    acct.BillingCountry = 'US';
    acct.research_ranking__c = '5';
    acct.Groupon_Scheduler_Strength__c='Deactivated';
    acct.Rewards_Offer_Status__c='Live';
    acct.Now_Category__c ='Stupid Now! Category';
    acct.Sales_Value__c = 02002;

    System.RunAs(usr)
    {
      insert acct;
    }

    return acct;
  }

  private static AM_Workbench.MerchantTemperature getMerchantTempature(Account acct, String createdById, String merchantId) {
    Merchant_Temperature__c merchantTemperatureResult = [SELECT CreatedById, Name, Overall_Experience_Comments__c, Category__c, Overall_Experience_Ranking__c, Merchant_Temperature_Date__c FROM Merchant_Temperature__c WHERE Account__c = :acct.Id];
    AM_Workbench.MerchantTemperature merchantTemperature = new AM_Workbench.MerchantTemperature(merchantTemperatureResult);
    merchantTemperature.Source = merchantTemperature.DetermineSource(createdById, merchantId);
    return merchantTemperature;
  }

  private static Merchant_Temperature__c createMerchantTemperatureData(Account acct) {
    Merchant_Temperature__c merchantTemperature = new Merchant_Temperature__c();
    merchantTemperature.Overall_Experience_Comments__c = 'Test Data';
    merchantTemperature.Overall_Experience_Ranking__c = 10;
    merchantTemperature.Account__c = acct.Id;
    return merchantTemperature;
  }

  static testMethod void nonMerchantTemperatureTest() {
    User usr = createTestAccountManager();
    Account acct = createTestAccount(usr);
    System.RunAs(usr)
    {
      insert createMerchantTemperatureData(acct);
    }
    
    Test.startTest();
    
    AM_Workbench.MerchantTemperature result = getMerchantTempature(acct, usr.id, 'MerchantId');
    System.assertEquals('AM', result.Source);
    
    Test.stopTest();
  }

  static testMethod void merchantTemperatureTest() {
    User merchantUser = createTestMerchant();
    Account acct = createTestAccount(merchantUser);
    String actualMerchantId = merchantUser.id;
    System.RunAs(merchantUser)
    {
      insert createMerchantTemperatureData(acct);
    }
    
    Test.startTest();
    
    AM_Workbench.MerchantTemperature result = getMerchantTempature(acct, merchantUser.id, actualMerchantId);
    System.assertEquals('Merchant', result.Source);
    
    Test.stopTest();
  }
}