@isTest
/*
Name: TestBatchCompletedEventUpdates
Owner: Naushad Rafique
Created Date: 1/29/2013
Last Modified By: Naushad Rafique
Last Modified Date: 1/29/2013
Test class for BatchCompletedEventUpdates 
*/

class TestBatchCompletedEventUpdates 
{
	//No logic in this class so nothing to assert
	static testMethod void testBatch()
	{
		Account acct = TestUtil.createAccount('ut acct 1');
		Opportunity oppty = TestUtil.createOpportunity(acct, 'test ut oppty1', 'open', Date.Today(), true);
		Contact cnt = TestUtil.createContact(); cnt.AccountId = acct.ID; insert cnt;
		Quantum_Lead__c ql = TestUtil.createQuantumLead(acct, true);
		
		//create 200 events under the Account, Oppty and Contacts and verify tht the method copies the ql values to the events
		List<Event> evts = new List<Event>();
		for(integer x = 0; x < 200; x++)
		{
			Event evt;
			if(x < 65)
				evt = TestUtil.createEvent(acct.ID, null, 'call', false);
			else if (x >= 65 && x < 130)
				evt = TestUtil.createEvent(oppty.ID, null, 'call', false);
			else
				evt = TestUtil.createEvent(null, cnt.ID, 'call', false);
				
			evt.StartDateTime = DateTime.Now().addHours(-3);
			evt.EndDateTime = DateTime.Now().addHours(-2);
			evt.Type = BatchCompletedEventUpdates.EVENT_TYPE_MERCHANT_CALL;
			evts.add(evt);
		}
		insert evts;
		
		
		Test.startTest();
		BatchCompletedEventUpdates.startBatch();
		Test.stopTest();
	}
	
	static testMethod void testSchedule()
	{
		Test.startTest();
        
        // Schedule the test job  
        String jobId = System.schedule('TestUserScheduler', '0 0 0 3 9 ? 2022', new BatchCompletedEventUpdates());
        // Get the information from the CronTrigger API object  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
                NextFireTime
                FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same  
        System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
        // Verify the job has not run  
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run  
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));

        Test.stopTest();
	}
}