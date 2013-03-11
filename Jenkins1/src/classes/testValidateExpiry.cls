@isTest
private class testValidateExpiry {
    static testMethod void mytestValidatePOexpiry() 
        {
            Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
                    {    
                         /*
                         Division__c divs = new Division__c(Name ='test',State__c ='IL');
                         insert divs;
                    
                         date mydate = date.parse('12/27/2009');
                         account a = new account (name = 'testing account', division__c=divs.id);
                         insert a;
                         
                         Opportunity o = new opportunity (name = 'test oppty', Deal_Strengh__c = 'Rep Getting Info', division__c = 'Hampton Roads', Category__c = 'Health & Beauty', Subcategory__c = 'Dental', closedate = mydate, AccountId=a.Id, StageName = 'Prospecting');
                         insert o;
                         */
                         Purchase_Order__c PO = new Purchase_Order__c(PO_Status__c = 'Approved');
                         insert PO;
                         system.debug('+++++++++++++++++++++++++++++++++++++++'+PO.id);
                         PO.PO_Status__c = 'Expired';
                         update po;
                         
 
                    }
        }
}