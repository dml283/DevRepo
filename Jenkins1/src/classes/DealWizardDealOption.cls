global class DealWizardDealOption {
  // TODO: consider setting deal_id (reference to its parent); will simplify params list for package_components operations
  final static Boolean SAVED_WITHOUT_ERROR = true;
  final static Boolean NOT_SAVED = false;

  public Decimal buyer_max {get;set;}
  public Decimal days_to_expiration {get; set;}
  public String option_from_deal_book {get; set;}
  public Decimal discount {get;set;} //calcd
  public Decimal display_order {get;set;}
  public List<DealWizardError> errors {get; set;}
  public String expiration_date {get;set;}
  public String expiration_type {get;set;}
  public Decimal gifting_max {get; set;}
  public Decimal groupon_lite_monthly_cap {get; set;}  // added for G2 (Groupon Lite)
  public Decimal groupon_take {get;set;} //marign $ calcd
  public String id {get;set;}
  public Decimal margin {get;set;} //% calcd
  public Decimal margin_dollar {get;set;}//margin $ calcd
  public Decimal max_pledges {get;set;} //Total_Deal_Max__c
  public Decimal max_per_purchase {get;set;}
  public Decimal months_to_expiration {get;set;} // int
  public String name { get; set; } // NOTE: custom get defined below
  public String offer_title {get;set;}
  public String offer_type {get;set;} //package deal - new field - stirng
  public List<DealWizardPackageComponent> package_components {get;set;}
  public Boolean stagger_expiration {get;set;} //
  public Decimal unit_buy_price {get;set;}
  public Decimal unit_sell_price {get;set;}
  public Decimal unit_value {get;set;}
  public String voucher_subtitle {get;set;}
  public String voucher_title {get;set;}

  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      // Fields in use
      'Buyer_Max__c'                      => 'buyer_max',
      'DaystoExpiration__c'               => 'days_to_expiration',
      'Discount__c'                       => 'discount',
      'Display_Order__c'                  => 'display_order',
      'Option_From_Deal_Book__c'          => 'option_from_deal_book',
      'Alternative_Expiration_Date__c'    => 'expiration_date',
      'Expiration_Type__c'                => 'expiration_type',
      'GrouponLite_Monthly_Cap__c'        => 'groupon_lite_monthly_cap',
      'id'                                => 'id',
      'Total_Deal_Max__c'                 => 'max_pledges',
      'Individual_Purchase_Max__c'        => 'max_per_purchase',
      'Months_to_Expiration__c'           => 'months_to_expiration',
      'Name'                              => 'name',
      'Offer_Title__c'                    => 'offer_title',
      'Offer_Type__c'                     => 'offer_type',
      'Enable_Staggered_Expiration__c'    => 'stagger_expiration',
      'Unit_Buy_Price__c'                 => 'unit_buy_price',
      'Unit_Sell_Price__c'                => 'unit_sell_price',
      'Unit_Value__c'                     => 'unit_value',
      'Voucher_Subtitle__c'               => 'voucher_subtitle',
      'Voucher_Title__c'                  => 'voucher_title',
      
      // unclassified
      'Margin__c'                         => 'groupon_take', // NOTE: is this Groupon's revenue or profit on the deal?

      // Collections / Children //
      //package_components

      // READ-ONLY //
      //errors
      //gifting_max
      'Margin_Percent__c'                 => 'margin',
      'Margin__c'                         => 'margin_dollar'
    };

  public String name() {
    return LibraryString.truncate( this.name, 80 );
  }

  public DealWizardDealOption() {
    initialize();
  }

  public DealWizardDealOption( Multi_Deal__c md ) {
    initialize();
    build( md );
  }

  // TODO: Deprecated  (delete after ensuring all Apex tests pass without it)
  public DealWizardDealOption( Multi_Deal__c md, List<DealWizardPackageComponent> components ) {
    initialize();
    this.package_components = components;
    build( md );
  }

  private void initialize() {
    errors = new List<DealWizardError>();
    package_components = new List<DealWizardPackageComponent>();
  }

  private void build( Multi_Deal__c md ) {

    this.buyer_max              = md.Buyer_Max__c;
    this.option_from_deal_book  = md.Option_From_Deal_Book__c;
    this.days_to_expiration     = md.DaystoExpiration__c;
    this.discount               = md.Discount__c;
    this.display_order          = md.Display_Order__c;
    this.expiration_date        = LibraryDate.toStringUsingLocaleFormat( md.Alternative_Expiration_Date__c );
    this.expiration_type        = md.Expiration_Type__c;
    this.groupon_take           = md.Margin__c;
    this.groupon_lite_monthly_cap = md.GrouponLite_Monthly_Cap__c;
    this.id                     = md.id;
    this.margin                 = md.Margin_Percent__c;
    this.margin_dollar          = md.Margin__c;
    this.max_per_purchase       = md.Individual_Purchase_Max__c;
    this.max_pledges            = md.Total_Deal_Max__c;
    this.months_to_expiration   = md.Months_to_Expiration__c;
    this.name                   = md.Name;
    this.offer_title            = md.offer_title__c;
    this.offer_type             = md.Offer_Type__c;
    this.stagger_expiration     = md.Enable_Staggered_Expiration__c;
    this.unit_value             = md.Unit_Value__c;
    this.unit_sell_price        = md.Unit_Sell_Price__c;
    this.unit_buy_price         = md.Unit_Buy_Price__c;
    this.voucher_title          = md.Voucher_Title__c;
    this.voucher_subtitle       = md.Voucher_Subtitle__c;

    // dependent calculated variables
    if ( this.buyer_max >= 0.0 && this.max_per_purchase >= 0.0 ) {
      this.gifting_max          = this.buyer_max - this.max_per_purchase;
    }
  }
  
  public static String build_option_query_string() {
    return 'SELECT ' +
       'Alternative_Expiration_Date__c, ' +
       'Buyer_Max__c, ' +
       'DaystoExpiration__c, ' +
       'Option_From_Deal_Book__c, ' +
       'Discount__c, ' +
       'Display_Order__c, ' +
       'Enable_Staggered_Expiration__c, ' +
       'Expiration_Type__c, ' +
       'GrouponLite_Monthly_Cap__c,' +
       'id, ' +
       'Individual_Purchase_Max__c, ' +
       'Margin__c, ' +
       'Margin_Percent__c, ' +
       'Months_to_Expiration__c, ' +
       'name, ' +
       'Offer_title__c, ' +
       'Offer_Type__c, ' +
       'Total_Deal_Max__c, ' +
       'Unit_Buy_Price__c, ' +
       'Unit_Sell_Price__c, ' +
       'Unit_Value__c, ' +
       'Voucher_Title__c, ' +
       'Voucher_Subtitle__c FROM Multi_Deals__r '; 
  }

  public static void load_all_for( DealWizardDeal deal ) {

    // TODO: this returns of list of components that were current at what point? rename to reflect that: "persisted_components_by_option_id"
    Map<id, List<DealWizardPackageComponent>> components_by_option_id = get_package_map( deal.opportunity.Multi_Deals__r );

    if ( deal.options == null || deal.options.isEmpty() ) {  // case: options are NOT present in the request

      add_retrieved_options_and_components( deal, components_by_option_id );
    }
    else { // case: options ARE present in the request (i.e. this is a POST request)
      // Since options are loaded after upsert, only need to merge requested/retrieved components on the deal's options
      for ( DealWizardDealOption deal_option : deal.options ) {

        if ( !deal_option.errors_exist_excluding_children() && LibraryString.exists_and_is_not_blank( deal_option.id ) ) { // case: the option persisted without error

          // TODO: move these to an instance method on option?
          merge_requested_and_retrieved_components( deal_option, components_by_option_id );
        }
      }
      // TODO: will tests pass if this is removed?
	    reorder_and_normalize_display_order_on_options( deal );
    }
  }

  public static Boolean upsert_all_for( DealWizardDeal deal ) {
  	
    reorder_and_normalize_display_order_on_options( deal );

    List<Multi_Deal__c> specified_multi_deals = new List<Multi_Deal__c>();

    if ( deal.options != null ) {

      if ( deal.delete_persisted_options_not_present_in_request() == false ) { // case: deletes were NOT successful
	      return NOT_SAVED;
      }

      try {
          for ( DealWizardDealOption option: deal.options ) {   // build and collect an sobject Multi_Deal__c for each option in the request
            Multi_Deal__c md = option.get_sobject( deal.opportunity.id );

            specified_multi_deals.add( md );
          }
      }
      // TODO: continue here - the return only is an advantage on upserts failed, if the load is avoided, so call the load below and remove from deal..
	    catch ( Exception anException ) {
	      deal.add_and_log_exception_error( anException, 'options', DealWizardDealOption.sobject_to_json_field_map );
	      return NOT_SAVED;
	    }

      if ( specified_multi_deals.size() > 0 ) {                       // upsert the collected Multi_Deals
        try {
          // NOTE: if any row in an upsert fails, then all appear to fail (when DMLException thrown)
          // Example UpsertResult object in full success case: [getErrors=();getId=a0Yc00000001rcvEAA;isCreated=true;isSuccess=true;]
          // Example in failure case (1 failure, 1 success):
          //   [getErrors=();getId=a0Yc00000001rgJEAQ;isCreated=true;isSuccess=true;],
          //   [getErrors=(Database.Error[getFields=(GrouponLite_Monthly_Cap__c);getMessage=GrouponLite Monthly Cap: value outside of valid range on numeric field: 10000000000000000000;getStatusCode=NUMBER_OUTSIDE_VALID_RANGE;]);getId=null;isCreated=true;isSuccess=false;]  // NOTE: this might pollute db with unfindable objects, since isCreated is true but no id was returned; also the error might not be a full DMLException, thus limiting the information available in error messages
          List<Database.UpsertResult> upserted_objects = Database.upsert( specified_multi_deals ); // Allow partial upserts by setting second parameter to false
        }
        catch ( DMLException anException ) {
          deal.add_and_log_dml_exception_error( anException, 'options', DealWizardDealOption.sobject_to_json_field_map );
		      return NOT_SAVED;
        }
        catch ( Exception anException ) {
          deal.add_and_log_exception_error( anException, 'options', DealWizardDealOption.sobject_to_json_field_map );
		      return NOT_SAVED;
        }
      }
    }

    // Reload the Options (if persisted successfully, since otherwise execution would return to call in deal)
      deal.reload_opportunity();
	    merge_requested_and_retrieved_options_and_preserve_requested_components( deal );
	    
    // Upsert the Package Components on each Option
    
    	Boolean components_saved_for_all_options = true;
    	
	    if ( deal.options != null && deal.options.size() > 0 ) { // TODO: handle null instead by initializing collections?
	
	      // TODO: consider delegating the create/update to the Option itself instead of digging into its internals
	      for ( DealWizardDealOption deal_option : deal.options ) {
	        components_saved_for_all_options = DealWizardPackageComponent.persist_all_specified_and_delete_all_excluded( deal_option, deal );
	      }
	    }
	    
    if ( components_saved_for_all_options ) {
    	// NOTE: is this load essentially performed, since deal is re-loaded
		  // Load the Options and their Package Components
		  DealWizardDealOption.load_all_for( deal );
	    return SAVED_WITHOUT_ERROR;
    }
    return NOT_SAVED;
  }
  
  private static Integer find_index_of_option_with_display_order( List<DealWizardDealOption> options, Integer display_order ) {
    Integer identified_index;
    
    for (Integer index = 0; index < options.size(); index++) {
        if (options[index].display_order == display_order) {
            identified_index = index;
            break;
        }
    }
    return identified_index;
  }
  
  public static void reorder_and_normalize_display_order_on_options( DealWizardDeal deal ) {
  	
  	if ( deal.options != null && deal.options.size() > 0 ) {
 
	  	reorder_options_by_display_order( deal );
	  	
	  	for (Integer index = 0; index < deal.options.size(); index++ ) {
	  		deal.options[index].display_order = index + 1;
	  	}
  	}
  }
  
  private static void reorder_options_by_display_order( DealWizardDeal deal ) {
  	
  	// precondition: deal.options is not null/empty
    List<DealWizardDealOption> original_options = deal.options.clone();
    List<DealWizardDealOption> sorted_options = new List<DealWizardDealOption>();
    Set<Integer> indices_already_added = new Set<Integer>();
    
    while ( indices_already_added.size() < original_options.size() ) {
    	
      Integer index_of_next_smallest_option = find_index_of_option_with_smallest_display_order( original_options, indices_already_added );
      sorted_options.add( original_options[ index_of_next_smallest_option ] );
      indices_already_added.add( index_of_next_smallest_option ); 
    }
    deal.options = sorted_options;
  }
  
  private static Integer find_index_of_option_with_smallest_display_order( List<DealWizardDealOption> options, Set<Integer> indices_already_added ) {
  	
  	Decimal smallest_display_order = 9999999;
  	Integer index_for_next_smallest = -1;

	  for (Integer index = 0; index < options.size(); index++) {
	  	
	  	if ( !indices_already_added.contains( index ) ) {
	  		
		  	if ( options[index].display_order < smallest_display_order ) {
		  		
			  	smallest_display_order = options[index].display_order;
		  		index_for_next_smallest = index;
		  	}
	  	}
	  }
	  return index_for_next_smallest;
  }
  
  private static void add_retrieved_options_and_components( DealWizardDeal deal, Map<id, List<DealWizardPackageComponent>> components_by_option_id ) {

    for ( Multi_Deal__c multi_deal: deal.opportunity.Multi_Deals__r ) { // loop over all currently persisted options on the deal

      DealWizardDealOption persisted_deal_wizard_option = new DealWizardDealOption( multi_deal );

      if ( components_by_option_id.containsKey( multi_deal.id ) ) { // add to the option all persisted package components found for it
        persisted_deal_wizard_option.package_components = components_by_option_id.get( multi_deal.id );
      }
      deal.options.add( persisted_deal_wizard_option );
    }
  }
  
  private static List<Multi_Deal__c> sort_multi_deals_by_display_order( List<Multi_Deal__c> multi_deals ) {
  	List<Multi_Deal__c> sorted_multi_deals = new Multi_deal__c[multi_deals.size()];
  	
  	for( Integer current_position = 0; current_position < multi_deals.size(); current_position++ ) {
  	
  	 Integer new_index = multi_deals[current_position].Display_Order__c.intValue() - 1;
  	 sorted_multi_deals[new_index] = multi_deals[current_position];
  		
  	}
  	
  	return sorted_multi_deals;
  }
  
  // TODO: abstract away multi_deal by using a finder that returns collection of DW Options to loop over
  // TODO: test whether this assumes no previously-persisted option was left out of options in the request (i.e. no deletions), but we'll need delete behavior
  private static void merge_requested_and_retrieved_options_and_preserve_requested_components( DealWizardDeal deal ) {

    Set<Integer> failed_option_positions = positions_with_errors( deal.errors, 'options' );
    Integer last_position = -1;
    Integer current_position = 0;
    
    List<Multi_Deal__c> sorted_multi_deals = sort_multi_deals_by_display_order( deal.opportunity.Multi_Deals__r );

    for ( multi_deal__c multi_deal: sorted_multi_deals ) { // loop over all currently persisted options on the deal

      DealWizardDealOption persisted_deal_wizard_option = new DealWizardDealOption( multi_deal );

      current_position = next_successfully_persisted_position( last_position, failed_option_positions, deal.options.size() );

      if ( object_at_position_exists_in_database( current_position ) ) {

        DealWizardDealOption current_option = deal.options[ current_position ];
        
        if ( !current_option.errors_exist_excluding_children() ) { // case: the option persisted without error

          // TODO: in this branch, why would there be errors on the current/persisted option?
          persisted_deal_wizard_option.errors = current_option.errors;
          persisted_deal_wizard_option.package_components = current_option.package_components;
          deal.options.set( current_position, persisted_deal_wizard_option );
        }
      }
      last_position = current_position;
    }
  }

  // NOTE: Remember: since bulk upserts are all-or-nothing, any error results in no upserts.  This simplifies the implementation.
  private static void merge_requested_and_retrieved_components( DealWizardDealOption current_option, Map<id, List<DealWizardPackageComponent>> components_by_option_id ) {

    if ( !current_option.errors_exist_on_children('package_components') ) { // case: all components persisted without error for this option

      if ( components_by_option_id.containsKey( current_option.id ) ) { // add to the option all persisted package components found for it
        
        current_option.package_components = components_by_option_id.get( current_option.id );
      }
    }
  }

  private static Set<Integer> positions_with_errors( List<DealWizardError> errors, String json_object_type ) {
    List<DealWizardError> component_errors = DealWizardError.find_errors_for_json_object_type( errors, json_object_type );
    return DealWizardError.extract_positions( component_errors );
  }

  public static Boolean object_at_position_exists_in_database( Integer object_position ) {
    return object_position >= 0;
  }

  public static Integer next_successfully_persisted_position( Integer last_position, Set<Integer> failed_positions, Integer number_positions_in_request ) {
    Integer next_position = -1;

    for ( Integer position = 0; position < number_positions_in_request; position++ ) {

      if ( position > last_position && !failed_positions.contains( position ) ) {

        next_position = position;
        break;
      }
    }

    return next_position;
  }

  // TODO: consider pushing down to Package Component as public method
  // map of Multi Deal id to the collection of its components
  private static Map<id, List<DealWizardPackageComponent>> get_package_map( List<multi_deal__c> mds ) {

    Map<Id, List<DealWizardPackageComponent>> packages = new Map<Id, List<DealWizardPackageComponent>>();
    Set<id> option_ids = new Set <Id>();

    // collect ids of all the options (Multi Deals)
    for ( multi_deal__c md : mds ) {
      option_ids.add( md.id );
    }

    if ( option_ids.isEmpty() != true ) {

      // get package components for all Multi Deals
      List<Package_Component__c> components = [select id, description__c, value__c, multi_deal__c FROM Package_Component__c where multi_deal__c in : option_ids];

      for ( Package_Component__c pc : components ) {
        List<DealWizardPackageComponent> comp;

        // get latest list of components for this component's MultiDeal
        if ( packages.containsKey( pc.multi_deal__c ) ) {
          comp = packages.get( pc.multi_deal__c );
        } else {
          comp = new List<DealWizardPackageComponent>();
        }

        // add this component to it
        comp.add( new DealWizardPackageComponent( pc ) );

        // add back the updated components list for this Multi Deal
        packages.put( pc.multi_deal__c, comp );
      }
    }

    return packages;
  }

  // Instance methods

  public Multi_Deal__c get_sobject( String opportunity_id ) {

    Multi_Deal__c md;
    if ( LibraryString.exists_and_is_not_blank(this.id) ) {
      md = new Multi_Deal__c( id = this.id, Opportunity__c = opportunity_id ); // find existing MultiDeal
    }
    else {
      md = new Multi_Deal__c( Opportunity__c = opportunity_id ); // create new MultiDeal for opportunity
    }

    md.Option_From_Deal_Book__c     = this.option_from_deal_book;
    md.Buyer_Max__c                 = this.buyer_max;
    md.DaystoExpiration__c          = this.days_to_expiration;
    //discount?
    md.Display_Order__c             = this.display_order;
    md.Alternative_Expiration_Date__c = LibraryDate.toDate( this.expiration_date );
    md.Expiration_Type__c           = this.expiration_type;
    //groupon_take?
    md.GrouponLite_Monthly_Cap__c   = this.groupon_lite_monthly_cap;
    md.Individual_Purchase_Max__c   = this.max_per_purchase;
    md.Total_Deal_Max__c            = this.max_pledges;
    md.Months_to_Expiration__c      = this.months_to_expiration;
    md.Name                         = this.name();
    md.offer_title__c               = this.offer_title;
    md.Offer_Type__c                = this.offer_type;
    //stagger_expiration?
    md.Unit_Value__c                = this.unit_value;
    md.Unit_Sell_Price__c           = this.unit_sell_price;
    md.Unit_Buy_Price__c            = this.unit_buy_price;
    md.Voucher_Title__c             = this.voucher_title;
    md.Voucher_Subtitle__c          = this.voucher_subtitle;
    return md;
  }

  public Boolean errors_exist_excluding_children() {
    return ( !DealWizardError.find_errors_for_json_object_type( this.errors, 'options' ).isEmpty() );
  }

  public Boolean errors_exist_on_children( String child_collection_json_field ) {
    return ( !DealWizardError.find_errors_for_json_object_type( this.errors, 'package_components' ).isEmpty() );
  }

}