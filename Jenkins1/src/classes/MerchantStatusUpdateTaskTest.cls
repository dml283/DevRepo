@isTest
private class MerchantStatusUpdateTaskTest {
    static testMethod void myMerchantStatusUpdateTaskTest() {
        Profile p = [select id from profile where name='System Administrator'];
                    User u = new User(alias = 'standt', email='standarduser@groupon.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p.Id,
                    timezonesidkey='America/Los_Angeles', username='MerchantStatusUpdateTaskTest@groupon.com');
                    insert u;
        //run as user
        System.RunAs(u) {
                    
            Division__c div = new Division__c(Name ='test',State__c ='IL');
            insert div;
                    
            account a = new account();
            a.Name = 'Test Account';
            a.Division__c = div.Id;
            a.Result_of_Merchant_Survey__c = 'Prospecting';
            a.Account_Status__c = 'Contacted';
            insert a;
            
            Task t = new Task();
            t.ActivityDate = System.Today();
            t.Merchant_Status__c = 'Prospecting';
            t.Merchant_Disposition__c = 'Do Not Run - Capacity';
            t.WhatId = a.Id;
            insert t;
            
            Task t2 = [SELECT Id, Merchant_Status__c, Merchant_Disposition__c FROM Task WHERE Id =: t.Id];
            
            System.assertEquals(t2.Merchant_Status__c,'Do Not Run - Capacity');
        }
    }
}