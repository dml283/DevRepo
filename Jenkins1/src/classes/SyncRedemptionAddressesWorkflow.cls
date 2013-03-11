public with sharing class SyncRedemptionAddressesWorkflow implements TriggerWorkflow 
{
	Map<ID, Merchant_Addresses__c> newMap, oldMap;
	public SyncRedemptionAddressesWorkflow(Map<ID, Merchant_Addresses__c> newMap, Map<ID, Merchant_Addresses__c> oldMap)
	{
		this.newMap = newMap;
		this.oldMap = oldMap;
	}
	
	private static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} private set;}
	public void execute()
	{
		if(!System.isBatch() && !System.isScheduled() && !System.isFuture())
		{
			if(!hasExecuted)
			{
				syncRedemptionAddress();
				hasExecuted = true;
			}
		}
	}
	
	private void syncRedemptionAddress()
	{
		for(Merchant_Addresses__c ma: newMap.values())
		{
			Set<ID> qualifiedMAids = new Set<ID>();
			if( ma.City__c != oldMap.get(ma.ID).City__c ||
				ma.Country__c != oldMap.get(ma.ID).Country__c ||
				ma.State_Province__c != oldMap.get(ma.ID).State_Province__c ||
				ma.Street_Line_1__c != oldMap.get(ma.ID).Street_Line_1__c ||
				ma.Street_Line_2__c != oldMap.get(ma.ID).Street_Line_2__c ||
				ma.Zip_Postal_Code__c != oldMap.get(ma.ID).Zip_Postal_Code__c ||
				ma.Phone_Number__c != oldMap.get(ma.ID).Phone_Number__c ||
				ma.Venue_Name__c  != oldMap.get(ma.ID).Venue_Name__c  
			)
			{
				qualifiedMAids.add(ma.ID);
			}
			
			
			if(qualifiedMAids.size() > 0)
			{
				List<Address__c> redemptionAddressesToUpdate = new List<Address__c>();
				
				for(Address__c ra: [Select Country__c,City__c,State__c,Phone_Number__c,Zip_Postal_Code__c,Street_Line_2__c,Street_Line_1__c,Venue_Name__c,Neighborhood__c,
									Merchant_Addresses__r.City__c, Merchant_Addresses__r.Country__c, Merchant_Addresses__r.State_Province__c, Merchant_Addresses__r.Phone_Number__c, Merchant_Addresses__r.Zip_Postal_Code__c,
									Merchant_Addresses__r.Street_Line_1__c, Merchant_Addresses__r.Street_Line_2__c, Merchant_Addresses__r.Venue_Name__c
									From Address__c
									Where Merchant_Addresses__c in: qualifiedMAids])
				{
					ra.City__c = ra.Merchant_Addresses__r.City__c;
		            ra.Country__c = ra.Merchant_Addresses__r.Country__c;
		            ra.State__c = ra.Merchant_Addresses__r.State_Province__c;
		            ra.Street_Line_1__c = ra.Merchant_Addresses__r.Street_Line_1__c;
		            ra.Street_Line_2__c = ra.Merchant_Addresses__r.Street_Line_2__c;
		            ra.Zip_Postal_Code__c = ra.Merchant_Addresses__r.Zip_Postal_Code__c;
		            ra.Phone_Number__c = ra.Merchant_Addresses__r.Phone_Number__c;
		            ra.Venue_Name__c = ra.Merchant_Addresses__r.Venue_Name__c;
		            redemptionAddressesToUpdate.add(ra);
            
            
				}
				
				if(redemptionAddressesToUpdate.size() > 0)
					update redemptionAddressesToUpdate;
			}
		}
	}
	
	public void exposeForUT_syncRedemptionAddress()
	{
		TestUtil.checkForUnitTestExecution();
		
		syncRedemptionAddress();
	}
}