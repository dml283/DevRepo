global class DealWizardDeal {
  static final Boolean NONTRANSACTIONAL = false;

  // POST parameters
  public String account_id {get; set;}
  public String additional_email_list_to {get; set;}
  public String  available_date {get; set;}
  public String cancellation_policy {get; set;}
  public String cancellation_policy_url {get; set;} //wooten - updated this to url to match rest of naming convention
  public Decimal cc_fee {get; set;}
  public String close_date {get; set;}
  public String  conditions {get; set;}
  public DealWizardConfigSettings config_settings {get; set;}
  public Decimal days_to_first_payment {get; set;}  // added for G2 (Groupon Lite)
  public String  deal_bank_eligible {get; set;}
  public List<DealWizardDealContact> deal_contacts {get; set;}
  public Boolean dealwizard_manual_update {get; set;}
  public String division {get; set;}
  public String deal_website {get; set;}
  public Boolean deal_wizard {get; set;}
  public String dq_flags {get; set;}
  public String  email_list_to {get; set;}
  public Boolean enable_staggered_expiration {get; set;}
  public List<DealWizardError> errors {get; set;}
  public String expiration_date {get; set;}
  public String expiration_type {get; set;}
  public String expiration_policy {get; set;}
  public Decimal groupon_lite_monthly_cap {get; set;}  // added for G2 (Groupon Lite)
  public Boolean has_errors {get; set;}
  public String id {get; set;}
  public String image_notes {get; set;}
  public String merchant_availability {get; set;} /* work with Chris on merchant avail. to determine type */
  public String merchant_highlights {get; set;}
  public String merchant_interview_contact_notes {get; set;}
  public String merchant_name_in_write_up {get; set;}
  public String merchant_provided_codes {get; set;}
  public Decimal months_to_expiration {get; set;}
  public String name {get; set;}
  public String now_sales_info {get; set;}
  public String now_sales_info_notes {get; set;}
  public Decimal number_of_buy_buttons {get; set;}
  public Boolean opt_out_of_mulligan {get; set;}
  public List<DealWizardDealOption> options {get; set;}
  public transient Opportunity opportunity {get; set;}
  public DealWizardPaymentTerms payment_terms {get; set;}
  public Decimal percent_payment {get; set;} // added for G2 (Groupon Lite)
  public String primary_service {get; set;}
  public String proof_of_licensing {get; set;}
  public String proof_of_licensing_url {get; set;}
  public String proof_of_pricing {get; set;}
  public String proof_of_pricing_url {get; set;}
  public List<DealWizardQuestion> questions {get; set;}
  public DealWizardDealRecordType record_type {get; set;}
  public String redemption_instructions {get; set;}
  public List<DealWizardRedemptionLocation> redemption_locations {get; set;}
  public String redemption_url {get; set;}
  public Decimal rep_projected_gp {get; set;}
  public Boolean rewards_contributed_to_g1_close {get; set;}
  public String  rewards_sales_info {get; set;}
  public String  rewards_sales_info_notes {get; set;}
  public String stage_name {get; set;}
  public Decimal deal_wizard_deal_cap {get; set;}

  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      // Fields in use
      'Account_Id__c'                 => 'account_id',  // or Parent Account?
      'Addtl_Email_List_To__c'        => 'additional_email_list_to', 
      'Available_Date__c'             => 'available_date',
      'Proof_of_Cancellation__c'      => 'cancellation_policy', 
      'cancellation_policy_url__c'    => 'cancellation_policy_url',
      'CC_Fee__c'                     => 'cc_fee', 
      'CloseDate'                     => 'close_date',
      'conditions__c'                 => 'conditions', 
      'Days_from_Feature_to_1st_Payment__c' => 'days_to_first_payment',
      'Deal_Bank_Eligible__c'         => 'deal_bank_eligible', 
      'Deal_Website__c'               => 'deal_website',
      'Division__c'                   => 'division',
      'deal_wizard__c'                => 'deal_wizard', 
      'Deal_Wizard_Deal_Cap__c'       => 'deal_wizard_deal_cap',
      'dealwizard_manual_update__c'   => 'dq_flags', 
      'Email_List_To__c'              => 'email_list_to', 
      'Enable_Staggered_Expiration__c' => 'enable_staggered_expiration', 
      'Groupon_Expiration_Date__c'    => 'expiration_date', 
      'Expiration_Type__c'            => 'expiration_type', 
      'Expiration_Policy__c'          => 'expiration_policy',
      'GrouponLite_Monthly_Cap__c'    => 'groupon_lite_monthly_cap',
      'id'                            => 'id',
      'Image_Notes__c'                => 'image_notes', 
      'sales_points__c'               => 'merchant_highlights', 
      'Merchant_Contact_Name__c'      => 'merchant_interview_contact_notes',
      'Merchant_name_in_write_up__c'  => 'merchant_name_in_write_up', 
      'Merchant_Provided_Codes__c'    => 'merchant_provided_codes', 
      'Months_to_Expiration__c'       => 'months_to_expiration', 
      'Name'                          => 'name', 
      'Now_Sales_Info__c'             => 'now_sales_info', 
      'Now_Sales_Info_Notes__c'       => 'now_sales_info_notes', 
      'Number_of_Buy_Buttons__c'      => 'number_of_buy_buttons', 
      'Opt_Out_of_Mulligan__c'        => 'opt_out_of_mulligan', 
      'Percent_Payment__c'            => 'percent_payment', 
      'Primary_Deal_Services__c'      => 'primary_service', 
      'Proof_of_License__c'           => 'proof_of_licensing', 
      'proof_of_licensing_url__c'     => 'proof_of_licensing_url', 
      'Proof_of_Pricing__c'           => 'proof_of_pricing', 
      'proof_of_pricing_website__c'   => 'proof_of_pricing_url', 
      // DealWizardDealRecordType class
// TODO 'RecordType'                    => 'record_type_name',
      'coupon_instructions__c'        => 'redemption_instructions', 
      'Unique_Redemption_Website_Notes__c' => 'redemption_url', 
      'Rep_Feature_Projected_GP__c'   => 'rep_projected_gp', 
      'Rewards_Contributed_to_G1_Close__c' => 'rewards_contributed_to_g1_close',
      'Rewards_Sales_Info__c'         => 'rewards_sales_info', 
      'Rewards_Sales_Info__c'         => 'rewards_sales_info_notes',
      'stageName'                     => 'stage_name'

      // Collections / Children //
      //options
      //questions
      //redemption_locations

      // READ-ONLY //
      //config_settings
      //errors 
      //has_errors 
      //deal_contacts
      //payment_terms

      // Settable but not persisted (transient) //

      // Unused fields (verify) //
      //dealwizard_manual_update (is boolean; dq_flags replaced?)
      //merchant_availability
    };

  public DealWizardDeal() {
    this.has_errors = false;
    this.rewards_contributed_to_g1_close = false;
    this.errors = new List<DealWizardError>();
    this.options = new List<DealWizardDealOption>();
  }

  public String name() {
    return LibraryString.truncate( this.name, 120 );
  }
  
  private String opportunity_query_string_for_attributes_and_children( String relationship_query_strings ) {
    
    String query = 'SELECT id, ' +
      'accountid, ' +
      'Addtl_Email_List_To__c, ' +
      'Available_Date__c, ' +
      'cancellation_policy_url__c, ' +
      'CC_Fee__c, ' +
      'closeDate, ' +
      'conditions__c, ' +
      'coupon_instructions__c,' +
      'Days_from_Feature_to_1st_Payment__c, ' +
      'Deal_Bank_Eligible__c, ' +
      'Deal_Website__c, ' +
      'deal_wizard__c, ' +
      'Deal_Wizard_Deal_Cap__c, ' +
      'dealwizard_manual_update__c, ' +
      'division__c, ' +
      'Email_List_To__c, ' +
      'Enable_Staggered_Expiration__c, ' +
      'Expiration_Policy__c , ' +
      'Expiration_Type__c, ' +
      'Groupon_Expiration_Date__c, ' +
      'GrouponLite_Monthly_Cap__c,' +
      'Image_Notes__c,' +
      'Merchant_Contact_Name__c, ' +
      'Merchant_name_in_write_up__c, ' +
      'Merchant_Provided_Codes__c, ' +
      'Months_to_Expiration__c, ' +
      'name, ' +
      'Number_of_Buy_Buttons__c, ' +
      'Now_Sales_Info__c, ' +
      'Now_Sales_Info_Notes__c, ' +
      'Opt_Out_of_Mulligan__c, ' +
      'Payment_Terms__c, ' +
      'Percent_Payment__c ,' +
      'Primary_Deal_Services__c, ' +
      'Proof_of_Cancellation__c, ' +
      'Proof_of_License__c, ' +
      'proof_of_licensing_url__c, ' +
      'Proof_of_Pricing__c, ' +
      'proof_of_pricing_website__c, ' +
      'RecordTypeId, ' +
      'Rep_Feature_Projected_GP__c, ' +
      'Rewards_Contributed_to_G1_Close__c, ' +
      'Rewards_Sales_Info__c, ' +
      'Rewards_Sales_Info_Notes__c, ' +
      'sales_points__c, ' +
      'stageName, ' +
      'Unique_Redemption_Website_Notes__c, ' +
      'X1st_Payment__c,' +
      'X1st_Payment_Date__c, ' +
      'X1st_Payment_Days__c, ' +
      'X2nd_Payment__c,' +
      'X2nd_Payment_Date__c, ' +
      'X2nd_Payment_Days__c, ' +
      'X3rd_Payment__c, ' +
      'X3rd_Payment_Date__c, ' +
      'X3rd_Payment_Days__c, ';
      
    query += relationship_query_strings;
      
    query += ' FROM Opportunity';
    query += ' WHERE id = \'' + id + '\'';
    
    return query;
  } 
  
  private String build_query_string_for_attributes_and_children( string id ) {
    
    String child_subqueries = '(' + DealWizardDealOption.build_option_query_string() + '),';
    child_subqueries += '(' + DealWizardRedemptionLocation.build_redemption_location_query_string() + '),';
    child_subqueries += '(' + DealWizardQuestion.build_question_query_string() + ')';
    
    return opportunity_query_string_for_attributes_and_children( child_subqueries ); 
  }

  // Overwrite this in-memory deal with latest database record for the Opportunity
  public void load() {

    if (id != null && id != '') {

      reload_opportunity();

      // Load the Options and their Package Components
      // TODO: consider implementing this by iterating over each option, so that only one child is handled at a time (may simplify code)
      DealWizardDealOption.load_all_for( this );

      // load the Redemption Locations
      this.redemption_locations = new List<DealWizardRedemptionLocation>();
      DealWizardRedemptionLocation.load_all_for( this );

      // load the Questions
      this.questions = new List<DealWizardQuestion>();
      DealWizardQuestion.load_all_for( this );

      this.deal_contacts = load_all_deal_contacts();
    }
  }
  
  private List<DealWizardDealContact> load_all_deal_contacts(){
    List<DealWizardDealContact> deal_contacts = new List<DealWizardDealContact>();
    List<OpportunityContactRole> contact_roles = DealWizardDealContact.load_all_contacts_for_deal(this.id);
    for (OpportunityContactRole contact_role : contact_roles){
      deal_contacts.add(new DealWizardDealContact(contact_role));
    }
    return deal_contacts;
  }
  
  public Opportunity fetch_opportunity() {
    
    return Database.query( this.build_query_string_for_attributes_and_children( this.id ) );
  }

  public void reload_opportunity() {
    
    this.opportunity = fetch_opportunity();
    load_opportunity( this.opportunity );
  }

  public void do_upsert() {

    // create or fetch the Opportunity
    // TODO: consider providing the opportunity from the controller level

    if ( this.id == null || this.id == '' ) {
      this.opportunity = new Opportunity();
    } 
    else {
      this.opportunity = new Opportunity( id = this.id );
    }

    // Update (overwrite) the Opportunity in-memory with the provided (and possibly missing/null) POST parameter values

    // TODO: decide/implement either absent/null/blank parameters overwrite their record fields OR no change is made (convention is the former for now)
    try {

        this.opportunity.accountid = this.account_id;
        this.opportunity.stageName = this.stage_name;
        this.opportunity.name = this.name();
        this.opportunity.Expiration_Policy__c = this.expiration_policy;
        this.opportunity.Addtl_Email_List_To__c = this.additional_email_list_to;
        this.opportunity.coupon_instructions__c = this.redemption_instructions;
        this.opportunity.Number_of_Buy_Buttons__c = this.number_of_buy_buttons;
        this.opportunity.Merchant_Contact_Name__c = this.merchant_interview_contact_notes;
        this.opportunity.closedate = LibraryDate.toDate( this.close_date );
        if ( this.opportunity.CloseDate == null ) {
          this.opportunity.CloseDate = system.today().addDays( 30 ); // default close date. TODO: define new library method that takes default assignment
        }
        this.opportunity.Days_from_Feature_to_1st_Payment__c = this.days_to_first_payment;
        this.opportunity.Deal_Website__c = this.deal_website;
        this.opportunity.Primary_Deal_Services__c = this.primary_service;
        this.opportunity.Expiration_Type__c = this.expiration_type;
        this.opportunity.GrouponLite_Monthly_Cap__c = this.groupon_lite_monthly_cap;
        this.opportunity.Available_Date__c = this.available_date;
        this.opportunity.CC_Fee__c = this.cc_fee;
        this.opportunity.Rep_Feature_Projected_GP__c = this.rep_projected_gp;
        this.opportunity.division__c = this.division;
        this.opportunity.cancellation_policy_url__c = this.cancellation_policy_url;
        this.opportunity.Proof_of_License__c = this.proof_of_licensing;
        this.opportunity.proof_of_pricing_website__c = this.proof_of_pricing_url;
        this.opportunity.Email_List_To__c = this.email_list_to;
        this.opportunity.Deal_Wizard_Deal_Cap__c = this.deal_wizard_deal_cap;
        this.opportunity.Deal_Bank_Eligible__c = this.deal_bank_eligible;
        this.opportunity.Rewards_Sales_Info__c = this.rewards_sales_info;
        this.opportunity.Proof_of_Pricing__c = this.proof_of_pricing;
        this.opportunity.Unique_Redemption_Website_Notes__c = this.redemption_url;
        this.opportunity.Rewards_Sales_Info_Notes__c = this.rewards_sales_info_notes;
        this.opportunity.Now_Sales_Info__c = this.now_sales_info;
        this.opportunity.Percent_Payment__c = this.percent_payment;
        this.opportunity.proof_of_licensing_url__c = this.proof_of_licensing_url;
        this.opportunity.sales_points__c = this.merchant_highlights;
    
        this.opportunity.Groupon_Expiration_Date__c = LibraryDate.toDate( this.expiration_date );
    
        this.opportunity.Months_to_Expiration__c = this.months_to_expiration;
    
        this.opportunity.Now_Sales_Info_Notes__c = this.now_sales_info_notes;
        this.opportunity.Merchant_Provided_Codes__c = this.merchant_provided_codes;
        this.opportunity.conditions__c = this.conditions;
        this.opportunity.Merchant_name_in_write_up__c = this.merchant_name_in_write_up;
        this.opportunity.Image_Notes__c = this.image_notes;
        this.opportunity.Proof_of_Cancellation__c = this.cancellation_policy;
    
        if ( this.record_type != null ) {
          DealWizardDealRecordType complete_record_type = DealWizardDealRecordType.find_by_name( this.record_type.name );
          this.opportunity.RecordTypeId = complete_record_type.id;
        }
    
        // Booleans
        this.opportunity.deal_wizard__c = true;
    
        this.opportunity.dealwizard_manual_update__c = this.dq_flags;
    
        if (this.rewards_contributed_to_g1_close != null) {
          this.opportunity.Rewards_Contributed_to_G1_Close__c = this.rewards_contributed_to_g1_close;
        }
    
        if ( this.opt_out_of_mulligan != null ) {
          this.opportunity.Opt_Out_of_Mulligan__c = this.opt_out_of_mulligan;
        }
    
        if ( this.enable_staggered_expiration != null ) {
          this.opportunity.Enable_Staggered_Expiration__c = this.enable_staggered_expiration;
        }
    
        // set Payment Terms
    
        if ( this.payment_terms != null ) {
          this.opportunity.Payment_Terms__c = this.payment_terms.payment_terms;
        }
    }
    catch ( Exception anException ) {
      add_and_log_exception_error( anException, 'deal', DealWizardDeal.sobject_to_json_field_map );
      return;
    }

    // upsert the Opportunity

    try {
      Database.upsert( this.opportunity );
    }
    catch ( DMLException anException ) {
      add_and_log_dml_exception_error( anException, 'deal', DealWizardDeal.sobject_to_json_field_map );
      return;
    }
    catch ( Exception anException ) {
      add_and_log_exception_error( anException, 'deal', DealWizardDeal.sobject_to_json_field_map );
      return;
    }
    //END OF PARENT (OPPORTUNITY) CHANGES

    // TODO: is this guard needed? why not just assign?
    if ( this.id == null || this.id == '' ) {
      this.id = this.opportunity.id;
    }
    
    if (id != null && id != '') {
      // fetch the latest Opportunity SObject with that id
      reload_opportunity();
    }

    // MODIFY CHILDREN
    
    if ( this.opportunity.id != null ) {
      // upsert Primary Contact
      List<DealWizardDealContact> saved_contacts = new List<DealWizardDealContact>();
      List<DealWizardDealContact> existingDealContacts = load_all_deal_contacts();
      Set<String> existingDealContactContactIds = new Set<String>();

      for (DealWizardDealContact dealContact : existingDealContacts){
        existingDealContactContactIds.add(dealContact.contact_id);
      }

      if (this.deal_contacts != null){
        for (DealWizardDealContact deal_contact : this.deal_contacts){
          deal_contact.deal_id = this.opportunity.id;
          if (deal_contact.exists() ){
            saved_contacts.add(deal_contact.update_contact());
          }else if (!existingDealContactContactIds.contains(deal_contact.contact_id)){
            saved_contacts.add(deal_contact.save());
          }
        }
      }
      this.deal_contacts = saved_contacts;
  
  
      // upsert Options and their Package Components
      if ( DealWizardDealOption.upsert_all_for( this ) == false ) {
        return;
      }
          
      // upsert Questions
  
      if ( DealWizardQuestion.upsert_all_for( this ) == false ) {
        return;
      }
  
      // upsert Redemption Locations
      
      // TODO: move these code sections to DealWizardRedemptionLocation?
  
        // delete Temporary Addresses
    
        if ( this.opportunity.id != null ) {
          List<Address__c> temp_addresses = [select id from address__c where opportunity__c = : this.opportunity.id];
          if ( temp_addresses != null ) {
            try {
              Database.delete( temp_addresses );
            }
            catch ( DMLException anException ) {
              add_and_log_dml_exception_error( anException, 'temp_addresses (implementation)', new Map<String, String>{ /** N/A **/ } );
            }
            catch ( Exception anException ) {
              add_and_log_exception_error( anException, 'temp_addresses (implementation)', new Map<String, String>{ /** N/A **/ } );
            }
          }
        }
  
      List<Address__c> addresses = new List<Address__c>();
  
      try {
          if ( this.redemption_locations != null ) {
            for ( DealWizardRedemptionLocation rd: this.redemption_locations ) {
              addresses.add( rd.get_sobject( this.opportunity.id, rd.merchant_address_id ) );
            }
          }
      }
      catch ( Exception anException ) {
        add_and_log_exception_error( anException, 'redemption_locations', DealWizardQuestion.sobject_to_json_field_map );
      }
      
      if ( addresses.size() > 0 ) {
        try {
          Database.upsert( addresses );
        }
        catch ( DMLException anException ) {
          add_and_log_dml_exception_error( anException, 'redemption_locations', DealWizardRedemptionLocation.sobject_to_json_field_map );
        }
        catch ( Exception anException ) {
          add_and_log_exception_error( anException, 'redemption_locations', DealWizardRedemptionLocation.sobject_to_json_field_map );
        }
      }
      
      this.redemption_locations = new List<DealWizardRedemptionLocation>();
      DealWizardRedemptionLocation.load_all_for( this );
      
    } // end of blank id check

  } // end of do_upsert()


  private void load_opportunity( Opportunity deal_opportunity ) {

    this.account_id = deal_opportunity.accountid;
    this.expiration_policy = deal_opportunity.Expiration_Policy__c;

    this.config_settings = new DealWizardConfigSettings();

    this.id = deal_opportunity.id;
    this.number_of_buy_buttons = deal_opportunity.Number_of_Buy_Buttons__c;
    this.redemption_instructions = deal_opportunity.coupon_instructions__c;
    this.division = deal_opportunity.division__c;
    this.cancellation_policy = deal_opportunity.Proof_of_Cancellation__c;
    this.days_to_first_payment = deal_opportunity.Days_from_Feature_to_1st_Payment__c;
    this.deal_website = deal_opportunity.Deal_Website__c;
    this.stage_name = deal_opportunity.stageName;
    this.name = deal_opportunity.name;
    this.rep_projected_gp = deal_opportunity.Rep_Feature_Projected_GP__c;
    this.merchant_interview_contact_notes = deal_opportunity.Merchant_Contact_Name__c;
    this.groupon_lite_monthly_cap = deal_opportunity.GrouponLite_Monthly_Cap__c;
    this.deal_wizard_deal_cap = deal_opportunity.Deal_Wizard_Deal_Cap__c; 
    this.proof_of_pricing = deal_opportunity.Proof_of_Pricing__c;
    this.close_date = LibraryDate.toStringUsingLocaleFormat( deal_opportunity.closeDate );
    this.primary_service = deal_opportunity.Primary_Deal_Services__c;
    this.redemption_url = deal_opportunity.Unique_Redemption_Website_Notes__c;
    this.expiration_type = deal_opportunity.Expiration_Type__c;
    this.available_date = deal_opportunity.Available_Date__c;
    this.proof_of_pricing_url = deal_opportunity.proof_of_pricing_website__c;
    this.cc_fee = deal_opportunity.CC_Fee__c;
    this.additional_email_list_to = deal_opportunity.Addtl_Email_List_To__c;
    this.cancellation_policy_url = deal_opportunity.cancellation_policy_url__c;
    this.expiration_date = LibraryDate.toStringUsingLocaleFormat( deal_opportunity.Groupon_Expiration_Date__c );
    this.months_to_expiration = deal_opportunity.Months_to_Expiration__c;
    this.email_list_to = deal_opportunity.Email_List_To__c;
    this.percent_payment = deal_opportunity.Percent_Payment__c;
    this.deal_bank_eligible = deal_opportunity.Deal_Bank_Eligible__c;
    this.rewards_sales_info = deal_opportunity.Rewards_Sales_Info__c;
    this.rewards_sales_info_notes = deal_opportunity.Rewards_Sales_Info_Notes__c;
    this.now_sales_info = deal_opportunity.Now_Sales_Info__c;
    this.now_sales_info_notes = deal_opportunity.Now_Sales_Info_Notes__c;
    this.merchant_provided_codes = deal_opportunity.Merchant_Provided_Codes__c;
    this.conditions = deal_opportunity.conditions__c;
    this.proof_of_licensing_url = deal_opportunity.proof_of_licensing_url__c;
    this.merchant_name_in_write_up = deal_opportunity.Merchant_name_in_write_up__c;
    this.image_notes = deal_opportunity.Image_Notes__c;
    this.proof_of_licensing = deal_opportunity.Proof_of_License__c;
    this.payment_terms = new DealWizardPaymentTerms( deal_opportunity );
    this.record_type = DealWizardDealRecordType.find( deal_opportunity.RecordTypeId );
    this.merchant_highlights = deal_opportunity.sales_points__c;

    // Booleans
    this.dq_flags = deal_opportunity.dealwizard_manual_update__c;
    this.deal_wizard = deal_opportunity.deal_wizard__c;
    this.enable_staggered_expiration = deal_opportunity.Enable_Staggered_Expiration__c;
    this.opt_out_of_mulligan = deal_opportunity.Opt_Out_of_Mulligan__c;
    this.rewards_contributed_to_g1_close = deal_opportunity.Rewards_Contributed_to_G1_Close__c;
  }

  // TODO: move to DealWizardDealOption
  public Boolean delete_persisted_options_not_present_in_request() {

    Set<id> ids_to_delete = new Set<id>();
    Set<id> persisted_option_ids = new Set<id>();
    Set<id> requested_option_ids = new Set<id>();

    for ( multi_deal__c md : [select id from multi_deal__c where opportunity__c = : this.id] ) {  // collect the id of each option currently persisted in db on this deal
      persisted_option_ids.add( md.id );
    }

    for ( DealWizardDealOption option : this.options ) {                                          // collect the ids (even if null?) of all options in the request

      requested_option_ids.add( option.id );
    }

    for ( id persisted_option_id : persisted_option_ids ) {

      if ( !requested_option_ids.contains( persisted_option_id ) ) {

        ids_to_delete.add( persisted_option_id );
      }
    }

    if ( ids_to_delete.isEmpty() != true ) {
      List<multi_deal__c> multi_deals_to_delete = [select id from Multi_deal__c where id in : ids_to_delete];  // collect the sobject Multi_Deals in db for each option in ids_to_delete
      try {
        Database.delete( multi_deals_to_delete );                                                              // and delete them
      }
      catch ( DMLException anException ) {
        add_and_log_dml_exception_error( anException, 'options', new Map<String, String>{ /** N/A **/ } );
        return false;
      }
      catch ( Exception anException ) {
        add_and_log_exception_error( anException, 'options', new Map<String, String>{ /** N/A **/ } );
        return false;
      }
    }
    return true;
  }

  public void add_and_log_dml_exception_error( DMLException dml_exception, String attempted_json_object_type, Map<String, String> attempted_sobject_to_json_field_map ) {

    List<DealWizardError> error_objects = DealWizardError.extract_errors( dml_exception, attempted_json_object_type, attempted_sobject_to_json_field_map );
    for ( DealWizardError error_object : error_objects ) {
        add_and_log_error( error_object );
    }
  }

  public void add_and_log_exception_error( Exception anException, String attempted_json_object_type, Map<String, String> attempted_sobject_to_json_field_map ) {

    DealWizardError error_object = new DealWizardError( anException, attempted_json_object_type, attempted_sobject_to_json_field_map );

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

  public DealWizardApprover submit_for_approval(){
    String approval_comment = 'Submitting request for approval via Deal Wizard.';
    DealWizardApprover approver = new DealWizardApprover();
    DealWizardApprover completed_approval = approver.process(this.id, approval_comment);
    Database.UpsertResult deal_upsert_result;

    if (completed_approval.success == true){
      Opportunity deal = fetch_opportunity();
      deal.Submitted_via_Deal_Wizard__c = true;
      deal_upsert_result = Database.upsert(deal, NONTRANSACTIONAL);
    }

    if (deal_upsert_result != null && deal_upsert_result.isSuccess() != true){
      if (deal_upsert_result.errors.isEmpty() != true){
        List<DealWizardError> formatted_errors = new List<DealWizardError>();
        List<Database.Error> upsert_errors = deal_upsert_result.getErrors();

        for ( Database.Error error : upsert_errors ) {
          DealWizardError formatted_error = new DealWizardError( error );
          formatted_errors.add( formatted_error );
        }
        completed_approval.errors.addAll(formatted_errors);
      }
    }
    return completed_approval;
  }
}