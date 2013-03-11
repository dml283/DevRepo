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
private class TestOppFieldAssignmentsWorkflow {

	static testMethod void testQLfieldCopy(){
		User u = testUtil.createUser('System Administrator');
        User u1 = testUtil.createUser2('Outside Sales');

        System.RunAs(u){
        	Account a = new Account ();
	        a.name = 'Test Acct';
	        a.ownerId = u1.id;
	        a.Highest_Sales_Value__c = 100;
	        a.Highest_QL_Rank__c = 5;
			a.Highest_QL_Rank_90_Day__c = 1;
			a.Highest_QL_Sales_Value_90_Day__c = 200;
	        insert a;
	        
	        String g1RecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' and Name = 'G1'].Id;
			
			Division__c d = new Division__c(); 
	        d.name = 'Chicago';
	        d.state__c = 'IL';
	        d.Manually_Assign_City_Team__c = False;
	        d.DSM__c = u.Id;
	        d.Outside_DSM__c = u.Id;
	        d.City_CEO__c = u.Id;
	        d.Market_Planner__c = u.Id;
	        insert d;
			
	    	Opportunity o1 = new Opportunity();
	        o1.name = 'Test Opportunity 1';
	        o1.RecordTypeId = g1RecordTypeId;
	        o1.OwnerId = u1.id;
	        o1.StageName = 'Prospecting';
	        o1.CloseDate = Date.today();
	        o1.AccountId = a.Id;
	        o1.Division__c = 'Chicago';
	        o1.Division_Dynamic__c  = d.Id;
			o1.User__c = u.Id; //city planner
	        insert o1;
	        batchapexstop.stopbatchapex =false;
	        
			o1.StageName = 'Closed Won';
        	update o1;
			
        	Test.startTest();               
	    		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
	    		req1.setObjectId(o1.Id);
	    		Approval.ProcessResult result1 = Approval.process(req1);
	    		System.assert(result1.isSuccess());
	    		System.assertEquals('Pending', result1.getInstanceStatus(), 'Instance Status'+result1.getInstanceStatus());
        	Test.stopTest();    
        	
        	System.assertEquals([Select StageName from Opportunity where Id =: o1.Id].StageName, 'Approval Needed');
    		//System.assertEquals([Select QL_Sales_Value__c from Opportunity where Id =: o1.Id].QL_Sales_Value__c, 100);
    		//System.assertEquals([Select QL_Rank__c from Opportunity where Id =: o1.Id].QL_Rank__c, '5');
    		//System.assertEquals([Select Highest_QL_Rank_90_Day__c from Opportunity where Id =: o1.Id].Highest_QL_Rank_90_Day__c, 1);
    		//System.assertEquals([Select Highest_QL_Sales_Value_90_Day__c from Opportunity where Id =: o1.Id].Highest_QL_Sales_Value_90_Day__c, 200);
        }
	}
}