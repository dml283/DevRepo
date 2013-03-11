@isTest
public class DealWizardRESTCompetitorDealsTest {

  // Test data setup methods
    static Account setupMerchant() {
      //Given an account
      Account merchant = DealWizardTestHelper.buildAccount();
      insert merchant;

      //Return merchant because we will need its id
      return merchant;
    }

    static Social_Living__c setupCompetitorDeal(Id merchant_id, decimal chicago_units_sold, decimal moscow_units_sold) {
      // Given competitor deals
      Social_Living__c competitor_chicago_deal = DealWizardTestHelper.buildCompetitorDeal(merchant_id, 'Chicago');
      competitor_chicago_deal.Units_Sold__c = chicago_units_sold;
      insert competitor_chicago_deal;

      Social_Living__c competitor_moscow_deal = DealWizardTestHelper.buildCompetitorDeal(merchant_id, 'Moscow');
      competitor_moscow_deal.Units_Sold__c = moscow_units_sold;
      insert competitor_moscow_deal;

      // return created competitor deal
      return competitor_chicago_deal;
    }

    static Social_Living__c setupGrouponCompetitorDeal(Id merchant_id, decimal groupon_units_sold) {
      Social_Living__c groupon_chicago_deal = DealWizardTestHelper.buildCompetitorDeal(merchant_id, 'Chicago');
      groupon_chicago_deal.Provider__c = 'Nopuorg';
      groupon_chicago_deal.Units_Sold__c = groupon_units_sold;
      insert groupon_chicago_deal;

      return groupon_chicago_deal;
    }

    static Opportunity setupMerchantDeal(Id merchant_id) {
      Opportunity merchant_chicago_deal = DealWizardTestHelper.buildOpportunity();
      merchant_chicago_deal.AccountId = merchant_id;
      Date today_date = Date.today();
      merchant_chicago_deal.Groupon_Expiration_Date__c = today_date.addYears(3);
      merchant_chicago_deal.Feature_Date__c = today_date;
      merchant_chicago_deal.Expiration_Type__c = 'Fixed';

      insert merchant_chicago_deal;

      return merchant_chicago_deal;
    }

  //context '#merchant_deals'
    //describe competitor deals endpoint return merchant's deals
      static testMethod void returns_merchant_deals_by_id() {
      Account merchant = setupMerchant();
      Opportunity merchant_deal = setupMerchantDeal(merchant.id);
      System.RestContext.request = new RestRequest();
      RestContext.request.params.put('salesforce_id', merchant.id);
      Date today_date = Date.today();

      // call the REST controller method
      List<Map<String, String>> returnedCompetitorDeal = DealWizardRESTCompetitorDeals.show();

      List<Map<String, String>> expectation = new List<Map<String, String>>();
      Map<String, String> expectation_map = new Map<String, String>{
        'expiration_date' => String.valueOf(today_date.addYears(3)),
        'feature_date'    => String.valueOf(today_date),
        'units_sold'      => '0'
      };
      expectation.add( expectation_map );

      System.assertEquals( expectation, returnedCompetitorDeal );
    }

  //context '#competitor deals'
    //describe competitor deals endpoint returns competitor deals

      static testMethod void returns_competitor_deals_by_id_and_division() {
        Account merchant = setupMerchant();
        Social_Living__c existingCompetitorDeal = setupCompetitorDeal(merchant.id, 61, 16);
        System.RestContext.request = new RestRequest();
        RestContext.request.params.put('salesforce_id', merchant.id);
        RestContext.request.params.put('division', 'Chicago');

        // call the REST controller method
        List<Map<String, String>> returnedCompetitorDeal = DealWizardRESTCompetitorDeals.show();

        // assertion
        List<Map<String, String>> expectation = new List<Map<String, String>>();
        Map<String, String> expectation_map = new Map<String, String>{
          'expiration_date' => '2014-09-02',
          'feature_date'    => '2012-09-02',
          'units_sold'      => '61'
        };
        expectation.add( expectation_map );

        System.assertEquals( expectation, returnedCompetitorDeal );
      }

      static testMethod void does_not_return_nopourg_deals() {
        Account merchant = setupMerchant();
        Social_Living__c nopuorg_deal = setupGrouponCompetitorDeal(merchant.id, 83);
        System.RestContext.request = new RestRequest();
        RestContext.request.params.put('salesforce_id', merchant.id);
        RestContext.request.params.put('division', 'Chicago');

        // call the REST controller method
        List<Map<String, String>> returnedCompetitorDeal = DealWizardRESTCompetitorDeals.show();

        // assertion
        List<Map<String, String>> expectation = new List<Map<String, String>>();
        System.assertEquals( expectation, returnedCompetitorDeal );
      }

      static testMethod void returns_competitor_deals_across_all_divisions_by_id_only() {
        Account merchant = setupMerchant();
        Social_Living__c existingCompetitorDeal = setupCompetitorDeal(merchant.id, 98, 89);
        System.RestContext.request = new RestRequest();
        RestContext.request.params.put('salesforce_id', merchant.id);

        // call the REST controller method
        List<Map<String, String>> returnedCompetitorDeal = DealWizardRESTCompetitorDeals.show();

        // assertion
        List<Map<String, String>> expectation = new List<Map<String, String>>();
        Map<String, String> expectation_map1 = new Map<String, String>{
          'expiration_date' => '2014-09-02',
          'feature_date'    => '2012-09-02',
          'units_sold'      => '98'
        };
        Map<String, String> expectation_map2 = new Map<String, String>{
          'expiration_date' => '2014-09-02',
          'feature_date'    => '2012-09-02',
          'units_sold'      => '89'
        };
        expectation.add( expectation_map1 );
        expectation.add( expectation_map2 );

        System.assertEquals( expectation, returnedCompetitorDeal );
      }

      static testMethod void does_not_return_deals_in_other_divisions() {
        Account merchant = setupMerchant();
        Social_Living__c existingCompetitorDeal = setupCompetitorDeal(merchant.id, 124, 421);
        System.RestContext.request = new RestRequest();
        RestContext.request.params.put('salesforce_id', merchant.id);
        RestContext.request.params.put('division', 'Cairo');

        // call the REST controller method
        List<Map<String, String>> returnedCompetitorDeal = DealWizardRESTCompetitorDeals.show();

        // assertion
        List<Map<String, String>> expectation = new List<Map<String, String>>();
        System.assertEquals( expectation, returnedCompetitorDeal );
      }

      static testMethod void does_not_return_deals_when_not_given_merchant_id() {
        // call the REST controller method
            System.RestContext.request = new RestRequest();
        List<Map<String, String>> returnedCompetitorDeal = DealWizardRESTCompetitorDeals.show();

        // assertion
        List<Map<String, String>> expectation = new List<Map<String, String>>();
        System.assertEquals( expectation, returnedCompetitorDeal );
      }
}