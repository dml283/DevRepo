trigger afterUpdateAgreementUpdateOpportunity on echosign_dev1__SIGN_Agreement__c (after update) {
    Map<ID,Opportunity> mapOpptyStatus = new Map<ID,Opportunity>();
    for(Integer x = 0; x<Trigger.new.size(); x++){
    	if(Trigger.new[x].echosign_dev1__Opportunity__c!=null && Trigger.new[x].echosign_dev1__Status__c != Trigger.old[x].echosign_dev1__Status__c){
    		if(Trigger.new[x].echosign_dev1__Status__c == 'Signed')
    			mapOpptyStatus.put(Trigger.new[x].echosign_dev1__Opportunity__c, 
    				new Opportunity(Id=Trigger.new[x].echosign_dev1__Opportunity__c,StageName = 'Closed Won'));
    	}
    }
    update mapOpptyStatus.values();
}