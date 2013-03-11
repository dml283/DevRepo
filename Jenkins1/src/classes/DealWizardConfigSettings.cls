public class DealWizardConfigSettings {

  public List<String> payment_terms_options  {get;set;}
  public List<String> expiration_type_options {get;set;}
  public List<String> deal_bank_eligibility_options {get;set;}
  public List<String> rewards_sales_info_options {get;set;}
  public List<String> now_sales_info_options {get;set;}
  public List<String> merchant_provided_codes_options {get;set;}
  public List<String> stage_name_options {get;set;}
  public List<String> proof_of_pricing_options {get;set;}
  public List<String> divisions {get;set;}
  public List<String> contact_roles {get;set;}
  public List<String> contact_best_contact_method {get;set;}
  public List<String> contact_best_contact_time_of_day {get;set;}

  public DealWizardConfigSettings() {

    this.payment_terms_options = new List<string>();
    this.expiration_type_options = new List<string>();
    this.deal_bank_eligibility_options = new List<string>();
    this.rewards_sales_info_options = new List<string>();
    this.now_sales_info_options = new List<string>();
    this.merchant_provided_codes_options = new List<string>();
    this.stage_name_options = new List<string>();
    this.proof_of_pricing_options = new List<string>();
    this.divisions = new List<string>();
    this.contact_roles = new List<string>();
    this.contact_best_contact_method = new List<string>();
    this.contact_best_contact_time_of_day = new List<string>();

    //vars
    Schema.DescribeFieldResult field;
    List<Schema.PicklistEntry> picklist_values;
    
    field = Opportunity.Payment_terms__c.getDescribe();
    picklist_values = field.getPicklistValues();
      for(Schema.PicklistEntry f : picklist_values) {
        this.payment_terms_options.add(f.getLabel());
      }  
    
    field = Opportunity.Proof_of_Pricing__c.getDescribe();
    picklist_values = field.getPicklistValues();
    for(Schema.PicklistEntry f : picklist_values) {
      this.proof_of_pricing_options.add(f.getLabel());
      }            

    field = Opportunity.StageName.getDescribe();
    picklist_values = field.getPicklistValues();
    for(Schema.PicklistEntry f : picklist_values) {
      this.stage_name_options.add(f.getLabel());
    }

    field = OpportunityContactRole.Role.getDescribe();
    picklist_values = field.getPicklistValues();
    for(Schema.PicklistEntry f : picklist_values) {
      this.contact_roles.add(f.getLabel());
    }  

    field = Opportunity.Expiration_Type__c.getDescribe();
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.expiration_type_options.add(f.getLabel());
    }

    field = Opportunity.Deal_Bank_Eligible__c.getDescribe();
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.deal_bank_eligibility_options.add(f.getLabel());
    }

    field = Opportunity.Rewards_Sales_Info__c.getDescribe();       
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.rewards_sales_info_options.add(f.getLabel());
    }

    field = Opportunity.Now_Sales_Info__c.getDescribe();       
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.now_sales_info_options.add(f.getLabel());
    }

    field = Opportunity.Merchant_Provided_Codes__c.getDescribe();       
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.merchant_provided_codes_options.add(f.getLabel());
    }

    field = Opportunity.Division__c.getDescribe();       
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.divisions.add(f.getLabel());
    }

    field = Contact.Best_Contact_Method__c.getDescribe();
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.contact_best_contact_method.add(f.getLabel());
    }

    field = Contact.Best_Contact_Time_of_Day__c.getDescribe();
    picklist_values = field.getPicklistValues();
    for( Schema.PicklistEntry f : picklist_values) {
      this.contact_best_contact_time_of_day.add(f.getLabel());
    }
  } // end of constructor
}