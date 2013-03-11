@isTest
private class QuantumLeadAccountUpdatesTest {
//Waiting to Delete
/*
  static testMethod void myQuantumLeadAccountUpdatesTest() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles', username='QuantumLeadAccountUpdatesTest@groupon.com');
    insert u;
        
    System.RunAs(u) {
      Test.startTest();             
          Division__c div = new Division__c(Name ='test',State__c ='IL');
          insert div;
                        
          account a = new account();
          a.Name = 'Test Account';
          a.Division__c = div.Id;
          a.Result_of_Merchant_Survey__c = 'Prospecting';
          a.Account_Status__c = 'Contacted';
          insert a;
    
          account a1 = new account();
          a1.Name = 'Test Account';
          a1.Division__c = div.Id;
          a1.Result_of_Merchant_Survey__c = 'Prospecting';
          a1.Account_Status__c = 'Contacted';
          insert a1;
                
          Quantum_Lead__c q = new Quantum_Lead__c();
          q.Account__c = a.Id;
          q.Parent_Id__c = a.Id;
          q.Call_List_Priority__c = '0000000150';
          q.Sales_Value__c = 50;
          q.Sales_Value_Reasons__c = 'Test Reason';
          insert q;
    
          Quantum_Lead__c q1 = new Quantum_Lead__c();
          q1.Account__c = a1.Id;
          q1.Parent_Id__c = a1.Id;
          q1.Call_List_Priority__c = '0000000150';
          q1.Sales_Value__c = 50;
          q1.Sales_Value_Reasons__c = 'Test Reason';
          insert q1;
                
          a.Account_Status__c = 'Merchant Research Flag';
          update a;
    
          a1.Quantum_Lead_Flag_Reason__c = 'Test Reason';
          update a1;
    
          a1.QL_Flag_Status__c = 'Resolved';
          update a1;
    
          delete a1;
                
          Quantum_Lead__c q2 = [SELECT Id, QL_Flag_Call_List_Priority__c, QL_Flag_Sales_Value__c, QL_Flag_Sales_Value_Reason__c FROM Quantum_Lead__c WHERE Id =: q.Id];
                
          System.assertEquals(q2.QL_Flag_Call_List_Priority__c,'0000000150');
          System.assertEquals(q2.QL_Flag_Sales_Value__c,50);
          System.assertEquals(q2.QL_Flag_Sales_Value_Reason__c,'Test Reason');
      Test.stopTest();
    }
  }
*/
}