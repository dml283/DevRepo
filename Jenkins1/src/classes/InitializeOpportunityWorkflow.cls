public with sharing class InitializeOpportunityWorkflow implements TriggerWorkflow
{
	List<Opportunity> newOpps;
	public InitializeOpportunityWorkflow(List<Opportunity> opptys)
	{
		this.newOpps = opptys;
	}
	
	//business logic
	private static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} private set;}
	public void execute()
	{
		initializeOpportunities(newOpps);
	}
	
	private void initializeOpportunities(List<Opportunity> ops) {
		if(!hasExecuted)
		{
	        for(Opportunity o : ops) {
	            if(o.Sales_Stages__c == 'Complete') {
	                o.Sales_Stages__c = 'Incomplete';
	            }
	        }
	        
	        hasExecuted = true;
		}
    }
}