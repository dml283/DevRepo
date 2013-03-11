@isTest
private class TestAccountBannerController {

    static testMethod void testQL() {
    	Test.startTest();
	    	Account acct = TestUtil.createAccount('Test');
	    	Integer qlp;
	    	
	    	List <Quantum_Lead__c> qls = new List <Quantum_Lead__c>();
	    	
	    	Quantum_Lead__c ql = new Quantum_Lead__c();
	    	ql.Account__c = acct.id;
	    	ql.Call_List_Priority__c = '7';
	    	ql.Parent_Id__c = '123';
	    	insert ql;
	    	qls.add(ql);
	    	
	    	AccountBannerController controller = new AccountBannerController(new ApexPages.StandardController(acct) );
	    	
	    	List <Quantum_Lead__c> getQls = [Select Call_List_Priority__c from Quantum_Lead__c WHERE Account__c =: acct.Id LIMIT 1]; 
	    	
	    	for(Quantum_Lead__c q: getQls){
		    	if(getQls.size() > 0){
			       	if(Integer.valueOf(ql.Call_List_Priority__c) != 0){
				       		ql = q;
				       		qlp = Integer.valueOf(ql.Call_List_Priority__c) + 1;
			       	}else{
			       		qlp = null;
			       	}
			    }
	    	}
	    	
	    	System.assertEquals(qlp, 8);
	    	   
       Test.stopTest();  	
    }
}