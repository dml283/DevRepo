@isTest
class TestSyncRedemptionAddressWorkflow 
{
	static testMethod void testSyncRedemptionAddress()
	{
		Account a = TestUtil.createAccount('ut acc1', true);
		Opportunity oppty = TestUtil.createOpportunity(a, 'oppty1', 'open', Date.Today(), true);
		
		Merchant_Addresses__c maNew = TestUtil.createMerchantAddress(a, true);
		Merchant_Addresses__c maOld = TestUtil.createMerchantAddress(a, true);
		maNew.City__c = 'Chicago';
		maOld.City__c = 'London';
		
		Address__c redemption = TestUtil.createAddress(a.ID, oppty.ID, 'st1', 'IL', '60657','chi', 'US');
		redemption.Merchant_Addresses__c = maNew.ID;
		update redemption;
		
		Map<ID, Merchant_Addresses__c> newMap = new Map<ID, Merchant_Addresses__c>{maNew.ID => maNew };
		Map<ID, Merchant_Addresses__c> oldMap = new Map<ID, Merchant_Addresses__c>{maNew.ID => maOld};
		
		System.assertEquals(redemption.City__c, 'chi');
		SyncRedemptionAddressesWorkflow sraw = new SyncRedemptionAddressesWorkflow(newMap, oldMap);
		sraw.exposeForUT_syncRedemptionAddress();
		
		redemption = [Select City__c from Address__c where id =: redemption.ID];
		System.assertEquals(redemption.City__c, 'Chicago');
		
	}
}