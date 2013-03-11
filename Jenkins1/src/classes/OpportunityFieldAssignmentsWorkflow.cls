/* ===================================================================
* OpportunityFieldAssignmentsWorkflow

* @author.....: Naushad Rafique

* @date.......: 2013/13/02

* @Last Change: 2013/25/02 by SS

* Description.: Class udpates opportunity fields via OpptyTrigger

* Dependencies: OpptyTrigger, TriggerWorkflow
* ===================================================================
*/
public with sharing class OpportunityFieldAssignmentsWorkflow implements TriggerWorkflow
{
    Map<ID, Opportunity> newMap;
    Map<ID, Opportunity> oldMap;
    
    Map<ID, Account> accountMap;
    Map<String, ID> mapDivisionNameToDivisionID;
    Map<ID, Division__c> divisionMap;
    Map<ID, String> mapOpptyIDToZipCode;
    Map<String, ID> mapZipNameToSubDivision;
    Map<ID, String> mapOpptyToOwnerProfileName;
    Map<String, TaxonmyMap__c> mapPrimaryServiceToTaxonmy;
    
    
    public OpportunityFieldAssignmentsWorkflow(Map<ID, Opportunity> newMap, Map<ID, Opportunity> oldMap)
    {
        this.newMap = newMap;
        this.oldMap = oldMap;
        
        mapDivisionNameToDivisionID = new Map<String, ID>();
        divisionMap = new Map<ID, Division__c>();
        mapOpptyIDToZipCode = new Map<ID, String>();
        mapZipNameToSubDivision = new Map<String,ID>();
        mapOpptyToOwnerProfileName = new Map<ID, String>();
        mapPrimaryServiceToTaxonmy = new Map<String, TaxonmyMap__c>();
    }
    
    public static Boolean hasExecuted{get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;}  set;}
    //business logic
    public void execute()
    {
        if(!hasExecuted && !System.isBatch() && !System.isFuture() )
        {
            loadAccounts();
            loadDivisions();
            loadAddressAndZipMaps();
            loadProfileMap();
            loadprimaryServiceTaxonomyMap();
            
            for(Opportunity oppty: newMap.values())
            {
                assignAccountManager(oppty);
                assignDivision(oppty);
                assignCityTeam(oppty);
                assignAutoSubdivision(oppty);
                assignOpptyCategories(oppty);
                copyQLfieldsToOpp(oppty);
            }
            
            hasExecuted = true;
        }
        
    }
    
    private void loadAccounts()
    {
        Set<ID> accountIDs = new Set<ID>();
        for(opportunity o: newMap.values()) 
            accountIDs.add(o.accountId);
        
        accountMap = new Map<Id,Account>([SELECT id, ownerid, Account_Manager__r.id FROM account WHERE ID in: accountIDs]);
    }
    
    //populates the division mapping    
    private void loadDivisions()
    {
        for(Division__c d : [Select id, Name, City_CEO__c, DSM__c, Outside_DSM__c, Market_Planner__c, Manually_Assign_City_Team__c from Division__c]) 
        {
            mapDivisionNameToDivisionID.put(d.name,d.id);
            divisionMap.put(d.Id,d);
        }
    }
    
    private void loadAddressAndZipMaps()
    {
        Set<String> zipCodes = new Set<String>();
        for(Address__c add : [Select id, Opportunity__c, Subdivision__r.name, Zip_Postal_Code_Auto_Assigned__c from Address__c Where Opportunity__c IN: newMap.values()]) 
        {
            if(add.Zip_Postal_Code_Auto_Assigned__c != null) 
            {
                ZipCodes.add(add.Zip_Postal_Code_Auto_Assigned__c);
                mapOpptyIdToZipCode.put(add.Opportunity__c, add.Zip_Postal_Code_Auto_Assigned__c);
            }
        }
        
        if(zipCodes.size() > 0)
        {
            for(Zip_Code__c z : [Select Name, Subdivision__c from Zip_Code__c where name in :zipCodes]) 
                mapZipNameToSubDivision.put(z.name, z.Subdivision__c);
        }  
        
    }
    
    private void loadProfileMap() 
    {
        Map<Id, Opportunity> mapOpptyOwnerIDToOppty = new Map<ID, Opportunity>();
        for(Opportunity o : newMap.values()) 
            mapOpptyOwnerIDToOppty.put(o.OwnerID, o);
        
        for(User u : [Select id, Profile.Name 
                        From User 
                        Where id in : mapOpptyOwnerIDToOppty.keySet()
                        and (Profile.Name =: Constants.PROFILE_NAME_INSIDE_SALES OR Profile.Name =: Constants.PROFILE_NAME_OUSIDE_SALES )])
        {
            if(mapOpptyOwnerIDToOppty.containsKey(u.ID))
            {
                mapOpptyToOwnerProfileName.put( mapOpptyOwnerIDToOppty.get(u.ID).ID, u.Profile.Name );
            }
        }
    }
    
    private void loadPrimaryServiceTaxonomyMap() 
    {
        for(TaxonmyMap__c tm : [SELECT id, Object__c, Category_v3__c, Primary_Service__c, newCategory__c, newSubcategory__c, newSubcategory1__c, oldCategory__c, oldSubcategory__c 
                                FROM TaxonmyMap__c 
                                WHERE Object__c = 'Opportunity' 
                                AND Primary_Service__c != null]) 
        {
            String s = tm.Category_v3__c + ' ' + tm.Primary_Service__c;
            mapPrimaryServiceToTaxonmy.put(s,tm);
        }
    }
    
    
    public void assignAccountManager(Opportunity o) 
    {
        if(accountMap.containsKey(o.AccountID))
        {            
            o.Acct_Owner__c = accountMap.get(o.AccountID).OwnerID;
            o.Owner_lookup__c = o.OwnerID;
            if(OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS) == o.RecordTypeID)
                o.AccountCoordinator__c = accountMap.get(o.AccountID).Account_Manager__c;
        }
    }
    
    // put the id of the division (table) on the oppty    
    public void assignDivision(Opportunity o) 
    {
        if(mapDivisionNameToDivisionID.containsKey(o.Division__c))
            o.Division_Dynamic__c = mapDivisionNameToDivisionID.get(o.Division__c);
    }
    
    
    //assigns the city team    
    public void assignCityTeam(Opportunity o) 
    {
        String profileName = mapOpptyToOwnerProfileName.get(o.ID);
        
        if( o.Division_Dynamic__c == NULL || 
            o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GETAWAYS) ||
            o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_G_TEAM) ||
            o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GOODS) ||
            o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS) 
        )
        {
            o.City_Manager__c = null;
            o.Divisional_Sales_Manager__c = null;
            o.User__c = null; 
        } 
        else if(    (o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_G1) ||
                     o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GLITE) )
                && (o.feature_date__c == NULL || o.feature_date__c >= system.TODAY())
                && o.Division_Dynamic__c != NULL 
        )
        {
            Division__c d = divisionMap.get(o.Division_Dynamic__c);
            if (!d.Manually_Assign_City_Team__c) 
            {
                if (d.City_ceo__c != null) 
                    o.City_Manager__c = d.city_ceo__c;
                else 
                    o.City_Manager__c = null;
                

                if (d.dsm__c != null && (d.Outside_DSM__c == null || profileName != Constants.PROFILE_NAME_OUSIDE_SALES)) 
                    o.Divisional_Sales_Manager__c = d.dsm__c;
                else if(d.Outside_DSM__c != null && profileName == Constants.PROFILE_NAME_OUSIDE_SALES) 
                    o.Divisional_Sales_Manager__c = d.Outside_DSM__c;
                else 
                    o.Divisional_Sales_Manager__c = null;
                

                if (d.Market_Planner__c != null) 
                    o.User__c = d.Market_Planner__c;
                else 
                    o.User__c = null;
            }
        } 
        else 
        {
            if(o.AccountCoordinator__c == null && o.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS) && accountMap.containsKey(o.AccountID)) 
                o.AccountCoordinator__c = accountMap.get(o.AccountID).Account_Manager__c;
            
        }
    }
    
    public void assignAutoSubdivision(Opportunity o) 
    {
        if(mapOpptyIdToZipCode.containsKey(o.ID)) 
            o.Subdivision_Dynamic__c = mapZipNameToSubDivision.get(mapOpptyIDToZipCode.get(o.ID)); 
    }
    
    public void assignOpptyCategories(Opportunity o) 
    {
        String s = o.category_v3__c + ' ' + o.Primary_Deal_Services__c;

        if(o.Primary_Deal_Services__c != oldMap.get(o.ID).Primary_Deal_Services__c) 
        {
            if(o.Deal_Strengh__c == Constants.DEAL_STRENGTH_REP_TAKING_INFO|| o.Deal_Strengh__c == Constants.DEAL_STRENGTH_MERCHANT_MANAGER_TAKING_INFO) 
            {
                if(mapPrimaryServiceToTaxonmy.containsKey(s))
                {
                    TaxonmyMap__c primaryServiceUpdate = mapPrimaryServiceToTaxonmy.get(s);
                    if(o.category_v3__c == primaryServiceUpdate.Category_v3__c) 
                    {
                        o.Category__c = primaryServiceUpdate.oldCategory__c;
                        o.Subcategory__c = primaryServiceUpdate.oldSubcategory__c;
                        o.Global_SFDC_Category__c = primaryServiceUpdate.newCategory__c;
                        o.Global_SFDC_Subcategory_1__c = primaryServiceUpdate.newSubcategory__c;
                        o.Global_SFDC_Subcategory_2__c = primaryServiceUpdate.newSubcategory1__c;
                    }
                }
            }
        }
    }
    
    public void copyQLfieldsToOpp(Opportunity o)
    {
      List<Id> qlAcctIds = new List <Id>();       
        if( (newmap.get(o.id).StageName != oldmap.get(o.id).StageName) && newmap.get(o.id).StageName == 'Approval Needed') {
        	qlAcctIds.add(o.AccountId);
        }
        
        for(Account a: [Select Highest_Sales_Value__c, Highest_QL_Rank__c, Highest_QL_Rank_90_Day__c, Highest_QL_Sales_Value_90_Day__c from Account where Id IN: qlAcctIds]){
        try
        {
	         o.QL_Sales_Value__c = a.Highest_Sales_Value__c;
	         o.QL_Rank__c = String.valueOf(a.Highest_QL_Rank__c); 
	         o.Highest_QL_Sales_Value_90_Day__c = a.Highest_QL_Sales_Value_90_Day__c;
	         o.Highest_QL_Rank_90_Day__c = a.Highest_QL_Rank_90_Day__c;
	         //update current sales value from acct
	         //update current rank from acctt
        }
        
        catch(DMLException e)
        {
          o.addError('There was a problem updating the Opportunity');
        }
      }   
    }
    
}