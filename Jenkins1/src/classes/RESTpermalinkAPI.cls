@RestResource(urlMapping='/v1.0/deal/permalink/*')

global class RESTpermalinkAPI{

@HttpPOST
global static opportunity addPermalink(){
     RestRequest req = RestContext.request;
     RestResponse res = new RestResponse();
     Opportunity o  = new opportunity();
     string theId;
     string permalink;
     if(req.params.containsKey('salesforce_id')&& req.params.containsKey('permalink')){
         theId = EncodingUtil.urlDecode(req.params.get('salesforce_id'),'UTF-8');
         permalink = EncodingUtil.urlDecode(req.params.get('permalink'),'UTF-8');
         o = [select id, permalink__c from Opportunity where ID = :theId];
         o.permalink__c = permalink;
         try{
             update o;
             }catch(exception e){
                 res.statusCode=500;
             }
         }else{
            res.statusCode=400;
         }
     RestContext.response = res;    
     return o;
    }

private static testMethod void PermalinkAPItest() 
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
                       
                         Division__c d = new Division__c();
                         d.Name ='Test';
                         d.State__c ='IL';
                         insert d; 
               
                       
                         date mydate1 = date.parse('12/31/2012');
                         opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
                         o.division__c = d.name;
                         o.Division_Dynamic__c = d.id;
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
                         insert o;

                    //testing negative case, permalink does not save due to missing param
                    test.StartTest();     
                    RestRequest req = new RestRequest(); 
                    RestResponse res = new RestResponse();
                    req.addParameter('salesforce_id', o.id);
                    RestContext.request = req;
                    Opportunity failedOpp = RESTpermalinkAPI.addPermalink();
                    system.assertEquals(failedOpp.permalink__c, null);
                    
                    //testing positive case, permalink saves
                    req.addParameter('permalink','sample-permalink');
                    RestContext.request = req;
                    RestContext.response = res;
                    Opportunity updatedOpp = RESTpermalinkAPI.addPermalink();
                    system.assertEquals(UpdatedOpp.permalink__c, 'sample-permalink');
                    Test.StopTest();

                    }
        }
}