Trigger AMTasksTrigger on Task (before insert) {

//Create a list of inserted tasks that are assigned to House Account
set<id>TaskOpps = new set<id>();
for(task t :trigger.new)
    taskOpps.add(t.whatID);
map<id,opportunity> opp_map = new map<id,opportunity>([select id,AccountCoordinator__c, AccountCoordinator__r.IsActive, AccountCoordinator__r.ManagerId from opportunity where AccountCoordinator__c <> null and id in :TaskOpps]);

for(task t :Trigger.new){
    if(t.whatid != null && t.OwnerID == '00580000001YaJI'){
        if(t.Subject.contains('Merchant Call')){
           string taskwhatid = t.WhatId;
           if(taskwhatid.substring(0,3) == '006'){
               opportunity o = opp_map.get(t.whatID);
               if(o != null) 
                   {
                       if(o.AccountCoordinator__r.IsActive == True)
                         {
                             t.ownerID=o.AccountCoordinator__c;
                         }else{
                             t.ownerID=o.AccountCoordinator__r.ManagerId;
                         }
         
                   }
            }
        }
    }
}

}