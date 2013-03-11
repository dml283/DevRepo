public with sharing class ZenDeskRATicketSubmissionWorkflow implements TriggerWorkflow
{
	List<Address__c> newList, oldList;
	public ZenDeskRATicketSubmissionWorkflow(List<Address__c> newList, List<Address__c> oldList)
	{
		this.newList = newList;
		this.oldList = oldList;
		
	}
	
	private static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} private set;}
	
	
	public void execute()
	{
		if(!hasExecuted)
		{
			String userprofile = UserInfo.getProfileId();
			
		  	 
	    	List<Address__c> triggernew = new List<Address__c>();
	    	List<Address__c> triggerold = new List<Address__c>();
	    	Set<Id> oppIds = new Set<Id>();
	    	Map<Id,Address__c> triggernewmap = new Map<Id,Address__c>();
	    	Map<Id,Address__c> triggeroldmap = new Map<Id,Address__c>();
	    	List<Id> oppId  = new List<Id>();
	    	List<Id> userId = new List<Id>();
	    	Opportunity oppInfo  = new Opportunity();
	    	User userinfo1 = new User();
	
	    	if(!Test.isRunningTest() || (Test.isRunningTest() && Limits.getFutureCalls() < Limits.getLimitFutureCalls()) ) 
	    	{
	      		for(Address__c addy: newList) 
	      		{
	        		oppIds.add(addy.Opportunity__c);
	      		}
	             
	      		Map<Id,Opportunity> oppsMap = new Map<id,opportunity>([SELECT Permalink__c FROM Opportunity WHERE Id IN :oppIds]);
	         
				for(address__c addressOld: oldList) 
				{
	        		if(oppsMap.get(addressOld.Opportunity__c).Permalink__c != null) 
	        		{
	          			triggerold.add(addressOld);
	          			triggeroldmap.put(addressOld.id, addressOld);
	        		}
	      		}
	         
	      		for(address__c addressNew: newList) 
	      		{
	        		oppId.add(addressNew.Opportunity__c);
	        		userId.add(addressNew.lastmodifiedbyId);
	                 
	        		if(oppsMap.get(addressNew.Opportunity__c).Permalink__c != null) 
	        		{
	          			triggernew.add(addressNew);
	          			triggernewmap.put(addressNew.id, addressNew);
	        		}
	      		}
	             
	      		if(oppId.size() > 0 && userId.size() > 0) 
	      		{
	        		oppInfo  = [select Id,account.name,type,permalink__c,division__c,Go_Live_Date__c from opportunity where Id=: oppId limit 1];
	        		userinfo1 = [select username,name from user where Id =:userId];
	        		zenDeskTicketSubmission.callZenddeskAPIforAddress(JSON.Serialize(triggernew),JSON.Serialize(triggerold),JSON.Serialize(triggernewmap),JSON.Serialize(triggeroldmap),JSON.Serialize(userInfo1),JSON.Serialize(oppInfo));
	      		}
			}
			hasExecuted = true;
		}
	}
}