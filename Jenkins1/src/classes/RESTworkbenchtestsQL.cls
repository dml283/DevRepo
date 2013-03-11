@isTest
public class RESTworkbenchtestsQL{

static testMethod void QLAPITest() 
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
                         
                         task t = new Task();
                         t.whatId = a.id;
                         t.Subject = 'test';
                         t.activityDate = system.today().addDays(2);
                         insert t;
                         
                         task t2 = new Task();
                         t2.whatId = a.id;
                         t2.Subject = 'test';
                         t2.activityDate = system.today().addDays(-2);
                         insert t2;
                         
                         date mydate1 = date.parse('12/31/2012');
                         opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
                         o.division__c = d.name;
                         o.Division_Dynamic__c = d.id;
                         o.AccountId = a.id;
                         o.StageName = 'Closed Won'; 
                         o.CloseDate = mydate1;
                         o.feature_date__c = system.today().addDays(2);
                         o.feature_end_date__c =system.today().addDays(3);
                         o.Category__c = 'Health & Beauty';
                         o.city_manager__c = null;
                         o.divisional_sales_manager__c = NULL;
                         o.user__c = NULL;
                         o.unit_buy_price__c = 5;
                         o.TotalOpportunityQuantity =5;
                         o.unit_sell_price__c = 10;
                         o.feature_date__c = system.today();
                         o.ownerId = u1.id;
                         insert o;
                         
                         Quantum_Lead__c ql = new Quantum_Lead__c();
                             ql.sales_value__c = 44;
                             ql.account__c = a.id;
                             ql.Sales_Value_Demand__c =55;
                             ql.Sales_Value_Reasons__c ='asdgag|sdgag';
                             ql.Call_List_Priority__c ='4343';
                             ql.Parent_Id__c ='4t5433';
                         insert ql;
                         
                         Social_Living__c cf = new Social_Living__c();
                             cf.AccountName__c = a.id;
                             cf.name = string.valueOf(system.now());
                             cf.Deal_Link__c = 'www.google.com';
                             cf.Feature_Date__c = system.today();
                         insert cf;
                         
                         Merchant_Payment__c mp = new Merchant_payment__c();
                         mp.amount__c =500;
                         mp.currency__c ='USD';
                         mp.payment_method__c='Check';
                         mp.Payment_Date__c = system.today();
                         mp.Check_Number__c = '135513';
                         mp.ACH_Confirmation_Number__c ='2525252';
                         mp.account__c = a.id;
                         insert mp;
                         
                    information_request__c ir = new Information_request__c();
                        ir.opportunity__c = o.id;
                        ir.Issue_Resolved__c = false;
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
                    req.addParameter('id',a.id);
                    RestContext.request = req;
                    RestContext.response = res;
 
                    list<RESTmerchantDealsAPI.deal> restMerchantDeals = RESTmerchantDealsAPI.get(); 
                    list<RESTMerchantPaymentsAPI.merchant_payment> restPayments = RESTMerchantPaymentsAPI.get();  
                    list<RESTcompetitorFeaturesAPI.competitive_feature > restCompFeatures = RESTcompetitorFeaturesAPI.get();
                    list<RESTtasksAPI.merchant_task>  restMerchantTasks = RESTtasksAPI.getTasks();
                    list< RESTirAPI.ir> restIrs = RESTirAPI.getIR();
                    list<RESTmerchant_call_listAPI.call_priority> restCallPrioroty = RESTmerchant_call_listAPI.get();
                    Test.StopTest();

                    }
        }
}