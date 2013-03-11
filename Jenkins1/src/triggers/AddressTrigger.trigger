trigger AddressTrigger on Address__c (before insert, before update, after insert, after update)
{
	TriggerServices.runTriggerWorkflow(new ZipAndSubDivisionPopulationWorkflow(Trigger.new, Trigger.old, Trigger.isBefore, Trigger.isAfter));
	if(Trigger.isAfter && Trigger.isUpdate)
	{
		TriggerServices.runTriggerWorkflow(new ZenDeskRATicketSubmissionWorkflow(Trigger.new, Trigger.old));
	}
}