@isTest
public class AM_workbenchTest {
  static testMethod void getOptionsTest() {
    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'Test Opportunity';
    opportunity.StageName = 'Stage Name';
    opportunity.CloseDate = System.today();
    opportunity.Feature_Date__c = System.today();
    Database.insert(opportunity);

    AM_workbench.getOptions(opportunity.Id);
  }

  static testMethod void prioritizeTest() {
    Test.setMock(HttpCalloutMock.class, new AMrulesEngineTest.MockSendMerchantDataHttp());
    AM_workbench.prioritize();
  }

  static testMethod void dealOptionTest() {
    AM_workbench.DealOption dealOption = new AM_workbench.DealOption();
    dealOption.id = 'Id';
    dealOption.name = 'Name';
    dealOption.unitValue = 0;
    dealOption.unitSellPrice = 0;
    dealOption.discount = 0;
    dealOption.optionCap = 0;
    dealOption.grouponLiteMonthlyCap = 0;
  }

  static testMethod void schedulerTest() {
    Account account = new Account();
    account.Name = 'testing account';
    account.BillingStreet = '123456 test';
    account.BillingCity = 'Chicago';
    account.BillingState = 'IL';
    account.BillingPostalCode = '60640';
    account.BillingCountry = 'US';
    account.research_ranking__c = '5';
    account.Groupon_Scheduler_Strength__c = 'Deactivated';
    account.Rewards_Offer_Status__c = 'Live';
    account.Now_Category__c = 'Stupid Now! Category';
    account.Sales_Value__c = 02002;
    insert account;

    new AM_workbench.Scheduler(account);
  }

  static testMethod void schedulerDealTest() {
    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'Test Opportunity';
    opportunity.StageName = 'Stage Name';
    opportunity.CloseDate = System.today();
    opportunity.Feature_Date__c = System.today();
    Database.insert(opportunity);

    new AM_workbench.Scheduler_Deal(opportunity);
  }

