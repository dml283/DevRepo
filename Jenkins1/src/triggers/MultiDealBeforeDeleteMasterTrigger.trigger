trigger MultiDealBeforeDeleteMasterTrigger on Multi_Deal__c (before delete) {

DATE TODAY = system.today();

for(Multi_Deal__c md : [select id from Multi_deal__c where id = :trigger.oldMap.keySet() AND (opportunity__r.StageName = 'Closed Won' OR opportunity__r.Feature_Date__c <= today)]){
    trigger.oldMap.get(md.id).addError('You can not delete an option on a Closed Won or Featured Deal');
}

}