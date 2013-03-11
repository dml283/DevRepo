@RestResource(urlMapping='/v1.0/pipeline/task')

global class TaskRESTController{
@HttpPost
    global static void createTask(string TaskBody, string TheId, string OwnerID, string RType){
        PerfectPipeline.createNewTask(TaskBody,TheId,OwnerID,RType);
    }
}