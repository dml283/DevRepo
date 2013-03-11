trigger UpdateNowTimeCoverage2 on NOW_Schedule__c (after update) {
list<NOW_Schedule__c> SchIds = [select Groupon_Now__r.Account_Name__r.id from NOW_Schedule__c where ID = :trigger.new];
set<id> AcctIds = new set<id>();
for(NOW_Schedule__c n : SchIds)
    {
        acctIds.add(n.Groupon_Now__r.Account_Name__r.id);
    }
asyncNOWTimeCoverageHelper.updateNowTime(AcctIds);
}