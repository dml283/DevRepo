/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/26/02

* @Last Change: 2013/26/02 by MK

* Description.: Class to run after update on Account. Validates Tax ID # and Company Legal Name

* Dependencies: AccountTrigger, TINValidationServices
* ===================================================================
*/

public with sharing class TINValidationWorkflow implements TriggerWorkflow {
  Map<ID, Account> newMap;
  Map<ID, Account> oldMap;
  Map<ID, Account> accountsToValidate;
  List<ID> accountIdsToValidate;

  public TINValidationWorkflow (Map<ID, Account> newMap, Map<ID, Account> oldMap) {
    this.newMap = newMap;
    this.oldMap = oldMap;

    accountIdsToValidate = new List<ID>();
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      loadAccountsToValidate();
      validateTIN(accountIdsToValidate);

      hasExecuted = true;
    }
  }

  public void loadAccountsToValidate() {
    for(Account a: newMap.values()) {
      if((oldMap.get(a.Id).Company_Legal_Name__c != newMap.get(a.Id).Company_Legal_Name__c) || (oldMap.get(a.ID).Tax_ID__c != newMap.get(a.ID).Tax_ID__c)) {
        accountIdsToValidate.add(a.Id);
      }
    }
  }

  @future(callout=true) public static void validateTIN (List<ID> accountIDs) {
    List<Account> accountsToUpdate = new List<Account>();
    for(Account a : [SELECT Id, Tax_ID__c, Company_Legal_Name__c, Tin_Status__c, TIN_Status_Details__c FROM Account WHERE Id IN: accountIDs]) {
      if(a.Tax_ID__c == null) {
        a.Tin_Status__c = 'Invalid';
        a.TIN_Status_Details__c = 'Tax ID # is Required';
        accountsToUpdate.add(a);
      } else if(a.Company_Legal_Name__c == null) {
        a.Tin_Status__c = 'Invalid';
        a.TIN_Status_Details__c = 'Company Legal Name is Required';
        accountsToUpdate.add(a);
      } else if(a.Tax_ID__c != null && a.Company_Legal_Name__c != null) {
        if(a.Tax_ID__c.contains('-') == true) {
          string taxId = a.Tax_ID__c.replaceAll('\\D','');
          if(taxId.length() != 9) {
            a.Tin_Status__c = 'Invalid';
            a.TIN_Status_Details__c = 'Invalid TIN Format';
            accountsToUpdate.add(a);
          } else {
            TINValidationServices vti = new TINValidationServices(taxId, a.Company_Legal_Name__c);
            if(!Test.isRunningTest()) {
              a.Tin_Status__c = vti.returnStatus();
            }
            if(a.Tin_Status__c == 'Valid') {
              a.TIN_Status_Details__c = 'TIN Status is Valid';
            } else {
              a.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
            }
            accountsToUpdate.add(a);
          }
        } else { 
          if(a.Tax_ID__c.length() != 9) {
            a.Tin_Status__c = 'Invalid';
            a.TIN_Status_Details__c = 'Invalid TIN Format';
            accountsToUpdate.add(a);
          } else {
            TINValidationServices vti = new TINValidationServices(a.Tax_ID__c, a.Company_Legal_Name__c);
            if(!Test.isRunningTest()) {
              a.Tin_Status__c = vti.returnStatus();
            }
            if(a.Tin_Status__c == 'Valid') {
              a.TIN_Status_Details__c = 'TIN Status is Valid';
            } else {
              a.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
            }
            accountsToUpdate.add(a);
          }
        }
      }
    }
    Database.SaveResult[] SR = database.update(accountsToUpdate);
  }
}