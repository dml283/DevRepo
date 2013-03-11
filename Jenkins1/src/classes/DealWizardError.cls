global class DealWizardError {

  public String attempted_field {get; set;}
  public Integer attempted_json_object_position_in_request {get; set;}
  public String attempted_json_object_type {get; set;}
  public String attempted_sobject_id {get; set;}
  //public String attempted_value {get; set;}
  public String error_code {get; set;}
  public String error_description {get; set;}
  public String stack_trace {get; set;}
  public String exception_type {get; set;}
  public DealWizardError(){}
  //public List<DealWizardError> multiple_errors

  //Database.Error
  public DealWizardError ( Database.Error database_error ) {
    initialize();

    for ( String error_field : database_error.fields ) {
      Map<String, String> sobject_to_json_field_map =  DealWizardMerchantAddress.sobject_to_json_field_map;

      if ( this.attempted_field == null ) {
        this.attempted_field = convert_field_name_with_map( sobject_to_json_field_map, error_field );
      } else {
        this.attempted_field += ', ' + convert_field_name_with_map( sobject_to_json_field_map, error_field );
      }
    }
    this.error_code = String.valueOf( database_error.statusCode );
    this.error_description = database_error.message;
  }

  // DMLException
  public DealWizardError( DMLException anException, Integer failed_sobject_result_index, String attempted_json_object_type_reported, Map<String, String> sobject_to_json_field_map ) {
    initialize();
    this.error_description = anException.getMessage();
    this.attempted_json_object_type = attempted_json_object_type_reported;
    this.attempted_sobject_id = anException.getDmlId(failed_sobject_result_index);
    this.stack_trace = anException.getStackTraceString();
    this.exception_type = anException.getTypeName();

    // case: single error
    Integer failed_field_index = 0;
    if ( !anException.getDmlFieldNames(failed_sobject_result_index).isEmpty() ) {
      String sobject_field_name = anException.getDmlFieldNames( failed_sobject_result_index )[ failed_field_index ];
      this.attempted_field = convert_field_name_with_map( sobject_to_json_field_map, sobject_field_name );
    }
    this.attempted_json_object_position_in_request = anException.getDmlIndex( failed_sobject_result_index );
    //this.attempted_value = anException;
    this.error_code = String.valueOf( anException.getDmlType( failed_sobject_result_index ) );
  }
  
  // Exception
  public DealWizardError( Exception anException, String attempted_json_object_type_reported, Map<String, String> sobject_to_json_field_map ) {
    initialize();

    this.attempted_json_object_type = attempted_json_object_type_reported;

    this.error_description = anException.getMessage();
    this.stack_trace = anException.getStackTraceString();
    this.exception_type = anException.getTypeName();
  }

  private void initialize() {
    //attempted_json_object_type = '';
    //attempted_field = '';
    //error_description = '';
  }
  
  public static List<DealWizardError> extract_errors( DMLException dml_exception, String attempted_json_object_type_reported, Map<String, String> sobject_to_json_field_map ) {
    List<DealWizardError> extracted_errors = new List<DealWizardError>();
    
    for (Integer result_index = 0; result_index < dml_exception.getNumDml(); result_index++) { // for each failed sobject
        DealWizardError error_object = new DealWizardError( dml_exception, result_index, attempted_json_object_type_reported, sobject_to_json_field_map );
        extracted_errors.add( error_object );
        
        // for each failed field on that object
          // add as a separate error
    }
    return extracted_errors;
  }

  public static Set<Integer> extract_positions( List<DealWizardError> deal_wizard_errors ) {
    Set<Integer> positions = new Set<Integer>();
    
    if ( !deal_wizard_errors.isEmpty() ) {

      for (DealWizardError deal_wizard_error : deal_wizard_errors) {
        Integer candidate_position = deal_wizard_error.attempted_json_object_position_in_request;

        if ( !positions.contains( candidate_position ) )
        positions.add( candidate_position );
      }
    }
    return positions;
  }

  public static List<DealWizardError> find_errors_for_json_object_type( List<DealWizardError> deal_wizard_errors, String json_object_type ) {

    List<DealWizardError> errors_for_type = new List<DealWizardError>();

    if ( deal_wizard_errors != null && !deal_wizard_errors.isEmpty() ) {

      for (DealWizardError deal_wizard_error : deal_wizard_errors) {

        if ( deal_wizard_error.attempted_json_object_type == json_object_type ) {

          errors_for_type.add( deal_wizard_error );
        }
      }
    }
    return errors_for_type;
  }

  private String convert_field_name_with_map(Map<String, String> field_name_map, String field_name){
    if ( field_name_map.containsKey( field_name ) ) {
      return field_name_map.get( field_name );
    } else {
      return field_name + ' (ADD TO MAP)';
    }
  }


  public void log_error() {
    System.debug( '  ===== DealWizardError =====  ' );
    System.debug( attempted_json_object_type );
    System.debug( attempted_sobject_id );
    System.debug( attempted_field );
    System.debug( error_code );
    System.debug( error_description );
    System.debug( stack_trace );
  }

}