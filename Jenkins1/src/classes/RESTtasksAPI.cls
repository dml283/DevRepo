@RestResource(urlMapping='/v1.0/tasks')



global class RESTtasksAPI {

@HttpGET

global static list<merchant_task> getTasks(){

string merchantId = RestContext.request.params.get('id');

list<merchant_task> tasks = new list<merchant_task>();

for(Task task:Database.query(get_task_query() + '\'' + merchantId + '\' AND ActivityDate!=null AND Owner.id = \''+ UserInfo.getUserId() +'\' order by activityDate desc LIMIT 5 ')){

tasks.add(new merchant_task(task));

}

return tasks;

}

 

global class merchant_task{

    public string subject {get;set;}

    public string description {get;set;}

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

        this.description = (t.description != null) ? t.description : '';

    }

}


public static string get_task_query(){

    string query = 'SELECT id, subject, toLabel(status), Description, activityDate, isclosed, ownerid, owner.name, accountid from Task WHERE accountid = ';

    return query;

}



}