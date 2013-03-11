@isTest
public class AM_workbenchUnitTest {
  public static Account buildAccount(User u) {
    Account a = new Account();
    a.name = 'testing account';
    a.Account_Manager__c = u.id;
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
    return a;
  }

  public static Opportunity buildOpportunity(Account a) {
    Opportunity o = new Opportunity();
    o.name = 'test oppty';
    List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'];
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
    return o;
  }

  static testMethod void mapAccountWithFeatureDateTest() {
    AM_workbench workbench = new AM_workbench();

    Map<Date, List<Account>> accountMap = new Map<Date, List<Account>>();
    Account account = new Account();
    Date oldFeatureDate = System.today().addDays(-1);
    Date newFeatureDate = System.today().addDays(1);
    List<Date> dates = new List<Date>();
    dates.add(oldFeatureDate);
    dates.add(newFeatureDate);
    workbench.mapAccountWithFeatureDate(account, dates, accountMap);

    System.assertEquals(true, accountMap.containsKey(newFeatureDate));
    System.assertEquals(false, accountMap.containsKey(oldFeatureDate));
  }

  static testMethod void getMerchantTaskFactoryTest() {
     AM_workbenchTaskFactory.FactoryInterface factory = AM_workbench.getMerchantTaskFactory();
     System.assert(factory != null);
  }

  static testMethod void isProductionTest() {
    System.assert(AM_workbench.isProduction(UserInfo.getOrganizationId()) != null);
  }

  static testMethod void userTest() {
    System.assert(UserInfo.getUserId() == AM_workbench.getUser());
  }

  static testMethod void onlyDisplayTopDealTest() {
    Account a = new Account();
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    List<Opportunity> opportunities = new List<Opportunity>();
    Opportunity old = new Opportunity(Feature_Date__c = System.today());
    Opportunity older = new Opportunity(Feature_Date__c = System.today().addDays(-1));
    opportunities.add(old);
    opportunities.add(older);
    m.addG1Deals(opportunities);
    System.assertEquals(true, m.g1deals[0].display);
    System.assertEquals(false, m.g1deals[1].display);
  }

  static testMethod void sortRecentDealsTest() {
    List<AM_workbench.g1> g1deals = new List<AM_workbench.g1>();
    Account a = new Account();
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    List<Opportunity> opportunities = new List<Opportunity>();
    Opportunity o = new Opportunity();

    AM_workbench.g1 todays = new AM_workbench.g1(o, false);
    todays.featureDate = System.today().format();
    AM_workbench.g1 tomorrows = new AM_workbench.g1(o, false);
    tomorrows.featureDate = System.today().addDays(1).format();
    g1deals.add(todays);
    g1deals.add(tomorrows);

    g1deals.sort();

    System.assertEquals(todays.featureDate, g1deals[0].featureDate);
    System.assertEquals(tomorrows.featureDate, g1deals[1].featureDate);
  }

  static testMethod void sortOldDealsTest() {
    List<AM_workbench.g1> g1deals = new List<AM_workbench.g1>();
    Account a = new Account();
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    List<Opportunity> opportunities = new List<Opportunity>();
    Opportunity o = new Opportunity();

    AM_workbench.g1 old = new AM_workbench.g1(o, false);
    old.featureDate = System.today().addDays(-1).format();
    AM_workbench.g1 older = new AM_workbench.g1(o, false);
    older.featureDate = System.today().addDays(-2).format();
    g1deals.add(old);
    g1deals.add(older);

    g1deals.sort();

    System.assertEquals(old.featureDate, g1deals[0].featureDate);
    System.assertEquals(older.featureDate, g1deals[1].featureDate);
  }

