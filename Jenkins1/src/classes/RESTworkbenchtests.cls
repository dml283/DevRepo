@isTest
public class RESTworkbenchtests{

static testMethod void workbenchAPITest() 
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
                        
                        Sales_Goal__c goal = new Sales_Goal__c();
                        goal.Goal_Start_Date__c = system.today().addDays(-1);
                        goal.goal_end_date__c = system.today().addDays(1);
                        goal.GP_Goal__c = 500;
                        goal.Contract_Goal__c=5;
                        goal.division__c = d.id;
                        insert goal;            
                       
                         account a =  new account();
                         a.name = 'testing account'; 
                         a.division__c=d.id; 
                         a.BillingStreet = '123456 test'; 
                         a.BillingCity = 'Chicago';
                         a.BillingState = 'IL';
                         a.BillingPostalCode = '60640';
                         a.research_ranking__c = '5';
                         a.Sales_Value__c =55;
                         insert a;
                       
                         date mydate1 = date.parse('12/31/2012');
                         opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
                         o.division__c = d.name;
                         o.Division_Dynamic__c = d.id;
                         o.AccountId = a.id;
                         o.StageName = 'Prospecting'; 
                         o.CloseDate = mydate1;
                         o.feature_date__c = system.today();
                         o.feature_end_date__c =system.today().addDays(1);
                         o.Category__c = 'Health & Beauty';
                         o.city_manager__c = null;
                         o.divisional_sales_manager__c = NULL;
                         o.user__c = NULL;
                         o.unit_buy_price__c = 5;
                         o.TotalOpportunityQuantity =5;
                         o.unit_sell_price__c = 10;
                         o.feature_date__c = system.today();
                         insert o;
                         
                         
                    information_request__c ir = new Information_request__c();
                    ir.opportunity__c = o.id;
                    insert ir;
                         
                    Multi_deal__c md = new Multi_deal__c();
                      md.opportunity__c = o.id;
                    insert md;
                         
                    address__c addy = new Address__c();
                        addy.opportunity__c = o.id;
                        addy.street_line_1__c = 'some street';
                        addy.city__c = 'city';
                        addy.state__c ='ST';
                    insert addy;    
                    
                    task test_task = new task();
                    test_task.whatid = a.id;
                    insert test_task;
                    
                   test.StartTest();     
                    
                    RestRequest req = new RestRequest(); 
                    RestResponse res = new RestResponse();
                    req.addParameter('salesforce_id', a.id);
                    RestContext.request = req;
                    RestContext.response = res;
                    
                    list<calendar.cal> myCal = RESTCalendarAPI.getCalendar();
                    
                    calendar.status my_cal_status = RESTcalendarStatusAPI.getMyDealStatus();
                    //RESTstatAPI.stat mystats = RESTstatAPI.getStats();
                    list<RESTirAPI.ir> irs = RESTirAPI.getIR();
                    list<MerchantAPI.merchant> merchants = RESTmerchantAPI.getMyMerchants();
                    list<contact> my_contacts = RESTcontactAPI.getMyContacts();
                    RESTcontractAPI.contract_list contracts = RESTcontractAPI.getMyContrats();
                    RESTmerchantStatAPI.merchant_stat stat = RESTmerchantStatAPI.merchant_stats();
                    Test.StopTest();

                    }
        }
}