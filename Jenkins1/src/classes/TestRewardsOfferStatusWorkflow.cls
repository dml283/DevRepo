@isTest
private class TestRewardsOfferStatusWorkflow {
  static testMethod void testSetRewardsOfferStatus(){
    Account a;
    Opportunity o1;
    Opportunity o2;
    Opportunity o3;
    Opportunity o4;
    Opportunity o5;
    Opportunity o6;
    Opportunity o7;
    Opportunity o8;
    Opportunity o9;
    Opportunity o10;
            
    a = TestUtil.createAccount();
    insert a;

    Map<ID, Account> newMap = new Map<ID, Account> {a.Id => a};

    //Test for Not Contacted
    o1 = TestUtil.createDeal(a);
    o1.Division__c = 'Training';
    o1.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o1.Stagename = 'Not Contacted';
    insert o1;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw1 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw1.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Not Contacted');

    //Test for Rejected
    o2 = TestUtil.createDeal(a);
    o2.Division__c = 'Training';
    o2.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o2.Stagename = 'Rejected';
    insert o2;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw2 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw2.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Rejected');

    //Test for Closed Lost
    o3 = TestUtil.createDeal(a);
    o3.Division__c = 'Training';
    o3.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o3.Stagename = 'Closed Lost';
    insert o3;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw3 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw3.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Closed Lost');

    //Test for Closed Expired
    o4 = TestUtil.createDeal(a);
    o4.Division__c = 'Training';
    o4.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o4.Stagename = 'Closed Expired';
    insert o4;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw4 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw4.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Closed Expired');

    //Test for Contacted
    o5 = TestUtil.createDeal(a);
    o5.Division__c = 'Training';
    o5.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o5.Stagename = 'Contacted';
    insert o5;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw5 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw5.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Contacted');

    //Test for In Negotiations
    o6 = TestUtil.createDeal(a);
    o6.Division__c = 'Training';
    o6.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o6.Stagename = 'In Negotiations';
    insert o6;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw6 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw6.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'In Negotiations');

    //Test for Contract Sent
    o7 = TestUtil.createDeal(a);
    o7.Division__c = 'Training';
    o7.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o7.Stagename = 'Contract Sent';
    insert o7;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw7 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw7.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Contract Sent');

    //Test for Closed Won
    o8 = TestUtil.createDeal(a);
    o8.Division__c = 'Training';
    o8.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o8.Stagename = 'Closed Won';
    insert o8;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw8 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw8.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Closed Won');

    //Test for Pulled
    o9 = TestUtil.createDeal(a);
    o9.Division__c = 'Training';
    o9.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o9.Stagename = 'Closed Won';
    o9.Feature_date__c = System.today()-10;
    o9.Feature_end_date__c = System.today()-5;
    insert o9;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw9 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw9.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Pulled');

    //Test for Live
    o10 = TestUtil.createDeal(a);
    o10.Division__c = 'Training';
    o10.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
    o10.Stagename = 'Closed Won';
    o10.Feature_date__c = System.today() -1;
    o10.Feature_end_date__c = System.today() +5;
    insert o10;

    RewardsOfferStatusWorkflow.hasExecuted = true;
    RewardsOfferStatusWorkflow rosw10 = new RewardsOfferStatusWorkflow (newMap, newMap);
    RewardsOfferStatusWorkflow.hasExecuted = false;
    rosw10.execute();
    System.assertEquals (a.Rewards_Offer_Status__c, 'Live');

  }
}