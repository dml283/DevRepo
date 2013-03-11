@isTest
private class testOpportunityClone {

  static testMethod void testRedirectClone() {

    Account a = TestUtil.createAccount ('Test Account');
    Opportunity o = TestUtil.createOpportunity (a, 'Test Opportunity', 'Prospecting', System.Today(), True);
    Multi_Deal__c m = TestUtil.createMDwithSku (o, 'Test Multi Deal');
    Address__c addy = TestUtil.createOpptyAddress (o);
    Question_Bank__c qb = TestUtil.createQuestionBank ('Test QB', FALSE, 'Picklist', 'Test Options', 'test');
    
    o.Unit_buy_price__c = 25;
    update o;
    
    Question__c q = new Question__c();
    q.Opportunity__c = o.Id;
    q.Question_Bank__c = qb.id;
    insert q;

    Question_DW__c dw = new Question_DW__c();
    dw.Opportunity__c = o.Id;
    dw.Name = 'Test Deal Wizard Question';
    insert dw;

    Deal_Reviews__c dr = new Deal_Reviews__c();
    dr.Opportunity__c = o.Id;
    dr.Redemption_Address__c = addy.Id;
    dr.Source__c = 'Yelp';
    dr.Type__c = 'Rating';
    dr.Unit__c = 'Stars';
    dr.Number_of_Ratings__c = 1000;
    dr.Rating__c = 10;
    insert dr;
    
    Test.StartTest();
    
    OpportunityCloneRedirectController ctrl = new OpportunityCloneRedirectController(new ApexPages.StandardController(o));
    ctrl.cloneOpportunity();
    
    OpptyCloneChannelTravel ctrl1 = new OpptyCloneChannelTravel(new ApexPages.StandardController(o));
    ctrl1.cloneAndRedirectTravel();    
    
    OpportunityCloneLive ctrl2 = new OpportunityCloneLive(new ApexPages.StandardController(o));
    ctrl2.cloneAndRedirectLive();
    
    OpportunityCloneRedirectControllerNTL ctrl3 = new OpportunityCloneRedirectControllerNTL(new ApexPages.StandardController(o));
    ctrl3.cloneAndRedirectNTL();
   
    Test.StopTest();
  }
}