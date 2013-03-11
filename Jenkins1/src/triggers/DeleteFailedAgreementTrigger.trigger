trigger DeleteFailedAgreementTrigger on echosign_dev1__SIGN_Trigger__c (after insert, after update) {
	List<echosign_dev1__SIGN_Trigger__c> agreementTriggers = new List<echosign_dev1__SIGN_Trigger__c>();
	
	for( echosign_dev1__SIGN_Trigger__c agreementTrigger : Trigger.new ) {
		if( agreementTrigger.echosign_dev1__Status__c == 'Success' ) {
			continue;
		}
		
		echosign_dev1__SIGN_Trigger__c newTrigger = new echosign_dev1__SIGN_Trigger__c(Id = agreementTrigger.Id);
		
		agreementTriggers.add(newTrigger);
	}
	
	List<echosign_dev1__SIGN_Trigger__c> totalTriggers = [SELECT Id from echosign_dev1__SIGN_Trigger__c where echosign_dev1__Status__c != 'Success'];
	if( totalTriggers.size() > 1 ) {
		delete agreementTriggers;
	}
}