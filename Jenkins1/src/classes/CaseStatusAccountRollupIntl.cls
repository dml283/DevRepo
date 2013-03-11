/*
As a system, I want to be able to update an account when the status and the Locking Reason of an associated escalation case changes so that SF users will know the status of the escalation. 

Acceptance Criteria:
1. A trigger exists that will update the account with the escalation case status and the Locking Reason

Author : Ronald Ranjit

Version 1

Contact : ronald.ranjit@groupon.com
*/
public with sharing class CaseStatusAccountRollupIntl {
	
	public static void rollUpStatus(List<Case> cases){
    Set<Id> AccountIds=new Set<Id>();
    List<Id> recordTypes=new List<Id>(); 
    Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Global Escalation Cases').getRecordTypeId();
    recordTypes.add(recordType);
    for(Case c:cases){
      system.debug('Record type======>>>'+recordType+'*******case record type=========>>>>'+c.RecordTypeId);
      if(c.RecordTypeId==recordType)
      AccountIds.add(c.AccountId);
    }
    if(AccountIds.size()>0){
      system.debug('*****I AM HERE****');
      List<Account> Accounts=[select Account.Escalation_Status__c, Account.Locking_Reason__c from Account where id in :AccountIds];
      List<Case> caseList=[Select id,Case.Escalation_Status_Account__c,Case.Locking_Reason_Account__c,AccountId from Case where AccountId in :AccountIds and RecordTypeId in :recordTypes ];
      system.debug('account size===>'+Accounts.size());
      system.debug('case size=====>>'+caseList.size());
      Integer Severity;
      String reason;
      List<Account> accUpdate=new List<Account>();
      for(Account a:Accounts){
        Severity=0;
        reason='';
        for(Case c:caseList){
          if(c.AccountId==a.Id){
            accUpdate.add(a);
            if(c.Escalation_Status_Account__c!=null||c.Escalation_Status_Account__c!=''){
              if(c.Escalation_Status_Account__c=='Open Case/Escalation'){
                if(Severity>=1||Severity==0){
                  Severity=1;
                  system.debug('***********1*****'+c.Escalation_Status_Account__c+'**********'+c.Locking_Reason_Account__c);
                  a.Escalation_Status__c=c.Escalation_Status_Account__c;
                  a.Locking_Reason__c=c.Locking_Reason_Account__c;
                  
                }
              } else if(c.Escalation_Status_Account__c=='Burned Account'){
                if(Severity>=2||Severity==0){
                  Severity=2;
                  a.Escalation_Status__c=c.Escalation_Status_Account__c;
                  a.Locking_Reason__c=c.Locking_Reason_Account__c;
                  system.debug('***********2*****'+c.Escalation_Status_Account__c+'**********'+c.Locking_Reason_Account__c);
                }
                
              }else if(c.Escalation_Status_Account__c=='On Probation'){
                if(Severity>=3||Severity==0){
                  Severity=3;
                  a.Escalation_Status__c=c.Escalation_Status_Account__c;
                  a.Locking_Reason__c=c.Locking_Reason_Account__c;
                  system.debug('***********3*****'+c.Escalation_Status_Account__c+'**********'+c.Locking_Reason_Account__c);
                }
              }else if(c.Escalation_Status_Account__c=='Active'){
                if(Severity==4||Severity==0){
                  Severity=4;
                  a.Escalation_Status__c=c.Escalation_Status_Account__c;
                  a.Locking_Reason__c=c.Locking_Reason_Account__c;
                  system.debug('***********4*****'+c.Escalation_Status_Account__c+'**********'+c.Locking_Reason_Account__c);
                }
              }
            }
          }
        }
        
      }
      if(accUpdate.size()>0){
        try{
        	update Accounts;
        }catch(Exception e){
          system.debug('Error thrown');
        }
      }
    }
  }

}