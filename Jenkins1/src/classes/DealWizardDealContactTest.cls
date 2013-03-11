@isTest
public class DealWizardDealContactTest{
  static Opportunity setupOpportunity(){
    Opportunity deal = DealWizardTestHelper.buildOpportunity();
    insert deal;
    return deal;
  }

  static Account setupMerchant() {
    Account merchant = DealWizardTestHelper.buildAccount();
    insert merchant;
    return merchant;
  }

  static Contact setupMerchantContact(Account merchant){
  	Contact merchant_contact = DealWizardTestHelper.buildMerchantContact();
  	merchant_contact.Account = merchant;
  	insert merchant_contact;
  	return merchant_contact;
  }

  static DealWizardDealContact setupDealWizardDealContact(String contact_id, String opportunity_id){
  	OpportunityContactRole contact_role = DealWizardTestHelper.buildOpportunityContactRole(contact_id, opportunity_id);
  	DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
  	return deal_contact.save();
  }


  //context #exists
  static testMethod void returns_false_for_an_object_with_null_id(){
    Account merchant = setupMerchant();
    Contact merchant_contact = setupMerchantContact(merchant);
    Opportunity opportunity = setupOpportunity();
    OpportunityContactRole contact_role = DealWizardTestHelper.buildOpportunityContactRole(merchant_contact.id, opportunity.id);
    DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
    System.assertEquals(false, deal_contact.exists());
    System.assertEquals( null, deal_contact.id );
  }

  static testMethod void returns_true_for_an_object_with_an_id() {
    Account merchant = setupMerchant();
    Contact merchant_contact = setupMerchantContact(merchant);
    Opportunity opportunity = setupOpportunity();
    OpportunityContactRole contact_role = DealWizardTestHelper.buildOpportunityContactRole(merchant_contact.id, opportunity.id);

    DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
    DealWizardDealContact saved_contact = deal_contact.save();

    System.assertEquals(true, saved_contact.exists());
    System.assertNotEquals(null, saved_contact.id);
  }


	//context #creates new deal contact
  static testMethod void returns_saved_object_with_no_errors_on_succesfull_save() {
  	Account merchant = setupMerchant();
  	Contact merchant_contact = setupMerchantContact(merchant);
  	Opportunity opportunity = setupOpportunity();
  	OpportunityContactRole contact_role = DealWizardTestHelper.buildOpportunityContactRole(merchant_contact.id, opportunity.id);

  	DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
		DealWizardDealContact saved_contact = deal_contact.save();

		System.assertEquals( true, saved_contact.errors.isEmpty() );
		System.assertNotEquals( null, saved_contact.id );
	}

  static testMethod void returns_saved_object_with_no_errors_on_succesfull_save_with_merchant_contact_attributes() {
  	Account merchant = setupMerchant();
  	Contact merchant_contact = setupMerchantContact(merchant);
  	merchant_contact.Best_Contact_Time_of_Day__c = 'Late Evening';
  	merchant_contact.Best_Contact_Method__c = 'Phone';
  	update merchant_contact;
  	Opportunity opportunity = setupOpportunity();
  	OpportunityContactRole contact_role = DealWizardTestHelper.buildOpportunityContactRole(merchant_contact.id, opportunity.id);

  	DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
		DealWizardDealContact saved_contact = deal_contact.save();

		System.assertEquals( true, saved_contact.errors.isEmpty() );
		System.assertNotEquals( null, saved_contact.id );
		System.assertEquals( 'Phone', saved_contact.best_contact_method );
	}

  static testMethod void returns_unsaved_object_with_errors_on_unsuccesfull_save() {
  	Account merchant = setupMerchant();
  	Contact merchant_contact = setupMerchantContact(merchant);
  	Opportunity opportunity = setupOpportunity();
  	OpportunityContactRole contact_role = DealWizardTestHelper.buildOpportunityContactRole(merchant_contact.id, null);

  	DealWizardDealContact deal_contact = new DealWizardDealContact(contact_role);
		DealWizardDealContact saved_contact = deal_contact.save();

		System.assertEquals( false, saved_contact.errors.isEmpty() );
		System.assertEquals( null, saved_contact.id );
	}

	//context #updates existing deal contact
  static testMethod void returns_updated_object_with_no_errors_on_succesfull_update() {
  	Account merchant = setupMerchant();
  	Contact merchant_contact = setupMerchantContact(merchant);
  	Opportunity opportunity = setupOpportunity();
  	DealWizardDealContact deal_contact = setupDealWizardDealContact(merchant_contact.id, opportunity.id);
  	deal_contact.role = 'AM Prep Role';
  	DealWizardDealContact updated_contact = deal_contact.update_contact();

		System.assertEquals( true, updated_contact.errors.isEmpty() );
		System.assertEquals( 'AM Prep Role', updated_contact.role );
	}

  static testMethod void returns_object_with_errors_on_unsuccesfull_update() {
  	Account merchant = setupMerchant();
  	Contact merchant_contact = setupMerchantContact(merchant);
  	Opportunity opportunity = setupOpportunity();
  	DealWizardDealContact deal_contact = setupDealWizardDealContact(merchant_contact.id, opportunity.id);
  	deal_contact.role = 'AM Prep Role';
    do {deal_contact.role += deal_contact.role;} while (deal_contact.role.length() < 100);
  	DealWizardDealContact updated_contact = deal_contact.update_contact();

		System.assertEquals( false, updated_contact.errors.isEmpty() );
	}
}