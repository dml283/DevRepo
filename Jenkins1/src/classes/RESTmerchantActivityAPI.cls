@RestResource(urlMapping='/v1.0/merchant/activity')

global class RESTmerchantActivityAPI{

@HttpGET
global static list<event_data> merchant_activity(){
     RestRequest req = RestContext.request;
     string theId = EncodingUtil.urlDecode(req.params.get('salesforce_id'),'UTF-8');

    list<event_data> tasks = new list<event_data>();
    list<task> merchant_tasks = [select id, subject, isclosed, Owner.Name, ActivityDate FROM task WHERE (WhatID = :theid OR WhoID = :theid) ORDER BY ActivityDate DESC LIMIT 10];
    for(task t : merchant_tasks)
        tasks.add(new event_data(t));
    return tasks;   
}    
global class event_data{
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
       
}