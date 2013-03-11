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
private class AddressControllerTest {

    static testMethod void testConstructor1() {
        String rtTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Performance Fleece');
        Opportunity testOpp = TestUtil.createOppty(rtTestOn, 'Performance Fleece');
        //Opportunity testOpp = TestUtil.createOppty('', 'Performance Fleece');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        AddressController ac = new AddressController(ctrl);
        System.assertEquals(1, ac.addyList.size());
    }
    
    static testMethod void testConstructor2() {
        String rtTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Performance Fleece');
        Opportunity testOpp = TestUtil.createOppty(rtTestOn, 'Performance Fleece');
        //Opportunity testOpp = TestUtil.createOppty('', 'Performance Fleece');
        Address__c testAddy = TestUtil.createAddress(testOpp.AccountId, testOpp.Id, '123 Dirt Rd', 'IL', '60606', 'Chicago', 'US');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        AddressController ac = new AddressController(ctrl);
        System.assertEquals(1, ac.addyList.size());
    }    
    
    static testMethod void testAddAddress() {
        String rtTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Performance Fleece');
        Opportunity testOpp = TestUtil.createOppty( rtTestOn, 'Performance Fleece');
        //Opportunity testOpp = TestUtil.createOppty('', 'Performance Fleece');
        Address__c testAddy = TestUtil.createAddress(testOpp.AccountId, testOpp.Id, '123 Dirt Rd', 'IL', '60606', 'Chicago', 'US');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        AddressController ac = new AddressController(ctrl);
        ac.addAddress(); 
        System.assertEquals(2, ac.addyList.size());     
        ac.addAddress(); 
        System.assertEquals(2, ac.addyList.size());  
    }
    
    static testMethod void testSaveAddresses() {
        String rtTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Performance Fleece');
        Opportunity testOpp = TestUtil.createOppty( rtTestOn, 'Performance Fleece');
        //Opportunity testOpp = TestUtil.createOppty('', 'Performance Fleece');
        Address__c testAddy = TestUtil.createAddress(testOpp.AccountId, testOpp.Id, '123 Dirt Rd', 'IL', '60606', 'Chicago', 'US');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        AddressController ac = new AddressController(ctrl);
        ac.addyList[0].addy.Street_Line_1__c = '123 Paved Road';
        ac.saveAddresses();
        Address__c queriedAddy = [SELECT Street_Line_1__c FROM Address__c WHERE Opportunity__c = :testOpp.Id LIMIT 1];
        System.assertEquals('123 Paved Road', queriedAddy.Street_Line_1__c);
    }    
    
    static testMethod void testDeleteSelected() {
        String rtTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Performance Fleece');
        Opportunity testOpp = TestUtil.createOppty( rtTestOn, 'Performance Fleece');
        
        //Opportunity testOpp = TestUtil.createOppty('', 'Performance Fleece');
        Address__c testAddy = TestUtil.createAddress(testOpp.AccountId, testOpp.Id, '123 Dirt Rd', 'IL', '60606', 'Chicago', 'US');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        AddressController ac = new AddressController(ctrl);
        ac.addyList[0].selected = true;
        ac.deleteSelected();
        System.assertEquals(1, ac.addyList.size());
        System.assertNotEquals('123 Dirt Rd', ac.addyList[0].addy.Street_Line_1__c);
    }            
}