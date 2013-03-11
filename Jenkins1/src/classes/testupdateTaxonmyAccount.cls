@isTest
private class testupdateTaxonmyAccount {
//Waiting to Delete
/*
    static testMethod void mytestupdateTaxonmyAccount() {
        Profile p = [select id from profile where name='System Administrator'];
                     User u = new User(alias = 'standt', email='standarduser@groupon.com',
                     emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                     localesidkey='en_US', profileid = p.Id,
                     timezonesidkey='America/Los_Angeles', username='testupdateTaxonmyAccount@groupon.com');
                     insert u;
        //run as user
        System.RunAs(u) {
        
            TaxonmyMap__c t = new TaxonmyMap__c();
            t.Object__c = 'Lead/Account';
            t.Category_v3__c = 'Beauty / Wellness / Healthcare';
            t.Subcategory_v3__c = 'Office - Dental';
            t.newCategory__c = 'Beauty';
            t.newSubcategory__c = 'Dental Care';
            insert t;
            
            TaxonmyMap__c t1 = new TaxonmyMap__c();
            t1.Object__c = 'Lead/Account';
            t1.Category_v3__c = 'Food & Drink';
            t1.Subcategory_v3__c = 'Restaurant';
            t1.newCategory__c = 'Restaurant';
            t1.newSubcategory__c = 'Restaurant';
            insert t1;

            account a =  new account();
            a.name = 'Test Acct';
            a.OwnerId = u.id;
            a.Category_v3__c = 'Food & Drink';
            a.Subcategory_v3__c = 'Restaurant';
            insert a;
            
            a.Category_v3__c = 'Beauty / Wellness / Healthcare';
            a.Subcategory_v3__c = 'Office - Dental';
            update a;
                                 
            Account a1 = [SELECT Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Category_v3__c, Subcategory_v3__c FROM Account WHERE Id = :a.Id];
            
            system.debug('Global SFDC Category: ' + a1.Global_SFDC_Category__c);
            system.debug('Global SFDC Subcategory 1: ' + a1.Global_SFDC_Subcategory_1__c);
        }
    }
*/
}