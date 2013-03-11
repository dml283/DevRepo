@RestResource(urlMapping='/v3.0/pipeline/*')
global class RESTpipelineController_V3 {

@HttpGet
  global static list<PerfectpipelineAPI_V3.pipeline> getPipeline(RestRequest req, RestResponse res) {
    string startDate = req.params.get('startDate');
    string endDate   = req.params.get('endDate');
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
    
    date sdate = date.parse(startDate);
    date edate = date.parse(endDate);
  
    PerfectpipelineAPI_V3 api = new PerfectpipelineAPI_V3(division,sDate,eDate);
    list<PerfectpipelineAPI_V3.pipeline> pipe = api.getPipeline();    
    return pipe;   
  }

@HttpPost

    global static PerfectPipeline.Purchase_Order createPO(RestRequest req, RestResponse res,
              string id ,
              string Division ,
              string Subdivision ,
              string TargetFeatureDate ,
              string Category ,
              string Subcategory1 ,
              string Subcategory2 ,
              string PONotes ,
              string MultiAssign ,
              string ExampleDeal1 ,
              string ExampleDeal2 ,
              string DealBuilder ,
              string IdealPrice ,
              string TargetGP ,
              string TargetGMS){
    
        
         PerfectPipeline.Purchase_Order po = new PerfectPipeline.Purchase_Order();
         po.id = id;
         po.Division = Division;
         po.Subdivision = Subdivision;
         po.TargetFeatureDate = TargetFeatureDate;
         po.Category  = Category;
         po.Subcategory1  = Subcategory1 ;
         po.Subcategory2  = Subcategory2 ;
         po.PONotes  = PONotes ;
         po.MultiAssign =  MultiAssign;
         po.ExampleDeal1  = ExampleDeal1 ;
         po.ExampleDeal2  = ExampleDeal2 ;
         po.DealBuilder  =  DealBuilder;
         po.IdealPrice  =  IdealPrice;
         po.TargetGP  =  TargetGP;
         po.TargetGMS  = TargetGMS ;

        PerfectPipeline.Purchase_order new_po = PerfectPipeline.addPO(po);
        return new_po;
    }
@Istest
public static void testme_GET()
{
RestRequest req = new RestRequest();
RestResponse res = new RestResponse();
req.requestURI = '/services/apexrest/v3.0/pipeline?division=chicago&startDate=6-18-2012&endDate=7-18-2012';
req.httpMethod = 'GET';
req.addParameter('division','Chicago');
req.addParameter('startDate','7-10-2012');
req.addParameter('endDate','7-18-2012');
system.debug('#### Request'+ req);
RESTpipelineController_V3.getPipeline(req,res);
}

}