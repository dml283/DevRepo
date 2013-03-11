global class AMTaskOwnerUpdate {
    public static void setAMTaskOwner(List<Task> beforeInsertTasks) {
    Set<Id>taskWhatIds = new Set<Id>();
        
        for(Task t : beforeInsertTasks) {
            taskWhatIds.add(t.whatID);
        }

        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT Id, AccountId, AccountCoordinator__c, AccountCoordinator__r.IsActive, AccountCoordinator__r.ManagerId, Account.Call_List_Priority__c FROM Opportunity WHERE Id IN:taskWhatIds]);

        for(task t :beforeInsertTasks) {
            if(t.whatid != null && t.OwnerID == '00580000001YaJI'){
                if(t.Subject.contains('Maintenance:')){
                   string taskwhatid = t.WhatId;
                   if(taskwhatid.substring(0,3) == '006'){
                       opportunity o = oppMap.get(t.whatID);
                        if(o != null) {
                            if(o.AccountCoordinator__c != null) {
                                if(o.AccountCoordinator__r.IsActive == True) {
                                    t.ownerID=o.AccountCoordinator__c;
                                } else {
                                    t.ownerID=o.AccountCoordinator__r.ManagerId;                                
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}