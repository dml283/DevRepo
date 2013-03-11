@isTest
public class DealWizardRESTMerchantAddressTest {

  static Account setupMerchant() {
    Account merchant = DealWizardTestHelper.buildAccount();
    insert merchant;
    return merchant;
  }

  //context #merchant_address
  	//describe merchant address endpoint creates new address
		  static testMethod void creates_new_address() {
		  	Account merchant = setupMerchant();
				Merchant_Addresses__c new_merchant_address = DealWizardTestHelper.buildMerchantAddress(merchant.id);
		    System.RestContext.request = new RestRequest();
  			System.RestContext.response = new RestResponse();
		    RestContext.request.params.put('salesforce_id', '');

				DealWizardMerchantAddress new_deal_wizard_merchant_address = new DealWizardMerchantAddress(new_merchant_address);

				DealWizardMerchantAddress returnedMerchantAddress = DealWizardRESTMerchantAddress.create(new_deal_wizard_merchant_address);
				System.assertEquals( 'Thunderdome', returnedMerchantAddress.venue_name );
			}

		  static testMethod void returns_errors_on_create() {
		  	Account merchant = setupMerchant();
				Merchant_Addresses__c new_merchant_address = DealWizardTestHelper.buildMerchantAddress(merchant.id);
				new_merchant_address.Zip_Postal_Code__c = '99999999999999999999999999999999999999999999999';
		    System.RestContext.request = new RestRequest();
  			System.RestContext.response = new RestResponse();
		    RestContext.request.params.put('salesforce_id', '');

				DealWizardMerchantAddress new_deal_wizard_merchant_address = new DealWizardMerchantAddress(new_merchant_address);

				DealWizardMerchantAddress returnedMerchantAddress = DealWizardRESTMerchantAddress.create(new_deal_wizard_merchant_address);
				System.assertEquals( false, returnedMerchantAddress.errors.isEmpty() );
			}

  	//describe merchant address endpoint updates existing address
		  static testMethod void updates_existing_address() {
		  	Account merchant = setupMerchant();
				Merchant_Addresses__c merchant_address = DealWizardTestHelper.buildMerchantAddress(merchant.id);
				insert merchant_address;
		    System.RestContext.request = new RestRequest();
  			System.RestContext.response = new RestResponse();
		    RestContext.request.params.put('salesforce_id', merchant_address.id);
				String new_venue_name = 'Constantinople';
				merchant_address.Venue_Name__c = new_venue_name;
				DealWizardMerchantAddress updated_deal_wizard_merchant_address = new DealWizardMerchantAddress(merchant_address);

				DealWizardMerchantAddress returnedMerchantAddress = DealWizardRESTMerchantAddress.create(updated_deal_wizard_merchant_address);
				System.assertEquals( new_venue_name, returnedMerchantAddress.venue_name );
			}
}