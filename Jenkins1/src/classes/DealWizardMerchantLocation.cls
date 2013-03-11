public class DealWizardMerchantLocation {

  public String account_id {get;set;}
  public String city {get;set;}
  public string country {get;set;}
  public String id {get;set;}
  public String phone_number {get;set;}
  public String postal_code {get;set;}
  public String state {get;set;}
  public String street_line_1 {get;set;}
  public String street_line_2 {get;set;}
  public String venue_name {get;set;}

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

  public DealWizardMerchantLocation( Merchant_Addresses__c addy ) {

    this.account_id     = addy.Account__c;
    this.city           = addy.city__c;
    this.country        = addy.Country__c;
    this.id             = addy.id;
    this.phone_number   = addy.Phone_Number__c;
    this.postal_code    = addy.Zip_Postal_Code__c;
    this.state          = addy.State_Province__c;
    this.street_line_1  = addy.Street_Line_1__c;
    this.street_line_2  = addy.Street_Line_2__c;
    this.venue_name     = addy.Venue_Name__c;
  }

  public static void upsert_specified( List<Merchant_Addresses__c> merchant_addresses, DealWizardMerchant parent_merchant ) {
    try{
      Database.upsert( merchant_addresses );
    }
    catch ( DMLException dml_exception ) {

      parent_merchant.add_and_log_dml_exception_error( dml_exception, 'merchant_addresses', DealWizardMerchantLocation.sobject_to_json_field_map );
    }
    catch ( Exception anException ) {
      parent_merchant.add_and_log_exception_error( anException, 'merchant_addresses', DealWizardMerchantLocation.sobject_to_json_field_map );
    }
  }
  
  public Merchant_Addresses__c get_sobject() {

    Merchant_Addresses__c addy;
    if (this.id != null && this.id != '') { // case: find existing addresses
      addy = new Merchant_Addresses__c( id=this.id, account__c = this.account_id );
    }
    else {
      addy = new Merchant_Addresses__c( account__c = this.account_id );
    }
    addy.Street_Line_1__c = this.street_line_1;
    addy.Street_Line_2__c = this.street_line_2;
    addy.city__c = this.city;
    addy.Zip_Postal_Code__c = this.postal_code;
    addy.State_Province__c = this.state;
    addy.Country__c = this.country;
    addy.Venue_Name__c = this.venue_name;
    addy.Phone_Number__c = this.phone_number;
    return addy;
  }

}