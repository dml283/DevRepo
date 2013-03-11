// DEPRECATED:  see DealWizardMerchant
//
global class dealWizardAPI_merchant {
//
//  global class merchant {
//
//    public String account_number {get;set;}
//    public String bank_name {get;set;}
//    public String billing_street {get;set;}
//    public String billing_city {get;set;}
//    public String billing_country {get;set;}
//    public String billing_postal_code {get;set;}
//    public String billing_state {get;set;}
//    public String category {get;set;}
//    public Config_settings config_settings {get;set;}
//    public String division {get; set;}
//    public List<string> errors {get;set;}
//    public String id {get;set;}
//    public String make_checks_payable_to {get;set;}
//    public List <merchant_location> merchant_addresses {get;set;}
//    public List<string> merchant_attributes {get;set;}
//    public String name {get;set;}
//    public String payment_preference {get;set;}
//    public String primary_service {get; set;}
//    public String routing_number {get;set;}
//    public List<string> services_offered {get;set;}
//    public String subcategory {get;set;}
//    public String website {get;set;}
//    public String why_not_ach {get;set;}
//    
//    public void do_upsert(){
//      account a = this.get_sobject();
//
//      a.website = this.website;
//      a.BillingStreet = this.billing_street;
//      a.BillingCity = this.billing_city;
//      a.Category_v3__c = this.category;
//      a.BillingCountry = this.billing_country;
//      a.BillingPostalCode = this.billing_postal_code;
//      a.BillingState = this.billing_state;
//      a.Make_Checks_Payable_to__c = this.make_checks_payable_to;
//      a.Payment_Preference__c = this.payment_preference;
//      a.Why_not_ACH__c = this.why_not_ach;
//      a.Routing_Number_enc__c = this.routing_number;
//      a.Account_Number__c = this.account_number;
//      a.Bank_Name__c = this.bank_name;
//      a.name = this.name;
//      a.Subcategory_v3__c = this.subcategory;
//      if(this.services_offered!=null){
//        a.Services_Offered__c='';
//        for(string s : this.services_offered){
//          a.Services_Offered__c += s +' | ';
//        } 
//      }
//      if(this.merchant_attributes!=null){
//        a.Merchant_Attributes__c='';
//        for(string s : this.merchant_attributes){
//          a.Merchant_Attributes__c += s +' | ';
//        } 
//      }    
//      try{
//        database.upsert(a);
//      }catch(exception e){
//        if(this.errors==null){
//          this.errors = new list<string>();
//          this.errors.add(string.valueof(e));
//        }else{
//          this.errors.add(string.valueof(e));
//        }
//      }
//      try{
//        if(this.merchant_addresses!=null){
//          list<Merchant_Addresses__c> merchant_addresses = new list<Merchant_Addresses__c>();
//          for(merchant_location ml : this.merchant_addresses){
//            merchant_addresses.add(ml.get_sobject());
//          }
//          database.upsert(merchant_addresses);
//        }
//      }catch(exception e){
//          if(this.errors==null){
//            this.errors = new list<string>();
//            this.errors.add(string.valueof(e));
//          }else{
//            this.errors.add(string.valueof(e));
//          }
//      }
//    }
//
//    public void get_values(){
//      account a = this.get_sobject();
//      system.debug(a);
//      this.id = a.id;
//      this.category = a.Category_v3__c;
//      this.config_settings = new config_settings();
//      this.website = a.website;
//      this.name = a.name;
//      this.division = a.DivName__c;
//      this.subcategory = a.Subcategory_v3__c;
//      this.account_number = a.Account_Number__c;
//      this.routing_number = a.Routing_Number_enc__c;
//      this.billing_street = a.BillingStreet;
//      this.billing_city = a.BillingCity;
//      this.billing_country = a.BillingCountry;
//      this.billing_postal_code = a.BillingPostalCode;
//      this.billing_state = a.BillingState;
//      this.make_checks_payable_to = a.Make_Checks_Payable_to__c;
//      this.payment_preference = a.Payment_Preference__c;
//      this.why_not_ach = a.Why_not_ACH__c;
//      this.bank_name = a.Bank_Name__c;
//      this.services_offered = new list<string>();
//      this.merchant_attributes = new list<string>();
//
//      if(a.Services_Offered__c !=null){
//        list<string> services = a.Services_Offered__c.split('\\|');
//        for(string s: services){
//          this.services_offered.add(s);
//        }
//      }
//      if(a.Merchant_Attributes__c !=null){
//        list<string> attributes = a.Merchant_Attributes__c.split('\\|');
//        for(string s: attributes){
//          this.merchant_attributes.add(s);
//        }
//      }
//      if(a.Merchant_Addresses__r !=null){
//        this.merchant_addresses = new list<merchant_location>();
//        for(Merchant_Addresses__c ma : a.Merchant_Addresses__r){
//          this.merchant_addresses.add(new merchant_location(ma));
//        }
//      }
//    }
//
//    public string get_query(){
//      string query = 'SELECT id, name, DivName__c, BillingStreet, BillingCity, Category_v3__c, Subcategory_v3__c, Merchant_Attributes__c, Services_Offered__c, BillingCountry, website, Routing_Number_enc__c, Bank_Name__c, Account_Number__c, BillingPostalCode, BillingState, Make_Checks_Payable_to__c, Payment_Preference__c, Why_not_ACH__c ';
//      query+=' , (SELECT id,account__c, Street_Line_1__c, Street_Line_2__c, city__c, Zip_Postal_Code__c, State_Province__c, Venue_Name__c, Phone_Number__c FROM Merchant_Addresses__r)';
//      query +=' FROM ACCOUNT ';
//      query +='WHERE id = \''+this.id+'\'';
//      return query;
//    }
//
//    public account get_sobject(){
//      account a;
//      if ( this.id != null && this.id != '' ) {
//        a = database.query(this.get_query());
//      }else{
//        a = new account();
//      }
//      return a;
//    }
//
//  }
//
//  public class config_settings {
//    public List<String> why_not_ach_options  {get;set;}
//    public List<String> payment_preference_options {get;set;}
//
//    public config_settings() {
//      Schema.DescribeFieldResult field;
//      List<Schema.PicklistEntry> picklist_values;
//
//      //why_not_ach_options
//      this.why_not_ach_options = new list<string>();
//      field = Account.Why_not_ACH__c.getDescribe();
//      picklist_values = field.getPicklistValues();
//      for (Schema.PicklistEntry f : picklist_values) {
//        this.why_not_ach_options.add(f.getLabel());
//      }            
//
//      // payment_preference_options
//      this.payment_preference_options = new list<string>();
//      field = Account.Payment_Preference__c.getDescribe();
//      picklist_values = field.getPicklistValues();
//
//      for (Schema.PicklistEntry f : picklist_values) {
//        if ( f.getLabel() != 'Wire' ) { // NOTE: exclude Wire payment method as an option, based on Business rule
//          this.payment_preference_options.add( f.getLabel() );
//        }
//      }
//    }
//  }
//
//  public class merchant_location {
//    public string street_line_1 {get;set;}
//    public string street_line_2 {get;set;}
//    public string city {get;set;}
//    public string postal_code {get;set;}
//    public string state {get;set;}
//    public string venue_name {get;set;}
//    public id account_id {get;set;}
//    public id id {get;set;}
//    public string phone_number {get;set;}
//    
//    public Merchant_Addresses__c get_sobject() {
//      Merchant_Addresses__c addy;
//      if (this.id != null && this.id != '') { // case: find existing addresses
//        addy = new Merchant_Addresses__c(id=this.id, account__c = this.account_id);
//      }else{
//        addy = new Merchant_Addresses__c(account__c = this.account_id);
//      }
//      addy.Street_Line_1__c = this.street_line_1;
//      addy.Street_Line_2__c = this.street_line_2;
//      addy.city__c = this.city;
//      addy.Zip_Postal_Code__c = this.postal_code;
//      addy.State_Province__c = this.state;
//      addy.Venue_Name__c = this.venue_name;
//      addy.Phone_Number__c = this.phone_number;
//      return addy;
//    }
//
//    public merchant_location(Merchant_Addresses__c addy) {
//      this.id = addy.id;
//      this.account_id = addy.Account__c;
//      this.street_line_1 = addy.Street_Line_1__c;
//      this.street_line_2 = addy.Street_Line_2__c;
//      this.city = addy.city__c;
//      this.postal_code = addy.Zip_Postal_Code__c;
//      this.state = addy.State_Province__c;
//      this.venue_name = addy.Venue_Name__c;
//      this.phone_number = addy.Phone_Number__c;
//    }
//  }  
//
}