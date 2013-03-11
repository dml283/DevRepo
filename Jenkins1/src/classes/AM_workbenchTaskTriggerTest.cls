@isTest
public class AM_workbenchTaskTriggerTest {
  private static User setupUser() {
      Profile p = [select id from profile where name='System Administrator'];
      User testUser = new User(alias = 'standt', email='standarduser@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');

      insert testUser;
      return testUser;    
  }

  private static Account setupAccount(User testUser) {
      Account a = new Account();
      a.name = 'testing account';
      a.Account_Manager__c = testUser.id;
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
      return a;
  }

  private static Opportunity setupOpportunity(User testUser, Account a) {
      Opportunity o = new Opportunity();
      o.name = 'test opportunity';
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
      o.AccountCoordinator__c = testUser.id;

      o.Intro_Call_Status__c = 'Initial Test Status';    
      o.Getting_Ready_Email_Status__c = 'Initial Test Status';
      o.Feature_Date_Confirmation_Status__c = 'Initial Test Status';
      o.Merchant_Center_Walkthrough_Status__c = 'Initial Test Status';
      o.Client_Preview_Status__c = 'Initial Test Status';    
      o.Preview_Approval_Status__c = 'Initial Test Status';    
      o.Day_After_Feature_Call_Status__c = 'Initial Test Status';    
      o.Pre_Expiration_Call_Status__c = 'Initial Test Status';    

      insert o;
      return o;
  }

  static testMethod void introCallStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Prep: Intro Call';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Intro_Call_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Intro_Call_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void introCallStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Prep: Intro Call';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Intro_Call_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Intro_Call_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void gettingReadyEmailStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Prep: Getting Ready';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Getting_Ready_Email_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Getting_Ready_Email_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void GettingReadyEmailStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Prep: Getting Ready';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Getting_Ready_Email_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Getting_Ready_Email_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void FeatureDateConfirmationStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Prep: Feature Date Confirmed';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Feature_Date_Confirmation_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Feature_Date_Confirmation_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void FeatureDateConfirmationNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Prep: Feature Date Confirmed';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Feature_Date_Confirmation_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Feature_Date_Confirmation_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void MerchantCenterWalkthroughStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Prep: MC Walkthrough';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Merchant_Center_Walkthrough_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Merchant_Center_Walkthrough_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void MerchantCenterWalkthroughStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Prep: MC Walkthrough';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Merchant_Center_Walkthrough_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Merchant_Center_Walkthrough_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void PreviewDeliveredStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Prep: Preview Delivered';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Client_Preview_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Client_Preview_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void PreviewDeliveredStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Prep: Preview Delivered';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Client_Preview_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Client_Preview_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void PreviewApprovedStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Prep: Preview Approved';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Preview_Approval_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Preview_Approval_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void PreviewApprovedStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Prep: Preview Approved';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Preview_Approval_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Preview_Approval_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void DayAfterStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Maintenance: Day After';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Day_After_Feature_Call_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Day_After_Feature_Call_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void DayAfterStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Maintenance: Day After';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Day_After_Feature_Call_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Day_After_Feature_Call_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void PreExpirationStatusCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Maintenance: Pre Expiration';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Pre_Expiration_Call_Status__c from opportunity where id = :o.id];

