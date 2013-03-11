@isTest
private class SupportTaxonomyRecordsTest {
//Waiting to Delete
/*
    static testMethod void mySupportTaxonomyRecordsTest() {
        Profile p = [select id from profile where name='System Administrator'];
        
        User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='SupportTaxonomyRecordsTest@groupon.com');
        insert u;
                    
        System.RunAs(u) {
        
            stopInsertSupportTaxonomyRecords.stopFutureCallout = false;
                    
            Division__c div = new Division__c(Name ='test',State__c ='IL');
            insert div;
                    
            account a = new account();
            a.Name = 'Test Account';
            a.Division__c = div.Id;
            a.Category_v3__c = 'Leisure Offers / Activities';
            a.Subcategory_v3__c = 'Watersports';
            a.Services_Offered__c = 'Clam Digging';
            insert a;
            
            stopInsertSupportTaxonomyRecords.stopFutureCallout = false;
            
            a.Services_Offered__c = 'Kayak';
            update a;
        }
    }
*/
}