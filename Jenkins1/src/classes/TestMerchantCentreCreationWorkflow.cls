@isTest
class TestMerchantCentreCreationWorkflow
{ 
	static testMethod void testMerchantCenterCreationExecute()
	{
		MerchantCentreCreationWorkflow.hasExecuted = true;
		
		//verify that if deal strength 
		Account a = TestUtil.createAccount('ut acc1', false);
		a.Merchant_Permalink__c = 'permaLInk';
		insert a;
		
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'ut oppty1', 'New', Date.Today(), false);
		opptyNew.Email_List_To__c = 'test@test.com';
		insert opptyNew;
		
		Opportunity opptyOld = TestUtil.createOpportunity(a, 'ut oppty2', 'New', Date.Today(), false);
		opptyOld.Email_List_To__c = 'test@test.com';
		insert opptyOld;
		
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		Map<ID, Opportunity> oldMap = new Map<ID, Opportunity>{opptyNew.ID => opptyOld};
		
		MerchantCentreCreationWorkflow mccw = new MerchantCentreCreationWorkflow(newMap, oldMap);
		
		//since the deal strength is not vetted yet, verify that merchant centre api is not called -- hence, no future callouts
		MerchantCentreCreationWorkflow.hasExecuted = false;
		integer numberOfFCBeforeTriggerExecution = Limits.getFutureCalls();
		mccw.execute();
		integer numberOfFCAfterTriggerExecution = Limits.getFutureCalls();
		System.assertEquals(numberOfFCBeforeTriggerExecution, numberOfFCAfterTriggerExecution);
		
		//this time update the deal strength to Vetted. The api still wont be called since the account's permalink is not null
		opptyNew.Deal_Strengh__c = Constants.DEAL_STRENGTH_VETTED;
		MerchantCentreCreationWorkflow.hasExecuted = false;
		numberOfFCBeforeTriggerExecution = Limits.getFutureCalls();
		mccw.execute();
		numberOfFCAfterTriggerExecution = Limits.getFutureCalls();
		System.assertEquals(numberOfFCBeforeTriggerExecution, numberOfFCAfterTriggerExecution);
		
		
	}
}