/*
* ===================================================================
* RESTTestPaymentAPI.cls
* @author.....: Dharmesh Gohil 
* @email......: dgohil@groupon.com
* @date.......: 03/05/2013
* @Last Change: 
* Description.: A test class for RESTPaymentsAPI.cls
* @param......: 
* @return.....: 
* ===================================================================
*/

@isTest
public with sharing class TestRESTPaymentAPI {
    
    public static testMethod void PermalinkAPItest() 
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
                         Account a = new Account(name = 'test oppty');
                         insert a;

                    //testing negative case, permalink does not save due to missing param
                    test.StartTest();     
                    RestRequest req = new RestRequest(); 
                    RestResponse res = new RestResponse();
                    req.addParameter('salesforce_id', a.id);
                    RestContext.request = req;
                    Account failedOpp = RESTpaymentsAPI.addPaymentStatus();
                    system.assertEquals(failedOpp.Merchant_Permalink__c, null);
                    
                    //testing positive case, permalink saves
                    req.addParameter('merchant_key','sample-permalink');
                    RestContext.request = req;
                    RestContext.response = res;
                    Account updateAct = RESTpaymentsAPI.addPaymentStatus();
                    system.assertEquals(updateAct.Merchant_Permalink__c, 'sample-permalink');

                    //testing positive case, permalink saves
                    req.addParameter('payment_status','Contract Closed');
                    RestContext.request = req;
                    RestContext.response = res;
                    Account updatedAct1 = RESTpaymentsAPI.addPaymentStatus();
                    system.assertEquals(UpdatedAct1.Payments_Product_Sales_Status__c, 'Contract Closed');

                    Test.StopTest();

                    }
        }

}