@isTest
public class RESTtests{

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
                                              
                         account a =  new account();
                         a.name = 'testing account'; 
                         a.division__c=d.id; 
                         a.BillingStreet = '123456 test'; 
                         a.BillingCity = 'Chicago';
                         a.BillingState = 'IL';
                         a.BillingPostalCode = '60640';
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
                         o.user__c = NULL;
                         insert o;
                         
                    Multi_deal__c md = new Multi_deal__c();
                      md.opportunity__c = o.id;
                    insert md;
                         
                    address__c addy = new Address__c();
                        addy.opportunity__c = o.id;
                        addy.street_line_1__c = 'some street';
                        addy.city__c = 'city';
                        addy.state__c ='ST';
                    insert addy;    
                    test.StartTest();     
                    DealAPI deal_api = new DealAPI();
                    DealAPI.Deal deal = new DealAPI.Deal();
                    string sampleId = o.id;
                    string dealReply ='';
                    deal = deal_api.JSONResponse(sampleId);     
                    
                    RestRequest req = new RestRequest(); 
                    RestResponse res = new RestResponse();
                    req.addParameter('id',o.id);
                    DealAPI.Deal app_deal = RESTdealAPI.getDealJSON(req,res);
                    
                    RestRequest req1 = new RestRequest(); 
                    req.addParameter('id',md.id);
                    DealAPI.Option app_option = RESToptionAPI.getDealJSON(req1,res);
                                        
                    Test.StopTest();

                    }
        }
}