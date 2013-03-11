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
public class RESTs3API_MerchantAccountTest {

  static testMethod void testMerchantPUTReturnsMerchantHavingNonNullIdWhenGivenValidCreateRequest() {
    // Provide POST params as a basic S3MerchantAccount
    S3MerchantAccount postedMerchant = new S3MerchantAccount();
    postedMerchant.name = 'new Name for Merchant';
    postedMerchant.billing_street     = '2 Diagon Alley';
    postedMerchant.billing_city       = 'Orlando';
    postedMerchant.billing_country    = 'US';
    postedMerchant.billing_postal_code = '44444';
    postedMerchant.billing_state      = 'FL';

    // call the REST controller method
    S3MerchantAccount returnedMerchant = RESTs3API_MerchantAccount.merchant_account_PUT( postedMerchant );

    // assertion
    System.assertEquals( 'new Name for Merchant', returnedMerchant.name );
    
    // assertion
    System.assertNotEquals( null, returnedMerchant.id );
  }

  static testMethod void testMerchantPOSTReturnsMerchantHavingNonNullIdWhenGivenValidUpdateRequest() {

    // Given an account
    Account account = LibraryRESTControllerTestHelpers.buildAccount(); 
    insert account;

    // Provide POST params as a basic S3MerchantAccount
    S3MerchantAccount postedMerchant = new S3MerchantAccount();
    postedMerchant.name = 'new Name for Merchant';
    postedMerchant.billing_street     = '2 Diagon Alley';
    postedMerchant.billing_city       = 'Orlando';
    postedMerchant.billing_country    = 'US';
    postedMerchant.billing_postal_code = '44444';
    postedMerchant.billing_state      = 'FL';
    postedMerchant.id = account.Id;

    // call the REST controller method
    S3MerchantAccount returnedMerchant = RESTs3API_MerchantAccount.merchant_account_POST( postedMerchant );

    // assertion
    System.assertEquals( 'new Name for Merchant', returnedMerchant.name );
  }

  static testMethod void testMerchantGETReturnsMerchantHavingNonNullIdWhenGivenValidAccountId() {

    // Given an account
    Account account = LibraryRESTControllerTestHelpers.buildAccount(); 
    insert account;

    // Set parameters on request
    RestRequest request = new RestRequest();
    request.params.put( 'salesforce_id', account.id );
    System.RestContext.request = request;
    
    // call controller method
    S3MerchantAccount returnedMerchant = RESTs3API_MerchantAccount.merchant_account_get();

    // assertion
    System.assertNotEquals( null, returnedMerchant.id );
  }
}