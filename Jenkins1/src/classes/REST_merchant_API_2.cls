@RestResource(urlMapping='/v2.0/merchants')

global class REST_merchant_API_2{
public final static map<string,string> category_map = new map<string,string>{'Beauty / Wellness / Healthcare'=>'icon-wellness', 'Leisure Offers / Activities' =>'icon-leisure', 'Travel' =>'icon-getaways', 'Tickets' =>'icon-grouponlive', 'Food & Drink' =>'icon-restaurants', 'Services' =>'icon-services', 'Shopping' =>'icon-shopping', 'Charity' =>'icon-grassroots'};

@HttpGET
global static list<merchant> get(){
    list<merchant> merchants = new list<merchant>();
    for(account a : database.query(query())){
        merchants.add(new merchant(a));
    }
    return merchants;
    }
global class merchant{
    public string name {get;set;}
    public id id {get;set;}
    public string category {get;set;}
    public string subcategory {get;set;}
    public string rank {get;set;}
    public decimal total_gp {get;set;}
    public decimal refund_rate {get;set;}
    public merchant_manager mm {get;set;}
    public list<merchant_task> tasks {get;set;}
    public list<deal> g1_deals {get;set;}
    public string permalink {get;set;}
    public string website {get;set;}
    public obj scheduler_status {get;set;}
    public obj now_status {get;set;}
    public string services_offered {get;set;}
    public obj rewards_status {get;set;}
    public obj g1_status {get;set;}
    public list<merchant_contact> contacts {get;set;}
    public list<merchant_location> locations {get;set;}
    public list<competitive_feature> competitor_features {get;set;}
    public list<merchant_payment> payments {get;set;}
    global merchant(account a){
        boolean out_of_business;
        this.locations = new list<merchant_location>();
        this.payments = new list<merchant_payment>();
        for(Merchant_Payment__c mp : a.Merchant_Payments__r){
            this.payments.add(new merchant_payment(mp));
        }
        this.competitor_features = new list<competitive_feature>();
        for(social_living__c sl : a.social_living__r){
            this.competitor_features.add(new competitive_feature(sl));
        }
          if(a.Account_Status__c =='Do Not Run - Bankruptcy / Out of Business' || a.Do_Not_Run_Again__c){
            out_of_business = true;
        }else{out_of_business = false;}
        this.name = a.name;
        this.id = a.id;
        this.contacts = new list<merchant_contact>();
        this.category = category_map.get(a.Category_v3__c);
        this.subcategory = a.subcategory_v3__c;
        this.rank = a.Research_Ranking__c;

        this.tasks = new list<merchant_task>();
        for(task t: a.tasks){
            this.tasks.add(new merchant_task(t));
        }
        this.g1_deals = new list<deal>();
        for(opportunity o : a.opportunities){
            this.g1_deals.add(new deal(o));
        }
        this.total_gp = a.Total_GP__c;
        this.refund_rate = a.Total_Refunds__c;
        this.website = a.website;
        this.services_offered = a.Services_Offered__c;
        for(Merchant_Addresses__c ma : a.Merchant_Addresses__r){
             this.locations.add(new merchant_location(ma));
        }
        for(contact c : a.contacts){
            this.contacts.add(new merchant_contact(c));
        }
        this.permalink = a.Merchant_Permalink__c;
        if(a.account_manager__c!=null){
            this.mm = new merchant_manager(a);
        }
        if(a.Rewards_Hand_off__c =='Yes' || a.category_v3__c == 'Food & Drink'){
            this.scheduler_status = new obj('S','badge-single');
        }else if(a.Groupon_Scheduler_Strength__c=='Pending Contact' || a.Groupon_Scheduler_Strength__c==null){
            this.scheduler_status = new obj('S','badge-single badge-danger');
        }else if(a.Groupon_Scheduler_Strength__c=='Contacted' || a.Groupon_Scheduler_Strength__c=='Merchant Unresponsive'){
            this.scheduler_status = new obj('S','badge-single badge-warning');
        }else if(a.Groupon_Scheduler_Strength__c=='In Process'){
            this.scheduler_status = new obj('S','badge-single badge-warning');
        }else if(a.Groupon_Scheduler_Strength__c=='Active'){
            this.scheduler_status = new obj('S','badge-single badge-success');
        }else if(a.Groupon_Scheduler_Strength__c=='Declined'){
            this.scheduler_status = new obj('S','badge-single badge-success');
        }else if(a.Groupon_Scheduler_Strength__c=='Deactivated'){
            this.scheduler_status = new obj('S','badge-single badge-inverse');
        }else{
            this.scheduler_status = new obj('S','badge-single');
        }
        //now status
        if(a.Now_Status__c=='Not Contacted' || a.Now_Status__c ==null){
            this.now_status = new obj('N','badge-single badge-danger');
        }else if(a.Now_Status__c=='Contacted' || a.Now_Status__c=='In Negotiations' || a.now_status__c =='Needs Followup'){
            this.now_status = new obj('N','badge-single badge-warning');
        }else if(a.Now_Status__c=='Closed Won' && a.Now_Merchant_Activity__c == 'Live'){
            this.now_status = new obj('N','badge-single badge-success');
        }else if(a.Now_Status__c=='Closed Won'){
            this.now_status = new obj('N','badge-single badge-info');
        }else if(a.Now_Status__c=='Closed Expired' || a.Now_Status__c=='Self Service Exclusive' || a.Now_Status__c=='Closed Lost'){
            this.now_status = new obj('N','badge-single badge-inverse');
        }else{
            this.now_status = new obj('N','badge-single');
        }
   
        //rewards status
        if(a.Rewards_Offer_Status__c=='Not Contacted' || a.Rewards_Offer_Status__c ==null || a.Rewards_Offer_Status__c=='Paused'){
            this.rewards_status = new obj('R','badge-single badge-danger');
        }else if(a.Rewards_Offer_Status__c=='Contacted' || a.Rewards_Offer_Status__c=='In Negotiations' || a.Rewards_Offer_Status__c=='Contract Sent'){
            this.rewards_status = new obj('R','badge-single badge-caution');
        }else if(a.Rewards_Offer_Status__c=='Closed Lost' || a.Rewards_Offer_Status__c=='Closed Expired' || a.Rewards_Offer_Status__c=='Rejected'){
            this.rewards_status = new obj('R','badge-single badge-inverse');
        }else if(a.Rewards_Offer_Status__c=='Closed Won'){
            this.rewards_status = new obj('R','badge-single badge-info');
        }else if(a.Rewards_Offer_Status__c=='Live'){
            this.rewards_status = new obj('R','badge-single badge-success');
        }else{
            this.rewards_status = new obj('R','badge-single');
        }
        if(a.Re_Feature_Status_REP__c == 'Not Interested in Re-Feature'){
            this.g1_status = new obj('G','badge-single badge-danger');
        }else if(a.Re_Feature_Status_REP__c == 'Interested in Re-Feature'){
            this.g1_status = new obj('G','badge-single badge-success');
        }else if(a.Re_Feature_Status_REP__c == 'Wants Different Deal Terms' || a.Re_Feature_Status_REP__c == 'Waiting on Response/Non-Commital'){
            this.g1_status = new obj('G','badge-single badge-warning');
        }else{
            this.g1_status = new obj('G','badge-single');
        }
    }
}
public class merchant_task{
    public string subject {get;set;}
    public string status {get;set;}
    public string owner {get;set;}
    public string task_date {get;set;}
    public id id {get;set;}
    
    public merchant_task(task t){
        this.subject = t.subject;
        this.status = t.status;
        this.owner = t.owner.name;
        this.id = t.id;
        if(t.activitydate!=null){
            this.task_date = t.activitydate.format();
            }else{
                     this.task_date='';
                 }
    }
}
public class deal{
    public string name {get;set;}
    public string feature_date {get;set;}
    public string stage {get;set;}
    public string division {get;set;}
    public decimal gp {get;set;}
    public decimal gms {get;set;}
    public integer units {get;set;}
    public string sales_rep {get;set;}
    public string permalink {get;set;}
    public string close_date {get;set;}
    
    public deal(opportunity o){
        this.name = o.name;
        if(o.feature_date__c!=null){
            this.feature_date = o.feature_date__c.format();
        }else{
            this.feature_date ='';
        }
        this.stage = o.stageName;
        this.gms = o.Total_GMS__c;
        this.gp = o.Total_GP__c;
        if(o.Total_Units_Sold__c>0)this.units = integer.valueOf(o.Total_Units_Sold__c);
        this.sales_rep = o.owner.name;
        this.division = o.division__c;
        this.permalink=o.permalink__c;
        this.close_date = o.closeDate.format();
    }
}
public class merchant_contact{
    public string name {get;set;}
    public string email {get;set;}
    public string phone {get;set;}
    public string mobile {get;set;}
    public string title {get;set;}
    public id id {get;set;}
    
    public merchant_contact(contact c){
        this.name = c.name;
        this.email = c.email;
        this.phone = c.phone;
        this.mobile = c.MobilePhone;
        this.title = c.title;
        this.id = c.id;
    }
}
public class merchant_location{
    public string street1 {get;set;}
    public string street2 {get;set;}
    public string city {get;set;}
    public string state {get;set;}
    public string country {get;set;}
    public string neighborhood {get;set;}
    public string subdivision {get;set;}
    
    public merchant_location(Merchant_Addresses__c ma){
        this.street1 = ma.Street_Line_1__c;
        this.street2 = ma.Street_Line_2__c;
        this.city = ma.city__c;
        this.state = ma.State_Province__c;
        this.country = ma.Country__c;
        this.neighborhood = ma.neighborhood__c;
        this.subdivision = ma.Subdivision__r.name;
    }
}

public class merchant_manager{
    public string name {get;set;}
    public string phone {get;set;}
    public string email {get;set;}
    public string photo_url {get;set;}
    public merchant_manager(account a){
        this.name = a.Account_Manager__r.name;
        this.phone = a.Account_Manager__r.phone;
        this.email = a.Account_Manager__r.email;
        this.photo_url = a.account_manager__r.SmallPhotoUrl;
    }
}
public class competitive_feature{
    public string name {get;set;}
    public string url {get;set;}
    public string division {get;set;}
    public string feature_date {get;set;}
    public decimal unit_price {get;set;}
    public decimal revenue {get;set;}
    public decimal units_sold {get;set;}
    public string competitor {get;set;}
    
    public competitive_feature(Social_Living__c cf){
        this.name = cf.name;
        this.url = cf.Deal_Link__c;
        this.division = cf.division__c;
        if(cf.Feature_Date__c!=null){
            this.feature_date = cf.Feature_Date__c.format();
        }
        this.revenue = cf.revenue__c;
        this.units_sold = cf.units_sold__c; 
        this.competitor = cf.Provider__c;
        this.unit_price = cf.Deal_Price__c;
    }
}
public class merchant_payment{
    public decimal amount {get;set;}
    public string fx {get;set;}
    public string payment_method {get;set;}
    public string payment_date {get;set;}
    public string confirmation_number {get;set;}
    
    public merchant_payment(Merchant_Payment__c mp){
        this.amount = mp.amount__c;
        this.fx = mp.currency__c;
        this.payment_method = mp.payment_method__c;
        if(mp.Payment_Date__c!=null){
            this.payment_date = mp.Payment_Date__c.format();
        }
        if(mp.ACH_Confirmation_Number__c !=null){
            this.confirmation_number = mp.ACH_Confirmation_Number__c;
        }else if(mp.Check_Number__c!=null){
            this.confirmation_number = mp.Check_Number__c;
        }
    }
}
public static string query(){
    string query = 'SELECT id, name, Sales_Value__c, Services_Offered__c, Category_v3__c, Total_GP__c, Account_Status__c,Re_Feature_Status_REP__c,Do_Not_Run_Again__c,Sales_Value_Demand__c, subcategory_v3__c, Research_Ranking__c, Total_Refund__c, Total_Refunds__c,Account_Manager__r.name,Account_Manager__r.phone, Account_Manager__r.email, account_manager__c, account_manager__r.SmallPhotoUrl, Website, Merchant_Permalink__c,Rewards_Hand_off__c,Groupon_Scheduler_Strength__c, Now_Status__c,Now_Merchant_Activity__c,Rewards_Offer_Status__c,';
    query+=' (SELECT id, subject, Description, ActivityDate, status, owner.name FROM TASKS WHERE activityDate !=null ORDER BY ActivityDate desc  LIMIT 5), ';
    query+=' (SELECT id, name, feature_date__c, stageName, owner.name, Total_GMS__c, Total_GP__c, Total_Units_Sold__c, closeDate, permalink__c, division__c FROM Opportunities where isclosed=true AND feature_date__C !=null ORDER by Feature_date__c desc LIMIT 5),';
    query+=' (SELECT id, name, title, mobilephone, phone, email FROM contacts), ';
    query+=' (SELECT id, Street_Line_1__c,Street_Line_2__c,city__c,State_Province__c,Country__c,neighborhood__c,Subdivision__r.name FROM Merchant_Addresses__r), ';
    query+=' (SELECT id, name, Deal_Link__c, division__c, Feature_Date__c, revenue__c, units_sold__c, Provider__c, Deal_Price__c FROM social_living__r WHERE Provider__c != \'nopuorG\' AND Provider__c != \'nopuorG Getaways\' AND Provider__c != \'nopuorG Goods\' ORDER BY Feature_Date__c DESC), ';
    query+=' (SELECT id,amount__c,currency__c,payment_method__c,Payment_Date__c,ACH_Confirmation_Number__c,Check_Number__c FROM Merchant_Payments__r ORDER BY Payment_Date__c DESC)';
    query+=' FROM ACCOUNT ';
    query+=' WHERE ownerid = \''+UserInfo.getUserId()+'\'';
    return query;
}  
public class obj{
    public string value {get;set;}
    public string css {get;set;}
    public string subject {get;set;}
    public obj(string value){
        this.value = value;
        this.css='';
        this.subject='';
    }
     public obj(string value, string subject, string css){
        this.value = value;
        this.css=css;
        this.subject=subject;
    }
    public obj(string value, string css){
        this.value = value;
        this.css=css;
        this.subject='';
    }
    public obj(string value, decimal order){
        this.value = value;
        this.subject='';
    }
    public obj(){}
}       
}