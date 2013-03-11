global class DealWizardCompetitorDeal {

  public Date feature_date {get; set;}
  public Date expiration_date {get; set;}
  public Decimal units_sold {get; set;}
  public DealWizardCompetitorDeal(){}

  public List<Map<String, String>> fetch_competitor_deals_for(String merchant_id, String division_name) {
  	List<Social_Living__c> competitor_deals_sobjects = get_sobjects(merchant_id, division_name);
  	List<Map<String, String>> competitor_deals = new List<Map<String, String>>();
 
  	for (Social_Living__c competitor_deal: competitor_deals_sobjects) {
  		Map<String, String> deal_map = new Map<String, String>{
  		  'feature_date'    => String.valueOf(competitor_deal.Feature_Date__c),
  		  'expiration_date' => String.valueOf(competitor_deal.Competitors_Deal_Expiration_Date__c),
  		  'units_sold'      => String.valueOf(competitor_deal.Units_Sold__c)
      };
      competitor_deals.add(deal_map);
  	}
 
  	return competitor_deals;
  }

  static List<Social_Living__c> get_sobjects(String merchant_id, String division_name) {
    String groupon_name = 'Nopuorg';

    if ( division_name == '' ){
      return [SELECT Competitors_Deal_Expiration_Date__c,Feature_Date__c,Units_Sold__c FROM Social_Living__c WHERE AccountName__c = :merchant_id AND Competitors_Deal_Expiration_Date__c > TODAY AND Provider__c != :groupon_name];
		} else {
      return [SELECT Competitors_Deal_Expiration_Date__c,Feature_Date__c,Units_Sold__c FROM Social_Living__c WHERE AccountName__c = :merchant_id AND Competitors_Deal_Expiration_Date__c > TODAY AND Division__c = :division_name AND Provider__c != :groupon_name];
		}
  }
}