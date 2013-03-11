@isTest
public class DealWizardDealTest {

  static DealWizardDeal setup_deal() {
    Opportunity opportunity = DealWizardTestHelper.buildOpportunity(); 
    insert opportunity;

    DealWizardDeal deal = DealWizardTestHelper.buildDealWizardDeal( opportunity );
    return deal;
  }

  static DealWizardDeal setup_approval_deal(){
    User user = DealWizardTestHelper.buildSystemAdminUser();
    insert user;

    Division__c division = DealWizardTestHelper.buildDivision();
    division.City_CEO__c = user.id;
    division.DSM__c = user.id;
    division.Market_Planner__c = user.id;
    insert division;

    Opportunity opportunity = DealWizardTestHelper.buildOpportunity();
    opportunity.User__c = user.id;
    opportunity.Division__c = division.name;
    insert opportunity;

    DealWizardDeal deal = DealWizardTestHelper.buildDealWizardDeal( opportunity );
    return deal;

  }

  static Contact setup_contact(){
    Contact contact = DealWizardTestHelper.buildMerchantContact();
    insert contact;
    return contact;
  }

  static OpportunityContactRole setup_contact_role(String contact_id, String deal_id){
    OpportunityContactRole contact_role = new OpportunityContactRole();
    contact_role.ContactId = contact_id;
    contact_role.OpportunityId = deal_id;
    return contact_role;
  }
  
  static DealWizardDeal provide_option_on_deal( DealWizardDeal deal ) {
    DealWizardDealOption deal_option = DealWizardTestHelper.buildDealOption();

    deal.options.add( deal_option );
    System.assert( !deal.options.isEmpty() );
    return deal;
  }

  static TestMethod void errors_on_an_existing_option_is_initially_empty() {

    DealWizardDeal deal = setup_deal();
    deal = provide_option_on_deal( deal );
    System.assert( deal.options[0].errors.isEmpty() );
  }
  
  //context saving deal contacts
    //duplicate deal contacts
      static testMethod void does_not_save_duplicate_deal_contact(){
        DealWizardDeal deal = setup_deal();
        Contact contact = setup_contact();
        OpportunityContactRole contact_role = setup_contact_role(contact.id, deal.id);

        DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
        List<DealWizardDealContact> empty_list = new List<DealWizardDealContact>();
        deal.deal_contacts = empty_list;

        deal.deal_contacts.add(deal_contact);
        deal.do_upsert();

        System.assertEquals(deal.deal_contacts.size(), 1);

        deal.deal_contacts.add(deal_contact);
        System.assertEquals(deal.deal_contacts.size(), 2);
        deal.do_upsert();

        System.assertEquals(deal.deal_contacts.size(), 1);
      }
  //context #submit_for_approval
    //describe submit for approbal returns true
      static testMethod void returns_true_for_valid_approval_returns_errors_for_invalid_approval() {
        DealWizardDeal deal = setup_approval_deal();
        List<DealWizardError> empty_list = new List<DealWizardError>();

        //first request for approval
        //should be successfull
        DealWizardApprover result = deal.submit_for_approval();

        System.assertEquals( empty_list, result.errors );
        System.assertEquals( true, result.success );

        //second request for approval
        //should be unsuccessfull, since there is already a request in process
        result = deal.submit_for_approval();

        System.assertNotEquals( empty_list, result.errors );
        System.assertEquals( false, result.success );
        }
}