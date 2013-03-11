@RestResource(urlMapping='/v1.0/task/*')

global class REST_task_API {

@HttpGET
global static Task get() {
    RestRequest req = RestContext.request;
    Task T = new Task();
    if(req.params.containsKey('id')){
        T = database.query(get_task_query(req.params.get('id')));
    }
    return T;
}
@HttpPOST
global static Task post(Task Task){
        try{
            database.upsert(task);
           }catch(exception e){system.debug(e);}
        return task;
}
private static string get_task_query(string id){
        return 'select ID, subject, status, description, whatid, ActivityDate, CallDisposition , Type, Merchant_Disposition__c FROM task where id = \''+id+'\' LIMIT 1';
}
private static testmethod void testTaskAPI(){
    string query = REST_task_API.get_task_query('');
    Task t = new Task();
    RestREquest req = new RestRequest();
    RestResponse res = new RestResponse();
    RestContext.request = req;
    RestContext.response = res;
    Task Sample_get = REST_task_API.get();
    Task Sample_post = REST_task_API.post(t);
    
}
}