@isTest
private class TestValidateTINController {

  static testMethod void testValidateTINButton() {
    List<Account> accountsToInsert = new List<Account>();
    Account a1;
    Account a2;
    Account a3;
    Account a4;
    Account a5;
    Account a6;
    Account a7;
    Account a8;

    a1 = TestUtil.createAccount();
    a1.Company_Legal_Name__c = 'Test Legal Name';
    accountsToInsert.add(a1);

    a2 = TestUtil.createAccount();
    a2.Tax_ID__c = '123456789';
    accountsToInsert.add(a2);

    a3 = TestUtil.createAccount();
    a3.Company_Legal_Name__c = 'Test Legal Name';
    a3.Tax_ID__c = '123-45-67890';
    accountsToInsert.add(a3);

    a4 = TestUtil.createAccount();
    a4.Company_Legal_Name__c = 'Test Legal Name';
    a4.Tax_ID__c = '0123456789';
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
    
    //Test for Missing Tax ID
    ValidateTINController controller1 = new ValidateTINController(new ApexPages.StandardController(a1));
    controller1.validateTINButton();

    a1 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a1.Id];
    System.assertEquals (a1.TIN_Status__c, 'Invalid');
    System.assertEquals (a1.TIN_Status_Details__c, 'Tax ID # is Required');

    //Test for Missing Company Legal Name
    ValidateTINController controller2 = new ValidateTINController(new ApexPages.StandardController(a2));
    controller2.validateTINButton();

    a2 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a2.Id];
    System.assertEquals (a2.TIN_Status__c, 'Invalid');
    System.assertEquals (a2.TIN_Status_Details__c, 'Company Legal Name is Required');

    //Test for improperly formatted Tax ID with a dash
    ValidateTINController controller3 = new ValidateTINController(new ApexPages.StandardController(a3));
    controller3.validateTINButton();

    a3 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a3.Id];
    System.assertEquals (a3.TIN_Status__c, 'Invalid');
    System.assertEquals (a3.TIN_Status_Details__c, 'Invalid TIN Format');

    //Test for improperly formatted Tax ID without a dash
    ValidateTINController controller4 = new ValidateTINController(new ApexPages.StandardController(a4));
    controller4.validateTINButton();

    a4 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a4.Id];
    System.assertEquals (a4.TIN_Status__c, 'Invalid');
    System.assertEquals (a4.TIN_Status_Details__c, 'Invalid TIN Format');

    //Test for properly formatted Tax ID with a dash - Invalid
    ValidateTINController controller5 = new ValidateTINController(new ApexPages.StandardController(a5));
    controller5.validateTINButton();

    a5 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a5.Id];
    System.assertEquals (a5.TIN_Status_Details__c, 'Tax ID # and Company Legal Name do not match');

    //Test for properly formatted Tax ID without a dash - Invalid
    ValidateTINController controller6 = new ValidateTINController(new ApexPages.StandardController(a6));
    controller6.validateTINButton();

    a6 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a6.Id];
    System.assertEquals (a6.TIN_Status_Details__c, 'Tax ID # and Company Legal Name do not match');

    //Test for properly formatted Tax ID with a dash - Valid
    ValidateTINController controller7 = new ValidateTINController(new ApexPages.StandardController(a7));
    controller7.validateTINButton();

    a7 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a7.Id];
    System.assertEquals (a7.TIN_Status__c, 'Valid');
    System.assertEquals (a7.TIN_Status_Details__c, 'TIN Status is Valid');

    //Test for properly formatted Tax ID without a dash - Valid
    ValidateTINController controller8 = new ValidateTINController(new ApexPages.StandardController(a8));
    controller8.validateTINButton();

    a8 = [SELECT Id, TIN_Status__c, TIN_Status_Details__c FROM Account WHERE Id =: a8.Id];
    System.assertEquals (a8.TIN_Status__c, 'Valid');
    System.assertEquals (a8.TIN_Status_Details__c, 'TIN Status is Valid');
  }
}