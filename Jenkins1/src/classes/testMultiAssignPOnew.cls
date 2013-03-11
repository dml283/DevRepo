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
private class testMultiAssignPOnew {

    static testMethod void myUnitTest() {
    
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id,
                 timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
        insert u;
        //run as user
        System.RunAs(u){
    
        User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='standarduser2@groupon.com');
        insert u1;
        
        Division__c D = new Division__c(name='Test Division', State__c='IL');
        insert D;
     
        Purchase_Order__c PO = new Purchase_Order__c (Category__c='Test', Division__c = D.id, Ideal_Zip_Code__c= '60642');
        insert PO;
            
        AssignedTo__c AsTo = new AssignedTo__c (Purchase_Order__c = PO.id, Assigned_To__c = u.id);
        insert AsTo;
        
        AssignedTo__c AsTo1 = new AssignedTo__c (Purchase_Order__c = PO.id, Assigned_To__c = u1.id);
        insert AsTo1;
        
        delete AsTo1;
        }
    }
}