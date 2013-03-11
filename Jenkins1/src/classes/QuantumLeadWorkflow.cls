public with sharing class QuantumLeadWorkflow implements TriggerWorkflow
{
    Map<ID, Opportunity> newMap, oldMap;
    
    public QuantumLeadWorkflow(Map<ID, Opportunity> newMap, Map<ID, Opportunity> oldMap)
    {
        this.newMap = newMap;
        this.oldMap = oldMap;   
    }
    
    private static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} private set;}
    //business logic
    public void execute()
    {
        if(!hasExecuted)
        {
            copySalesValueAndRankOnOpptyFromQuantumLead();
            hasExecuted = true;
        }
    }
    
    private void copySalesValueAndRankOnOpptyFromQuantumLead()
    {
        Map<ID, List<Opportunity>> mapAccountToQualifiedOpptys = new Map<ID, List<Opportunity>>();
        for(Opportunity o : newMap.values()) 
        {
            if( o.StageName != oldMap.get(o.id).StageName && o.StageName == 'Approval Needed') 
            {
                List<Opportunity> opptyList = new List<Opportunity>();
                if(mapAccountToQualifiedOpptys.containsKey(o.AccountID))
                    opptyList = mapAccountToQualifiedOpptys.get(o.AccountID);
                
                opptyList.add(o);
                mapAccountToQualifiedOpptys.put(o.AccountID, opptyList);
                
            }
        }
        
        if(mapAccountToQualifiedOpptys.size() > 0)
        {
            for(Quantum_Lead__c q: [Select Account__c, Sales_Value__c, Call_List_Priority__c, Highest_QL_Rank_90_Day__c, Highest_QL_Sales_Value_90_Day__c from Quantum_Lead__c where Account__c IN: mapAccountToQualifiedOpptys.keySet()])
            {
                if(mapAccountToQualifiedOpptys.containsKey(q.Account__c))
                {
                    for(Opportunity o: mapAccountToQualifiedOpptys.get(q.Account__c))
                    {
                        
                        try
                        {
                            o.QL_Sales_Value__c = q.Sales_Value__c;
                            o.QL_Rank__c = q.Call_List_Priority__c; 
                            //o.Highest_QL_Sales_Value_90_Day__c = q.Highest_QL_Sales_Value_90_Day__c;
                            //o.Highest_QL_Rank_90_Day__c = q.Highest_QL_Rank_90_Day__c;
                        }
                        catch(DMLException e)
                        {
                            o.addError('There was a problem updating the Opportunity: ');
                        }
                    }
                }
            }    
        }
    }

}