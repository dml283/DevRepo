public class workbench {

@RemoteAction
public static void closeTask(string taskId){
    try{
        Task t = [select id, status from Task where id = :taskId];
        t.status = 'Completed';
        database.update(t);
    }catch(exception e){system.debug(e);}
}
@RemoteAction
public static void deleteTask(string taskId){
    try{
        Task t = [select id FROM Task where id = :taskId];
        database.delete(t);
    }catch(exception e){system.debug(e);}
}
public stat getStat(){
    stat s = new stat();
    return s;
}
@RemoteAction
public static list<contact> merchant_contacts(string theId){
     list<contact> contacts = new list<contact>();
     contacts = [select id, name, phone, email from Contact where accountid = :theId];
     return contacts;
    }
public list<transactions> getTransactions(){
    list<transactions> transactions = new list<transactions>();
    for(Financial_Records__c fr: [select opportunity__r.feature_date__c, opportunity__r.feature_end_date__c, Booking_Amount__c, Sum_of_Refunds__c, Units_Refunded__c, Collection_Date__c, opportunity__r.name, opportunity__c  FROM Financial_Records__c WHERE (Opportunity__r.ownerid = :UserInfo.getUserId() OR opportunity__r.account.Account_Manager__c = :UserInfo.getUserId()) AND Collection_Date__c!=null AND collection_date__c = this_quarter ORDER BY Collection_Date__c DESC LIMIT 250]){
        transactions.add(new transactions(fr));
    }
    return transactions;
}
public list<live_deal> getLiveDeals(){
     list<live_deal> live_deals = new list<live_deal>();
     list<opportunity> olist = [SELECT account.category_v3__c, division__c, account.subcategory_v3__c, account.name, permalink__c, accountid, name, id, feature_date__c, feature_end_date__c, (SELECT  Revenue_Amount__c FROM Financial_Records__r) FROM Opportunity WHERE feature_date__c <= :system.today() AND feature_end_date__c >= :system.today() AND recordType.name != 'Rewards' LIMIT 999];
     for(opportunity o: olist)
       live_deals.add(new live_deal(o));
     return live_deals;
}
public class transactions{
    public decimal revenue {get;set;}
    public date collection_date {get;set;}
    public string collection_date_format {get;set;}
    public string deal_name {get;set;}
    public date feature_date {get;set;}
    public date feature_end_date {get;set;}
    public decimal refunds {get;set;}
    public decimal refund_units {get;set;}
    public id deal_id {get;set;}
    public string type {get;set;}
    public transactions(Financial_Records__c fr){
        this.revenue = fr.Booking_Amount__c;
        this.collection_date = fr.Collection_Date__c;
        this.collection_date_format = fr.Collection_Date__c.format();
        this.deal_name = fr.opportunity__r.name;
        this.feature_date = fr.opportunity__r.feature_date__c;
        this.feature_end_date = fr.opportunity__r.feature_end_date__c;
        this.refunds = fr.Sum_of_Refunds__c;
        if(refunds!=null)refunds.setScale(0);
        this.refund_units = fr.Units_Refunded__c;
        if(refund_units!=null)refund_units.setScale(0);
        this.deal_id = fr.opportunity__c;
        if(collection_date < fr.opportunity__r.feature_date__c){
            this.type='Pre-Feature';
        }
        if(collection_date >= fr.opportunity__r.feature_date__c && collection_date <= fr.opportunity__r.feature_end_date__c){
            this.type='Feature';
        }else{
            this.type='Post-Feature';
        }
        
    }
    
    
}
public list<opportunity> getMyRGI(){
    list<opportunity> opps = new list<opportunity>();
    opps = [select id, name, account.name, closeDate, accountid, stageName, deal_strengh__c, category_v3__c, subcategory_v3__c, division__c FROM opportunity where (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId()) AND Deal_strengh__c = 'Rep Getting Info' AND stageName='Closed Won' ORDER BY closeDate desc];
    return opps;
}
public contract_list getContrats(){
     contract_list cl = new contract_list();
     return cl;
    }
public calendar_list getMyCalendarList(){
    return new calendar_list();
}    
public list<ir> getIR(){
    list<ir> irs = new list<ir>();
    for(information_request__c i : [select id, opportunity__r.Pre_Feature_Status__c, opportunity__r.deal_strengh__c, Write_Up_Status__c, Who_do_you_need_information_from__c, Please_describe_the_information_you_need__c, What_is_Missing__c, opportunity__r.name, opportunity__r.feature_date__c, name from Information_request__c where (Opportunity__r.ownerid = :UserInfo.getUserId() OR opportunity__r.account.Account_Manager__c = :UserInfo.getUserId()) AND Issue_Resolved__c = false AND (opportunity__r.feature_date__c > :system.today() OR opportunity__r.feature_date__c = null) AND opportunity__r.stageName = 'Closed Won' ORDER BY opportunity__r.feature_date__c desc]){
         irs.add(new ir(i));        
        }
    return irs;
    }
public list<merchant> getMerchants(){
    list<merchant> merchants = new list<merchant>();
    for(account a :[select id, Now_Launch__c, Groupon_Scheduler_Strength__c, Do_Not_Run_Again__c, LastActivityDate,Account_Manager__r.name, Total_GP__c, Merchant_Refund_Dollars__c, Services_Offered__c,Merchant_Attributes__c,Category_v3__c,Subcategory_v3__c,Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Global_SFDC_Category__c, name, Most_Recent_Feature__c, Number_of_Features__c, research_ranking__c, merchant_permalink__c, m3_id__c FROM account where (ownerid = :UserInfo.getUserId() OR account_manager__c = :UserInfo.getUserId()) ORDER BY research_ranking__c desc LIMIT 499]){
        merchants.add(new merchant(a));
    }
    for(lead l: [select id,Category_v3__c,Subcategory_v3__c,Services_Offered__c,Merchant_Attributes__c, Research_Ranking__c, Company,M3_Id__c, LastActivityDate, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c FROM lead WHERE ownerid = :UserInfo.getUserId() AND isconverted = false ORDER BY research_ranking__c desc LIMIT 499]){
        merchants.add(new merchant(l));
    }
    if(merchants.size() > 0){
        return merchants;
        }else{
            merchant m = new merchant();
            merchants.add(m);
            return merchants;
        }
}
public list<calendar> getCalendar(){
    list<calendar> mycal = new list<calendar>();
    date low_range = system.today().addDays(-60);
    for(opportunity o : [select id,deal_issues__c,Subdivision__c, Pre_Feature_Status__c, account.name, division__c, Projected_GP__c,Writeup_Status_del__c, Merchant_name_in_write_up__c, Multi_Deal_Projected_GP__c,  Deal_Strengh__c, Total_GP__c, Subcategory_v3__c, Category_v3__c, name, feature_date__c, feature_end_date__c from opportunity where (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId()) AND feature_date__c !=null AND feature_end_date__c !=null AND feature_date__c > :low_range ORDER by Feature_date__c DESC]){
        mycal.add(new calendar(o));
    }
    return mycal;
}       
public string getCalendarJSON(){
    list<calendar> mycal = new list<calendar>();
    date low_range = system.today().addDays(-60);
    for(opportunity o : [select id,deal_issues__c,Subdivision__c, Pre_Feature_Status__c, account.name, division__c, Projected_GP__c,Writeup_Status_del__c, Merchant_name_in_write_up__c, Multi_Deal_Projected_GP__c,  Deal_Strengh__c, Total_GP__c, Subcategory_v3__c, Category_v3__c, name, feature_date__c, feature_end_date__c from opportunity where (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND feature_date__c !=null AND feature_end_date__c !=null AND feature_date__c > :low_range ORDER by Feature_date__c DESC]){
        mycal.add(new calendar(o));
    }
    return JSON.serialize(mycal);
}    
public calendar_status getCalendar_satus(){
    calendar_status banner = new calendar_status();
    list<opportunity> status = [select id,Pre_Feature_Status__c, Multi_Deal_Projected_GP__c, Projected_GP__c, deal_issues__c, deal_strengh__c FROM opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND stageName ='Closed Won' AND feature_date__c >= :system.today()];
    for(opportunity o : status){
        if(o.deal_strengh__c=='A Sure Thing'){banner.sure_thing++;}
        if(o.deal_strengh__c=='Rep Getting Info'){banner.getting_info++;}
        if(o.deal_strengh__c!='Rep Getting Info' && o.deal_strengh__c!='A Sure Thing'){banner.in_progress++;}
        banner.projected_gp = o.Multi_Deal_Projected_GP__c+o.Projected_GP__c;    
    }
    return banner;
}
@RemoteAction
public static list<marker> getMapMarkers(){
    list<marker> markers = new list<marker>();
    for(Merchant_Addresses__c ma : [select id, account__c, account__r.name, Latitude__c, Longitude__c, account__r.category_v3__c, account__r.subcategory_v3__c from Merchant_Addresses__c WHERE (account__r.ownerid = :UserInfo.getUserId() OR account__r.Account_Manager__c = :UserInfo.getUserId())  AND Latitude__c!=null LIMIT 999]){
        markers.add(new marker(ma));
    }
    for(lead l : [select id, company, Latitude__c, Longitude__c, category_v3__c, subcategory_v3__c FROM LEAD where ownerid = :UserInfo.getUserId()  AND Latitude__c!=null]){
        markers.add(new marker(l));
    }
    return markers;
}
public merchant_stat getMerchant_stats(){
     merchant_stat stats = new merchant_stat();
     string ranking='0';
     string lead_ranking='0';
     string num_leads ='0';
     string num_accounts='0';
     stats.total_deals = '1';
     AggregateResult[] ar = [SELECT sum(Total_GP__c) gp, sum(Research_Ranking_num__c) ranking , sum(Merchant_Refund_Dollars__c) refunds, sum(Number_of_Features__c) num_deals, count(id) closed FROM Account WHERE (ownerid = :UserInfo.getUserId() OR Account_Manager__c = :UserInfo.getUserId())  AND Total_GP__c>0];
        for(AggregateResult agg :ar){
        stats.total_gp_earned = string.valueOf(agg.get('gp'));
        stats.total_refunds = string.valueOf(agg.get('refunds'));
        stats.total_deals = string.valueOf(agg.get('num_deals'));
        stats.merchants_closed = string.valueOf(agg.get('closed'));
        ranking = string.valueOf(agg.get('ranking'));
        }
     AggregateResult[] ar1 = [SELECT count(id) num_leads, sum(Research_Ranking_num__c) ranking FROM Lead WHERE ownerid = :UserInfo.getUserId() AND isconverted=false];
        for(AggregateResult agg :ar1){  
        lead_ranking = string.valueOf(agg.get('ranking'));
        num_leads = string.valueOf(agg.get('num_leads'));
        }
     AggregateResult[] ar2 = [SELECT count(id)accounts FROM Account WHERE (ownerid = :UserInfo.getUserId() OR Account_Manager__c = :UserInfo.getUserId()) ];
        for(AggregateResult agg :ar2){
            num_accounts = string.valueOf(agg.get('accounts'));
        }
    
     stats.num_merchants = integer.valueOf(num_accounts) + integer.valueOf(num_leads);
     if(lead_ranking!=null & ranking!=null)stats.avg_ranking=(decimal.valueOf(lead_ranking)+decimal.valueOf(ranking))/stats.num_merchants;
     if(stats.avg_ranking!=null)stats.avg_ranking=stats.avg_ranking.setScale(2);
     if(decimal.valueOf(stats.total_deals)>0 && stats.total_deals!=null && stats.total_gp_earned!=null)stats.avg_gp_deal = decimal.valueOf(stats.total_gp_earned)/decimal.valueOf(stats.total_deals);
     if(decimal.valueOf(stats.total_gp_earned)>0 && stats.total_refunds!=null)stats.avg_refund_rate = decimal.valueOf(stats.total_refunds)/decimal.valueOf(stats.total_gp_earned);
     if(stats.avg_refund_rate!=null)stats.avg_refund_rate=stats.avg_refund_rate.setScale(2);
     if(stats.avg_gp_deal!=null)stats.avg_gp_deal=stats.avg_gp_deal.setScale(2);
     return stats;
}
public class live_deal{
    public string category {get;set;}
    public string subcategory {get;set;}
    public string merchant_name {get;set;}
    public string deal_name {get;set;}
    public string merchant_id {get;set;}
    public string deal_id {get;set;}
    public decimal revenue{get;set;}
    public string feature_launch_date {get;set;}
    public string feature_end_date {get;set;}
    public string permalink {get;set;}
    public string division {get;set;}
    public live_deal(opportunity o){
        this.category = o.account.category_v3__c;
        this.subcategory = o.account.subcategory_v3__c;
        this.merchant_name = o.account.name;
        this.merchant_id = o.accountid;
        this.deal_name = o.name;
        this.deal_id = o.id;
        this.permalink = o.permalink__c;
        this.feature_launch_date = o.feature_date__c.format();
        this.feature_end_date = o.feature_end_date__c.format();
        this.revenue = 0;
        this.division = o.division__c;
        for(Financial_Records__c fr : o.Financial_Records__r){
            revenue+=fr.Revenue_Amount__c;
        }

    }
    
} 
public class marker{
    public string title {get;set;}
    public id id {get;set;}
    public latlng latlng {get;set;}
    public string category {get;set;}
    public string subcategory{get;set;}
    
    public marker (Merchant_Addresses__c ma){
        this.title = ma.account__r.name;
        this.category = ma.account__r.category_v3__c;
        this.subcategory = ma.account__r.subcategory_v3__c;
        this.id = ma.account__c;
        this.latLng = new latLng();
            this.latlng.lat = ma.Latitude__c;
            this.latlng.lng = ma.Longitude__c;
    }
    public marker (lead l){
        this.title =l.company;
        this.category = l.category_v3__c;
        this.subcategory = l.subcategory_v3__c;
        this.id = l.id;
        this.latlng = new latLng();
             this.latlng.lat = l.Latitude__c;
             this.latlng.lng = l.Longitude__c;
        //id, company, Latitude__c, Longitude__c, category_v3__c, subcategory_v3__c
    }
} 
public class LatLng{
        public decimal lat {get;set;}
        public decimal lng {get;set;}
    }   
public class merchant_stat{
    public integer num_merchants {get;set;}
    public string merchants_closed {get;set;}
    public decimal avg_ranking {get;set;}
    public string total_gp_earned {get;set;}
    public decimal avg_gp_deal {get;set;}
    public decimal avg_refund_rate {get;set;}
    public string total_refunds {get;set;}
    public string total_deals {get;set;}
 }
public class calendar{
    public string start_date {get;set;}
    public string end_date {get;set;}
    public string name {get;set;}
    public string id {get;set;}
    public string category {get;set;}
    public decimal total_gp{get;set;}
    public string subcategory {get;set;}
    public string deal_strength {get;set;}
    public decimal proj_gp {get;set;}
    public string merchant_name {get;set;}
    public string writeup_status {get;set;}
    public string division {get;set;}
    public string subdivision {get;set;}
    public string backgroundColor {get;set;}
    
    public calendar(opportunity o){
            if(o.Pre_Feature_Status__c=='Opt-In'){
                this.start_date = o.Feature_Date__c.addDays(-1).format();
            }else{
                this.start_date = o.Feature_Date__c.format();
                }
            this.end_date = o.feature_end_date__c.format();
            this.name = o.name;
            if(o.Total_GP__c>0)
              this.name+=' $'+o.Total_GP__c.SetScale(0)+' GP';
            this.id = o.id;
            this.category =o.Category_v3__c;
            this.total_gp = o.Total_GP__c.SetScale(0);
            this.subcategory = o.Subcategory_v3__c;
            this.deal_strength = o.Deal_Strengh__c;
            if(o.Merchant_name_in_write_up__c!=null){this.merchant_name = o.Merchant_name_in_write_up__c;}else{this.merchant_name=o.account.name;}
            this.proj_gp = o.Multi_Deal_Projected_GP__c+o.Projected_GP__c;
            this.writeup_status = o.Writeup_Status_del__c;
            this.subdivision=o.subdivision__c;
            this.division=o.division__c;
            
            if(o.deal_issues__c!='No Issues'){this.backgroundColor='red';}else if(o.deal_strengh__c!='A Sure Thing'){this.backgroundColor='grey';}else{this.backgroundColor='black';}
        }
}

public class calendar_status{
    public decimal sure_thing{get;set;}
    public decimal in_progress {get;set;}
    public decimal getting_info {get;set;}
    public decimal projected_gp {get;set;}
    public calendar_status(){
        this.sure_thing=0;
        this.in_progress=0;
        this.getting_info=0;
        this.projected_gp=0;
    }
}
public class contract_list{
    public list<contract> outstanding {get;set;}
    public list<contract> closed {get;set;}
    public list<contract> prospecting {get;set;}
    
    public contract_list(){
        this.outstanding = new list<contract>();
        this.closed = new list<contract>();
        this.prospecting = new list<contract>();
        for(opportunity o : [select id, name, accountid, account.name, stageName, closeDate,createdDate,category_v3__c, subcategory_v3__c, (Select ID, echosign_dev1__DateSentDate__c FROM echosign_dev1__R00N70000001hM2REAU__r) FROM opportunity where ownerid = :UserInfo.getUserId() AND stageName = 'Closed Won' AND closeDate = this_month ORDER BY closeDate asc]){
            closed.add(new contract(o));
        }
        for(opportunity o : [select id, name, accountid, account.name, stageName, closeDate,createdDate,category_v3__c, subcategory_v3__c, (Select ID, echosign_dev1__DateSentDate__c FROM echosign_dev1__R00N70000001hM2REAU__r) FROM opportunity where ownerid = :UserInfo.getUserId() AND stageName = 'Contract Sent' order By closeDate asc]){
            outstanding.add(new contract(o));
        }
        for(opportunity o : [select id, name, accountid, account.name, stageName, closeDate,createdDate,category_v3__c, subcategory_v3__c FROM opportunity where ownerid = :UserInfo.getUserId() AND stageName = 'Prospecting' order by createdDate asc]){
            prospecting.add(new contract(o));
        }        
    }
    
}

public class calendar_list{
    public list<my_calendar> tasks {get;set;}
    public list<my_calendar> events {get;set;}    
    public calendar_list(){
        this.tasks = new list<my_calendar>();
        this.events = new list<my_calendar>();
        
        for(task t : [select id, subject, ActivityDate,type from task where ownerid = :UserInfo.getUserId() AND IsClosed !=true  ORDER BY ActivityDate ASC LIMIT 500 ]){
            this.tasks.add(new my_calendar(t));
        }
        for(event e : [select id, subject, EndDateTime, StartDateTime  FROM event where ownerid = :UserInfo.getUserId() ORDER BY StartDateTime DESC LIMIT 500]){
            this.events.add(new my_calendar(e));
        }
    }
}    
public class my_calendar{
    public string subject {get;set;}
    public dateTime start_time {get;set;}
    public dateTime end_time {get;set;}
    public string start_date {get;set;}
    public id salesforce_id {get;set;}
    public string merchant {get;set;}
    public string type {get;set;}
    
    public my_calendar(task t){
        this.subject = t.subject;
        if(t.activityDate!=null)this.start_date = t.ActivityDate.format();
        this.type = t.type;
        this.salesforce_id = t.id;
    }
    public my_calendar(event e){
        this.subject = e.subject;
        this.start_time = e.startDateTime;
        this.end_time = e.endDateTime;
    }
}
@RemoteAction
public static list<event_data> merchant_activity(string theId){
    list<event_data> tasks = new list<event_data>();
    list<task> merchant_tasks = [select id, subject, isclosed, Owner.Name, ActivityDate FROM task WHERE (WhatID = :theid OR WhoID = :theid) ORDER BY ActivityDate DESC LIMIT 10];
    for(task t : merchant_tasks)
        tasks.add(new event_data(t));
    return tasks;   
}    
public class event_data{
    public string ActivityDate {get;set;}
    public string Subject {get;set;}
    public string Name {get;set;}
    public boolean completed {get;set;}
    public event_data(task t){
            this.ActivityDate = t.ActivityDate.format();
            this.Subject = t.Subject;
            this.Name = t.Owner.Name;
            this.completed = t.IsClosed;
        }
}
public class Merchant{
    public Division division {get;set;}
    public Taxonomy taxonomy {get;set;}
    public list<place> places {get;set;}
    public list<deal> deals {get;set;}
    
    public string merchant_satisfaction {get;set;}
    public string research_ranking {get;set;}
    public string name {get;set;}
    public string merchant_permalink {get;set;}
    public id account_id {get;set;}
    public decimal m3_id {get;set;}
    public date last_contacted {get;set;}
    public string last_activity {get;set;}
    public integer num_deals {get;set;}
    public string last_feature {get;set;}
    public decimal account_gp {get;set;}
    public decimal ePPM {get;set;}
    public decimal refund_percent {get;set;}
    public string merchant_manager {get;set;}
    public string g1_status {get;set;}
    public string now_status {get;set;}
    public string scheduler_status {get;set;}
    
    public merchant(lead l){
            this.research_ranking = l.Research_Ranking__c;
            this.name = l.Company;
            this.account_id = l.id;
            this.m3_id = l.M3_Id__c;
            if(l.LastActivityDate!=null)this.last_activity  = l.LastActivityDate.format();
            this.num_deals = 0;
            this.last_feature  = '-';
            this.account_gp = 0;
            this.refund_percent = 0;
            this.taxonomy = new taxonomy(l);
    }
    
    public merchant(){
    }
    
    public merchant(account a){
            if(a.Now_Launch__c!=null)this.now_status='badge-success';
            if(a.Total_GP__c>0 && a.Do_Not_Run_Again__c != true)this.g1_status='badge-success';
            if(a.Do_Not_Run_Again__c==true)this.g1_status='badge-danger';
            if(a.Groupon_Scheduler_Strength__c=='Active')this.scheduler_status='badge-success';
            this.research_ranking = a.Research_Ranking__c;
            this.name = a.name;
            this.merchant_permalink = a.Merchant_Permalink__c;
            this.account_id = a.id;
            this.m3_id = a.M3_Id__c;
            if(a.LastActivityDate!=null)this.last_activity  = a.LastActivityDate.format();
            if(a.Number_of_Features__c!=null)this.num_deals = integer.valueOf(a.Number_of_Features__c);
            if(a.Most_Recent_Feature__c!=null)this.last_feature  = a.Most_Recent_Feature__c.format();
            this.account_gp = a.Total_GP__c;
            this.refund_percent = a.Merchant_Refund_Dollars__c;
            this.taxonomy = new taxonomy(a);
            this.merchant_manager = a.Account_Manager__r.name;
    }
}      
public class division{
        public string name {get;set;}
        public id salesforce_id {get;set;}
        public list<subdivision> subdivisions {get;set;}
        
        public division(division__c d){
                this.name = d.name;
                this.salesforce_id = d.id;
                this.subdivisions = new list<subdivision>();
                for(subdivision__c s : [select id, name, division__c, rank__c from Subdivision__c WHERE division__r.name =:d.name ORDER BY rank__c DESC]){
                    this.subdivisions.add(new subdivision(s));
                }
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
            public List<string> v3_services{get;set;}
            public string v3_attributes{get;set;}
            public taxonomy(lead l){
            string[] servicessplit = new string[]{};
            // Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Category__c, Category_v3__c,  Subcategory__c, Subcategory_v3__c,
                    this.v2_category = l.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = l.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = l.Global_SFDC_Subcategory_2__c; 
                    this.v3_category = l.Category_v3__c;
                    this.v3_subcategory = l.Subcategory_v3__c;
                    if(l.Services_Offered__c!=null){
                        l.Services_Offered__c.replace(' | ','|');
                        for(String s: l.Services_Offered__c.split('\\|')){
                        servicessplit.add(s);
                        }
                     }   
                    this.v3_services = servicessplit ;
                    this.v3_attributes = l.Merchant_Attributes__c;
            }
            
            public taxonomy(opportunity o){
                    this.v2_category = o.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = o.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = o.Global_SFDC_Subcategory_2__c; 
                }
            public taxonomy(account a){
                     string[] servicessplit = new string[]{};

                    this.v2_category = a.Global_SFDC_Category__c; 
                    this.v2_subcategory1 = a.Global_SFDC_Subcategory_1__c;
                    this.v2_subcategory2 = a.Global_SFDC_Subcategory_2__c; 
                    this.v3_category = a.Category_v3__c;
                    this.v3_subcategory = a.Subcategory_v3__c;
                    if( a.Services_Offered__c != null)
                    {
                    a.Services_Offered__c.replace(' | ','|');
                    for(String s: a.Services_Offered__c.split('\\|')){
                    servicessplit.add(s);
                    }
                    }
                    this.v3_services = servicessplit ;
                    this.v3_attributes = a.Merchant_Attributes__c;
                }    
        }
        public class subdivision{
            public string name{get;set;}
            public id salesforce_id {get;set;}
            public id division_id {get;set;}
            public list<string> zip_codes{get;set;}
            public double rank {get;set;}
            public subdivision(subdivision__c s){
                    this.name = s.name;
                    this.salesforce_id = s.id;
                    this.division_id = s.division__c;
                    this.rank=s.rank__c;
                    this.zip_codes = new list<string>();
                    for(zip_code__c z: [select name from Zip_code__c WHERE Subdivision__r.name = :s.name]){
                        this.zip_codes.add(z.name);
                    }
                }
        }
        public class place{
            public string neighborhood{get;set;}
            public decimal lat{get;set;}
            public decimal lng{get;set;}
            public string street1{get;set;}
            public string street2{get;set;}
            public string city{get;set;}
            public string state{get;set;}
            public string postal_code{get;set;}
            public string subdivision{get;set;}

            public place (lead l){
                    this.street1 = l.street;
                    this.city = l.City;
                    this.state = l.State;
                    this.postal_code = l.postalCode;
                    //this.subdivision=m.Subdivision__r.Name;
                }
            
            public place (Merchant_Addresses__c m){
                    this.street1 = m.Street_Line_1__c;
                    this.street2 = m.Street_Line_2__c;
                    this.city = m.City__c;
                    this.state = m.State_Province__c;
                    this.postal_code = m.Zip_Postal_Code__c;
                    this.subdivision=m.Subdivision__r.Name;
                }
        }
        public class deal{
            public string name {get;set;}
            public id salesforce_id {get;set;}
            public Taxonomy taxonomy {get;set;}
            public date launch_at {get;set;}
            public date close_at {get;set;}
            public decimal msat {get;set;}
            public string stage {get;set;}
            public string strength {get;set;}
            
            public deal(opportunity o){
                    this.name = o.name;
                    this.salesforce_id = o.id;
                    this.taxonomy = new taxonomy(o);
                    this.launch_at = o.feature_date__c;
                    this.close_at = o.feature_end_date__c;
                    this.msat = o.Overall_Satisfaction__c;
                    this.stage = o.StageName;
                    this.strength = o.Deal_Strengh__c;
                }
        }    
public class ir{
    public string name {get;set;}
    public string id {get;set;}
    public string what_is_missing {get;set;}
    public string feature_date {get;set;}
    public string details {get;set;}
    public string from_who {get;set;}
    public string writeup_status {get;set;}
    public string deal_strength {get;set;}
    public integer days_to_feature {get;set;}
    public ir(information_request__c i){
        this.name=i.opportunity__r.name;
        this.id=i.id;
        this.deal_strength = i.opportunity__r.deal_strengh__c;
        this.from_who = i.Who_do_you_need_information_from__c;
        this.details = i.Please_describe_the_information_you_need__c;
        this.what_is_missing = i.What_is_Missing__c;
        this.writeup_status = i.Write_Up_Status__c;
        if(i.opportunity__r.feature_date__c!=null){
        if(i.opportunity__r.Pre_Feature_Status__c=='Opt-In'){
                this.days_to_feature = system.today().daysBetween(i.opportunity__r.feature_date__c.addDays(-1));
                this.feature_date = i.opportunity__r.feature_date__c.addDays(-1).format();
            }else{
                this.days_to_feature = system.today().daysBetween(i.opportunity__r.feature_date__c);
                this.feature_date = i.opportunity__r.feature_date__c.format();
                }
            
            }
    }
}        
public class contract{
    public string merchant_name {get;set;}
    public string deal_name {get;set;}
    public string date_sent {get;set;}
    public string stage {get;set;}
    public string close_date {get;set;}
    public string created_date {get;set;}
    public string category {get;set;}
    public string subcategory {get;set;}
    public id salesforce_id {get;set;}
    public integer days_outstanding{get;set;}
    public integer days_since_created {get;set;}
    public id account_id {get;set;}
    
    public contract(opportunity o){
        this.merchant_name = o.account.name;
        this.deal_name = o.name;
        this.date_sent = '';
        this.stage = o.stageName;
        if(o.closeDate!=null){
            this.close_date = o.closeDate.format();
            }
        if(o.createddate!=null){
            this.created_date = date.valueOf(o.createddate).format();
            this.days_since_created = date.valueOf(o.createddate).DaysBetween(system.today());
            }
        this.category= o.Category_v3__c;
        this.subcategory = o.Subcategory_v3__c;
        this.salesforce_id = o.id;
        this.account_id = o.accountid;
        for(echosign_dev1__SIGN_Agreement__c e : o.echosign_dev1__R00N70000001hM2REAU__r){
          if(e.echosign_dev1__DateSentDate__c!=null){
            this.date_sent = e.echosign_dev1__DateSentDate__c.format();
            this.days_outstanding = e.echosign_dev1__DateSentDate__c.daysBetween(system.today());
            }
        }
        
    }
}    
public class stat{
    public string gp_actual {get;set;}
    public string gp_sure_thing {get;set;}
    public string gp_deals_run{get;set;}
    public string gp_run_rate {get;set;}
    public decimal actual_percent_to_goal {get;set;}
    public decimal projected_percent_to_goal {get;set;}
    public string my_deals {get;set;}
    public string my_irs {get;set;}
    public string my_contracts {get;set;}
    public string my_tasks {get;set;}
    public string my_rgi {get;set;}
    
    public string contracts_won {get;set;}
    public string contracts_sent {get;set;}
    public double contract_goal {get;set;}
    public string contracts_new_business {get;set;}
    public decimal contract_percent_to_goal {get;set;}
    public stat(){
        this.gp_deals_run='0';
        this.gp_actual='0';
        this.gp_sure_thing='0';
        this.my_rgi='0';
        this.gp_run_rate='0';
        this.contracts_won = '0';
        this.contract_goal = 0;
        this.contracts_new_business = '0';
        this.contract_percent_to_goal = 0;
        this.my_deals='0';
        this.contracts_sent='0';
        this.my_irs = '0';    
      list<sales_goal__c> goals = [select id, Division__r.name, GP_Goal__c, Contract_Goal__c FROM sales_goal__c WHERE ownerid = :UserInfo.getUserId() and goal_start_date__c = this_month];
      decimal goal =1;
        list<string> divisions = new list<string>();
        for(sales_goal__c g : goals){
            //goal+=g.gp_goal__c;
            divisions.add(g.division__r.name);
            contract_goal += g.Contract_Goal__c;
        } 
     AggregateResult[] ar = [SELECT sum(Total_GP__c) gp, count(id) num_run FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND Total_GP__c >0 AND feature_date__c = this_month AND division__c IN :divisions];
        for(AggregateResult agg :ar){
        gp_actual = string.valueOf(agg.get('gp'));
        if(gp_actual==null)gp_actual='0';
        gp_deals_run = string.valueOf(agg.get('num_run'));
        if(gp_deals_run==null)gp_deals_run='0';
        }   
    AggregateResult[] ar1 = [SELECT count(id) num_st FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND deal_strengh__c ='A Sure Thing' AND feature_date__c = this_month ANd feature_date__c>=:system.today()];
        for(AggregateResult agg :ar1){
        gp_sure_thing = string.valueOf(agg.get('num_st'));
        }
    AggregateResult[] rgi = [SELECT count(id) num_rgi FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND deal_strengh__c ='Rep Getting Info' AND stageName = 'Closed Won'];
        for(AggregateResult agg :rgi){
        my_rgi = string.valueOf(agg.get('num_rgi'));
        }      
    AggregateResult[] ar2 = [SELECT sum(Projected_GP__c) proj FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND feature_date__c = this_month AND division__c IN :divisions AND feature_date__c > :system.today()];
        for(AggregateResult agg :ar2){
        gp_run_rate = string.valueOf(agg.get('proj'));
        if(gp_run_rate==null)gp_run_rate='0';
        gp_run_rate = string.valueOf(decimal.valueOf(gp_run_rate).setScale(0)+decimal.valueOf(gp_actual).setScale(0));
        }
     actual_percent_to_goal = ((decimal.valueOf(gp_actual)/goal)*100).setScale(0);
     projected_percent_to_goal = ((decimal.valueOf(gp_run_rate)/goal)*100).setScale(0);
     AggregateResult[] ar3 = [SELECT count(id) ir FROM Information_request__c WHERE (Opportunity__r.ownerid = :UserInfo.getUserId() OR Opportunity__r.account.Account_Manager__c = :UserInfo.getUserId())  AND Issue_Resolved__c = false AND opportunity__r.feature_date__c > :system.today() AND opportunity__r.stageName = 'Closed Won'];
        for(AggregateResult agg : ar3){
        my_irs=string.valueOf(agg.get('ir'));
        }
        AggregateResult[] ar4 = [SELECT count(id) pipe FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND Feature_date__c >=:system.today() AND stageName = 'Closed Won'];
        for(AggregateResult agg : ar4){
        my_deals=string.valueOf(agg.get('pipe'));
        }
        AggregateResult[] ar5 = [SELECT count(id) tasks FROM Task WHERE ownerid = :UserInfo.getUserId() AND ActivityDate <=:system.today() AND isClosed !=true];
        for(AggregateResult agg : ar5){
        my_tasks=string.valueOf(agg.get('tasks'));
        }
        AggregateResult[] ar6 = [SELECT count(id) contracts FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND stageName = 'Contract Sent'];
        for(AggregateResult agg : ar6){
        my_contracts=string.valueOf(agg.get('contracts'));
        }
        AggregateResult[] ar7 = [SELECT count(id) contracts_won FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId())  AND stageName = 'Closed Won' AND closedate = this_month];
        for(AggregateResult agg : ar7){
        contracts_won=string.valueOf(agg.get('contracts_won'));
        }
        AggregateResult[] ar8 = [SELECT count(id) contracts_won FROM Opportunity WHERE (ownerid = :UserInfo.getUserId() OR account.Account_Manager__c = :UserInfo.getUserId()) AND Feature_or_Refeature__c = 'New Deal' AND closedate = this_month AND stageName ='Closed Won'];
        for(AggregateResult agg : ar8){
        contracts_new_business=string.valueOf(agg.get('contracts_won'));
        }
        if(contracts_won!='' && contract_goal >0)contract_percent_to_goal = (decimal.valueOf(contracts_won)/contract_goal)*100;             
    }
  }
}