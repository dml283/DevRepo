/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testAcctOwnerUpdate {
    static testMethod void mytestToUpdateOwnerName() 
        {
            Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='testAcctOwnerUpdate@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
                    {    
                         Division__c divs = new Division__c(Name ='test',State__c ='IL');
                         insert divs;
                    
                         date mydate = date.parse('12/27/2009');
                         account a = new account (name = 'testing account', division__c=divs.id);
                         insert a;
                         Opportunity o = new opportunity (name = 'test oppty', Deal_Strengh__c = 'Rep Getting Info', division__c = 'Hampton Roads', Category__c = 'Health & Beauty', Subcategory__c = 'Dental', closedate = mydate, AccountId=a.Id, StageName = 'Prospecting');
                         insert o;
                         o.type = 'feature';
                         update o; 
                    }
        }
}