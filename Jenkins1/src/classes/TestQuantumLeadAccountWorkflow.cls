@isTest
class TestQuantumLeadAccountWorkflow {

  static testMethod void testpopulateQLFlagFields() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'testPreviousAccountOwner1@groupon.com', 'testPreviousAccountOwner1@groupon.com');
    Account a1;
    Account a2;
    Quantum_Lead__c q;

    System.runAs (u1) {
      a1 = TestUtil.createAccount();
      a1.OwnerId = UserInfo.getUserId();
      a1.Result_of_Merchant_Survey__c = 'Prospecting';
      a1.Account_Status__c = 'Contacted';
      insert a1;

      a2 = TestUtil.createAccount();
      a2.OwnerId = UserInfo.getUserId();
      a2.Result_of_Merchant_Survey__c = 'Groupon Not Interested';
      a2.Account_Status__c = 'Merchant Research Flag';
      insert a2;

      q = TestUtil.createQuantumLead(a2,True);
      q.Sales_Value_Reasons__c = 'Test Reason';
      update q;
    }

    QuantumLeadAccountWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account> {a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account> {a2.Id => a2};
    QuantumLeadAccountWorkflow qlaw1 = new QuantumLeadAccountWorkflow (newMap, oldMap);

    QuantumLeadAccountWorkflow.hasExecuted = false;
    qlaw1.execute();
    q = [SELECT Id, Account__c, Call_List_Priority__c, Sales_Value__c, Sales_Value_Reasons__c, QL_Flag_Call_List_Priority__c, QL_Flag_Sales_Value__c, QL_Flag_Sales_Value_Reason__c FROM Quantum_Lead__c WHERE Id =: q.Id];
    System.assertEquals (q.QL_Flag_Call_List_Priority__c, q.Call_List_Priority__c);
    System.assertEquals (q.QL_Flag_Sales_Value__c, q.Sales_Value__c);
    System.assertEquals (q.QL_Flag_Sales_Value_Reason__c, q.Sales_Value_Reasons__c);
  }

  static testMethod void testpopulateQLResolutionFields() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'testPreviousAccountOwner1@groupon.com', 'testPreviousAccountOwner1@groupon.com');
    Account a1;
    Account a2;

    System.runAs (u1) {
      a1 = TestUtil.createAccount();
      a1.OwnerId = UserInfo.getUserId();
      a1.Quantum_Lead_Flag_Reason__c = 'Test Reason';
      a1.Quantum_Lead_Flag_Reason_Description__c = 'Test Reason Description';
      a1.QL_Flag_Status__c = 'Unresolved';
      insert a1;

      a2 = TestUtil.createAccount();
      a2.OwnerId = UserInfo.getUserId();
      a2.Quantum_Lead_Flag_Reason__c = 'Test Reason';
      a2.Quantum_Lead_Flag_Reason_Description__c = 'Test Reason Description';
      a2.QL_Flag_Status__c = 'Resolved';
      insert a2;
    }

    QuantumLeadAccountWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account> {a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account> {a2.Id => a2};
    QuantumLeadAccountWorkflow qlaw2 = new QuantumLeadAccountWorkflow (newMap, oldMap);

    QuantumLeadAccountWorkflow.hasExecuted = false;
    qlaw2.execute();
    System.assertEquals (a2.Quantum_Lead_Flag_Reason__c, '');
    System.assertEquals (a2.Quantum_Lead_Flag_Reason_Description__c, '');
  }

  static testMethod void testpopulateQLFlagStatus() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'testPreviousAccountOwner1@groupon.com', 'testPreviousAccountOwner1@groupon.com');
    Account a1;
    Account a2;

    System.runAs (u1) {
      a1 = TestUtil.createAccount();
      a1.OwnerId = UserInfo.getUserId();
      a1.Quantum_Lead_Flag_Reason__c = null;
      insert a1;

      a2 = TestUtil.createAccount();
      a2.OwnerId = UserInfo.getUserId();
      a2.Quantum_Lead_Flag_Reason__c = 'Test Reason';
      insert a2;
    }

    QuantumLeadAccountWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account> {a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account> {a2.Id => a2};
    QuantumLeadAccountWorkflow qlaw3 = new QuantumLeadAccountWorkflow (newMap, oldMap);

    QuantumLeadAccountWorkflow.hasExecuted = false;
    qlaw3.execute();
    System.assertEquals (a2.QL_Flag_Status__c, 'Unresolved');
  }
}