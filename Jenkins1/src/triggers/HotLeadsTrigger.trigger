trigger HotLeadsTrigger on Task (after insert, after update) {
    List<Task> tasksInTrigger = new List<Task>();
    List<Task> taskOwnerProfile = new List<Task>();
    List<user> users = new List<User>();
    Set<id> userOwnerId = new Set<Id>();
    Set<Id> inboundLeadsInTrigger = new Set<Id>();
    Set<Id> inboundAcctsInTrigger = new Set<Id>();
    Set<Id> inboundContactsInTrigger = new Set<Id>();
    Set<Id> outboundLeadsInTrigger = new Set<Id>();
    Set<Id> outboundAcctsInTrigger = new Set<Id>();
    Set<Id> outboundContactsInTrigger = new Set<Id>();
    Map<Id,Task> oldTask = new Map<Id,Task>();
    Map<Id,String> userProfiles = new Map<Id,String>();

    if(trigger.isUpdate) {
        for(Task taskOld : trigger.old) {                     
            oldTask.put(taskOld.id, taskOld);              
        }
    }
    
    tasksInTrigger = [SELECT Id, owner.Profile.Name, WhoId, WhatId, Type, Status, OwnerId FROM Task WHERE (Type = 'Call - Outbound' OR Type = 'Email' OR Type = 'Email - Outbound' OR Type = 'In-Person' OR Type = 'Meeting' OR Type = 'Call - Phone Bank Inbound' OR Type = 'Call - Phone Bank Inbound POS' OR Type = 'Inbound') AND Id IN :Trigger.new];
        
    for(Task t : tasksInTrigger) {
        userProfiles.put(t.Id,t.owner.Profile.Name);
    }

    system.debug('User Profile Map: ' + userProfiles);

    //Find the Inbound Tasks in the trigger based on Type. Only include those that are being created or those have the Type changed to one of the inbound values
    for (task t :tasksInTrigger) {
        if((t.Type == 'Call - Phone Bank Inbound POS' || t.Type == 'Call - Phone Bank Inbound' || (t.Type == 'Inbound' && userProfiles.get(t.Id) == 'Warm Leads Sales')) && (trigger.isInsert || (trigger.isUpdate && oldTask.IsEmpty() == False && oldTask.get(t.Id).Type != t.Type && oldTask.get(t.Id).Type != 'Call - Phone Bank Inbound POS'  && oldTask.get(t.Id).Type != 'Call - Phone Bank Inbound' && oldTask.get(t.Id).Type != 'Inbound'))) {
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
        if((t.Type == 'Call - Outbound' || t.Type == 'Email' || t.Type == 'Email - Outbound' || t.Type == 'In-Person' || t.Type == 'Meeting') && t.Status == 'Completed' && (Trigger.isInsert || (Trigger.isUpdate && oldTask.get(t.Id).Status != 'Completed'))) {
                    
            //Determine if the outbound task in on a lead or account and add to the related set
            if(t.whoid!=null) {
                String taskWhoId = t.whoid;
                
                if(taskWhoId.substring(0,3)=='00Q') {
                    Id outboundLeadId = t.WhoId;
                    outboundLeadsInTrigger.add(outboundLeadId);
                }
                    
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

    for(Contact c : [SELECT Id, Account.Id FROM Contact WHERE Id IN: inboundContactsInTrigger]) {
        inboundAcctsInTrigger.add(c.account.id);
    }

    for(Contact c : [SELECT Id, Account.Id FROM Contact WHERE Id IN: outboundContactsInTrigger]) {
        outboundAcctsInTrigger.add(c.account.id);
    }
            
    HotLeads.UpdatePhoneBankAcct(inboundAcctsInTrigger);
    HotLeads.UpdatePhoneBankLead(inboundLeadsInTrigger);
    HotLeads.UpdateOutboundAcct(outboundAcctsInTrigger);
    HotLeads.UpdateOutboundLead(outboundLeadsInTrigger);

}