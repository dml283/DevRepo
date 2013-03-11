/* ===================================================================
* TaskTrigger

* @author.....: Nick Prater

* @date.......: 2012/09/11

* @Last Change: 2013/19/02 by SS

* Description.: TO BE REFACTORED : Class to dispatch different classes upon task trigger fires.  

* Dependencies: 
* ===================================================================
*/
trigger TaskTrigger on Task (before insert, before update, after insert, after update) {
    List<Task> beforeInsertTasks = new List<Task>();
    List<Task> beforeTasksInTrigger = new List<Task>();
    Set<Id> inboundLeadsInTrigger = new Set<Id>();
    Set<Id> inboundAcctsInTrigger = new Set<Id>();
    Set<Id> inboundContactsInTrigger = new Set<Id>();
    Set<Id> outboundLeadsInTrigger = new Set<Id>();
    Set<Id> outboundAcctsInTrigger = new Set<Id>();
    Set<Id> outboundContactsInTrigger = new Set<Id>();
    Map<Id,Task> oldTask = new Map<Id,Task>();
    Map<Id,String> userProfiles = new Map<Id,String>();

    if(Trigger.isBefore) {
        for(Task t :Trigger.new) {
            beforeTasksInTrigger.add(t);
        }

        if(Trigger.isInsert) {
            for(Task t :Trigger.new) {
                beforeInsertTasks.add(t);
            }
        }
        MerchantStatusUpdateTask.setMerchantStatus(beforeInsertTasks);
        AMTaskOwnerUpdate.setAMTaskOwner(beforeInsertTasks);
        CompletedTaskUpdates.setCompletedDateTime(beforeTasksInTrigger,Trigger.newmap,Trigger.oldmap);
        CompletedTaskUpdates.setCompletedBy(beforeTasksInTrigger,Trigger.newmap,Trigger.oldmap);
        CompletedTaskUpdates.updateTaskCallListPriority(beforeTasksInTrigger,Trigger.newmap,Trigger.oldmap);
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert || trigger.isUpdate) {
            AM_StatusUpdater.setAmStatusFields(trigger.new); 
        }
        if(Trigger.isInsert){
        	TriggerServices.runTriggerWorkflow(new TaskQLWorkflow(Trigger.oldMap, Trigger.newMap, False, True)); 
        }

        if(Trigger.isUpdate) {
            for(Task taskOld : trigger.old) {                     
                oldTask.put(taskOld.id, taskOld);              
            }
            TriggerServices.runTriggerWorkflow(new TaskQLWorkflow(Trigger.oldMap, Trigger.newMap, False, False)); 
        }
            
        for(Task t : trigger.new) {
            userProfiles.put(t.Id,t.owner.Profile.Name);
        }

        system.debug('User Profile Map: ' + userProfiles);

        //Find the Inbound Tasks in the trigger based on Type. Only include those that are being created or those have the Type changed to one of the inbound values
        for (Task t :trigger.new) {
            if((t.Type == 'Call - Inbound' || t.Type == 'Call - Phone Bank Inbound POS' || t.Type == 'Call - Phone Bank Inbound' || (t.Type == 'Inbound' && userProfiles.get(t.Id) == 'Warm Leads Sales')) && (trigger.isInsert || (trigger.isUpdate && oldTask.IsEmpty() == False && oldTask.get(t.Id).Type != t.Type && oldTask.get(t.Id).Type != 'Call - Inbound' && oldTask.get(t.Id).Type != 'Call - Phone Bank Inbound' && oldTask.get(t.Id).Type != 'Inbound'))) {
                //Determine if the inbound task in on a lead or account and add to the related set
                if(t.whoid!=null) {
                    String taskWhoId = t.whoid;
                    
                    if(taskWhoId.substring(0,3)=='00Q') {
                        Id inboundLeadId = t.WhoId;
                        inboundLeadsInTrigger.add(inboundLeadId);
                    }
                    
                    if(taskWhoId.substring(0,3)=='003') {
                        Id inboundContactId = t.WhoId;
                        inboundContactsInTrigger.add(inboundContactId);
                    }
                }
                    
                if(t.whatid!=null) {
                    String taskWhatId = t.whatid;
                    
                    if(taskWhatId.substring(0,3)=='001') {
                        Id inboundAccountId = t.WhatId;
                        inboundAcctsInTrigger.add(inboundAccountId);
                    }
                }
            }
                
            //Find the Outbound Tasks in the trigger based on Type. Only include those that are being created or those have the Status changed to 'Completed'
            if((t.Type == 'Call - Outbound' || t.Type == 'Email - Outbound' || t.Type == 'In-Person' || t.Type == 'Meeting' || t.Type == 'Email' || t.Type == 'Email - Click' || t.Type == 'Email - Open' || t.Type == 'Other Forms of Contact') && t.Status == 'Completed' && (Trigger.isInsert || (Trigger.isUpdate && oldTask.get(t.Id).Status != 'Completed'))) {
                        
                //Determine if the outbound task in on a lead or account and add to the related set
                if(t.whoid!=null) {
                    String taskWhoId = t.whoid;
                    if(taskWhoId.substring(0,3)=='003') {
                        Id outboundContactId = t.WhoId;
                        outboundContactsInTrigger.add(outboundContactId);
                    }
                }
                    
                if(t.whatid!=null) {
                    String taskWhatId = t.whatid;
                    
                    if(taskWhatId.substring(0,3)=='001') {
                        Id outboundAccountId = t.WhatId;
                        outboundAcctsInTrigger.add(outboundAccountId);
                    }
                }
            }
        }

        if(inboundAcctsInTrigger != null) {
            HotLeads.UpdatePhoneBankAcct(inboundAcctsInTrigger);
        }
        if(inboundLeadsInTrigger != null) {
            HotLeads.UpdatePhoneBankLead(inboundLeadsInTrigger);
        }
        if(outboundAcctsInTrigger != null) {
            HotLeads.UpdateOutboundAcct(outboundAcctsInTrigger);
        }
        
    }
}