  static testMethod void sortDealsTest() {
    List<AM_workbench.g1> g1deals = new List<AM_workbench.g1>();

    List<Opportunity> opportunities = new List<Opportunity>();
    Opportunity o = new Opportunity();

    AM_workbench.g1 twoDaysAgo = new AM_workbench.g1(o, false);
    twoDaysAgo.featureDate = System.today().addDays(-2).format();

    AM_workbench.g1 yesterday = new AM_workbench.g1(o, false);
    yesterday.featureDate = System.today().addDays(-1).format();

    AM_workbench.g1 today = new AM_workbench.g1(o, false);
    today.featureDate = System.today().format();

    AM_workbench.g1 tomorrow = new AM_workbench.g1(o, false);
    tomorrow.featureDate = System.today().addDays(1).format();

    AM_workbench.g1 weekFromNow = new AM_workbench.g1(o, false);
    weekFromNow.featureDate = System.today().addDays(7).format();

    AM_workbench.g1 nullDay = new AM_workbench.g1(o, false);
    nullDay.featureDate = null;

    g1deals.add(twoDaysAgo);
    g1deals.add(yesterday);
    g1deals.add(today);
    g1deals.add(tomorrow);
    g1deals.add(weekFromNow);
    g1deals.add(nullDay);

    g1deals.sort();

    System.assertEquals(today.featureDate, g1deals[0].featureDate);
    System.assertEquals(tomorrow.featureDate, g1deals[1].featureDate);
    System.assertEquals(weekFromNow.featureDate, g1deals[2].featureDate);
    System.assertEquals(nullDay.featureDate, g1deals[3].featureDate);
    System.assertEquals(yesterday.featureDate, g1deals[4].featureDate);
    System.assertEquals(twoDaysAgo.featureDate, g1deals[5].featureDate);
  }

  static testMethod void getMerchantListInNext10OrderWithPriority() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a1 = buildAccount(u);
      Account a2 = buildAccount(u);

