/**
* @author Daniel Nakonieczny - Model Metrics
* @date July 5th 2011
* @description This class processes Cases that were sent from ZenDesk using Web2Case
*/

public with sharing class CaseUtils {

	/**
	 * Processes Cases as they come in from Web2Case, which is used by Zendesk
	 * to push Tickets into Salesforce. It is called from the Case trigger
	 * @param List<Case> cList A list of Cases passed from the trigger.
	 */
	public static void processCases(List<Case> cList) {
		Set<String> permalinks = new Set<String>();
		Set<Decimal> ticketIDs = new Set<Decimal>();
		String orphanedCasesOppID = getSettings().OrphanedCasesOppID__c;
		List<Case> goodCases = new List<Case>();
		List<Case> badCases = new List<Case>();
		
		//go through each incoming Case, and note their Permalinks and Zendesk Ticket IDs
		//so that we can query existing Cases and Opportunities using that data
		for (Case c : cList) {
			if (c.Permalink__c != null && c.Permalink__c != '') {
				permalinks.add(c.Permalink__c);
			}
			if (c.Zendesk__Zendesk_Ticket_ID__c != null && c.Zendesk__Zendesk_Ticket_ID__c > 0) {
				ticketIDs.add(c.Zendesk__Zendesk_Ticket_ID__c);
			}
		}
		
		List<Case> caseList = [select Id, Zendesk__Zendesk_Ticket_ID__c, Reason, Permalink__c from Case where Zendesk__Zendesk_Ticket_ID__c in :ticketIDs];
		
		//Map to store Cases by their Ticket IDs
		Map<Integer, Case> ticketIDtoCase = new Map<Integer, Case>();
		
		for (Case c : caseList) {
			ticketIDtoCase.put(c.Zendesk__Zendesk_Ticket_ID__c.intValue(), c);
		}
		
		List<Opportunity> opList = [select Id, AccountId, Permalink__c from Opportunity where Permalink__c in :permalinks];
		Map<String, Opportunity> permalinkToOppMap = new Map<String, Opportunity>();
		
		for (Opportunity o : opList) {
			permalinkToOppMap.put(o.Permalink__c, o);
		}
		
		List<Case> casesToCreate = new List<Case>();
		List<Case> casesToUpdate = new List<Case>();
		
		for (Case c : cList) {
			if (c.Permalink__c != null && c.Permalink__c != '') {
				Opportunity o = permalinkToOppMap.get(c.Permalink__c);
				if (o == null) {
					
					if (c.Zendesk__Zendesk_Ticket_ID__c != null && c.Zendesk__Zendesk_Ticket_ID__c > 0) {
						Case oldCase = ticketIDtoCase.get(c.Zendesk__Zendesk_Ticket_ID__c.intValue());
						if (oldCase == null) {
							c.Origin = c.Source__c;
						} else {
							oldCase.AccountId = null;
							oldCase.Opportunity__c = null;
							oldCase.Reason = c.Reason;
							oldCase.Status = c.Status;
							oldCase.Subject = c.Subject;
							oldCase.Description = c.Description;
							oldCase.Assignee__c = c.Assignee__c;
							oldCase.Bucket__c = c.Bucket__c;
							oldCase.Origin = c.Source__c;
							oldCase.Tags__c = c.Tags__c; 
							oldCase.Permalink__c = c.Permalink__c;
							casesToUpdate.add(oldCase);
							badCases.add(oldCase);
							c.Duplicate__c = true;
						}
						 
					}
					
					badCases.add(c);
				} else {
					if (c.Zendesk__Zendesk_Ticket_ID__c != null && c.Zendesk__Zendesk_Ticket_ID__c > 0) {
						Case oldCase = ticketIDtoCase.get(c.Zendesk__Zendesk_Ticket_ID__c.intValue());
						if (oldCase == null) {
							c.Opportunity__c = o.Id; 
							c.AccountId = o.AccountId;
							c.Origin = c.Source__c;
						} else {
							oldCase.Opportunity__c = o.Id;
							oldCase.AccountId = o.AccountId;
							oldCase.Reason = c.Reason;
							oldCase.Status = c.Status;
							oldCase.Subject = c.Subject;
							oldCase.Description = c.Description;
							oldCase.Assignee__c = c.Assignee__c;
							oldCase.Bucket__c = c.Bucket__c;
							oldCase.Origin = c.Source__c;
							oldCase.Tags__c = c.Tags__c;
							oldCase.Permalink__c = c.Permalink__c;
							casesToUpdate.add(oldCase);
							c.Duplicate__c = true;
						}
						 
					} else {
						badCases.add(c);
					}
				}
			} else { 
				badCases.add(c);
			}
		}
		
		//point all the bad Cases (without Permalinks or TicketIDs) to a special
		//Opportunity for Orphaned Cases
		for (Case c : badCases) {
			c.Opportunity__c = orphanedCasesOppID;
		}
		
		//update any existing Cases, in case anything changed
		if (!casesToUpdate.isEmpty()) {
			try {
				update casesToUpdate;
			} catch (Exception e) {
				system.debug(e.getMessage());
				system.debug(e.getStackTraceString());
			}
		}	
	}
	
	/**
	 * Marks Cases for deletion. This happens if a Case comes in from Zendesk, and there already exists a Case in the system with 
	 * the same Ticket ID. We extract the data from the incoming Case, and update the original Case with the new data. 
	 * The incoming Case can be then safely deleted.
	 * @param List<Case> cList A list of Cases passed from the processCases method.
	 */
	public static void markForDeletion(List<Case> cList) {
		Set<Id> toDelete = new Set<Id>();
		
		for (Case c : cList) {
			if (c.Duplicate__c) {
				toDelete.add(c.Id);
			}
		}
		
		if (!toDelete.isEmpty()) {
			deleteCases(toDelete);
		}
	}
	
	/**
	 * deletes all the duplicate Cases. We extract the data from them, to update the originals
	 * so the duplicates need to be deleted
	 * @param Set<Id> toDelete A set of Case IDs passed from the markForDeletion method.
	 */
	@future
	public static void deleteCases(Set<Id> toDelete) {
		try {
			List<Case> toDel = [select Id from Case where Id in :toDelete];
    		Database.delete(toDel);
		} catch (Exception e) {
			system.debug(e.getMessage());
			system.debug(e.getStackTraceString());
		}
	}
	
	/**
	 * Gets a list of custom settings from the ZenDesk2Salesforce__c object
	 * @return ZenDesk2Salesforce__c The default instance of the ZenDesk2Salesforce__c custom setting
	 */
	public static ZenDesk2Salesforce__c getSettings() {
        // get the user-specific settings (null if none)
        ZenDesk2Salesforce__c settings = ZenDesk2Salesforce__c.getValues(UserInfo.getUserId());
        
        if (settings == null) {
            // if null, copy the closest settings that apply
            ZenDesk2Salesforce__c curSettings = ZenDesk2Salesforce__c.getInstance(UserInfo.getUserId());
            
            //If this line is failing, it's because there is no applicable System_Settings__c record in the org
            //Check custom settings and click "Manage" to add a record
        	System.assertNotEquals(null, curSettings);
        	
            settings = curSettings.clone(false);
            settings.SetupOwnerId = UserInfo.getUserId();
        }
        
        return settings;
    }
	
}