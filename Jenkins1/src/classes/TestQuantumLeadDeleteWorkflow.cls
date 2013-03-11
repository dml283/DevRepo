@isTest
class TestQuantumLeadDeleteWorkflow {

  static testMethod void testDeleteQLRecords() {
    User u1 = TestUtil.createUserWithUsername ('System Administrator', 'testPreviousAccountOwner1@groupon.com', 'testPreviousAccountOwner1@groupon.com');
    Account a1;
    Quantum_Lead__c q;

    System.runAs (u1) {

      a1 = TestUtil.createAccount();
      insert a1;

      q = TestUtil.createQuantumLead(a1,True);

      Delete a1;
    }

    try {
      q = [SELECT Id FROM Quantum_Lead__c WHERE Id =: q.Id];
    } catch(Exception e) {
      System.assertEquals (e.getMessage(),'List has no rows for assignment to SObject');
    }
  }
}