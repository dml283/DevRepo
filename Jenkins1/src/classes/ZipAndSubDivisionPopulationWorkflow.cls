public with sharing class ZipAndSubDivisionPopulationWorkflow implements TriggerWorkflow
{
	List<Merchant_Addresses__c> newMAList, oldMAList;
	List<Address__c> newRAList, oldRAList;
	Boolean isBeforeForMA, isAfterForMA, isBeforeForRA, isAfterForRA;
	
	Boolean isMATrigger, isRATrigger;
	
	
	public ZipAndSubDivisionPopulationWorkflow(List<Merchant_Addresses__c> newList, List<Merchant_Addresses__c> oldList , Boolean isBefore, Boolean isAfter)
	{
		this.newMAList = newList;
		this.oldMAList = oldList;
		this.isBeforeForMA = isBefore;
		this.isAfterForMA = isAfter;
		
		isMATrigger = true;
		isRATrigger = false;
	}
	
	public ZipAndSubDivisionPopulationWorkflow(List<Address__c> newList, List<Address__c> oldList , Boolean isBefore, Boolean isAfter)
	{
		this.newRAList = newList;
		this.oldRAList = oldList;
		this.isBeforeForRA = isBefore;
		this.isAfterForRA = isAfter;
		
		isMATrigger = false;
		isRATrigger = true;
	}
	
	private static Boolean hasExecutedBeforeForMA{ get{if(hasExecutedBeforeForMA == null) hasExecutedBeforeForMA = false; return hasExecutedBeforeForMA;} private set;}
	private static Boolean hasExecutedAfterForMA{ get{if(hasExecutedAfterForMA == null) hasExecutedAfterForMA = false; return hasExecutedAfterForMA;} private set;}
	
	private static Boolean hasExecutedBeforeForRA{ get{if(hasExecutedBeforeForRA == null) hasExecutedBeforeForRA = false; return hasExecutedBeforeForRA;} private set;}
	private static Boolean hasExecutedAfterForRA{ get{if(hasExecutedAfterForRA == null) hasExecutedAfterForRA = false; return hasExecutedAfterForRA;} private set;}
	
	private static Boolean shouldUpdateAccountWithNewSubDivs{ get{if(shouldUpdateAccountWithNewSubDivs == null) shouldUpdateAccountWithNewSubDivs = false; return shouldUpdateAccountWithNewSubDivs;} private set;}
	private static Boolean shouldUpdateOpportunityWithNewSubDivs{ get{if(shouldUpdateOpportunityWithNewSubDivs == null) shouldUpdateOpportunityWithNewSubDivs = false; return shouldUpdateOpportunityWithNewSubDivs;} private set;}
	
	//business logic
	public void execute()
	{
		if(isMATrigger)
		{
			if(isBeforeForMA)
			{
				if(!hasExecutedBeforeForMA)
				{
					updateMerchantAddressesWithZipCodeAndSubDivisionReferences();
					hasExecutedBeforeForMA = true;
				}
			}
			else if (isAfterForMA && shouldUpdateAccountWithNewSubDivs)
			{
				if(!hasExecutedAfterForMA)
				{
					//updateParentRecordsWithSubvisions(newMAList, oldMAList, 'Zip_Postal_Code__c', 'Subdivision', 'Account__c', 'Merchant_Addresses__c');
					this.updateAccountWithSubvisions();
					hasExecutedAfterForMA = true;
				}
			}
		}
		else if(isRATrigger)
		{
			if(isBeforeForRA)
			{
				if(!hasExecutedBeforeForRA)
				{
					updateRedemptionAddressesWithZipCodeAndSubDivisionReferences();
					hasExecutedBeforeForMA = true;
				}
			}
			else if (isAfterForRA && shouldUpdateOpportunityWithNewSubDivs)
			{
				if(!hasExecutedAfterForRA)
				{
					//updateParentRecordsWithSubvisions(newRAList, oldRAList, 'Zip_Postal_Code__c', 'Subdivision', 'Opportunity__c', 'Address__c');
					this.updateOpportunitysWithSubvisions();
					hasExecutedAfterForRA = true;
				}
			}
		}
	}
	
	
	private void updateMerchantAddressesWithZipCodeAndSubDivisionReferences()
	{
		Map<String, List<Merchant_Addresses__c>> qualifiedMAsMappedByZipCodes = AddressServices.getQualifiedZipCodesToAddressObjectMap(newMAList, oldMAList, 'Zip_Postal_Code__c', 'State_Province__c');
		if(qualifiedMAsMappedByZipCodes != null && qualifiedMAsMappedByZipCodes.size() > 0)
		{
			AddressServices.assignZipCodeAndSubDivision(qualifiedMAsMappedByZipCodes, 'Zip_Code__c', 'Subdivision__c');
			//accounts should only be updated in the "after" part of trigger if there actually was a zipcode update
			shouldUpdateAccountWithNewSubDivs = true;
		}
	}
	
	
	private void updateRedemptionAddressesWithZipCodeAndSubDivisionReferences()
	{
		Map<String, List<Address__c>> qualifiedRAsMappedByZipCodes = AddressServices.getQualifiedZipCodesToAddressObjectMap(newRAList, oldRAList, 'Zip_Postal_Code__c', 'State__c');
		if(qualifiedRAsMappedByZipCodes != null && qualifiedRAsMappedByZipCodes.size() > 0)
		{
			AddressServices.assignZipCodeAndSubDivision(qualifiedRAsMappedByZipCodes, 'Dynamic_Zip_Code__c', 'Subdivision__c');
			//opptys should only be updated in the "after" part of trigger if there actually was a zipcode update
			shouldUpdateOpportunityWithNewSubDivs = true;
		}
	}
	
	//this method queries all the Subdivisions underneath the account and accumulates them in the form of a semi colon delimited string of values to update the account 
	private void updateAccountWithSubvisions()
	{
		Set<ID> accountIDs = new Set<ID>();
		Integer x = 0;
		for(Merchant_Addresses__c ma: newMAList)
		{
			if(oldMAList == null || (ma.Zip_Postal_Code__c != oldMAList[x].Zip_Postal_Code__c))
				accountIDs.add(ma.Account__c);
			x++;
		}
		
		if(accountIDs.size() > 0)
		{
			Map<ID, Set<String>> mapAccountIDToSubDivs = new Map<ID, Set<String>>();
			for(Merchant_Addresses__c ma: [Select ID, Account__c, Subdivision__c, Subdivision__r.Name, Zip_Postal_Code__c from Merchant_Addresses__c where Account__c in : accountIDs])
			{
				Set<String> subDivs = new Set<String>();
				if(mapAccountIDToSubDivs.containsKey(ma.Account__c))
					subDivs = mapAccountIDToSubDivs.get(ma.Account__c);
				
				if(ma.Subdivision__r.Name != null)
				{
					subDivs.add(ma.Subdivision__r.Name);
					mapAccountIDToSubDivs.put(ma.Account__c, subDivs);
				}
			}
			
			if(mapAccountIDToSubDivs.size() > 0)
			{
				List<Account> accountsToUpdate = new List<Account>();
				for(ID accID: mapAccountIDToSubDivs.keySet())
				{
					Account a = new Account(ID = accID);
					if(mapAccountIDToSubDivs.get(accID).size() > 99)
						a.Subdivision__c = 'National Account: Too many subdivisions';
					else
					{
						a.Subdivision__c = GrouponUtils.getCSVFromSet(mapAccountIDToSubDivs.get(accID), ';');
						accountsToUpdate.add(a);
					}
				}
				
				if(accountsToUpdate.size() > 0)
					update accountsToUpdate;
			}
		}
			
	}
	
	//this method queries all the Subdivisions underneath the account and accumulates them in the form of a semi colon delimited string of values to update the account 
	private void updateOpportunitysWithSubvisions()
	{
		Set<ID> opptyIDs = new Set<ID>();
		Integer x = 0;
		for(Address__c ra: newRAList)
		{
			if(oldRAList == null || (ra.Zip_Postal_Code__c != oldRAList[x].Zip_Postal_Code__c))
				opptyIDs.add(ra.Opportunity__c);
			x++;
		}
		
		if(opptyIDs.size() > 0)
		{
			Map<ID, Set<String>> mapOpptyIDToSubDivs = new Map<ID, Set<String>>();
			for(Address__c ra: [Select ID, Opportunity__c, Subdivision__c, Subdivision__r.Name, Zip_Postal_Code__c from Address__c where Opportunity__c in : opptyIDs])
			{
				Set<String> subDivs = new Set<String>();
				if(mapOpptyIDToSubDivs.containsKey(ra.Opportunity__c))
					subDivs = mapOpptyIDToSubDivs.get(ra.Opportunity__c);
				
				if(ra.Subdivision__r.Name != null)
				{
					subDivs.add(ra.Subdivision__r.Name);
					mapOpptyIDToSubDivs.put(ra.Opportunity__c, subDivs);
				}
			}
			System.debug('\n\nmapOpptyIDToSubDivs = '+mapOpptyIDToSubDivs+'\n\n');
			
			if(mapOpptyIDToSubDivs.size() > 0)
			{
				List<Opportunity> opptysToUpdate = new List<Opportunity>();
				for(ID opptyID: mapOpptyIDToSubDivs.keySet())
				{
					Opportunity oppty = new Opportunity(ID = opptyID);
					if(mapOpptyIDToSubDivs.get(opptyID).size() > 99)
						oppty.Subdivision__c = 'National Account: Too many subdivisions';
					else
					{
						oppty.Subdivision__c = GrouponUtils.getCSVFromSet(mapOpptyIDToSubDivs.get(opptyID), ';');
						opptysToUpdate.add(oppty);
					}
				}
				
				if(opptysToUpdate.size() > 0)
					update opptysToUpdate;
			}
		}
			
	}
	
	/*
	//this method queries all the Subdivisions underneath the account and accumulates them in the form of a semi colon delimited string of values to update the account 
	private void updateParentRecordsWithSubvisions(List<SObject> newList, List<SObject> oldList, String zipFieldName, String subdivisionFieldName, String parentReferenceFieldName ,String SObjectName )
	{
		Set<String> parentIDs = new Set<String>();
		Integer x = 0;
		for(SObject addressRecord: newList)
		{
			if(oldList == null || (addressRecord.get(zipFieldName) != oldList[x].get(zipFieldName)))
				parentIDs.add(String.valueOf(addressRecord.get(parentReferenceFieldName)));
				
			x++;
		}
		
		if(parentIDs.size() > 0)
		{
			Map<String, Set<String>> mapParentIDToSubDivs = new Map<String, Set<String>>();
			String query = 'Select ID, '+SubdivisionFieldName+'__c, '+SubdivisionFieldName+'__r.Name, '+parentReferenceFieldName+' from '+SobjectName+' where '+parentReferenceFieldName+' in: parentIDs';
			System.debug('\n\nquery = '+query+'\n\n');
			for(SObject sObj: Database.query(query))
			{
				Set<String> subDivs = new Set<String>();
				if(mapParentIDToSubDivs.containsKey(String.valueOf(sObj.get(parentReferenceFieldName))))
					subDivs =  mapParentIDToSubDivs.get(String.valueOf(sObj.get(parentReferenceFieldName)));
				
				if(sObj.get(subdivisionFieldName+'__r.Name') != null)
				{
					subDivs.add(String.valueOf(sObj.get(subdivisionFieldName+'__r.Name')));
					mapParentIDToSubDivs.put(String.valueOf(sObj.get(parentReferenceFieldName)), subDivs);
				}
			}
			//System.debug('\n\nmapOpptyIDToSubDivs = '+mapOpptyIDToSubDivs+'\n\n');
			
			if(mapParentIDToSubDivs.size() > 0)
			{
				List<SObject> parentsToUpdate = new List<SObject>();
				for(String parentID: mapParentIDToSubDivs.keySet())
				{
					SObject parentRecord;
					if(isMATrigger) 
						parentRecord = new Account(ID = parentID);
					else if(isRATrigger)
						parentRecord = new Opportunity(ID = parentID);
						
					if(mapParentIDToSubDivs.get(parentID).size() > 99)
						parentRecord.put(subdivisionFieldName+'__c', 'National Account: Too many subdivisions');
					else
					{
						parentRecord.put(subdivisionFieldName+'__c', GrouponUtils.getCSVFromSet(mapParentIDToSubDivs.get(parentID), ';'));
						parentsToUpdate.add(parentRecord);
					}
				}
				
				if(parentsToUpdate.size() > 0)
					update parentsToUpdate;
			}
		}
			
	}
	*/
	
}