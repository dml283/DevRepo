public virtual class LeadDynamicZipcode extends DispatchClient implements DispatchContextFilter {

  private DispatchContext context;

  public override void execute(DispatchContext context) {

    this.context = context;

    List<Lead> newLeads = (List<Lead>) context.changedList(this);
    if (newLeads.size() == 0) {
      return;
    }

    List<Zip_Code__c> zipCodes = findZipCodes(extractZips(newLeads));

    Map<String, Zip_Code__c> zipToZipCodes = new Map <String, Zip_Code__c>();  
    for (Zip_Code__c zipCode : zipCodes) {
      zipToZipCodes.put(zipCode.name, zipCode);
    }  

    for (Lead lead: newLeads) {
      String zip = extractZip(lead);
      if (zip != null) {
        Zip_Code__c zipCode = zipToZipCodes.get(zip.toUpperCase());
        if (zipCode == null) {
          lead.Now_Zip_Code__c = null;
          lead.Dynamic_Division__c = null;
          lead.Subdivision_Dynamic__c = null;
        } else {
          lead.Now_Zip_Code__c = zipCode.Id;
          lead.Dynamic_Division__c = zipCode.Division__c;
          lead.Subdivision_Dynamic__c = zipCode.Subdivision__c;
          if (lead.Division__c == null) {
            lead.Division__c = zipCode.Division__r.Name;
          }
        }
      }
    }
  }

  public override void resume(DispatchContext context) {
  }

  private List<String> extractZips(List<Lead> newLeads) {
    List<String> zips = new List<String>();
    for (Lead lead: newLeads) {
      zips.add(extractZip(lead));
    }
    return zips;
  }

  private String extractZip(Lead lead) {
    String zip = lead.PostalCode;
    if (zip != null) {
      zip = zip.trim();

      if (lead.Country == 'US' && lead.PostalCode.length() >= 5) {
        zip = zip.subString(0,5);
      }

      if (lead.Country == 'CA' && lead.PostalCode.length() >= 3) {
        zip = zip.subString(0,3);
      }
    }
    return zip;
  }

  public Boolean filter(SObject oldObject, SObject newObject) {
    return ((Lead) oldObject).PostalCode != ((Lead) newObject).PostalCode;
  }

  protected virtual List<Zip_Code__c> findZipCodes(List<String> zipsInUpdate) {
    return [select name, id, Division__c, Division__r.Name, Subdivision__c From Zip_Code__c where name IN :zipsInUpdate];
  }
  
}