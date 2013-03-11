global class TaxonomyAccountMapping {
//Waiting to Delete
/*
    public static void updateAccountGlobalTaxonomy(List<Account> accountsInTrigger, Map<Id,Account> triggerNewMap, Map<Id,Account> triggerOldMap) {
        Map<String, TaxonmyMap__c> taxonmyMaps = new Map<String, TaxonmyMap__c>();

        for (TaxonmyMap__c taxonmyMap : [select Object__c, Subcategory_v3__c, newCategory__c, newSubcategory__c from TaxonmyMap__c where Object__c = 'Lead/Account']) {
            taxonmyMaps.put(taxonmyMap.Subcategory_v3__c, taxonmyMap);
        }
    
        for (Account account : accountsInTrigger) {
            if(triggerOldMap == null) {
                if(account.Subcategory_v3__c != null) {
                    TaxonmyMap__c taxonmyMap = taxonmyMaps.get(account.Subcategory_v3__c);
                    if (taxonmyMap != null) {   
                        account.Global_SFDC_Category__c = taxonmyMap.newCategory__c;
                        account.Global_SFDC_Subcategory_1__c = taxonmyMap.newSubcategory__c;
                    }
                }
            } else if (triggerOldMap != null) {
                if (account.Subcategory_v3__c != null && triggerOldMap.get(account.Id).Subcategory_v3__c != account.Subcategory_v3__c) {
                    TaxonmyMap__c taxonmyMap = taxonmyMaps.get(account.Subcategory_v3__c);
                    if (taxonmyMap != null) {   
                        account.Global_SFDC_Category__c = taxonmyMap.newCategory__c;
                        account.Global_SFDC_Subcategory_1__c = taxonmyMap.newSubcategory__c;
                    }
                }
            }
        }
    }
*/
}