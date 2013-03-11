global class DealWizardMerchantDeal {

  public Date feature_date {get; set;}
  public String expiration_date {get; set;}
  public Decimal units_sold {get; set;}
  public DealWizardMerchantDeal(){}

  public List<Map<String, String>> fetch_merchant_deals_for(String merchant_id, String division_name) {
  	List<Opportunity> merchant_deals_sobjects = get_sobjects(merchant_id, division_name);

  	List<Map<String, String>> merchant_deals = new List<Map<String, String>>();
 
  	for (Opportunity merchant_deal: merchant_deals_sobjects) {
  		Map<String, String> deal_map = new Map<String, String>{
  			'feature_date'     => String.valueOf(merchant_deal.Feature_Date__c),
  			'expiration_date'  => String.valueOf(merchant_deal.Groupon_Expiration_Date__c),
  			'units_sold'       => String.valueOf(merchant_deal.Total_Units_Sold__c)
  		};
  		merchant_deals.add(deal_map);
  	}
 
  	return merchant_deals;
  }

  static List<Opportunity> get_sobjects(string merchant_id, string division_name) {
    if ( division_name == '' ){
      return [SELECT Groupon_Expiration_Date__c,Feature_Date__c,Total_Units_Sold__c FROM Opportunity WHERE AccountId = :merchant_id AND Groupon_Expiration_Date__c > TODAY];
		} else {
      return [SELECT Groupon_Expiration_Date__c,Feature_Date__c,Total_Units_Sold__c FROM Opportunity WHERE AccountId = :merchant_id AND Groupon_Expiration_Date__c > TODAY AND Division__c = :division_name];
		}
  }
}