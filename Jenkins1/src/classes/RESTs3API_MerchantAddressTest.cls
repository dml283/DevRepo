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
@isTest
private class RESTs3API_MerchantAddressTest {

  static testMethod void testAddressPUTReturnsAddressHavingNonNullIdWhenGivenValidCreateRequest() {
    Account merchant = LibraryRESTControllerTestHelpers.buildAccount();
    insert merchant;
    
    S3MerchantAddress postedAddress = new S3MerchantAddress();
    postedAddress.account_id = merchant.Id;
    postedAddress.city     = 'Palo Alto';
    postedAddress.country       = 'US';
    postedAddress.phone_number = '5551231234';
    postedAddress.postal_code    = '94306';
    postedAddress.state    = 'CA';
    postedAddress.street_line_1    = '3101 Park Blvd';
    postedAddress.street_line_2    = 'Testing Address';
    postedAddress.venue_name    = 'Test Venue Name';

    // call the REST controller method
    S3MerchantAddress returnedAddress = RESTs3API_MerchantAddress.merchant_address_PUT( postedAddress );

    // assertion
    System.assertEquals( '3101 Park Blvd', returnedAddress.street_line_1 );
    
    // assertion
    System.assertNotEquals( null, returnedAddress.id );
  }

  static testMethod void testAddressPOSTReturnsAddressHavingNonNullIdWhenGivenValidUpdateRequest() {

    Account merchant = LibraryRESTControllerTestHelpers.buildAccount();
    insert merchant;
    
    Merchant_Addresses__c address = LibraryRESTControllerTestHelpers.buildMerchantAddress(merchant.id); 
    insert address;

    // Provide POST params as a basic S3MerchantAccount
    S3MerchantAddress postedAddress = new S3MerchantAddress();
    postedAddress.city     = 'Palo Alto';
    postedAddress.country       = 'US';
    postedAddress.phone_number = '5551231234';
    postedAddress.postal_code    = '94306';
    postedAddress.state    = 'CA';
    postedAddress.street_line_1    = '3101 Park Blvd';
    postedAddress.street_line_2    = 'Testing Address';
    postedAddress.venue_name    = 'Test Venue Name';
    postedAddress.id = address.Id;

    // call the REST controller method
    S3MerchantAddress returnedAddress = RESTs3API_MerchantAddress.merchant_address_POST( postedAddress );

    // assertion
    System.assertEquals( '3101 Park Blvd', returnedAddress.street_line_1 );
    
  }

  static testMethod void testAddressGETReturnsAddressHavingNonNullIdWhenGivenValidAccountId() {

    Account merchant = LibraryRESTControllerTestHelpers.buildAccount();
    insert merchant;
    
    Merchant_Addresses__c address = LibraryRESTControllerTestHelpers.buildMerchantAddress(merchant.id); 
    insert address;

    // Set parameters on request
    RestRequest request = new RestRequest();
    request.params.put( 'salesforce_id', address.id );
    System.RestContext.request = request;
    
    // call controller method
    S3MerchantAddress returnedAddress = RESTs3API_MerchantAddress.merchant_address_get();

    // assertion
    System.assertNotEquals( null, returnedAddress.id );
  }
}