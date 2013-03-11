public class OpportunityTriggerFactoryPR {
	
	public static Boolean hasRunBefore
	{
	  	get
	  	{
	  		if(hasRunBefore == null)
	  			hasRunBefore = false;
	  		
	  		return hasRunBefore;
	  	}
	  	
	  	private set;
	}
  
	public static Boolean hasRunAfter
	{
		get
	  	{
	  		if(hasRunAfter == null)
	  			hasRunAfter = false;
	  		
	  		return hasRunAfter;
	  	}
	  	
	  	private set;
	}
	
    public List<Opportunity> triggerNew {get;set;}
    public List<Opportunity> triggerOld {get;set;}
    public Set<Id> triggerNew_id_set{get;set;}
    public Set<Id> triggerOld_id_set{get;set;}
    public Map<Id,Opportunity> triggernewmap{get;set;}
    public Map<Id,Opportunity> triggeroldmap{get;set;}
    public Map<Id,Account> account_map {get;set;}
    public List<Address__c> addresses {get;set;}
    public List<Multi_Deal__c> multiDealInTrigger {get;set;}

    List<Address__c> AddyInTrigger = new List<Address__c>();
    List<Zip_Code__c> Zips = new List<Zip_code__c>();
    List<Id> OppchildId = new List<Id>();
    List<TaxonmyMap__c> taxList = new list<TaxonmyMap__c>();
    List<Multi_Deal__c> multiDealsToUpdate = new List<Multi_Deal__c>();
    List<RecordType> rtList = new List<RecordType>();
    List <Quantum_Lead__c> ql = new List <Quantum_Lead__c>();
    List <Opportunity> initOppApprovalNeeded = new List <Opportunity>();
    Set<Id> account_id_set = new Set<Id>();
    Set<String> ZipText = new Set<String>();
    Set<String> merchant_center_ids = new Set<String>();
    Map<id,RecordType> RTMap = new map <id, RecordType>();
    Map<id,String> profileMap = new Map <Id, String>();
    Map<id,division__c> division_map = new map <id, division__c>();
    Map<String,Id> DivisionMapping  = new Map<String,Id>();
    Map<String,TaxonmyMap__c> taxMapNew = new Map<String,TaxonmyMap__c>();
    Map<String,TaxonmyMap__c> taxMapOld = new Map<String,TaxonmyMap__c>();
    Map<String,String> taxMapMisc = new Map<String,String>();
    Map<Id,String> OpptyZipMap = new Map<Id,String>();
    Map<String,Id> ZipMapSubDiv = new Map<String,Id>();
    Map<Id,List<Multi_Deal__c>> multiDealMap = new Map<Id,List<Multi_Deal__c>>();
    Map<Id,Opportunity> newOpptyMap = new Map<Id,Opportunity>();
    Map<Id,Opportunity> oldOpptyMap =  new Map<Id,Opportunity>();
    Map<String,TaxonmyMap__c> primaryServiceMap = new Map<String,TaxonmyMap__c>();
    Map<Id,String> profileName = new Map<Id,String>();
    Map<Id,String> userProfiles = new Map<Id,String>();

    //Constructor
    public OpportunityTriggerFactoryPR(list<opportunity> triggerNew, list<opportunity> triggerOld, set<id>TriggerNewId, set<id> TriggerOldId,Map<Id,Opportunity> Triggernmap,Map<Id,Opportunity> Triggeromap) {
        this.triggerNew = triggerNew;
        this.triggerOld = triggerOld;
        this.triggerNew_id_set = TriggerNewId;
        this.triggerOld_id_set = TriggerOldId;
        this.triggernewmap = Triggernmap;
        this.triggeroldmap = triggeromap;
    }
	/*
    //set up the data we will use, this manages all of the calls    
    public void init() {
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            loadAccounts();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            doDivisionMapping();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildmulti_subdiv_Addresslist();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildAddressMaps();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildZipMaps();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildprimaryServiceTaxonomyMap();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            createMerchantCenters();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildProfileNameMap();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildRecordTypeMap();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            queryQLrecords();
        }
    }

    public void initAfter() {
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            loadAccounts();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) { 
            buildMultiDealMap();
        }
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            buildTriggerMaps();
        }
    }
	
    public void buildTriggerMaps() {
        for(opportunity newOpp : triggernew) {
            newOpptyMap.put(newOpp.Id,newOpp);
        }

        for(opportunity oldOpp : triggerold) {
            oldOpptyMap.put(oldOpp.Id, oldOpp);
        }
    }
	*/
    /*where the magic happens  
    Triggers covered here : 
    1) PlaceCurrentAcctOwneronOppty     :  assignAccountManager()
    2) CityTeamAssignment               :  assignCityTeam()
    3) updateDivisions                  :  assignDivision()
    4) updatetaxonomy                   :  translateTaxonomy();
    5) AutomaticSubdivisonAssignment    :  assignAutoSubdivision();
    */

    public void run() {
    	/*
        if(system.isBatch() == false && system.isFuture() == false && batchapexstop.stopbatchapex == false) {
            for(opportunity o: TriggerNew) {              
                account_id_set.add(o.accountId);
            }

            init();

            for(opportunity o: TriggerNew) {
                if(Limits.getQueries() < Limits.getLimitQueries()) {         
                    system.debug('LOOP 1 complete' + Limits.getQueries() + Limits.getLimitQueries());        
                    assignAccountManager(o);
                }
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 2 complete' + Limits.getQueries() + Limits.getLimitQueries());
                    assignDivision(o);
                }
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 3 complete' + Limits.getQueries() + Limits.getLimitQueries());
                    assignCityTeam(o);
                }
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 4 complete'+ Limits.getQueries() + Limits.getLimitQueries());
                    assignAutoSubdivision(o);
                }
                
                //if(Limits.getQueries() < Limits.getLimitQueries()) {
                //    system.debug('LOOP  complete'+ Limits.getQueries() + Limits.getLimitQueries());
                //    assignmultiplesubdivs(o);
                //}
                
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 5 complete'+ Limits.getQueries() + Limits.getLimitQueries());
                    primaryServiceTaxonomyMap(o);
                }
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 6 complete'+ Limits.getQueries() + Limits.getLimitQueries());
                    copyQLfieldsToOpp(o);
               }
            }
            batchapexstop.stopbatchapex =true;
        }
        */
    }

    public void runAfter() {
    	/*
        List<Multi_Deal__c> multiDealsForUpdate = new List<Multi_Deal__c>();
        if(system.isBatch() == false && system.isFuture() == false) {
            for(opportunity o: TriggerNew) {              
                account_id_set.add(o.accountId);
            }

            initAfter();
            
			for(opportunity o: TriggerNew) {
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 8 complete'+ Limits.getQueries() + Limits.getLimitQueries());
                    multiDealsForUpdate = populateAccountOnMD(o);
                }
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    system.debug('LOOP 9 complete'+ Limits.getQueries() + Limits.getLimitQueries());
                    sendToNetsuite(o);
                }
            }
            database.update(multiDealsForUpdate);
        }
        */
    }

    //*******************INIT FUNCTIONS****************************
    /*
    public void queryQLrecords(){  
	    List<Id> qlAcctIds = new List <Id>(); 
	    List <Opportunity> initOppApprovalNeeded = [select Id, AccountId from Opportunity where ID in :triggerNew];
		
	    for(Opportunity o : initOppApprovalNeeded) {
	        if((triggernewmap.get(o.id).StageName != triggeroldmap.get(o.id).StageName) && triggernewmap.get(o.id).StageName == 'Approval Needed') {
	    		qlAcctIds.add(o.AccountId);
	        }
	    }
	    
        ql = [Select Sales_Value__c, Call_List_Priority__c, Highest_QL_Rank_90_Day__c, Highest_QL_Sales_Value_90_Day__c from Quantum_Lead__c where Account__c IN: qlAcctIds];
  	} 
  
    public void createMerchantCenters() {
        list<opportunity> merch_centers_needed = [select id, accountid from Opportunity where ID in :triggerNew AND account.Merchant_Permalink__c = null];
        for(opportunity o : merch_centers_needed) {
            if(triggernewmap.get(o.id).Deal_Strengh__c != triggeroldmap.get(o.id).Deal_Strengh__c && triggernewmap.get(o.id).Deal_Strengh__c =='Vetted') {
                merchant_center_ids.add(o.id);
            }
        }
        if(!Test.isRunningTest() || (Test.isRunningTest() && Limits.getFutureCalls() < Limits.getLimitFutureCalls()) )
            MerchantCenterAPI.createBulkMerchantCenter(merchant_center_ids);
    }

    public void buildprimaryServiceTaxonomyMap() {
        list<taxonmyMap__c> taxonomyMapList = [SELECT id, Object__c, Category_v3__c, Primary_Service__c, newCategory__c, newSubcategory__c, newSubcategory1__c, oldCategory__c, oldSubcategory__c FROM TaxonmyMap__c WHERE Object__c = 'Opportunity' AND Primary_Service__c != null];
        
        for(taxonmyMap__c tm : taxonomyMapList) {
            String s = tm.Category_v3__c + ' ' + tm.Primary_Service__c;
            primaryServiceMap.put(s,tm);
        }

        for(opportunity newOpp : triggernew) {
            newOpptyMap.put(newOpp.Id,newOpp);
        }

        for(opportunity oldOpp : triggerold) {
            oldOpptyMap.put(oldOpp.Id, oldOpp);
        }

    }

    public void loadAccounts(){
        account_map = new Map<id,account>([SELECT id, ownerid, Account_Manager__r.id FROM account WHERE ID in:account_id_set]);
    }

    //populates the division mapping    
    public void doDivisionMapping() {
        list<division__c> div = [select id, Name, City_CEO__c, DSM__c, Outside_DSM__c, Market_Planner__c, Manually_Assign_City_Team__c from Division__c];
        for(division__c d : div) {
            divisionMapping.put(d.name,d.id);
            division_map.put(d.Id,d);
        }
    }

    public void buildmulti_subdiv_Addresslist() {
        AddyInTrigger = [select id, Opportunity__c, Subdivision__r.name, Zip_Postal_Code_Auto_Assigned__c from Address__c WHERE Opportunity__c IN :Triggernew];
    }

    public void buildAddressMaps() {
        for(Address__c Addy : AddyInTrigger) {
            if(Addy.Zip_Postal_Code_Auto_Assigned__c != null) {
                ZipText.add(Addy.Zip_Postal_Code_Auto_Assigned__c);
                OpptyZipMap.put(Addy.Opportunity__c, Addy.Zip_Postal_Code_Auto_Assigned__c);
            }
        }   
    }

    public void buildZipMaps() {
        Zips = [Select name, Subdivision__c from Zip_Code__c where name in :ZipText];
        for(Zip_Code__c z : Zips) {
            ZipMapSubDiv.put(z.name, z.Subdivision__c);
        }
    }

    public void buildProfileNameMap() {
        Set<id> userOwnerId = new Set<Id>();
        for(Opportunity o : triggernew) {
            userOwnerId.add(o.owner.id);
        }

        List<User> users = [select id, Profile.Name from User where id in :userOwnerId];
        List<Profile> salesProfiles = [SELECT Id, Name FROM Profile WHERE Name =: 'Inside Sales' OR Name =: 'Outside Sales'];
        for(Profile p : salesProfiles) {
          profileMap.put(p.Id, p.Name);
        }
        system.debug('Profile Map' + profileMap);

        for(user u: users) {
            userProfiles.put(u.id,u.ProfileId);
        }

        for(opportunity o:triggernew) {
            profileName.put(o.id,profileMap.get(userProfiles.get(o.ownerid)));
        }
    }

    public void buildMultiDealMap() {
        List<Opportunity> opptyMDList = [SELECT Id, (SELECT Id, Account__c FROM Multi_Deals__r) FROM Opportunity WHERE Id in :TriggerNew];
        for(opportunity o: opptyMDList ) {
            multiDealMap.put(o.Id, o.Multi_Deals__r);
        }
    }

    public void buildRecordTypeMap() {
        rtList = [SELECT id, Name, sObjectType FROM RecordType WHERE sObjectType = 'Opportunity'];
        for(RecordType rt : rtList) {
            if(rt.sObjectType == 'Opportunity') {
                RTMap.put(rt.Id, rt);
            }
        }
    }

    //*******************MODIFIER FUNCTIONS****************************oi
    
   public void copyQLfieldsToOpp(Opportunity o){ 
        for(Quantum_Lead__c q: ql){ 
	      try
	      {
	       o.QL_Sales_Value__c = q.Sales_Value__c;
	       o.QL_Rank__c = q.Call_List_Priority__c; 
	       o.Highest_QL_Sales_Value_90_Day__c = q.Highest_QL_Sales_Value_90_Day__c;
	       o.Highest_QL_Rank_90_Day__c = q.Highest_QL_Rank_90_Day__c;
	      }
	      catch(DMLException e)
	      {
	        o.addError('There was a problem updating the Opportunity');
	      }
    	}    
  	}
    
    public void primaryServiceTaxonomyMap(opportunity o) {
        opportunity newOppty = newOpptyMap.get(o.Id);
        opportunity oldOppty = oldOpptyMap.get(o.Id);
        string s = o.category_v3__c + ' ' + o.Primary_Deal_Services__c;

        if(newOppty.Primary_Deal_Services__c != oldOppty.Primary_Deal_Services__c) {
            if(newOppty.Deal_Strengh__c == 'Rep Getting Info' || newOppty.Deal_Strengh__c == 'Merchant Manager Getting Info') {
                taxonmyMap__c primaryServiceUpdate = new taxonmyMap__c();
                if(s != null) {
                    primaryServiceUpdate = primaryServiceMap.get(s);
                }
                if(primaryServiceUpdate != null) {
                    if(o.category_v3__c == primaryServiceUpdate.Category_v3__c) {
                        newOppty.Category__c = primaryServiceUpdate.oldCategory__c;
                        newOppty.Subcategory__c = primaryServiceUpdate.oldSubcategory__c;
                        newOppty.Global_SFDC_Category__c = primaryServiceUpdate.newCategory__c;
                        newOppty.Global_SFDC_Subcategory_1__c = primaryServiceUpdate.newSubcategory__c;
                        newOppty.Global_SFDC_Subcategory_2__c = primaryServiceUpdate.newSubcategory1__c;
                    }
                }
            }
        }
    }

    public List<Multi_Deal__c> populateAccountOnMD(opportunity o) {
        List<Multi_Deal__c> multiDealReturnList = new List<Multi_Deal__c>();
        List<Multi_Deal__c> md = multiDealMap.get(o.Id);
        Account a = account_map.get(o.accountid);

        if(a != null) {
            for(Multi_Deal__c m : md) {
                if(m.Account__c != a.Id) {
                    m.Account__c = a.Id;
                    multiDealReturnList.add(m);
                }
            }
        }
        return multiDealReturnList;
    }

    public void assignAutoSubdivision(opportunity o) {
        system.debug('Loop 6');
        string ZipCodeName = OpptyZipMap.get(o.id);
        
        if(ZipCodeName !=null) {
            Id SubDiv = ZipMapSubDiv.get(ZipCodeName);
            o.Subdivision_Dynamic__c = SubDiv;
        }    
    }

    //Place Account Owner, Account Manager and Owner (Lookup) on Opportunity
    public void assignAccountManager(opportunity o) {
        system.debug('Loop 1');
        account a = account_map.get(o.accountid);
        system.debug('Account value here is' + a);
        if(a != null) {
            system.debug('I should not enter here');
            o.Acct_Owner__c = a.OwnerId;
            if(o.RecordTypeId == '012C0000000UK9N') {
                o.AccountCoordinator__c = a.Account_Manager__r.id;
            }
            o.Owner_lookup__c = o.OwnerId;
        }
    }

    // put the id of the division (table) on the oppty    
    public void assignDivision(opportunity o) {
        system.debug('Loop 3');
        o.Division_Dynamic__c = divisionMapping.get(o.division__c);
    }

    //assigns the city team    
    public void assignCityTeam(opportunity o) {
        system.debug('Loop 2');
        string profileString = profileName.get(o.id);
        system.debug('Owner Profile Name ' + profileString);
        RecordType rt = RTMap.get(o.recordtypeid);

        if(o.Division_Dynamic__c == NULL || rt.name == 'Groupon Getaways' || rt.name == 'G-Team' || rt.name == 'Groupon Goods' || rt.name == 'Rewards') {
            o.City_Manager__c = null;
            o.Divisional_Sales_Manager__c = null;
            o.User__c = null; 
        } else if((rt.name == 'G1' || rt.name == 'gLite') && (o.feature_date__c == NULL || o.feature_date__c >= system.TODAY())&& o.Division_Dynamic__c != NULL) {
            division__c d = division_map.get(o.division_dynamic__c);
            if (d.Manually_Assign_City_Team__c == false) {
                if (d.city_ceo__c != null) {
                    o.City_Manager__c = d.city_ceo__c;
                } else {
                    o.City_Manager__c = null;
                }

                if (d.dsm__c != null && (d.Outside_DSM__c == null || profileString != 'Outside Sales')) {
                    o.Divisional_Sales_Manager__c = d.dsm__c;
                } else if(d.Outside_DSM__c != null && profileString == 'Outside Sales') {
                    o.Divisional_Sales_Manager__c = d.Outside_DSM__c;
                } else {
                    o.Divisional_Sales_Manager__c = null;
                }

                if (d.market_planner__c != null) {
                    o.User__c = d.market_planner__c;
                } else {
                    o.User__c = null;
                }
            }
        } else {
            if(o.AccountCoordinator__c == null && rt.Name == 'Rewards') {
                account a = account_map.get(o.accountid);
                o.AccountCoordinator__c = a.Account_Manager__r.id;
            }
        }
    } 
    
      //Create PO in Netsuite when Stage is changed to Deal Structure Approved
    public void sendToNetsuite(opportunity o) {
      opportunity newOppty = newOpptyMap.get(o.Id);
      opportunity oldOppty = oldOpptyMap.get(o.Id);
      
      
      
      //if(newOppty.OwnerID == paul.ID || newOppty.OwnerID == jason.id){
        if (newOppty != null && oldOppty != null) {
          if (newOppty.StageName != oldOppty.StageName) {
            if ((newOppty.fulfillment_method__c == 'Drop ship (Supplier small parcel)')
             || (newOppty.fulfillment_method__c == 'Drop Ship (Groupon small parcel)')
             || (newOppty.fulfillment_method__c == 'Post-deal purchase 3PL')
             || (newOppty.fulfillment_method__c == 'Pre-deal purchase 3PL')){
              if (newOppty.StageName == 'Deal Structure Approved') { 
                ID rtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Groupon Goods').getRecordTypeId();               
                if (newOppty.RecordTypeID == rtype){
                  NetsuiteCreate.addOpportunity(o.Id);
                }
              }
            }
          } 
        }
      //}
    }  
    */
}