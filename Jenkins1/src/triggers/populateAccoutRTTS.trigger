//This trigger will compare old and new values of Rewards_Transaction_Tracking_Status__c on the Merchant_Address__c to see if they are changed.
//If the old and new values are different it will pass to class acctRewardsTransactionTrackingStatus which will evaluate the RTTS* on each address related to the account and update a new field on the account.
//*RTTS = Rewards Transaction Tracking Status - this is a field on the account object Rewards_Transaction_Tracking_Status__c
//Author: JJenkins
//v.01 Date: 06/14/2012 JJenkins
trigger populateAccoutRTTS on Merchant_Addresses__c (after update) {/*
    set<id> AcctIds = new set<id>(); 
    for(merchant_addresses__c ma : trigger.new){
            if(trigger.oldMap.get(ma.id).Rewards_Transaction_Tracking_Status__c != trigger.newMap.get(ma.id).Rewards_Transaction_Tracking_Status__c){
                    AcctIds.add(ma.Account__c);
                }
        }
    acctRewardsTransactionTrackingStatus rtts = new acctRewardsTransactionTrackingStatus();    
    rtts.updateAcctStatus(AcctIds);*/
}