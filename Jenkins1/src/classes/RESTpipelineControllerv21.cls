@RestResource(urlMapping='/v2.1/pipeline/*')
global class RESTpipelineControllerv21 {

@HttpGet
  global static list<PerfectPipelineAPI21.pipeline> getPipeline(RestRequest req, RestResponse res) {
    String division = req.params.get('division');
    string startDate = req.params.get('startDate');
    
    string endDate = req.params.get('endDate');
    startDate = startDate.replaceAll('-','/');
    endDate = endDate.replaceAll('-','/');
    
    date sdate = date.parse(startDate);
    date edate = date.parse(endDate);

    
    PerfectPipelineAPI21 api = new PerfectPipelineAPI21(division,sDate,eDate);
    list<PerfectPipelineAPI21.pipeline> pipe = api.getPipeline(division,sdate ,edate);
    
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

}