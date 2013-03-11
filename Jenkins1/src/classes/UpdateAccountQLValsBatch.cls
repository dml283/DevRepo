global class UpdateAccountQLValsBatch implements database.Batchable<SObject>, Database.Stateful {	
	public String query; //for tests
	public Date NinetyDaysAgo = System.today() - 90; 
	
	  global Database.QueryLocator start (Database.BatchableContext bc) {
	  		System.debug('sonja in start');
	  		Date todayVal = System.today();    
	    	query = ' SELECT id,Highest_QL_Rank__c,Highest_Sales_Value__c,Call_List_Priority__c FROM Account WHERE Evaluate_Merchant_Status__c = True OR LastActivityDate =: todayVal OR LastActivityDate =: NinetyDaysAgo OR Most_Recent_Expiry_Date__c =: todayVal';
	    	return Database.getQueryLocator (query);
	  }
  
	  global void execute (Database.BatchableContext BC, List<sObject> scope) {
	  		List<Account> accounts = (List<Account>) scope;
		    List<Quantum_Lead__c> qls = [Select Id, Highest_QL_Rank_90_Day__c, Highest_QL_Sales_Value_90_Day__c from Quantum_Lead__c where Account__c IN: accounts];    	
			List<Account> acctsToUpdate = new List<Account>();
		    
		    for(Account a: accounts){  
		    	for(Quantum_Lead__c q: qls){
			    	a.Highest_QL_Rank_90_Day__c = q.Highest_QL_Rank_90_Day__c;
					a.Highest_QL_Sales_Value_90_Day__c = q.Highest_QL_Sales_Value_90_Day__c;
		    	}
			 acctsToUpdate.add(a);
			}
			database.update (acctsToUpdate);
	  }
	  
	  global void finish (Database.BatchableContext bcMain) {
	
	  }

}