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
private class testOpptyCloneChannelTravel {

     static testMethod void testRedirectTravel() {
        
        String rtTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Bars');
        Opportunity testOpp = TestUtil.createOppty(rtTestOn, 'Bars');
        Address__c a = new Address__c();
        a.Street_Line_1__c = 'line1';
        a.City__c = 'city';
        a.State__c = 'IL';
        a.Country__c = 'country';
        a.Zip_Postal_Code__c = '12345';
        a.Opportunity__c = testOpp.Id;
        insert a;
        
        grouponTestUtil gTestUtil = new grouponTestUtil();
        multi_deal__c md = gTestUtil.createOption();
        md.Opportunity__c = testOpp.Id;
        insert md;
        
        Question_Bank__c qb = new Question_Bank__c();
        insert qb;
        
        Question__c q = new Question__c();
        q.Opportunity__c = testOpp.Id;
        q.Question_Bank__c = qb.id;
        insert q;
        
        OpptyCloneChannelTravel ctrl = new OpptyCloneChannelTravel(new ApexPages.StandardController(testOpp));
        
        ctrl.cloneAndRedirectTravel();
    }
}