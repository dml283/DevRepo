@RestResource(urlMapping='/v1.0/s3/account/*')
global class RESTs3API_MerchantAccount {
  
	@HttpPut
	global static S3MerchantAccount merchant_account_PUT( S3MerchantAccount merchant ){
	  merchant.do_upsert();
	  merchant.load();
	  return merchant;
	}   
  
	@HttpPost
	global static S3MerchantAccount merchant_account_POST( S3MerchantAccount merchant ){
	  merchant.do_upsert();
	  merchant.load();
	  return merchant;
	}
	
	@HttpGET
	global static S3MerchantAccount merchant_account_get() {
	   S3MerchantAccount merchantAccount = new S3MerchantAccount();
	   RestRequest req = RestContext.request;
	   RestResponse res = RestContext.response;
	   //lets check to see if the salesforce_id is part of the request 
	   if(req.params.containsKey('salesforce_id')){
	     system.debug(req.params.get('salesforce_id'));
	     merchantAccount.id=req.params.get('salesforce_id');
	   }
	   merchantAccount.load();
	
	   return merchantAccount;
	}

	@HttpDELETE
	global static String merchant_account_delete() {
		return '';
	} 


}