@isTest
private class LeadUpdateMerchantTest {

    static testMethod void convertLead() {

      GrouponTestUtil testData = new GrouponTestUtil();

      User user = testData.createTestUser();
      insert user;

      Division__c division = testData.createDivision();
      insert division;

      Zip_Code__c zip = testData.createZipCode(division, null);
      insert zip;

      Lead lead = testData.createLead();
      lead.Division__c = division.id;
      insert lead;

      Account account = testData.createAccount();
      insert account;

      Contact contact = testData.createContact();
      contact.AccountId = account.Id;
      insert contact;

      Lead lead2 = testData.createLead();
      lead2.Division__c = division.id;
      insert lead2;

      Account account2 = testData.createAccount();
      insert account2;

      Merchant_Addresses__c merchantAddress = testData.createMerchantAddress();
      merchantAddress.Account__c = account2.Id;
      insert merchantAddress;

      Data_Integrity__c dataIntegrityOne = new Data_Integrity__c(Lead__c = lead.Id);
      insert dataIntegrityOne;
      Data_Integrity__c dataIntegrityTwo = new Data_Integrity__c(Lead__c = lead.Id);
      insert dataIntegrityTwo;

      Reviews__c review = testData.createReview();
      review.Lead__c = lead.id;
      insert review;

      Merchant_Events__c merchantEvent = new Merchant_Events__c (Lead__c = lead.id);
      insert merchantEvent;

      List<Id> accountIds = new List<Id> {account.Id, account2.Id};

      System.assertEquals(1, [SELECT COUNT() FROM Merchant_Addresses__c WHERE Account__c IN :accountIds]);

      Test.startTest();

      Database.LeadConvert lc = new database.LeadConvert();
      lc.setLeadId(lead.id);
      lc.setAccountId(account.id);
      lc.setContactId(contact.id);
      lc.setOverwriteLeadSource(false);
      lc.setSendNotificationEmail(false);
      lc.setConvertedStatus('Prospecting');
      Database.LeadConvertResult lcr = Database.convertLead(lc);

      Test.stopTest();

      System.assert(lcr.isSuccess());

      dataIntegrityOne = [SELECT Id, Account__c FROM Data_Integrity__c WHERE Id = :dataIntegrityOne.Id];
      System.assertEquals(account.Id, dataIntegrityOne.Account__c);
      dataIntegrityTwo = [SELECT Id, Account__c FROM Data_Integrity__c WHERE Id = :dataIntegrityTwo.Id];
      System.assertEquals(account.Id, dataIntegrityTwo.Account__c);

      System.assertEquals(2, [SELECT COUNT() FROM Merchant_Addresses__c WHERE Account__c IN :accountIds]);
      Merchant_Addresses__c address = [SELECT Id FROM Merchant_Addresses__c WHERE Account__c = :account.Id LIMIT 1];

      review = [SELECT Id, Account__c, Merchant_Address__c FROM Reviews__c WHERE Id = :review.Id];
      System.assertEquals(account.Id, review.Account__c);
      System.assertEquals(address.Id, review.Merchant_Address__c);

      merchantEvent = [SELECT Id, Account__c FROM Merchant_Events__c WHERE Id = :merchantEvent.Id];
      System.assertEquals(account.id, merchantEvent.Account__c);

    }
}