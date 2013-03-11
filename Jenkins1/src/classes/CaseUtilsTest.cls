/**
* @author Daniel Nakonieczny - Model Metrics
* @date July 5th 2011
* @description This class provides unit tests for the ZenDesk to Salesforce integration
*/

@isTest
private class CaseUtilsTest {

    static testMethod void testBlankPermaLink() {
    	
    	Case testCase = ZenDeskCaseTestUtil.createCase('New', 'Web', 'New problem', 12345);
    	testCase = [select Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(CaseUtils.getSettings().OrphanedCasesOppID__c, testCase.Opportunity__c);
    	system.assertEquals(null, testCase.Permalink__c);
    	system.assertEquals(12345, testCase.Zendesk__Zendesk_Ticket_ID__c);
    }
    
    static testMethod void testBlankTicketID() {
    	
    	Case testCase = ZenDeskCaseTestUtil.createCase('New', 'Web', 'New problem', null);
    	testCase = [select Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(CaseUtils.getSettings().OrphanedCasesOppID__c, testCase.Opportunity__c);
    	system.assertEquals(null, testCase.Permalink__c);
    	system.assertEquals(null, testCase.Zendesk__Zendesk_Ticket_ID__c);
    }
    
    static testMethod void testPermalinkNoOpp() {
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', null);
    	testCase.Permalink__c = 'test.permalink';
    	insert testCase;
    	testCase = [select Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(CaseUtils.getSettings().OrphanedCasesOppID__c, testCase.Opportunity__c);
    	system.assertEquals('test.permalink', testCase.Permalink__c);
    	system.assertEquals(null, testCase.Zendesk__Zendesk_Ticket_ID__c);
    }
    
    static testMethod void testWrongTicketID() {
    	Opportunity testOpp = ZenDeskCaseTestUtil.newOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp.Permalink__c = 'test.permalink';
    	insert testOpp;
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', null);
    	testCase.Permalink__c = 'test.permalink';
    	insert testCase;
    	testCase = [select Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(CaseUtils.getSettings().OrphanedCasesOppID__c, testCase.Opportunity__c);
    	system.assertEquals('test.permalink', testCase.Permalink__c);
    	system.assertEquals(null, testCase.Zendesk__Zendesk_Ticket_ID__c);
    }
    
    static testMethod void testPermalinkAndOppNoTicket() {
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', null);
    	testCase.Permalink__c = 'test.permalink';
    	insert testCase;
    	Opportunity testOpp = ZenDeskCaseTestUtil.newOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp.Permalink__c = 'test.permalink';
    	insert testOpp;
    	
    	testCase = [select Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(CaseUtils.getSettings().OrphanedCasesOppID__c, testCase.Opportunity__c);
    	system.assertEquals('test.permalink', testCase.Permalink__c);
    	system.assertEquals(null, testCase.Zendesk__Zendesk_Ticket_ID__c);
    }
    
    static testMethod void testPermalinkAndOppAndTicket() {
    	Opportunity testOpp = ZenDeskCaseTestUtil.newOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp.Permalink__c = 'test.permalink';
    	insert testOpp;
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 12345);
    	testCase.Permalink__c = 'test.permalink';
    	insert testCase;
    	
    	testCase = [select Status, Reason, Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(testOpp.Id, testCase.Opportunity__c);
    	system.assertEquals('test.permalink', testCase.Permalink__c);
    	system.assertEquals(12345, testCase.Zendesk__Zendesk_Ticket_ID__c);
    	
    	system.assertEquals('New', testCase.Status);
    	system.assertEquals('New problem', testCase.Reason);
    }
    
    static testMethod void testPermalinkAndOppAndTicket2() {
    	Opportunity testOpp = ZenDeskCaseTestUtil.newOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp.Permalink__c = 'test.permalink';
    	insert testOpp;
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 12345);
    	testCase.Permalink__c = 'test.permalink';
    	insert testCase;
    	
    	Case testCase2 = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 12345);
    	testCase2.Permalink__c = 'test.permalinasdk';
    	insert testCase2;
    	
    	testCase = [select Status, Reason, Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(CaseUtils.getSettings().OrphanedCasesOppID__c, testCase.Opportunity__c);
    	system.assertEquals('test.permalinasdk', testCase.Permalink__c);
    	system.assertEquals(12345, testCase.Zendesk__Zendesk_Ticket_ID__c);
    	
    	system.assertEquals('New', testCase.Status);
    	system.assertEquals('New problem', testCase.Reason);
    }
    
    static testMethod void testPermalinkAndOppAndTicketExisting() {
    	Opportunity testOpp = ZenDeskCaseTestUtil.newOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp.Permalink__c = 'test.permalink';
    	insert testOpp;
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 999529999);
    	testCase.Permalink__c = 'test.permalink';
    	insert testCase;
    	
    	testCase = [select Status, Reason, Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals('New', testCase.Status);
    	system.assertEquals('New problem', testCase.Reason);
    	
    	Test.startTest();
    	
    	try {
    		Database.DMLOptions dml = new Database.DMLOptions();
    		dml.optAllOrNone = false;
    		Case testCase2 = ZenDeskCaseTestUtil.newCase('Closed', 'Web', 'Another problem', 999529999);
    		testCase2.Permalink__c = 'test.permalink';
    		Database.insert(testCase2, dml);
    	} catch (Exception e) {
    		system.assert(e.getMessage().contains('A case with this Ticket ID already exists. It will be updated. TicketID: 12345'));
    	}
    	
    	//query the original Case, to make sure it was updated
    	testCase = [select Status, Reason, Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals('Closed', testCase.Status);
    	system.assertEquals('Another problem', testCase.Reason);
    	
    	testCase = [select Opportunity__c, Permalink__c, Zendesk__Zendesk_Ticket_ID__c from Case where id = :testCase.id];
    	system.assertEquals(testOpp.Id, testCase.Opportunity__c);
    	system.assertEquals('test.permalink', testCase.Permalink__c);
    	system.assertEquals(999529999, testCase.Zendesk__Zendesk_Ticket_ID__c);
    	
    	Test.stopTest();
    	
    	system.assertEquals(1, [select count() from Case where Zendesk__Zendesk_Ticket_ID__c = 999529999]);
    }
    
    static testMethod void testBulkInsert() {
    	List<Case> toInsert = new List<Case>();
    	
    	Opportunity testOpp = ZenDeskCaseTestUtil.newOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp.Permalink__c = 'test.permalink';
    	insert testOpp;
    	
    	Opportunity testOpp2 = ZenDeskCaseTestUtil.createOpportunity('Food and Drink', 'Performance Fleece');
    	testOpp2.Permalink__c = 'test.permalink2';
    	update testOpp2;
    	
    	Case testCase = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 999529999);
    	testCase.Permalink__c = 'test.permalink';
    	
    	Case testCase2 = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 999529998);
    	testCase2.Permalink__c = 'test.permalink';
    	
    	Case testCase3 = ZenDeskCaseTestUtil.newCase('New', 'Web', 'New problem', 979529999);
    	testCase3.Permalink__c = 'test.permalink2';
    	
    	toInsert.add(testCase);
    	toInsert.add(testCase2);
    	toInsert.add(testCase3);
    	
    	insert toInsert;
    	
    	testCase = [select Opportunity__c from Case where id = :testCase.Id];
    	system.assertEquals(testOpp.Id, testCase.Opportunity__c);
    	
    	testCase2 = [select Opportunity__c from Case where id = :testCase2.Id];
    	system.assertEquals(testOpp.Id, testCase2.Opportunity__c);
    	
    	testCase3 = [select Opportunity__c from Case where id = :testCase3.Id];
    	system.assertEquals(testOpp2.Id, testCase3.Opportunity__c);
    }
    
}