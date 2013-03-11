@isTest
public class InsertSpaceForCanadianZipCodeTriggerTest {

  // describe: empty constructor
  static TestMethod void inserts_space_in_canadian_zipcodes_without_them() {
    Account account = DealWizardTestHelper.buildAccount();
    insert account;

    Merchant_Addresses__c address = DealWizardTestHelper.buildMerchantAddress(account.id);
    address.State_Province__c = 'ON';
    address.Zip_Postal_Code__c = 'M5V1J1';
    address.Country__c = 'Canada';
    
    insert address;
    
    Merchant_Addresses__c InsertedMA = [SELECT Zip_Postal_Code__c FROM Merchant_Addresses__c WHERE ID =: address.id];
    
    System.assertEquals('M5V 1J1', InsertedMA.Zip_Postal_Code__c);
  }
  
  static TestMethod void does_not_insert_space_in_canadian_zipcodes_that_already_have_them() {
    Account account = DealWizardTestHelper.buildAccount();
    insert account;

    Merchant_Addresses__c address = DealWizardTestHelper.buildMerchantAddress(account.id);
    address.State_Province__c = 'ON';
    address.Zip_Postal_Code__c = 'M5V 1J1';
    address.Country__c = 'Canada';
    
    insert address;
    
    Merchant_Addresses__c InsertedMA = [SELECT Zip_Postal_Code__c FROM Merchant_Addresses__c WHERE ID =: address.id];
    
    System.assertEquals('M5V 1J1', InsertedMA.Zip_Postal_Code__c);
  }
  
  static TestMethod void inserts_space_even_if_country_name_is_abbreviated() {
    Account account = DealWizardTestHelper.buildAccount();
    insert account;

    Merchant_Addresses__c address = DealWizardTestHelper.buildMerchantAddress(account.id);
    address.State_Province__c = 'ON';
    address.Zip_Postal_Code__c = 'M5V1J1';
    address.Country__c = 'CA';
    
    insert address;
    
    Merchant_Addresses__c InsertedMA = [SELECT Zip_Postal_Code__c FROM Merchant_Addresses__c WHERE ID =: address.id];

    System.assertEquals('M5V 1J1', InsertedMA.Zip_Postal_Code__c);
  }
}