@RestResource(urlMapping='/v1.0/pipeline/users/all')
/*Rest wrapper to get user list*/
Global class  PipelineUserRESTController {
/*GET Rest method to retrieve list of users*/
@HttpGet
global static list<string> getPipelineUsers(){
  PipelineAPI API = new PipelineAPI();
  return API.getAllPipelineUsers();
  }



}