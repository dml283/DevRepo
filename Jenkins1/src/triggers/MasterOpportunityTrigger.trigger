trigger MasterOpportunityTrigger on opportunity (before update, after update){
  /*
  OpportunityTriggerFactoryPR TF = new OpportunityTriggerFactoryPR(trigger.new,trigger.old,Trigger.NewMap.keySet(),Trigger.OldMap.keySet(),Trigger.newmap,Trigger.oldmap);

  if(trigger.isBefore) {
    if(!OpportunityTriggerFactoryPR.hasRunBefore)
    {
        TF.run();
        OpportunityTriggerFactoryPR.hasRunBefore = true;
    }
  }
  if(trigger.isAfter) {
    if(!OpportunityTriggerFactoryPR.hasRunAfter)
    {
        TF.runAfter();
//    MessageBus.notify('Opportunity', 'Update', Trigger.NewMap.KeySet());
      OpportunityTriggerFactoryPR.hasRunAfter = true;
    }
  }
  
  */
  
}