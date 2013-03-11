@isTest
private class ValidateTaxIdTest {
//Waiting to Delete
/*
    static testMethod void mytestToUpdateOwnerName() {
        Profile p = [select id from profile where name='System Administrator'];
                    User u = new User(alias = 'standt', email='standarduser@groupon.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p.Id,
                    timezonesidkey='America/Los_Angeles', username='ValidateTaxIdTest@groupon.com');
                    insert u;
        //run as user
        System.RunAs(u) {
            Set<Id> accountsToUpdate = new Set<Id>();
            
            Division__c div = new Division__c(Name ='test',State__c ='IL');
            insert div;
                    
            account a = new account();
            a.Name = 'Test Account';
            a.Division__c = div.Id;            
            a.Company_Legal_Name__c = 'Test Legal Name';
            a.Tax_ID__c = '1234';
            insert a;
            
            a.Tax_ID__c = '123456789';
            update a;
            
            accountsToUpdate.add(a.Id);
            
            ValidateTaxId.validateAcct(accountsToUpdate);
            //ValidateTaxId vt = new ValidateTaxId(a.Tax_ID__c,a.Company_Legal_Name__c);
            //vt.returnStatus();
            
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        }
    }
*/
}