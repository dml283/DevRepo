@isTest
public class RESTMerchantDealsAPIv2Tests {
  static testMethod void testIncludesBothOptions() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account account = new GrouponTestUtil().createAccount();
      insert account;
      Opportunity deal = new GrouponTestUtil().createDeal(account);
      insert deal;
      Multi_Deal__c option1 = new GrouponTestUtil().createOption(deal);
      insert option1;
      Multi_Deal__c option2 = new GrouponTestUtil().createOption(deal);
      insert option2;

      RestContext.request.addParameter('salesforce_id', account.Id);
      List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals(2, deals.get(0).options.size());
    }
  }

  // static testMethod void testFirstPaymentDate() {
  //   RestContext.request = new RestRequest();
  //   User user = new GrouponTestUtil().createTestUser('System Administrator');

  //   System.runAs(user) {
  //     Account account = new GrouponTestUtil().createAccount();
  //     insert account;
  //     Opportunity deal = new GrouponTestUtil().createDeal(account);
  //     deal.Feature_Date__c = Date.today();
  //     deal.X1st_Payment_Days__c = 1;
  //     insert deal;

  //     RestContext.request.addParameter('salesforce_id', account.Id);
  //     List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

  //     Date paymentDate = Date.today().addDays(1);
  //     System.assertEquals(new LibrarySimpleIsoDateTime(paymentDate).formatIso8601Gmt(), deals.get(0).nextPayment);
  //   }
  // }

  // static testMethod void testSecondPaymentDate() {
  //   RestContext.request = new RestRequest();
  //   User user = new GrouponTestUtil().createTestUser('System Administrator');

  //   System.runAs(user) {
  //     Account account = new GrouponTestUtil().createAccount();
  //     insert account;
  //     Opportunity deal = new GrouponTestUtil().createDeal(account);
  //     deal.Feature_Date__c = Date.today().addDays(-5);
  //     deal.X1st_Payment_Days__c = 1;
  //     deal.X2nd_Payment_Days__c = 30;
  //     insert deal;

  //     RestContext.request.addParameter('salesforce_id', account.Id);
  //     List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

  //     Date paymentDate = Date.today().addDays(25);
  //     System.assertEquals(new LibrarySimpleIsoDateTime(paymentDate).formatIso8601Gmt(), deals.get(0).nextPayment);
  //   }
  // }

  // static testMethod void testThirdPaymentDate() {
  //   RestContext.request = new RestRequest();
  //   User user = new GrouponTestUtil().createTestUser('System Administrator');

  //   System.runAs(user) {
  //     Account account = new GrouponTestUtil().createAccount();
  //     insert account;
  //     Opportunity deal = new GrouponTestUtil().createDeal(account);
  //     deal.Feature_Date__c = Date.today().addDays(-40);
  //     deal.X1st_Payment_Days__c = 1;
  //     deal.X2nd_Payment_Days__c = 30;
  //     deal.X2nd_Payment_Days__c = 60;
  //     insert deal;

  //     RestContext.request.addParameter('salesforce_id', account.Id);
  //     List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

  //     Date paymentDate = Date.today().addDays(20);
  //     System.assertEquals(new LibrarySimpleIsoDateTime(paymentDate).formatIso8601Gmt(), deals.get(0).nextPayment);
  //   }
  // }

  static testMethod void testAllPaymentDates() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account account = new GrouponTestUtil().createAccount();
      insert account;
      Opportunity deal = new GrouponTestUtil().createDeal(account);
      deal.Feature_Date__c = Date.today().addDays(-120);
      deal.Feature_End_Date__c = Date.today().addDays(-120);
      deal.X1st_Payment_Days__c = 1;
      deal.X2nd_Payment_Days__c = 30;
      deal.X3rd_Payment_Days__c = 60;
      insert deal;

      RestContext.request.addParameter('salesforce_id', account.Id);
      List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

      Date paymentDate = Date.today().addDays(20);
      System.assertEquals(null, deals.get(0).nextPayment);
    }
  }

  static testMethod void testRefundedUnits() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account account = new GrouponTestUtil().createAccount();
      insert account;
      Opportunity deal = new GrouponTestUtil().createDeal(account);
      insert deal;
      Financial_Records__c refundRecord1 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord1.Units_Refunded__c = -5;
      insert refundRecord1;
      Financial_Records__c refundRecord2 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord2.Units_Refunded__c = -3;
      insert refundRecord2;

      RestContext.request.addParameter('salesforce_id', account.Id);
      List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals(8, deals.get(0).refundedUnits);
    }
  }
  static testMethod void testPostGp() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account account = new GrouponTestUtil().createAccount();
      insert account;
      Opportunity deal = new GrouponTestUtil().createDeal(account);
      deal.Feature_End_Date__c = Date.today();
      insert deal;
      Financial_Records__c refundRecord1 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord1.Collection_Date__c = Date.today().addDays(5);
      refundRecord1.Revenue_Amount__c = 10;
      insert refundRecord1;
      Financial_Records__c refundRecord2 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord2.Collection_Date__c = Date.today().addDays(-5);
      refundRecord2.Revenue_Amount__c = 10;
      insert refundRecord2;

      RestContext.request.addParameter('salesforce_id', account.Id);
      List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals(10, deals.get(0).postGp);
    }
  }

  static testMethod void testPostUnits() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account account = new GrouponTestUtil().createAccount();
      insert account;
      Opportunity deal = new GrouponTestUtil().createDeal(account);
      deal.Feature_End_Date__c = Date.today();
      insert deal;
      Financial_Records__c refundRecord1 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord1.Collection_Date__c = Date.today().addDays(5);
      refundRecord1.Revenue_Amount__c = 10;
      insert refundRecord1;
      Financial_Records__c refundRecord2 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord2.Collection_Date__c = Date.today().addDays(5);
      refundRecord1.Revenue_Amount__c = -10;
      insert refundRecord2;
      Financial_Records__c refundRecord3 = new GrouponTestUtil().createFinancialRecord(deal);
      refundRecord3.Collection_Date__c = Date.today().addDays(-5);
      insert refundRecord3;

      RestContext.request.addParameter('salesforce_id', account.Id);
      List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals(1, deals.get(0).postUnits);
    }
  }

  static testMethod void testDealStatus() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account grouponLiteAccount = new GrouponTestUtil().createAccount();
      Account featureAccount = new GrouponTestUtil().createAccount();
      Account dealBankAccount = new GrouponTestUtil().createAccount();
      Account expiredAccount = new GrouponTestUtil().createAccount();
      Account openAccount = new GrouponTestUtil().createAccount();

      insert new List<Account> {
        openAccount,
        expiredAccount,
        dealBankAccount,
        featureAccount,
        grouponLiteAccount
      };

      Opportunity grouponLiteDeal = new GrouponTestUtil().createDeal(grouponLiteAccount);
      RecordType gLiteRecordType = [SELECT Id FROM RecordType WHERE Name = 'gLite'];
      grouponLiteDeal.RecordTypeId = gLiteRecordType.Id;

      Opportunity featureDeal = new GrouponTestUtil().createDeal(featureAccount);
      featureDeal.Sure_Thing_Date__c = Date.today().addDays(-10);
      featureDeal.Feature_Date__c = Date.today().addDays(-5);
      featureDeal.Feature_End_Date__c = Date.today().addDays(5);

      Opportunity dealBankDeal = new GrouponTestUtil().createDeal(dealBankAccount);
      dealBankDeal.Sure_Thing_Date__c = Date.today().addDays(-15);
      dealBankDeal.Feature_Date__c = Date.today().addDays(-10);
      dealBankDeal.Feature_End_Date__c = Date.today().addDays(-5);
      dealBankDeal.Groupon_expiration_Date__c = Date.today().addDays(5);

      Opportunity expiredDeal = new GrouponTestUtil().createDeal(expiredAccount);
      expiredDeal.Deal_Bank_Eligible__c = 'Opt-In';
      expiredDeal.Sure_Thing_Date__c = Date.today().addDays(-20);
      expiredDeal.Feature_Date__c = Date.today().addDays(-15);
      expiredDeal.Feature_End_Date__c = Date.today().addDays(-10);
      expiredDeal.Groupon_expiration_Date__c = Date.today().addDays(-5);

      Opportunity openDeal = new GrouponTestUtil().createDeal(openAccount);
      openDeal.Deal_Bank_Eligible__c = 'Opt-Out';
      openDeal.Sure_Thing_Date__c = Date.today().addDays(-15);
      openDeal.Feature_Date__c = Date.today().addDays(-10);
      openDeal.Feature_End_Date__c = Date.today().addDays(-5);
      openDeal.Groupon_expiration_Date__c = Date.today().addDays(5);

      insert new List<Opportunity> {
        grouponLiteDeal,
        featureDeal,
        dealBankDeal,
        expiredDeal,
        openDeal
      };

      List<RESTMerchantDealsAPIv2.Deal> deals;
      RestContext.request.addParameter('salesforce_id', grouponLiteAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('G2', deals.get(0).dealStatus);

      RestContext.request.addParameter('salesforce_id', featureAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Feature', deals.get(0).dealStatus);

      RestContext.request.addParameter('salesforce_id', dealBankAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Deal Bank', deals.get(0).dealStatus);

      RestContext.request.addParameter('salesforce_id', expiredAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Expired', deals.get(0).dealStatus);

      RestContext.request.addParameter('salesforce_id', openAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Open', deals.get(0).dealStatus);
    }
  }

  static testMethod void testStatusFields() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account completedAccount = new GrouponTestUtil().createAccount();
      insert completedAccount;
      Opportunity completedDeal = new GrouponTestUtil().createDeal(completedAccount);
      insert completedDeal;
      insert new List<Task> {
        new GrouponTestUtil().createTask('Prep: Intro Call', completedDeal, 'Completed'),
        new GrouponTestUtil().createTask('Prep: Feature Date Communicated', completedDeal, 'Completed'),
        new GrouponTestUtil().createTask('Prep: Getting Ready Email Sent', completedDeal, 'Completed'),
        new GrouponTestUtil().createTask('Prep: Merchant Center Walkthrough', completedDeal, 'Completed'),
        new GrouponTestUtil().createTask('Prep: Preview Sent', completedDeal, 'Completed'),
        new GrouponTestUtil().createTask('Prep: Preview Approved', completedDeal, 'Completed')
      };

      Account inProgressAccount = new GrouponTestUtil().createAccount();
      insert inProgressAccount;
      Opportunity inProgressDeal = new GrouponTestUtil().createDeal(inProgressAccount);
      insert inProgressDeal;
      insert new List<Task> {
        new GrouponTestUtil().createTask('Prep: Intro Call', inProgressDeal, 'In Progress'),
        new GrouponTestUtil().createTask('Prep: Feature Date Communicated', inProgressDeal, 'In Progress'),
        new GrouponTestUtil().createTask('Prep: Getting Ready Email Sent', inProgressDeal, 'In Progress'),
        new GrouponTestUtil().createTask('Prep: Merchant Center Walkthrough', inProgressDeal, 'In Progress'),
        new GrouponTestUtil().createTask('Prep: Preview Sent', inProgressDeal, 'In Progress'),
        new GrouponTestUtil().createTask('Prep: Preview Approved', inProgressDeal, 'In Progress')
      };

      Account notStartedAccount = new GrouponTestUtil().createAccount();
      insert notStartedAccount;
      Opportunity notStartedDeal = new GrouponTestUtil().createDeal(notStartedAccount);
      insert notStartedDeal;

      List<RESTMerchantDealsAPIv2.Deal>  deals;

      RestContext.request.addParameter('salesforce_id', completedAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals('Completed', deals.get(0).statusIntro);
      System.assertEquals('Completed', deals.get(0).statusFeatureDate);
      System.assertEquals('Completed', deals.get(0).statusGettingReady);
      System.assertEquals('Completed', deals.get(0).statusMerchantCenter);
      System.assertEquals('Completed', deals.get(0).statusPreviewSent);
      System.assertEquals('Completed', deals.get(0).statusPreviewApproved);

      RestContext.request.addParameter('salesforce_id', inProgressAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals('In Progress', deals.get(0).statusIntro);
      System.assertEquals('In Progress', deals.get(0).statusFeatureDate);
      System.assertEquals('In Progress', deals.get(0).statusGettingReady);
      System.assertEquals('In Progress', deals.get(0).statusMerchantCenter);
      System.assertEquals('In Progress', deals.get(0).statusPreviewSent);
      System.assertEquals('In Progress', deals.get(0).statusPreviewApproved);

      RestContext.request.addParameter('salesforce_id', notStartedAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals('Not Started', deals.get(0).statusIntro);
      System.assertEquals('Not Started', deals.get(0).statusFeatureDate);
      System.assertEquals('Not Started', deals.get(0).statusGettingReady);
      System.assertEquals('Not Started', deals.get(0).statusMerchantCenter);
      System.assertEquals('Not Started', deals.get(0).statusPreviewSent);
      System.assertEquals('Not Started', deals.get(0).statusPreviewApproved);
    }
  }

  static testMethod void testLastContactDate() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account account = new GrouponTestUtil().createAccount();
      insert account;
      Opportunity deal = new GrouponTestUtil().createDeal(account);
      insert deal;
      Task task = new GrouponTestUtil().createTask(deal);
      task.ActivityDate = Date.today();
      insert task;

      RestContext.request.addParameter('salesforce_id', account.Id);
      List<RESTMerchantDealsAPIv2.Deal> deals = RESTMerchantDealsAPIv2.getDeals();

      System.assertEquals(new LibrarySimpleIsoDateTime(Date.today()).formatIso8601Gmt(), deals.get(0).lastContactDate);
    }
  }

  static testMethod void testStage() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Account expiredAccount = new GrouponTestUtil().createAccount();
      Account featuredAccount = new GrouponTestUtil().createAccount();
      Account vettedAccount = new GrouponTestUtil().createAccount();
      Account sureThingAccount = new GrouponTestUtil().createAccount();
      Account closedWonAccount = new GrouponTestUtil().createAccount();
      Account closedLostAccount = new GrouponTestUtil().createAccount();
      Account closedExpiredAccount = new GrouponTestUtil().createAccount();
      Account prospectingAccount = new GrouponTestUtil().createAccount();

      insert new List<Account> {
        prospectingAccount,
        closedExpiredAccount,
        closedLostAccount,
        closedWonAccount,
        sureThingAccount,
        vettedAccount,
        featuredAccount,
        expiredAccount
      };

      Opportunity expiredDeal = new GrouponTestUtil().createDeal(expiredAccount);
      expiredDeal.Groupon_expiration_Date__c = Date.today().addDays(-5);
      expiredDeal.StageName = 'Closed Won';
      expiredDeal.Deal_Strengh__c = 'Strength';

      Opportunity featuredDeal = new GrouponTestUtil().createDeal(featuredAccount);
      featuredDeal.StageName = 'Closed Won';
      featuredDeal.Deal_Strengh__c = 'Strength';
      featuredDeal.Feature_Date__c = Date.today().addDays(-5);

      Opportunity vettedDeal = new GrouponTestUtil().createDeal(vettedAccount);
      vettedDeal.StageName = 'Closed Won';
      vettedDeal.Deal_Strengh__c = 'Vetted';
      vettedDeal.Feature_Date__c = null;
      vettedDeal.Feature_End_Date__c = null;

      Opportunity sureThingDeal = new GrouponTestUtil().createDeal(sureThingAccount);
      sureThingDeal.StageName = 'Closed Won';
      sureThingDeal.Deal_Strengh__c = 'A Sure Thing';
      sureThingDeal.Feature_Date__c = null;
      sureThingDeal.Feature_End_Date__c = null;

      Opportunity closedWonDeal = new GrouponTestUtil().createDeal(closedWonAccount);
      closedWonDeal.StageName = 'Closed Won';
      closedWonDeal.Deal_Strengh__c = 'Strength';
      closedWonDeal.Feature_Date__c = null;
      closedWonDeal.Feature_End_Date__c = null;

      Opportunity closedLostDeal = new GrouponTestUtil().createDeal(closedLostAccount);
      closedLostDeal.StageName = 'Closed Lost';
      closedLostDeal.Deal_Strengh__c = 'Strength';
      closedLostDeal.Feature_Date__c = null;
      closedLostDeal.Feature_End_Date__c = null;

      Opportunity closedExpiredDeal = new GrouponTestUtil().createDeal(closedExpiredAccount);
      closedExpiredDeal.StageName = 'Closed Expired';
      closedExpiredDeal.Deal_Strengh__c = 'Strength';
      closedExpiredDeal.Feature_Date__c = null;
      closedExpiredDeal.Feature_End_Date__c = null;

      Opportunity prospectingDeal = new GrouponTestUtil().createDeal(prospectingAccount);
      prospectingDeal.StageName = 'Prospecting';
      prospectingDeal.Deal_Strengh__c = 'Strength';
      prospectingDeal.Feature_Date__c = null;
      prospectingDeal.Feature_End_Date__c = null;

      insert new List<Opportunity> {
        expiredDeal,
        featuredDeal,
        vettedDeal,
        sureThingDeal,
        closedWonDeal,
        closedLostDeal,
        closedExpiredDeal,
        prospectingDeal
      };

      List<RESTMerchantDealsAPIv2.Deal> deals;

      RestContext.request.addParameter('salesforce_id', expiredAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      expiredDeal.Feature_Date__c = Date.today().addDays(-15);
      expiredDeal.Feature_End_Date__c = Date.today().addDays(-10);
      System.assertEquals('Feature Expired', deals.get(0).stage);
      System.assertEquals('Strength', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', featuredAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Featured', deals.get(0).stage);
      System.assertEquals('Strength', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', vettedAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Prep', deals.get(0).stage);
      System.assertEquals('Vetted', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', sureThingAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Prep', deals.get(0).stage);
      System.assertEquals('A Sure Thing', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', closedWonAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Closed Won', deals.get(0).stage);
      System.assertEquals('Strength', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', closedLostAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Closed Lost', deals.get(0).stage);
      System.assertEquals('Strength', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', closedExpiredAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Closed Expired', deals.get(0).stage);
      System.assertEquals('Strength', deals.get(0).dealStrength);

      RestContext.request.addParameter('salesforce_id', prospectingAccount.Id);
      deals = RESTMerchantDealsAPIv2.getDeals();
      System.assertEquals('Prospecting', deals.get(0).stage);
      System.assertEquals('Prospecting', deals.get(0).dealStrength);
    }
  }

}