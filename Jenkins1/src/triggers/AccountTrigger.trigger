/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/21/02

* @Last Change: 2013/21/02 by MK

* Description.: Dispatches workflows on each trigger action

* Dependencies: AccountTaxonomyWorkflow, AccountFieldAssignmentsWorkflow, ACHFieldUpdateWorkflow, QuantumLeadAccountWorkflow, RewardsOfferStatusWorkflow, QuantumLeadDeleteWorkflow, TINValidationWorkflow
* ===================================================================
*/

trigger AccountTrigger on Account (before update, before delete, after update) {

  if(Trigger.isBefore) {
    
    if(Trigger.isUpdate) {
      TriggerServices.runTriggerWorkflow (new AccountFieldAssignmentsWorkflow(Trigger.newMap, Trigger.oldMap));
      TriggerServices.runTriggerWorkflow (new ACHFieldUpdateWorkflow(Trigger.newMap, Trigger.oldMap));
      TriggerServices.runTriggerWorkflow (new QuantumLeadAccountWorkflow(Trigger.newMap, Trigger.oldMap));
      TriggerServices.runTriggerWorkflow (new RewardsOfferStatusWorkflow(Trigger.newMap, Trigger.oldMap));
      TriggerServices.runTriggerWorkflow (new AccountTaxonomyWorkflow(Trigger.newMap, Trigger.oldMap));
    }
    if (Trigger.isDelete) {
      TriggerServices.runTriggerWorkflow (new QuantumLeadDeleteWorkflow(Trigger.oldMap));
    }

  } else {
    TriggerServices.runTriggerWorkflow (new TINValidationWorkflow(Trigger.newMap, Trigger.oldMap));
/*
    TriggerServices.runTriggerWorkflow (new MsgBusAcctWorkflow(Trigger.newMap, Trigger.oldMap, Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete));
      if (Trigger.isDelete)
      {
         TriggerServices.runTriggerWorkflow (new MsgBusAcctWorkflow(Trigger.newMap, Trigger.oldMap, Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete));
      }
*/
  }
}