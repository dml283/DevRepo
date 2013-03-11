global class SupportTaxonomyRecords {
//Waiting to Delete
/*
    public static void insertSupportTaxonomyRecords(List<Account> accountsInTrigger, Map<Id,Account> triggerNewMap, Map<Id,Account> triggerOldMap) {
        if (stopInsertSupportTaxonomyRecords.stopFutureCallout == false) {
            List<Id> accountIds = new List<Id>();
            List<String> servicesOfferedOld = new List<string>();
            List<String> servicesOfferedNew = new List<string>();
            List<String> categories = new List<string>();
    
            for (Account account : accountsInTrigger) {
                if (triggerOldMap.get(account.Id).Services_Offered__c != triggerNewMap.get(account.Id).Services_Offered__c) {
                    accountIds.add(account.Id);
    
                    if (triggerOldMap.get(account.Id).Services_Offered__c != null) {
                        servicesOfferedOld.add(triggerOldMap.get(account.Id).Services_Offered__c);
                    }
    
                    if (triggerNewMap.get(account.Id).Services_Offered__c != null) {
                        servicesOfferedNew.add(triggerNewMap.get(account.Id).Services_Offered__c);
                    }
                    categories.add(triggerNewMap.get(account.Id).Category_v3__c);
                }
            }
          
            List<insertSupportTaxonomyRecords.async_helper> async = new List<insertSupportTaxonomyRecords.async_helper>();
            async.add(new insertSupportTaxonomyRecords.async_helper(accountIds, servicesOfferedOld, servicesOfferedNew, categories));
            insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));
    
            stopInsertSupportTaxonomyRecords.stopFutureCallout = true;
        }
    }
*/
}