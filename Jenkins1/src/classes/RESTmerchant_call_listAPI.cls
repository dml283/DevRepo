@RestResource(urlMapping='/v1.0/merchants/call_list')

global class RESTmerchant_call_listAPI{
public final static map<string,string> category_map = new map<string,string>{'Beauty / Wellness / Healthcare'=>'icon-wellness', 'Leisure Offers / Activities' =>'icon-leisure', 'Travel' =>'icon-getaways', 'Tickets' =>'icon-grouponlive', 'Food & Drink' =>'icon-restaurants', 'Services' =>'icon-services', 'Shopping' =>'icon-shopping', 'Charity' =>'icon-grassroots'};

@HttpGET
global static list<call_priority> get(){
    list<call_priority> merchants = RESTmerchant_call_listAPI.get_call_priorities();
    return merchants;
}

global static list<call_priority> get_call_priorities(){
    list<call_priority> call_list = add_merchants();
    
    return call_list;
}
global class call_priority implements Comparable{
    public Merchant merchant {get;set;}
    public Priority priority {get;set;}
    public Activity activity {get;set;}
    public call_priority(account a){
        this.merchant = new Merchant(a);
        this.priority = new Priority(a);
    }
    
    // Sort this object by Call List Priority.
    global integer compareTo(Object compareTo) {
        call_priority compareToCallPriority = (call_priority)compareTo;
        if(decimal.valueOf(priority.call_list_priority) == decimal.valueOf(compareToCallPriority.priority.call_list_priority)) return 0;
        else if(decimal.valueOf(priority.call_list_priority) > decimal.valueOf(compareToCallPriority.priority.call_list_priority)) return 1;
        else return -1;
    }
}
public static list<call_priority> add_merchants(){
    list<call_priority> call_list = new list<call_priority>();
    map<id,list<task>> task_map = get_task_map();
    system.debug(task_map);
    for(account a : database.query(get_merchants_account())){
    if(a.Quantum_Leads__r.size()>0 && a.Quantum_Leads__r[0].Call_List_Priority__c !=null){
            list<task> tasks = new list<task>();
            call_priority cp = new call_priority(a);
            if(task_map.containsKey(a.id)){
                tasks.addAll(task_map.get(a.id));
            }
            cp.activity = new Activity(tasks);
            if(a.Account_Status__c == 'Merchant Research Flag'){
                //cp.activity.completed=true;
            }
            call_list.add(cp);
        }
    }
    call_list.sort();
    return call_list;    
}    
public class priority{
    public decimal sales_value {get;set;}
    public decimal sales_value_demand {get;set;}
    public list<string> sales_value_reasons {get;set;}
    public string call_list_priority {get;set;}
    
    public priority(account a){
        if (a.Quantum_Leads__r.size() > 0) {
            this.sales_value = a.Quantum_Leads__r[0].Sales_Value__c;
            if(this.sales_value !=null){
                this.sales_value = this.sales_value.setScale(0);
            }
            this.sales_value_demand = a.Quantum_Leads__r[0].Sales_Value_Demand__c;
            if(a.Quantum_Leads__r[0].Sales_Value_Reasons__c!=null){
                this.sales_value_reasons = a.Quantum_Leads__r[0].Sales_Value_Reasons__c.split('\\|');
            }else{
                this.sales_value_reasons = new list<string>{'Reason'};
            }
            this.call_list_priority = a.Quantum_Leads__r[0].Call_List_Priority__c;
        }
    }    
}
public class merchant{
    public string category_name {get;set;}
    public string category_css {get;set;}
    public string deassignment_warning {get;set;}
    public string id {get;set;}
    public string star {get;set;}
    public string last_feature {get;set;}
    public boolean has_featured {get;set;}
    public boolean has_competitors {get;set;}
    public string status {get;set;}
    public string status_reason {get;set;}
    public string name {get;set;}
    public string website {get;set;}
    public string permalink {get;set;}
    public boolean recently_assigned {get;set;}
    public String safe_name {get;set;}
    public merchant(account a){
        this.id = a.id;
        this.website = a.website;
        this.permalink = a.merchant_permalink__c;
        this.status = a.Result_of_Merchant_Survey__c;
        this.status_reason = a.Account_Status__c;
        this.name = a.name;
        this.safe_name = String.escapeSingleQuotes(a.name);
        if(a.Deassignment_Warning__c!=null){
            this.deassignment_warning = a.Deassignment_Warning__c;
        }
        if(a.Competitor_Features__c!=null && a.Competitor_Features__c > 0){
            this.has_competitors=true;
        }else{
            this.has_competitors=false;
        }
        if(a.Days_Owned__c >3){
            this.recently_assigned = false;
        }else{
            this.recently_assigned = true;
        }
        if(a.Most_Recent_Feature__c!=null){
            this.has_featured=true;
            this.last_feature=a.Most_Recent_Feature__c.format();
        }else{
            this.has_featured=false;
        }
        this.category_name = a.Category_v3__c;
        if(category_map.containsKey(a.Category_v3__c)){
                this.category_css = category_map.get(a.Category_v3__c);
            }else{
                this.category_css ='icon-restaurants';
            }            
        }
}
public class activity{
    public string last_activity {get;set;}
    public string next_activity {get;set;}
    public id next_activity_id {get;set;}
    public string due {get;set;}
    public string last_activity_date {get;set;}
    public string next_activity_date {get;set;}
    public list<merchant_task> tasks {get;set;}
    public boolean completed {get;set;}
    public boolean display_future_task {get;set;}
    public string text_color {get;set;}
    public activity(list<task> tasks){
        this.completed = false;
        this.display_future_task = true;
        this.tasks = new list<merchant_task>();
        date max_date = system.today().addDays(30);
        date min_date = system.today().addDays(-365);
        for(task t : tasks){
            this.tasks.add(new merchant_task(t));
            if(t.IsClosed){
                if(t.activityDate > min_date && t.activityDate <=  system.today()){
                    min_date = t.activityDate;
                    this.last_activity = t.subject;
                    if(t.activityDate!=null){this.last_activity_date = t.activityDate.format();}
                } 
            }else{
                if(t.activityDate < max_date){
                    max_date = t.activityDate;
                    this.next_activity = t.subject;
                    this.next_activity_id = t.id;
                    this.next_activity_date = t.activityDate.format();
                    if(t.activityDate ==  system.today()){
                        this.due = 'Due: Today';
                        this.text_color = '#00CC00';
                        this.display_future_task = false;
                    }else if(t.activityDate ==  system.today().addDays(1)){
                        this.due = 'Due: Tomorrow';
                        this.display_future_task = true;
                    }else if(t.activityDate <  system.today()){
                        this.text_color = '#FF0000';
                        this.due = 'Due: '+t.activityDate.format();
                        this.display_future_task = false;
                    }else{
                        this.due = 'Due: '+t.activityDate.format();
                      }
            }
        }
      }
        if(display_future_task && (last_activity_date!=null && date.parse(last_activity_date) == system.today() || last_activity_date!=null && date.parse(last_activity_date) == system.today().addDays(-1) || (due !='Due: Today' && due!=null) ) ){
            this.completed = true;
        }
    }
    public activity(){}
}
public static map<id,list<task>> get_task_map(){
    date upperQueryBound = System.Today().addDays(60);
    map<id,list<task>> task_map = new map<id,list<task>>();
    list<task> tasks = database.query(get_task_query());
    list<task> tsk;
    for(task t : tasks){
        if(task_map.containsKey(t.accountid)){
            tsk = task_map.get(t.accountid);
            if(tsk.size()<=5){
                tsk.add(t);
                task_map.put(t.accountid,tsk);
            }
        }else{
            tsk = new list<task>();
            tsk.add(t);
            task_map.put(t.accountid,tsk);
        }
    }
    system.debug(JSON.Serialize(task_map));
    return task_map;
}

public static string get_task_query(){
    string query = 'SELECT id, subject, status, Description, activityDate, isclosed, ownerid, owner.name,accountid from Task WHERE accountid IN (select id from account WHERE ownerid = \''+UserInfo.getUserId()+'\') AND ownerid = \''+UserInfo.getUserId()+'\' AND ActivityDate !=null AND ActivityDate < :upperQueryBound ORDER BY activityDate desc LIMIT 1500';
    return query;
}

public static string get_merchants_account(){
    string query = 'SELECT id, name, Category_v3__c, Days_Owned__c, Deassignment_Warning__c, Result_of_Merchant_Survey__c, Account_Status__c, website, merchant_permalink__c, Competitor_Features__c,  Most_Recent_Feature__c,';
    query+=' (SELECT Sales_Value__c, Sales_Value_Demand__c, Sales_Value_Reasons__c, Call_List_Priority__c FROM Quantum_Leads__r)';
    query+=' FROM Account ';
    query+=' WHERE ownerid = \''+UserInfo.getUserId()+'\' ';
    return query;
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

}