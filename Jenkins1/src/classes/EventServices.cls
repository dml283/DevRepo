/*
Name: EventServices
Owner: Naushad Rafique
Created Date: 1/29/2013
TestClass : TestEventServices
Last Modified By: Naushad Rafique
Last Modified Date: 1/29/2013 
This class holds all the static level methods relating to the Event object. Will be primarily used by triggers and batch updates
on Event object
*/
public with sharing class EventServices 
{
	public static void stampCompletedFieldsOnCompletedEvents(List<Event> events)
	{
		List<Event> completedEvents = new List<Event>();
		for(Event evt: events)
		{
			//only process events that were "recently" completed. Recent completion defined as date in past and Completed date is null
			if(evt.EndDateTime != null)
			{
				setDateTimeAndCompletedUser(evt);
				completedEvents.add(evt);
			}
		}
		
		setCallListPriorityAndSalesValue(completedEvents);
		
		update events;
	}
	
	public static void setDateTimeAndCompletedUser(Event evt)
	{
		if(evt != null && evt.EndDateTime != null)
		{
			evt.Completed_Date__c = Date.newInstance(evt.EndDateTime.year(), evt.EndDateTime.month(), evt.EndDateTime.day());
			evt.Completed_Date_Time__c = evt.EndDateTime;
			evt.Completed_By__c = UserInfo.getName();
		}
	}
	
	public static void setCallListPriorityAndSalesValue(List<Event> events)
	{
		if(events != null && events.size() > 0)
		{
			Set<ID> relatedIDs = new Set<ID>();
			
			for(Event evt: events)
			{
				if(evt.WhatID != null) relatedIds.add(evt.WhatID);
				if(evt.WhoID != null) relatedIds.add(evt.WhoID);
			}
			
			if(relatedIDs.size() > 0)
			{
				Map<ID, ID> mapRelatedIDsToAccountID = new Map<ID, ID>();
				Map<ID, Quantum_Lead__c> mapAccountIdToQL = new Map<ID, Quantum_Lead__c>();
				
				//get the map from what and who ids to the corresponding account. 
				//also get the map form accounts to its corresponding quantum lead
				//trace from event's what/whoid to account to the quantum lead. 
				//finally copy the call list priority and sales value to the event
				for(Account acct: [Select ID from Account where ID in: relatedIDs])
					mapRelatedIDsToAccountID.put(acct.ID, acct.ID);
				
				for(Opportunity oppty: [Select ID, AccountID from Opportunity where ID in: relatedIDs])
					mapRelatedIDsToAccountID.put(oppty.ID, oppty.AccountID);
				
				for(Contact cnt: [Select ID, AccountID from Contact where ID in: relatedIDs])
					mapRelatedIDsToAccountID.put(cnt.ID, cnt.AccountID);
				
				for(Quantum_Lead__c ql: [Select ID, Account__c, Call_List_Priority__c, Sales_Value__c
										 from Quantum_Lead__c where Account__c in: mapRelatedIDsToAccountID.values() ])
					mapAccountIdToQL.put(ql.Account__c, ql);
				
				for(Event evt: events)
				{
					if(evt.whatID != null && mapRelatedIDsToAccountID.containsKey(evt.whatId))
					{
						System.debug('\n\nevent = '+evt+'\n\n');
					
						String accountID = mapRelatedIDsToAccountID.get(evt.whatID);
						if(mapAccountIdToQL.containsKey(accountID))
						{
							evt.Call_List_Priority__c = mapAccountIdToQl.get(accountID).Call_List_Priority__c;
							evt.Sales_Value__c = mapAccountIdToQl.get(accountId).Sales_Value__c;
						}
					}
					
					if(evt.whoID != null && mapRelatedIDsToAccountID.containsKey(evt.whoId))
					{
						String accountID = mapRelatedIDsToAccountID.get(evt.whoID);
						if(mapAccountIdToQL.containsKey(accountID))
						{
							evt.Call_List_Priority__c = mapAccountIdToQl.get(accountID).Call_List_Priority__c;
							evt.Sales_Value__c = mapAccountIdToQl.get(accountId).Sales_Value__c;
						}
					}
				}
				
			}
		}
	}
	
}