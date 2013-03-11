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
 * Need to build an account, Now, Now Schedule and Redemption Address with necessary fields per validation rules.   
 * Then Change Now to Closed Won to activate trigger
 *
 */
@isTest
private class testSetNowDealClosedBy {
    static testMethod void mytestToUpdateClosedOwner() 
        {
            Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='SetNowDealCloseBy@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
                    {    
                         //Create Division
                         Division__c divs = new Division__c(Name ='test',State__c ='IL');
                         insert divs;
                         date mydate = date.parse('12/27/2009');
                         //Create Account with required Now Fields for Closed Won
                         account a = new account (name = 'SetNowDealCloseBy' + system.now(), division__c=divs.id,website='www.testaccount.com',now_deal_owner__c = u.id, Now_Category__c = 'Health & Fitness',Tax_Identification_Number__c = '123456789',Tax_Id__c = '123456789',Make_Checks_Payable_to__c = 'Test Owner', billingstreet = '123 bac street', billingcity = 'Springfield', billingstate = 'IL', billingpostalcode = '60605',billingcountry = 'usa' );
                         insert a;
                         //Create Now Deal with required Fields for Closed Won
                         GrouponNow__c g = new GrouponNow__c (deal_name__c = 'test deal', deal_strength__c = 'recommended', division__c = divs.id , now_Category__c = 'Health & Fitness', Now_Subcategory__c = 'Cosmetic Surgeons', Account_Name__c=a.Id, Limit_Per_Person__c= '1', Limit_number_of_Groupons_redeemable_at_a__c = 1, Per__c = 'table', Fine_Print__c = 'none', Buy_Price__c = 5,Sell_Price__c = 10,Unit_Value__c = 20);
                         insert g;
                         //Create Redemption Address so Now can be Closed won
                         Now_Redemption_Address__c r = new Now_Redemption_Address__c (groupon_now__c = g.id, Address_Line_1__c = '123 abc way', City__c = 'Springfield', State__c = 'IL', Zip_Code__c = '65654', Country__c = 'usa', Phone_Number__c= '4178389566');
                         insert r;
                         //Create Schedule so Now can be Closed won
                         Now_Schedule__c s = new Now_Schedule__c (groupon_now__c = g.id, Daily_Unit_Max_for_this_Schedule__c = 15);
                         insert s;
                         //Change Now to Closed Won to fire SetNowDealClosedBy trigger
                         g.stage__c = 'closed won';
                         update g; 
                    }
        }
}