/*
Name: OpportunityServices
Owner: Naushad Rafique
Created Date: 1/31/2013
TestClass : TestOpportunityServices
Last Modified By: Naushad Rafique
Last Modified Date: 1/31/2013 
This class holds all the static level methods relating to the Opportunity object. Will be primarily used by triggers and batch updates
on Opportunity object
*/
public with sharing class OpportunityServices 
{
	public static Map<String, ID> mapRecordTypeNamesToID
	{
		get
		{
			if(mapRecordTypeNamesToID == null)
			{
				mapRecordTypeNamesToID = new Map<String, ID>();
				
				for(RecordType rt: [Select ID, DeveloperName, Name from RecordType where SObjectType =: 'Opportunity'])
					mapRecordTypeNamesToID.put(rt.DeveloperName, rt.ID);
			}
				
			return mapRecordTypeNamesToID;
		}
		
		private set;
	}
	
	public static Map<ID, String> mapRecordTypeIDsToName
	{
		get
		{
			if(mapRecordTypeIDsToName == null)
			{
				mapRecordTypeIDsToName = new Map<ID, String>();
				
				for(RecordType rt: [Select ID, DeveloperName, Name from RecordType where SObjectType =: 'Opportunity'])
					mapRecordTypeIDsToName.put(rt.ID, rt.DeveloperName);
			}
				
			return mapRecordTypeIDsToName;
		}
		
		private set;
	}
}