trigger SubdivisonAssignmentMerchadd on Merchant_Addresses__c (before insert, before update) {
/*
  list <Merchant_Addresses__c> AddyToUpdate = new list <Merchant_Addresses__c>();
  set <string> ZipsInTrigger = new set <string>();
  map <string,id> ZipSubdivMap = new map <string,id>();
  map <string,string> ZipSubdivNames = new map <string,string>();
  set <id> acctSet = new set <id>();
  map<id,Merchant_Addresses__c> oldMerchAddy = new map<id,Merchant_Addresses__c>();  
  if(trigger.isUpdate){  
      for(Merchant_Addresses__c merchAddyOld : trigger.old){                     
              oldMerchAddy.put(merchAddyOld.id, merchAddyOld);              
          }
      }
  
  for (Merchant_Addresses__c Addy :Trigger.new){
  if(oldMerchAddy.isEmpty() == false){
    if(oldMerchAddy.get(Addy.Id).Zip_Postal_Code__c != Addy.Zip_Postal_Code__c){
        if(Addy.Zip_Postal_Code__c <> null) {
          AddyToUpdate.add(Addy);
          acctSet.add(Addy.Account__c);
        }
     }   
    }else if(trigger.isInsert){
        if(Addy.Zip_Postal_Code__c <> null) {
            AddyToUpdate.add(Addy);
            acctSet.add(Addy.Account__c);    
        }
     }
  }
  
  list <account> AcctsInTrigger = [select id, subdivision__c from Account where id in : acctSet];
  
  for (Merchant_Addresses__c a :AddyToUpdate) {
    string zipString = '';
    integer i = a.Zip_Postal_Code__c.length();
      if(a.State_Province__c == 'AB' || a.State_Province__c == 'BC' || a.State_Province__c == 'MB' || a.State_Province__c == 'NB' || a.State_Province__c == 'NL' || a.State_Province__c == 'NT' || a.State_Province__c == 'NS' || a.State_Province__c == 'NU' || a.State_Province__c == 'ON' || a.State_Province__c == 'PC' || a.State_Province__c == 'QC' || a.State_Province__c == 'SK' || a.State_Province__c == 'YT') {
        if(i >= 3) {
          zipString = a.Zip_Postal_Code__c.substring(0,3);
        }
      } else {
        if(i >=5) {
          zipString = a.Zip_Postal_Code__c.substring(0,5);
        }
      }
    ZipsInTrigger.add (zipString);
  }
  
  list <account> AcctsToUpdate = new list <account>();
  for (zip_code__c z :[Select id, name, subdivision__c, subdivision__r.name From zip_code__c Where name in :ZipsInTrigger]) {
    ZipSubdivMap.put(z.name,z.subdivision__c);
    ZipSubdivNames.put(z.name,z.subdivision__r.name);
  }
  
  for (Merchant_Addresses__c Add :AddyToUpdate) {
    string zipString = '';
    integer i = Add.Zip_Postal_Code__c.length();
      if(Add.State_Province__c == 'AB' || Add.State_Province__c == 'BC' || Add.State_Province__c == 'MB' || Add.State_Province__c == 'NB' || Add.State_Province__c == 'NL' || Add.State_Province__c == 'NT' || Add.State_Province__c == 'NS' || Add.State_Province__c == 'NU' || Add.State_Province__c == 'ON' || Add.State_Province__c == 'PC' || Add.State_Province__c == 'QC' || Add.State_Province__c == 'SK' || Add.State_Province__c == 'YT') {
        if(i >= 3) {
          zipString = Add.Zip_Postal_Code__c.substring(0,3);
        }
      } else {
        if(i >= 5) {
          zipString = Add.Zip_Postal_Code__c.substring(0,5);
        }
      }
    Add.Subdivision__c = ZipSubdivMap.get(zipString);
    
    for (account a : AcctsInTrigger)
        {
            list<string> subdivList = new list<string>();
            if(a.id == Add.Account__c)
                {
                    if(a.subdivision__c != null){
                        subdivList = a.subdivision__c.split(';',0);
                    }
                    system.debug('Subdivision List Size: ' + subdivList.size());
                    system.debug('----------This is the subdivision---------- ' + a.subdivision__c);
                    if(a.subdivision__c != null && (subdivList.size() > 99 || (ZipSubdivNames.get(zipString) != null && a.subdivision__c.contains(ZipSubdivNames.get(zipString)))))
                        {
                        }
                    else if(a.subdivision__c != null && ZipSubdivNames.get(zipString) != null)
                        {
                            a.subdivision__c = a.subdivision__c + '; ' + ZipSubdivNames.get(zipString);
                        }
                    else if(a.subdivision__c == null && ZipSubdivNames.get(zipString) != null)
                        {
                            a.subdivision__c = ZipSubdivNames.get(zipString);
                        }
                    AcctsToUpdate.add(a);
                }
        }
  }
  update AcctsToUpdate;*/
}