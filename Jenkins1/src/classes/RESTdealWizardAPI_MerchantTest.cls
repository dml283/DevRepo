@isTest
public class RESTdealWizardAPI_MerchantTest {

  // TODO: test a create request
  //static testMethod void testMerchantPOSTReturnsMerchantHavingNonNullIdWhenGivenValidCreateRequest() {
  //}


  static testMethod void testMerchantPOSTReturnsMerchantHavingNonNullIdWhenGivenValidUpdateRequest() {

    // Given an account
    Account account = DealWizardTestHelper.buildAccount(); 
    insert account;

    // Provide POST params as a basic DealWizardMerchant
    DealWizardMerchant postedMerchant = new DealWizardMerchant();
    postedMerchant.name = 'new Name for Merchant';
    postedMerchant.billing_street     = '2 Diagon Alley';
    postedMerchant.billing_city       = 'Orlando';
    postedMerchant.billing_country    = 'US';
    postedMerchant.billing_postal_code = '44444';
    postedMerchant.billing_state      = 'FL';
    postedMerchant.id = account.Id;

    // call the REST controller method
    DealWizardMerchant returnedMerchant = RESTdealWizardAPI_Merchant.merchant_POST( postedMerchant );

    // assertion
    System.assertEquals( 'new Name for Merchant', returnedMerchant.name );
  }

  static testMethod void testMerchantGETReturnsMerchantHavingNonNullIdWhenGivenValidAccountId() {

    // Given an account
    Account account = DealWizardTestHelper.buildAccount(); 
    insert account;

    // Set parameters on request
    RestRequest request = new RestRequest();
    request.params.put( 'salesforce_id', account.id );
    System.RestContext.request = request;
    
    // call controller method
    DealWizardMerchant returnedMerchant = RESTdealWizardAPI_Merchant.merchant_get();

    // assertion
    System.assertNotEquals( null, returnedMerchant.id );
  }
}