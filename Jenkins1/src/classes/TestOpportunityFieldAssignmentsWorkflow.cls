@isTest
class TestOpportunityFieldAssignmentsWorkflow 
{
	static testMethod void testAssignAccountManager()
	{
		User u = TestUtil.createUser('Standard User');
		Account a;
		System.runAs(u)
		{
			a = TestUtil.createAccount('ut acc1', false);
			a.Account_Manager__c = UserInfo.getUserId();
			a.BillingStreet = 'street 1';
			a.BillingCity = 'city1';
			a.BillingState = 'IL';
			a.BillingCountry = 'US';
			a.BillingPostalCode = '60645';
			insert a;
			
			
		}
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = true;
		a = [Select ID, OwnerID, Account_Manager__c from Account where ID =: a.ID];
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'oppt1', 'New', Date.today(), true);
		opptyNew.OwnerID = [Select ID, OwnerID from Opportunity where ID =: opptyNew.ID].OwnerID;
		opptyNew.RecordTypeID = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		OpportunityFieldAssignmentsWorkflow ofawf = new OpportunityFieldAssignmentsWorkflow(newMap, newMap);
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		
		System.assertEquals(opptyNew.Acct_Owner__c, a.OwnerID);
		System.assertEquals(opptyNew.Owner_lookup__c, opptyNew.OwnerID);
		//System.assertEquals(opptyNew.Account_Coordinator__c, a.Account_Manager__c);	
		
	}
	
	static testMethod void testAssignDivision()
	{
		Account a = TestUtil.createAccount('ut acc1', false);
		a.Account_Manager__c = UserInfo.getUserId();
		a.BillingStreet = 'street 1';
		a.BillingCity = 'city1';
		a.BillingState = 'IL';
		a.BillingCountry = 'US';
		a.BillingPostalCode = '60645';
		insert a;
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = true;
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'oppt1', 'New', Date.today(), true);
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		OpportunityFieldAssignmentsWorkflow ofawf = new OpportunityFieldAssignmentsWorkflow(newMap, newMap);
		
		Division__c div = TestUtil.createDivision();
		div.Name = 'div1';
		insert div;
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		opptyNew.Division__c = 'div1';
		ofawf.execute();
		
		System.assertEquals(opptyNew.Division_Dynamic__c, div.ID);
	}
	
	static testMethod void testAssignCityTeam()
	{
		Account a = TestUtil.createAccount('ut acc1', false);
		a.Account_Manager__c = UserInfo.getUserId();
		a.BillingStreet = 'street 1';
		a.BillingCity = 'city1';
		a.BillingState = 'IL';
		a.BillingCountry = 'US';
		a.BillingPostalCode = '60645';
		insert a;
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = true;
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'oppt1', 'New', Date.today(), true);
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		OpportunityFieldAssignmentsWorkflow ofawf = new OpportunityFieldAssignmentsWorkflow(newMap, newMap);
		
		Division__c div = TestUtil.createDivision();
		div.Name = 'div1';
		insert div;
		
		//record type Rewards should make City Manager, DSM and User null
		opptyNew.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.City_Manager__c, null);
		System.assertEquals(opptyNew.Divisional_Sales_Manager__c, null);
		System.assertEquals(opptyNew.User__c, null);
		
		//if record type is G1, feature date is in future and division exists, values from Division would populate the fields on oppty but since division doens't have anything populated, the lookups will still be null
		opptyNew.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_G1);
		opptyNew.Feature_Date__c = Date.today().addDays(5);
		opptyNew.Division_Dynamic__c = div.ID;
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.City_Manager__c, null);
		System.assertEquals(opptyNew.Divisional_Sales_Manager__c, null);
		System.assertEquals(opptyNew.User__c, null);
		
		// this time, populate CEO Lookup in Division adn verify that gets pushed to oppty
		div.City_CEO__c = UserInfo.getUserId();
		update div;
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.City_Manager__c, UserInfo.getUserId());
		
		//If DSM is filled out on Division, verify that the opptys DSM gets filled with that user
		System.assertEquals(opptyNew.Divisional_Sales_Manager__c, null);
		div.DSM__c =  UserInfo.getUserId();
		update div;
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.Divisional_Sales_Manager__c, UserInfo.getUserId());
		
		//verify that if outside DSM is filled on DIV, DSM is null and hte owners profile is OUtside sales, Outside DSM on div becomes the outside DSM on oppty
		User u = TestUtil.getTestUser('utgrpn1', Constants.PROFILE_NAME_OUSIDE_SALES);
		insert u;
		opptyNew.OwnerId = u.ID;
		opptyNew.Divisional_Sales_Manager__c = null;
		div.Outside_DSM__c = u.ID;
		update div;
		
		System.assertEquals(opptyNew.Divisional_Sales_Manager__c, null);
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.Divisional_Sales_Manager__c, u.ID);
		
		//verify that populating a market planner on division, pushes that value on opptys User lookup
		System.assertEquals(opptyNew.User__c, null);
		div.Market_Planner__c = u.ID;
		update div;
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.User__c, u.ID);
		
		
	}
	
	static testMethod void testAssignAutoSubDivision()
	{
		Account a = TestUtil.createAccount('ut acc1', false);
		a.Account_Manager__c = UserInfo.getUserId();
		a.BillingStreet = 'street 1';
		a.BillingCity = 'city1';
		a.BillingState = 'IL';
		a.BillingCountry = 'US';
		a.BillingPostalCode = '60645';
		insert a;
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = true;
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'oppt1', 'New', Date.today(), true);
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		OpportunityFieldAssignmentsWorkflow ofawf = new OpportunityFieldAssignmentsWorkflow(newMap, newMap);
		
		Address__c add = Testutil.createAddress(a.ID, opptyNew.ID, 'street1', 'IL','60016', 'SheKago', 'US');
		Subdivision__c sd = TestUtil.createSubDiv();
		Zip_Code__c zc = TestUtil.createZipCode('60016', false);
		zc.Subdivision__c = sd.ID;
		insert zc;
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		
		System.assertEquals(opptyNew.Subdivision_Dynamic__c, sd.ID);
		
	}
	
	static testMethod void testAssignOpptyCategories()
	{
		Account a = TestUtil.createAccount('ut acc1', false);
		a.Account_Manager__c = UserInfo.getUserId();
		a.BillingStreet = 'street 1';
		a.BillingCity = 'city1';
		a.BillingState = 'IL';
		a.BillingCountry = 'US';
		a.BillingPostalCode = '60645';
		a.Category_v3__c = 'catv31';
		insert a;
		
		OpportunityFieldAssignmentsWorkflow.hasExecuted = true;
		Opportunity opptyNew = TestUtil.createOpportunity(a, 'oppt1', 'New', Date.today(), false);
		opptyNew.Primary_Deal_Services__c = 'pds1';
		opptyNew.Category__c = 'originalCat';
		insert opptyNew;
		opptyNew = [Select ID, name, AccountID, Category_V3__c, Primary_Deal_Services__c, Category__c,  Subcategory__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c,Global_SFDC_Subcategory_2__c, OwnerID 
					from Opportunity where ID =: opptyNew.ID];
		Opportunity opptyOld = TestUtil.createOpportunity(a, 'oppt2', 'New', Date.today(), false);
		opptyOld.Primary_Deal_Services__c = 'pds1';
		insert opptyOld;
		Map<ID, Opportunity> newMap = new Map<ID, Opportunity>{opptyNew.ID => opptyNew};
		Map<ID, Opportunity> oldMap = new Map<ID, Opportunity>{opptyNew.ID => opptyOld};
		OpportunityFieldAssignmentsWorkflow ofawf = new OpportunityFieldAssignmentsWorkflow(newMap, oldMap);
		
		TaxonmyMap__c tm = TestUtil.createTaxonmyMap('Opportunity', 'pds1', 'catv31', 'subCatV3', 'oc1', 'osc1', 'cat1', 'newSC', 'newSC1', true);
		
		//verify that if pds don't change, the cateogry on oppty remains unchanged 
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.Category__c, 'originalCat');
		
		//change pds this time and verify that the category is still not populated since deal strength is not the correct value
		opptyOld.Primary_Deal_Services__c = 'pds2';
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		System.assertEquals(opptyNew.Category__c, 'originalCat');
		
		//update deal strength this time and verify that category and other values from taxonomy Map are populated to Oppty
		//System.debug('\n\nopptyNew.Category_V3__c = '+opptyNew.Category_v3__c+'\n\n');
		opptyNew.Deal_Strengh__c = Constants.DEAL_STRENGTH_REP_TAKING_INFO;
		OpportunityFieldAssignmentsWorkflow.hasExecuted = false;
		ofawf.execute();
		
		System.assertEquals(opptyNew.Category__c, 'oc1');
		System.assertEquals(opptyNew.Subcategory__c, 'osc1');
		System.assertEquals(opptyNew.Global_SFDC_Category__c,'cat1');
        System.assertEquals(opptyNew.Global_SFDC_Subcategory_1__c, 'newSC' );
        System.assertEquals(opptyNew.Global_SFDC_Subcategory_2__c, 'newSC1');
	}
}