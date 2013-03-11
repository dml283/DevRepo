/* ===================================================================
* OpptyTrigger

* @author.....: Naushad Rafique

* @date.......: 2013/13/02

* @Last Change: 2013/15/02 by SS

* Description.: Class dispatch different classes upon opportunity trigger fires

* Dependencies: TriggerServices
* ===================================================================
*/
trigger OpptyTrigger on Opportunity (before insert, after insert, before update, after update, after delete)
{
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            TriggerServices.runTriggerWorkflow(new InitializeOpportunityWorkflow(Trigger.New));
        }
        if(Trigger.isUpdate)
        {
            TriggerServices.runTriggerWorkflow(new OpportunityFieldAssignmentsWorkflow(Trigger.newMap, Trigger.oldMap));
            TriggerServices.runTriggerWorkflow(new MerchantCentreCreationWorkflow(Trigger.newMap, Trigger.oldMap));
            TriggerServices.runTriggerWorkflow(new QuantumLeadWorkflow(Trigger.newMap, Trigger.oldMap));
        }
    }
    else //is after
    {
        TriggerServices.runTriggerWorkflow(new QuestionsCRUDWorkflow(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.old, Trigger.new));
        
        if(Trigger.isInsert)
        {
            //TriggerServices.runTriggerWorkflow(new MessageBusWorkflow(Trigger.newMap, Trigger.oldMap, 'create'));
        }
                
        if(Trigger.isUpdate)
        {
            //TriggerServices.runTriggerWorkflow(new MessageBusWorkflow(Trigger.newMap, Trigger.oldMap, 'update'));
            TriggerServices.runTriggerWorkflow(new ZenDeskOpptyTicketSubmissionWorkflow(Trigger.New, Trigger.old));
            TriggerServices.runTriggerWorkflow(new NetSuiteCreationWorkflow(Trigger.newMap, Trigger.oldMap));
            TriggerServices.runTriggerWorkflow(new MultiDealAccountUpdateWorkflow(Trigger.newMap, Trigger.oldMap));
        }
        if(Trigger.isDelete)
        {
            //TriggerServices.runTriggerWorkflow(new MessageBusWorkflow(Trigger.newMap, Trigger.oldMap, 'delete'));
        }
    } 
}