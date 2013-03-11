public class DealWizardRedemptionLocation {

  public String city {get;set;}
  // TODO: consider changing Id to String type, to avoid invalid id error on null/blank check
  public String id {get;set;}
  public String merchant_address_id {get;set;}
  public String phone_number {get;set;}
  public String postal_code {get;set;}
  public String state {get;set;}
  public String street_line_1 {get;set;}
  public String street_line_2 {get;set;}
  public String country {get;set;}
  public String venue_name {get;set;}

  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      'City__c'               => 'city',
      'id'                    => 'id',
      'Merchant_Addresses__c' => 'merchant_address_id',
      'Phone_Number__c'       => 'phone_number',
      'Zip_Postal_Code__c'    => 'postal_code',
      'State__c'              => 'state',
      'Street_Line_1__c'      => 'street_line_1',
      'Street_Line_2__c'      => 'street_line_2',
      'Country__c'            => 'country',
      'Venue_Name__c'         => 'venue_name'
    };

  public DealWizardRedemptionLocation( address__c addy ) {
    this.id = addy.id;
    this.merchant_address_id = addy.Merchant_Addresses__c;
    this.street_line_1 = addy.Street_Line_1__c;
    this.street_line_2 = addy.Street_Line_2__c;
    this.city = addy.city__c;
    this.postal_code = addy.Zip_Postal_Code__c;
    this.state = addy.State__c;
    this.country = addy.Country__c;
    this.venue_name = addy.Venue_Name__c;
    this.phone_number = addy.Phone_Number__c;
  }

  public static void load_all_for( DealWizardDeal deal ) {

    for ( address__c  addy: deal.opportunity.Addresses__r ) {

      deal.redemption_locations.add( new DealWizardRedemptionLocation( addy ) );
    }
  }
  
  public static String build_redemption_location_query_string() {
  	return ' SELECT ' +
        'City__c, ' +
        'Country__c, ' +
        'id, ' +
        'Merchant_Addresses__c, ' +
        'Name, ' +
        'Phone_Number__c, ' +
        'State__c, ' +
        'Street_Line_1__c, ' +
        'Street_Line_2__c, ' +
        'Venue_Name__c, ' +
        'Zip_Postal_Code__c FROM Addresses__r ';
  }

  public Address__c get_sobject(id deal_id, id merch_addy_id){
    Merchant_Addresses__c parent = [select id, Street_Line_1__c, Street_Line_2__c, City__c,Zip_Postal_Code__c,State_Province__c, Country__c, Venue_Name__c, Phone_Number__c FROM Merchant_Addresses__c WHERE id = :merch_addy_id LIMIT 1];
    Address__c addy = new Address__c();
    if(parent.id!=null){
      addy.Opportunity__c = deal_id;
      addy.Merchant_Addresses__c = merch_addy_id;
      addy.Street_Line_1__c = parent.Street_Line_1__c;
      addy.Street_Line_2__c = parent.Street_Line_2__c;
      addy.City__c = parent.city__c;
      addy.Zip_Postal_Code__c = parent.Zip_Postal_Code__c;
      addy.State__c = parent.State_Province__c;
      addy.Country__c = parent.Country__c;
      addy.Venue_Name__c = parent.venue_name__c;
      addy.phone_number__c = parent.phone_number__c;      
    }
    return addy;
  }
  
}