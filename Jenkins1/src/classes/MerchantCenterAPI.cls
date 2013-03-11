global class MerchantCenterAPI{

Merchant M;
Response r = new Response();

public Merchant getMerchant(){
    M = new Merchant(ApexPages.currentPage().getParameters().get('id'));
    return M;
}
public response getResponse(){
    return r;
}
public PageReference CreateMerchantCenter(){
    HttpRequest req = getMerchantCenterRequest();
    req.setBody(JSON.serialize(M));

    Http http = new Http();
    HTTPResponse res = http.send(req);

    r.rendered=true;
    if(res.getStatusCode()==200){
         MerchantCenterResponse responseMsg = (MerchantCenterResponse)JSON.deserialize(res.getBody(), MerchantCenterResponse.class);
         r.created = true;
         r.permalink = responseMsg.id;
         if(m.contacts.size()>=1){
             HttpRequest request_contact = getMerchantCenterContactRequest(responseMsg.id);
             request_contact.setBody(JSON.serialize(m.contacts[0]));
             HTTPResponse res_contact = http.send(request_contact);
             if(res_contact.getStatusCode()==200){
                 r.contacts_created=true;
                 r.successMsg.add(res_contact.getStatus());
             }else{
                      r.errorMsg.add(res_contact.getStatus());
                      System.debug('=============================='+res_contact.getBody());
                      r.contacts_created = false;
                      r.contacts_failed = true;
                      Map<String, Object> contact_response_json = (Map<String, Object>)JSON.deserializeUntyped(res_contact.getBody());
                      Map<String, Object> contact_merchant_json = (Map<String, Object>)contact_response_json.get('contact');
                      Map<String, Object> contact_errors_json = (Map<String, Object>)contact_merchant_json.get('errors');
                      for(string s : contact_errors_json.keySet()){
                         r.contactErrorMsg.add(string.ValueOf(contact_errors_json.get(s)));
                     }
             }
          }
     //responseMsg.addPermalink(m);        
     }else{
         r.errorMsg.add(res.getStatus());
         Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
         Map<String, Object> merchant_json = (Map<String, Object>)m.get('merchant');
         Map<String, Object> errors_json = (Map<String, Object>)merchant_json.get('errors');
         for(string s : errors_json.keySet()){
             r.errorMsg.add(string.ValueOf(errors_json.get(s)));
         }

         r.failed = true;
         r.created=false;
     }
    system.debug('========================='+r); 
    return null;
}
@Future(callout=true)
public static void createBulkMerchantCenter(set<string> ids){
    MerchantCenterAPI api = new MerchantCenterAPI();
    for(string s : ids){
      API.CreateMerchantCenter(s);
      }
}
public void CreateMerchantCenter(string theId){
    Merchant M = new Merchant(theId);
    Response r = new Response();

    HttpRequest req = getMerchantCenterRequest();
    req.setBody(JSON.serialize(M));

    Http http = new Http();
    HTTPResponse res = http.send(req);
    string accountId = [select accountid from opportunity where Id=:theId limit 1].accountId;
    if(res.getStatusCode()==200){
         MerchantCenterResponse responseMsg = (MerchantCenterResponse)JSON.deserialize(res.getBody(), MerchantCenterResponse.class);
         r.permalink = responseMsg.id;
         if(m.contacts.size()>=1){
             HttpRequest request_contact = getMerchantCenterContactRequest(responseMsg.id);
             request_contact.setBody(JSON.serialize(m.contacts[0]));
             HTTPResponse res_contact = http.send(request_contact);
             if(res_contact.getStatusCode()==200){
                 r.contacts_created=true;
                 r.successMsg.add(res_contact.getStatus());               
             }else{
                      r.errorMsg.add(res_contact.getStatus());
                      r.contacts_created = false;
                      r.contacts_failed = true;
                      Map<String, Object> contact_errors_json = new Map<String, Object>();
                      
                      Map<String, Object> contact_response_json = (Map<String, Object>)JSON.deserializeUntyped(res_contact.getBody());
                      system.debug('response body'+JSON.deserializeUntyped(res_contact.getBody()));
                      if(contact_response_json.containsKey('contact')){
                      Map<String, Object> contact_merchant_json = (Map<String, Object>)contact_response_json.get('contact');
                      if(contact_merchant_json.containsKey('errors')){
                          contact_errors_json = (Map<String, Object>)contact_merchant_json.get('errors');
                      }
                      if(contact_merchant_json.containsKey('error')){
                          contact_errors_json = (Map<String, Object>)contact_merchant_json.get('errors');
                      }  
                      for(string s : contact_errors_json.keySet()){
                         r.contactErrorMsg.add(string.ValueOf(contact_errors_json.get(s)));
                     }
                     }
             }
          }
    if(accountId!=null || accountId!=''){
             account a = new account(id=accountId );
             a.failed_merchant_center_creation__c=string.valueOf(r.errorMsg);
             database.update(a);
             }  
     responseMsg.addPermalink(m);        
     }else{
         r.errorMsg.add(res.getStatus());
         Map<String, Object> merch_resp = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
         Map<String, Object> merchant_json = (Map<String, Object>)merch_resp.get('merchant');
         Map<String, Object> errors_json = (Map<String, Object>)merchant_json.get('errors');
         for(string s : errors_json.keySet()){
             r.errorMsg.add(string.ValueOf(errors_json.get(s)));
         }

         r.failed = true;
         r.created=false;

         if(accountId!=null || accountId!=''){
         account a = new account(id=accountId );
         a.failed_merchant_center_creation__c=string.valueOf(r.errorMsg);
         database.update(a);
         }
     }
}
public HttpRequest getMerchantCenterRequest(){
         HttpRequest req = new HttpRequest();
         req.setEndpoint('https://api.groupon.com/v2/merchants/?client_id=192d6ae2391f82e9ba9a4b77d39f1eb3ac214bb2&access_token=77fd0c6da849497707ebf7c59e99131e8b067628e2a82565321b444860998e12');
         req.setMethod('POST');
         req.setHeader('content-type','application/json');
         return req;
}
public HttpRequest getMerchantCenterContactRequest(string permalink){
         HttpRequest req = new HttpRequest();
         req.setEndpoint('https://api.groupon.com/v2/merchants/'+permalink+'/contacts?client_id=192d6ae2391f82e9ba9a4b77d39f1eb3ac214bb2&access_token=77fd0c6da849497707ebf7c59e99131e8b067628e2a82565321b444860998e12');
         req.setMethod('POST');
         req.setHeader('content-type','application/json');
         req.setTimeout(30000);
         return req;
}

    global class Merchant{
        public string name {get;set;}
        public list <address> locations {get;set;}
        public id salesforce_account_id {get;set;}
        public string website{get;set;}
        public string facebook_url {get;set;}
        public string twitter_name {get;set;}
        public string remit_to {get;set;}
        public string remittance_address1{get;set;}
        public string remittance_address2{get;set;}
        public string remittance_city{get;set;}
        public string remittance_state{get;set;}
        public string remittance_zip{get;set;}
        public string remittance_country{get;set;}
        public string category {get;set;}
        public string category_2 {get;set;}
        public list<merchant_contact> contacts {get;set;}

        
        public merchant(string theId){
        map<string,string> categoryMap = new map<String,String>{'Beauty / Wellness / Healthcare' => 'Beauty & Spas', 'Leisure Offers / Activities' => 'Arts and Entertainment', 'Travel' => 'Travel','Tickets' => 'Tickets',  'Food & Drink' => 'Restaurants', 'Shopping' => 'Shopping', 'Services' => 'Services', 'Charity' => 'Professional Services'};
        opportunity o = [select Addtl_Email_List_To__c,Email_List_To__c,Merchant_name_in_write_up__c, accountid from opportunity where id = :theId LIMIT 1];
        account a = [select id, website, facebook_url__c, Category_v3__c,Subcategory_v3__c, Twitter_Handle__c, Make_Checks_Payable_to__c, BillingStreet,BillingCity, BillingState, BillingPostalCode, BillingCountry FROM account where id = :o.accountid LIMIT 1];
            this.name = o.Merchant_name_in_write_up__c;
            this.salesforce_account_id = a.id;
            this.website = a.website;
            this.facebook_url = a.Facebook_URL__c;
            this.twitter_name = a.Twitter_Handle__c;
            this.remit_to = a.Make_Checks_Payable_to__c;
            this.remittance_address1 = a.BillingStreet;
            this.remittance_city = a.BillingCity;
            this.remittance_state = a.BillingState;
            this.remittance_zip = a.BillingPostalCode;
            this.remittance_country = a.BillingCountry;
            if(categoryMap.containsKey(a.Category_v3__c)){
                this.category = categoryMap.get(a.Category_v3__c);
            }
            
            //this.category_2 = a.Subcategory_v3__c;
            this.contacts = new list<merchant_contact>();
            if(o.Email_List_To__c!='')contacts.add(new merchant_contact(o.Email_List_To__c, o.Merchant_name_in_write_up__c));
            this.locations = new list<Address>();
            for (merchant_addresses__c ma :[select Street_Line_1__c, Street_Line_2__c, city__c, state_province__c, zip_postal_code__c, venue_name__c, country__c, phone_number__c, id from merchant_addresses__c where account__c = :a.id AND city__c!=null AND state_province__c!=null AND zip_postal_code__c!=null]) {
                this.locations.add(new Address(ma));
            }
        }
    }
    
    public class Address{
        public string address1 {get;set;}
        public string address2 {get;set;}
        public string city {get;set;}
        public string state {get;set;}
        public string zip {get;set;}
        public string venue_name {get;set;}
        public string country {get;set;}
        public string phone_number {get;set;}
        public id salesforce_address_id {get;set;}
          
          public address(merchant_addresses__c m){
              this.address1 = m.Street_Line_1__c;
              this.address2 = m.Street_Line_2__c;
              this.city = m.city__c;
              this.state = m.state_province__c;
              this.zip = m.zip_postal_code__c;
              this.venue_name = m.venue_name__c;
              this.country = m.country__c;
              this.phone_number = m.phone_number__c;
              this.salesforce_address_id = m.id;
          }
           
    }
    public class merchant_contact{
        public string first_name {get;set;}
        public string last_name {get;set;}
        public string full_name {get;set;}
        public string phone {get;set;}
        public string email_address {get;set;}
        public id salesforce_id {get;set;}
        
        public merchant_contact(string email, string merch_name){
        contact c;
          try{
              c = [select id, firstname, email, lastName from Contact where email = :email LIMIT 1];
            }catch(exception e){system.debug(e);}
            if(c!=null){
               this.email_address = c.email;
               this.first_name = c.firstName;
               this.last_name = c.lastName;
            }else{
            this.email_address = email;
            this.first_name = merch_name;
            }
        }
        public merchant_contact(contact c){
            this.email_address = c.email;
            this.first_name = c.firstName;
            this.last_name = c.lastName;
        }
      
    }
    public class MerchantCenterResponse{
        public string id {get;set;}
        public id salesforce_id {get;set;}
        public void addPermalink(merchant m){
            Account A = new Account(id=m.salesforce_account_id,Merchant_Permalink__c='');
            a.Merchant_Permalink__c=id;
            database.update(a);
        }
    
    }
   public class response{
       public boolean rendered {get;set;}
       public boolean created {get;set;}
       public boolean failed {get;set;}
       public boolean contacts_created {get;set;}
       public boolean contacts_failed {get;set;}
       public string permalink {get;set;}
       public list<string> successMsg {get;set;}
       public list<string> errorMsg {get;set;}
       public list<string> contactErrorMsg {get;set;}
       public response(){this.rendered=false;this.errorMsg=new list<string>();this.successMsg=new list<string>();this.contactErrorMsg=new list<string>();}
   } 

static testMethod void MerchantCenterAPItest() {
    account a = new account();
        a.website='www.somewebsite';
        a.name='MerchantCetnerAPI test '+system.now();
        a.facebook_url__c='facebookurl';
        a.twitter_handle__c = 'Groupon';
        a.Make_Checks_Payable_to__c='GRoupon.com';
        a.BillingStreet='600 W Chicago';
        a.BillingCity='Chicago';
        a.BillingState='IL';
        a.BillingPostalCode='60652';
        a.BillingCountry='US';
    insert a;
    contact c = new Contact();
        c.email ='salesforce@groupon.com';
        c.firstName = 'Sales';
        c.lastName = 'Force';
    insert c;   
    Opportunity o = new opportunity();
        o.Addtl_Email_List_To__c='salesforce@groupon.com';
        o.Email_List_To__c='salesforce@groupon.com';
        o.Merchant_name_in_write_up__c='SalesforceTest'+system.now();
        o.Accountid = a.id;
        o.stageName='Prospecting';
        o.closeDate=system.today();
        o.name='MerchantCetnerAPI test '+system.now();
    insert o;
    merchant_addresses__c m = new merchant_addresses__c();
        m.Street_Line_1__c ='600 W Chicago';
        m.Street_Line_2__c='';
        m.city__c='Chicago';
        m.state_province__c='IL';
        m.zip_postal_code__c='60654';
        m.venue_name__c='River North';
        m.Country__c='US';
        m.phone_number__c='312-870-6223';
        m.Account__c = a.id;
    insert m;
    
    PageReference testPage = Page.CreateMerchantCenter;
    testPage.getParameters().put('id', o.id);
    Test.setCurrentPage(testPage);
    MerchantCenterAPI api = new MerchantCenterAPI();
    Merchant Test_Merchant = api.getMerchant();
    response resp = api.getResponse();
    api.CreateMerchantCenter(o.id);
    HttpRequest mc_req = api.getMerchantCenterRequest();
    HttpRequest mc_contact_req = api.getMerchantCenterContactRequest('sample-permalink');
}   
}