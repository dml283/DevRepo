@isTest
public class LeadInsertTaxonomyTest {


  static void mytestLeadInsertSupportTaxonomyRecords() {
    Profile p = [select id from profile where name = 'System Administrator'];
    User u = new User(alias = 'standt', email = 'standarduser@groupon.com', username = 'LeadSupportTaxonomy@test.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id, timezonesidkey = 'America/Los_Angeles');
    insert u;

    //run as user
    System.RunAs(u) {
      List < id > leadTestRec = new list < id > ();
      List < string > leadTestOldServices = new list < string > ();
      List < string > leadTestNewServices = new list < string > ();
      List < string > leadTestCategory = new list < string > ();

      lead l = new lead();
      l.company = 'leadSupportTXNMYrecords';
      l.division__c = 'Las Vegas';
      l.category_v3__c = 'Shopping';
      l.Status = 'Uncontacted';
      l.LastName = 'Lorem';
      l.services_offered__c = 'Mattress | Pillow | Faucet';

      taxonomy_Support__c ts1 = new taxonomy_Support__c();
      ts1.name__c = 'Magazine';
      ts1.category__c = 'Shopping';
      insert ts1;

      taxonomy_Support__c ts2 = new taxonomy_Support__c();
      ts2.name__c = 'Musical Instrument';
      ts2.category__c = 'Shopping';
      insert ts2;

      taxonomy_Support__c ts3 = new taxonomy_Support__c();
      ts3.name__c = 'Mattress';
      ts3.category__c = 'Shopping';
      insert ts3;

      taxonomy_Support__c ts4 = new taxonomy_Support__c();
      ts4.name__c = 'Pillow';
      ts4.category__c = 'Shopping';
      insert ts4;

      taxonomy_Support__c ts5 = new taxonomy_Support__c();
      ts5.name__c = 'Faucet';
      ts5.category__c = 'Shopping';
      insert ts5;

      insert l;

      l.Services_Offered__c = 'Magazine | Musical Instrument';
      update l;

      leadTestRec.add(l.id);
      leadTestOldServices.add('Faucet');
      leadTestNewServices.add('Pillow');
      leadTestCategory.add('Shopping');

      list < insertSupportTaxonomyRecords.async_helper > async = new list < insertSupportTaxonomyRecords.async_helper > ();
      async.add(new insertSupportTaxonomyRecords.async_helper(leadTestRec, leadTestOldServices, leadTestNewServices, leadTestCategory));

      insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));
    }

  }

  @isTest
  static void mytestAcctInsertSupportTaxonomyRecords() {
    Profile p = [select id from profile where name = 'System Administrator'];
    User u = new User(alias = 'standt', email = 'standarduser@groupon.com', username = 'AcctSupportTaxonomy@test.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id, timezonesidkey = 'America/Los_Angeles');
    insert u;

    //run as user
    System.RunAs(u) {
      List < id > acctTestRec = new list < id > ();
      List < string > acctTestOldServices = new list < string > ();
      List < string > acctTestNewServices = new list < string > ();
      List < string > acctTestCategory = new list < string > ();

      account a = new account();
      a.name = 'acctSupportTaxonomyRecords';
      a.category_v3__c = 'Shopping';
      //a.services_offered__c = 'Magazine | Musical Instrument';
      taxonomy_Support__c ts1 = new taxonomy_Support__c();
      ts1.name__c = 'Magazine';
      ts1.category__c = 'Shopping';
      insert ts1;

      taxonomy_Support__c ts2 = new taxonomy_Support__c();
      ts2.name__c = 'Musical Instrument';
      ts2.category__c = 'Shopping';
      insert ts2;

      taxonomy_Support__c ts3 = new taxonomy_Support__c();
      ts3.name__c = 'Mattress';
      ts3.category__c = 'Shopping';
      insert ts3;

      taxonomy_Support__c ts4 = new taxonomy_Support__c();
      ts4.name__c = 'Pillow';
      ts4.category__c = 'Shopping';
      insert ts4;

      taxonomy_Support__c ts5 = new taxonomy_Support__c();
      ts5.name__c = 'Faucet';
      ts5.category__c = 'Shopping';
      insert ts5;

      insert a;
      test.startTest();
      a.Services_Offered__c = 'Faucet';
      update a;
      test.stopTest();

      list < insertSupportTaxonomyRecords.async_helper > async = new list < insertSupportTaxonomyRecords.async_helper > ();
      async.add(new insertSupportTaxonomyRecords.async_helper(acctTestRec, acctTestOldServices, acctTestNewServices, acctTestCategory));
      insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));
    }

  }
}