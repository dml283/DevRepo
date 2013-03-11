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
private class testCaseCountRollup {
    /*
    static testMethod void mytestCaseCountRollup() 
        {
            Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='caseCountTest@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
                    {     
                         list<case> caselist = new list<case>();                      
                         account a = new account();
                         a.name = 'caseCountRollup' + system.now();
                         insert a;                       
                         
                         opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.StageName = 'Prospecting';
                         o.CloseDate = date.today();
                         o.Deal_Strengh__c = 'Rep Getting Info';
                         o.Feature_Date__c = date.newinstance(2011, 7, 15);
                         o.AccountId = a.Id;
                         o.Division__c = 'Chicago';
                         o.CS_Email_Alert__c = '';
                         o.Permalink__c = 'Permalink';
                         insert o;                        
                         
                         //test case insert
                         case c1 = new case();
                         c1.Opportunity__c = o.Id;
                         c1.Origin = 'Web';
                         c1.Permalink__c = 'Permalink';
                         c1.Zendesk__Zendesk_Ticket_ID__c = 12345;
                         c1.Bucket__c = 'merchant';
                         c1.Reason_list__c = 'closing_bankrupt_merchant_cbm';
                         insert c1;
                         
                         //test case update
                         case cu = [SELECT Type FROM case WHERE Opportunity__c = :o.id];
                         cu.Type = 'Feature Request';
                         update cu;                                                                                                                      
 
                         //test 2nd case insert
                         case c2 = new case();
                         c2.Opportunity__c = o.Id;
                         c2.Origin = 'Web';
                         c2.Permalink__c = 'Permalink';
                         c2.Zendesk__Zendesk_Ticket_ID__c = 12345;
                         c2.Bucket__c = 'sales';
                         c2.Reason_list__c = 'closing_bankrupt_merchant_cbm';
                         caselist.add(c2);
                         
                         //test 3rd case insert
                         case c3 = new case();
                         c3.Opportunity__c = o.Id;
                         c3.Origin = 'Web';
                         c3.Permalink__c = 'Permalink';
                         c3.Zendesk__Zendesk_Ticket_ID__c = 12345;
                         c3.Bucket__c = 'sales';
                         c3.Reason_list__c = 'closing_bankrupt_merchant_cbm';
                         caselist.add(c3); 
                         
                         //test 4th case insert
                         case c4 = new case();
                         c4.Opportunity__c = o.Id;
                         c4.Origin = 'Web';
                         c4.Permalink__c = 'Permalink';
                         c4.Zendesk__Zendesk_Ticket_ID__c = 12345;
                         c4.Bucket__c = 'sales';
                         c4.Reason_list__c = 'closing_bankrupt_merchant_cbm';
                         caselist.add(c4); 
                         
                         //test 5th case insert
                         case c5 = new case();
                         c5.Opportunity__c = o.Id;
                         c5.Origin = 'Web';
                         c5.Permalink__c = 'Permalink';
                         c5.Zendesk__Zendesk_Ticket_ID__c = 12345;
                         c5.Bucket__c = 'merchant';
                         c5.Reason_list__c = 'closing_bankrupt_merchant_cbm';
                         caselist.add(c5);                                                                
                         
                         insert caselist;

                    }
        }
        */
}