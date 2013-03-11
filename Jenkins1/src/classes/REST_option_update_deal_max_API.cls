@RestResource(urlMapping='/v1.0/deal/option/max_pledges')

global class REST_option_update_deal_max_API{

@HttpPOST
global static max_pledge post(max_pledge option){
     RestRequest req = RestContext.request;
     RestResponse res = RestContext.response;
     
     system.debug('=======rest response'+res);
     
     system.debug('=====option in the request'+option);
     option.update_option_cap(option.get_sobj());
     system.debug('=====option in the request'+option);
     
     system.debug('=======rest response'+res);
     try{
         if(option.success){
             res.statusCode = 200;
         }else{
             res.statusCode = 400;
         }
       }catch(exception e){
           system.debug('=========exception e'+e);
       }  
     return option;
}

global class max_pledge{
    public string id {get;set;}
    public decimal max_pledges {get;set;}
    public boolean success {get;set;}
    
    public void check_if_option_success(){
       multi_deal__c md_update = this.get_sobj();
       if(md_update!=null && md_update.Total_Deal_Max__c == this.max_pledges){
           this.success = true;
       }else{
           this.success = false;
       }
    }

    public void update_option_cap(multi_deal__c md){
        try{
            md.Total_Deal_Max__c = this.max_pledges;
            database.update(md);
        }catch(exception e){
            this.success=false;
        }
      this.check_if_option_success();
    }

    public multi_deal__c get_sobj(){
        multi_deal__c md;
        try{
            md = [select id, Total_Deal_Max__c FROM Multi_deal__c where id = :this.id];
            }catch(exception e){
                this.success=false;
            }
       return md;
    }
}
private static testMethod void testPost() {
        
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
                         a.name = 'testing account'+system.now(); 
                         a.division__c=d.id; 
                         a.BillingStreet = '123456 test'; 
                         a.BillingCity = 'Chicago';
                         a.BillingState = 'IL';
                         a.BillingPostalCode = '60640';
                         insert a;
                       
                         date mydate1 = date.parse('12/31/2012');
                         opportunity o = new opportunity();
                         o.name = 'test opptyt'+system.now(); 
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
                         
                    max_pledge  option = new max_pledge();
                    option.id = md.id;
                    option.max_pledges = 5;
                    option.success=false;
                    test.StartTest();     

                    system.debug('looking at the request========'+option);
                    max_pledge result = REST_option_update_deal_max_API.post(option);

                    multi_deal__c md_assert = [select id, Total_Deal_Max__c FROM Multi_deal__c where id = :option.id];
                    system.assertEquals(md_assert.Total_Deal_Max__c, 5);
                    
                    Test.StopTest();

                    }
        }
}