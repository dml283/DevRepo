/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/26/02

* @Last Change: 2013/26/02 by MK

* Description.: Class to run before delete on Account. Deletes QL record associated with a deleted Account

* Dependencies: AccountTrigger
* ===================================================================
*/

public with sharing class QuantumLeadDeleteWorkflow implements TriggerWorkflow {
  Map<ID, Account> oldMap;
  List<Quantum_Lead__c> quantumLeadRecordsToDelete;

  public QuantumLeadDeleteWorkflow (Map<ID, Account> oldMap) {
    this.oldMap = oldMap;
    quantumLeadRecordsToDelete = new List<Quantum_Lead__c>();
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      deleteQLRecord();

      hasExecuted = true;
    }
  }

  private void deleteQLRecord() {
    quantumLeadRecordsToDelete = [SELECT Id, Account__r.Id, Call_List_Priority__c, Sales_Value__c, Sales_Value_Reasons__c FROM Quantum_Lead__c WHERE Account__c IN : oldMap.values()];
    Delete quantumLeadRecordsToDelete;
  }
}