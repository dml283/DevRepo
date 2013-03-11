public with sharing class ZenDeskOpptyTicketSubmissionWorkflow implements TriggerWorkflow
{
	
	List<Opportunity> newOpps;
	List<Opportunity> oldOpps;
	public Boolean zenDeskCalloutIssued {get; private set;}
	public ZenDeskOpptyTicketSubmissionWorkflow(List<Opportunity> newOpps, List<Opportunity> oldOpps)
	{
		this.newOpps = newOpps;
		this.oldOpps = oldOpps;
		this.zenDeskCalloutIssued = false;
	}
	
	//business logic
	public static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} set;}
	
	public void execute()
	{
		if(!hasExecuted)
		{
			submitZenDeskTicket();
			hasExecuted = true;
		}
	}
	
	private void submitZenDeskTicket()
	{
		if(Zenddeskticket.stopfuturecall == false) {
	        List<Id> AccountId = new List<Id>();
	        List<Id> UserId    = new List<Id>();
	        List<opportunity> triggernew = new list<opportunity>();
	        List<opportunity> triggerold = new list<opportunity>();
	        Map<Id,opportunity> triggernewmap = new Map<Id,opportunity>();
	        Map<Id,opportunity> triggeroldmap = new Map<Id,opportunity>();
	        Account AccountInfo = new Account();
	        User Userinfo = new User();
	              
	        for(Opportunity oppOld : oldOpps) {
	          if(oppOld.Permalink__c != null) {
	            triggerold.add(oppOld);
	            triggeroldmap.put(oppOld.id, oppOld);
	          }
	        }
	                          
	        for(opportunity Opp : newOpps) {
	          AccountId.add(Opp.accountId);
	          UserId.add(Opp.LastmodifiedbyId);
	                      
	          if(Opp.Permalink__c != null) {
	            triggernew.add(Opp);
	            triggernewmap.put(Opp.id, Opp);
	          }
	        }
	                  
	        if(AccountId.size() > 0) {
	          try {
	            AccountInfo = [select Id,name,Groupon_Scheduler_Strength__c from account where Id=:AccountId];
	          } catch(exception ex) {
	            Return;
	          }
	        }
	                  
	        if(UserId.size() > 0) {
	          Userinfo = [select Id,name,email from User where Id=:UserId];
	        }
	                  
	        if(system.isBatch() == false && system.isFuture() == false) 
	        {
	          if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()) 
	          {
	          	if(Test.isRunningTest())
	          	{
	          		this.zenDeskCalloutIssued = true;
	          	}
	          	else
	          	{
	            	zenDeskTicketSubmission.callZenddeskAPIforOpp(JSON.Serialize(triggernew),JSON.Serialize(triggerold),JSON.Serialize(triggernewMap),JSON.Serialize(triggeroldMap),JSON.Serialize(AccountInfo),JSON.Serialize(Userinfo));
	            	Zenddeskticket.stopfuturecall = true;
	          	}
	          }
	        }
		}
	}
}