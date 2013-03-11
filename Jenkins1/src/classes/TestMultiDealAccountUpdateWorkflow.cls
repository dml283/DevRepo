@isTest
class TestMultiDealAccountUpdateWorkflow 
{
	static testMethod void testUpdateAccountLookupOnMultiDealCreation()
	{
		MultiDealAccountUpdateWorkflow.hasExecutedMultiDealCreation = true;
		MultiDealAccountUpdateWorkflow.hasExecutedOpptyUpdate = true;
		
		Account a = TestUtil.createAccount('ut acc1', true);
		Opportunity oppty = TestUtil.createOpportunity(a, 'ut oppty1', 'New', Date.Today(), true);
		Multi_Deal__c md1 = TestUtil.createMD(oppty);
		Multi_Deal__c md2 = TestUtil.createMD(oppty);
		
		List<Multi_Deal__c> newList = new List<Multi_Deal__c>{md1, md2};
		
		MultiDealAccountUpdateWorkflow.hasExecutedMultiDealCreation = false;
		MultiDealAccountUpdateWorkflow.hasExecutedOpptyUpdate = false;
		MultiDealAccountUpdateWorkflow mdauw = new MultiDealAccountUpdateWorkflow(newList);
		mdauw.execute();
		System.assertEquals(md1.Account__c, a.ID);
		System.assertEquals(md2.Account__c, a.ID);
	}
	
	static testMethod void testUpdateAccountLookupOnOpportunityReassignment()
	{
		MultiDealAccountUpdateWorkflow.hasExecutedMultiDealCreation = true;
		MultiDealAccountUpdateWorkflow.hasExecutedOpptyUpdate = true;
		
		Account a = TestUtil.createAccount('ut acc1', true);
		Account newAcc = TestUtil.createAccount('ut acc2', true);
		
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'ut oppty1', 'New', Date.Today(), true);
		Opportunity opptyOld = TestUtil.createOpportunity(a, 'ut oppty2', 'New', Date.Today(), true);
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		Map<ID, Opportunity> oldMap = new Map<ID, Opportunity>{opptyNew.ID => opptyOld};
		
		Multi_Deal__c md1 = TestUtil.createMD(opptyNew); md1.Account__c = a.ID; update md1;
		
		MultiDealAccountUpdateWorkflow.hasExecutedMultiDealCreation = false;
		MultiDealAccountUpdateWorkflow.hasExecutedOpptyUpdate = false;
		MultiDealAccountUpdateWorkflow mdauw = new MultiDealAccountUpdateWorkflow(newMap, oldMap);
		//since the account lookup on opptys hasn't changed, the account lookup on MultiDeals also wont change
		mdauw.execute();
		System.assertEquals(md1.Account__c, a.ID);
		
		//reassign oppty to the newAcc and verify that the account lookups on multideals also update
		opptyNew.AccountId = newAcc.ID;
		MultiDealAccountUpdateWorkflow.hasExecutedMultiDealCreation = false;
		MultiDealAccountUpdateWorkflow.hasExecutedOpptyUpdate = false;
		mdauw.execute();
		md1 = [Select ID, Account__c from Multi_Deal__c where ID =: md1.ID];
		System.assertEquals(md1.Account__c, newAcc.ID);
	}
}