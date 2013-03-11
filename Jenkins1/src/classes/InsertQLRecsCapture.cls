global class InsertQLRecsCapture implements database.Batchable<SObject>, Database.Stateful {	
	public String query; //for tests
	
	global Database.QueryLocator start (Database.BatchableContext bc) {		
    	query = ' SELECT Id, Sales_Value__c, Call_List_Priority__c FROM Quantum_Lead__c WHERE Sales_Value__c != null AND Call_List_Priority__c != null' ;
    	return Database.getQueryLocator (query);
  }
  
   global void execute (Database.BatchableContext BC, List<sObject> scope) {
  		List<Quantum_Lead__c> qls = (List<Quantum_Lead__c>) scope;
  		List <QL_SalesVal__c> qlSalesValsInsert = new List <QL_SalesVal__c>();
	    List <QL_RankVal__c> qlRankValsInsert = new List<QL_RankVal__c>();

		for(Quantum_Lead__c q: qls){   			
			qlSalesValsInsert.add( 
				new QL_SalesVal__c( 
				Date__c = System.today(), 
				Quantum_Lead__c = q.Id, 
				Value__c = q.Sales_Value__c ));
					
			qlRankValsInsert.add(
				new QL_RankVal__c( 
				Date__c = System.today(), 
				Quantum_Lead__c = q.Id, 
				Value__c = Decimal.valueOf(q.Call_List_Priority__c)) );
		}				
		database.insert (qlSalesValsInsert);
		database.insert (qlRankValsInsert);
  }

  global void finish (Database.BatchableContext bcMain) {
  		Date ninetyOneDaysAgo = System.today() - 91;

    	List <QL_RankVal__c> deleteOldRankVals = [SELECT Id FROM QL_RankVal__c WHERE Date__c <=: ninetyOneDaysAgo ];
	    List <QL_SalesVal__c> deleteOldSalesVals = [SELECT Id FROM QL_SalesVal__c WHERE Date__c <=: ninetyOneDaysAgo ];
 
    	Database.delete(deleteOldSalesVals);
    	Database.delete(deleteOldRankVals);
  }
}