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
private class testNOWCloseChatter {
    
    static testMethod void myChatterTest() {
        {
                list <Account> insertAcct = new list <Account>();
                list <Account> testNowAcct = new list <Account>();
                Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='NowCloseTest1@groupon.com');
                        insert u;
                        User u1 = new User(alias = 'standt1', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='NowCloseTest2@groupon.com');
                        insert u1;
        
                //run as user
                System.RunAs(u)
                    {    
                        //Build the Division
                                Division__c divs = new Division__c(Name ='test',State__c ='IL');
                                insert divs;
                                system.debug('---------Division---------' + divs.name); 
                                
                        //Build the ZipCode
                                Zip_Code__c zip = new Zip_Code__c(Name = '60656', NOW_Deal_Owner__c = u1.id, Valid_for_Now__c = true, Division__c =divs.id);        
                                insert zip;
                               system.debug('---------NOW DEAL OWNER IN ZIP CODE---------' + zip.NOW_Deal_Owner__c); 
                        
                        //build the Account(s)
                           
                                Account a = new Account(name='NOWcloseTest' + system.now(), BillingCountry='MyCountry',BillingPostalCode='60656', eligibility__c='Eligible', division__c = divs.ID, Tax_Identification_Number__c ='12345', Website='testsite.com', Make_Checks_Payable_to__c='Test Check Payto', Quality__c='Gold', Now_Category__c='Test');
                                insert a;
                                
                         //build the NOW Deal(s)      
                                GrouponNow__c gn = new GrouponNow__c(Account_Name__c=a.id, Buy_Price__c= 5, Sell_Price__c=10, Unit_Value__c =15,Category__c='test', subcategory__c='test', Deal_Name__c='NOW DEAL', Division__c=divs.id, Fine_Print__c='sometext',Limit_Per_Person__c='5', Limit_number_of_Groupons_redeemable_at_a__c=10,Per__c='number', Now_Category__c = 'Test Cat', Now_Subcategory__c = 'test subcat');
                                insert gn;
                         //build the NOW Sch(s)             
                                NOW_Schedule__c ns = new NOW_Schedule__c(Start_Time__c='9:30 AM', End_Time__c = '10:00 AM', Groupon_Now__c =gn.id, monday__c=true, tuesday__c=true);
                                insert ns;
                         //build the NOW Redemption(s)
                                Now_Redemption_Address__c rd = new Now_Redemption_Address__c (Groupon_Now__c = gn.id, Address_Line_1__c='line1',City__c='city',State__c='IL',Zip_Code__c='65656');
                                insert rd;
                                
                                gn.stage__c='Prospect';
                                update gn;
                               
                            //System.assertEquals(tempacct.Now_Deal_Owner__r.id, u1.id);
 }
 }
 }
 }