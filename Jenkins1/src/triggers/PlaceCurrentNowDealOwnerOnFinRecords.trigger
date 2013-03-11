trigger PlaceCurrentNowDealOwnerOnFinRecords on Financial_Records__c (before insert) {
/*
Current Version:1.0
Author: BF
Initail Build: 1/18/2012

Version History:
1.0 - Initial build

Test Class: ?
VF Pages Using This: 

Known Issues:


*/

    Set<Id> acct_ids = new set<Id>();
    for (Financial_Records__c F : trigger.new)
    {
        acct_ids.add(F.Account__c);
    }
    
    list<account> acctstoupdate = [SELECT id, Now_Deal_Owner__c
                              FROM account
                              WHERE ID in:acct_ids];
    map<Id, Id> acct_owners= new map<Id, Id>();
    for (Account a: acctstoupdate)
        {
        acct_owners.put(a.Id, a.now_deal_owner__c);
        }
    
    for (Financial_records__c f :trigger.new)
        {    
        f.Now_Deal_owner__c = acct_owners.get(f.account__c);
         }
}