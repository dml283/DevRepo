/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testZenDeskTicketSubmission {
static testmethod void mytestZenDeskTicketSubmission()
{
    Profile p = [select id from profile where name='System Administrator'];
                 User u = new User(alias = 'standt', email='testzenDeskTicketSubmission@groupon.com',
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id,
                 timezonesidkey='America/Los_Angeles', username='testzenDeskTicketSubmission@groupon.com');
                 insert u;
                 
    //run as user
    System.RunAs(u) 
        {
            Test.startTest();
            
            List<Opportunity> OppList = new List<Opportunity> ();
            List<Opportunity> OppList2 = new List<Opportunity> ();      
            Map<Id,Opportunity> OppMap = new Map<Id,Opportunity>();        
            Map<Id,Opportunity> OppMap2 = new Map<Id,Opportunity>(); 
            Map<Id,multi_deal__c> MultiMap = new Map<Id,multi_deal__c>();        
            Map<Id,multi_deal__c> MultiMap2 = new Map<Id,multi_deal__c>();  
            Map<Id,address__c> addressMap = new Map<Id,address__c>();        
            Map<Id,address__c> addressMap2 = new Map<Id,address__c>();                                                      
            List<multi_deal__c> multilist = new List<multi_deal__c>();
            List<multi_deal__c> multilist2 = new List<multi_deal__c>();
            List<address__c> addresslist = new List<address__c>();
            List<address__c> addresslist2 = new List<address__c>();
        
            division__c d = new division__c(); 
            d.name = 'test';
            d.state__c = 'CA';
            insert d; 
                        
            division__c d2 = new division__c(); 
            d2.name = 'test3';
            d2.state__c = 'IL';
            insert d2; 
                        
            account a =  new account ();
            a.name = 'Test Acct';
            a.OwnerId = u.id;
            a.Account_Manager__c = u.id;
            insert a;

            Opportunity O = new Opportunity();
            o.name = 'oppt';
            o.AccountId = a.Id;
            o.Feature_Date__c = date.today() + 1;
            o.feature_end_date__c = date.today()+1;
            o.Unit_buy_price__c = 2407;
            o.Unit_sell_price__c = 5070;
            o.Value_of_Unit__c = 456;
            o.Max_Units__c    = '323';                     
            o.Min_Units__c    = '303'; 
            o.enable_staggered_expiration__c = false; 
            o.opt_Out_of_Mulligan__c = false;
            o.Deal_Bank_Eligible__c = 'testeed';
            o.unique_Redemption_Website__c = false;
            o.conditions__c  = 'false';
            o.Type = 'feature';
            o.stagename  = 'closed lost';
            o.Deal_Strengh__c = 'A Sure Thing';
            o.display_Order__c  = 12;                                        
            o.targeting_Criteria__c  = 'Test1';
            o.show_in_Deals_Nearby__c = false; 
            o.Exclude_Pa__c  =   'no'; 
            o.min_Subs__c   = 11;     
            o.max_Subs__c   =21;   
            o.radius__c   =51;               
            o.coupon_instructions__c ='Test1'; 
            o.Expiration_Policy__c = 'Per Deal';
            o.Expiration_Type__c = 'Fixed';
            o.Months_to_Expiration__c = 3;
            o.Groupon_Expiration_Date__c = date.today()+1;
            o.Getaways_Deal_Filter__c = 'USA';
            o.division__c  =  d.Id;  
            o.ForecastCategoryName = 'Closed';
            o.OwnerId = u.id;
            o.CloseDate = date.today()+1;                      
            o.permalink__c = 'hello';
            insert o;
                 
            multi_deal__c multi = new multi_deal__c();
            multi.Opportunity__c = o.Id;
            multi.name = 'testmulti';
            multi.Multi_Deal_Expiration_Date__c = '6 months from feature';
            multi.Alternative_Expiration_Date__c = date.today();
            multi.Expiration_Type__c = 'Per Deal';
            multi.Months_to_Expiration__c = 3;
            multi.DaystoExpiration__c = 90;
            multi.GrouponLite_Monthly_Cap__c = 10;
            multi.Unit_Buy_Price__c = 123;                             
            multi.unit_sell_price__c = 321;    
            multi.unit_value__c = 200;
            multi.Shipping_Handling__c = 123;
            multi.Enable_Staggered_Expiration__c = true;
            multi.Buyer_max__c = 123;
            multi.Total_Deal_Max__c = 1;
            multi.display_order__c = 2;
            insert multi;
                            
            address__c address = new address__c();
            address.Opportunity__c = o.id;
            address.Street_Line_1__c = '303 E Wacker Dr';
            address.Street_Line_2__c = '26th Floor';
            address.City__c = 'Chicago';
            address.State__c = 'IL';
            address.Zip_Postal_Code__c = '60601';
            address.Venue_Name__c = 'Chicago Stadium';
            address.Phone_Number__c = '123-456-7890';
            Insert address;


            Opportunity o2 = new Opportunity();
            o2.name = 'oppty2';
            o2.AccountId = a.Id;
            o2.Feature_Date__c = date.today();
            o2.feature_end_date__c = date.today();
            o2.Unit_buy_price__c = 240;
            o2.Unit_sell_price__c = 507;
            o2.Value_of_Unit__c = 45;
            o2.Max_Units__c    = '32';                     
            o2.Min_Units__c    = '30'; 
            o2.enable_staggered_expiration__c = true; 
            o2.opt_Out_of_Mulligan__c = true;
            o2.Deal_Bank_Eligible__c = 'tested';
            o2.unique_Redemption_Website__c = true;
            o2.conditions__c  = 'true';
            o2.Type = 'Side Deal';
            o2.stagename  = 'Closed Won';
            o2.Deal_Strengh__c = 'Recommended';
            o2.display_Order__c  = 1;                                        
            o2.targeting_Criteria__c  = 'Test2';
            o2.show_in_Deals_Nearby__c = true; 
            o2.Exclude_Pa__c  =   'Yes'; 
            o2.min_Subs__c   = 1;     
            o2.max_Subs__c   =2;   
            o2.radius__c   =5;               
            o2.coupon_instructions__c ='Test2'; 
            o2.Expiration_Policy__c = 'Per Option';
            o2.Expiration_Type__c = 'Relative to Feature';
            o2.Months_to_Expiration__c = 6;
            o2.Groupon_Expiration_Date__c = date.today();
            o2.Getaways_Deal_Filter__c = 'Canada';
            o2.division__c  =  d.Id;  
            o2.ForecastCategoryName = 'Closed';
            o2.OwnerId = u.id;
            o2.CloseDate = date.today()+1;
            o2.permalink__c = 'hello';                  
            insert o2;
            
            multi_deal__c multi2 = new multi_deal__c();
            multi2.Opportunity__c = o.Id;
            multi2.name = 'testmulti2';
            multi2.Multi_Deal_Expiration_Date__c = '12 months from feature';
            multi2.Alternative_Expiration_Date__c = date.today() + 1;
            multi2.Expiration_Type__c = 'Per Option';
            multi2.Months_to_Expiration__c = 12;
            multi2.DaystoExpiration__c = 360;
            multi2.GrouponLite_Monthly_Cap__c = 15;
            multi2.Unit_Buy_Price__c = 12;                             
            multi2.unit_sell_price__c = 32;    
            multi2.unit_value__c = 20;
            multi2.Shipping_Handling__c = 12;
            multi2.Enable_Staggered_Expiration__c = false;
            multi2.Buyer_max__c = 12;
            multi2.Total_Deal_Max__c = 10;
            multi2.display_order__c = 1;
            insert multi2; 

            address__c address2 = new address__c();
            address2.Opportunity__c = o.id;
            address2.Street_Line_1__c = '1809 buena vista';
            address2.Street_Line_2__c = 'apt#1809';
            address2.City__c = 'sunnyvale';
            address2.State__c = 'CA';
            address2.Zip_Postal_Code__c = '94404';
            address2.Venue_Name__c = 'United Center';
            address2.Phone_Number__c = '987-654-3210';
            insert address2;
            
            multilist.add(multi);
            multilist2.add(multi2);
            OppList.add(o);
            oppList2.add(o2);
            OppMap.put(o.Id,o);
            OppMap2.put(o.Id,o);
            MultiMap .put(multi.Id,multi);
            MultiMap2.put(multi.Id,multi);
            AddressMap.put(address.Id,address);
            AddressMap2.put(address.Id,address);
            addresslist.add(address);
            addresslist2.add(address2);                        
            
            Test.stopTest();
        }
}
	
	static testMethod void testSetupXMLString()
	{
		Test.startTest();
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_setupXMLString(null, null, null, null));
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_setupXMLString('ut acct1', null, null, null));
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_setupXMLString('ut acct1', new Opportunity(), null, null));
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_setupXMLString('ut acct1', new Opportunity(), new User(), null));
		
		Account acc = TestUtil.createAccount('ut acct1');
		Opportunity oppty = TestUtil.createOpportunity(acc, 'ut oppty1', 'open', Date.Today(), false);
		oppty.Type = 'standard';
		User u = TestUtil.createUser('Standard User');
		String description = 'some description';
		
		String xmlString = zenDeskTicketSubmission.exposeForUT_setupXMLString(acc.Name, oppty, u, description);
		System.assertEquals(xmlString, '<ticket>\n<description>some description</description><subject>'+acc.Name+'-'+oppty.Type+'</subject><requester-email>'+u.email+'</requester-email><requester-name>'+u.name+'</requester-name>');
		Test.stopTest();
	}
	
	static testMethod void testGetDescription()
	{
		Account acc = TestUtil.createAccount('ut acc1');
		acc.Type  = 'standard';
		Account acc2 = TestUtil.createAccount('ut acc1');
		acc2.Type = 'standard';
		Test.startTest();
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_getDescription(null, null, null, null));
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_getDescription(acc, acc2, null, null));
		//will still return empty string because the field value hasn't changed;
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_getDescription(acc2, acc, 'Type','Type'));
		acc2.Type = 'Non-Standard';
		String description = zenDeskTicketSubmission.exposeForUT_getDescription(acc2, acc, 'Type','Type');
		System.assertEquals('Type changed from standard to Non-Standard\n', description);
		Test.stopTest();
	}
	
	static testMethod void testAddAdditionalTags()
	{
		System.assertEquals(null, zenDeskTicketSubmission.exposeForUT_addAdditionalTags(null));
		System.assertEquals('<additional-tags>tg</additional-tags>', zenDeskTicketSubmission.exposeForUT_addAdditionalTags('tg'));
	}
	
	static testMethod void testAddTicketFieldEntries()
	{
		System.assertEquals('', zenDeskTicketSubmission.exposeForUT_addTicketFieldEntries(null, true));
		
		Account acc = TestUtil.createAccount('ut acc1');
		Opportunity oppty = TestUtil.createOpportunity(acc, 'ut oppty 1', 'open', Date.Today(), true);
		oppty.Permalink__c = 'http://www.google.com';
		String tfeString = zenDeskTicketSubmission.exposeForUT_addTicketFieldEntries(oppty, true);
		System.assert(tfeString.contains(' <ticket-field-entries type="array"> <ticket-field-entry> <ticket-field-id>'+113268+'</ticket-field-id><value> '+'http://www.groupon.com/deals/' +oppty.Permalink__c+ '</value> </ticket-field-entry> '));
		System.assert(tfeString.contains(' <ticket-field-entry> <ticket-field-id>'+113212+'</ticket-field-id><value> '+ 'Copy' + '</value> </ticket-field-entry> '));
		System.assert(tfeString.contains(' <ticket-field-entry> <ticket-field-id>'+166523+'</ticket-field-id><value> '+ String.valueof('1989-01-01') + '</value> </ticket-field-entry>  </ticket-field-entries></ticket>'));
		
	}
	
	static testMethod void testFormatOpportunity()
	{
		Zendesk_User_Categories__c  zuc = Zendesk_User_Categories__c.getInstance();
		zuc.Name = 'test';
		insert zuc;
		Zendesk_Field_Mappings__c zfm = new Zendesk_Field_Mappings__c();
		zfm.Field_Label__c = 'Type';
		zfm.API_Name__c = 'Type';
		zfm.Opportunity__c = true;
		zfm.Name = '1';
		insert zfm;
		User u = [Select ID, Name, Email from User where ID =: UserInfo.getUserId()];
		//negative tests
		Account acct = TestUtil.createAccount('ut acc1');
		Opportunity opptyNew = TestUtil.createOpportunity(acct, 'ut acc1', 'open', Date.Today(), false);
		opptyNew.Permalink__c = 'http://www.google.com';
		opptyNew.Type = 'type1';
		Opportunity opptyOld = TestUtil.createOpportunity(acct, 'ut acc1', 'open', Date.Today(), false);
		opptyOld.Permalink__c = 'http://www.yahoo.com';
		opptyOld.Type = 'type1';
		
		String xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u );
		//since Type hasn't changed, the XML String would be null
		System.assertEquals(xmlString, null);
		
		
		//this time update a field other than type and verify the xmlString is still null
		opptyNew.Facebook_of_Fans__c = 10;
		opptyOld.Facebook_of_Fans__c = 20;
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assertEquals(xmlString, null);
		
		
		//this time update the type field (which is defined in custom settings) and verify the xmlString is not null
		opptyNew.Type = 'type2';
		opptyOld.Type = 'type1';
		
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assert(xmlString.contains('SFDC Opportunity ID: https://na8.salesforce.com/'+opptyNew.Id+'\n') );
		System.assert(xmlString.contains('<additional-tags>Automation</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>Opportunity</additional-tags>'));
		System.assert(xmlString.contains('Type changed from type1 to type2\n'));
		
		
		//test all additional tags
		//first test that the additional tags don't exist in teh xml string right now
		System.assert(!xmlString.contains('<additional-tags>ga</additional-tags>'));
		System.assert(!xmlString.contains('<additional-tags>rew</additional-tags>'));
		System.assert(!xmlString.contains('<additional-tags>f_p</additional-tags>'));
		System.assert(!xmlString.contains('<additional-tags>FD</additional-tags>'));
		
		//now update the opptys and verify the additional tags appear in the resulting string
		opptyNew.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GETAWAYS);
		opptyNew.Division__c = 'div1';
		opptyNew.Conditions__c = 'cond1';
		opptyNew.Feature_Date__c = Date.Today().addDays(2);
		opptyOld.conditions__c = 'cond2';
		opptyOld.Feature_Date__c = Date.Today().addDays(1);
		
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assert(xmlString.contains('<additional-tags>ga</additional-tags>'));
		System.assert(!xmlString.contains('<additional-tags>rew</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>f_p</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>div1</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>FD</additional-tags>'));
		
		//test the rewards deal as well
		opptyNew.RecordTypeId = OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS);
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assert(!xmlString.contains('<additional-tags>ga</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>rew</additional-tags>'));
		
		//now update the zuc custom settings and make the current user an account manager.
		zuc.Account_Manager__c = true; update zuc;
		zfm.Ignore_For_Account_Manager__c = true; update zfm;
		//change of the field now should yield a null xml String since the change would be ignored
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assertEquals(xmlString, null);
		
		//verify that if we ignore for feature dates as well, xml is still null
		zfm.Ignore_For_Feature_Dates_In_Future__c = true; update zfm;
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assertEquals(xmlString, null);
		
		//verify that if the current user is a City Planner, the xml is received
		zuc.City_Planner__c = true; zuc.Account_Manager__c = false; update zuc;
		xmlString = zenDeskTicketSubmission.exposeForUT_formatOpportunity(opptyNew, opptyOld, acct, u);
		System.assertNotEquals(xmlString, null);
		
	}
	
	static testMethod void testFormatMultiDeal()
	{
		Zendesk_User_Categories__c  zuc = Zendesk_User_Categories__c.getInstance();
		zuc.Name = 'test';
		insert zuc;
		Zendesk_Field_Mappings__c zfm = new Zendesk_Field_Mappings__c();
		zfm.Field_Label__c = 'Name';
		zfm.API_Name__c = 'Name';
		zfm.Multi_Deal__c = true;
		zfm.Name = '1';
		insert zfm;
		User u = [Select ID, Name, Email from User where ID =: UserInfo.getUserId()];
		//negative tests
		Account acct = TestUtil.createAccount('ut acc1');
		Opportunity oppty = TestUtil.createOpportunity(acct, 'ut acc1', 'open', Date.Today(), true);
		oppty.Account = acct;
		oppty.Permalink__c = 'http://www.google.com';
		Multi_Deal__c mdNew = TestUtil.createMD(oppty); mdNew.Name = 'name1';
		Multi_Deal__c mdOld = TestUtil.createMD(oppty); mdOld.Name = 'name1';
		
		String xmlString = zenDeskTicketSubmission.exposeForUT_formatMultiDeals(mdNew, mdOld, u, oppty );
		//since Type hasn't changed, the XML String would be null
		System.assertEquals(xmlString, null);
		
		
		//this time update a field other than name and verify the xmlString is still null
		mdNew.Average_Check__c = 10;
		mdOld.Average_Check__c = 20;
		xmlString = zenDeskTicketSubmission.exposeForUT_formatMultiDeals(mdNew, mdOld, u, oppty );
		System.assertEquals(xmlString, null);
		
		
		//this time update the name field (which is defined in custom settings) and verify the xmlString is not null
		mdNew.Name = 'name2';
		
		xmlString = zenDeskTicketSubmission.exposeForUT_formatMultiDeals(mdNew, mdOld, u, oppty );
		System.assert(xmlString.contains('<additional-tags>Automation</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>multi</additional-tags>'));
		System.assert(xmlString.contains('Name changed from name1 to name2\n'));
		
		
		//test all additional tags
		//first test that the additional tags don't exist in teh xml string right now
		System.assert(!xmlString.contains('<additional-tags>s_p</additional-tags>'));
		System.assert(!xmlString.contains('<additional-tags>b_p</additional-tags>'));
		System.assert(!xmlString.contains('<additional-tags>u_p</additional-tags>'));
		
		//now update the mds and verify the additional tags appear in the resulting string
		oppty.Division__c = 'div1';
		mdNew.Unit_Buy_Price__c = 20;
		mdNew.Unit_Sell_Price__c = 40;
		mdNew.Unit_Value__c = 10;
		mdOld.Unit_Buy_Price__c = 10;
		mdOld.Unit_Sell_Price__c = 20;
		mdOld.Unit_Value__c = 5;
		
		xmlString = zenDeskTicketSubmission.exposeForUT_formatMultiDeals(mdNew, mdOld, u, oppty );
		System.assert(xmlString.contains('<additional-tags>s_p</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>b_p</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>u_v</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>div1</additional-tags>'));
		
		//now update the zuc custom settings and make the current user an account manager.
		zuc.Account_Manager__c = true; update zuc;
		zfm.Ignore_For_Account_Manager__c = true; update zfm;
		//change of the field now should yield a null xml String since the change would be ignored
		xmlString = zenDeskTicketSubmission.exposeForUT_formatMultiDeals(mdNew, mdOld, u, oppty );
		System.assertEquals(xmlString, null);
		
	}
	
	static testMethod void testFormatAddresses()
	{
		Zendesk_User_Categories__c  zuc = Zendesk_User_Categories__c.getInstance();
		zuc.Name = 'test';
		insert zuc;
		Zendesk_Field_Mappings__c zfm = new Zendesk_Field_Mappings__c();
		zfm.Field_Label__c = 'City';
		zfm.API_Name__c = 'City__c';
		zfm.Address__c = true;
		zfm.Name = '1';
		insert zfm;
		User u = [Select ID, Name, Email from User where ID =: UserInfo.getUserId()];
		//negative tests
		Account acct = TestUtil.createAccount('ut acc1');
		Opportunity oppty = TestUtil.createOpportunity(acct, 'ut acc1', 'open', Date.Today(), true);
		oppty.Account = acct;
		oppty.Permalink__c = 'http://www.google.com';
		Address__c addNew = TestUtil.createAddress(acct.Id, oppty.Id, 'st', 'il', '60016', 'niles', 'usa');
		Address__c addOld = TestUtil.createAddress(acct.Id, oppty.Id, 'st', 'il', '60016', 'niles', 'usa');
		
		String xmlString = zenDeskTicketSubmission.exposeForUT_formatAddresses(addNew, addOld, u, oppty);
		//since City hasn't changed, the XML String would be null
		System.assertEquals(xmlString, null);
		
		//this time update a field other than name and verify the xmlString is still null
		
		addNew.Country__c = 'us';
		addOld.Country__c = 'usa';
		xmlString = zenDeskTicketSubmission.exposeForUT_formatAddresses(addNew, addOld, u, oppty);
		System.assertEquals(xmlString, null);
		
		
		//this time update the name field (which is defined in custom settings) and verify the xmlString is not null
		addOld.City__c = 'niles';
		addNew.City__c = 'lombard';
		
		xmlString = zenDeskTicketSubmission.exposeForUT_formatAddresses(addNew, addOld, u, oppty);
		System.assert(xmlString.contains('<additional-tags>Automation</additional-tags>'));
		System.assert(xmlString.contains('<additional-tags>redem</additional-tags>'));
		System.assert(xmlString.contains('City changed from niles to lombard\n'));
		
		
		//test all additional tags
		oppty.Division__c = 'div1';
		
		xmlString = xmlString = zenDeskTicketSubmission.exposeForUT_formatAddresses(addNew, addOld, u, oppty);
		System.assert(xmlString.contains('<additional-tags>div1</additional-tags>'));
		
		//now update the zuc custom settings and make the current user an account manager.
		zuc.Account_Manager__c = true; update zuc;
		zfm.Ignore_For_Feature_Dates_In_Future__c = true; 
		zfm.Ignore_For_Account_Manager__c = true; 
		oppty.Feature_Date__c = Date.Today().addDays(2);
		update zfm;
		//this should yield a null xml String
		xmlString = xmlString = zenDeskTicketSubmission.exposeForUT_formatAddresses(addNew, addOld, u, oppty);
		System.assertEquals(xmlString, null);
		
		
		
	}
}