      Opportunity o = buildOpportunity(a1);
      Opportunity o2 = buildOpportunity(a2);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a1));
      merchants.add(new AM_workbench.Merchant(a2));
      AM_workbench.g1 d1 = new AM_workbench.g1(o, true);
      d1.featureDate = System.today().addDays(6).format();
      AM_workbench.g1 d2 = new AM_workbench.g1(o2, true);
      d2.featureDate = System.today().addDays(-1).format();
      merchants[0].g1deals.add(d1);
      merchants[1].g1deals.add(d2);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals(1, orderedMerchants[0].nextOrder);
      System.assertEquals(2, orderedMerchants[1].nextOrder);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListOnlyInNext10Order() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a1 = buildAccount(u);
      Account a2 = buildAccount(u);
      Account a3 = buildAccount(u);

      Opportunity o = buildOpportunity(a1);
      Opportunity o2 = buildOpportunity(a2);
      Opportunity o3 = buildOpportunity(a3);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a1));
      merchants.add(new AM_workbench.Merchant(a2));
      merchants.add(new AM_workbench.Merchant(a3));

      AM_workbench.g1 d1 = new AM_workbench.g1(o, true);
      d1.featureDate = System.today().addDays(6).format();
      AM_workbench.g1 d2 = new AM_workbench.g1(o2, true);
      d2.featureDate = System.today().addDays(5).format();
      AM_workbench.g1 d3 = new AM_workbench.g1(o3, true);
      d3.featureDate = System.today().addDays(5).format();

      merchants[0].g1deals.add(d1);
      merchants[1].g1deals.add(d2);
      merchants[2].g1deals.add(d3);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals(1, orderedMerchants[0].nextOrder);
      System.assertEquals(2, orderedMerchants[1].nextOrder);
      System.assertEquals(3, orderedMerchants[2].nextOrder);

      System.assertEquals(System.today().addDays(5), orderedMerchants[0].dateToSort);
      System.assertEquals(System.today().addDays(5), orderedMerchants[1].dateToSort);
      System.assertEquals(System.today().addDays(6), orderedMerchants[2].dateToSort);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListInNext10OrderUseFirstFeatureDate() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a1 = buildAccount(u);
      Account a2 = buildAccount(u);

      Opportunity o = buildOpportunity(a1);
      Opportunity o2 = buildOpportunity(a2);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a1));
      merchants.add(new AM_workbench.Merchant(a2));

      AM_workbench.g1 d1 = new AM_workbench.g1(o, true);
      d1.featureDate = System.today().addDays(2).format();
      AM_workbench.g1 d2 = new AM_workbench.g1(o2, true);
      d2.featureDate = System.today().addDays(1).format();
      AM_workbench.g1 d3 = new AM_workbench.g1(o2, true);
      d3.featureDate = System.today().addDays(3).format();

      merchants[0].g1deals.add(d1);
      merchants[1].g1deals.add(d2);
      merchants[1].g1deals.add(d3);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals(1, orderedMerchants[0].nextOrder);
      System.assertEquals(2, orderedMerchants[1].nextOrder);

      System.assertEquals(System.today().addDays(1), orderedMerchants[0].dateToSort);
      System.assertEquals(System.today().addDays(2), orderedMerchants[1].dateToSort);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListInLast10OrderWithPriority() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a1 = buildAccount(u);
      Account a2 = buildAccount(u);

      Opportunity o = buildOpportunity(a1);
      Opportunity o2 = buildOpportunity(a2);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a1));
      merchants.add(new AM_workbench.Merchant(a2));
      AM_workbench.g1 d1 = new AM_workbench.g1(o, true);
      d1.featureDate = System.today().addDays(-6).format();
      AM_workbench.g1 d2 = new AM_workbench.g1(o2, true);
      d2.featureDate = System.today().addDays(1).format();
      merchants[0].g1deals.add(d1);
      merchants[1].g1deals.add(d2);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals(1, orderedMerchants[1].lastOrder);
      System.assertEquals(2, orderedMerchants[0].lastOrder);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListOnlyInLast10Order() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a1 = buildAccount(u);
      Account a2 = buildAccount(u);
      Account a3 = buildAccount(u);

      Opportunity o = buildOpportunity(a1);
      Opportunity o2 = buildOpportunity(a2);
      Opportunity o3 = buildOpportunity(a3);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a1));
      merchants.add(new AM_workbench.Merchant(a2));
      merchants.add(new AM_workbench.Merchant(a3));

      AM_workbench.g1 d1 = new AM_workbench.g1(o, true);
      d1.featureDate = System.today().addDays(-6).format();
      AM_workbench.g1 d2 = new AM_workbench.g1(o2, true);
      d2.featureDate = System.today().addDays(-5).format();
      AM_workbench.g1 d3 = new AM_workbench.g1(o3, true);
      d3.featureDate = System.today().addDays(-5).format();

      merchants[0].g1deals.add(d1);
      merchants[1].g1deals.add(d2);
      merchants[2].g1deals.add(d3);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);

      System.assertEquals(1, orderedMerchants[0].priorityOrder);
      System.assertEquals(2, orderedMerchants[1].priorityOrder);
      System.assertEquals(3, orderedMerchants[2].priorityOrder);

      System.assertEquals(1, orderedMerchants[0].nextOrder);
      System.assertEquals(2, orderedMerchants[1].nextOrder);
      System.assertEquals(3, orderedMerchants[2].nextOrder);

      System.assertEquals(3, orderedMerchants[0].lastOrder);
      System.assertEquals(1, orderedMerchants[1].lastOrder);
      System.assertEquals(2, orderedMerchants[2].lastOrder);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListOnlyG1AndGLiteTypeOpportunities() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      List<RecordType> recordTypes = new List<RecordType>();

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

      Opportunity o = new Opportunity();
      o.name = 'test oppty';
      recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'];
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
      insert o;

      Opportunity lite = new Opportunity();
      lite.name = 'test oppty';
      recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'gLite'];
      if (recordTypes.size() > 0) {
        lite.RecordTypeId = recordTypes[0].id;
      }
      lite.AccountId = a.id;
      lite.StageName = 'Closed Won';
      lite.CloseDate = system.today().addDays(-32);
      lite.feature_date__c = system.today().addDays(-1);
      lite.feature_end_date__c = system.today().addDays(3);
      lite.Category__c = 'Health & Beauty';
      lite.city_manager__c = null;
      lite.divisional_sales_manager__c = NULL;
      lite.user__c = NULL;
      lite.unit_buy_price__c = 15;
      lite.TotalOpportunityQuantity = 5;
      lite.unit_sell_price__c = 10;
      lite.deal_strengh__c = 'CP Needs Info';
      insert lite;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      Set<Id> opportunityIds = new Set<Id>();
      for (AM_workbench.g1 g : merchants[0].g1deals) {
        opportunityIds.add(g.id);
      }

      System.assert(opportunityIds.contains(o.id));
      System.assert(opportunityIds.contains(lite.id));

      Test.stopTest();
    }
  }

  static User sharedUser;
  static Account sharedAccount;
  static Opportunity sharedOpportunity;

  static void setupDateTest() {
    Profile p = [select id from profile where name='System Administrator'];

    sharedUser = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert sharedUser;

    sharedAccount = new Account();
    sharedAccount.Name = 'testing account';
    sharedAccount.Account_Manager__c = sharedUser.id;
    sharedAccount.BillingStreet = '123456 test';
    sharedAccount.BillingCity = 'Chicago';
    sharedAccount.BillingState = 'IL';
    sharedAccount.BillingPostalCode = '60640';
    sharedAccount.BillingCountry = 'US';
    sharedAccount.Research_Ranking__c = '5';
    sharedAccount.Groupon_Scheduler_Strength__c='Deactivated';
    sharedAccount.Rewards_Offer_Status__c='Live';
    sharedAccount.Now_Category__c ='Stupid Now! Category';
    sharedAccount.Sales_Value__c = 02002;
    insert sharedAccount;

    sharedOpportunity = new Opportunity();
    sharedOpportunity.Name = 'test oppty';

    List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'];
    if (recordTypes.size() > 0) {
      sharedOpportunity.RecordTypeId = recordTypes[0].id;
    }

    sharedOpportunity.AccountId = sharedAccount.id;
    sharedOpportunity.StageName = 'Closed Won';
    sharedOpportunity.CloseDate = System.today().addDays(-32);
    sharedOpportunity.Category__c = 'Health & Beauty';
    sharedOpportunity.Unit_Buy_Price__c = 15;
    sharedOpportunity.TotalOpportunityQuantity = 5;
    sharedOpportunity.Unit_Sell_Price__c = 10;
    sharedOpportunity.Deal_Strengh__c = 'CP Needs Info';
  }

  static testMethod void getMerchantListWithinFeatureMinDateAndWithinExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = System.today().addDays(-364);
    sharedOpportunity.Groupon_Expiration_Date__c = System.today().addDays(-89);
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();

      Set<Id> opportunityIds = new Set<Id>();
      for (AM_workbench.g1 g : merchants[0].g1deals) {
        opportunityIds.add(g.Id);
      }

      System.assertEquals(true, opportunityIds.contains(sharedOpportunity.Id));
    }
  }

  static testMethod void getMerchantListWithinFeatureMinDateAndOutsideExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = System.today().addDays(-364);
    sharedOpportunity.Groupon_Expiration_Date__c = System.today().addDays(-92);
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assert(merchants.isEmpty());
    }
  }

  static testMethod void getMerchantListWithinFeatureMinDateAndNullExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = System.today().addDays(-364);
    sharedOpportunity.Groupon_Expiration_Date__c = NULL;
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();

      Set<Id> opportunityIds = new Set<Id>();
      for (AM_workbench.g1 g : merchants[0].g1deals) {
        opportunityIds.add(g.Id);
      }

      System.assertEquals(true, opportunityIds.contains(sharedOpportunity.id));
    }
  }

  static testMethod void getMerchantListOutsideFeatureMinDateAndWithinExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = System.today().addDays(-366);
    sharedOpportunity.Groupon_Expiration_Date__c = System.today().addDays(-89);
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assert(merchants.isEmpty());
    }
  }

  static testMethod void getMerchantListOutsideFeatureMinDateAndOutsideExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = System.today().addDays(-366);
    sharedOpportunity.Groupon_Expiration_Date__c = System.today().addDays(-93);
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assert(merchants.isEmpty());
    }
  }

  static testMethod void getMerchantListOutsideFeatureMinDateAndNullExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = System.today().addDays(-366);
    sharedOpportunity.Groupon_Expiration_Date__c = NULL;
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assert(merchants.isEmpty());
    }
  }

  static testMethod void getMerchantListNullFeatureMinDateAndWithinExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = NULL;
    sharedOpportunity.Groupon_Expiration_Date__c = System.today().addDays(-89);
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();

      Set<Id> opportunityIds = new Set<Id>();
      for (AM_workbench.g1 g : merchants[0].g1deals) {
        opportunityIds.add(g.id);
      }

      System.assertEquals(true, opportunityIds.contains(sharedOpportunity.id));
    }
  }

  static testMethod void getMerchantListNullFeatureMinDateAndOutsideExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = NULL;
    sharedOpportunity.Groupon_Expiration_Date__c = System.today().addDays(-93);
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assert(merchants.isEmpty());
    }
  }

  static testMethod void getMerchantListNullFeatureMinDateAndNullExpirationMinDate() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = NULL;
    sharedOpportunity.Groupon_Expiration_Date__c = NULL;
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();

      Set<Id> opportunityIds = new Set<Id>();
      for (AM_workbench.g1 g : merchants[0].g1deals) {
        opportunityIds.add(g.Id);
      }

      System.assertEquals(true, opportunityIds.contains(sharedOpportunity.id));
    }
  }

  static testMethod void getMerchantListNullFeatureMinDateAndSpecialExpirationDates() {
    setupDateTest();
    sharedOpportunity.Feature_Date__c = NULL;
    sharedOpportunity.Groupon_Expiration_Date__c = Date.parse('1/1/1900');
    insert sharedOpportunity;

    System.RunAs(sharedUser)
    {
      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();

      Set<Id> opportunityIds = new Set<Id>();
      for (AM_workbench.g1 g : merchants[0].g1deals) {
        opportunityIds.add(g.Id);
      }

      System.assertEquals(true, opportunityIds.contains(sharedOpportunity.id));
    }
  }

  static testMethod void getMerchantListWithBabysitOpportunitiesTest() {
    Profile p = [select id from profile where name='System Administrator'];
    User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u1;

    System.RunAs(u1)
    {
      User u2 = new User(alias = 'user2', email='standarduser2@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser2@groupon.com');
      insert u2;

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

      Opportunity o = new Opportunity();
      o.name = 'test oppty';
      List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'];
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
      o.AccountCoordinator__c = u2.id;
      insert o;

      Test.startTest();

      System.runAs(u2) {
        AM_workbench workbench = new AM_workbench();
        List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
        Set<String> merchantIds = new Set<String>();
        for (AM_workbench.merchant m : merchants) {
          merchantIds.add(m.id);
        }

        System.assert(merchantIds.contains(a.id));
      }

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListWithGetawayOpportunitiesTest() {
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

      Opportunity o = new Opportunity();
      o.name = 'test oppty';
      List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Groupon Getaways'];
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
      o.Travel_Quality__c = '4. No Getaways; Approved for G1';
      insert o;

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assertEquals(a.id, merchants[0].id);
      System.assertEquals(1, merchants[0].g1deals.size());

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListWithLiveOpportunitiesTest() {
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

      Opportunity o = new Opportunity();
      o.name = 'test oppty';
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
      List<AM_workbench.Merchant> merchants = workbench.getMerchantList();
      System.assertEquals(a.id, merchants[0].id);
      System.assertEquals(1, merchants[0].g1deals.size());

      Test.stopTest();
    }
  }

  static testMethod void isUKInstance() {
    System.assertEquals( false, AM_workbench.isUKInstance('xyz') );
    System.assertEquals( true, AM_workbench.isUKInstance('00DP00000007iDS') );
  }

  static testMethod void merchantTemperature() {
    AM_workbench.Merchant m = new AM_workbench.Merchant(new Account());

    Date today = System.today();
    List<AM_workbench.MerchantTemperature> temps = new List<AM_workbench.MerchantTemperature>();
    AM_workbench.MerchantTemperature temperature = new AM_workbench.MerchantTemperature();
    temperature.category = 'Example Category';
    temperature.tempDate = today;
    temperature.overallRanking = 1;
    temperature.overallComments = 'Example Comments';
    temps.add(temperature);

    m.temperature = temps;

    Test.startTest();

    System.assertEquals('Example Category', m.temperature[0].category);
    System.assertEquals(today, m.temperature[0].tempDate);
    System.assertEquals(1, m.temperature[0].overallRanking);
    System.assertEquals('Example Comments', m.temperature[0].overallComments);

    Test.stopTest();
  }
}