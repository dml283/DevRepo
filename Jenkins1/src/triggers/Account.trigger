trigger Account on Account (before insert, before update, before delete, after update) {
//Waiting to Delete
/*
  List<Account> accountsInTrigger = new List<Account>();
  Set<Id> accountIdsForTaxValidation = new Set<Id>();

  if(Trigger.isDelete) {
    for(Account a : Trigger.old) {
      accountsInTrigger.add(a);
    }
   }else{
    for(Account a : Trigger.new) {
      accountsInTrigger.add(a);
    }
  }

  if (Trigger.isDelete) {
    QuantumLeadAccountUpdates.deleteDuplicateQLRecords(accountsInTrigger);
  }
  
  if(Trigger.isBefore){     
    if(Trigger.isInsert || Trigger.isUpdate){
        ACHChecksum.checkForValidRoutingNumber(accountsInTrigger);
        TaxonomyAccountMapping.updateAccountGlobalTaxonomy(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
    }
    
    if(Trigger.isUpdate){
        ACHUpdateDate.populateLastACHUpdate(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
        NowDealClosedBy.setNowDealClosedBy(accountsInTrigger);
        PreviousAccountData.setPreviousAccountOwner(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
        //PreviousAccountData.setPreviousAccountStatus(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
        SetRewardsOfferStatus.updateRewardsOfferStatus(accountsInTrigger,Trigger.NewMap.keySet());
        QuantumLeadAccountUpdates.populateQLFlagFields(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
        QuantumLeadAccountUpdates.qlFlagResolutionUpdates(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
    }
  }
    
    if(Trigger.isAfter){
        SupportTaxonomyRecords.insertSupportTaxonomyRecords(accountsInTrigger,Trigger.newmap,Trigger.oldmap);
        if(System.isFuture() == False) {
          for(Account account : accountsInTrigger) 
          {
            if(Trigger.oldMap.get(account.ID).Company_Legal_Name__c != Trigger.newMap.get(account.ID).Company_Legal_Name__c
              ||
               Trigger.oldMap.get(account.ID).Tax_ID__c != Trigger.newMap.get(account.ID).Tax_ID__c
            )
            {
                accountIDsForTaxValidation.add(account.ID);
            }
          }
        }
      if(Limits.getFutureCalls() < Limits.getLimitFutureCalls() && System.isFuture() == False && accountIDsForTaxValidation.size() > 0) {
        ValidateTaxId.validateAcct(accountIdsForTaxValidation);
      } 
   }     
*/
}