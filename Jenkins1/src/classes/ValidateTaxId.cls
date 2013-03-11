public class ValidateTaxId {
//Waiting to Delete
/*
  public String tin {get; set;}
  public String legal_name {get; set;}
  public Id currentAccountId {get; set;}
  public Account currentAccount {get; set;}
  public Http http {get; set;}
  public HttpRequest req {get; set;}
  public HttpResponse res {get; set;}
  final String baseEndpoint = 'https://msse-staging.groupondev.com/v0/validations/tin_validation';
  
  public ValidateTaxId (ApexPages.StandardController ctrl) {
    currentAccountId = ctrl.getID();
  }
  
  public PageReference validateTINButton() {
      for(Account account : [SELECT Id, Tax_ID__c, Company_Legal_Name__c FROM Account WHERE Id =: currentAccountId]) {
        if(account.Tax_ID__c == null) {
          account.Tin_Status__c = 'Invalid';
          account.TIN_Status_Details__c = 'Tax ID # is Required';
        } else if(account.Company_Legal_Name__c == null) {
          account.Tin_Status__c = 'Invalid';
          account.TIN_Status_Details__c = 'Company Legal Name is Required';
        } else if(account.Tax_ID__c != null && account.Company_Legal_Name__c != null) {
          if(account.Tax_ID__c.contains('-') == true) {
            string taxId = account.Tax_ID__c.replaceAll('\\D','');
            system.debug('This is the Tax Id' + taxId);
            if(taxId.length() != 9) {
              account.Tin_Status__c = 'Invalid';
              account.TIN_Status_Details__c = 'Invalid TIN Format';
            } else {
              ValidateTaxId vti = new ValidateTaxId(taxId, account.Company_Legal_Name__c);
              account.Tin_Status__c = vti.returnStatus();
              if(vti.returnStatus() == 'Valid') {
                account.TIN_Status_Details__c = 'TIN Status is Valid';
              } else {
                account.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
              }
            }
          } else { 
            if(account.Tax_ID__c.length() != 9) {
              account.Tin_Status__c = 'Invalid';
              account.TIN_Status_Details__c = 'Invalid TIN Format';
            } else {
              ValidateTaxId vti = new ValidateTaxId(account.Tax_ID__c, account.Company_Legal_Name__c);
              account.Tin_Status__c = vti.returnStatus();
              if(vti.returnStatus() == 'Valid') {
                account.TIN_Status_Details__c = 'TIN Status is Valid';
              } else {
                account.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
              }
            }
          }
          update account;
        }
      }
      
      // Redirect the user back to the original page
      PageReference pageRef = new PageReference('/' + currentAccountId);
      pageRef.setRedirect(true);
      return pageRef;
    }

  @future(callout=true) public static void validateAcct (Set<Id> accountIdsForTaxValidation) {
    List<Account> accountsToUpdate = new List<Account>();
    for(Account account : [SELECT Id, Tax_ID__c, Company_Legal_Name__c FROM Account WHERE Id IN: accountIdsForTaxValidation]) {
      if(account.Tax_ID__c == null) {
        account.Tin_Status__c = 'Invalid';
        account.TIN_Status_Details__c = 'Tax ID # is Required';
        accountsToUpdate.add(account);
      } else if(account.Company_Legal_Name__c == null) {
        account.Tin_Status__c = 'Invalid';
        account.TIN_Status_Details__c = 'Company Legal Name is Required';
        accountsToUpdate.add(account);
      } else if(account.Tax_ID__c != null && account.Company_Legal_Name__c != null) {
        if(account.Tax_ID__c.contains('-') == true) {
          string taxId = account.Tax_ID__c.replaceAll('\\D','');
          system.debug('This is the Tax Id' + taxId);
          if(taxId.length() != 9) {
            account.Tin_Status__c = 'Invalid';
            account.TIN_Status_Details__c = 'Invalid TIN Format';
            accountsToUpdate.add(account);
          } else {
            ValidateTaxId vti = new ValidateTaxId(taxId, account.Company_Legal_Name__c);
            account.Tin_Status__c = vti.returnStatus();
            if(vti.returnStatus() == 'Valid') {
              account.TIN_Status_Details__c = 'TIN Status is Valid';
            } else {
              account.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
            }
            accountsToUpdate.add(account);
          }
        } else { 
          if(account.Tax_ID__c.length() != 9) {
            account.Tin_Status__c = 'Invalid';
            account.TIN_Status_Details__c = 'Invalid TIN Format';
            accountsToUpdate.add(account);
          } else {
            ValidateTaxId vti = new ValidateTaxId(account.Tax_ID__c, account.Company_Legal_Name__c);
            account.Tin_Status__c = vti.returnStatus();
            if(vti.returnStatus() == 'Valid') {
              account.TIN_Status_Details__c = 'TIN Status is Valid';
            } else {
              account.TIN_Status_Details__c = 'Tax ID # and Company Legal Name do not match';
            }
            accountsToUpdate.add(account);
          }
        }
      }
    }
    Database.SaveResult[] SR = database.update(accountsToUpdate);
  }

  public ValidateTaxId (String tin, String legal_name) {
    this.tin = tin;
    this.legal_name = legal_name;
    this.req = new HttpRequest();
    this.req.setMethod ('GET');
    this.req.setEndpoint (getURL(tin, legal_name));
    this.req.setTimeout(60000);
    this.http = new Http();
  }

  public string getURL (String tin, String legal_name) {
    string params = '?tin='
                    + EncodingUtil.urlEncode (tin, 'UTF-8')
                    + '&legal_name='
                    + EncodingUtil.urlEncode (legal_name, 'UTF-8');
    return baseEndpoint + params;
  }

  public void sendRequest() {
    res = http.send (req);
  }

  public boolean isRequestValid() {
    if (res.getStatusCode() == 200) {
      return true;
    } else {
      return false;
    }
  }

  public class TinStatus {
    public String valid {get; set;}
    public String feedback {get; set;}
  }

  
  public string returnStatus () {
    String tin_status;
    sendRequest();
    TinStatus ts = (TinStatus)JSON.deserialize (res.getBody(), TinStatus.class);
    if (isRequestValid()) {
      if (ts.valid == 'true'){
        tin_status = 'Valid';
        return tin_status;
      }else {
        tin_status = 'Invalid';
        return tin_status;
      }
    } else {
      tin_status = 'Invalid';
      return tin_status;
    }
  }
*/
}