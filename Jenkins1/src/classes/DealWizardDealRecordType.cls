global class DealWizardDealRecordType {

  public String id {get; set;}
  public String name {get; set;}

  public DealWizardDealRecordType() {
    initialize();
  }

  public DealWizardDealRecordType( String record_type_id, String record_type_name ) {
    initialize();
    id = record_type_id;
    name = record_type_name;
  }

  public void initialize() {
    id = '';
    name = '';
  }

  public static DealWizardDealRecordType find( String record_type_id ) {

    Map<Id, Schema.RecordTypeInfo> id_to_record_type_info_map = Opportunity.SObjectType.getDescribe().getRecordTypeInfosById();
    String record_type_name;

    if ( id_to_record_type_info_map.containsKey( record_type_id ) ) {
      record_type_name = id_to_record_type_info_map.get( record_type_id ).getName();
    }
    return DealWizardDealRecordType.build( record_type_id, record_type_name );
  }

  public static DealWizardDealRecordType find_by_name( String record_type_name ) {

    Map<String, Schema.RecordTypeInfo> name_to_record_type_info_map = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
    String record_type_id;

    if ( name_to_record_type_info_map.containsKey( record_type_name ) ) {
      record_type_id = name_to_record_type_info_map.get( record_type_name ).getRecordTypeId();
    }
    return DealWizardDealRecordType.build( record_type_id, record_type_name );
  }

  public static DealWizardDealRecordType build( String record_type_id, String record_type_name ) {

    if ( LibraryString.exist_and_are_not_blank( record_type_id, record_type_name ) ) {
      return new DealWizardDealRecordType( record_type_id, record_type_name  );
    }
    return new DealWizardDealRecordType();
  }

}