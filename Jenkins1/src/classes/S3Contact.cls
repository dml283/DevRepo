global class S3Contact {

	public String id {get;set;}
	
	public String first_name {get;set;}
	public String last_name {get;set;}
	public String phone {get;set;}
	public String email {get;set;}
	
	public List<DealWizardError> errors {get;set;}
    public Boolean has_errors {get; set;}
	
	public static final Map<String, String> sobject_to_json_field_map =
    	new Map<String, String>{
        'id'                  => 'id', 
      	'FirstName'           => 'first_name',
      	'LastName'            => 'last_name', 
      	'Phone'               => 'phone',
      	'Email'               => 'email'
    };
    
	public S3Contact() {
		this.has_errors = false;
	    this.errors = new List <DealWizardError>();	
	}
	
	public void do_upsert() {
    	Contact contact = this.get_sobject();

    	if ( contact != null ) { // case: the contact already exists
	      	try {
	      		contact.FirstName = this.first_name;
	      		contact.LastName = this.last_name;
	      		contact.Phone = this.phone;
	      		contact.Email = this.email;
		    }
	        catch ( Exception anException ) {
	        	this.add_and_log_exception_error( anException, 's3_contact', S3Contact.sobject_to_json_field_map );
	      	}
	
	      	// Upsert the Contact
	
	      	try {
	        	Database.upsertResult result = Database.upsert(contact);
	        	if (result.isSuccess()) {
	        		this.id = result.getId();	        	
	        	}
	      	}
	      	catch ( DMLException dml_exception ) {
	        	this.add_and_log_dml_exception_error( dml_exception, 's3_contact', S3Contact.sobject_to_json_field_map );
	      	}
	      	catch ( Exception anException ) {
	        	this.add_and_log_exception_error( anException, 's3_contact', S3Contact.sobject_to_json_field_map );
	      	}  
	    }
	}
	
	public void load(){
    	Contact contact = this.get_sobject();
    	this.id = contact.id;
	    this.first_name = contact.FirstName;
	    this.last_name = contact.LastName;
	    this.phone = contact.Phone;
	    this.email = contact.Email;    
	}

	public String get_query(){
		string query = 'SELECT id, FirstName, LastName, Phone, Email';
		query += ' FROM Contact';
		query += ' WHERE id = \''+this.id+'\'';
		return query;
	}

	public Contact get_sobject() {
		Contact contact;
    	if ( this.id != null && this.id != '' ) {
      		return Database.query( this.get_query() );
    	}
    	else {
      		return new contact();
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
    	if ( this.errors == null ) {
      		this.errors = new List <DealWizardError>();
    	}
    	this.errors.add( error_object );
    	this.has_errors = true;

    	error_object.log_error();
  	}
}