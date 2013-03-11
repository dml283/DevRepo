@isTest
class TestNetSuiteCreationWorkflow 
{
	static testMethod void testSendToNetSuite()
	{
		NetSuiteCreationWorkflow.hasExecuted = true;
		Account a  = TestUtil.createAccount('ut acc1', true);
		Opportunity newOppty = TestUtil.createOpportunity(a, 'ut oppty1', 'stage', Date.today(), true);
		Opportunity oldOppty = TestUtil.createOpportunity(a, 'ut oppty2', 'stage', Date.today(), true);
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{newOppty.ID => newOppty};
		Map<ID, Opportunity> oldMap = new Map<ID, Opportunity>{newOppty.ID => oldOppty};
		NetSuiteCreationWorkflow nscw = new NetSuiteCreationWorkflow(newMap, oldMap);
		
		NetSuiteCreationWorkflow.hasExecuted = false;
		//since the record type is not goods, the callout to netsuite is not issued
		nscw.execute();
		System.assertEquals(nscw.calloutToNetSuiteCreateDone, false);
		
		//update the record type to Goods
		newOppty.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GOODS);
		//since fufillment method isnt one of the defined values, the callout will still not be issued
		NetSuiteCreationWorkflow.hasExecuted = false;
		nscw.execute();
		System.assertEquals(nscw.calloutToNetSuiteCreateDone, false);
		
		//give the oppty a correct fulfillment method for callout to be issued
		newOppty.Fulfillment_Method__c = Constants.FULFILLMENT_METHOD_DROP_SHIP_GROUPON_SMALL_PARCEL;
		//since hte stage name didnt change to Deal Structure approved, tehe callout will still not be issued
		NetSuiteCreationWorkflow.hasExecuted = false;
		nscw.execute();
		System.assertEquals(nscw.calloutToNetSuiteCreateDone, false);
		
		//this time update the stage to deal structure approved and verify that this time the callout is issued
		newOppty.StageName = Constants.OPPORTUNITY_STAGE_DEAL_STRUCTURE_APPROVED;
		NetSuiteCreationWorkflow.hasExecuted = false;
		nscw.execute();
		System.assertEquals(nscw.calloutToNetSuiteCreateDone, true);
	}
}