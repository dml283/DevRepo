global class S3MerchantAddress {

	public String id {get;set;}

	public String account_id {get;set;}
	public String city {get;set;}
	public string country {get;set;}
	public String phone_number {get;set;}
	public String postal_code {get;set;}
	public String state {get;set;}
	public String street_line_1 {get;set;}
	public String street_line_2 {get;set;}
	public String venue_name {get;set;}
	
	public List<DealWizardError> errors {get;set;}
	public Boolean has_errors {get; set;}

  	public static final Map<String, String> sobject_to_json_field_map = new Map<String, String>{
      	// Fields in use
      	'Account__c'          => 'account_id', 
      	'City__c'             => 'city', 
      	'Country__c'          => 'country',
      	'id'                  => 'id', 
      	'Phone_Number__c'     => 'phone_number', 
      	'Zip_Postal_Code__c'  => 'postal_code', 
      	'State_Province__c'   => 'state', 
      	'Street_Line_1__c'    => 'street_line_1', 
      	'Street_Line_2__c'    => 'street_line_2', 
      	'Venue_Name__c'       => 'venue_name' 
    };

  	public S3MerchantAddress() {
  		this.has_errors = false;
		this.errors = new List <DealWizardError>();
  	}

	public void do_upsert() {
		Merchant_Addresses__c a = this.get_sobject();

	    if ( a != null ) { // case: the account already exists (this is the only case currently-supported)

    		try {
    			if ( this.id == null ) { // insert
    				a.Account__c = this.account_id;
    			}
	      		a.City__c = this.city;
	      		a.Country__c = this.country;
	      		a.Phone_Number__c = this.phone_number;
			    a.Zip_Postal_Code__c = this.postal_code;
			    a.State_Province__c = this.state;
			    a.Street_Line_1__c = this.street_line_1;
			    a.Street_Line_2__c = this.street_line_2;
			    a.Venue_Name__c = this.venue_name;
			}
		    catch ( Exception anException ) {
		    	this.add_and_log_exception_error( anException, 'merchant', S3MerchantAddress.sobject_to_json_field_map );
			}

			// Upsert the Merchant (Address)
			try {
				Database.upsertResult result = Database.upsert(a);
				if (result.isSuccess()) {
					this.id = result.getId();	        	
				}        
      		}
			catch ( DMLException dml_exception ) {
				this.add_and_log_dml_exception_error( dml_exception, 'merchant', S3MerchantAddress.sobject_to_json_field_map );
			}
			catch ( Exception anException ) {
				this.add_and_log_exception_error( anException, 'merchant', S3MerchantAddress.sobject_to_json_field_map );
			}
		}
	}

	public void load(){
	    Merchant_Addresses__c a = this.get_sobject();
	    this.id = a.id;
		this.account_id = a.Account__c;
		this.city = a.City__c;
		this.country = a.Country__c;
		this.phone_number = a.Phone_Number__c;
		this.postal_code = a.Zip_Postal_Code__c;
		this.state = a.State_Province__c;
		this.street_line_1 = a.Street_Line_1__c;
		this.street_line_2 = a.Street_Line_2__c;
		this.venue_name = a.Venue_Name__c;
	
	}

  	public String get_query(){
    	string query = 'SELECT id, Account__c, Street_Line_1__c, Street_Line_2__c, City__c, Zip_Postal_Code__c, State_Province__c, Country__c, Venue_Name__c, Phone_Number__c';
    	query += ' FROM Merchant_Addresses__c';
    	query += ' WHERE id = \''+this.id+'\'';
    	return query;
  	}

    public Merchant_Addresses__c get_sobject() {
		Merchant_Addresses__c a;
    	if ( this.id != null && this.id != '' ) {
	    	return Database.query( this.get_query() );
    	}
    	else {
      		return new Merchant_Addresses__c();
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