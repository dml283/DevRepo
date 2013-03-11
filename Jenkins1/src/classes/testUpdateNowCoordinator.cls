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
 * TESTING Set Now Deal Closed By TRIGGER
 *
 *
 * Need to build an account and a Now record.   
 * Then clear the Now Coordinator Test field on the Now to activate trigger
 *
 */
@isTest
private class testUpdateNowCoordinator {
    static testMethod void mytestToSetCoord() 
        {
            Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='nowCoordTest@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
                    {    
                         //Create Division
                         Division__c divs = new Division__c(Name ='test',State__c ='IL', now_coordinator__c = u.id);
                         insert divs;
                         date mydate = date.parse('12/27/2009');
                         //Create Account 
                         account a = new account (name = 'UpdNowCoord' + system.now(), division__c=divs.id,website='www.testaccount.com',now_deal_owner__c = u.id, Now_Category__c = 'Health & Fitness',Tax_Identification_Number__c = '123456789',Make_Checks_Payable_to__c = 'Test Owner', billingstreet = '123 bac street', billingcity = 'Springfield', billingstate = 'IL', billingpostalcode = '60605',billingcountry = 'usa' );
                         insert a;
                         //Create Now Deal 
                         GrouponNow__c g = new GrouponNow__c (deal_name__c = 'test deal', division__c = divs.id , now_Category__c = 'Health & Fitness', Now_Subcategory__c = 'Cosmetic Surgeons', Account_Name__c=a.Id, Limit_Per_Person__c= '1', Limit_number_of_Groupons_redeemable_at_a__c = 1, Per__c = 'table', Fine_Print__c = 'none', Buy_Price__c = 5,Sell_Price__c = 10,Unit_Value__c = 20);
                         insert g;
                         //Clear Now Coordinator to fire UpdateNowCoordinator trigger
                         g.real_now_coordinator__c = null;
                         update g; 
                    }
        }
}