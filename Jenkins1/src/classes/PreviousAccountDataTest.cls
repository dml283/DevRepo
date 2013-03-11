@isTest
private class PreviousAccountDataTest {
//Waiting to Delete
/*
    static testMethod void myPreviousAccountDataTest() {
        Profile p = [select id from profile where name='System Administrator'];
        
        User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='PreviousAccountDataTest@groupon.com');
        insert u;
        
        User u2 = new User(alias = 'standt2', email='standarduser2@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='PreviousAccountDataTest2@groupon.com');
        insert u2;
        
        System.RunAs(u) {
                    
            Division__c div = new Division__c(Name ='test',State__c ='IL');
            insert div;
                    
            account a = new account();
            a.Name = 'Test Account';
            a.OwnerId = u.Id;
            a.Division__c = div.Id;
            a.Result_of_Merchant_Survey__c = 'Prospecting';
            a.Account_Status__c = 'Contacted';
            insert a;
            
            a.OwnerId = u2.Id;
            a.Account_Status__c = 'Contract Sent';
            update a;
                
            Account a2 = [SELECT Id, Previous_Account_Owner__c, Previous_Acct_Status__c FROM Account WHERE Id =: a.Id];
                
            System.assertEquals(a2.Previous_Account_Owner__c,u.Id);
        }
    }
*/
}