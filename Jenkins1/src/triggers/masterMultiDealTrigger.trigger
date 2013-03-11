trigger masterMultiDealTrigger on Multi_Deal__c (before insert, before update, before delete, after update) {
 	if(Trigger.isBefore && Trigger.isInsert)
		TriggerServices.runTriggerWorkflow(new MultiDealAccountUpdateWorkflow(Trigger.New));
		
  List <Id> mdOpps = new List <Id>();
  List<Multi_deal__c> triggernew = new List<Multi_deal__c>();
  List<Multi_deal__c> triggerold = new List<Multi_deal__c>();
  Set<Id> oppIds = new Set<Id>();
  Map<Id,Multi_deal__c> triggernewmap = new Map<Id,Multi_deal__c>();
  Map<Id,Multi_deal__c> triggeroldmap = new Map<Id,Multi_deal__c>();
  List<Id> oppId  = new List<Id>();
  List<Id> userId = new List<Id>();
  Opportunity oppInfo  = new Opportunity();
  User uInfo = new User();
  String sku;
  Multi_Deal__c mdObj;
  
 if(Trigger.isBefore){	
 	Profile p = [Select name from Profile where Id =: UserInfo.getProfileId() ];
	  String profileName = String.valueOf(p);
    
	if(
	  profileName == Constants.PROFILE_API_DEV ||
	  profileName == Constants.PROFILE_API_DEV_ENC ||
	  profileName == Constants.PROFILE_API_ONLY ||
	  profileName == Constants.PROFILE_DELEGATED_ADMIN || 
	  profileName == Constants.PROFILE_SYSTEM_ADMINISTRATOR){ 
	  
    if(Trigger.isDelete){     
   		for(Multi_Deal__c md : [select Id from Multi_Deal__c where Id = :Trigger.oldMap.keySet() AND Opportunity__r.StageName = 'Closed Won']){
    		Trigger.oldMap.get(md.id).addError('You can not delete an option on a Closed Won Deal');
    	}
     }
    	 
	 if(Trigger.isInsert || Trigger.isUpdate){  
	 	
	 		    
	      for(Multi_Deal__c n: Trigger.new) {
	        if(n.Product_SKU__c != null){
	          mdOpps.add(n.Opportunity__c);
	          triggernewmap.put(n.Id, n);
	          mdObj = n;
	          sku = n.Product_SKU__c;
	        }
	      }

	      for(Multi_Deal__c m: [Select Id, Product_SKU__c from Multi_Deal__c m WHERE Opportunity__c = :mdOpps AND Id NOT IN: triggernewmap.keyset()]){
	        if(m.Product_SKU__c == sku){
	            mdObj.addError('This Sell SKU already exists on another Multi-Deal/Option for this Opportunity!');
	        }
	      }
   	   }
	}
  } 	 
  
  if(Trigger.isAfter){
    if(Trigger.isUpdate){
      if(!Test.isRunningTest() || (Test.isRunningTest() && Limits.getFutureCalls() < Limits.getLimitFutureCalls()) ) {
        for(Multi_deal__c multi: trigger.new) {
          oppIds.add(multi.Opportunity__c);
        }
                   
        Map<id,opportunity> oppsMap = new Map<id,opportunity>([SELECT Permalink__c FROM Opportunity WHERE Id IN :oppIds]);
                        
        for(Multi_deal__c multiOld: Trigger.old) {
          if(oppsMap.get(multiOld.Opportunity__c).Permalink__c != null) {
            triggerold.add(multiOld);
            triggeroldmap.put(multiOld.id, multiOld);
          }
        }
               
        for(Multi_deal__c multiNew: Trigger.new) {
          oppId.add(multiNew.Opportunity__c);
          userId.add(multiNew.lastmodifiedbyId);
                       
          if(oppsMap.get(multiNew.Opportunity__c).Permalink__c != null) {
            triggernew.add(multiNew);
            triggernewmap.put(multiNew.id, multiNew);
          }
        }
    
        if(oppId !=null && userId!=null) {
          oppInfo  = [select Id,account.name,type,permalink__c,division__c,Go_Live_Date__c from opportunity where Id=: OppId limit 1];
          uInfo = [select username,name from user where Id =:userId];
          zenDeskTicketSubmission.callZenddeskAPIformultideal(JSON.Serialize(triggernew),JSON.Serialize(triggerold),JSON.Serialize(triggernewmap),JSON.Serialize(triggeroldmap),JSON.Serialize(uInfo),JSON.Serialize(oppInfo));
        }
      }
    }
  }

}