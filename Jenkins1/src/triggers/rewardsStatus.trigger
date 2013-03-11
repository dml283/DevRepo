trigger rewardsStatus on Account (before update) {

    rewardsOfferStatus ros = new rewardsOfferStatus(trigger.newMap.keySet());
    for(account a:trigger.new){
            a.rewards_offer_status__c = ros.offerStatus.get(a.id);            
        }

}