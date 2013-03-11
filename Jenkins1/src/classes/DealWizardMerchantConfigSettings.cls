public class DealWizardMerchantConfigSettings {

  public List<String> why_not_ach_options  {get;set;}
  public List<String> payment_preference_options {get;set;}
  public List<DealWizardMerchantContact> merchant_contacts {get;set;}

  public DealWizardMerchantConfigSettings() {
    Schema.DescribeFieldResult field;
    List<Schema.PicklistEntry> picklist_values;

    //why_not_ach_options
    this.why_not_ach_options = new list<string>();
    field = Account.Why_not_ACH__c.getDescribe();
    picklist_values = field.getPicklistValues();
    for (Schema.PicklistEntry f : picklist_values) {
      this.why_not_ach_options.add(f.getLabel());
    }            

    // payment_preference_options
    this.payment_preference_options = new list<string>();
    field = Account.Payment_Preference__c.getDescribe();
    picklist_values = field.getPicklistValues();

    for (Schema.PicklistEntry f : picklist_values) {
      if ( f.getLabel() != 'Wire' ) { // NOTE: exclude Wire payment method as an option, based on Business rule
        this.payment_preference_options.add( f.getLabel() );
      }
    }
  }

  public void add_emails(String id) {
    this.merchant_contacts = new List<DealWizardMerchantContact>();
    if(String.isNotBlank(id)){
      List<contact> contacts = [SELECT  Best_Contact_Method__c,
                                        Best_Contact_Time_of_Day__c,
                                        Email,
                                        Id,
                                        MobilePhone,
                                        Name,
                                        Phone

                                FROM    Contact

                                WHERE   AccountId =:id
                                ];
      for(Contact contact: contacts){
        this.merchant_contacts.add(new DealWizardMerchantContact(contact));
      }
    }
  }
}