public class LeadUpdateTaxonomy extends DispatchClient {

  public override void execute(DispatchContext context) {
    list < taxonmyMap__c > taxList = [select id, Object__c, Category_v3__c, Subcategory_v3__c, oldCategory__c, oldSubcategory__c, newCategory__c, newSubcategory__c, newSubcategory1__c, direct__c from TaxonmyMap__c];
    map < string, taxonmyMap__c > taxMapNewGlobal = new map < string, taxonmyMap__c > ();
    map < string, taxonmyMap__c > taxMapNewV3 = new map < string, taxonmyMap__c > ();
    map < string, taxonmyMap__c > taxMapOld = new map < string, taxonmyMap__c > ();
    map < string, string > taxMapMisc = new map < string, string > ();

    for(taxonmyMap__c t: taxList) {
      taxMapNewGlobal.put(t.newSubcategory__c, t);
      taxMapNewV3.put(t.Subcategory_v3__c, t);
      taxMapMisc.put(t.newCategory__c, t.oldCategory__c);
    }

    if (context.isInsert()) {
      for(lead l: (List<Lead>) context.newList()) {
        // Maps from global taxonomy to old taxonomy if v3 is blank (GrouponLive)
        if(l.Global_SFDC_Category__c == 'GrouponLive' && l.Global_SFDC_Subcategory_1__c != null && l.Category_v3__c == null) {
          l.category__c = 'GrouponLive';
          l.subcategory__c = l.Global_SFDC_Subcategory_1__c;
        }
        // Maps from global taxonomy to old taxonomy if v3 is blank (not GrouponLive)
        if(l.Global_SFDC_Subcategory_1__c != null && l.Global_SFDC_Category__c != 'GrouponLive' && l.Category_v3__c == null) {
          system.debug('---------inside the new map: global to old');
          taxonmyMap__c t = new TaxonmyMap__c();
          t = taxMapNewGlobal.get(l.Global_SFDC_Subcategory_1__c);
          if(t != null && t.Object__c == 'Lead/Account') {
            l.subcategory__c = t.oldSubcategory__c;
            l.category__c = t.oldCategory__c;
          }
        }
        // Maps from v3 taxonomy to global and old taxonomy
        if(l.Subcategory_v3__c != null) {
          system.debug('---------inside the new map: v3 to global and old');
          taxonmyMap__c t = new TaxonmyMap__c();
          t = taxMapNewV3.get(l.Subcategory_v3__c);
          if(t != null && t.Object__c == 'Lead/Account') {
            l.Global_SFDC_Category__c = t.newCategory__c;
            l.Global_SFDC_Subcategory_1__c = t.newSubcategory__c;
            l.subcategory__c = t.oldSubcategory__c;
            l.category__c = t.oldCategory__c;
          }
        }
      }
    } else {

      map < id, lead > oldMap = new map < id, lead > ();
      map < id, lead > newMap = new map < id, lead > ();

      for(lead leadOld: (List<Lead>) context.oldList()) {
        oldMap.put(leadOld.id, leadOld);
      }
      for(lead leadNew: (List<Lead>) context.newList()) {
        newMap.put(leadNew.id, leadNew);
      }

      for(lead l: (List<Lead>) context.newList()) {
        lead oldL = oldMap.get(l.id);
        lead newL = newMap.get(l.id);

        system.debug('---------lets debug');
        // Maps from global taxonomy to old taxonomy if v3 is blank (GrouponLive)
        if(l.Global_SFDC_Category__c == 'GrouponLive' && l.Global_SFDC_Subcategory_1__c != null && l.Category_v3__c == null) {
          l.category__c = 'GrouponLive';
          l.subcategory__c = l.Global_SFDC_Subcategory_1__c;
        }

        // Maps from global taxonomy to old taxonomy if v3 is blank (not GrouponLive)
        if(l.Global_SFDC_Subcategory_1__c != null && l.Global_SFDC_Category__c != 'GrouponLive' && l.Category_v3__c == null) {
          system.debug('---------inside the new map: global to old');
          taxonmyMap__c t = new TaxonmyMap__c();
          t = taxMapNewGlobal.get(l.Global_SFDC_Subcategory_1__c);
          if(t != null && t.Object__c == 'Lead/Account') {
            l.subcategory__c = t.oldSubcategory__c;
            l.category__c = t.oldCategory__c;
          }
        }

        // Maps from v3 taxonomy to global and old taxonomy
        if(l.Subcategory_v3__c != null && oldL.Subcategory_v3__c != newL.Subcategory_v3__c) {
          system.debug('---------inside the new map: v3 to global and old');
          taxonmyMap__c t = new TaxonmyMap__c();
          t = taxMapNewV3.get(l.Subcategory_v3__c);
          if(t != null && t.Object__c == 'Lead/Account') {
            l.Global_SFDC_Category__c = t.newCategory__c;
            l.Global_SFDC_Subcategory_1__c = t.newSubcategory__c;
            l.subcategory__c = t.oldSubcategory__c;
            l.category__c = t.oldCategory__c;
          }
        }
      }
    }
  }

  public override void resume(DispatchContext context) {}

}