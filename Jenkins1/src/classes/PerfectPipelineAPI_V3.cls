global class PerfectPipelineAPI_V3 {
    global PerfectPipelineAPI_V3(){} 
    
    global PerfectPipelineAPI_V3(string division, date start_date, date end_date){
        this.accountIds = new set<id>();
        this.leadIds = new set<id>();
        this.contact_list = new list<contact>();
        this.contact_map = new map<id,list<contact>>(); 
        this.target_zip_codes = new map<id,list<string>>();
        this.users = new map<id,user>([select id, FirstName, LastName, Name, email, phone from USER]);
        this.subdivision_map = new map<id,subdivision__c>([select id, name, division__r.name, (select id, Name FROM  Zip_Codes__r) FROM subdivision__c]);
        this.addy_map = new map<id,list<address>>(); 
        
        this.opportunities = [SELECT id,Primary_Deal_Services__c,category_v3__c,subcategory_v3__c,Deal_Attributes__c,Nextstep, recordType.name, Redeem_At__c, deal_issues__c, Subdivision_Dynamic__c, accountid, account.Merchant_Permalink__c,Account.Name, Category__c, Subcategory__c,unit_buy_price__c, Margin__c, Amount_of_Multi_Deal_Children__c, Total_GP__c, Feature_End_Date__c, Margin_Percent__c, Value_of_Unit__c, Projected_Multi_Deal_Share_of_GP__c, permalink__c, 
                                  Subdivision_Dynamic__r.name, type, Unit_Sell_Price__c, Total_Projected_GMS__c, Total_Feature_Projected_GP__c, Owner.Name, OwnerId, Name, 
                                  Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, Feature_Date__c, Division_Dynamic__r.Name, 
                                  Division_Dynamic__c, Deal_Strengh__c, (select id, Unit_Sell_Price__c,Unit_Value__c,unit_buy_price__c, Margin_Percent__c,margin__c FROM Multi_Deals__r)  
                              FROM Opportunity 
                              WHERE Division_Dynamic__r.Name = :division AND Feature_Date__c >= :start_date AND Feature_Date__c <= :end_date AND Feature_Date__c !=null AND Type != 'Social Media' AND Type != 'Sponsorship' AND Type != 'G-Team' ];

         this.purchase_orders = [SELECT id, (SELECT Account__c, lead__c, opportunity__c, Purchase_Order__c FROM PinnedMerchants__r),Subcategory_v3__c,Category_v3__c,Services__c,Merchant_attributes__c, name, Opportunity__c, Zip_Code__r.name, Subdivision__r.name, Assigned_To_multi__c, Rep_PO_Notes__c, Deal_Builder_Template__c, Assigned_to__r.name, Target_Revenue__c, 
                                     Target_GP__c, Example_Deal_1__c, Example_Deal_2__c, Target_Feature_Date__c, Global_SFDC_Category__c,  Division__r.Name,  Global_SFDC_Subcategory_1__c, 
                                     Global_SFDC_Subcategory_2__c, Ideal_Price_Range__c, PO_notes__c,  PO_Status__c, Type__c,latitude__c,longitude__c
                                 FROM Purchase_Order__c 
                                 WHERE Division__r.Name =:division AND Target_Feature_Date__c >= :start_date AND Target_Feature_Date__c <= :end_date AND PO_Status__c != 'Approved' AND PO_Status__c != 'Expired' AND Type__c !='Now!'];
        this.purchase_orders_assigned_to = new map<id,purchase_order__c>([select id, name, (select id, Assigned_To__c FROM Assigned_To1__r)
                                           FROM Purchase_Order__c 
                                           WHERE Division__r.Name =:division AND Target_Feature_Date__c >= :start_date AND Target_Feature_Date__c <= :end_date AND PO_Status__c != 'Approved' AND PO_Status__c != 'Expired' AND Type__c !='Now!']);
         
         this.targetZip = [SELECT id, (select id, Target_Zip_Code__c FROM Target_Zips__r)  
                              FROM Opportunity 
                              WHERE Division_Dynamic__r.Name = :division AND Feature_Date__c >= :start_date AND Feature_End_Date__c <= :end_date];
         
         list<opportunity> location_list = [SELECT id, (select City__c, Country__c, State__c,  Street_Line_1__c, Street_Line_2__c, Zip_Postal_Code__c, merchant_addresses__r.Longitude__c,merchant_addresses__r.Latitude__c FROM Addresses__r)  
                              FROM Opportunity 
                              WHERE Division_Dynamic__r.Name = :division AND Feature_Date__c >= :start_date AND Feature_Date__c <= :end_date];

         for(opportunity o: location_list ){
             list<address> addy_list = new list<address>();
             for(Address__c a : o.Addresses__r){
                     addy_list.add(new address(a));
                 }
             addy_map.put(o.id,addy_list);    
         }
                              
         this.contact_list = [select id, Email, phone, name, accountid FROM contact where AccountID in: this.accountIds];
         
         this.lead_map = new map<id,lead>([select id, Phone,Merchant_Attributes__c,services_offered__c, Global_SFDC_Category__c, Global_SFDC_subcategory_1__c, Global_SFDC_subcategory_2__c, Company, Name, email, Research_Ranking__c, ownerID, owner.name, status, Last_Activity_Date__c, repNotes__c, RepnotesDate__c,  (select id, Subject, owner.name, description, ActivityDate FROM tasks ORDER BY ActivityDate DESC LIMIT 5) from lead where id in :this.leadIds]);
         
         
         this.account_map = new map<id,account>([select id,Merchant_Attributes__c,services_offered__c,  Global_SFDC_Category__c, Global_SFDC_subcategory_1__c, Global_SFDC_subcategory_2__c, ownerid, owner.name, RepnotesDate__c, RepNotes__c,Research_Ranking__c, name, phone, Account_Status__c, Most_Recent_Feature__c, Total_Revenue__c, (select id, Subject, owner.name, description, ActivityDate FROM tasks ORDER BY ActivityDate DESC LIMIT 5) from Account where id in :this.accountIds]);
         
         for(opportunity o: targetZip){
             list<string> zip = new list<string>();
             for(target_zip__c t:o.Target_Zips__r){
                     zip.add(t.Target_Zip_Code__c);
                 }
              target_zip_codes.put(o.id,zip);   
             }    
         for (contact c : this.contact_list){
                 if(this.contact_map.containsKey(c.accountid)){
                         list<contact> cont = contact_map.get(c.accountid);
                         cont.add(c);
                         this.contact_map.put(c.accountid,cont);
                     }else{
                             list<contact> cont = new list<contact>();
                             cont.add(c);
                             this.contact_map.put(c.accountid,cont);
                          }
             }                                            
    }
map<id,list<address>> addy_map {get;set;}    
map<id,list<string>> target_zip_codes {get;set;}
map<id,user> users {get;set;}
map<id,list<contact>> contact_map {get;set;}
map<id,account> account_map {get;set;}
map<id,lead> lead_map {get;set;}
//map<id,list<pinnedMerchant__c>> po_pin_map {get;set;}
map<id,subdivision__c> subdivision_map {get;set;}

map<id,purchase_order__c> purchase_orders_assigned_to {get;set;}
list<opportunity> targetZip {get;set;}
list<opportunity> opportunities {get;set;}
list<multi_deal__c> multi_deal{get;set;}
list<purchase_order__c> purchase_orders {get;set;}
//list<pinnedMerchant__c> pinned_merchants{get;set;}
list<contact> contact_list {get;set;}
list<account> account_list {get;set;}
list<lead> lead_list {get;set;}

set<id> leadIds {get;set;}
set<id> accountIds {get;set;}

public list<pipeline> getPipeline(){
        list<pipeline> pipelines = new list<pipeline>();
        for(opportunity o:opportunities){
                subdivision__c subdiv = new subdivision__c();
                if(subdivision_map.containsKey(o.Subdivision_Dynamic__c))subdiv = subdivision_map.get(o.Subdivision_Dynamic__c);
                pipelines.add(new pipeline(o,target_zip_codes.get(o.id),addy_map.get(o.id), subdiv));
            }
        for(purchase_order__c po :purchase_orders){
                subdivision__c subdiv = new subdivision__c();
                if(po.subdivision__c !=null)
                    subdiv = subdivision_map.get(po.subdivision__c);
                pipelines.add(new pipeline(po, lead_map, contact_map,account_map, subdiv, users, purchase_orders_assigned_to.get(po.id)));    
            }
        return pipelines;    
    }

global class Pipeline{
            public string type{get;set;}
            public Subdivision subdivision{get;set;}
            public id RecordId{get;set;}
            public string PONotes{get;set;}
            public string Status{get;set;}
            public string POtype{get;set;}
            public string RepNotes{get;set;}
            public string DealType{get;set;}
            public string NextStep{get;set;}
            public string OwnerName{get;set;}
            public id deal_id {get;set;}
            public string deal_issues {get;set;}
            public string redeem_at {get;set;}
            public string opportunity_record_type {get;set;}
            //objects
            public links links {get;set;}
            public list<deal_structure> options{get;set;}
            public list<string> targetingZipCodes{get;set;}
            public Taxonomy taxonomy {get;set;}
            public list<assigned_to> assignedTo{get;set;}
            public Financial financial {get;set;}
            public Merchant merchant {get;set;}
            public dates dates {get;set;}
            public list<address> locations {get;set;}
            public proposed_locations proposed_location{get;set;}
            public Pipeline(opportunity o, list<string> zips, list<address> addy_list, subdivision__c subdiv){
                    this.type='Deal';
                    this.redeem_at = o.Redeem_At__c;
                    this.RecordId=o.id;
                    this.dates = new dates(o);
                    this.PONotes=o.name;
                    this.status=o.deal_strengh__c;
                    this.DealType=(o.type);
                    this.subdivision = new subdivision(subdiv);
                    //this.pinnedMerchants = new list<pinnedMerchant>();
                    this.NextStep=string.valueof(o.NextStep);
                    this.taxonomy = new taxonomy(o);
                    this.links = new links(o);
                    this.financial = new Financial(o);
                    this.merchant = new merchant(o);
                    this.options = new list<deal_structure>();
                    this.options.add(new deal_structure(o));
                    for(multi_deal__c md : o.Multi_deals__r){
                            this.options.add(new deal_structure(md));
                        }
                    this.targetingZipCodes = zips; 
                    this.locations = addy_list;
                    this.deal_issues = o.deal_issues__c;
                    this.opportunity_record_type =o.recordType.name;   
                    this.OwnerName =  o.Owner.Name;
                }
          public Pipeline (Purchase_order__c po, map<id,lead> lead_map, map<id,list<contact>> contact_map, map<id,account> account_map, subdivision__c subdiv, map<id,user> users,purchase_order__c po_assigned){
                    this.recordID=po.id;
                    this.type='PO';
                    this.PONotes=po.PO_Notes__c;
                    this.status=po.po_status__c;
                    this.dates = new dates(po);
                    this.DealType='PO';
                    this.RepNotes = po.Rep_PO_Notes__c;
                    this.taxonomy = new taxonomy(po);
                    this.links = new links(po);
                    this.targetingZipCodes = new list<string>();
                    this.targetingZipCodes.add(po.Zip_Code__r.name);
                    this.financial = new Financial(po);
                    this.subdivision = new subdivision(subdiv);
                    //this.pinnedMerchants = new list<pinnedMerchant>();
                    this.deal_id = po.Opportunity__c;
                    this.assignedTo = new list<assigned_to>();
                    this.proposed_location = new proposed_locations(po);

                    for(assignedTo__C ass : po_assigned.Assigned_To1__r){
                        user deal_user =users.get(ass.Assigned_To__c);
                        if ( deal_user != null) { 
                          assignedTo.add(new assigned_to(deal_user));
                        }
                    }
                    list<contact> contactval = new list<contact>();
                }
        }
      public class deal_structure{
            public decimal unit_sell_price{get;set;}
            public decimal unit_value{get;set;}
            public decimal unit_margin_percent{get;set;}
            public decimal unit_margin_dollar{get;set;}
            public decimal unit_buy_price{get;set;}
            
            public deal_structure(opportunity o){
                    this.unit_sell_price = o.Unit_Sell_Price__c;
                    this.unit_value = o.Value_of_Unit__c;
                    this.unit_buy_price = o.unit_buy_price__c;
                    this.unit_margin_percent = o.Margin_Percent__c;
                    this.unit_margin_dollar = o.margin__c;
                }
           public deal_structure(Multi_Deal__c m){
                    this.unit_sell_price = m.Unit_Sell_Price__c;
                    this.unit_value = m.Unit_Value__c;
                    this.unit_buy_price = m.unit_buy_price__c;
                    this.unit_margin_percent = m.Margin_Percent__c;
                    this.unit_margin_dollar = m.margin__c;
                }     
        }
    public class tasks{
            public string activity_date {get;set;}
            public string owner {get;set;}
            public string task_subject {get;set;}
            public string task_comments {get;set;}
            
            public tasks(task t){
                    if(t.ActivityDate!=null)this.activity_date = t.ActivityDate.format();
                    this.owner = t.owner.name;
                    this.task_subject = t.subject;
                    this.task_comments = t.Description;
            }
        }    
    public class links{
            public string example_deal_1 {get;set;}
            public string example_deal_2 {get;set;}
            public string deal_builder {get;set;}
            public string permalink {get;set;}
            
            public links(opportunity o){this.permalink=o.permalink__c;}
            public links(purchase_order__c po){
                    this.deal_builder = po.Deal_Builder_Template__c;
                    this.example_deal_1 = po.Example_Deal_1__c;
                    this.example_deal_2 = po.Example_Deal_2__c;
                }
        }
    public class taxonomy{
            public string v1_category{get;set;}
            public string v1_subcategory{get;set;}
            public string v2_category{get;set;}
            public string v2_subcategory1{get;set;}
            public string v2_subcategory2{get;set;}
            public string v3_category{get;set;}
            public string v3_subcategory{get;set;}
            public list<string> v3_services{get;set;}
            public list<string> v3_attributes{get;set;}
            public taxonomy(opportunity o){
                    this.v1_category = o.category__c;
                    this.v1_subcategory = o.subcategory__c;
                    this.v2_category = o.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = o.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = o.Global_SFDC_Subcategory_2__c;
                    this.v3_services = new list<string>();
                    this.v3_attributes = new list<string>();
                    string[] servicessplit = new string [] {};
                    string[] servicessplit2 = new string [] {};

                    this.v3_category = o.Category_v3__c;
                    this.v3_subcategory = o.Subcategory_v3__c;
                    if(o.Primary_Deal_Services__c!=null)
                    {
                        o.Primary_Deal_Services__c.replace(' | ','|');
                        for(String s: o.Primary_Deal_Services__c.split('\\|'))
                        {
                        servicessplit.add(s);
                        }
                    }
                    this.v3_services = servicessplit ;
                   if(o.Deal_Attributes__c!=null)
                    {
                        o.Deal_Attributes__c.replace(' | ','|');
                        for(String s: o.Deal_Attributes__c.split('\\|'))
                        {
                        servicessplit2.add(s);
                        }
                    }
                    this.v3_attributes=  servicessplit2;
                   
                }
            public taxonomy(Purchase_order__c po){
                    this.v2_category = po.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = po.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = po.Global_SFDC_Subcategory_2__c; 
                    this.v3_services = new list<string>();
                    this.v3_attributes = new list<string>();
                    this.v3_category = po.Category_v3__c;
                    this.v3_subcategory = po.Subcategory_v3__c;                 
                    string[] servicessplit = new string [] {};
                    string[] servicessplit2 = new string [] {};
                     if(po.Services__c!=null)
                    {
                        po.Services__c.replace(' | ','|');
                        for(String s: po.Services__c.split('\\|'))
                        {
                        servicessplit.add(s);
                        }
                    }
                    this.v3_services = servicessplit;
                     if(po.Merchant_Attributes__c!=null)
                    {
                        po.Merchant_Attributes__c.replace(' | ','|');
                        for(String s: po.Merchant_Attributes__c.split('\\|'))
                        {
                        servicessplit2.add(s);
                        }
                    }
                    this.v3_attributes =servicessplit2;
                }
             public taxonomy(account a){
   
                    this.v2_category = a.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = a.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = a.Global_SFDC_Subcategory_2__c;
                    string[] servicessplit = new string [] {};
                    string[] servicessplit2 = new string [] {};
                     if(a.Services_Offered__c!=null)
                    {
                        a.Services_Offered__c.replace(' | ','|');
                        for(String s: a.Services_Offered__c.split('\\|'))
                        {
                        servicessplit.add(s);
                        }
                    }
                    this.v3_services = servicessplit;
                     if(a.Merchant_Attributes__c!=null)
                    {
                        a.Merchant_Attributes__c.replace(' | ','|');
                        for(String s: a.Merchant_Attributes__c.split('\\|'))
                        {
                        servicessplit2.add(s);
                        }
                    }
                    this.v3_attributes =servicessplit2;                   
                }
             public taxonomy(lead l){
                    this.v2_category = l.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = l.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = l.Global_SFDC_Subcategory_2__c;
                        string[] servicessplit = new string [] {};
                    string[] servicessplit2 = new string [] {};
                     if(l.Services_Offered__c!=null)
                    {
                        l.Services_Offered__c.replace(' | ','|');
                        for(String s: l.Services_Offered__c.split('\\|'))
                        {
                        servicessplit.add(s);
                        }
                    }
                    this.v3_services = servicessplit;
                     if(l.Merchant_Attributes__c!=null)
                    {
                        l.Merchant_Attributes__c.replace(' | ','|');
                        for(String s: l.Merchant_Attributes__c.split('\\|'))
                        {
                        servicessplit2.add(s);
                        }
                    }
                    this.v3_attributes =servicessplit2; 
                    
                }           
        }
    public class assigned_to{
            public string first_name {get;set;}
            public string last_name{get;set;}
            public string full_name{get;set;}
            public string email {get;set;}
            public string phone {get;set;}
            public string id {get;set;}
            
            public assigned_to(user u){
                    this.first_name = u.FirstName;
                    this.last_name = u.LastName;
                    this.full_name = u.name;
                    this.email = u.email;
                    this.phone = u.phone;
                    this.id = u.id;
                }
        }
    public class contacts{
            public string name {get;set;}
            public string phone {get;set;}
            public string email {get;set;}
            public string id {get;set;}
            
            public contacts(lead l){
                    this.name = l.Name;
                    this.phone = l.phone;
                    this.email = l.email;
                    this.id = l.id;
                }
            public contacts(contact c){
                    this.name = c.Name;
                    this.phone = c.phone;
                    this.email = c.email;
                    this.id = c.id;
                }    
        }
    public class dates{
            public date target_date {get;set;}
            public date feature_start_date {get;set;}
            public date feature_end_date {get;set;}
            public date week_of {get;set;}
            public dates(purchase_order__c p){
                this.target_date = p.Target_Feature_Date__c;
                this.week_of = p.Target_Feature_Date__c.toStartOfWeek();
            }
            public dates(opportunity o){
                this.feature_start_date = o.feature_date__c;
                this.feature_end_date = o.Feature_End_Date__c; 
                this.week_of = o.feature_date__c.toStartOfWeek();
            }
        }    
     public class financial{
            public string PriceRange{get;set;}
            public decimal TargetGP{get;set;}
            public decimal TargetGMS{get;set;}  
            public decimal TotalGP{get;set;}
            public financial(opportunity o){
                this.TargetGP = o.Total_Feature_Projected_GP__c;
                this.TargetGMS = o.Total_Projected_GMS__c;
                this.TotalGP = o.Total_GP__c;
            }
            public financial(purchase_order__c p){
                this.priceRange = p.Ideal_Price_Range__c;
                this.TargetGP = p.Target_GP__c;
                this.TargetGMS = p.Target_Revenue__c;
                }
         }
     public class subdivision{
             public string name{get;set;}
             public string division {get;set;}
             public list<string> zip_codes {get;set;}
             
             public subdivision(subdivision__c s){
                     this.name = s.name;
                     this.division = s.division__r.name;
                     this.zip_codes = new list<string>();
                     for(zip_code__c z: s.Zip_Codes__r)
                         this.zip_codes.add(z.name);
                 }
         }
             
     public class merchant{
             public string name {get;set;}
             public string salesforce_id {get;set;}
             public string merchant_permalink {get;set;}
             
             public merchant (opportunity o){
                     this.name = o.account.name;
                     this.salesforce_id = o.accountid;
                     this.merchant_permalink = o.account.Merchant_Permalink__c;
                 }
         }
       public class Address{
            public string street_1 {get;set;}
            public string street_2 {get;set;}
            public string city {get;set;}
            public string state {get;set;}
            public string zip {get;set;}
            public string country {get;set;}
            public id salesforce_id {get;set;}   
            public decimal lat {get;set;}
            public decimal lng {get;set;}
            
            public address(Address__c a){
                  this.street_1 = a.Street_Line_1__c;
                  this.street_2 = a.Street_Line_2__c;
                  this.city = a.city__c;
                  this.state = a.State__c;
                  this.zip = a.zip_postal_code__c;
                  this.country = a.country__c;
                  this.salesforce_id = a.id;
                  this.lng = a.merchant_addresses__r.Longitude__c;
                  this.lat = a.merchant_addresses__r.Latitude__c;
              }
          }        
        public class proposed_locations
        {
            public id salesforce_id {get;set;}   
            public string lat {get;set;}
            public string lng {get;set;}
            public proposed_locations(purchase_order__c POS)
            {
                  this.salesforce_id = POS.Id ;
                  this.lng = string.valueof(POS.longitude__c);
                  this.lat = string.valueof(POS.latitude__c);
            }
        }
static testMethod void PerfectPipelineAPI_V3(){
    grouponTestUtil util = new grouponTestUtil();
    list<contact> contact_list = new list<contact>();
    user users = util.createTestUser('system administrator');
    insert users;
    
    Assignedto__c assign = util.createassignedto();
    insert assign;
    
    subdivision__c subdiv = util.createsubdiv();
    insert subdiv;
    division__c d = util.createDivision();
    insert d;
    
    account a = util.createAccount();
    a.division__c = d.id;
    insert a;
    
    contact c = new contact();
    c.accountid = a.id;
    c.lastname = 'my last name';
    insert c;
     contact_list.add(c);
    opportunity o = new opportunity();
    o.division__c = d.name;
    o.name = 'my test name' + string.valueOf(system.today());
    o.stageName = 'Prospecting';
    o.closeDate = system.today();
    o.feature_date__c = system.today();
    o.feature_end_date__c = system.today();
    insert o;
    
    purchase_order__c po = util.createPO();
    po.target_feature_date__c = system.today();
    insert po;
    
    lead l = new lead();
    l.division__c = d.name;
    l.lastName ='my last name' + string.valueOf(system.today());
    l.company =  'my company name'+ string.valueOf(system.today());
    insert l;
    
    
    merchant_addresses__c mercha = new merchant_addresses__c();
    mercha.latitude__c = 123;
    mercha.longitude__c = 321;
    mercha.Account__c = a.id;
    insert mercha;
    
    address__c addy = new address__c();
    addy.merchant_addresses__c = mercha.id;
    addy.Opportunity__c = o.id;
    insert addy;
    map<id,lead> lead_map = new map<Id,lead>();
    map<id,list<contact>> contact_map = new map<id,list<contact>>();
    map<id,account> account_map = new map<Id,account>();
    map<id,user> user_map = new map<id,user>();
    lead_map.put(l.Id,l);
    contact_map.put(c.id,contact_list);
    account_map.put(a.id,a);
    user_map.put(users.Id,users);
    
    PerfectPipelineAPI_V3 api = new PerfectPipelineAPI_V3(d.name, system.today(), system.today());
    PerfectPipelineAPI_V3.pipeline PP_pipeline = new PerfectPipelineAPI_V3.pipeline (po, lead_map, contact_map,account_map, subdiv, user_map,po);
    list<pipeline> my_pipeline =  api.getPipeline();
}                                                  
}