/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/26/02

* @Last Change: 2013/26/02 by MK

* Description.: Class to run before update on Account. Populates QL Flag fields on the QL record, QL Resolution fields on the Account, and QL Flag Status on the Account

* Dependencies: AccountTrigger
* ===================================================================
*/

public with sharing class QuantumLeadAccountWorkflow implements TriggerWorkflow {
  Map<ID, Account> newMap;
  Map<ID, Account> oldMap;

  List<Account> flaggedAccounts;
  List<Quantum_Lead__c> quantumLeadRecordsInTrigger;
  List<Quantum_Lead__c> quantumLeadRecordsToUpdate;

  public QuantumLeadAccountWorkflow (Map<ID, Account> newMap, Map<ID, Account> oldMap) {
    this.newMap = newMap;
    this.oldMap = oldMap;

    flaggedAccounts = new List<Account>();
    quantumLeadRecordsInTrigger = new List<Quantum_Lead__c>();
    quantumLeadRecordsToUpdate = new List<Quantum_Lead__c>();
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      loadFlaggedAccounts();
      loadQuantumLeads();

      for (Account a : newMap.values()) {
        populateQLFlagFields(a);
        populateQLResolutionFields(a);
        populateQLFlagStatus(a);
      }

      hasExecuted = true;
    }
  }

  private void loadFlaggedAccounts() {
    for(Account a: newMap.values()) {
      if (oldMap.get(a.Id).Account_Status__c != 'Merchant Research Flag' && a.Account_Status__c == 'Merchant Research Flag') {
        flaggedAccounts.add(a);
      }
    }
  }

  private void loadQuantumLeads() {
    if(flaggedAccounts.size() > 0) {
        quantumLeadRecordsInTrigger = [SELECT Id, Account__r.Id, Call_List_Priority__c, Sales_Value__c, Sales_Value_Reasons__c FROM Quantum_Lead__c WHERE Account__c IN : flaggedAccounts];
    }
  }

  public void populateQLFlagFields (Account a) {
    if(oldMap != null) {
      if (oldMap.get(a.Id).Account_Status__c != 'Merchant Research Flag' && a.Account_Status__c == 'Merchant Research Flag') {
        for(Quantum_Lead__c ql : quantumLeadRecordsInTrigger) {
          if(ql.Account__r.Id == a.Id) {
            ql.QL_Flag_Call_List_Priority__c = ql.Call_List_Priority__c;
            ql.QL_Flag_Sales_Value__c = ql.Sales_Value__c;
            ql.QL_Flag_Sales_Value_Reason__c = ql.Sales_Value_Reasons__c;
            ql.QL_Flag_Timestamp__c = System.Now();
            quantumLeadRecordsToUpdate.add(ql);
          }
        }
      }
    }
    
    try {
     Database.SaveResult[] SR = database.update(quantumLeadRecordsToUpdate);
    } catch(DMLException e)  {
      System.debug('Error: ' + e);
    }
  }

  public void populateQLResolutionFields (Account a) {
    if(oldMap.get(a.Id).QL_Flag_Status__c != 'Resolved' && a.QL_Flag_Status__c == 'Resolved') {
      a.Quantum_Lead_Flag_Reason__c = '';
      a.Quantum_Lead_Flag_Reason_Description__c = '';
      a.Most_Recent_QL_Resolution_Date__c = System.Now();
      a.Most_Recent_QL_Resolver__c = UserInfo.getUserId();
    }
  }

  public void populateQLFlagStatus (Account a) {
    if(oldMap.get(a.Id).Quantum_Lead_Flag_Reason__c == null && a.Quantum_Lead_Flag_Reason__c != null) {
      a.QL_Flag_Status__c = 'Unresolved';
    }
  }
}