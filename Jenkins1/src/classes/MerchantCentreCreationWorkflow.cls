public with sharing class MerchantCentreCreationWorkflow implements TriggerWorkflow
{
	Map<ID, Opportunity> newMap;
	Map<ID, Opportunity> oldMap;
	
	public MerchantCentreCreationWorkflow(Map<ID, Opportunity> newMap, Map<ID, Opportunity> oldMap)
	{
		this.newMap = newMap;
		this.oldMap = oldMap;	
	}
	
	public static Boolean hasExecuted{get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} set;}
	//business logic
	public void execute()
	{
		if(!hasExecuted)
		{
			Set<String> merchantCentreIDs = new Set<String>();
			for(Opportunity o : [select id, AccountId, Deal_Strengh__c from Opportunity where ID in :newMap.keySet() and Account.Merchant_Permalink__c = null]) 
	        {
	            if(newMap.get(o.ID).Deal_Strengh__c == Constants.DEAL_STRENGTH_VETTED && newMap.get(o.ID).Deal_Strengh__c != oldMap.get(o.id).Deal_Strengh__c) 
	            	merchantCentreIds.add(o.id);
	        }
	        
	        //assign this boolean before calling the API since API will be called asynchronously "in future". Until it is called, we do not want the method to be executed again!
	        hasExecuted = true;
	        if(!System.isBatch() && !System.isFuture() && merchantCentreIDs.size() > 0)
	        	MerchantCenterAPI.createBulkMerchantCenter(merchantCentreIds);
		}
	}

}