@RestResource(urlMapping='/v1.0/wizard/merchant')
global class RESTdealWizardAPI_Merchant {
  
	@HttpPost
	global static DealWizardMerchant merchant_POST( DealWizardMerchant merchant ){
	  merchant.do_upsert();
	  merchant.load();
	  return merchant;
	}
	
	@HttpGET
	global static DealWizardMerchant merchant_get() {
	   DealWizardMerchant merchant = new DealWizardMerchant();
	   RestRequest req = RestContext.request;
	   RestResponse res = RestContext.response;
	   //lets check to see if the salesforce_id is part of the request 
	   if(req.params.containsKey('salesforce_id')){
	     system.debug(req.params.get('salesforce_id'));
	     merchant.id=req.params.get('salesforce_id');
	   }
	   merchant.load();
	
	   return merchant;
	}

}