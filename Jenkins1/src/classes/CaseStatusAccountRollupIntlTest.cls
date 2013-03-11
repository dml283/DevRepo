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
private class CaseStatusAccountRollupIntlTest {

    static testMethod void myUnitTest() {
    	Account a=TestUtil.createAccount();
    	insert a;
    	Case c=TestUtil.createCase(false,true);
    	c.AccountId=a.id;
    	Case c1=TestUtil.createCase(false,true);
    	c1.Escalation_Status_Account__c='Active';
    	c1.AccountId=a.id;
    	insert c1;
    	insert c;
    	a=[select id,Escalation_Status__c,Locking_Reason__c from Account where id=:a.id];
    	//system.assert(c.Escalation_Status_Account__c==a.Escalation_Status__c);
    	//system.assert(a.Locking_Reason__c==c.Locking_Reason_Account__c);
    	
        // TO DO: implement unit test
    }
}