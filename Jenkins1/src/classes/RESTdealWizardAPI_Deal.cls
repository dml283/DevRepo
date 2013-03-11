@RestResource(urlMapping='/v1.0/wizard/deal')
global class RESTdealWizardAPI_Deal {

  @HttpPost
  global static DealWizardDeal createOrUpdate( DealWizardDeal deal ) {
    deal.do_upsert();
    return deal;
  }
 
  @HttpGet
  global static DealWizardDeal show() {
    RestRequest request = RestContext.request;
    DealWizardDeal deal = new DealWizardDeal();
    String id = '';
    if ( request.params.containsKey('salesforce_id') ) {
      System.debug( request.params.get('salesforce_id') );
      id = request.params.get('salesforce_id');
    }
    deal.id = id;
    deal.load();
    return deal;
  } 

}