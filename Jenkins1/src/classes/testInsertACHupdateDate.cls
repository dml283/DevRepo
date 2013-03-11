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
private class testInsertACHupdateDate {
    static testMethod void mytestInsertACHupdateDate(){
            grouponTestUtil gTestUtil = new grouponTestUtil();
            User u = gTestUtil.createTestUser('System Administrator');
            u.username = 'InsertACHupdateDate@test.com';
            insert u;

            System.RunAs(u){    
                    //Division__c divs = new Division__c(Name ='test',State__c ='IL');
                    //insert divs;
                                                     
                    //date mydate = date.parse('12/27/2009');
                    Account Acct = gTestUtil.createAccount();
                    acct.BillingStreet = '123456 test';
                    acct.BillingCity = 'Chicago';
                    acct.BillingState = 'IL';
                    acct.BillingPostalCode = '60640';
                    acct.Account_Number__c = '123456789';
                    acct.Routing_Number_enc__c = '987654321';
                    acct.Payment_Preference__c = '';
                    //account a =  new account (name = 'testing account', division__c=divs.id, , );
                    insert acct;
                    acct.Account_number__c = '654258';
                    acct.BillingStreet = '600 West Chicago Ave';
                    acct.BillingCity = 'Las Vegas';
                    acct.BillingState = 'NV';
                    acct.BillingPostalCode = '90210';
                    acct.Routing_Number_enc__c = '789456';
                    acct.BillingCountry = 'US';
                    acct.Make_Checks_Payable_to__c = 'JJ';
                    acct.Payment_Preference__c = 'Check';
                    update acct; 
                }
        }
}