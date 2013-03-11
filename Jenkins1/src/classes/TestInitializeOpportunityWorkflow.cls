@isTest
class TestInitializeOpportunityWorkflow 
{	
	static testMethod void testInitializeOpportunityWorkflow()
	{
		Account a = TestUtil.createAccount();
		Opportunity oppty = TestUtil.createOpportunity(a, 'ut oppt1', 'New', Date.today(), false);
		oppty.Sales_Stages__c = 'Complete';
		insert oppty;
		
		oppty = [Select ID, Sales_Stages__c from Opportunity where ID =: oppty.ID];
		System.assertEquals(oppty.Sales_Stages__c, 'Incomplete');
		
		Opportunity oppty2 = TestUtil.createOpportunity(a, 'ut oppt2', 'New', Date.today(), false);
		oppty2.Sales_Stages__c = 'some value';
		insert oppty2;
		
		oppty2 = [Select ID, Sales_Stages__c from Opportunity where ID =: oppty2.ID];
		System.assertEquals(oppty2.Sales_Stages__c, 'some value');
	}
}