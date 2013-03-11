public class AccountBannerController {	
	private Account acct;
	public Integer qlp {get; set;}
	
	public AccountBannerController(ApexPages.StandardController controller) {
       this.acct = (Account)controller.getRecord();
       List <Quantum_Lead__c> getQls = [Select Call_List_Priority__c from Quantum_Lead__c WHERE Account__c =: this.acct.Id AND Call_List_Priority__c != '']; 
       
       if(getQls.size() > 0){
       	for(Quantum_Lead__c q: getQls){
	       	if(Integer.valueOf(q.Call_List_Priority__c) != 0){
		       		Quantum_Lead__c ql = q;
		       		qlp = Integer.valueOf(ql.Call_List_Priority__c) + 1;
		       	}else{
		       		qlp = null;
		       	}
		    }
		}
	}
    
}