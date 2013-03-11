@RestResource(urlMapping='/v1.0/calendar/my')

global class RESTmyCalendarAPI{

@HttpGET
global static calendar_list getMyTasks(){
     calendar_list cl = new calendar_list();
     set<id> whoIds = new set<id>();
     set<id> whatIds = new set<id>();
     list<task> tasks = [select id, subject, status, description, ActivityDate,type, whatid, whoid, accountid from task where ownerid = :UserInfo.getUserId() AND IsClosed !=true AND ActivityDate!=null ORDER BY ActivityDate ASC LIMIT 500];
     for(task t:tasks){
         if(t.whoId!=null)whoIds.add(t.whoid);
         if(t.whatId!=null)whatIds.add(t.whatId);
     }
     map<id,lead> lead_map = new map<id,lead>([select id, company from lead where id in :whoIds]);
     map<id,account> account_map = new map<id,account>([select id, name from account where OwnerID = :UserInfo.getUserId()]);
     map<id,opportunity> oppty_map = new map<id,opportunity>([select id, account.name, accountid from opportunity where id in :whatids]);
     map<id,contact> contact_map = new map<id,contact>([select id, name, AccountId from contact where id in :whoids AND AccountId!=null]);
     for(task t : tasks){
         my_calendar cal = new my_calendar(t);
         if(cal.related_to!=null){
             if(account_map.containsKey(cal.related_to)){
                 cal.merchant = account_map.get(cal.related_to).name;
                 cal.account_id = t.accountid;
             }else if(oppty_map.containsKey(cal.related_to)){
                 cal.merchant = oppty_map.get(cal.related_to).account.name;
                 cal.account_id = t.accountid;
             }else if(contact_map.containsKey(cal.related_to) && account_map.containsKey(contact_map.get(cal.related_to).AccountId)){
                 if(account_map.get(contact_map.get(cal.related_to).AccountId) != null) {
                       cal.merchant = account_map.get(contact_map.get(cal.related_to).AccountId).name;
                 } else {
                    cal.merchant = '';
                 }
                 cal.account_id = t.accountid;
             }  
        }
      cl.tasks.add(cal);   
    }
         return cl;
}
global class calendar_list{
    public list<my_calendar> tasks {get;set;}
    public list<my_calendar> events {get;set;}    
    public calendar_list(){
        this.tasks = new list<my_calendar>();
    }
}    
global class my_calendar{
    public string subject {get;set;}
    public dateTime start_time {get;set;}
    public dateTime end_time {get;set;}
    public string start_date {get;set;}
    public id id {get;set;}
    public string related_to {get;set;}
    public string merchant {get;set;}
    public string type {get;set;}
    public string status {get;set;}
    public string description {get;set;}
    public string account_id {get;set;}
    
    public my_calendar(task t){
        this.subject = t.subject;
        if(t.activityDate!=null)this.start_date = t.ActivityDate.format();
        this.type = t.type;
        this.id = t.id;
        this.status = t.status;
        this.description = t.description;
        if(t.whatId!=null)this.related_to = t.whatid;
        if(t.whoId!=null)this.related_to = t.whoid;
    }
    public my_calendar(event e){
        this.subject = e.subject;
        this.start_time = e.startDateTime;
        this.end_time = e.endDateTime;
    }
}
}