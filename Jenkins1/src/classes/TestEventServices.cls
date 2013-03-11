@isTest
/*
Name: TestEventServices
Owner: Naushad Rafique
Created Date: 1/29/2013
Last Modified By: Naushad Rafique
Last Modified Date: 1/29/2013
Test class for EventServices 
*/

class TestEventServices 
{
	static testMethod void testSetDateTimeAndCompletedUser()
	{
		Account acct = TestUtil.createAccount('ut acct 1');
		Event evt = TestUtil.createEvent(acct.ID, null, 'test evt1', false);
		Test.startTest();
		//null end date should not update the Events "Completed" fields
		EventServices.setDateTimeAndCompletedUser(evt);
		System.assertEquals(evt.Completed_Date__c, null);
		System.assertEquals(evt.Completed_Date_Time__c, null);
		System.assertEquals(evt.Completed_By__c, null);
		
		//provide an end date and verify that "Completed" fields are populated accordingly
		evt.StartDateTime = DateTime.Now().addDays(-2);
		evt.EndDateTime = DateTime.Now().addDays(-2).addHours(1);
		EventServices.setDateTimeAndCompletedUser(evt);
		System.assertEquals(evt.Completed_Date_Time__c, evt.EndDateTime);
		System.assertEquals(evt.Completed_Date__c, Date.newInstance(evt.EndDateTime.year(), evt.EndDateTime.month(), evt.EndDateTime.day()) );
		System.assertEquals(evt.Completed_By__c, UserInfo.getName());
		
		Test.stopTest();
	}
	
	static testMethod void setCallListPriorityAndSalesValue()
	{
		Account acct = TestUtil.createAccount('ut acct 1');
		Opportunity oppty = TestUtil.createOpportunity(acct, 'test ut oppty1', 'open', Date.Today(), true);
		Contact cnt = TestUtil.createContact(); cnt.AccountId = acct.ID; insert cnt;
		Quantum_Lead__c ql = TestUtil.createQuantumLead(acct, true);
		
		//create an event under the Account and verify tht the method copies the ql values to the event
		Event evt = TestUtil.createEvent(acct.ID, null, 'call', false);
		evt.EndDateTime = DateTime.Now().addHours(-1);
		evt.Type = Constants.EVENT_TYPE_MERCHANT_CALL;
		List<Event> events = new List<Event>{evt};
		
		Test.startTest();
		EventServices.setCallListPriorityAndSalesValue(events);
		System.assertEquals(evt.Call_List_Priority__c, ql.Call_List_Priority__c);
		System.assertEquals(evt.Sales_Value__c, ql.Sales_Value__c);
		
		//now transfer the event to oppty and verify that values copy again
		evt.Call_List_Priority__c = null;
		evt.Sales_Value__c = null;
		evt.WhatId = oppty.ID;
		//update evt;
		EventServices.setCallListPriorityAndSalesValue(events);
		System.assertEquals(evt.Call_List_Priority__c, ql.Call_List_Priority__c);
		System.assertEquals(evt.Sales_Value__c, ql.Sales_Value__c);
		
		//now transfer the event to contact and verify that values copy again
		evt.Call_List_Priority__c = null;
		evt.Sales_Value__c = null;
		evt.WhatId = null;
		evt.WhoId = cnt.ID;
		//update evt;
		EventServices.setCallListPriorityAndSalesValue(events);
		System.assertEquals(evt.Call_List_Priority__c, ql.Call_List_Priority__c);
		System.assertEquals(evt.Sales_Value__c, ql.Sales_Value__c);
				
		Test.stopTest();
	}
	
	//since this method is simply delegating, test method won't assert anything. 
	static testMethod void testStampCompletedFieldsOnCompletedEvents()
	{
		Account acct = TestUtil.createAccount('ut acct 1');
		Opportunity oppty = TestUtil.createOpportunity(acct, 'test ut oppty1', 'open', Date.Today(), true);
		Contact cnt = TestUtil.createContact(); cnt.AccountId = acct.ID; insert cnt;
		Quantum_Lead__c ql = TestUtil.createQuantumLead(acct, true);
		
		//create an event under the Account and verify tht the method copies the ql values to the event
		Event evt = TestUtil.createEvent(acct.ID, null, 'call', false);
		evt.StartDateTime = DateTime.Now().addHours(-3);
		evt.EndDateTime = DateTime.Now().addHours(-2);
		evt.Type = Constants.EVENT_TYPE_MERCHANT_CALL;
		insert evt;
		List<Event> events = new List<Event>{evt};
		Test.startTest();
		EventServices.stampCompletedFieldsOnCompletedEvents(events);
		Test.stopTest();
		
	}
}