@isTest
class TestACHFieldUpdateWorkflow {

  static testMethod void testPopulateLastACHUpdate() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'testPreviousAccountOwner1@groupon.com', 'testPreviousAccountOwner1@groupon.com');
    Account a1;
    Account a2;

    System.runAs (u1) {
      a1 = TestUtil.createAccount();
      a1.OwnerId = UserInfo.getUserId();
      a1.Routing_Number_enc__c = '123456789';
      a1.Account_Number__c = '123456789';
      insert a1;

      a2 = TestUtil.createAccount();
      a2.OwnerId = UserInfo.getUserId();
      a2.Routing_Number_enc__c = '987654321';
      a2.Account_Number__c = '987654321';
      a2.BillingStreet = '600 W. Chicago Ave. 6th Floor';
      insert a2;
    }

    //Test for update to ACH fields
    ACHFieldUpdateWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account> {a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account> {a2.Id => a2};
    ACHFieldUpdateWorkflow afuw = new ACHFieldUpdateWorkflow (newMap, oldMap);

    ACHFieldUpdateWorkflow.hasExecuted = false;
    afuw.execute();
    System.assertEquals (a2.Last_ACH_Update__c, System.today());

    //Test for no update to ACH fields
    ACHFieldUpdateWorkflow.hasExecuted = true;
    Map<ID, Account> newMap1 = new Map<ID, Account> {a1.Id => a1};
    ACHFieldUpdateWorkflow afuw1 = new ACHFieldUpdateWorkflow (newMap1, newMap1);

    ACHFieldUpdateWorkflow.hasExecuted = false;
    afuw1.execute();
    System.assertEquals (a1.Last_ACH_Update__c, null);
  }

  static testMethod void testValidRoutingNumberUpdate() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'testAccountFieldAssignment1@groupon.com', 'testAccountFieldAssignment1@groupon.com');
    Account a3;
    Account a4;
    Account a5;

    System.runAs (u1) {

      a3 = TestUtil.createAccount();
      a3.BillingStreet = '600 W Chicago Ave';
      a3.BillingCity = 'Montreal';
      a3.BillingState = 'QC';
      a3.BillingPostalCode = 'G0A';
      a3.BillingCountry = 'CA';
      a3.TransitNumber__c  ='12345678';
      a3.Payment_Preference__c = 'ACH (Direct Deposit)';
      insert a3;

      a4 = TestUtil.createAccount();
      a4.BillingStreet = '600 W Chicago Ave';
      a4.BillingCity = 'Chicago';
      a4.BillingState = 'IL';
      a4.BillingPostalCode = '60654';
      a4.BillingCountry = 'US';
      a4.TransitNumber__c  = null;
      a4.Payment_Preference__c = 'ACH (Direct Deposit)';
      a4.Routing_Number_enc__c ='111000025';
      insert a4;

      a5 = TestUtil.createAccount();
      a5.Payment_Preference__c = 'ACH (Direct Deposit)';
      a5.Routing_Number_enc__c ='12345';
      insert a5;
    }
    
    //Test for 'N/A'
    ACHFieldUpdateWorkflow.hasExecuted = true;
    Map<ID, Account> newMap1 = new Map<ID, Account> {a3.Id => a3};
    ACHFieldUpdateWorkflow afuw1 = new ACHFieldUpdateWorkflow (newMap1, newMap1);

    ACHFieldUpdateWorkflow.hasExecuted = false;
    afuw1.execute();
    System.assertEquals (a3.Valid_Routing__c, 'N/A');
    
    //Test for 'Yes'
    ACHFieldUpdateWorkflow.hasExecuted = true;
    Map<ID, Account> newMap2 = new Map<ID, Account> {a4.Id => a4};
    ACHFieldUpdateWorkflow afuw2 = new ACHFieldUpdateWorkflow (newMap2, newMap2);

    ACHFieldUpdateWorkflow.hasExecuted = false;
    afuw2.execute();
    System.assertEquals (a4.Valid_Routing__c, 'Yes');
    
    //Test for 'No'
    ACHFieldUpdateWorkflow.hasExecuted = true;
    Map<ID, Account> newMap3 = new Map<ID, Account> {a5.Id => a5};
    ACHFieldUpdateWorkflow afuw3 = new ACHFieldUpdateWorkflow (newMap3, newMap3);

    ACHFieldUpdateWorkflow.hasExecuted = false;
    afuw3.execute();
    System.assertEquals (a5.Valid_Routing__c, 'No');
  }
}