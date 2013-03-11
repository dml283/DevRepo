@isTest
private class TestCompletedTaskUpdates {
    static testMethod void testTaskUpdates() { 
    User u = TestUtil.createUser('System Administrator');
	    System.runAs(u){
	    Test.startTest();
	        List <Account> accountsforCompletedTasks = new List <Account>();
	        List <Account> accountsforOpenTasks = new List <Account>();
	        
	        Account a1 = TestUtil.createAccount(); 
	        accountsforCompletedTasks.add(a1);
	        Account a2 = TestUtil.createAccount();
	        accountsforCompletedTasks.add(a2);
	        Account a3 = TestUtil.createAccount();
	        accountsforCompletedTasks.add(a3);
	        
	        Account a4 = TestUtil.createAccount(); 
	        accountsforOpenTasks.add(a1);
	        Account a5 = TestUtil.createAccount();
	        accountsforOpenTasks.add(a2);
	        Account a6 = TestUtil.createAccount();
	        accountsforOpenTasks.add(a3);
	        
	        List <Opportunity> opptys = new List <Opportunity>();
	        
	        Opportunity o1 = TestUtil.createOpportunity(a1, 'test opp1', 'stage', Date.Today(), true);//String name, String stage, Date closedDate, Boolean doInsert
	        opptys.add(o1);
	        Opportunity o2 = TestUtil.createOpportunity(a2, 'test opp2', 'stage', Date.Today(), true);
	        opptys.add(o2);
	        Opportunity o3= TestUtil.createOpportunity(a3, 'test opp3', 'stage', Date.Today(), true);
	        opptys.add(o3);
	        
	        List <Task> createCompletedTasks = new List <Task>();
	        List <Task> createOpenTasks = new List <Task>();
	        List <Contact> contacts = new list <Contact>();
	        
	        Task t1 = TestUtil.createTask(o1);
	        createCompletedTasks.add(t1);
	        Task t2 = TestUtil.createTask(o2);
	        createCompletedTasks.add(t2);
	        Task t3 = TestUtil.createTask(o3);
	        createCompletedTasks.add(t3);
	        
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
	    
	        for(Task t : createCompletedTasks) {
	          if(t.Status == 'Completed') {
	              completedTasks.add(t);
	            } else {
	              completedTasks.add(t);
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
	       Test.stopTest();  
	    }
    }
}