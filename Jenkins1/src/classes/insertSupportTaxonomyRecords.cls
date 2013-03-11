public class insertSupportTaxonomyRecords {
  public class async_helper {
    public List < id > recordId {
      get;
      set;
    }
    public List < string > OldServices {
      get;
      set;
    }
    public List < string > NewServices {
      get;
      set;
    }
    public List < string > Category {
      get;
      set;
    }
    public async_helper(List < id > i, List < string > oldS, list < string > newS, List < string > cat) {
      this.recordId = i;
      this.OldServices = oldS;
      this.NewServices = newS;
      this.Category = cat;
    }
  }

  public static void insertSupportTaxonomy(string JSONstring) {
    string stringId = '';
    string async_cat = '';
    string[] oldS = new string[] {};
    string[] newS = new string[] {};
    list < string > oldServices = new list < string > ();
    list < string > newServices = new list < string > ();
    list < taxonomy_Support__c > supportRecords = new list < taxonomy_Support__c > ();
    list < Selected_Taxonomy__c > selectedLeadRecords = new list < Selected_Taxonomy__c > ();
    list < Selected_Taxonomy__c > selectedAcctRecords = new list < Selected_Taxonomy__c > ();
    list < Selected_Taxonomy__c > taxonomySupportRecordsInsert = new list < Selected_Taxonomy__c > ();

    List < id > idSet = new List < id > ();
    map < string, id > categoryMap = new map < string, id > ();
    list < async_helper > async = (list < async_helper > ) JSON.Deserialize(JSONstring, list < async_helper > .class);
    for(async_helper a: async) {
      idSet = a.recordID;
      for(Id recID: a.recordID) {
        stringId = recID;
      }
      for(string str: a.category) {
        async_cat = str;
      }
      for(Id recId: a.recordID) {
        categoryMap.put(async_cat, recId);
      }

      if(a.OldServices != null) {
        for(string oldStr: a.OldServices) {
          oldS = oldStr.split('\\|');
        }
        for(string s: oldS) {
          oldServices.add(s.trim());
        }
      }
      if(a.NewServices != null) {
        for(string newStr: a.NewServices) {
          newS = newStr.split('\\|');
        }
        for(string s: newS) {
          newServices.add(s.trim());
        }
      }
    }

    selectedLeadRecords = [SELECT id, lead__c, account__c, taxonomy_support__r.name__c FROM Selected_Taxonomy__c where taxonomy_support__r.name__c IN: oldServices AND(lead__c IN: idSet or account__c IN: idSet)];
    database.delete(selectedLeadRecords);

    supportRecords = [SELECT id, name__c, category__c FROM taxonomy_Support__c WHERE name__c IN: newServices and category__c = : categoryMap.keySet()];
    for(async_helper a: async) {
      string iD = stringId;
      for(integer i = 0; i < supportRecords.size(); i++) {
        stringId = iD;
        selected_taxonomy__c stRecords = new selected_taxonomy__c();
        if(stringId.substring(0, 3) == '00Q') {
          stRecords.lead__c = iD;
        }
        if(stringId.substring(0, 3) == '001') {
          stRecords.account__c = iD;
        }
        stRecords.Taxonomy_Support__c = supportRecords[i].id;
        taxonomySupportRecordsInsert.add(stRecords);

      }
    }
    database.insert(taxonomySupportRecordsInsert);

  }


}