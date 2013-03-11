trigger SubdivisonAssignment on Address__c (before insert, after insert, before update, after update) {
/*
  Set <String> zipsInTrigger = new Set <String>();
  Set <Id> opportunitySet = new Set <Id>();
  List <Zip_code__c> zipIDsInTrigger = new List <Zip_code__c>();
  List <Address__c> addysInTrigger = new List <Address__c>();
  List <Address__c> addysToUpdate = new List <Address__c>();
  List <Opportunity> oppsToUpdate = new List <Opportunity>();
  Map <String,Id> zipSubdivMap = new Map <String,Id>();
  Map <Id,Address__c> oldMap = new Map <Id,Address__c>();
  Map <Id,Address__c> newMap = new Map <Id,Address__c>();
  Map <String,Id> zipMap = new Map <String,Id>();
  Map <String,String> zipSubdivNames = new Map <String,String>();
    
  for (Address__c Addy :Trigger.new) {
    if(Addy.Zip_Postal_Code__c != null) {
      addysInTrigger.add(Addy);
      opportunitySet.add(Addy.Opportunity__c);
    }
  }

  for (Address__c a :addysInTrigger) {
    String zipString = '';
    Integer i = a.Zip_Postal_Code__c.Length();
      if(a.State__c == 'AB' || a.State__c == 'BC' || a.State__c == 'MB' || a.State__c == 'NB' || a.State__c == 'NL' || a.State__c == 'NT' || a.State__c == 'NS' || a.State__c == 'NU' || a.State__c == 'ON' || a.State__c == 'PC' || a.State__c == 'QC' || a.State__c == 'SK' || a.State__c == 'YT') {
        if(i >= 3) {
          zipString = a.Zip_Postal_Code__c.Substring(0,3);
        }
      } else {
        if(i >=5) {
          zipString = a.Zip_Postal_Code__c.Substring(0,5);
        }
      }
    zipsInTrigger.add(zipString);
  }
        
  zipIDsInTrigger = [SELECT Id, Name, Subdivision__c, Subdivision__r.Name FROM Zip_code__c WHERE Name IN : zipsInTrigger];
        
  for (Zip_code__c z :zipIDsInTrigger) {
    zipSubdivMap.put(z.Name,z.Subdivision__c);
    zipMap.put(z.Name,z.Id);
    zipSubdivNames.put(z.Name,z.Subdivision__r.Name);
  }
  
  //Populate subdivision on the address record
  if(trigger.isBefore) {

    for (Address__c Add :addysInTrigger) {
      String zipString = '';
      Integer i = Add.Zip_Postal_Code__c.Length();
        if(Add.State__c == 'AB' || Add.State__c == 'BC' || Add.State__c == 'MB' || Add.State__c == 'NB' || Add.State__c == 'NL' || Add.State__c == 'NT' || Add.State__c == 'NS' || Add.State__c == 'NU' || Add.State__c == 'ON' || Add.State__c == 'PC' || Add.State__c == 'QC' || Add.State__c == 'SK' || Add.State__c == 'YT') {
          if(i >= 3) {
            zipString = Add.Zip_Postal_Code__c.substring(0,3);
          }
        } else {
          if(i >= 5) {
            zipString = Add.Zip_Postal_Code__c.substring(0,5);
          }
        }
      Add.Subdivision__c = zipSubdivMap.get(zipString);
      Add.Dynamic_zip_code__c = zipMap.get(zipString);
    }
  }

  //Populate Subdivision on the opportunity record
  if(trigger.isAfter) {

    List <Opportunity> oppsInTrigger = [SELECT Id, Subdivision__c FROM Opportunity WHERE Id IN : opportunitySet];

    for(Opportunity o: oppsInTrigger) {
      String newOpportunitySubdivisions = '';
      String totalOpportunitySubdivisions = '';
      List <String> subdivList = new List <String>();

      for(Address__c Add : addysInTrigger) {
        if(Add.Opportunity__c == o.Id) {
          String zipString = '';
          Integer i = Add.Zip_Postal_Code__c.Length();
          if(Add.State__c == 'AB' || Add.State__c == 'BC' || Add.State__c == 'MB' || Add.State__c == 'NB' || Add.State__c == 'NL' || Add.State__c == 'NT' || Add.State__c == 'NS' || Add.State__c == 'NU' || Add.State__c == 'ON' || Add.State__c == 'PC' || Add.State__c == 'QC' || Add.State__c == 'SK' || Add.State__c == 'YT') {
            if(i >= 3) {
              zipString = Add.Zip_Postal_Code__c.substring(0,3);
            }
          } else {
            if(i >= 5) {
              zipString = Add.Zip_Postal_Code__c.substring(0,5);
            }
          }
          if((o.Subdivision__c != null && zipSubdivNames.get(zipString) != null && o.Subdivision__c.contains(zipSubdivNames.get(zipString))) || (zipSubdivNames.get(zipString) != null && newOpportunitySubdivisions.contains(zipSubdivNames.get(zipString)))) {
            //Do Nothing
          } else {
            if(zipSubdivNames.get(zipString) != null) {
              newOpportunitySubdivisions = newOpportunitySubdivisions + ';' + zipSubdivNames.get(zipString);
            }
          }
        }
      }

      if(o.Subdivision__c == null) {
        totalOpportunitySubdivisions = newOpportunitySubdivisions;
      } else {
        totalOpportunitySubdivisions = o.Subdivision__c + ';' + newOpportunitySubdivisions;
      }

      subdivList = totalOpportunitySubdivisions.split(';',0);

      if(subdivList.size() > 99) {
        o.Subdivision__c = 'National Account: Too many subdivisions';
      } else if(o.Subdivision__c == null) {
        o.Subdivision__c = newOpportunitySubdivisions;
      } else {
        o.Subdivision__c = o.Subdivision__c + ';' + newOpportunitySubdivisions;
      }
      oppsToUpdate.add(o);
    }
    Database.SaveResult[] SR = database.update(oppsToUpdate);
  }
  */
}