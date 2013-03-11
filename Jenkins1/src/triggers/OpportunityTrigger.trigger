trigger OpportunityTrigger on Opportunity (before insert, after insert, after update, after delete) {
	/*
  Profile p = [Select name from Profile where Id =: UserInfo.getProfileId() ];
  List<Id> OpportunityId = new List<Id>();
  List<opportunity> triggernew = new list<opportunity>();
  List<opportunity> triggerold = new list<opportunity>();

if(Trigger.isAfter) {
    if(Trigger.isInsert) {
      //MessageBus.notify('opportunity', 'create', Trigger.newMap.keySet()  ); 
      OpportunityTriggerUtil.createQuestions(Trigger.new, true, true,true);
    } else if(Trigger.isUpdate) {

       Set <Id> ids = new Set <Id>();
       for(Integer i=0; i<Trigger.new.size(); i++){
            if(Trigger.new[i].Deal_Strengh__c != 'A Sure Thing'){
                //MessageBus.notify('opportunity', 'update', Trigger.newMap.keySet()  ); 
            }else{
                if( (Trigger.new[i].Deal_Strengh__c != Trigger.old[i].Deal_Strengh__c) && Trigger.new[i].Deal_Strengh__c == 'A Sure Thing'){
                    ids.add(Trigger.new[i].Id);
                    //MessageBus.notify('opportunity', 'sure_thing', ids ); 
                }
            }
        }

      if(Zenddeskticket.stopfuturecall == false) {
        List<Id> AccountId = new List<Id>();
        List<Id> UserId    = new List<Id>();
        Map<Id,opportunity> triggernewmap = new Map<Id,opportunity>();
        Map<Id,opportunity> triggeroldmap = new Map<Id,opportunity>();
        Account AccountInfo = new Account();
        User Userinfo = new User();
              
        for(Opportunity oppOld : trigger.old) {
          if(oppOld.Permalink__c != null) {
            triggerold.add(oppOld);
            triggeroldmap.put(oppOld.id, oppOld);
          }
        }
                          
        for(opportunity Opp : Trigger.new) {
          AccountId.add(Opp.accountId);
          UserId.add(Opp.LastmodifiedbyId);
                      
          if(Opp.Permalink__c != null) {
            triggernew.add(Opp);
            triggernewmap.put(Opp.id, Opp);
          }
        }
     
        if(AccountId.size() > 0) {
          try {
            AccountInfo = [select Id,name,Groupon_Scheduler_Strength__c from account where Id=:AccountId];
          } catch(exception ex) {
            Return;
          }
        }
                  
        if(UserId.size() > 0) {
          Userinfo = [select Id,name,email from User where Id=:UserId];
        }
                  
        if(system.isBatch() == false && system.isFuture() == false) {
          if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()) {
            zenDeskTicketSubmission.callZenddeskAPIforOpp(JSON.Serialize(triggernew),JSON.Serialize(triggerold),JSON.Serialize(triggernewMap),JSON.Serialize(triggeroldMap),JSON.Serialize(AccountInfo),JSON.Serialize(Userinfo));
            Zenddeskticket.stopfuturecall = true;
          }
        }
      }     
      OpportunityTriggerUtil.updateQuestions(Trigger.old, Trigger.new);
    } else if(Trigger.isDelete) {
      //MessageBus.notify('opportunity', 'delete', Trigger.oldMap.keySet() ); 
      OpportunityTriggerUtil.deleteQuestions(Trigger.old, true, true);
    }
  } else if(Trigger.isBefore) {
    if(Trigger.isInsert) {
         if(!Test.isRunningTest() || (Test.isRunningTest() && Limits.getFutureCalls() < Limits.getLimitFutureCalls()) )
            OpportunityTriggerUtil.initializeOpportunities(Trigger.new);
        } 
    }
    */
}