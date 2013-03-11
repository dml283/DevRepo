global class S3MerchantAccount {

  public String id {get;set;}

  public String account_number {get;set;}
  public String bank_name {get;set;}
  public String billing_street {get;set;}
  public String billing_city {get;set;}
  public String billing_country {get;set;}
  public String billing_postal_code {get;set;}
  public String billing_state {get;set;}
  public String category {get;set;}
  public DealWizardMerchantConfigSettings config_settings {get;set;}
  public String division {get; set;}
  public String make_checks_payable_to {get;set;}
  public List <DealWizardMerchantLocation> merchant_addresses {get;set;}
  public List<string> merchant_attributes {get;set;}
  public String name {get;set;}
  public String payment_preference {get;set;}
  public String primary_service {get; set;}
  public String routing_number {get;set;}
  public List<string> services_offered {get;set;}
  public String subcategory {get;set;}
  public String website {get;set;}
  public String why_not_ach {get;set;}

  public List<DealWizardError> errors {get;set;}
  public Boolean has_errors {get; set;}
  
  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      // Fields in use
      'Account_Number__c'           => 'account_number', 
      'Bank_Name__c'                => 'bank_name',
      'BillingStreet'               => 'billing_street', 
      'BillingCity'                 => 'billing_city', 
      'BillingCountry'              => 'billing_country', 
      'BillingPostalCode'           => 'billing_postal_code',
      'BillingState'                => 'billing_state', 
      'Category_v3__c'              => 'category',
      'DivName__c'                  => 'division',
      'id'                          => 'id', 
      'Make_Checks_Payable_to__c'   => 'make_checks_payable_to', 
      'Merchant_Attributes__c'      => 'merchant_attributes',
      'Name'                        => 'name', 
      'Payment_Preference__c'       => 'payment_preference', 
      //primary_service
      'Routing_Number_enc__c'       => 'routing_number', 
      'Services_Offered__c'         => 'services_offered',  
      'Subcategory_v3__c'           => 'subcategory', 
      'Website'                     => 'website', 
      'Why_not_ACH__c'              => 'why_not_ach' 

      // Collections / Children //
      //merchant_addresses 
      
      // READ-ONLY //
      //config_settings 
    };

  public S3MerchantAccount() {
    this.has_errors = false;
    this.errors = new List <DealWizardError>();
    this.merchant_addresses = new List<DealWizardMerchantLocation>();
    this.merchant_attributes = new List<String>();
    this.services_offered = new List<String>();
  }

  public void do_upsert() {
    Account a = this.get_sobject();

    if ( a != null ) { // case: the account already exists (this is the only case currently-supported)

      try {
      	  a.website = this.website;
	      a.BillingStreet = this.billing_street;
	      a.BillingCity = this.billing_city;
	      a.Category_v3__c = this.category;
	      a.BillingCountry = this.billing_country;
	      a.BillingPostalCode = this.billing_postal_code;
	      a.BillingState = this.billing_state;
	      a.Make_Checks_Payable_to__c = this.make_checks_payable_to;
	      a.Payment_Preference__c = this.payment_preference;
	      a.Why_not_ACH__c = this.why_not_ach;
	      a.Routing_Number_enc__c = this.routing_number;
	      a.Account_Number__c = this.account_number;
	      a.Bank_Name__c = this.bank_name;
	      a.name = this.name;
	      a.Subcategory_v3__c = this.subcategory;
	
	      if(this.services_offered!=null){
	         a.Services_Offered__c='';
	         for(string s : this.services_offered){
	            a.Services_Offered__c += s +' | ';
	         }
	      }
	
	      if(this.merchant_attributes!=null){
	         a.Merchant_Attributes__c='';
	         for(string s : this.merchant_attributes){
	            a.Merchant_Attributes__c += s +' | ';
	         } 
	      }    
      }
      catch ( Exception anException ) {
         this.add_and_log_exception_error( anException, 'merchant', S3MerchantAccount.sobject_to_json_field_map );
      }

      // Upsert the Merchant (Account)

      try {
        Database.upsertResult result = Database.upsert(a);
    	if (result.isSuccess()) {
 			this.id = result.getId();	        	
    	}        
      }
      catch ( DMLException dml_exception ) {
        this.add_and_log_dml_exception_error( dml_exception, 'merchant', S3MerchantAccount.sobject_to_json_field_map );
      }
      catch ( Exception anException ) {
        this.add_and_log_exception_error( anException, 'merchant', S3MerchantAccount.sobject_to_json_field_map );
      }

  
      // Upsert Merchant Locations (Addresses)
      if (this.merchant_addresses!=null) {
        List<Merchant_Addresses__c> merchant_addresses_to_save = new List<Merchant_Addresses__c>();
        for (DealWizardMerchantLocation ml : this.merchant_addresses) {
          try {
            merchant_addresses_to_save.add( ml.get_sobject() );
          }
          catch ( Exception anException ) {
            this.add_and_log_exception_error( anException, 'merchant_addresses', S3MerchantAccount.sobject_to_json_field_map );
          }
        }
        //DealWizardMerchantLocation.upseƒrt_specified( merchant_addresses_to_save, this );
      }
    }
  }

  public void load(){
    Account a = this.get_sobject();
    this.id = a.id;
    this.category = a.Category_v3__c;
    this.config_settings = new DealWizardMerchantConfigSettings();
    this.website = a.website;
    this.name = a.name;
    this.division = a.DivName__c;
    this.subcategory = a.Subcategory_v3__c;
    this.account_number = a.Account_Number__c;
    this.routing_number = a.Routing_Number_enc__c;
    this.billing_street = a.BillingStreet;
    this.billing_city = a.BillingCity;
    this.billing_country = a.BillingCountry;
    this.billing_postal_code = a.BillingPostalCode;
    this.billing_state = a.BillingState;
    this.make_checks_payable_to = a.Make_Checks_Payable_to__c;
    this.payment_preference = a.Payment_Preference__c;
    this.why_not_ach = a.Why_not_ACH__c;
    this.bank_name = a.Bank_Name__c;
    this.services_offered = new list<string>();
    this.merchant_attributes = new list<string>();

    if(a.Services_Offered__c !=null){
      list<string> services = a.Services_Offered__c.split('\\|');
      for(string s: services){
        this.services_offered.add(s);
      }
    }
    if(a.Merchant_Attributes__c !=null){
      list<string> attributes = a.Merchant_Attributes__c.split('\\|');
      for(string s: attributes){
        this.merchant_attributes.add(s);
      }
    }
    if(a.Merchant_Addresses__r !=null){
      this.merchant_addresses = new list<DealWizardMerchantLocation>();
      for(Merchant_Addresses__c ma : a.Merchant_Addresses__r){
        this.merchant_addresses.add(new DealWizardMerchantLocation(ma));
      }
    }
  }

  ////////
  // TODO: why is Merchant_Addresses__r used here but Merchant_Addresses__c used elsewhere in this class and in DealWizardMerchantLocation ?  See usage within same line inside get_values()
  ////////
  public String get_query(){
    string query = 'SELECT id, name, DivName__c, BillingStreet, BillingCity, Category_v3__c, Subcategory_v3__c, Merchant_Attributes__c, Services_Offered__c, BillingCountry, website, Routing_Number_enc__c, Bank_Name__c, Account_Number__c, BillingPostalCode, BillingState, Make_Checks_Payable_to__c, Payment_Preference__c, Why_not_ACH__c ';
    query+=' , (SELECT id,account__c, Street_Line_1__c, Street_Line_2__c, city__c, Zip_Postal_Code__c, State_Province__c, Country__c, Venue_Name__c, Phone_Number__c FROM Merchant_Addresses__r)';
    query +=' FROM ACCOUNT ';
    query +='WHERE id = \''+this.id+'\'';
    return query;
  }

  public Account get_sobject() {
    Account a;
    if ( this.id != null && this.id != '' ) {

      return Database.query( this.get_query() );
    }
    else {
      return new account();
    }
  }

  public void add_and_log_dml_exception_error( DMLException dml_exception, String attempted_json_object_type, Map<String,String> attempted_sobject_to_json_field_map ) {

    List<DealWizardError> error_objects = DealWizardError.extract_errors( dml_exception, attempted_json_object_type, attempted_sobject_to_json_field_map );
    
    for ( DealWizardError error_object : error_objects ) {
	    add_and_log_error( error_object );
    }
  }

  public void add_and_log_exception_error( Exception an_exception, String attempted_json_object_type, Map<String,String> attempted_sobject_to_json_field_map ) {

    DealWizardError error_object = new DealWizardError( an_exception, attempted_json_object_type, attempted_sobject_to_json_field_map );

    add_and_log_error( error_object );
  }

  public void add_and_log_error( DealWizardError error_object ) {
    // TODO: find another way to initialize the list outside this if block; had problems when tried this before
    if ( this.errors == null ) {
      this.errors = new List <DealWizardError>();
    }
    this.errors.add( error_object );
    this.has_errors = true;

    error_object.log_error();
  }

}