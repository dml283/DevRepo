@IsTest
private class DealTaxonomyClassTest {
  static testmethod void dealTaxonomyTest() {

    grouponTestUtil gTestUtil = new grouponTestUtil();
    User u = gTestUtil.createTestUser ('System Administrator');
    u.UserName = 'dealTaxonomyClass@user.com';
    insert u;
    System.RunAs (u) {
      Account Acct1 = gTestUtil.createAccount();
      acct1.Category_v3__c = 'Test Category';
      insert Acct1;

      Opportunity oppty1 = gTestUtil.createDeal();
      oppty1.AccountId = Acct1.Id;
      insert oppty1;

      Multi_Deal__c md1 = gTestUtil.createOption();
      md1.Opportunity__c = oppty1.Id;
      md1.Option_Services__c = 'Test Services';
      insert md1;

      Account Acct2 = gTestUtil.createAccount();
      acct2.Category_v3__c = 'Tickets';
      insert Acct2;

      Opportunity oppty2 = gTestUtil.createDeal();
      oppty2.AccountId = Acct2.Id;
      insert oppty2;

      Multi_Deal__c md2 = gTestUtil.createOption();
      md2.Opportunity__c = oppty2.Id;
      md2.Option_Services__c = 'Test Services';
      insert md2;

      taxonomy_Support__c ts1 = new taxonomy_Support__c();
      ts1.name__c = 'Live Test';
      ts1.category__c = 'Tickets';
      ts1.Type__c = 'Deal Attribute';
      ts1.Eligible_For_Primary_Service__c = True;
      insert ts1;

      PageReference pr = page.dealTaxonomyVF;
      Test.setCurrentPageReference (pr);

      id ctrlId = ApexPages.currentPage().getParameters().get ('Id');

      string currentid1 = ApexPages.currentPage().getParameters().put ('id', oppty1.id);
      ApexPages.StandardController stdController1 = new ApexPages.StandardController (Oppty1);
      dealTaxonomyClass dtTaxClass1 = new dealTaxonomyClass (stdController1);

      dtTaxClass1.getPrimaryOptions();
      dtTaxClass1.insertPrimaryService();

      string currentid2 = ApexPages.currentPage().getParameters().put ('id', oppty2.id);
      ApexPages.StandardController stdController2 = new ApexPages.StandardController (Oppty2);
      dealTaxonomyClass dtTaxClass2 = new dealTaxonomyClass (stdController2);

      dtTaxClass2.getPrimaryOptions();
    }
  }
}