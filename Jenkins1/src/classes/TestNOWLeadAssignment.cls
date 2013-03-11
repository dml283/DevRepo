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
private class TestNOWLeadAssignment {
    static testMethod void myNOWLeadTest() {
        {
                list <lead> insertLeads = new list <lead>();
                list <lead> testNowLeads = new list <lead>();
                Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
                        insert u;
        
                //run as user
                System.RunAs(u)
                    {   
                        //Build the Division
                                Division__c divs = new Division__c(Name ='test',State__c ='IL');
                                insert divs;
                                system.debug('---------Division---------' + divs.name); 
                                
                        //Build the ZipCode
                                Zip_Code__c zip = new Zip_Code__c(Name = '60656', NOW_Deal_Owner__c = u.id, Valid_for_Now__c = true, Division__c =divs.id);        
                                insert zip;
                               system.debug('---------NOW DEAL OWNER IN ZIP CODE---------' + zip.NOW_Deal_Owner__c); 
                        
                          
                        //build the lead(s)
                           
                            lead l2 = new lead(company = 'test company', category__c = 'Health & Beauty',subcategory__c = 'Facial',LeadSource = 'Warm Lead',division__c ='test',lastname='LastName',Dynamic_Division__c=divs.id, PostalCode='60656' );
                                insert l2;
                                system.debug('---------INSERTING LEAD---------' +l2.name);
                                try{
                                update l2;
                                }catch(Exception f)
                                    {System.debug(f);}
                                system.debug('---------UPDATE LEAD---------'+l2.name);  
                            system.debug('---------NOW DEAL OWNER---------' + l2.NOW_Deal_Vetter__c);
                               
                                
                              
                            list<lead> temp = new list<lead>();
                            lead templead;
                            temp = [select id, NOW_Deal_Vetter__c from lead where owner.id = :u.id];
                            for(lead t : temp){
                            templead = t;
                            }
                                
                            system.debug('NOW DEAL OWNER---------  ' + l2.NOW_Deal_Vetter__c);
                            system.debug('NOW POSTAL CODE---------  ' + l2.PostalCode);
                            //System.assertEquals(templead.NOW_Deal_Vetter__c, u.id);
 }
 }
 }
 }