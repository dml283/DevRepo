public class Constants {
	
	public static final String PROFILE_SYSTEM_ADMINISTRATOR;
	public static final String PROFILE_DELEGATED_ADMIN;
	public static final String PROFILE_API_ONLY;
	public static final String PROFILE_API_DEV;
	public static final String PROFILE_API_DEV_ENC;
	
	static{
		Map<String,String> mapSAprofileRecordTypes = new Map<String,String>();
	    for(RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType =: 'Profile']){
	       mapSAprofileRecordTypes.put(rt.Name,rt.Id);
	    }
	    PROFILE_SYSTEM_ADMINISTRATOR = mapSAprofileRecordTypes.get('System Administrator');
	    PROFILE_DELEGATED_ADMIN = mapSAprofileRecordTypes.get('Delegated Admin');
	    PROFILE_API_ONLY = mapSAprofileRecordTypes.get('API only');
	    PROFILE_API_DEV = mapSAprofileRecordTypes.get('API/DEV');
	    PROFILE_API_DEV_ENC = mapSAprofileRecordTypes.get('API/Dev_enc');  
	}
	
	public static final String TASK_STATUS_COMPLETED = 'Completed';
	
	//Additions by Naushad 1/29/2013
	public static final String EVENT_TYPE_MERCHANT_MEETING = 'Merchant Meeting';
	public static final String EVENT_TYPE_MERCHANT_CALL = 'Merchant Call';
	//Additions by Naushad 1/31/2013
	public static final String OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GETAWAYS = 'Groupon_Getaways';
	public static final String OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS = 'Rewards';
	public static final String OPPORTUNITY_RECORD_TYPE_DEV_NAME_G_TEAM = 'G_Team';
	public static final String OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GOODS = 'Groupon_Goods';
	public static final String OPPORTUNITY_RECORD_TYPE_DEV_NAME_G1 = 'G1';
	public static final String OPPORTUNITY_RECORD_TYPE_DEV_NAME_GLITE = 'gLite';
	//Additions by Naushad 2/1/2013
	public static final String ONLY_AVAILABLE_FOR_UNIT_TEST_EXCEPTION_MSG = 'This method can only be called from a unit class';
	//Additions by Naushad 2/7/2013
	public static final String QUANTUM_LEAD_FLAG_REASON_DUPLICATE = 'Duplicate';
	//Additions by Naushad 2/8/2013
	public static final String ZENDESK_QUANTUM_LEAD_INSTANCE = 'Quantum Lead'; 
	public static final String MISSING_ZENDESK_INSTANCE_ERROR = 'No ZenDesk Instance defined for Quantum Lead ticket creation in custom setting \'ZenDesk Instances\'';
	//additions by Naushad 2/11/13
	public static final String PROFILE_NAME_INSIDE_SALES = 'Inside Sales';
	public static final String PROFILE_NAME_OUSIDE_SALES = 'Outside Sales';
	
	public static final String DEAL_STRENGTH_REP_TAKING_INFO = 'Rep Getting Info';
	public static final String DEAL_STRENGTH_MERCHANT_MANAGER_TAKING_INFO = 'Merchant Manager Getting Info';
	public static final String DEAL_STRENGTH_VETTED = 'Vetted';
	
	public static final String FULFILLMENT_METHOD_DROP_SHIP_SUPPLIER_SMALL_PARCEL = 'Drop ship (Supplier small parcel)';
	public static final String FULFILLMENT_METHOD_DROP_SHIP_GROUPON_SMALL_PARCEL = 'Drop ship (Groupon small parcel)';
	public static final String FULFILLMENT_METHOD_POST_DEAL_PURCHASE_3PL = 'Post-deal purchase 3PL';
	public static final String FULFILLMENT_METHOD_PRE_DEAL_PURCHASE_3PL = 'Pre-deal purchase 3PL';
	
	public static final String OPPORTUNITY_STAGE_DEAL_STRUCTURE_APPROVED = 'Deal Structure Approved';
	public static final String COUNTRY_US = 'US';
	public static final String COUNTRY_CA = 'CA';
	public static final String STATE_AB = 'AB';
	public static final String STATE_BC = 'BC';
	public static final String STATE_MB = 'MB';
	public static final String STATE_NB = 'NB';
	public static final String STATE_NL = 'NL';
	public static final String STATE_NT = 'NT';
	public static final String STATE_NS = 'NS';
	public static final String STATE_NU = 'NU';
	public static final String STATE_ON = 'ON';
	public static final String STATE_PC = 'PC';
	public static final String STATE_QC = 'QC';
	public static final String STATE_SK = 'SK';
	public static final String STATE_YT = 'YT';
	
	public static boolean MESSAGE_BUS_FIRST_RUN = True; 
}