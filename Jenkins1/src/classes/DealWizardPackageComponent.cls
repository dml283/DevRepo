public class DealWizardPackageComponent {

  public String description {get; set;}
  public String id {get; set;}
  public String option_id {get; set;}
  public Decimal value {get; set;}

  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      'description__c' => 'description',
      'id' => 'id',                   // correct?
      'Multi_Deal__c' => 'option_id', // correct?
      'value__c' => 'value'
    };

  // class methods

  // TODO: simpler implementation possible in Apex (to find single not List); otherwise, eliminate duplication of find_all_for
  //public static List<DealWizardPackageComponent> find_by_id( String component_id ) {

  //  DealWizardPackageComponent package_component = new List<DealWizardPackageComponent>();

  //  List<Package_Component__c> component_sobjects_for_option = [select id, description__c, value__c, Multi_Deal__c from Package_Component__c where id = :component_id];

  //  for (Package_Component__c component_sobject : component_sobjects_for_option) {
  //    components.add( new DealWizardPackageComponent( component_sobject ) );
  //  }
  //  return components;
  //}

  //public static List<DealWizardPackageComponent> find_all_for( DealWizardDealOption deal_option ) {

  //  List<DealWizardPackageComponent> components = new List<DealWizardPackageComponent>();
  //  List<Package_Component__c> component_sobjects_for_option = [select id, description__c, value__c, Multi_Deal__c from Package_Component__c where Multi_Deal__c = :deal_option.id];

  //  for (Package_Component__c component_sobject : component_sobjects_for_option) {
  //    components.add( new DealWizardPackageComponent( component_sobject ) );
  //  }
  //  return components;
  //}

  public static Boolean persist_all_specified_and_delete_all_excluded( DealWizardDealOption deal_option, DealWizardDeal deal ) {
  	Boolean all_components_saved = true;
  	Boolean some_component_saves_failed = false;

    //DealWizardPackageComponent.create_or_update_all_for_deal_option( deal_option, deal );
    //DealWizardPackageComponent.delete_all_unspecified_on_deal_option( deal_option, deal );

    Set<Id> ids_of_components_to_persist = new Set<Id>();
    List<package_component__c> all_components_as_sobjects = new List<package_component__c>();
      
    if ( deal_option.package_components !=null && deal_option.package_components.size() > 0 ) {
    	
      for ( DealWizardPackageComponent pc : deal_option.package_components ) {

        if ( pc.id != null ) { // identifies components specified in request that already exist in database
          ids_of_components_to_persist.add( pc.id );
        }
        if ( LibraryString.exists_and_is_not_blank( deal_option.id ) ) {
          pc.option_id = deal_option.id;	
        }
        all_components_as_sobjects.add( pc.build_sobject() ); // adds each component specified in the request
      }
    }         

    // delete package components
    List<package_component__c> components_to_delete = [select id from package_component__c where id not in :ids_of_components_to_persist AND Multi_Deal__c = :deal_option.id];
    DealWizardPackageComponent.delete_multiple( components_to_delete, deal_option, deal );

    // create/upsert package components
    if ( !DealWizardPackageComponent.upsert_multiple( all_components_as_sobjects, deal_option, deal ) ) {
    	return some_component_saves_failed;
    }
    return all_components_saved;
  }

  //public static void create_or_update_all_for_deal_option( DealWizardDealOption deal_option, DealWizardDeal deal ) {

  //  //List<Package_Component__c> components_as_sobjects = new List<Package_Component__c>();

  //  //// TODO: consider moving the iteration up to the persist_all method, so this becomes a 'create/update one component'
  //  //if ( deal_option.package_components != null ) {

  //  //  for ( DealWizardPackageComponent component : deal_option.package_components ) {
  //  //    // TODO: extract as a generalized logging mechanism
  //  //    System.debug( '********* package component (id on option_id): ' + component.id + ' ' + component.option_id + ';  description: ' + component.description + ' **********' );

  //  //    components_as_sobjects.add( component.build_sobject() );
  //  //  }
  //  //}

  //  //DealWizardPackageComponent.upsert_multiple( all_components_as_sobjects, deal );
  //}

  //public static void delete_all_unspecified_on_deal_option( DealWizardDealOption deal_option, DealWizardDeal deal ) {

  //  //Set<Id> ids_for_specified_existing_package_components = new Set<id>();

  //  //if ( deal_option.package_components != null ) {

  //  //  for ( DealWizardPackageComponent component : deal_option.package_components ) {

  //  //    if ( LibraryObject.is_present( component.id ) ) {
  //  //      ids_for_specified_existing_package_components.add( component.id );
  //  //    }
  //  //  }
  //  //}
  //  //List< Package_Component__c > components_to_delete = [ select id from Package_Component__c where id not in : ids_for_specified_existing_package_components AND Multi_Deal__c = : deal_option.id ];

  //  //DealWizardPackageComponent.delete_multiple( components_to_delete, deal );
  //}


  private static Boolean upsert_multiple( List<package_component__c> components, DealWizardDealOption deal_option, DealWizardDeal deal ) {
  	Boolean all_components_saved = true;
  	Boolean some_component_saves_failed = false;
  	
    try {
      Database.upsert( components );
    }
    catch ( DMLException anException ) {
      //String error_location = 'error while upserting package components for a DealWizardOption';
      //String error_message_item = error_location + string.valueOf( anException );
      add_and_log_dml_exception_error( anException, 'package_components', deal_option, deal ); // 'DealWizardPackageComponent', (error_message_item + ' create/update all for deal option') );
      return some_component_saves_failed;
    }
    catch ( Exception anException ) {
      add_and_log_exception_error( anException, 'package_components', deal_option, deal );
      return some_component_saves_failed;
    }
    return all_components_saved;
  }

  private static void delete_multiple( List<package_component__c> components, DealWizardDealOption deal_option, DealWizardDeal deal ) {
    try {
      Database.delete( components );
    }
    catch ( DMLException anException ) {
      add_and_log_dml_exception_error( anException, 'package_components', deal_option, deal ); //, 'DealWizardPackageComponent', 'delete specified package components for deal option' );
    }
    catch ( Exception anException ) {
      add_and_log_exception_error( anException, 'package_components', deal_option, deal );
    }
  }

  private static void add_and_log_dml_exception_error( DMLException dml_exception, String attempted_json_object_type, DealWizardDealOption deal_option, DealWizardDeal deal ) {

    List<DealWizardError> error_objects = DealWizardError.extract_errors( dml_exception, attempted_json_object_type, DealWizardPackageComponent.sobject_to_json_field_map );
    
    for ( DealWizardError error_object : error_objects ) {
        DealWizardPackageComponent.add_and_log_error( error_object, deal_option, deal );
    }
  }

  private static void add_and_log_exception_error( Exception anException, String attempted_json_object_type, DealWizardDealOption deal_option, DealWizardDeal deal ) {

    DealWizardError error_object = new DealWizardError( anException, attempted_json_object_type, DealWizardPackageComponent.sobject_to_json_field_map );

    DealWizardPackageComponent.add_and_log_error( error_object, deal_option, deal );
  }

  private static void add_and_log_error( DealWizardError error_object, DealWizardDealOption deal_option, DealWizardDeal deal ) {
    // TODO: find another way to initialize the list outside this if block; had problems when tried this before
    if ( deal_option.errors == null ) {
      deal_option.errors = new List <DealWizardError>();
    }
    deal_option.errors.add( error_object );

    deal.has_errors = true;
    error_object.log_error();
  }

  // instance methods

  public DealWizardPackageComponent() {}

  public DealWizardPackageComponent( Package_Component__c pc ) {
    this.description = pc.description__c;
    this.value = pc.value__c;
    this.id = pc.id;
    this.option_id = pc.multi_deal__c;
  }

  public Package_Component__c build_sobject() {

    Package_Component__c p;
    if ( LibraryString.exists_and_is_not_blank( this.id ) ) {
      p = new Package_Component__c( id = this.id );
    }
    else {
      p = new Package_Component__c();
    }
    p.description__c = this.description;
    p.value__c = this.value;
    p.multi_deal__c = this.option_id;
    return p;
  }

}