@isTest
class TestZenDeskOpptyTicketSubmissionWorkflow 
{
	static testMethod void testZenDeskOpptyTicketSubmission()
	{
		ZenDeskOpptyTicketSubmissionWorkflow.hasExecuted = true;
		
		//whenever an oppty is updated, a call to ZenDeskTicketSubmission class is made. 
		Account a = TestUtil.createAccount('ut acc1', true);
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'ut oppty1', 'New', Date.Today(), false);
		opptyNew.Permalink__c = 'pm'; insert opptyNew; opptyNew = [Select ID, AccountID, name, LastModifiedByID, PermaLink__c from Opportunity where ID=: opptyNew.ID];
		Opportunity opptyOld = TestUtil.createOpportunity(a, 'ut oppty2', 'New', Date.Today(), false);
		opptyOld.Permalink__c = 'pm2'; insert opptyOld; opptyOld = [Select ID, AccountID, name, LastModifiedByID, PermaLink__c from Opportunity where ID=: opptyOld.ID];
		
		List<Opportunity> newList = new List <Opportunity>{opptyNew};
		List<Opportunity> oldList = new List <Opportunity>{opptyOld};
		
		ZenDeskOpptyTicketSubmissionWorkflow.hasExecuted = false;
		ZendeskOpptyTicketSubmissionWorkflow zotswf = new ZendeskOpptyTicketSubmissionWorkflow(newList, oldList);
		zotswf.execute();
		System.assertEquals(zotswf.zenDeskCalloutIssued, true);
	}
}