@RestResource(urlMapping='/v1.0/deals/locations/*')
global class RESTpipelineController_V4 {

@HttpGet
  global static list<PerfectpipelineAPI_V4.pipeline> getPipeline(RestRequest req, RestResponse res) {
    string startDate = req.params.get('startDate');
    string endDate = req.params.get('endDate');
    string division;
    if(req.params.containsKey('division'))
    {
    division = req.params.get('division');
    }
    else
    {
    division = '';
    }   
    
    startDate = startDate.replaceAll('-','/');
    endDate = endDate.replaceAll('-','/');
    
    startDate = startDate.substring(5,7)+'/'+startDate.substring(8,10)+'/'+startDate.substring(0,4);
    endDate   = endDate.substring(5,7)+'/'+endDate.substring(8,10)+'/'+endDate.substring(0,4);  
    date sdate = date.parse(startDate);
    date edate = date.parse(endDate);

    
    PerfectpipelineAPI_V4 api = new PerfectpipelineAPI_V4(division,sdate,edate);
    list<PerfectpipelineAPI_V4.pipeline> pipe = api.getPipeline();    
    return pipe;   
  }
}