public class ValidateTINController {

  public Id currentAccountId {get; set;}

  public ValidateTINController (ApexPages.StandardController ctrl) {
    currentAccountId = ctrl.getID();
  }

  public PageReference validateTINButton() {
    for (Account account : [SELECT Id, Tax_ID__c, Company_Legal_Name__c, Tin_Status__c, TIN_Status_Details__c FROM Account WHERE Id = : currentAccountId]) {
      if (account.Tax_ID__c == null) {
        account.Tin_Status__c = 'Invalid';
        account.TIN_Status_Details__c = 'Tax ID # is Required';
      } else if (account.Company_Legal_Name__c == null) {
        account.Tin_Status__c = 'Invalid';
        account.TIN_Status_Details__c = 'Company Legal Name is Required';
      } else if (account.Tax_ID__c != null && account.Company_Legal_Name__c != null) {
        if (account.Tax_ID__c.contains ('-') == true) {
          string taxId = account.Tax_ID__c.replaceAll ('\\D', '');
          if (taxId.length() != 9) {
            account.Tin_Status__c = 'Invalid';
            account.TIN_Status_Details__c = 'Invalid TIN Format';
          } else {
            TINValidationServices vti = new TINValidationServices(taxId, account.Company_Legal_Name__c);
            if(!Test.isRunningTest()) {
              account.Tin_Status__c = vti.returnStatus();
            }
            if (account.Tin_Status__c == 'Valid') {
              account.TIN_Status_Details__c = 'TIN Status is Valid';
            } else {
              account.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
            }
          }
        } else {
          if (account.Tax_ID__c.length() != 9) {
            account.Tin_Status__c = 'Invalid';
            account.TIN_Status_Details__c = 'Invalid TIN Format';
          } else {
            TINValidationServices vti = new TINValidationServices(account.Tax_ID__c, account.Company_Legal_Name__c);
            if(!Test.isRunningTest()) {
              account.Tin_Status__c = vti.returnStatus();
            }
            if (account.Tin_Status__c == 'Valid') {
              account.TIN_Status_Details__c = 'TIN Status is Valid';
            } else {
              account.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
            }
          }
        }
      }
      update account;
    }

    // Redirect the user back to the original page
    PageReference pageRef = new PageReference ('/' + currentAccountId);
    pageRef.setRedirect (true);
    return pageRef;
  }
}