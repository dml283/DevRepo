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
private class testAutoAssignZip {

    static testMethod void myUnitTest() {
    	Division__c D = new Division__c(name='Test Division', State__c='IL');
    	insert D;
    	Subdivision__c S = new Subdivision__c(name='Test Subdiv');
    	insert S;
        Zip_Code__c Z = new Zip_Code__c(name='60642', Subdivision__c= S.id);
        insert Z;
        
        Purchase_Order__c P = new Purchase_Order__c (Category__c='Test', Division__c = D.id, Ideal_Zip_Code__c= '60642');
        insert P;
        
        //system.assert(P.Subdivision__c,S.id);
        
    }
}