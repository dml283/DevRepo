public class PurchaseOrder {

public id RecordId {get;set;}
public Purchase_order__c po {get;set;}
public string purchase_order {get;set;}
public id current_user {get;set;}
public string target_date {get;set;}

public PurchaseOrder(){
        this.recordID = ApexPages.currentPage().getParameters().get('Id');
        po = new Purchase_order__c();
        if(this.recordID!=null){
        po = [Select Subdivision__r.name, division__r.name, Owner.name, xSubDivision__c, Zip_Code__c, Type__c, Time_to_Schedule_PO__c, Target_Revenue__c, Target_GP__c, Target_Feature_Date__c,
        SystemModstamp, Subdivision__c, Subcategory__c, Source__c, Rep_PO_Notes__c, Purchase_Order_Fill_Time__c, PO_Submitted_Date__c, PO_Status__c, PO_Notes__c, PO_Approved_Date__c, OwnerId,     
        Oppty_Merchant_Value__c, Opportunity__c, Opportunity_Sell_Price__c, Opportunity_Projected_Revenue__c, Opportunity_Division__c, Opportunity_Deal_Strength__c, Opportunity_Deal_Score__c, 
        Opportunity_Close_Date__c, Opportunity_Category__c, Now_Target_Locations__c, Now_Deal__c, Now_Deal_Strength__c, Now_Deal_Close_Date__c, Neighborhood__c, Name, Merchant_Value_Prop__c,  
        Location__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Ideal_Zip_Code__c, Ideal_Price_Range__c, Ideal_Day_of_the_Week__c, Id, Global_SFDC_Subcategory_2__c,  
        Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, Example_Deal_2__c, Example_Deal_1__c, Division__c, Desired_GP__c, Deal_Zip_Code__c, Deal_Subcategory__c, Deal_Sell_Price__c,     
        Deal_Retail_Value__c, Deal_Merchant_Value__c, Deal_Division__c, Deal_Category__c, Deal_Buy_Price__c, Deal_Builder_Template__c, Days_to_Expiration__c, CreatedDate, CreatedById, 
        ConnectionSentId, Category_v3__c, Subcategory_v3__c, ConnectionReceivedId, Category__c, Auto_Expire_dnu__c, Assigned_To_multi__c, Assigned_To__c, Assigned_To_Logged_In_User__c, Approval_Time__c From Purchase_Order__c     
        where id = :this.recordID];
        Purchase_order = JSON.serialize(po);
        current_user = UserInfo.getUserId();
        if(po.Target_Feature_date__c!=null)target_date = po.Target_Feature_date__c.format();
        }
    }
@RemoteAction
public static list<event_data> merchant_activity(string id){
    list<event_data> tasks = new list<event_data>();
    list<task> merchant_tasks = [select id, subject, Owner.Name, ActivityDate FROM task WHERE (WhatID = :id OR WhoID = :id) ORDER BY ActivityDate DESC LIMIT 10];
    for(task t : merchant_tasks)
        tasks.add(new event_data(t));
    return tasks;   
}    
@RemoteAction
public static List<ProcessInstanceWorkitem> poApprovalStatus(string POId){
        List<ProcessInstanceWorkitem> workitem = new List<ProcessInstanceWorkitem>();
        workitem = [select Id, ProcessInstance.TargetObjectId, ProcessInstance.status from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = : POId];
    return workitem;
  }
    
@RemoteAction
public static list<option> getClosedDeals(string ownerid){
        list<opportunity> olist = [select name , id from Opportunity where ownerid = :ownerid AND stageName ='Closed Won' AND Total_GP__c = 0 ORDER by CloseDate DESC];
        list<option> options = new list<option>();
        for(opportunity o : olist){
                options.add(new option(o));
            }
        return options;    
    }    
@RemoteAction
public static void deletePinned(string POid, string recordId){
    PinnedMerchant__c p = [select id, account__c, Purchase_Order__c from PinnedMerchant__c WHERE Purchase_order__c =:POiD AND (account__c=:recordId OR lead__c=:recordID) limit 1];
            try{
                delete p;
            }catch(exception e){system.debug('=========OH NO.....there was an error and it was: '+e);}
}
@RemoteAction
public static void addPinned(string POid, string recordId, string pm_type){
    PinnedMerchant__c p;
    
    if(pm_type=='Lead')
        p = new PinnedMerchant__c(Purchase_order__c=poId, lead__c = recordId);
    if(pm_type=='Account')
        p = new PinnedMerchant__c(Purchase_order__c=poId, account__c = recordId);    
            try{
                insert p;
            }catch(exception e){system.debug('=========OH NO.....there was an error and it was: '+e);}
}      
@RemoteAction
public static list<result> getPinned(string JSONstring){
    list<result> pinned_merchants= new list<result>();
    search_options options = new search_options();
    set<id> ids = new set<id>();

    list<PinnedMerchant__c> pms = new list<pinnedMerchant__c>();
    pms = [select id, Account__c, Lead__c from PinnedMerchant__c WHERE Purchase_Order__c = :JSONstring];
    for(PinnedMerchant__c p :pms){
            ids.add(p.Account__c);
            ids.add(p.Lead__c);
        }
        
    list<account> accounts = database.query(options.get_account_SOQL_pinned(ids));
    list<lead> leads = database.query(options.get_lead_SOQL_pinned(ids));
    
    for(lead l :leads)
       pinned_merchants.add(new result(l));
    for(account a :accounts)
       pinned_merchants.add(new result(a));
           
    return pinned_merchants;    
}

@RemoteAction
public static list<result> getSearch_Results(string JSONstring){
    list<result> results = new list<result>();
    search_options options =(search_options)JSON.deserialize(JSONString, search_options.class);

     for(account a : database.query(options.get_account_SOQL()))
        results.add(new result(a));
    for(lead l : database.query(options.get_lead_SOQL()))
        results.add(new result(l));    
    return results;
}
@RemoteAction
public static list<option> getDivisions(){
    list<option> options = new list<option>();
    list<division__c> dlist = [select id, name from Division__c order by name ASC];
    options.add(new option());
    for(division__c d: dlist){
          options.add(new option(d));
      }
return options;
}
@RemoteAction
public static void removeDeal(string poid){
    Purchase_order__c PO = new Purchase_Order__c(id=poid);
    po.opportunity__c =null;
    update po;
    ProcessInstanceWorkitem PR = [Select p.Id, p.ProcessInstanceId, p.ProcessInstance.TargetObjectId,p.ProcessInstance.status from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: poId limit 1];
    Approval.ProcessWorkitemRequest ap_request = new Approval.ProcessWorkitemRequest();
    ap_request.setWorkitemId (PR.Id);
//Make sure to have it as 'removed' though doc says as 'remove' else you will hit this exception : System.DmlException: Process failed. First exception on row 0; first error: INVALID_OPERATION, Illegal transition type: []
    ap_request.setAction('Removed');
    Approval.ProcessResult prq = Approval.process(ap_request); 
}
@RemoteAction
public static void submitPO(string poid, string oppid){
        Purchase_order__c PO = new Purchase_Order__c(id=poid);
        po.opportunity__c = oppid;
        update po;
        Approval.ProcessSubmitRequest req1 =  new Approval.ProcessSubmitRequest();
        req1.setObjectId(poid);
        Approval.ProcessResult result = Approval.process(req1);
    }
@RemoteAction
public static list<option> getSubdivision(string division){
    list<option> options = new list<option>();
    list<Subdivision__c> subdivisions = [select id, name FROM Subdivision__c WHERE division__r.name = :division];
    options.add(new option());
    for(Subdivision__c s :subdivisions)
        options.add(new option(s.name));
    return options;
}    
@RemoteAction
public static list<option> getCategory(){
    list<option> options = new list<option>();
    set<string> dupes = new set<string>();
    list<taxonomy_support__c> taxList = [select category__c from taxonomy_support__c WHERE type__c = 'taxonomy'];
    options.add(new option());
    for(taxonomy_support__c t: taxList){
    if(!dupes.contains(t.category__c)){
            options.add(new option(t.category__c));
            dupes.add(t.category__c);
          }
    }
return options;
}
@RemoteAction
public static list<option> getSubcategory(string category){
    list<option> options = new list<option>();
    list<taxonomy_support__c> taxList = [select subcategory__c from taxonomy_support__c WHERE type__c = 'taxonomy' AND category__c = :category];
    options.add(new option());
    for(taxonomy_support__c t: taxList){
        options.add(new option(t.subcategory__c));
    }
return options;
}
@RemoteAction
public static list<option> getUsers(){
        list<user> users = [select id, Name from user WHERE isactive = true ORDER BY name ASC];
        list<option> options = new list<option>();
        for(user u :users)
            options.add(new option(u));
     return options;       
    }
    
@RemoteAction
public static void switchOwner(string objid, string ownerid, string type){
    if(type=='Account'){
            Account A = New Account(id=objid);
            a.ownerid = ownerid;
            update a;
        }else{
                Lead L = new Lead(id=objid);
                l.ownerid = ownerid;
                update l;
            }
}    
public class Result
        {
            public id RecordID{get;set;}
            public string RType{get;set;}
            public string Merchant{get;set;}
            public string ContactName{get;set;}
            public string cat{get;set;}
            public string subcat{get;set;}
            public string subcat2{get;set;}
                public string subdiv{get;set;}
            public string NewOld{get;set;}
            public string Phone{get;set;}
            public string ResearchRanking{get;set;}
            public string Owner{get;set;}
            public string FeatureDate{get;set;}
            public string Stage{get;set;}
            public string LastActivity{get;set;}
            public id POID{get;set;}
            public string website{get;set;}
            public string checked {get;set;}
            public string services{get;set;}
            public string ownerid {get;set;}
            
            public result(Account A){
                    this.rtype='Account';
                    this.ownerid = a.ownerid;
                    this.NewOld='Existing Business';
                    this.services = a.Services_Offered__c;
                    this.cat=a.Category_v3__c;
                    this.RecordID =a.id;
                    this.Merchant=a.Name;
                    this.subdiv = string.valueOf(a.subdivision__c);
                    this.subcat=a.Subcategory_v3__c;
                    this.subcat2=a.Global_SFDC_Subcategory_2__c;
                    this.ResearchRanking=a.Research_Ranking__c;
                    this.owner=a.Owner.Name;
                    this.POID=POid;
                    this.stage=a.Account_Status__c;
                    this.website=a.website;
                    if(a.Acct_Status_Change_Date__c!=null)this.lastActivity=a.Acct_Status_Change_Date__c.format();
                    if(a.Most_Recent_Feature__c!=null)this.FeatureDate = a.Most_Recent_Feature__c.format();
                    if(a.pinned__c==true){this.checked='Yes';}else{this.checked='No';}
                }
            public result(lead l){
                this.services =l.Services_Offered__c;
                this.ownerid = l.ownerid;
                this.rtype='Lead';
                this.NewOld='New Business';
                this.ContactName=l.Name;
                //this.subdiv = l.Subdivision__c;
                this.subdiv = l.Subdivision_Dynamic__r.name;
                this.cat=l.Category_v3__c;
                this.RecordID = l.id;
                this.Merchant=l.Company;
                this.subcat=l.Subcategory_v3__c;
                this.subcat2=l.Global_SFDC_Subcategory_2__c;
                this.Phone=l.Phone;
                this.ResearchRanking=l.Research_Ranking__c;
                this.owner=l.owner.name;
                this.stage=l.Status;
                if(l.LastActivityDate!=null)this.LastActivity=l.LastActivityDate.format();
                this.POID=POid;
                this.Website=l.Website;
                if(l.pinned__c==true){this.checked='Yes';}else{this.checked='No';}
            }
            public result(){}
        }
public class search_options{
    string name {get;set;}
    string division {get;set;}
    string category{get;set;}
    string subcategory{get;set;}
    string services {get;set;}
    string id {get;set;}
    string subdivision {get;set;}

    public string get_taxonomy_SOQL(string category){
        string s = 'select id, Category_v3__c, name__c from taxonomy_support__c WHERE name__c != null AND type__c = \'Merchant Service\' AND category__c = \''+category+'\' order by name__c ASC';
        return s;
    }
    public string get_account_SOQL_pinned(set<id>ids){
        string s = 'select id, Subdivision__c, Most_Recent_Feature__c, Category_v3__c, Subcategory_v3__c, ownerid, Services_Offered__c,Name,Global_SFDC_Category__c,global_SFDC_Subcategory_1__c,global_SFDC_Subcategory_2__c,Research_Ranking__c,Owner.Name,Account_Status__c,website,Acct_Status_Change_Date__c, Pinned__c FROM Account WHERE ID in :ids ';
        if(this.name!=null){
            s+= 'AND name like \'%'+string.escapeSingleQuotes(this.name)+'%\' ';
            }
        if(this.category!=null)
            s+= 'AND Category_v3__c = \''+this.category+'\' ';
        if(this.subcategory!=null)
            s+= 'AND Subcategory_v3__c = \''+this.subcategory+'\' ';  
        s+=' ORDER BY Research_Ranking_num__c DESC';                
        return s;
    }
    public string get_lead_SOQL_pinned(set<id>ids){
        string s = 'select id, Subdivision__c,  Subdivision_Dynamic__c, Subcategory_v3__c,  Category_v3__c,  ownerid,Services_Offered__c, Name, Global_SFDC_Category__c, Subdivision_Dynamic__r.name, Company, global_SFDC_Subcategory_1__c, global_SFDC_Subcategory_2__c, Phone, Research_Ranking__c, owner.name, Status, LastActivityDate, Website, pinned__c FROM LEAD WHERE ID in :ids ';
        if(this.name!=null){
            s+= 'AND name like \'%'+string.escapeSingleQuotes(this.name)+'%\' ';
            }
        if(this.category!=null)
            s+= 'AND Category_v3__c = \''+this.category+'\' ';  
        if(this.subcategory!=null)
            s+= 'AND Subcategory_v3__c = \''+this.subcategory+'\' '; 
        s+=' ORDER BY Research_Ranking_num__c DESC';         
        return s;
    }
    public string get_account_SOQL(){
        string s = 'select id, ownerid, Subcategory_v3__c, Most_Recent_Feature__c,  Research_Ranking_num__c, Category_v3__c, division__r.name, Subdivision__c, Services_Offered__c, Name,Global_SFDC_Category__c,global_SFDC_Subcategory_1__c,global_SFDC_Subcategory_2__c,Research_Ranking__c,Owner.Name,Account_Status__c,website,Acct_Status_Change_Date__c, Pinned__c FROM Account WHERE ownerID !=null ';
        if(this.name!=null){
            s+= 'AND name like \'%'+string.escapeSingleQuotes(this.name)+'%\' ';
            }
        if(this.division!=null)
            s+= 'AND division__r.name = \''+string.escapeSingleQuotes(this.division)+'\' ';
        if(this.subdivision!=null)
            s+= 'AND Subdivision__c includes (\''+this.subdivision+'\') ';   
        if(this.category!=null)
            s+= 'AND Category_v3__c = \''+this.category+'\' ';
        if(this.subcategory!=null)
            s+= 'AND Subcategory_v3__c = \''+this.subcategory+'\' ';
        s+=' ORDER BY Research_Ranking_num__c DESC';  
        //if(this.max!=null)
            //s+= 'AND Research_Ranking_num__c >= '+this.min+' AND Research_Ranking_num__c <= '+this.max;
        //if(this.services!=null)
            //s+= 'AND Services_Offered__c like \'%'+this.services+'%\' ';            
        return s;
    }
    public string get_lead_SOQL(){
        string s = 'select id, Research_Ranking_num__c, Category_v3__c, Subcategory_v3__c, ownerid, division__c, Subdivision__c, Services_Offered__c, Name, Global_SFDC_Category__c, Subdivision_Dynamic__r.name, Company, global_SFDC_Subcategory_1__c, global_SFDC_Subcategory_2__c, Phone, Research_Ranking__c, owner.name, Status, LastActivityDate, Website, pinned__c FROM LEAD WHERE isconverted = false ';
        if(this.name!=null){
            s+= 'AND Company like \'%'+string.escapeSingleQuotes(this.name)+'%\' ';
            }
        if(this.category!=null)
            s+= 'AND Category_v3__c = \''+this.category+'\' ';
        if(this.division!=null)
            s+= 'AND Dynamic_Division__r.name = \''+string.escapeSingleQuotes(this.division)+'\' ';            
        if(this.subdivision!=null)
            s+= 'AND Subdivision_Dynamic__r.name like \'%'+string.escapeSingleQuotes(this.subdivision)+'%\' ';     
        if(this.subcategory!=null)
            s+= 'AND Subcategory_v3__c = \''+this.subcategory+'\' ';
        s+=' ORDER BY Research_Ranking_num__c DESC';    
        //if(this.max!=null)
            //s+= 'AND Research_Ranking_num__c >= '+this.min+' AND Research_Ranking_num__c <= '+this.max;    
        //if(this.services!=null)
           // s+= 'AND Services_Offered__c like \'%'+this.services+'%\' ';
        return s;
    }
}
public class option{
    public string value{get;set;}
    public string name{get;set;}
    public option(user u){this.value = u.id;this.name = u.Name;}
    public option(opportunity o){this.value = o.id;this.name = o.name;}
    public option(){this.value ='';this.name='';}
    public option(division__c d){this.value = d.name;this.name = d.name;}
    public option(string s){this.value = s;this.name = s;}
    public option(taxonomy_support__c t){this.value = t.name__c;this.name = t.name__c;}
}
public class event_data{
    public string ActivityDate {get;set;}
    public string Subject {get;set;}
    public string Name {get;set;}
    public event_data(task t){
            this.ActivityDate = t.ActivityDate.format();
            this.Subject = t.Subject;
            this.Name = t.Owner.Name;
        }
}
static testMethod void testPurchaseOrderSystem(){
        PurchaseOrder PO = new PurchaseOrder();
        
        //test data
        Purchase_order__c p = new Purchase_order__c();
        insert p;
        lead l = new lead(lastName='My Last Name', company='my Company');
        insert l;
        Account A = new Account(Name='Account Name');
        insert A;
        Opportunity O = new Opportunity(accountid=a.id, Name='My Opp', CloseDate =system.today(), StageName='Prospecting', Category__c='Food and Drink');
        insert o;
        Division__c Div = new Division__c(name='Chicago', State__c ='IL');
        insert div;
        Subdivision__c subdiv = new Subdivision__c(name='South Chicago', division__c = div.id);
        
        Search_Options options = new PurchaseOrder.Search_Options();
            options.category = 'Food and Drink';
            options.division = 'Chicago';
        set<id> testIds = new set<id>();
            testIds.add(a.id);
            testIds.add(o.id);
            testIds.add(l.id);
        
        //test adding pinned
        PurchaseOrder.addPinned(p.id, l.id, 'Lead');
        PurchaseOrder.addPinned(p.id, a.id, 'Account');
        //test getting approval status
        List<ProcessInstanceWorkitem> poApprovalStatus= PurchaseOrder.poApprovalStatus('');
        //test get merchant activity history
        list<event_data> merchant_activity = PurchaseOrder.merchant_activity('');
        //test to get closed deals
        list<option> ClosedDeals = PurchaseOrder.getClosedDeals('');
        //test to get the pinned merchants
        list<result> Pinned = PurchaseOrder.getPinned(p.id);
        //test search
        //list<result> getSearch_Results(string JSONstring);
        //test deleting a pinned merchant
        //test getting the divisions
        list<option> Divisions = PurchaseOrder.getDivisions();
        //test getting the subdivisions
        list<option> subdivisions = PurchaseOrder.getSubdivision('Chicago');
        //test submitting a deal
        PurchaseOrder.submitPO(p.id,o.id);
        //test removing a deal from an approval processs
        PurchaseOrder.removeDeal(p.id);
        //test deleting the pinned merchant
        PurchaseOrder.deletePinned(p.id, l.id);
        //test getting the users
        list<option> Users = PurchaseOrder.getUsers();

        string acct_soql = options.get_account_SOQL_pinned(testIds);
        acct_soql = options.get_account_SOQL();
        string lead_soql = options.get_lead_SOQL();
        
    }        
}