  static testMethod void workbenchTest() {
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

      User u3 = new User(alias = 'user3', email='standarduser3@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser3@groupon.com');
      insert u3;

      User u4 = new User(alias = 'user4', email='standarduser4@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser4@groupon.com');
      insert u4;

      Division__c d = new Division__c();
      d.Name = 'Test';
      d.State__c = 'IL';
      d.City_CEO__c = u2.id;
      d.dsm__c = u3.id;
      d.market_planner__c = u4.id;
      insert d;

      Account a = new Account();
      a.name = 'testing account';
      a.Account_Manager__c = u2.id;
      a.division__c=d.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.BillingCountry = 'US';
      a.research_ranking__c = '5';
      a.Groupon_Scheduler_Strength__c='Deactivated';
      a.Rewards_Offer_Status__c='Live';
      a.Now_Category__c ='Stupid Now! Category';
      a.Sales_Value__c =02002;
      insert a;

      Merchant_Payment__c mp = new Merchant_Payment__c();
      mp.amount__c = 5;
      mp.account__c = a.id;
      insert mp;

      date mydate1 = date.parse('12/31/2012');
      opportunity o = new opportunity();
      o.name = 'test oppty';

      List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'];
      if (recordTypes.size() > 0) {
        o.RecordTypeId = recordTypes[0].id;
      }

      o.division__c = d.name;
      o.Division_Dynamic__c = d.id;
      o.AccountId = a.id;
      o.StageName = 'Prospecting';
      o.CloseDate = mydate1;
      o.feature_date__c = system.today();
      o.feature_end_date__c =system.today().addDays(1);
      o.Category__c = 'Health & Beauty';
      o.city_manager__c = null;
      o.divisional_sales_manager__c = NULL;
      o.user__c = NULL;
      o.unit_buy_price__c = 5;
      o.TotalOpportunityQuantity =5;
      o.unit_sell_price__c = 10;
      o.Deal_Bank_Eligible__c='Opt-Out';
      insert o;

      Merchant_Addresses__c addy1 = new Merchant_Addresses__c();
      addy1.account__c = a.id;
      addy1.street_line_1__c = 'some street';
      addy1.city__c = 'city';
      addy1.State_Province__c ='ST';
      addy1.Latitude__c=134.34242;
      insert addy1;

      GrouponNow__c gnow1 = new GrouponNow__c();
      gnow1.Stage__c ='In Negotiations';
      gnow1.Buy_Price__c =5;
      gnow1.Sell_Price__c=10;
      gnow1.account_name__c = a.id;
      gnow1.close_date__c = system.today();
      gnow1.Deal_Name__c ='Deal Name';
      gnow1.Division__c=d.id;
      gnow1.Fine_Print__c='Fine Print';
      gnow1.Limit_Per_Person__c='1';
      gnow1.Limit_number_of_Groupons_redeemable_at_a__c=2;
      gnow1.Per__c='2';
      gnow1.Now_Category__c='Cat';
      gnow1.Now_Subcategory__c ='Subcat';
      insert gnow1;

      list<task> tasks = new list<task>();

      Task ta1 = new Task();
      ta1.whatid = o.id;
      ta1.subject = 'Prep: Feature Date Confirmed';
      ta1.status = 'Not Started';
      ta1.ownerid = u2.id;
      ta1.activityDate = system.today();
      tasks.add(ta1);

      insert tasks;

      Financial_Records__c fr = new Financial_Records__c();
      fr.Collection_Date__c = system.today();
      fr.opportunity__c = o.id;
      fr.Units_Refunded__c=5l;
      fr.Revenue_Amount__c=500;
      fr.Profit_Amount__c=550;
      fr.Refunds_for_Commission__c=500;
      fr.Gross_Profit_Salesforce__c=5000;
      insert fr;

      task test_task = new task();
      test_task.whatid = a.id;
      insert test_task;

      AM_workbench am_wb = new AM_workbench();

      test.StartTest();
      list <RESTmerchant_call_listAPI.call_priority> call_list = RESTmerchant_call_listAPI.get();

      system.runas(u2){
        list<AM_workbench.merchant> merchs = am_wb.getmerchantList();
      }

      Test.StopTest();
    }
  }

  static testMethod void taskItTest() {
    Task task = new Task();
    task.subject = 'Prep: Feature Date Confirmed';
    task.status = 'Not Started';
    insert task;

    AM_workbench.Obj obj = AM_workbench.taskIt(task);

    task = [SELECT ActivityDate FROM Task WHERE Id = :task.Id];
    System.assertEquals(System.today(), task.ActivityDate);
    System.assertEquals('Prep: Feature Date Confirmed', obj.subject);
  }

  static testMethod void objTest() {
    AM_workbench.Obj obj = new AM_workbench.Obj('value');
    System.assertEquals('value', obj.value);
  }

  static testMethod void merchantContactsTest() {
    Account account = new Account();
    account.Name = 'testing account';
    account.BillingStreet = '123456 test';
    account.BillingCity = 'Chicago';
    account.BillingState = 'IL';
    account.BillingPostalCode = '60640';
    account.BillingCountry = 'US';
    account.Research_Ranking__c = '5';
    account.Groupon_Scheduler_Strength__c = 'Deactivated';
    account.Rewards_Offer_Status__c = 'Live';
    account.Now_Category__c = 'Stupid Now! Category';
    account.Sales_Value__c = 02002;
    insert account;

    Contact contact = new Contact();
    contact.FirstName = 'John';
    contact.LastName = 'Smith';
    contact.Phone = '1234567890';
    contact.Email = 'john@smith.com';
    contact.MobilePhone = '1234567890';
    contact.AccountId = account.Id;
    insert contact;

    List<AM_workbench.MerchantContact> contacts =  AM_workbench.merchant_contacts(account.Id, '006');
    AM_workbench.MerchantContact merchantContact = contacts[0];
    System.assertEquals(contact.Phone, merchantContact.phone);
    System.assertEquals(contact.Email, merchantContact.email);
    System.assertEquals(contact.MobilePhone, merchantContact.mobilePhone);
    System.assertEquals('006', merchantContact.dealId);
  }

  static testMethod void rewardTest() {
    Account account = new Account();
    account.Name = 'testing account';
    account.BillingStreet = '123456 test';
    account.BillingCity = 'Chicago';
    account.BillingState = 'IL';
    account.BillingPostalCode = '60640';
    account.BillingCountry = 'US';
    account.Research_Ranking__c = '5';
    account.Groupon_Scheduler_Strength__c = 'Deactivated';
    account.Rewards_Offer_Status__c = 'Live';
    account.Now_Category__c = 'Stupid Now! Category';
    account.Sales_Value__c = 02002;
    insert account;

    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'Test Opportunity';
    opportunity.StageName = 'Stage Name';
    opportunity.CloseDate = System.today();
    opportunity.Feature_Date__c = System.today();
    opportunity.AccountId = account.Id;
    List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND Name = 'Rewards'];
    if (recordTypes.size() > 0) {
      opportunity.RecordTypeId = recordTypes[0].Id;
      insert opportunity;

      List<AM_workbench.MerchantReward> rewards = AM_workbench.rewards(account.Id);

      System.assertEquals(1, rewards.size());
    }
  }

  static testMethod void grouponNowTest() {
    Account account = new Account();
    account.Name = 'testing account';
    account.BillingStreet = '123456 test';
    account.BillingCity = 'Chicago';
    account.BillingState = 'IL';
    account.BillingPostalCode = '60640';
    account.BillingCountry = 'US';
    account.Research_Ranking__c = '5';
    account.Groupon_Scheduler_Strength__c = 'Deactivated';
    account.Rewards_Offer_Status__c = 'Live';
    account.Now_Category__c = 'Stupid Now! Category';
    account.Sales_Value__c = 02002;
    insert account;

    GrouponNow__c now = new GrouponNow__c();
    now.Stage__c = 'Stage';
    now.Account_Name__c = account.Id;
    now.Close_Date__c = System.today();
    insert now;

    List<AM_workbench.Merchant> merchants = AM_workbench.grouponNow(account.Id);
    AM_workbench.Now nowDeal = merchants[0].now_deals[0];
    System.assertEquals(now.Stage__c, nowDeal.stage);
    System.assertEquals(now.Close_Date__C, nowDeal.closeDate);
  }
}