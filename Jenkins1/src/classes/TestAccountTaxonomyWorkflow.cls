@isTest
class TestAccountTaxonomyWorkflow {

  static testMethod void testGlobalTaxonomyMapping() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'TestAccountTaxonomyWorkflow1@groupon.com', 'TestAccountTaxonomyWorkflow1@groupon.com');
    TaxonmyMap__c taxmap;
    Account a1;
    Account a2;

    System.runAs (u1) {

      taxmap = TestUtil.createTaxonmyMap('Lead/Account', '', 'Beauty / Wellness / Healthcare', 'Office - Dental', 'Health & Beauty', 'Miscellaneous', 'Beauty', 'Dental Care', 'Dental Care', True);

      a1 = TestUtil.createAccount();
      a1.OwnerId = UserInfo.getUserId();
      a1.Category_v3__c = 'Test Category';
      a1.Subcategory_v3__c = 'Test Subcategory';
      a1.Services_Offered__c = 'Test Services';
      insert a1;

      a2 = TestUtil.createAccount();
      a2.OwnerId = UserInfo.getUserId();
      a2.Category_v3__c = 'Beauty / Wellness / Healthcare';
      a2.Subcategory_v3__c = 'Office - Dental';
      a2.Services_Offered__c = 'Teeth Cleaning';
      insert a2;
    }

    AccountTaxonomyWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account> {a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account> {a2.Id => a2};
    AccountTaxonomyWorkflow atw = new AccountTaxonomyWorkflow (newMap, oldMap);

    AccountTaxonomyWorkflow.hasExecuted = false;
    atw.execute();
    System.assertEquals (a2.Global_SFDC_Category__c, 'Beauty');
    System.assertEquals (a2.Global_SFDC_Subcategory_1__c, 'Dental Care');
  }

  static testMethod void testcreateSupportTaxonomyRecords() {
    User u1 = TestUtil.createUserWithUsername ('Inside Sales', 'TestAccountTaxonomyWorkflow1@groupon.com', 'TestAccountTaxonomyWorkflow1@groupon.com');
    Account a1;
    Account a2;
    Selected_Taxonomy__c st;

    System.runAs (u1) {

      a1 = TestUtil.createAccount();
      a1.OwnerId = UserInfo.getUserId();
      a1.Category_v3__c = 'Test Category';
      a1.Subcategory_v3__c = 'Test Subcategory';
      a1.Services_Offered__c = 'Test Services';
      insert a1;

      a2 = TestUtil.createAccount();
      a2.OwnerId = UserInfo.getUserId();
      a2.Category_v3__c = 'Beauty / Wellness / Healthcare';
      a2.Subcategory_v3__c = 'Office - Dental';
      a2.Services_Offered__c = 'Teeth Cleaning';
      insert a2;
    }

    AccountTaxonomyWorkflow.hasExecuted = true;
    Map<ID, Account> oldMap = new Map<ID, Account> {a2.Id => a1};
    Map<ID, Account> newMap = new Map<ID, Account> {a2.Id => a2};
    AccountTaxonomyWorkflow atw = new AccountTaxonomyWorkflow (newMap, oldMap);

    AccountTaxonomyWorkflow.hasExecuted = false;
    stopInsertSupportTaxonomyRecords.stopFutureCallout = false;
    atw.execute();
  }
}