@isTest
public class DealWizardMerchantTest {

  // describe: Merchant class (146 lines; mostly tests other two classes)

    // describe: properties (setting)

    static DealWizardMerchant setup_merchant_for_persisted_account() {

      // Given an existing account
      Account subject_account = DealWizardTestHelper.buildAccount(); 
      insert subject_account;

      DealWizardMerchant subject_merchant = new DealWizardMerchant();
      //subject_merchant.account_number = subject_account.;
      subject_merchant.bank_name          = 'Gringotts';
      subject_merchant.billing_street     = subject_account.BillingStreet;
      subject_merchant.billing_city       = subject_account.BillingCity;
      subject_merchant.billing_country    = subject_account.BillingCountry;
      subject_merchant.billing_postal_code = subject_account.BillingPostalCode;
      subject_merchant.billing_state      = subject_account.BillingState;
      subject_merchant.category           = 'Services';
      //subject_merchant.settings =  
      subject_merchant.division           = 'Orlando';
      subject_merchant.errors             = new List<DealWizardError>();
      subject_merchant.id                 = subject_account.id;
      subject_merchant.make_checks_payable_to = 'Nicholas Flamel';
      //subject_merchant.merchant_addresses =
      //subject_merchant.merchant_attributes =
      subject_merchant.name               = 'Ollanders Wand Shop ' + DealWizardTestHelper.current_server_timestamp();
      subject_merchant.payment_preference = 'gold';
      subject_merchant.primary_service    = 'Custom-Matched Magical Wands';
      subject_merchant.routing_number     = '112233333';
      //subject_merchant.services_offered = 
      subject_merchant.subcategory        = 'Magical Items';
      subject_merchant.website            = 'www.ollanders.wiz';
      subject_merchant.why_not_ach        = 'hmm';

      return subject_merchant;
    }

    // describe: do_upsert (update)

      static testMethod void test_stored_merchant_has_no_errors_after_upsert() {
        DealWizardMerchant subject_merchant = DealWizardMerchantTest.setup_merchant_for_persisted_account();
        subject_merchant.do_upsert();
        System.assert( subject_merchant.errors.isEmpty() == true );
      }

      static testMethod void testStoredPropertiesAreRetrievable() {
        //DealWizardMerchant subject_merchant = DealWizardMerchantTest.setup_merchant_for_persisted_account();
        //subject_merchant.do_upsert();

        //DealWizardMerchant retrieved_merchant = new DealWizardMerchant();
        //retrieved_merchant.id = subject_merchant.id;
        //retrieved_merchant.load();
        //System.assert( 'Ollanders Wand Shop' == retrieved_merchant.name );
      }


      //static testMethod void testStoredSettingsAreRetrievable() {
      //}
      
      //static testMethod void testStoredAddressesAreRetrievable() {
      //}

      //static testMethod void testStoredMerchantAttributesAreRetrievable() {
      //}

      //static testMethod void testStoredServicesOfferedAreRetrievable() {
      //}

      // case: there was an error during upsert of the account

      static testMethod void test_stored_merchant_does_have_errors_after_upsert() {
        DealWizardMerchant subject_merchant = DealWizardMerchantTest.setup_merchant_for_persisted_account();
        subject_merchant.routing_number = '1234567890'; // case: too long by one digit
        subject_merchant.do_upsert();

        System.assert( subject_merchant.errors.size() >= 1 );
      }


    // describe: load()

    // describe: handle_error

    // describe: get_query

    // describe: get_sobject
      // TODO: also test case where account doesn't exist (or comment that out)


  // describe: config_settings class (27 lines)
 
  // describe: merchant_location class (39 lines)

}