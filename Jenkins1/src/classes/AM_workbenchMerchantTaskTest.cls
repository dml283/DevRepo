@isTest
public class AM_workbenchMerchantTaskTest {
  static testMethod void getPrepTaskTest() {
    Account account = new Account();
    account.Name = 'testing account';
    account.BillingStreet = '123456 test';
    account.BillingCity = 'Chicago';
    account.BillingState = 'IL';
    account.BillingPostalCode = '60640';
    account.BillingCountry = 'US';
    account.research_ranking__c = '5';
    account.Groupon_Scheduler_Strength__c = 'Deactivated';
    account.Rewards_Offer_Status__c = 'Live';
    account.Now_Category__c = 'Stupid Now! Category';
    account.Sales_Value__c = 02002;
    insert account;

    Task task = new Task();
    task.Subject = 'Prep: Preview Delivered';
    task.WhatId = account.Id;
    insert task;

    AM_workbench.MerchantTask merchantTask = AM_workbench.getPrepTask(task.Subject, task.WhatId);
    System.assertEquals(task.WhatId, merchantTask.whatId);
    System.assertEquals(task.Subject, merchantTask.subject);
  }

  static testMethod void create() {
    Task task = new Task();
    AM_workbench.MerchantTask merchantTask = new AM_workbench.MerchantTask(task, 'Default Subject', 'Default ID');
    System.assertEquals('Default ID', merchantTask.whatId);
    System.assertEquals('Default Subject', merchantTask.subject);
  }
}