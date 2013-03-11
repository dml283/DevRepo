/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/26/02

* @Last Change: 2013/26/02 by MK

* Description.: Class to run before insert or update on Account.  Maps back to Global Taxonomy from v3 and inserts Support Taxonomy records

* Dependencies: AccountTrigger
* ===================================================================
*/

public with sharing class AccountTaxonomyWorkflow implements TriggerWorkflow {
  Map<ID, Account> newMap;
  Map<ID, Account> oldMap;

  List<Id> accountIds;
  List<String> categories;
  List<String> servicesOfferedOld;
  List<String> servicesOfferedNew;
  Map<String, TaxonmyMap__c> taxonomyMap;

  public AccountTaxonomyWorkflow(Map<ID, Account> newMap, Map<ID, Account> oldMap) {
    this.newMap = newMap;
    this.oldMap = oldMap;

    accountIds = new List<Id>();
    categories = new List<string>();
    servicesOfferedOld = new List<string>();
    servicesOfferedNew = new List<string>();
    taxonomyMap = new Map<String, TaxonmyMap__c>();
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      loadTaxonomyMap();

      for (Account a : newMap.values()) {
        globalTaxonomyMapping(a);
        createSupportTaxonomyRecords(a);
      }

      hasExecuted = true;
    }
  }

  private void loadTaxonomyMap() {
    for (TaxonmyMap__c t : [select Object__c, Subcategory_v3__c, newCategory__c, newSubcategory__c from TaxonmyMap__c where Object__c = 'Lead/Account']) {
      taxonomyMap.put(t.Subcategory_v3__c, t);
    }
  }

  public void globalTaxonomyMapping (Account a) {
    if (a.Subcategory_v3__c != null && oldMap.get(a.Id).Subcategory_v3__c != a.Subcategory_v3__c) {
      TaxonmyMap__c t = taxonomyMap.get(a.Subcategory_v3__c);
      if (t != null) {   
        a.Global_SFDC_Category__c = t.newCategory__c;
        a.Global_SFDC_Subcategory_1__c = t.newSubcategory__c;
      }
    }
  }

  public void createSupportTaxonomyRecords (Account a) {
    if (stopInsertSupportTaxonomyRecords.stopFutureCallout == false) {
      if (oldMap.get(a.Id).Services_Offered__c != newMap.get(a.Id).Services_Offered__c) {
        accountIds.add(a.Id);
    
        if (oldMap.get(a.Id).Services_Offered__c != null) {
          servicesOfferedOld.add(oldMap.get(a.Id).Services_Offered__c);
        }
    
        if (newMap.get(a.Id).Services_Offered__c != null) {
          servicesOfferedNew.add(newMap.get(a.Id).Services_Offered__c);
        }
        categories.add(newMap.get(a.Id).Category_v3__c);
      }
          
      List<insertSupportTaxonomyRecords.async_helper> async = new List<insertSupportTaxonomyRecords.async_helper>();
      async.add(new insertSupportTaxonomyRecords.async_helper(accountIds, servicesOfferedOld, servicesOfferedNew, categories));
      insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));
    
      stopInsertSupportTaxonomyRecords.stopFutureCallout = true;
    }
  }
}