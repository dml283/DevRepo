@RestResource(urlMapping='/v1.0/pipeline/divisions/all')

Global class DivisionRESTController {

@HttpGet
global static list<string>  getDivisions(){
  PipelineAPI API = new PipelineAPI();
  return API.getAllDivisions();
}



}