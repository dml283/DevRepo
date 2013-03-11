global class BatchGeocoder implements Database.Batchable<SObject>, Database.Stateful,  Database.AllowsCallouts {

  global BatchGeocoder() {}

  global Database.queryLocator start (Database.BatchableContext ctx) {
    string query;
    query = 'select id, Street_Line_1__c, Street_Line_2__c, city__c, State_Province__c, Zip_Postal_Code__c, country__c, latitude__c, GeoCode_Date__c, Longitude__c, neighborhood__c, failed_geocode__c, precision__c, Accuracy__c, Failed_Geo_Code_Reason__c FROM merchant_addresses__c WHERE geocode_needed__c = \'yes\' ORDER BY lastModifiedDate desc LIMIT 5000';
    return Database.getQueryLocator (query);
  }

  global void execute (Database.BatchableContext ctx, List<Sobject> scope) {
    List<merchant_addresses__c> addresses = (List<merchant_addresses__c>) scope;
    bulk_geocoder geo = new bulk_geocoder();
    geo.merch_addy = addresses;
    geo.geocode();
  }

  global void finish (Database.BatchableContext ctx) {

    AsyncApexJob a = [SELECT id, ApexClassId,
                      JobItemsProcessed, TotalJobItems,
                      NumberOfErrors, CreatedBy.Email
                      FROM AsyncApexJob
                      WHERE id = : ctx.getJobId()];

    String emailMessage = 'Your batch job '
                          + 'Geocode '
                          + 'has finished.  It executed '
                          + a.totalJobItems
                          + ' batches.  Of which, ' + a.jobitemsprocessed
                          + ' processed without any exceptions thrown and '
                          + a.numberOfErrors +
                          ' batches threw unhandled exceptions.';


    Messaging.SingleEmailMessage mail =
      new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {'cbland@groupon.com'};
    mail.setToAddresses (toAddresses);
    mail.setReplyTo ('noreply@salesforce.com');
    mail.setSenderDisplayName ('Batch Job Summary');
    mail.setSubject ('Geocode Batch job completed');
    mail.setPlainTextBody (emailMessage);
    mail.setHtmlBody (emailMessage);
    Messaging.sendEmail (new Messaging.SingleEmailMessage[]
                         { mail });
  }

  public static testmethod void testBatchLeadConversion() {
    Account acct = new Account();
    acct.name = 'Test Account' + system.now();
    insert acct;

    merchant_addresses__c ma = new merchant_addresses__c();
    ma.account__c = acct.id;
    ma.Street_Line_1__c = '123 fake st';
    ma.city__c = 'Chicago';
    ma.State_Province__c = 'IL';
    ma.Zip_Postal_Code__c = '60654';

    insert ma;

    Test.startTest();
    Database.executeBatch (new BatchGeocoder());
    Test.stopTest();

  }
}