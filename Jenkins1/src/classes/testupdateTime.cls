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
private class testupdateTime {

    static testMethod void myUnitTest() 
        {
                //build the user to test
                Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id, phone = '303-933-1414', 
                        timezonesidkey='America/Los_Angeles', username='testUpdateTime@groupon.com');
                        insert u;
        
                //run as user
                System.RunAs(u)
                    {                          
                       //Build the Division
                                Division__c divs = new Division__c(Name ='test',State__c ='IL');
                                insert divs;        
                        //Build the account (id, Now_Deal_Owner__c.id, Name, Owner.name, Closed_Now_Deals__c, Closed_Needs_Followup_Now_Deals__c,Now_Category__c)
                                Account a = new Account(name='testUpdateTime' + System.Now(), BillingCountry='MyCountry', eligibility__c='Eligible', division__c = divs.ID, Tax_Identification_Number__c ='12345', Now_Category__c='Test');
                                insert a;
                        //Build the GrouponNOW Deals
                                GrouponNow__c deal = new GrouponNow__c(Account_Name__c=a.id, Category__c='test', Deal_Owner__c=u.id, Now_Category__c = 'Test Cat', Now_Subcategory__c = 'test subcat');
                                insert deal;
                        //VisualForce Put Method        
                        ApexPages.currentPage().getParameters().put('id', a.Id);        
           
           //Build the Times
            Time__c t1 = new Time__c(Name = '10:00 AM', minutes__c = 600);
            Time__c t2 = new Time__c(Name = '10:30 AM', minutes__c = 630);
            insert t1;
            insert t2;
            
            //Build the NOW Schd
            NOW_Schedule__c sch = new NOW_Schedule__c(Start_Time__c ='10:00 AM', End_Time__c = '10:30 AM', Daily_Unit_Max_for_this_Schedule__c = 5, Groupon_Now__c=deal.id, Monday__c=true, Tuesday__c=true,Wednesday__c=true,Thursday__c=true,Friday__c=true,Saturday__c=true,Sunday__c=true);
            insert sch;
            update sch;
            }
            
                      
        }
}