public class DealWizardDealContact {
  public List<DealWizardError> errors {get;set;}
  public Boolean primary {get;set;}
  public String contact_id {get;set;}
  public String deal_id {get;set;}
  public String role {get;set;}
  public String id {get;set;}
  public String best_contact_method {get;set;}
  public String best_contact_time_of_day {get;set;}
  public String name {get;set;}
  public String email {get;set;}

  public DealWizardDealContact(OpportunityContactRole contact_role){
      this.contact_id = contact_role.ContactId;
      this.primary = contact_role.isPrimary;
      this.role = contact_role.role;
			this.deal_id = contact_role.OpportunityId;
			this.id = contact_role.Id;

      Contact merchant_contact = load_merhant_contact_sobject(contact_role.ContactId);
			this.best_contact_method = merchant_contact.Best_Contact_Method__c;
			this.best_contact_time_of_day = merchant_contact.Best_Contact_Time_of_Day__c;
      this.name = merchant_contact.Name;
      this.email = merchant_contact.Email;
  }

  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      // Fields in use
      'ContactId' 		=> 'contact_id',
      'Id'    				=> 'id',
      'OpportunityId' => 'deal_id',
      'IsPrimary'			=> 'is_primary',
      'Role'      		=> 'role'
  };

  public Boolean exists(){
    return !String.isBlank(this.id);
  }

  public DealWizardDealContact save(){
  	OpportunityContactRole contact_role = initialize_sobject_to_be_upserted();
    Contact merchant_contact = initialize_merchant_contact_sobject_to_be_upserted();

    Database.UpsertResult merchant_contact_result = Database.upsert(merchant_contact, false);
    if (merchant_contact_result.isSuccess() == false){ add_errors_and_return(merchant_contact_result); return this;}

  	Database.UpsertResult contact_role_result = Database.upsert(contact_role, false);
    if (contact_role_result.isSuccess() == false){ add_errors_and_return(contact_role_result); return this;}

  	String updated_contact_id = contact_role_result.getId();
  	DealWizardDealContact updated_contact = new DealWizardDealContact(load_contact_sobject(updated_contact_id));
  	updated_contact.errors = new List<DealWizardError>();
  	return updated_contact;
  }

	public DealWizardDealContact update_contact(){
		OpportunityContactRole original_deal = load_contact_sobject(this.id);
		if (original_deal != null){
			DealWizardDealContact deal_to_save = new DealWizardDealContact(original_deal);
			deal_to_save.primary = this.primary;
			deal_to_save.role = this.role;
      deal_to_save.best_contact_method = this.best_contact_method;
      deal_to_save.best_contact_time_of_day = this.best_contact_time_of_day;
			return deal_to_save.save();
		}else{
			return this.save();
		}
	}

  private static Contact load_merhant_contact_sobject(String id){
    return [SELECT  Best_Contact_Method__c,
                    Best_Contact_Time_of_Day__c,
                    Name,
                    Email
            
            FROM    Contact

            WHERE   Id = :id
            ];
  }

  private static OpportunityContactRole load_contact_sobject(String id){
  	return [SELECT 	Id,
  									IsPrimary,
  									OpportunityId,
  									ContactId,
  									Role

  					FROM 		OpportunityContactRole

  					WHERE 	Id = :id
  					];
  }

  public static List<OpportunityContactRole> load_all_contacts_for_deal(String deal_id){
  	return [SELECT 	Id,
  									IsPrimary,
  									OpportunityId,
  									ContactId,
  									Role

  					FROM 		OpportunityContactRole

  					WHERE 	OpportunityId = :deal_id
  					];
  }

  private OpportunityContactRole initialize_sobject_to_be_upserted(){
    if (String.isBlank(this.id)) {this.id = null;}

  	OpportunityContactRole contact_role = new OpportunityContactRole(
  		ContactId 		= this.contact_id,
  		isPrimary 		= this.primary,
  		OpportunityId = this.deal_id,
  		Role 					= this.role,
  		Id 						= this.id
  		);
  	return contact_role;
  }

  private Contact initialize_merchant_contact_sobject_to_be_upserted(){
    Contact merchant_contact = new Contact();
    if (this.contact_id == null){
      merchant_contact.Best_Contact_Method__c = null;
      merchant_contact.Best_Contact_Time_of_Day__c = null;
    }else{
      merchant_contact = load_merhant_contact_sobject(this.contact_id);
      merchant_contact.Best_Contact_Method__c = this.best_contact_method;
      merchant_contact.Best_Contact_Time_of_Day__c = this.best_contact_time_of_day;
    }
    return merchant_contact;
  }

  private List<DealWizardError> format_upsert_errors(Database.UpsertResult upsert_result){
    List<DealWizardError> formatted_errors = new List<DealWizardError>();
    List<Database.Error> upsert_errors = upsert_result.getErrors();
    for (Database.Error error : upsert_errors){
      DealWizardError formatted_error = new DealWizardError(error);
      formatted_errors.add(formatted_error);
    }
    return formatted_errors;
  }

  private void add_errors_and_return(Database.UpsertResult upsert_result){
    this.errors = format_upsert_errors(upsert_result);
  }
}