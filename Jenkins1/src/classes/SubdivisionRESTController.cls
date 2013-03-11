@RestResource(urlMapping='/v1.0/pipeline/subdivisions')

Global class SubdivisionRESTController {

@HttpGet
    global static list<string>  getSubDivisions(){
      RestRequest req = RestContext.request;
      PipelineAPI API = new PipelineAPI();
      return API.getSubdivisions(req.params.get('division'));
    }

}