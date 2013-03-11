@isTest
public class RESTdealWizardAPI_DealTest {

  static DealWizardDeal setup() {
    // Given an opportunity
    Opportunity opportunity = DealWizardTestHelper.buildOpportunity(); 
    insert opportunity;

    // Provide POST params as a basic DealWizardDeal
    return DealWizardTestHelper.buildDealWizardDeal( opportunity );
  }

  static testMethod void testDealPOSTReturnsDealHavingNonNullIdWhenGivenValidRequest() {
    DealWizardDeal postedDeal = setup();
    DealWizardDeal returnedDeal = null;

    // call the REST controller method
    returnedDeal = RESTdealWizardAPI_Deal.createOrUpdate( postedDeal );

    // assertion
    System.assertNotEquals( null, returnedDeal.id );
  }

}