@RestResource(urlMapping='/v1.0/sales_value/demand/')

global class RESTSalesValueDemandController{

@HttpGet
global static  Map<string,List<SalesValueDemandAPI.Deal>> get() {

    RestRequest req = RestContext.request;
    string req_date = req.params.get('scheduled_after');
    string req_start_date = req.params.get('start_date');
    Date closed_after = date.valueOf(req_date);
    Datetime start_date = Datetime.valueOf(req_start_date);
    Integer query_limit = integer.valueof(req.params.get('query_limit'));
    String division = req.params.get('division');
    
    System.debug('New Request for Inventory');
    System.debug(req_start_date);
    
    SalesValueDemandAPI svdapi = new SalesValueDemandAPI();
     
    List <SalesValueDemandAPI.Deal> closedDeals = new List<SalesValueDemandAPI.Deal>();
        
    closedDeals = svdapi.findDemand(closed_after, division, query_limit, start_date);
    Map<string,List<SalesValueDemandAPI.Deal>> deals = new Map<string,List<SalesValueDemandAPI.Deal>>();
    
    deals.put('deals',closedDeals);
    
    return deals;
  
  }
  
@isTest 
static void testGet(){

  RestContext.request = new RestRequest();
  RestContext.request.httpMethod = 'GET';
  RestContext.request.addParameter('scheduled_after', '2012-08-25');
  RestContext.request.addParameter('start_date', '2012-08-25 00:00:00');
  RestContext.request.addParameter('query_limit', '10');
  RestContext.request.addParameter('division', 'cleveland');
  Map<string,List<SalesValueDemandAPI.Deal>> dealList = new  Map<string,List<SalesValueDemandAPI.Deal>>();
  // get(); 
  System.assert(dealList != null);
  
}
  

}