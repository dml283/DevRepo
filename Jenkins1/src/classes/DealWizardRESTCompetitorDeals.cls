@RestResource(urlMapping='/v1.0/wizard/merchant/competitor_deals')
global class DealWizardRESTCompetitorDeals {

  @HttpGet
  global static List<Map<String, String>> show() {
    RestRequest request = RestContext.request;
    String id = load_merchant_id(request.params);
    String division_name = load_division_name(request.params);

    if ( id == null || id == ''){
      return new List<Map<String, String>>();
    } else {
      return get_competitor_and_merchant_deals_json(id, division_name);
    }
  }

  private static List<Map<String, String>> get_competitor_and_merchant_deals_json(String id, String division_name) {
    DealWizardCompetitorDeal competitor_deal = new DealWizardCompetitorDeal();
    DealWizardMerchantDeal merchant_deal = new DealWizardMerchantDeal();
    List<Map<String, String>> competitor_deals =  competitor_deal.fetch_competitor_deals_for(id, division_name);
    List<Map<String, String>> merchant_deals =  merchant_deal.fetch_merchant_deals_for(id, division_name);

    List<Map<String, String>> combined_deals = new List<Map<String, String>>();

    combined_deals.addAll(competitor_deals);
    combined_deals.addAll(merchant_deals);


    return combined_deals;
  }

  private static String load_merchant_id(Map<String,String> request_params) {
    if ( request_params.containsKey('salesforce_id') ) {
      return request_params.get('salesforce_id');
    } else {
      return '';
    }
  }

  private static String load_division_name(Map<String,String> request_params) {
    if ( request_params.containsKey('division') ) {
      return request_params.get('division');
    } else {
      return '';
    }
  }
}