      System.assertEquals('Completed', resultingOpp.Pre_Expiration_Call_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void PreExpirationStatusNotCompleted() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      Opportunity o = setupOpportunity(testUser, a);

      Test.startTest();

      Task t = new Task();
      t.WhatId = o.id;
      t.Subject = 'Not a Maintenance: Pre Expiration';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';
      insert t;
      
      Opportunity resultingOpp = [select id, name, Pre_Expiration_Call_Status__c from opportunity where id = :o.id];

      System.assertEquals('Initial Test Status', resultingOpp.Pre_Expiration_Call_Status__c);
      
      Test.stopTest();
    }
  }

  static testMethod void bulkUpdates() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account account = setupAccount(testUser);
      Opportunity opportunity = setupOpportunity(testUser, account);

      Test.startTest();

      Task task1 = new Task();
      task1.WhatId = opportunity.Id;
      task1.Subject = 'Prep: Intro Call';
      task1.ActivityDate = System.today();
      task1.Status = 'Completed';

      Task task2 = new Task();
      task2.WhatId = opportunity.Id;
      task2.Subject = 'Prep: Getting Ready';
      task2.ActivityDate = System.today();
      task2.Status = 'Completed';

      List<Task> tasks = new List<Task>();
      tasks.add(task1);
      tasks.add(task2);
      insert tasks;

      Opportunity resultingOpportunity = [SELECT Intro_Call_Status__c, Getting_Ready_Email_Status__c FROM Opportunity WHERE Id = :opportunity.Id];

      System.assertEquals('Completed', resultingOpportunity.Intro_Call_Status__c);
      System.assertEquals('Completed', resultingOpportunity.Getting_Ready_Email_Status__c);

      Test.stopTest();
    }
  }

  private static Account setupAccount() {
    Account account = new Account();
    account.name = 'testing account';
    account.BillingStreet = '123456 test';
    account.BillingCity = 'Chicago';
    account.BillingState = 'IL';
    account.BillingPostalCode = '60640';
    account.BillingCountry = 'US';
    insert account;
    return account;
  }

  private static Opportunity setupOpportunity(Account account) {
    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'test opportunity';
    List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'GrouponLive'];
    if (recordTypes.size() > 0) {
      opportunity.RecordTypeId = recordTypes[0].id;
    }
    opportunity.AccountId = account.Id;
    opportunity.StageName = 'Closed Won';
    opportunity.CloseDate = System.today().addDays(-32);
    opportunity.Category__c = 'Health & Beauty';
    insert opportunity;
    return opportunity;
  }

  static testMethod void MerchantTemperatureFollowUpCompleted() {
    Account account = setupAccount();

    Quantum_Lead__c lead = new Quantum_Lead__c();
    lead.Account__c = account.Id;
    lead.Call_List_Priority__c = '0';
    lead.Sales_Value__c = 0;
    lead.Parent_Id__c = account.Id;
    insert lead;

    Merchant_Temperature__c temperature = new Merchant_Temperature__c();
    temperature.Account__c = account.Id;
    temperature.Low_Merchant_Temp_Call_Status__c = 'Not Completed';
    temperature.Overall_Experience_Ranking__c = 3;
    insert temperature;

    Test.startTest();

    Task task = new Task();
    task.WhatId = account.Id;
    task.Subject = 'Maintenance: Merchant Temperature Follow Up';
    task.ActivityDate = System.today();
    task.Status = 'Completed';
    insert task;

    Merchant_Temperature__c updatedTemperature = [SELECT Low_Merchant_Temp_Call_Status__c FROM Merchant_Temperature__c WHERE Id = :temperature.Id];

    System.assertEquals('Completed', updatedTemperature.Low_Merchant_Temp_Call_Status__c);
  }

  static testMethod void OpportunityDoesNotExist() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account account = setupAccount(testUser);

      Test.startTest();

      Quantum_Lead__c lead = new Quantum_Lead__c();
      lead.Account__c = account.Id;
      lead.Call_List_Priority__c = '0';
      lead.Sales_Value__c = 0;
      lead.Parent_Id__c = account.Id;
      insert lead;

      Task task = new Task();
      task.WhatId = account.Id;
      task.Subject = 'Prep: Intro Call';
      task.ActivityDate = System.today();
      task.Status = 'Completed';
      insert task;

      try {
        Opportunity opportunity = [SELECT Id, Name, Intro_Call_Status__c FROM Opportunity WHERE Id = :task.WhatId];
        System.assert(false, 'opportunity should not exist');
      } catch (Exception e) {
        System.assert(true, 'The opportunity did not exist as we had expected it not to.');
      }

      Test.stopTest();
    }
  }

  static testMethod void TaskHasBlankWhatId() {
    User testUser = setupUser();
    System.RunAs(testUser) {
      Account a = setupAccount(testUser);
      
      Test.startTest();

      Task t = new Task();
      t.Subject = 'Prep: Intro Call';
      t.ActivityDate = system.today();
      t.Status = 'Completed';
      t.Description = 'Test-AM-Story-27';

      try {
        insert t;
        System.assert(true, 'Inserting the task did not throw any exceptions');
      } catch (Exception e) {
        System.assert(false, 'Inserting the task threw exception' + e);
      }

      Test.stopTest();
    }
  }

  class FakeException extends Exception {}

  static testMethod void emailOpportunityException() {
    Opportunity opportunity = new Opportunity(Id = '006C000000h0Utf');
    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
    opportunityMap.put(opportunity.Id, opportunity);
    Exception e = new FakeException('Error');
    Messaging.SingleEmailMessage[] mails = AM_StatusUpdater.email(opportunityMap.keySet(), e);
    System.assertEquals('Workbench Validation Error', mails[0].getSubject());
    System.assertEquals('AM Workbench', mails[0].getSenderDisplayName());
    System.assert(mails[0].getPlainTextBody().contains('006C000000h0Utf'));
    System.assert(mails[0].getPlainTextBody().contains('Error'));
    System.assert(mails[0].getPlainTextBody().contains(UserInfo.getUserId()));
  }

  static testMethod void emailMerchantTemperatureException() {
    Merchant_Temperature__c temperature = new Merchant_Temperature__c(Id = 'a3Bc0000000Cftr');
    Map<Id, Merchant_Temperature__c> temperatureMap = new Map<Id, Merchant_Temperature__c>();
    temperatureMap.put(temperature.Id, temperature);
    Exception e = new FakeException('Error');
    Messaging.SingleEmailMessage[] mails = AM_StatusUpdater.email(temperatureMap.keySet(), e);
    System.assertEquals('Workbench Validation Error', mails[0].getSubject());
    System.assertEquals('AM Workbench', mails[0].getSenderDisplayName());
    System.assert(mails[0].getPlainTextBody().contains('a3Bc0000000Cftr'));
    System.assert(mails[0].getPlainTextBody().contains('Error'));
    System.assert(mails[0].getPlainTextBody().contains(UserInfo.getUserId()));
  }
}