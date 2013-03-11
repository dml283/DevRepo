global class CompletedTaskUpdates {
  public static void setCompletedDateTime(List<Task> beforeTasksInTrigger, Map<Id,Task> triggerNewMap, Map<Id,Task> triggerOldMap) {
    for(Task t : beforeTasksInTrigger) {
      if(t.Status == 'Completed') {
        if(triggerOldMap == null) {
          t.Completed_Date__c = system.today();
          t.Completed_Date_Time__c = system.now();
        } else if(triggerOldMap.get(t.Id).Status != 'Completed') {
          t.Completed_Date__c = system.today();
          t.Completed_Date_Time__c = system.now();
        }
      }
    }
  }

  public static void setCompletedBy(List<Task> beforeTasksInTrigger, Map<Id,Task> triggerNewMap, Map<Id,Task> triggerOldMap) {
    for(Task t : beforeTasksInTrigger) {
      if(t.Status == 'Completed') {
        if(triggerOldMap == null) {
          t.Completed_By__c = UserInfo.getName();
        } else if(triggerOldMap.get(t.Id).Status != 'Completed') {
          t.Completed_By__c = UserInfo.getName();
        }
      }
    }
  }

  public static void updateTaskCallListPriority(List<Task> beforeTasksInTrigger, Map<Id,Task> triggerNewMap, Map<Id,Task> triggerOldMap) {
    List<Account> accountsInTrigger = new List<Account>();
    List<Task> completedTasks = new List<Task>();
    List<Quantum_Lead__c> quantumLeadList = new List<Quantum_Lead__c>();
    Map<Id, Account> accountMap = new Map<Id, Account>();
    Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    Map<Id, Quantum_Lead__c> quantumLeadMap = new Map<Id, Quantum_Lead__c>();
    Set<Id>taskAccountIds = new Set<Id>();
    Set<Id>taskOpportunityIds = new Set<Id>();
    Set<Id>taskWhoIds = new Set<Id>();

    for(Task t : beforeTasksInTrigger) {
      if(t.Status == 'Completed') {
        if(triggerOldMap == null) {
          completedTasks.add(t);
        } else if(triggerOldMap.get(t.Id).Status != 'Completed') {
          completedTasks.add(t);
        }
      }
    }

    for(Task t : completedTasks) {
      if(t.WhatId != null) {
        string taskWhatId = t.WhatId;
        if(taskWhatId.substring(0,3) == '001') {
          taskAccountIds.add(t.WhatId);
        }
        if(taskWhatId.substring(0,3) == '006') {
          taskOpportunityIds.add(t.WhatId);
        }
      }
    }

    for(Task t : completedTasks) {
      if(t.whoId != null && t.whatId == null) {
        string taskWhoId = t.whoId;
        if(taskWhoId.substring(0,3) == '003') {
          taskWhoIds.add(t.whoId);
        }
      }
    }

    if(taskAccountIds != null) {
      accountMap = new Map<Id,Account>([SELECT Id FROM Account WHERE Id IN:taskAccountIds]);
    }

    if(taskOpportunityIds != null) {
      oppMap = new Map<Id,Opportunity>([SELECT Id, AccountId, Account.Id FROM Opportunity WHERE Id IN:taskOpportunityIds]);
    } 

    if(taskWhoIds != null) {
      contactMap = new Map<Id,Contact>([SELECT Id, AccountId, Account.Id FROM Contact WHERE Id IN:taskWhoIds]);
    }
    
    for(task t :completedTasks) {
      system.debug('Task Who ID ' + t.WhoId);
      system.debug('Task What ID ' + t.WhatId);
      if(t.Whatid != null) {
        string taskwhatid = t.WhatId;
        if(taskwhatid.substring(0,3) == '006') {
          opportunity o = oppMap.get(t.whatID);
          accountsInTrigger.add(o.Account);
        } else if(taskwhatid.substring(0,3) == '001') {
          account a = accountMap.get(t.whatID);
          accountsInTrigger.add(a);
        }
      } else if (t.WhoId != null) {
        string taskwhoid = t.WhoId;
        if(taskwhoid.substring(0,3) == '003') {
          Contact c = contactMap.get(t.whoID);
          if (c != null) {
            accountsInTrigger.add(c.Account);
          }
        }
      }
    }
        
    quantumLeadList = [SELECT Account__c, Call_List_Priority__c, Sales_Value__c FROM Quantum_Lead__c WHERE Account__c IN:accountsInTrigger];

    for(Quantum_Lead__c ql : quantumLeadList) {
      quantumLeadMap.put(ql.Account__c, ql);
    }

    for(task t :completedTasks) {
      if(t.Whatid != null && t.Call_List_Priority__c == null) {
        string taskwhatid = t.WhatId;
        if(taskwhatid.substring(0,3) == '006') {
          opportunity o = oppMap.get(t.whatID);
          if(o != null && quantumLeadMap.get(o.Account.Id) != null) {
            if(quantumLeadMap.get(o.Account.Id).Call_List_Priority__c != null) {
              t.Call_List_Priority__c = quantumLeadMap.get(o.Account.Id).Call_List_Priority__c;
            }
            if(quantumLeadMap.get(o.Account.Id).Sales_Value__c != null) {
              t.Sales_Value__c = quantumLeadMap.get(o.Account.Id).Sales_Value__c;
            }
          }
        } else if(taskwhatid.substring(0,3) == '001') {
          account a = accountMap.get(t.whatID);
          if(a != null && quantumLeadMap.get(a.Id) != null) {
            if(quantumLeadMap.get(a.id).Call_List_Priority__c != null) {
              t.Call_List_Priority__c = quantumLeadMap.get(a.id).Call_List_Priority__c;
            }
            if(quantumLeadMap.get(a.id).Sales_Value__c != null) {
              t.Sales_Value__c = quantumLeadMap.get(a.id).Sales_Value__c;
            }
          }
        }
      } else if (t.Whoid != null && t.Call_List_Priority__c == null) {
        string taskwhoid = t.WhoId;
        if(taskwhoid.substring(0,3) == '003') {
          Contact c = contactMap.get(t.whoID);
          if(c != null && quantumLeadMap.get(c.Account.Id) != null) {
            if(quantumLeadMap.get(c.Account.Id).Call_List_Priority__c != null) {
              t.Call_List_Priority__c = quantumLeadMap.get(c.Account.Id).Call_List_Priority__c;
            }
            if(quantumLeadMap.get(c.Account.Id).Sales_Value__c != null) {
              t.Sales_Value__c = quantumLeadMap.get(c.Account.Id).Sales_Value__c;
            }
          }
        }
      }
    }
  }
}