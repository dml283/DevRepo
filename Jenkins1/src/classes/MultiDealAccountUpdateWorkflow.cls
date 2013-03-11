public with sharing class MultiDealAccountUpdateWorkflow implements TriggerWorkflow
{
	List<Multi_Deal__c> newMDList;
	Map<ID, Opportunity> newOpptyMap, oldOpptyMap;
	Boolean isBeforeInsertMultiDeal, isAfterUpdateOpportunity;
	
	public MultiDealAccountUpdateWorkflow(List<Multi_Deal__c> newList)
	{
		this.newMDList = newList;
		isBeforeInsertMultiDeal = true;
		isAfterUpdateOpportunity = false;
	}
	
	public MultiDealAccountUpdateWorkflow(Map<ID, Opportunity> newMap, Map<ID, Opportunity> oldMap)
	{
		this.newOpptyMap = newMap;
		this.oldOpptyMap = oldMap;	
		isBeforeInsertMultiDeal = false;
		isAfterUpdateOpportunity = true;
	}
	
	//business logic
	public void execute()
	{
		if(isBeforeInsertMultiDeal)
			updateAccountLookupOnMultiDealCreation();
		
		if(isAfterUpdateOpportunity)
			updateAccountLookupOnOpportunityReassignment();
	}
	
	public static Boolean hasExecutedMultiDealCreation{ get{if(hasExecutedMultiDealCreation == null) hasExecutedMultiDealCreation = false; return hasExecutedMultiDealCreation;} set;}
	public void updateAccountLookupOnMultiDealCreation()
	{
		if(!hasExecutedMultiDealCreation)
		{
			Map<ID, List<Multi_Deal__c>> mapOpptyIdToMultiDeals = new Map<ID, List<Multi_Deal__c>>();
			for(Multi_Deal__c md: newMDList)
			{
				List<Multi_Deal__c> mdList = new List<Multi_Deal__c>();
				if(mapOpptyIdToMultiDeals.containsKey(md.Opportunity__c))
					mdList = mapOpptyIdToMultiDeals.get(md.Opportunity__c);
				
				mdList.add(md);
				mapOpptyIdToMultiDeals.put(md.Opportunity__c, mdList);
			}
			
			if(mapOpptyIdToMultiDeals.size() > 0)
			{
				for(Opportunity oppty: [Select ID, AccountID from Opportunity where ID in: mapOpptyIDToMultiDeals.keySet()])
				{
					for(Multi_Deal__c md: mapOpptyIdToMultiDeals.get(oppty.ID))
						md.Account__c = oppty.AccountID;
				}
			}
			
			hasExecutedMultiDealCreation = true;
		}
	}
	
	public static Boolean hasExecutedOpptyUpdate{ get{if(hasExecutedOpptyUpdate == null) hasExecutedOpptyUpdate = false; return hasExecutedOpptyUpdate;} set;}
	public void updateAccountLookupOnOpportunityReassignment()
	{
		if(!hasExecutedOpptyUpdate)
		{
			Map<ID, ID> mapQualifiedOpptysToNewAccountIDs = new Map<ID,ID>();
			
			for(Opportunity oppty: newOpptyMap.values())
			{
				if(oppty.AccountId != oldOpptyMap.get(oppty.ID).AccountID)
					mapQualifiedOpptysToNewAccountIDs.put(oppty.ID, oppty.AccountID);
			}
			
			if(mapQualifiedOpptysToNewAccountIDs.size() > 0)
			{
				List<Multi_Deal__c> multiDealsToUpdate = new List<Multi_Deal__c>();
				for(Multi_Deal__c md: [Select ID, Account__c, Opportunity__c from Multi_Deal__c where Opportunity__c in: mapQualifiedOpptysToNewAccountIDs.keySet()])
				{
					if(mapQualifiedOpptysToNewAccountIDs.containsKey(md.Opportunity__c))
					{
						md.Account__c = mapQualifiedOpptysToNewAccountIDs.get(md.Opportunity__c);
						multiDealsToUpdate.add(md);
					}
				}
				
				if(multiDealsToUpdate.size() > 0)
					update multiDealsToUpdate;
			}
			hasExecutedOpptyUpdate = true;
		}
		
	}
}