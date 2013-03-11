@isTest
private class testOpportunityTriggerFactoryPR {
	
	static testMethod void testQLfieldCopy(){
		User u = testUtil.createUser('System Administrator');
        User u1 = testUtil.createUser2('Outside Sales');

        System.RunAs(u){
        	Account a = new Account ();
	        a.name = 'Test Acct';
	        a.ownerId = u1.id;
	        insert a;
	        
	        String g1RecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' and Name = 'G1'].Id;
			
			Division__c d = new Division__c(); 
	        d.name = 'Chicago';
	        d.state__c = 'IL';
	        d.Manually_Assign_City_Team__c = False;
	        d.DSM__c = u.Id;
	        d.Outside_DSM__c = u.Id;
	        d.City_CEO__c = u.Id;
	        d.Market_Planner__c = u.Id;
	        insert d;
			
	    	Opportunity o1 = new Opportunity();
	        o1.name = 'Test Opportunity 1';
	        o1.RecordTypeId = g1RecordTypeId;
	        o1.OwnerId = u1.id;
	        o1.StageName = 'Prospecting';
	        o1.CloseDate = Date.today();
	        o1.AccountId = a.Id;
	        o1.Division__c = 'Chicago';
	        o1.Division_Dynamic__c  = d.Id;
			o1.User__c = u.Id;
	        insert o1;
	        batchapexstop.stopbatchapex =false;
	        
	        Quantum_Lead__c q = new Quantum_Lead__c();
	        q.Sales_Value__c = 100;
			q.Call_List_Priority__c = 'test';
			q.Account__c = a.Id;
			q.Parent_Id__c = a.Id;
			insert q;
			
			List <QL_SalesVal__c> createSalesVals = TestUtil.createSalesVals(q);
			List <QL_RankVal__c> createRanks = TestUtil.createRanks(q);
			
        Test.startTest();        
    		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    		req1.setObjectId(o1.Id);
    		Approval.ProcessResult result1 = Approval.process(req1);
    		System.assert(result1.isSuccess());
    		System.assertEquals('Pending', result1.getInstanceStatus(), 'Instance Status'+result1.getInstanceStatus());
    		
    		Opportunity o = [Select QL_Sales_Value__c, QL_Rank__c, Highest_QL_Rank_90_Day__c, Highest_QL_Sales_Value_90_Day__c from Opportunity where Id =: o1.Id];
    		
    		//System.assertEquals(o.QL_Sales_Value__c, 100);
    		//System.assertEquals(o.QL_Rank__c, 'test');
    		//System.assertEquals(o.Highest_QL_Rank_90_Day__c, 1);
    		//System.assertEquals(o.Highest_QL_Sales_Value_90_Day__c, 300);
        Test.stopTest();
        }
	}
/*
	static testMethod void mytestOpportunityTriggerFactoryPR() {
		User u = testUtil.createUser('System Administrator');
        User u1 = testUtil.createUser2('Outside Sales');
        
        System.RunAs(u) {
			Division__c d = new Division__c(); 
	        d.name = 'Chicago';
	        d.state__c = 'IL';
	        d.Manually_Assign_City_Team__c = False;
	        d.DSM__c = u.Id;
	        d.Outside_DSM__c = u.Id;
	        d.City_CEO__c = u.Id;
	        d.Market_Planner__c = u.Id;
	        insert d;
        
            Subdivision__c s = new Subdivision__c();
            s.Name = 'Downtown - South(Chicago)';
            s.Division__c = d.Id;
            s.Is_Active__c = True;
            insert s;

            Zip_Code__c z = new Zip_Code__c();
            z.name = '60601';
            z.Subdivision__c = s.Id;
            insert z;

            taxonmyMap__c t = new taxonmyMap__c();
            t.Category_v3__c = 'Leisure Offers / Activities';
            t.Primary_Service__c = 'Air Rifle';
            t.newCategory__c = 'Leisure Offers';
            t.newSubcategory__c = 'Shooting';
            t.newSubcategory1__c = 'Air Rifle';
            t.oldCategory__c = 'Activities';
            t.oldSubcategory__c = 'Sports';
            t.Object__c = 'Opportunity';
            t.direct__c = True;
            insert t;

            taxonmyMap__c t1 = new taxonmyMap__c();
            t1.Category_v3__c = 'Leisure Offers / Activities';
            t1.Primary_Service__c = 'Snowshoeing';
            t1.newCategory__c = 'Leisure Offers';
            t1.newSubcategory__c = 'Leisure Sports';
            t1.newSubcategory1__c = 'Leisure Sports';
            t1.oldCategory__c = 'Activities';
            t1.oldSubcategory__c = 'Outdoor Pursuits';
            t1.Object__c = 'Opportunity';
            t1.direct__c = False;
            insert t1;

            Account a = new Account ();
            a.name = 'Test Acct';
            a.OwnerId = u.id;
            a.Account_Manager__c = u.id;
            a.Category_v3__c = 'Leisure Offers / Activities';
            insert a;

            String g1RecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' and Name = 'G1'].Id;
            String getawaysRecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' and Name = 'Groupon Getaways'].Id;

            opportunity o = new opportunity();
            o.name = 'Test Opportunity';
            o.RecordTypeId = g1RecordTypeId;
            o.OwnerId = u.id;
            o.StageName = 'Prospecting';
            o.CloseDate = date.today();
            o.AccountId = a.Id;
            o.Division__c = 'Chicago';
            o.Division_Dynamic__c  = d.Id;
            o.Subdivision__c = 'Online/No Location';
            o.Primary_Deal_Services__c = 'Air Rifle';
            o.Category__c = 'GrouponLive';
            o.Subcategory__c = 'Music Event';
            o.Global_SFDC_Category__c = '';
            o.Global_SFDC_Subcategory_1__c = '';
            o.Global_SFDC_Subcategory_2__c = '';
            insert o;
            batchapexstop.stopbatchapex =false;

            o.Category__c = '';
            o.Subcategory__c = '';
            o.Global_SFDC_Category__c = 'GrouponLive';
            o.Global_SFDC_Subcategory_1__c = 'Music Event';
            o.Global_SFDC_Subcategory_2__c = 'Music Event';
            o.Primary_Deal_Services__c = 'Snowshoeing';
            update o;
            batchapexstop.stopbatchapex =false;
			
            Opportunity o1 = new Opportunity();
            o1.name = 'Test Opportunity 1';
            o1.RecordTypeId = g1RecordTypeId;
            o1.OwnerId = u1.id;
            o1.StageName = 'Prospecting';
            o1.CloseDate = date.today();
            o1.AccountId = a.Id;
            o1.Division__c = 'Chicago';
            o1.Division_Dynamic__c  = d.Id;
            o1.Category__c = 'Activities';
            o1.Subcategory__c = 'Outdoor Pursuits';
            o1.Global_SFDC_Category__c = '';
            o1.Global_SFDC_Subcategory_1__c = '';
            o1.Global_SFDC_Subcategory_2__c = '';
            o1.Primary_Deal_Services__c = 'Snowshoeing';
            insert o1;
            batchapexstop.stopbatchapex =false;

            o1.RecordTypeId = getawaysRecordTypeId ;
            o1.Feature_Date__c = date.today() - 1;
            o1.Division_Dynamic__c  = null;
            o1.Category__c = '';
            o1.Subcategory__c = '';
            o1.Global_SFDC_Category__c = 'Leisure Offers';
            o1.Global_SFDC_Subcategory_1__c = 'Leisure Sports';
            o1.Global_SFDC_Subcategory_2__c = 'Leisure Sports';
            o1.Primary_Deal_Services__c = 'Snowshoeing';
            update o1;
            batchapexstop.stopbatchapex = false;

            multi_deal__c m = new multi_deal__c();
            m.CP_Projection__c = 100;
            m.Units_Sold__c = 100;
            m.opportunity__c = o.id;
            m.Groupon_Rev_Share__c = null;
            insert m;

            Address__c addy = new Address__c();
            addy.Opportunity__c = o.id;
            addy.Street_Line_1__c = '303 E Wacker Dr';
            addy.Street_Line_2__c = '26th Floor';
            addy.City__c = 'Chicago';
            addy.State__c = 'IL';
            addy.Zip_Postal_Code__c = '60601';
            addy.Country__c = 'US';
            addy.Subdivision__c = s.Id;
            insert addy; 
	    }
	}
	*/

}