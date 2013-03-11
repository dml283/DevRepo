public class pinned_merchants {
public id record_id {get;set;}
List<string> reasonslist = new List<string>();
List<string> reasonslist2 = new List<String>();
List<string> reasonslist_acc = new List<string>();
List<string> reasonslist_acc2 = new List<String>();
public list<merchant> merchants {get;set;}
    public pinned_merchants(ApexPages.StandardController page) {
        set<id> ids = new set<id>();
        for(pinnedMerchant__c pm : [select id, opportunity__r.accountid, account__c, lead__c from PinnedMerchant__c where purchase_order__c = :ApexPages.currentPage().getParameters().get('id') ]){
            ids.add(pm.opportunity__r.accountid);
            ids.add(pm.account__c);
            ids.add(pm.lead__c);
        }
    merchants = getMerchantsFromId(ids);
    record_id = ApexPages.currentPage().getParameters().get('id');
    }
public integer getNumPinned(){
    return merchants.size();
}
public decimal getAverageRanking(){
    decimal d=0;
    integer count = 0;
    for(merchant m : merchants){
        if(m.research_ranking!=null && m.research_ranking!=null){
            d+=decimal.valueOf(m.research_ranking);
            count++;
        }
    }
    if(d!=0)d=d/count;
    d=d.setScale(1);
    return d;
}
public list<owners> getOwners(){
    list<owners> owners = new list<owners>();
    set<string> already_added = new set<string>();
    for(merchant m : merchants){
        if(!already_added.contains(m.owner)){
        string name = m.owner;
        already_added.add(m.owner);
        integer counter = 0;
        decimal avg = 0;
            for(merchant ma : merchants){
                    if(ma.owner == name){
                        counter++;
                        if(ma.research_ranking!=null)avg+=decimal.valueOf(ma.research_ranking);
                    }
                }
        owners o = new owners();
        o.name= m.owner;
        o.count = counter;
        o.avg = avg/counter;
        o.avg = o.avg.setScale(1);
        owners.add(o);
        }}
    return owners;    
}
public list<merchant> getMerchantsFromId(set<id> ids){
    merchants = new list<merchant>();

  //LEAD CUSTOM SETTING
    object reasons = pinned_merchants_Lead_setting__c.getInstance('Status_Reason').get('Lead_Status_reasons__c');
    object reasons1 = pinned_merchants_Lead_setting__c.getInstance('Status_Reason1').get('Lead_Status_reasons__c');
    system.debug('reasons'+reasons);
    system.debug('reasons1'+reasons1);
    string strings  = (string)reasons;
    string strings1 = (string)reasons1;
    string[] newstringar = strings.split(',');
    string[] newstringar1 = strings1.split(',');
    reasonslist = (newstringar);
    reasonslist2 = (newstringar1);
  //ACCOUNT CUSTOM SETTING
    object reasons_acc = pinned_merchants_Account_setting__c.getInstance('Status_Reason').get('Account_Status_reasons__c');
    object reasons_acc1 = pinned_merchants_Account_setting__c.getInstance('Status_Reason1').get('Account_Status_reasons__c');
    system.debug('reasons_acc'+reasons_acc);
    system.debug('reasons_acc1'+reasons_acc1);
    string strings_acc  = (string)reasons_acc;
    string strings_acc1 = (string)reasons_acc1;
    string[] newstringar_acc = strings_acc.split(',');
    string[] newstringar_acc1 = strings_acc1.split(',');
    reasonslist_acc = (newstringar_acc);
    reasonslist_acc2 = (newstringar_acc1);
    

   
        system.debug('Leads size here is '+ database.query(getLeadSOQL()));
    for(lead l : database.query(getLeadSOQL())){

            merchants.add(new merchant(l));
        }
    
    for(account a : database.query(getAccountSOQL())){
            merchants.add(new merchant(a));
        }    
    return merchants;
}

public string getLeadSOQL(){
   system.debug('VAL HERE IS '+ reasonslist  + reasonslist2);
    string s = 'select id, company, website, owner.name, research_ranking__c, Category_v3__c, Subcategory_v3__c, Subdivision_Dynamic__r.name, Services_Offered__c,Merchant_Attributes__c, status, LastActivityDate from lead where id in :ids and Merchant_Status_Reasons__c NOT IN: reasonslist and  Merchant_Status_Reasons__c NOT IN: reasonslist2';
    return s;
}
public string getAccountSOQL(){
    string s ='select id, owner.name, website, Name, LastActivityDate, Subdivision__c, Re_Feature_Status_Rep__c, Number_of_Features__c, Research_Ranking__c, ReClose_Aging__c, Merchant_Value__c, Category_v3__c, Subcategory_v3__c, Services_Offered__c,Merchant_Attributes__c, Most_Recent_Feature__c from Account where id in :ids and Account_Status__c NOT IN: reasonslist_acc and  Account_Status__c NOT IN: reasonslist_acc2';
    return s;
}
public class owners{
    public string name {get;set;}
    public integer count {get;set;}
    public decimal avg {get;set;}
}
public class merchant{
        public string type {get;set;}
        public string name {get;set;}
        public string owner {get;set;}
        public string research_ranking {get;set;}
        public string category{get;set;}
        public string subcategory {get;set;}
        public string services {get;set;}
        public string attributes {get;set;}
        public string subdivision {get;set;}
        public string stage {get;set;}
        public string last_activity {get;set;}
        public string website {get;set;}
        public id record_id {get;set;}
        public string feature_date {get;set;}
        
        public merchant(account a){
            this.name = a.Name;
            this.record_id = a.id;
            this.owner = a.owner.name;
            this.research_ranking = a.research_ranking__c;
            if(a.Number_of_Features__c>0)this.type='Exisiting';else{this.type='New';}
            this.website = a.website;
            this.category = a.Category_v3__c;
            this.subcategory = a.Subcategory_v3__c;
            this.attributes = a.Merchant_Attributes__c;
            this.services = a.services_offered__c;
            this.subdivision = a.Subdivision__c;
            this.stage = a.Re_Feature_Status_Rep__c;
            if(a.LastActivityDate!=null)this.last_activity = a.LastActivityDate.format();
            if(a.Most_Recent_Feature__c!=null)this.Feature_Date = a.Most_Recent_Feature__c.format();
        }
        
        public merchant (lead l){
            this.type = 'New';
            this.name = l.company;
            this.website = l.website;
            this.record_id = l.id;
            this.owner = l.owner.name;
            this.research_ranking = l.research_ranking__c;
            this.category = l.Category_v3__c;
            this.subcategory = l.Subcategory_v3__c;
            this.subdivision = l.Subdivision_Dynamic__r.name;
            this.attributes = l.Merchant_Attributes__c;
            this.services = l.services_offered__c;
            this.stage = l.status;
            if(l.LastActivityDate!=null)this.last_activity = l.LastActivityDate.format();
        }
    }

static testmethod void testPinnedMerchant(){
    Purchase_order__c po = new Purchase_order__c();
    insert po;
    
    lead l = new lead();
    l.company = 'my name';
    l.lastName= 'my new last name';
    insert l;
    
    pinnedMerchant__c pm = new pinnedMerchant__c();
    pm.purchase_order__c = po.id;
    pm.lead__c = l.id;
    insert pm;
    
     pinned_merchants_Lead_setting__c inst = new pinned_merchants_Lead_setting__c();
    inst.Lead_Status_reasons__c = 'test';
     inst.Name = 'Status_Reason';
    Insert inst;
    pinned_merchants_Lead_setting__c inst1 = new pinned_merchants_Lead_setting__c();
    inst1.Lead_Status_reasons__c = 'test1';
     inst1.Name = 'Status_Reason1';
    Insert inst1;
    
    pinned_merchants_Account_setting__c inst2 = new pinned_merchants_account_setting__c();
    inst2.Account_Status_reasons__c = 'test';
     inst2.Name = 'Status_Reason';
    Insert inst2;
    pinned_merchants_Account_setting__c inst3 = new pinned_merchants_account_setting__c();
    inst3.Account_Status_reasons__c = 'test1';
     inst3.Name = 'Status_Reason1';
    Insert inst3;
    
    PageReference pageRef = Page.PinnedMerchants;
    pageref.getParameters().put('id', po.id); 
    Test.setCurrentPageReference(pageRef);
    
    ApexPages.StandardController sc = new ApexPages.standardController(po);
    // create an instance of the controller
    pinned_merchants con = new pinned_merchants(sc);
    
    list<owners> owners = con.getOwners();
    decimal avg = con.getAverageRanking();
    integer numPinned = con.getNumPinned();
   
}    
}