trigger LeadMaster on Lead (before update, before insert) {

  if (Trigger.isBefore) {
    if (Trigger.isUpdate || Trigger.isInsert) {
      TriggerDispatcher.dispatch(new LeadDynamicZipcode());
      TriggerDispatcher.dispatch(new LeadUpdateTaxonomy());
    }

    if (Trigger.isUpdate) {
      TriggerDispatcher.dispatch(new LeadUpdateMerchant());
    }
  }

  if (Trigger.isAfter) {
    if (Trigger.isUpdate) {
      TriggerDispatcher.dispatch(new LeadInsertTaxonomy());
    }
  }

}