global class DealWizardMerchantAddress {

  public String account_id {get;set;}
  public String city {get;set;}
  public String country {get;set;}
  public String id {get;set;}
  public String phone_number {get;set;}
  public String postal_code {get;set;}
  public String state {get;set;}
  public String street_line_1 {get;set;}
  public String street_line_2 {get;set;}
  public String venue_name {get;set;}
  public List<DealWizardError> errors {get;set;}

  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
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

  public DealWizardMerchantAddress(Merchant_Addresses__c addy){
    this.account_id     = addy.Account__c;
    this.city           = addy.City__c;
    this.country        = addy.Country__c;
    this.id             = addy.Id;
    this.phone_number   = addy.Phone_Number__c;
    this.postal_code    = addy.Zip_Postal_Code__c;
    this.state          = addy.State_Province__c;
    this.street_line_1  = addy.Street_Line_1__c;
    this.street_line_2  = addy.Street_Line_2__c;
    this.venue_name     = addy.Venue_Name__c;
  }

  public Merchant_Addresses__c load_address_sobject(String id){
    return [SELECT  Street_Line_1__c,
                    Street_Line_2__c,
                    City__c,
                    State_Province__c,
                    Zip_Postal_Code__c,
                    Country__c,
                    Venue_Name__c,
                    Phone_Number__c,
                    Account__c

            FROM    Merchant_Addresses__c

            WHERE   Id = :id
            ];
  }

  public DealWizardMerchantAddress save(){
    Merchant_Addresses__c merchant_address = initialize_sobject_to_be_upserted();

    Database.UpsertResult result = Database.upsert(merchant_address, false);

    if (result.isSuccess() == true){
      String updated_address_id = result.getId();
      DealWizardMerchantAddress updated_address = new DealWizardMerchantAddress(load_address_sobject(updated_address_id));
      updated_address.errors = new List<DealWizardError>();
      return updated_address;
    } else if (result.errors.isEmpty() == false){
      this.errors = format_upsert_errors(result);
    }
    return this;
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

  private Merchant_Addresses__c initialize_sobject_to_be_upserted(){
    Merchant_Addresses__c merchant_address = new Merchant_Addresses__c(
      Street_Line_1__c    = this.street_line_1,
      Street_Line_2__c    = this.street_line_2,
      City__c             = this.city,
      Zip_Postal_Code__c  = this.postal_code,
      State_Province__c   = this.state,
      Country__c          = this.country,
      Venue_Name__c       = this.venue_name,
      Phone_Number__c     = this.phone_number,
      Account__c          = this.account_id,
      Id                  = this.id
   );
    return merchant_address;
 }
}