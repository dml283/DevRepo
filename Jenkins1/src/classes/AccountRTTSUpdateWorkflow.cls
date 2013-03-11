public with sharing class AccountRTTSUpdateWorkflow implements TriggerWorkflow
{
	Map<ID, Merchant_Addresses__c> newMap, oldMap;
	
	public AccountRTTSUpdateWorkflow(Map<ID, Merchant_Addresses__c> newMap, Map<ID, Merchant_Addresses__c> oldMap)
	{
		this.newMap = newMap;
		this.oldMap = oldMap;	
	} 
	
	private static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} private set;}
	public void execute()
	{
		if(!hasExecuted)
		{
			updateAccountRTTS();
			hasExecuted = true;
		}
	}
	
	private void updateAccountRTTS()
	{
		Set<ID> acctIds = new Set<ID>(); 
	    for(Merchant_Addresses__c ma : newMap.values())
	    {
	    	if(ma.Rewards_Transaction_Tracking_Status__c  != oldMap.get(ma.id).Rewards_Transaction_Tracking_Status__c)
	    		acctIds.add(ma.Account__c);
	    
	    }
	    
	    if(acctIDs.size() > 0)
	    {
	    	AcctRewardsTransactionTrackingStatus rtts = new AcctRewardsTransactionTrackingStatus();    
	    	rtts.updateAcctStatus(acctIds);
	    }
	} 
}