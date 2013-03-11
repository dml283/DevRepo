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
private class testHotLeadsTrigger {

    static testMethod void myHotLeadsTest() {
      grouponTestUtil gTestUtil = new grouponTestUtil();
            User u = gTestUtil.createTestUser('System Administrator');
            u.username = 'HotLeadsTrigger@test.com';
            insert u;
        //run as user
        System.RunAs(u) {
        
          list<task> tasklist = new list<task>();
          list<event> eventlist = new list<event>();

          lead l = new lead();
          l.FirstName = 'Will';
          l.LastName = 'Smith';
          l.Company = 'M.I.B.';
          l.Research_Ranking__c = '10';
          l.Date_of_Hotness__c = system.today();
          l.Hot_Lead__c = 'Yes';
          insert l;
          system.debug('Lead ID: ' + l.id); 
          
          account a = new account();
          a.name = 'test acct';
          a.Research_Ranking__c = '10';
          a.Date_of_Hotness__c = system.today();
          a.Hot_Lead__c = 'Yes';
          insert a;     
          system.debug('Account ID: ' + a.id);
          
          opportunity o = new opportunity();
          o.name = 'Test Opportunity';
          o.AccountId = a.id;
          o.StageName = 'Closed Won';
          o.CloseDate = system.today();
          o.AccountCoordinator__c = u.Id;
          insert o;
          
          contact c = new contact();
          c.Account = a;
          c.LastName = 'Test';
          insert c;
          
          Quantum_Lead__c q = new Quantum_Lead__c();
          q.Account__c = a.Id;
          q.Parent_Id__c = a.Id;
          q.Name = 'QL Test';
          q.Call_List_Priority__c = '000000012';
          q.Sales_Value__c = 3982;
          q.Sales_Value_Demand__c = 153;
          q.Sales_Value_Reasons__c = 'Increase new merchant mix';
          insert q;
          
          task t1 = new task();
          t1.Subject = 'Task 1';
          t1.Type = 'Call - Inbound';
          t1.whoid = l.id;
          tasklist.add(t1);
          
          task t2 = new task();
          t2.Subject = 'task 1';
          t2.Type = 'Call - Outbound';
          t2.whoid = l.id;
          tasklist.add(t2);
          
          task t3 = new task();
          t3.OwnerID = '00580000001YaJI';
          t3.Subject = 'Merchant Call';
          t3.Type = 'Call - Inbound';
          t3.whatid = o.id;
          tasklist.add(t3);
          
          task t4 = new task();
          t4.Subject = 'task 1';
          t4.Type = 'Call - Outbound';
          t4.whatid = a.id;                  
          tasklist.add(t4);
          
          task t5 = new task();
          t5.Subject = 'task 1';
          t5.Type = 'Call - Inbound';
          t5.whoid = c.id;
          tasklist.add(t5);
          
          task t6 = new task();
          t6.Subject = 'task 1';
          t6.Type = 'Call - Outbound';
          t6.whoid = c.id;
          t6.Status = 'Completed';              
          tasklist.add(t6);
          
          event e = new event();
          e.Subject = 'event 1';
          e.Type = 'Merchant Meeting';
          e.whoid = l.id;
          e.DurationInMinutes = 1;
          e.ActivityDateTime = system.now();
          eventlist.add(e);
          
          event e1 = new event();
          e1.Subject = 'event 2';
          e1.Type = 'Merchant Call';
          e1.whatid = a.id;
          e1.whoid = c.id;
          e1.DurationInMinutes = 1;
          e1.ActivityDateTime = system.now();
          eventlist.add(e1);
          
          insert tasklist;
          insert eventlist;
          
          t2.Status = 'Completed';
          update t2;
          
          t4.Status = 'Completed';
          update t4;

          e.Subject = 'updated event 1';
          update e;
          
          e1.Subject = 'updated event 2';
          update e1;
          
          Social_Living__c cf = new Social_Living__c();
          cf.Provider__c = 'Living Social';
          cf.AccountName__c = a.id;
          cf.Feature_Date__c = system.today();
          
        }
        
    }
}