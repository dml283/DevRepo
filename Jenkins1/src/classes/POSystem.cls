global class POSystem {
    public Purchase_Order__c po {get; set;}
    public POSystem(ApexPages.StandardController controller) {po = (Purchase_Order__c)controller.getRecord();}  
    public ID POId = ApexPages.currentPage().getParameters().get('id'); 
    public String LeadSOQL{get;set;}
    public String AcctSOQL{get;set;}
    public map <id,string> contactPhone = new map<id,string>();
    public map <id,string> contactName = new map<id,string>();
    public id acctId;
    public id recordID{get;set;}
    public boolean runYet = false;
    
    public string MerchantName{get;set;}
    public string category{get;set;}
    public string division{get;set;} 
    public string subcategory1{get;set;} 
    public string subcategory2{get;set;}
    public string numResults{get;set;}
    //public set<id> PinnedIDs{get;set;}
   public list<result> getResults()
        {
            init();
            list<result> ResultList = new list<result>();
            
            //create the SOQL strings
            string leadQuery = getLeadSOQL();
            //string AcctQuery = getAcctSOQL();===========
            
            string QueryType='';
            
            Settings POParams = new Settings();
            POParams = BuildSettings();
            
            //Get the Pinned Leads and Exclude them
            set<id>PinnedIDs=excludePinned();
            
            //Add the Where Condition to the Queryies
            leadQuery = addWhere(leadQuery);
            
            //AcctQuery = addWhere(AcctQuery);
            
            //add the PO Conditions, ie does it match cat, subcat, div
            QueryType='Lead';
            leadQuery = addPOConditions(leadQuery, POParams,QueryType);
            QueryType='Account';
            //AcctQuery = addPOConditions(AcctQuery, POParams,QueryType);===========
            
            //Exclude leads that have already been pinned
            leadQuery = excludePinned(leadQuery);
            //AcctQuery = excludePinned(AcctQuery);===========
            
            //Add the Limit to the Queries
            leadQuery = addLimit(leadQuery);
            //AcctQuery = addLimit(AcctQuery);===========

            
            //Run the queries
            list<lead> LeadList = database.query(leadQuery);
            
            list<account>Account_list = new list<account>();
                        //===========
            
            for(lead l: leadList)
                resultList.add(new result(l));
            for(account a: account_list)
                resultList.add(new result(a));  
            
            return ResultList;
        }
   
    public list<result>getPinned()
        {
                list<result> ResultList = new list<result>();
                
            list<lead> LeadList=getPinnedLeads();
            
            list<account> Account_list = new list<account>();
            //getPinnedAccounts();
            //===========
            
            
            for(lead l: leadList)
                resultList.add(new result(l));
            for(account a: Account_list)
                resultList.add(new result(a));  
            
            return ResultList;
        }
    
    public list<lead> getPinnedLeads(){
                set<id> IDSet = new set<id>();
            list<PinnedMerchant__c> LeadSet=[select lead__c from PinnedMerchant__c WHERE Purchase_order__C =:POid];
            
            for(PinnedMerchant__c p:leadSet)
                IDset.add(p.lead__c);
            string queryString = getLeadSOQL();
            queryString += 'WHERE id IN :IDset';
            list<lead> L = database.query(queryString);          
            return l;
        }   
   
    public PageReference addAccount(){
            PinnedMerchant__c p = new PinnedMerchant__c(account__c  =  recordID, Purchase_Order__c = POId);
            insert p;
            return null;
        }
    public PageReference addLead(){
            PinnedMerchant__c p = new PinnedMerchant__c(lead__c  =  recordID, Purchase_Order__c = POId);
            insert p;
            return null;
        }
   public PageReference unpinLead(){
            PinnedMerchant__c p = [select id, lead__c, Purchase_Order__c from PinnedMerchant__c WHERE Purchase_order__c =:POiD AND lead__c=:recordId limit 1];
            delete p;
            return null;
        }
   public PageReference unpinMerchant(){
            PinnedMerchant__c p = [select id, account__c, Purchase_Order__c from PinnedMerchant__c WHERE Purchase_order__c =:POiD AND account__c=:recordId limit 1];
            delete p;
            return null;
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
            public string subdivision{get;set;}
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
            
            public result(Account A){
                    this.rtype='Account';
                    this.NewOld='Existing Business';
                    this.cat=a.Global_SFDC_Category__c;
                    this.RecordID =a.id;
                    this.Merchant=a.Name;
                    this.subcat=a.global_SFDC_Subcategory_1__c;
                    this.subcat2=a.Global_SFDC_Subcategory_2__c;                    
                    this.ResearchRanking=a.Research_Ranking__c;
                    this.owner=a.Owner.Name;
                    this.POID=POid;
                    this.stage=a.Account_Status__c;
                    this.website=a.website;
                    this.lastActivity= string.valueOf(a.Acct_Status_Change_Date__c);
                    if(a.pinned__c==true){this.checked='Yes';}else{this.checked='No';}
                }
            public result(lead l){
                this.rtype='Lead';
                this.NewOld='New Business';
                this.ContactName=l.Name;
                this.cat=l.Global_SFDC_Category__c;
                this.subdivision=l.Subdivision_Dynamic__r.name;
                this.RecordID = l.id;
                this.Merchant=l.Company;
                this.subcat=l.global_SFDC_Subcategory_1__c;
                this.subcat2=l.Global_SFDC_Subcategory_2__c;
                this.Phone=l.Phone;
                this.ResearchRanking=l.Research_Ranking__c;
                this.owner=l.owner.name;
                this.stage=l.Status;
                this.LastActivity=string.valueof(l.LastActivityDate);
                this.POID=POid;
                this.Website=l.Website;
                if(l.pinned__c==true){this.checked='Yes';}else{this.checked='No';}
            }
            public result(){}
        }
    public class Settings
        {
            public string cat{get;set;}
            public string subcat{get;set;}
            public string subcat2{get;set;}
            public id AssignedTo{get;set;}
            public string DivName{get;set;}
            public id SubDivID{get;set;}
        }   
      
    
    public string excludePinned(string s){
            s+=' id NOT IN :PinnedIDs ';
            return s;
        }    
    
    public string addPOConditions(string s, Settings POParams, string t){
                if(POParams.cat!=null)
                        s+=' Global_SFDC_Category__c = \''+POParams.cat+'\' AND ';
                if(POParams.subcat!=null)
                        s+=' Global_SFDC_SubCategory_1__c = \''+POParams.subcat+'\' AND ';
                if(POParams.divName!=null && t=='Lead')
                        s+=' division__c = \''+POParams.DivName+'\' AND ';
                if(POParams.divName!=null && t=='Account')
                        s+=' division__c = \''+POParams.DivName+'\' AND ';
                if(t=='Lead')
                        s+=' isconverted = false AND ';                                         
                return s;
        }
        

    public string getLeadSOQL(){
            LeadSOQL = 'select id, Pinned__c, company, LastActivityDate, Global_SFDC_Category__c, Research_Ranking__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Name, Website, Email, Status, Phone, LeadSource, Last_Activity_Date__c, MQS__c, owner.name, Merchant_Value__c, Subdivision_Dynamic__r.name, Division__c from Lead ';
            return leadSOQL;
        }
    public string getAcctSOQL(){
            AcctSOQL = 'select id, Pinned__c, Account.id, owner.name, Account.Name, Account.Research_Ranking__c, Account.ReClose_Aging__c, Global_SFDC_Category__c, Account.Owner.Name, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Feature_Date__c, Total_GMS__c, Total_GP__c, Permalink__c, Account.OwnerId, division__c, StageName, MQS__c, Account.Owner.id, Account.Merchant_Value__c, Subdivision_Dynamic__r.name from Opportunity ';
            return AcctSOQL;
        }       
    public string addOrderBy(string s){
                s+=' ORDER BY Research_Ranking__c asc';
                return s;
        }     
        
    public string addLimit(string soql){
            soql+= ' limit 250';
            return soql;
        }
    public set<id> excludePinned()
        {
            set<id>PinnedIDs = new set<id>();
            list<PinnedMerchant__c> ExcludeThese=[select lead__c, opportunity__c from PinnedMerchant__c WHERE Purchase_order__C =:POid];
            for(PinnedMerchant__c p:ExcludeThese)
                {
                    if(p.lead__c!=null)
                        PinnedIDs.add(p.lead__c);
                    if(p.opportunity__c!=null)    
                        PinnedIDs.add(p.opportunity__c);
                }
           return PinnedIDs;     
        }
    public string addWhere(string s){
                s+=' WHERE ';
                return s;
        }              

    public void init(){
            if(po==null)
                {
                    po = [select id, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Assigned_To__c, Division__c, Subdivision__c from Purchase_Order__c WHERE ID = :POId LIMIT 1];
                }
        }
        
    public Settings BuildSettings()
        {
                Settings POParams = new Settings();
                Purchase_Order__c p = [select id, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Assigned_To__c, Division__r.name, Subdivision__c from Purchase_Order__c WHERE ID = :POId LIMIT 1];

            POParams.cat = P.Global_SFDC_Category__c;
            POParams.subcat = P.Global_SFDC_Subcategory_1__c;
            POParams.divName = P.Division__r.name;
            return POParams;
        }
    public static list<option> getDivisions(){
            list<option> options = new list<option>();
            list<division__c> dlist = [select id, name from Division__c order by name ASC];
            options.add(new option());
            for(division__c d: dlist){
                options.add(new option(d));
                        }
                return options;
        }       
    public class option{
            public string value{get;set;}
            public string name{get;set;}
            public option(){this.value ='';this.name='';}
            public option(division__c d){this.value = d.name;this.name = d.name;}
            public option(taxonomy_support__c t){this.value = t.name__c;this.name = t.name__c;
         }
}
private testMethod static void testRelevantLeads(){
        
        Purchase_Order__c po = new Purchase_order__c();
        //= [select id, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Assigned_To__c, Division__c, Subdivision__c from Purchase_Order__c WHERE Division__c!=null AND Global_SFDC_Category__c !=null AND Global_SFDC_Subcategory_1__c!=null LIMIT 1];

        Division__c d = new Division__c(name='Hampton Roads', State__c = 'VA');
        insert d;
        po.assigned_to__c = '00580000003PoQL';
        po.Global_SFDC_Category__c = 'Restaurant';
        po.Global_SFDC_Subcategory_1__c = 'Bar';
        po.division__c = d.id;
        insert po;
        
        ApexPages.StandardController stc = new ApexPages.Standardcontroller(po);
        POsystem con = new POSystem (stc);
        
        PageReference pageRef = Page.POSystem;
        pageRef.getParameters().put('Id', po.id);
        Test.setCurrentPage(pageRef);
        
        con.POId=po.id;
        
        list<result>list1 = con.getPinned();
        list<result>list2 = con.getResults();
        
        
    }
    
}