@RestResource(urlMapping='/v1.0/s3/contact/*')
global class RESTs3API_Contact {
  
	@HttpPUT
	global static S3Contact contact_PUT ( S3Contact contact ) {
		contact.do_upsert();
	  	contact.load();
	  	return contact;
	}
	
	@HttpPost
	global static S3Contact contact_POST( S3Contact contact ){
	  contact.do_upsert();
	  contact.load();
	  return contact;
	}
	
	@HttpGET
	global static S3Contact contact_get() {
	   S3Contact contact = new S3Contact();
	   RestRequest req = RestContext.request;
	   RestResponse res = RestContext.response;
	   //lets check to see if the salesforce_id is part of the request 
	   if(req.params.containsKey('salesforce_id')){
	     system.debug(req.params.get('salesforce_id'));
	     contact.id = req.params.get('salesforce_id');
	   }
	   
	   contact.load();
	
	   return contact;
	}
	
	@HttpDELETE
	global static String contact_delete() {
		return '';
	} 

}