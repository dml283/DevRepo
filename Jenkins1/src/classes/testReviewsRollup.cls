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
private class testReviewsRollup {
        static testMethod void mytestReviewsRollup() {
        Test.StartTest();
            Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='testReviewsRollup@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
             {             
             
             account a = new account();
             a.name = 'Test Reviews Acct';
             insert a;
             
             merchant_addresses__c m = new merchant_addresses__c();     
             m.street_line_1__c = '600 W. Chicago';
             m.Street_Line_2__c = '';
             m.City__c = '';
             m.State_Province__c = '';
             m.Zip_Postal_Code__c = '';
             m.Phone_Number__c = '';
             m.account__c = a.id;
             insert m;
             
             reviews__c r = new reviews__c();             
             r.account__c = a.id;                   
             r.Merchant_Address__c = m.id;
             r.Description__c = 'Test Description';
             r.Max_Possible_Rating__c = 10;
             r.Number_of_Ratings__c = 100;                                      
             r.Rating__c = 9;
             r.Source__c = 'Google';
             r.Type__c = 'Rating';
             r.Unit__c = 'Stars';
             r.Review_Link__c = 'www.google.com';
             r.of_1_star_Reviews__c = 1;
             r.of_2_star_Reviews__c = 2;
             r.of_3_star_Reviews__c = 3;
             r.of_4_star_Reviews__c = 4;
             r.of_5_star_Reviews__c = 5;
             r.of_Complaints__c = 0;
             r.BBB_Accredited__c = 'Yes';
             r.BBB_Grade__c = 'A';
             r.Quote__c = 'Quote';
             r.Quote_Attribution__c = 'Quote Attribution';
             r.Mixed_Lede__c = 'Test';
             insert r; 
             
             reviews__c r2 = new reviews__c();             
             r2.account__c = a.id;                   
             r2.Description__c = 'Test Description';
             r2.Max_Possible_Rating__c = 10;
             r2.Number_of_Ratings__c = 100;                                      
             r2.Rating__c = 9;
             r2.Source__c = 'Google';
             r2.Type__c = 'Rating';
             r2.Unit__c = 'Stars';
             r2.Review_Link__c = 'www.google.com';
             r2.of_1_star_Reviews__c = 1;
             r2.of_2_star_Reviews__c = 2;
             r2.of_3_star_Reviews__c = 3;
             r2.of_4_star_Reviews__c = 4;
             r2.of_5_star_Reviews__c = 5;
             r2.of_Complaints__c = 0;
             r2.BBB_Accredited__c = 'Yes';
             r2.BBB_Grade__c = 'A';
             r2.Quote__c = 'Quote';
             r2.Quote_Attribution__c = 'Quote Attribution';
             r2.Mixed_Lede__c = 'Test1';         
             insert r2;
             
        Test.stopTest();
            }
        }
}