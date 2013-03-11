@isTest
public class AM_workbenchSearchTest {
  static testMethod void searchMerchantsDelegateToGetMerchantList() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'testing account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Test.startTest();

      List<AM_workbench.Merchant> merchants = AM_workbench.searchMerchants('testing account');
      System.assertEquals(a.id, merchants[0].id);

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithMerchantSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'testing account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('testing account');
      System.assertEquals(a.id, merchants[0].id);

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithNoMerchantSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'testing account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('xyz');
      System.assertEquals(0, merchants.size());

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListWithDealSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Opportunity o = new Opportunity();
      o.name = 'opportunity';
      List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'GrouponLive'];
      if (recordTypes.size() > 0) {
        o.RecordTypeId = recordTypes[0].id;
      }
      o.AccountId = a.id;
      o.StageName = 'Closed Won';
      o.CloseDate = system.today().addDays(-32);
      o.feature_date__c = system.today().addDays(-1);
      o.feature_end_date__c = system.today().addDays(3);
      o.Category__c = 'Health & Beauty';
      o.city_manager__c = null;
      o.divisional_sales_manager__c = NULL;
      o.user__c = NULL;
      o.unit_buy_price__c = 15;
      o.TotalOpportunityQuantity = 5;
      o.unit_sell_price__c = 10;
      o.deal_strengh__c = 'CP Needs Info';
      o.AccountCoordinator__c = u1.id;
      insert o;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('opportunity');
      System.assertEquals(a.id, merchants[0].id);

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithNoDealSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;     

      Opportunity o = new Opportunity();
      o.name = 'opportunity';
      List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'GrouponLive'];
      if (recordTypes.size() > 0) {
        o.RecordTypeId = recordTypes[0].id;
      }
      o.AccountId = a.id;
      o.StageName = 'Closed Won';
      o.CloseDate = system.today().addDays(-32);
      o.feature_date__c = system.today().addDays(-1);
      o.feature_end_date__c = system.today().addDays(3);
      o.Category__c = 'Health & Beauty';
      o.city_manager__c = null;
      o.divisional_sales_manager__c = NULL;
      o.user__c = NULL;
      o.unit_buy_price__c = 15;
      o.TotalOpportunityQuantity = 5;
      o.unit_sell_price__c = 10;
      o.deal_strengh__c = 'CP Needs Info';
      o.AccountCoordinator__c = u1.id;
      insert o;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('xyz');
      System.assertEquals(0, merchants.size());

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithContactNumberSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Contact c = new Contact();
      c.FirstName = 'John';
      c.LastName = 'Smith';
      c.Phone = '(123)123-1234';
      c.AccountId = a.Id;
      insert c;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('(123)123-1234');
      System.assertEquals(a.id, merchants[0].id);

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithNoContactNumberSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Contact c = new Contact();
      c.FirstName = 'John';
      c.LastName = 'Smith';
      c.Phone = '(123)123-1234';
      c.AccountId = a.Id;
      insert c;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('(123)123-1235');
      System.assertEquals(0, merchants.size());

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithContactNameSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Contact c = new Contact();
      c.FirstName = 'John';
      c.LastName = 'Contact';
      c.Phone = '(123)123-1234';
      c.AccountId = a.Id;
      insert c;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('Contact');
      System.assertEquals(a.id, merchants[0].id);

      Test.stopTest();
    }
  } 

  static testMethod void getMerchantListWithNoContactNameSearchResult() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      Account a = new Account();
      a.name = 'account';
      a.Account_Manager__c = u1.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c = 02002;
      insert a;

      Contact c = new Contact();
      c.FirstName = 'John';
      c.LastName = 'Contact';
      c.Phone = '(123)123-1234';
      c.AccountId = a.Id;
      insert c;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList('Smith');
      System.assertEquals(0, merchants.size());

      Test.stopTest();
    }
  } 
}