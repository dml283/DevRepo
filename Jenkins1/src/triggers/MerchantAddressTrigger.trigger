trigger MerchantAddressTrigger on Merchant_Addresses__c (before insert, before update, after insert, after update) 
{
    if(Trigger.isBefore)
    {
    	TriggerServices.runTriggerWorkflow(new CanadianZipCodeInsertSpaceWorkflow(Trigger.new, Trigger.old));
    }
    else if(Trigger.isAfter)
    {
    	if(Trigger.isUpdate)
    	{
    		TriggerServices.runTriggerWorkflow(new SyncRedemptionAddressesWorkflow(Trigger.newMap, Trigger.oldMap));
    		TriggerServices.runTriggerWorkflow(new AccountRTTSUpdateWorkflow(Trigger.newMap, Trigger.oldMap));
    	}
    }
    TriggerServices.runTriggerWorkflow(new ZipAndSubDivisionPopulationWorkflow(Trigger.New, Trigger.Old, Trigger.isBefore, Trigger.isAfter));
    
}