trigger insertSelectedTaxonomyRecordsAcct on Account (after update) {

    if(stopInsertSupportTaxonomyRecords.stopFutureCallout == false){
    list<insertSupportTaxonomyRecords.async_helper> async = new list<insertSupportTaxonomyRecords.async_helper>();
    List<ID> AccountId= new List<Id>();
    List<string> ServicesOfferedOld = new List<string>();
    List<string> ServicesOfferedNew = new List<string>();
    List<string> Category = new List<string>();
    
        for(account a : trigger.new){
                if(Trigger.oldMap.get(a.id).Services_Offered__c != Trigger.NewMap.get(a.id).Services_Offered__c){
                        AccountId.add(a.Id);
                        
                        if(Trigger.oldMap.get(a.id).Services_Offered__c != null){
                                ServicesOfferedOld.add(Trigger.oldMap.get(a.id).Services_Offered__c);
                            }
                        if(Trigger.NewMap.get(a.id).Services_Offered__c != null){
                                ServicesOfferedNew.add(Trigger.NewMap.get(a.id).Services_Offered__c);
                            }
                        Category.add(Trigger.NewMap.get(a.id).Category_v3__c);
                   }
            }
            
            async.add(new insertSupportTaxonomyRecords.async_helper(AccountId,ServicesOfferedOld,ServicesOfferedNew,Category));
            insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));
        
        stopInsertSupportTaxonomyRecords.stopFutureCallout = true;
   }

}