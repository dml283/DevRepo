@RestResource(urlMapping='/v1.0/wizard/merchant/merchant_address')
global class DealWizardRESTMerchantAddress {

  @HttpPost
  global static DealWizardMerchantAddress create(DealWizardMerchantAddress address) {
		return address.save();
	}
}