global class QuantumLeadAccountUpdates {
//Waiting to Delete
/*
  public static void populateQLFlagFields(List<Account> accountsInTrigger, Map<Id,Account> triggerNewMap, Map<Id,Account> triggerOldMap) {
    List<Account> flaggedAccounts = new List<Account>();
    List<Quantum_Lead__c> quantumLeadRecordsInTrigger = new List<Quantum_Lead__c>();
    List<Quantum_Lead__c> quantumLeadRecordsToUpdate = new List<Quantum_Lead__c>();
 
    for (Account account : accountsInTrigger) {
      System.debug('Account status changed');
      if (triggerOldMap.get(account.Id).Account_Status__c != 'Merchant Research Flag' && account.Account_Status__c == 'Merchant Research Flag') {
        flaggedAccounts.add(account);
      }
    }
        
    if(flaggedAccounts.size() > 0) {
      quantumLeadRecordsInTrigger = [SELECT Id, Account__r.Id, Call_List_Priority__c, Sales_Value__c, Sales_Value_Reasons__c FROM Quantum_Lead__c WHERE Account__c IN : flaggedAccounts];
    }
        
    for (Account account : flaggedAccounts) {
      if(triggerOldMap != null) {
        if (triggerOldMap.get(account.Id).Account_Status__c != 'Merchant Research Flag' && account.Account_Status__c == 'Merchant Research Flag') {
          for(Quantum_Lead__c ql : quantumLeadRecordsInTrigger) {
            if(ql.Account__r.Id == account.Id) {
              ql.QL_Flag_Call_List_Priority__c = ql.Call_List_Priority__c;
              ql.QL_Flag_Sales_Value__c = ql.Sales_Value__c;
              ql.QL_Flag_Sales_Value_Reason__c = ql.Sales_Value_Reasons__c;
              ql.QL_Flag_Timestamp__c = System.Now();
              quantumLeadRecordsToUpdate.add(ql);
            }
          }
        }
      }
    }
    try{
     Database.SaveResult[] SR = database.update(quantumLeadRecordsToUpdate);
    }catch(DMLException e)  {}
  }

  public static void qlFlagResolutionUpdates(List<Account> accountsInTrigger, Map<Id,Account> triggerNewMap, Map<Id,Account> triggerOldMap) {
    List<Account> resolvedAccounts = new List<Account>();
    List<Account> unresolvedAccounts = new List<Account>();
    for (Account account : accountsInTrigger) {
      if (triggerOldMap.get(account.Id).QL_Flag_Status__c != 'Resolved' && account.QL_Flag_Status__c == 'Resolved') {
        resolvedAccounts.add(account);
      }
      if (triggerOldMap.get(account.Id).Quantum_Lead_Flag_Reason__c == null && account.Quantum_Lead_Flag_Reason__c != null) {
        unresolvedAccounts.add(account);
      }
    }

    for(Account account : resolvedAccounts) {
      account.Quantum_Lead_Flag_Reason__c = '';
      account.Quantum_Lead_Flag_Reason_Description__c = '';
      account.Most_Recent_QL_Resolution_Date__c = System.Now();
      account.Most_Recent_QL_Resolver__c = account.LastmodifiedbyId;
    }

    for(Account account : unresolvedAccounts) {
      account.QL_Flag_Status__c = 'Unresolved';
    }
  }

  public static void deleteDuplicateQLRecords(List<Account> accountsInTrigger) {
    List<Quantum_Lead__c> quantumLeadRecordsToDelete = new List<Quantum_Lead__c>();
    quantumLeadRecordsToDelete = [SELECT Id, Account__r.Id, Account__c FROM Quantum_Lead__c WHERE Account__c IN : accountsInTrigger];
    Delete quantumLeadRecordsToDelete;
  }
*/
}