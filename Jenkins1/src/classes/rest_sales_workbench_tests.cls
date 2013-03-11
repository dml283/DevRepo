@isTest
public class rest_sales_workbench_tests{

static testMethod void workbenchTest() 
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
                         a.Account_Manager__c = u2.id;
                         a.division__c=d.id; 
                         a.BillingStreet = '123456 test'; 
                         a.BillingCity = 'Chicago';
                         a.BillingState = 'IL';
                         a.BillingPostalCode = '60640';
                         a.research_ranking__c = '5';
                         a.Groupon_Scheduler_Strength__c='Deactivated';
                         a.Rewards_Offer_Status__c='Live';
                         a.Now_Category__c ='Stupid Now! Category';
                         a.Sales_Value__c = 20342;
                         insert a;
                         
                         contact c = new contact();
                         c.accountid = a.id;
                         c.lastName = 'Bob';
                         c.firstName ='smith';
                         insert c;
                         
                         lead l = new lead();
                         l.lastName ='Salesforce test'+system.now();
                         l.company = 'Salesforce test'+system.now();
                         insert l;
                       
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
                         o.Deal_Bank_Eligible__c='Opt-Out';
                         insert o;
                         
                         opportunity o1 = new opportunity();
                         o1.name = 'test oppty';
                         o1.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
                         o1.division__c = d.name;
                         o1.Division_Dynamic__c = d.id;
                         o1.AccountId = a.id;
                         o1.StageName = 'Closed Won'; 
                         o1.CloseDate = mydate1;
                         o1.feature_date__c = system.today().addDays(2);
                         o1.feature_end_date__c =system.today().addDays(4);
                         o1.Category__c = 'Health & Beauty';
                         o1.city_manager__c = null;
                         o1.divisional_sales_manager__c = NULL;
                         o1.user__c = NULL;
                         o1.unit_buy_price__c = 5;
                         o1.TotalOpportunityQuantity =5;
                         o1.unit_sell_price__c = 10;
                         o1.deal_strengh__c = 'A Sure Thing';
                         insert o1;
                         
                         
                         opportunity o2 = new opportunity();
                         o2.name = 'test oppty';
                         o2.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
                         o2.division__c = d.name;
                         o2.Division_Dynamic__c = d.id;
                         o2.AccountId = a.id;
                         o2.StageName = 'Closed Won'; 
                         o2.CloseDate = system.today().addDays(-32);
                         o2.feature_date__c = system.today().addDays(-1);
                         o2.feature_end_date__c =system.today().addDays(3);
                         o2.Category__c = 'Health & Beauty';
                         o2.city_manager__c = null;
                         o2.divisional_sales_manager__c = NULL;
                         o2.user__c = NULL;
                         o2.unit_buy_price__c =15;
                         o2.TotalOpportunityQuantity =5;
                         o2.unit_sell_price__c = 10;
                         o2.deal_strengh__c = 'CP Needs Info';
                         insert o2;
                         
                         opportunity o3 = new opportunity();
                         o3.name = 'test oppty'+system.now();
                         o3.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Rewards'].id;
                         o3.division__c = d.name;
                         o3.Division_Dynamic__c = d.id;
                         o3.AccountId = a.id;
                         o3.StageName = 'Closed Won'; 
                         o3.CloseDate = system.today().addDays(-32);
                         o3.feature_date__c = system.today().addDays(-22);
                         o3.feature_end_date__c =system.today().addDays(-24);
                         o3.Category__c = 'Health & Beauty';
                         o3.city_manager__c = null;
                         o3.divisional_sales_manager__c = NULL;
                         o3.user__c = NULL;
                         o3.unit_buy_price__c =15;
                         o3.TotalOpportunityQuantity =5;
                         o3.unit_sell_price__c = 10;
                         o3.deal_strengh__c = 'A Sure Thing';
                         insert o3;
                         
                         
                    information_request__c ir = new Information_request__c();
                    ir.opportunity__c = o1.id;
                    insert ir;
                         
                    social_living__c comp_feat = new social_living__c();
                    comp_feat.AccountName__c = a.id;
                    comp_feat.Deal_Link__c = 'www.sample_deal.com';
                    comp_feat.division__c = d.id;
                    comp_feat.Feature_Date__c = system.today();
                    insert comp_feat;
                    
                    Multi_deal__c md = new Multi_deal__c();
                      md.opportunity__c = o.id;
                    insert md;
                    
                    Merchant_Payment__c mp = new Merchant_Payment__c();
                        mp.amount__c = 5;
                        mp.currency__c ='USD';
                        mp.account__c = a.id;
                    insert mp;
                         
                    address__c addy = new Address__c();
                        addy.opportunity__c = o.id;
                        addy.street_line_1__c = 'some street';
                        addy.city__c = 'city';
                        addy.state__c ='ST';
                    insert addy;
                    
                    Merchant_Addresses__c addy1 = new Merchant_Addresses__c();
                        addy1.account__c = a.id;
                        addy1.street_line_1__c = 'some street';
                        addy1.city__c = 'city';
                        addy1.State_Province__c ='ST';
                        addy1.Latitude__c=134.34242;
                    insert addy1;       
                    
                    GrouponNow__c gnow = new GrouponNow__c();
                        gnow.Stage__c ='Stage';
                        gnow.account_name__c = a.id;
                        gnow.close_date__c = system.today();
                    insert gnow;
                    
                    GrouponNow__c gnow1 = new GrouponNow__c();
                        gnow1.Stage__c ='In Negotiations';
                        gnow1.Buy_Price__c =5;
                        gnow1.Sell_Price__c=10;
                        gnow1.account_name__c = a.id;
                        gnow1.close_date__c = system.today();
                        gnow1.Deal_Name__c ='Deal Name';
                        gnow1.Division__c=d.id;
                        gnow1.Fine_Print__c='Fine Print';
                        gnow1.Limit_Per_Person__c='1';
                        gnow1.Limit_number_of_Groupons_redeemable_at_a__c=2;
                        gnow1.Per__c='2';
                        gnow1.Now_Category__c='Cat';
                        gnow1.Now_Subcategory__c ='Subcat';
                    insert gnow1;
                    
                    Task ta = new Task();
                        ta.whatid = o.id;
                        ta.subject = 'Prep: Feature Date Communicated';
                        ta.ownerid = u2.id;
                   insert ta;     
                   
                   Financial_Records__c fr = new Financial_Records__c();
                       fr.Collection_Date__c = system.today();
                       fr.opportunity__c = o.id;
                       fr.Units_Refunded__c=5l;
                       fr.Revenue_Amount__c=500;
                   insert fr;
                   
                    
                    task test_task = new task();
                    test_task.whatid = a.id;
                    insert test_task;
                    
                    
                    test.StartTest();     
                      List <REST_merchant_API_2.merchant> merchants = REST_merchant_API_2.get();
                      RESTleaderboard_salesAPI.leaderboard leaderboard = RESTleaderboard_salesAPI.get();
                      List <RESTdaily_transactionsAPI.daily_transactions> daily_trans = RESTdaily_transactionsAPI.getFinancials();
                      list<RESTmerchant_call_listAPI.call_priority> call_list = RESTmerchant_call_listAPI.get();
                    Test.StopTest();

                    }
        }
}