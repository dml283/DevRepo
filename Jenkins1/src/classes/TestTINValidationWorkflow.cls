@isTest
class TestTINValidationWorkflow {

  static testMethod void testValidateTIN() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'TestAccountTaxonomyWorkflow1@groupon.com', 'TestAccountTaxonomyWorkflow1@groupon.com');
    Account oldAccount;
    Account a1;
    Account a2;
    Account a3;
    Account a4;
    Account a5;
    Account a6;
    Account a7;
    Account a8;
    List<Account> accountsToInsert = new List<Account>();

    Test.startTest();
      System.runAs(u1) {
        oldAccount = TestUtil.createAccount();
        accountsToInsert.add(oldAccount);

        a1 = TestUtil.createAccount();
        a1.Company_Legal_Name__c = 'Test Legal Name';
        accountsToInsert.add(a1);

        a2 = TestUtil.createAccount();
        a2.Tax_ID__c = '123456789';
        accountsToInsert.add(a2);

        a3 = TestUtil.createAccount();
        a3.Company_Legal_Name__c = 'Test Legal Name';
        a3.Tax_ID__c = '123-456-7890';
        accountsToInsert.add(a3);

        a4 = TestUtil.createAccount();
        a4.Company_Legal_Name__c = 'Test Legal Name';
        a4.Tax_ID__c = '1234567890';
        accountsToInsert.add(a4);

        a5 = TestUtil.createAccount();
        a5.Company_Legal_Name__c = 'Test Legal Name';
        a5.Tax_ID__c = '123-45-6789';
        accountsToInsert.add(a5);

        a6 = TestUtil.createAccount();
        a6.Company_Legal_Name__c = 'Test Legal Name';
        a6.Tax_ID__c = '123456789';
        accountsToInsert.add(a6);

        a7 = TestUtil.createAccount();
        a7.Company_Legal_Name__c = 'Test Legal Name';
        a7.Tax_ID__c = '123-45-6789';
        a7.TIN_Status__c = 'Valid';
        accountsToInsert.add(a7);

        a8 = TestUtil.createAccount();
        a8.Company_Legal_Name__c = 'Test Legal Name';
        a8.Tax_ID__c = '123456789';
        a8.TIN_Status__c = 'Valid';
        accountsToInsert.add(a8);

        insert accountsToInsert;
      }

      TINValidationWorkflow.hasExecuted = true;
      Map<ID, Account> oldMap = new Map<ID, Account> {a1.Id => oldAccount, a2.Id => oldAccount, a3.Id => oldAccount, a4.Id => oldAccount, a5.Id => oldAccount, a6.Id => oldAccount, a7.Id => oldAccount, a8.Id => oldAccount};
      Map<ID, Account> newMap = new Map<ID, Account> {a1.Id => a1, a2.Id => a2, a3.Id => a3, a4.Id => a4, a5.Id => a5, a6.Id => a6, a7.Id => a7, a8.Id => a8};
      TINValidationWorkflow tvw = new TINValidationWorkflow (newMap, oldMap);
      TINValidationWorkflow.hasExecuted = false;
      tvw.execute();

    Test.stopTest();

    //Test for Missing Tax ID
    a1 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a1.Id];
    System.assertEquals (a1.TIN_Status__c, 'Invalid');
    System.assertEquals (a1.TIN_Status_Details__c, 'Tax ID # is Required');

    //Test for Missing Company Legal Name
    a2 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a2.Id];
    System.assertEquals (a2.TIN_Status__c, 'Invalid');
    System.assertEquals (a2.TIN_Status_Details__c, 'Company Legal Name is Required');

    //Test for improperly formatted Tax ID with a dash
    a3 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a3.Id];
    System.assertEquals (a3.TIN_Status__c, 'Invalid');
    System.assertEquals (a3.TIN_Status_Details__c, 'Invalid TIN Format');

    //Test for improperly formatted Tax ID without a dash
    a4 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a4.Id];
    System.assertEquals (a4.TIN_Status__c, 'Invalid');
    System.assertEquals (a4.TIN_Status_Details__c, 'Invalid TIN Format');

    //Test for improperly formatted Tax ID without a dash
    a5 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a5.Id];
    System.assertEquals (a5.TIN_Status_Details__c, 'Tax ID # and Company Legal Name do not match');

    //Test for improperly formatted Tax ID without a dash
    a6 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a6.Id];
    System.assertEquals (a6.TIN_Status_Details__c, 'Tax ID # and Company Legal Name do not match');

    //Test for improperly formatted Tax ID without a dash
    a7 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a7.Id];
    System.assertEquals (a7.TIN_Status_Details__c, 'TIN Status is Valid');

    //Test for improperly formatted Tax ID without a dash
    a8 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a8.Id];
    System.assertEquals (a8.TIN_Status_Details__c, 'TIN Status is Valid');
  }
}