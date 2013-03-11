@isTest
public class REST_deal_wizard_tests{

static testMethod void APITest() 
        {
            
            Profile p = [select id from profile where name='System Administrator'];
                        User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
                        insert u1;
                //run as user
                System.RunAs(u1)
                {
                        User u2 = new User(alias = 'user2', email='standarduser2@groupon.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id,
                                 timezonesidkey='America/Los_Angeles', username='standarduser2@groupon.com');
                        insert u2;
                        
                        User u3 = new User(alias = 'user3', email='standarduser3@groupon.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id,
                                 timezonesidkey='America/Los_Angeles', username='standarduser3@groupon.com');
                        insert u3;
                        
                        User u4 = new User(alias = 'user4', email='standarduser4@groupon.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id,
                                 timezonesidkey='America/Los_Angeles', username='standarduser4@groupon.com');
                        insert u4;
                        
                         Division__c d = new Division__c();
                         d.Name ='Test';
                         d.State__c ='IL';
                         d.City_CEO__c = u2.id; 
                         d.dsm__c = u3.id;
                         d.market_planner__c = u4.id;
                         insert d; 
                                              
                         account a = DealWizardTestHelper.buildAccount();
                         a.name         = 'testing account' + system.now(); 
                         a.division__c  = d.id; 
                         insert a;
                       
                         date mydate1 = date.parse('12/31/2012');
                         opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
                         o.division__c = 'Test';
                         o.Division_Dynamic__c = d.id;
                         o.AccountId = a.id;
                         o.StageName = 'Prospecting'; 
                         o.CloseDate = mydate1;
                         o.Category__c = 'Health & Beauty';
                         o.city_manager__c = null;
                         o.divisional_sales_manager__c = NULL;
                         o.payment_terms__c = '1/3 / 30 days';
                         o.user__c = NULL;
                         insert o;
                    
                    contact acct_contact = new contact();
                        acct_contact.accountid = a.id;
                        acct_contact.lastName ='Last Name';
                        //acct_contact.name = 'My contat Name';
                    insert acct_contact;
                    
                    test.StartTest();     
                    
                    DealWizardMerchantContact merch_contact = new DealWizardMerchantContact(acct_contact);
                    
                    OpportunityContactRole contact_role = new OpportunityContactRole();
                           contact_role.contactID = acct_contact.id;
                           contact_role.isPrimary = true;
                           contact_role.role = 'role';
                           contact_role.OpportunityId = o.id;
                    insert contact_role;
                    
                    DealWizardDealContact con = new DealWizardDealContact(contact_role);
                    
                         
                    Multi_deal__c md = new Multi_deal__c();
                      md.opportunity__c = o.id;
                    insert md;
                    
                    DealWizardDealOption option = new DealWizardDealOption(md);
                    option.get_sobject(o.id);
                    
                    package_component__c pc = new package_component__c();
                    pc.multi_deal__c = md.id;
                    pc.value__c = 5;
                    insert pc;
                    
                    DealWizardPackageComponent pgk = new DealWizardPackageComponent(pc);
                    package_component__c pck1 = pgk.build_sobject();
                    
                    DealWizardPaymentTerms pay_temrs = new DealWizardPaymentTerms(o);
                    
                    Question_DW__c quest = new Question_DW__c();
                    quest.opportunity__c = o.id;
                    quest.questions__c ='some question';
                    quest.answer__c = 'my answer';
                    insert quest;
                    
                    DealWizardQuestion quest_dw = new DealWizardQuestion(quest);
                    quest = quest_dw.get_sobject();
                    
                    Merchant_Addresses__c parent = new Merchant_Addresses__c();
                    parent.Street_Line_1__c = 'street 1';
                    parent.Street_Line_2__c = 'street 2';
                    parent.Account__c = a.id;
                    insert parent;
                         
                    address__c addy = new Address__c();
                        addy.opportunity__c = o.id;
                        addy.street_line_1__c = 'some street';
                        addy.city__c = 'city';
                        addy.state__c ='ST';
                    insert addy;    
                    
                    DealWizardMerchant merch = new DealWizardMerchant();
                        merch.id = a.id;
                        merch.load();
                    string query_string_merch = merch.get_query();
                    
                        
                    DealWizardRedemptionLocation dw_location = new DealWizardRedemptionLocation(addy);
                    dw_location.get_sobject(o.id, parent.id);
                    
                    
                    DealWizardDeal deal = new DealWizardDeal();
                    deal.id = o.id;
                    //deal.payment_terms = new DealWizardPaymentTerms(o);
                    deal.redemption_locations = new list< DealWizardRedemptionLocation >();
                    deal.do_upsert();
                    deal.load();                   
                    
                    deal.delete_persisted_options_not_present_in_request();
                    Test.StopTest();

                    }
        }
}