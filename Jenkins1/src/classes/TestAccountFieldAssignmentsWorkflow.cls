@isTest
class TestAccountFieldAssignmentsWorkflow {
  static testMethod void testPreviousAccountOwner() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'testPreviousAccountOwner1@groupon.com', 'testPreviousAccountOwner1@groupon.com');
    User u2 = TestUtil.createUserWithUsername ('Inside Sales', 'testPreviousAccountOwner2@groupon.com', 'testPreviousAccountOwner2@groupon.com');
    Account a1;
    Account a2;

    System.runAs (u1) {
        a1 = TestUtil.createAccount();
        a1.OwnerId = UserInfo.getUserId();
        insert a1;
    }
    
    System.runAs (u2) {
        a2 = TestUtil.createAccount();
        a2.OwnerId = UserInfo.getUserId();
        insert a2;
    }
    
    //Testing for Owner Change
    AccountFieldAssignmentsWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account>{a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account>{a2.Id => a2};
    AccountFieldAssignmentsWorkflow afaw = new AccountFieldAssignmentsWorkflow(newMap, oldMap);
    
    AccountFieldAssignmentsWorkflow.hasExecuted = false;
    afaw.execute();
    System.assertEquals(a2.Previous_Account_Owner__c, u1.Id);

    //Testing for no Owner Change
    AccountFieldAssignmentsWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap1 = new Map<ID, Account>{a1.Id => a1};
    AccountFieldAssignmentsWorkflow afaw1 = new AccountFieldAssignmentsWorkflow(oldMap1, oldMap1);
    
    AccountFieldAssignmentsWorkflow.hasExecuted = false;
    afaw1.execute();
    System.assertEquals(a1.Previous_Account_Owner__c, null);

  }
  
  static testMethod void testNowDealClosedBy() {
    User u1 = TestUtil.createUserWithUsername ('System Administrator', 'testAccountFieldAssignment1@groupon.com', 'testAccountFieldAssignment1@groupon.com');
    Division__c d1;
    Account a1;
    GrouponNow__c g1;
    Now_Redemption_Address__c nra;
    NOW_Schedule__c ns;

    System.runAs (u1) {
        d1 = TestUtil.createDivision();
        insert d1;
        
        a1 = TestUtil.createAccount();
        a1.Division__c = d1.Id;
        a1.Now_Deal_Owner__c = UserInfo.getUserId();
        a1.Now_Deal_Closed_By__c = null;
        a1.Make_Checks_Payable_to__c = 'Test Name';
        a1.Tax_ID__c = '123456789';
        insert a1;
        
        g1 = TestUtil.createGrouponNow(a1, d1);
        
        nra = TestUtil.createNowAddress(g1);
        
        ns = TestUtil.createNowSchedule(g1);
        
        g1.Stage__c = 'Closed Won';
        update g1;
    }
    
    AccountFieldAssignmentsWorkflow.hasExecuted = true;
    a1 = [SELECT Id, OwnerId, Now_Deal_Closed_By__c, Now_Deal_Owner__c, Now_Status__c FROM Account WHERE Id =: a1.Id];
    Map<ID, Account> newMap = new Map<ID, Account>{a1.Id => a1};
    AccountFieldAssignmentsWorkflow afaw = new AccountFieldAssignmentsWorkflow(newMap, newMap);
    
    AccountFieldAssignmentsWorkflow.hasExecuted = false;
    afaw.execute();
    System.assertEquals(a1.Now_Deal_Closed_By__c, a1.Now_Deal_Owner__c);
  }
}