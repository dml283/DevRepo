/**
* @author Daniel Nakonieczny - Model Metrics
* @date July 5th 2011
* @description This class helps with the creation of sample data in unit tests
*/

public with sharing class ZenDeskCaseTestUtil {
	public static Case newCase(String status, String origin, String reason, Decimal ticketID) {
		Case c = new Case();
		c.Status = status;
		c.Origin = origin;
		c.Reason = reason;
		c.Zendesk__Zendesk_Ticket_ID__c = ticketID;
		return c;
	}
	
	public static Case createCase(String status, String origin, String reason, Decimal ticketID) {
		Case c = newCase(status, origin, reason, ticketID);
		insert c;
		return c;
	}
	
	public static Opportunity newOpportunity(String categoryId, String subcategory) {
		Opportunity o = new Opportunity(Name = 'TEST' + System.currentTimeMillis(), Subcategory__c = subcategory, StageName = 'Contract Sent', CloseDate = System.today().addDays(30),Category__c=categoryId);
		return o;
	}
	
	public static Opportunity createOpportunity(String categoryId, String subcategory) {
		Opportunity o = newOpportunity(categoryId, subcategory);
		insert o;
		return o;
	}
}