@isTest
class TestOpportunityServices 
{
	static testMethod void testMapRecordTypeNamesToID()
	{
		Map<String, ID> rtMap = new Map<String, ID>();
		for(RecordType rt: [Select ID, DeveloperName, Name from RecordType where SObjectType =: 'Opportunity'])
			rtMap.put(rt.DeveloperName, rt.ID);
		
		Map<String, ID> rtMapToTest = OpportunityServices.mapRecordTypeNamesToID;
		System.assertEquals(rtMapToTest.size(), rtMap.size());
		System.assert(rtMapToTest.keySet().containsAll(rtMap.keySet()));
		for(String devname: rtMapToTest.keySet())
			System.assertEquals(rtMapToTest.get(devName), rtMap.get(devName));
	}
	
	static testMethod void testMapRecordTypeIDsToName()
	{
		Map<ID, String> rtMap = new Map<ID, String>();
		for(RecordType rt: [Select ID, DeveloperName, Name from RecordType where SObjectType =: 'Opportunity'])
			rtMap.put(rt.ID, rt.DeveloperName);
		
		Map<ID, String> rtMapToTest = OpportunityServices.mapRecordTypeIDsToName;
		System.assertEquals(rtMapToTest.size(), rtMap.size());
		System.assert(rtMapToTest.keySet().containsAll(rtMap.keySet()));
		for(ID rtID: rtMapToTest.keySet())
			System.assertEquals(rtMapToTest.get(rtID), rtMap.get(rtID));
	}
}