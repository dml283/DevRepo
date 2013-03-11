public class LeadInsertTaxonomy extends DispatchClient implements DispatchContextFilter {

  public override void execute(DispatchContext context) {

    if(stopInsertSupportTaxonomyRecords.stopFutureCallout == false) {
      list < insertSupportTaxonomyRecords.async_helper > async = new list < insertSupportTaxonomyRecords.async_helper > ();
      list < ID > LeadId = new list < ID > ();
      list < string > ServicesOfferedOld = new list < string > ();
      list < string > ServicesOfferedNew = new list < string > ();
      list < string > Category = new list < string > ();

      for(Lead l: (List<Lead>) context.changedList(this)) {
        LeadId.add(l.id);
        String oldServices = ((Lead) context.oldMap().get(l.id)).Services_Offered__c;
        String newServices = ((Lead) context.newMap().get(l.id)).Services_Offered__c;

        if(oldServices != null) {
          ServicesOfferedOld.add(oldServices);
        }
        if(newServices != null) {
          ServicesOfferedNew.add(newServices);
        }
        Category.add(((Lead) context.newMap().get(l.id)).Category_v3__c);
      }

      async.add(new insertSupportTaxonomyRecords.async_helper(LeadId, ServicesOfferedOld, ServicesOfferedNew, Category));
      insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));

      stopInsertSupportTaxonomyRecords.stopFutureCallout = true;
    }

  }

  public override void resume(DispatchContext context) {
  }

  public Boolean filter(SObject oldObject, SObject newObject) {
    return ((Lead) oldObject).Services_Offered__c != ((Lead) newObject).Services_Offered__c;
  }


}