/* ===================================================================
* TaskQlWorkflow

* @author.....: Sonja Smith

* @date.......: 2013/21/02

* @Last Change: 2013/20/02 by SS

* Description.: Class to update Account and Opportunity with Highest Quantum Lead Sales Value and Rank by comparing completed tasks withi a 90 day range

* Dependencies: TaskTrigger.trigger
* ===================================================================
*/
public with sharing class TaskQLWorkflow implements TriggerWorkflow{

    Map<ID, Task> oldMap, newMap;
    Boolean isBefore, isInsert;
    
    public TaskQLWorkflow(Map<ID, Task> oldMap, Map<ID, Task> newMap, Boolean isBefore, Boolean isInsert)
    {
        this.oldMap = oldMap;
        this.newMap = newMap;       
        this.isBefore = isBefore;
        this.isInsert = isInsert;
    }
    
    public void execute()
    { 
        updateAccts(); 
    }
    
    public void updateAccts()
    {
        Set <Id> whatIds = new Set <Id>();
        Set <Id> taskIds = new Set <Id>();
        List <Task> ranks = new List <Task>();
        List <Task> vals = new List <Task>();
        List <Account> accountsToUpdate = new List <Account>();   
        Date LastNinetyDays = System.today()-90; 
          
        for(Task n: newMap.values())
        {
            if(!(n.Call_List_Priority__c == null && n.Sales_Value__c ==null) && n.whatId != null)
            {
                whatIds.add(n.whatId);         
            }    
        }

        for(Task t: [Select Id from Task  
                    WHERE whatId IN: whatIds
                    AND Status =: Constants.TASK_STATUS_COMPLETED
                    AND Completed_Date__c >=: LastNinetyDays ])
        {
            taskIds.add(t.Id);
            
        }
        
        for(Task r: [SELECT Call_List_Priority__c 
                    FROM Task 
                    WHERE WhatId IN: whatIds
                    AND Id IN: taskIds
                    ORDER BY Call_List_Priority__c ASC LIMIT 1])
        {
            ranks.add(r);
        }
        
        for(Task v: [SELECT Sales_Value__c 
                    FROM Task 
                    WHERE WhatId IN: whatIds
                    AND Id IN: taskIds
                    ORDER BY Sales_Value__c DESC LIMIT 1 ])
        {
            
            vals.add(v);
        }
                                
        if(taskIds.size()>0 && ranks.size()>0 && vals.size()>0)
        {
            for(Account a: [Select Id, Highest_QL_Rank_90_Day__c, Highest_QL_Sales_Value_90_Day__c from Account where Id IN: whatIds ])
            {
                if(ranks.get(0).Call_List_Priority__c != null) {
                    a.Highest_QL_Rank_90_Day__c = Decimal.valueOf(ranks.get(0).Call_List_Priority__c);
                    a.Highest_QL_Sales_Value_90_Day__c = vals.get(0).Sales_Value__c; 
                    accountsToUpdate.add(a);
                }
            }
        }
        
        try 
        {
            update accountsToUpdate;
        }
        catch(DMLException e)
        {
            for (Integer i = 0; i < e.getNumDml(); i++)
        {
                System.debug(e.getDmlMessage(i)); 
            }
        }
    }
    
}