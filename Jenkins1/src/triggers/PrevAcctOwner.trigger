/*
Current Version 2.0
Author: JJ
Initial Build: 8/1/11

Version History: 

2.0 - compare values and only populate if different (11/4/2011)
1.0 - initial build

Test Class:
TestPrevAcctOwner

VF References:
none
*/
trigger PrevAcctOwner on Account (before update) {


   map <id,string> OldAcctStatus = new map <id,string>();
   map <id,id> AcctIdPrevRepId = new map<id, id>();
   for (account a: trigger.old)
   {
       OldAcctStatus.put(a.id,a.Account_Status__c);
       AcctIdPrevRepId.put (a.id, a.ownerid);
   }
   
   for (Account a : trigger.new)
       if(a.ownerid != AcctIdPrevRepId.get(a.id))
           {
               a.previous_account_owner__c = AcctIdPrevRepId.get(a.id);
           }

   for (Account a :trigger.new)
       if(a.Account_Status__c != OldAcctStatus.get(a.id))
           {
               a.previous_acct_status__c = OldAcctStatus.get(a.id);   
           }

}