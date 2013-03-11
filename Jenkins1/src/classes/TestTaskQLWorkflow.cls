/* ===================================================================
* TestTaskQLWorkflow

* @author.....: Sonja Smith

* @date.......: 2013/15/02

* @Last Change: 2013/15/02 by SS

* Description.: Test class that updates Account and Opportunity with Highest Quantum Lead Sales Value and Rank by comparing completed tasks withi a 90 day range

* Dependencies: TaskQLWorkflow
* ===================================================================
*/
@isTest
private class TestTaskQLWorkflow {
    
    static testMethod void testInsertAndUpdate(){
        Account a = TestUtil.createAccount('Test');
        Opportunity o = TestUtil.createOpportunity(a, 'Test', 'Prospecting', System.today()+1, True);
        Quantum_Lead__c q = TestUtil.createQuantumLead(a, 500, '5');
        Task t = TestUtil.createTask('In progress', System.today(), a.Id);
        
        Test.startTest();
            q.Call_List_Priority__c = '1';
            q.Sales_Value__c = 200;
            update q;
            
            t.Status ='Completed';
            update t;
            
            q.Call_List_Priority__c = '2';
            q.Sales_Value__c = 1000;
            update q;
            
            Task t2 = TestUtil.createTask('Completed', System.today()+1, a.Id);

            //System.assertEquals([Select Highest_QL_Sales_Value_90_Day__c from Account where Id =: a.Id].get(0).Highest_QL_Sales_Value_90_Day__c, 1000);
            //System.assertEquals([Select Highest_QL_Sales_Value_90_Day__c from Opportunity where Id =: o.Id].get(0).Highest_QL_Sales_Value_90_Day__c, 1000);
            //System.assertEquals([Select Highest_QL_Rank_90_Day__c from Account where Id =: a.Id].get(0).Highest_QL_Rank_90_Day__c, 1);
            //System.assertEquals([Select Highest_QL_Rank_90_Day__c from Opportunity where Id =: o.Id].get(0).Highest_QL_Rank_90_Day__c, 1);
        Test.stopTest();
    }

}