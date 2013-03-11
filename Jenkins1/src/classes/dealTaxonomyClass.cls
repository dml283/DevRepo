public class dealTaxonomyClass {

  public Id ctrlId {get; set;}
  public String ctrlCat {get; set;}
  public String currentService {get; set;}
  public String primaryService {get; set;}
  public String successMessages {get; set;}
  public String errorMessages {get; set;}
  public String acctId {get; set;}


  public dealTaxonomyClass (ApexPages.StandardController controller) {
    ctrlId = ApexPages.currentPage().getParameters().get ('Id');
    Opportunity o = [SELECT AccountId, Primary_Deal_Services__c, Category_v3__c FROM Opportunity WHERE Id = : ctrlId];
    currentService = o.Primary_Deal_Services__c;
    acctId = o.AccountId;
    ctrlCat = o.Category_v3__c;
  }

  public Set <String> getPrimaryOptions() {
    String s = '';
    Set<String>primaryServices = new Set<String>();

    Account a = [SELECT Services_Offered__c FROM Account WHERE Id = : acctId];
    if (a.services_offered__c != null) {
      s += a.Services_Offered__c;
    } else {
      s += '';
    }
    Set<String> pList = formatList (s);
    return pList;
  }

  public Set<String> formatList (string s) {
    Set<String> sList = new set<string>();
    string[] sArray = s.split ('\\|');
    for (String a : sArray)
      if (a.length() > 0 && a.trim() != currentService) {
        slist.add (a);
      }
    return sList;
  }

  public void insertPrimaryService() {
    successMessages = '';
    errorMessages = '';
    Opportunity currentOpp = [SELECT Id, Primary_Deal_Services__c FROM Opportunity WHERE Id = : ctrlId];
    currentOpp.Primary_Deal_Services__c = primaryService;
    try {
      update currentOpp;
      successMessages = 'Your Selections have been Saved!';
    } catch (DMLexception e) {
      errorMessages = e.getDmlMessage (0);
    }
  }
}