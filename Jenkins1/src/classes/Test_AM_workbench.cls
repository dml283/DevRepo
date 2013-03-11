@isTest
public with sharing class Test_AM_workbench {

	static testMethod void testTaskFactory() {
		setupTestData();
		AM_workbenchTaskFactory.FactoryInterface amw = AM_workbench.getMerchantTaskFactory();
			
		//assert that MerchantTask is returned
		//assert that account vals were updated
		//assert that task vals were updated
		//assert that MerchantRefeature fields = acct fields
		//add new merchant
		//update vals with acct vals

	}
	
	public static void setupTestData(){
		//create merchant task, task, account, oppty, multi deals, merchant, deal option list, merchant list
	}

}