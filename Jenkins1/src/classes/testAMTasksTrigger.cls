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
@istest
private class testAMTasksTrigger {

    static testMethod void myAMTasksTest() {
      Test.StartTest();
      Profile p = [select id from profile where name='System Administrator'];
          User u = new User(alias = 'standt', email='standarduser@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='myAMTasksTest@groupon.com');
          insert u;
        //run as user
        System.RunAs(u)
        {     
          User ha = [SELECT Id FROM user WHERE Id = '00580000001YaJI'];
          
          User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='myAMTasksTest2@groupon.com', managerId = u.id);
          insert u1;
          
          account a = new account();
          a.name = 'testAMTasksTrigger' + system.now();
          insert a;     
          system.debug('Account ID: ' + a.id);
          
          opportunity o = new opportunity();
          o.name = 'test oppty';
          o.StageName = 'Prospecting';
          o.CloseDate = date.today();
          o.Deal_Strengh__c = 'Rep Getting Info';
          o.AccountCoordinator__c = u1.id;
          o.AccountId = a.Id;
          insert o; 
          
          task t = new task();
          t.OwnerId = ha.id;
          t.Subject = 'Maintenance: Test';
          t.Type = 'Call - Phone Bank Inbound';
          t.whatid = o.id;
          insert t;
          
          u1.isActive = false;
          update u1;
          
          task t1 = new task();
          t1.OwnerId = ha.id;
          t1.Subject = 'Maintenance: Test';
          t1.Type = 'Call - Phone Bank Inbound';
          t1.whatid = o.id;
          insert t1;
          
          //task t1 = [SELECT OwnerId FROM task WHERE Id = :t.Id];
            
          Test.StopTest();
        }
        
    }
}