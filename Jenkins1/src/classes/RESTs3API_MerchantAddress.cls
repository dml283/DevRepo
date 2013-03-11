@RestResource(urlMapping='/v1.0/s3/address/*')
global class RESTs3API_MerchantAddress {
  
	@HttpPut
	global static S3MerchantAddress merchant_address_PUT( S3MerchantAddress address ){
	  address.do_upsert();
	  address.load();
	  return address;
	}	

	@HttpPost
	global static S3MerchantAddress merchant_address_POST( S3MerchantAddress address ){
	  address.do_upsert();
	  address.load();
	  return address;
	}
	
	@HttpGET
	global static S3MerchantAddress merchant_address_get() {
	   S3MerchantAddress merchantAddress = new S3MerchantAddress();
	   RestRequest req = RestContext.request;
	   RestResponse res = RestContext.response;
	   //lets check to see if the salesforce_id is part of the request 
	   if(req.params.containsKey('salesforce_id')){
	     system.debug(req.params.get('salesforce_id'));
	     merchantAddress.id = req.params.get('salesforce_id');
	   }
	   merchantAddress.load();
	
	   return merchantAddress;
	}
	
	@HttpDELETE
	global static String merchant_account_delete() {
		return '';
	} 

}