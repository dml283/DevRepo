@RestResource(urlMapping='/v1.0/pipeline/divisions/taxonomy/all')

Global class DivisionTaxonomyRESTController {

@HttpGet
global static list<Division__c>  getDivisions(){
 PipelineAPI API = new PipelineAPI();
  return API.getDivisionTaxonomyMap();
}



}