public virtual class DealWizardTestHelper {

  public static User buildSystemAdminUser() {
    Profile p = [select id from profile where name='System Administrator'];
    User user = new User(
        alias = 'tstsysad',
        email='testsysadmin@groupon.com',
        emailencodingkey='UTF-8',
        lastname='Testuser',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = p.Id,
        timezonesidkey='America/Los_Angeles',
        username='testsysadmin@groupon.com'
    );
    return user;
  }

  // TODO: move to LibraryDomainObjectTestHelpers
  public static Opportunity buildOpportunity() {
    Opportunity opportunity = new Opportunity(); 
    opportunity.Name = 'test oppty';
    opportunity.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
    opportunity.division__c = 'Test';
    opportunity.StageName = 'Prospecting'; 
    opportunity.CloseDate = Date.parse('09/02/2012');
    opportunity.Category__c = 'Health & Beauty';
    opportunity.city_manager__c = NULL;
    opportunity.divisional_sales_manager__c = NULL;
    opportunity.user__c = NULL;
    return opportunity;
  }
  
  public static String current_server_timestamp() {
  	return Date.today().format();
  }
  
  public static String random_integer_as_string() {
  	return String.valueOf( Math.abs( Crypto.getRandomInteger() ) );
  }

  // TODO: move to LibraryDomainObjectTestHelpers
  public static Account buildAccount() {
    Account account = new Account();
    account.Name              = DealWizardTestHelper.random_integer_as_string() + ' Test Account ' + DealWizardTestHelper.current_server_timestamp();
    account.BillingStreet     = '2 Diagon Alley';
    account.BillingCity      = 'Orlando';
    account.BillingCountry   = 'US';
    account.BillingPostalCode = '44444';
    account.BillingState     = 'FL';
    return account;
  }

  // TODO: move to LibraryDomainObjectTestHelpers
  public static Social_Living__c buildCompetitorDeal(string merchant_id, string division_name) {
    Social_Living__c competitor_feature = new Social_Living__c();
    competitor_feature.AccountName__c = merchant_id;
    competitor_feature.Feature_Date__c = Date.parse('09/02/2012');
    competitor_feature.Competitors_Deal_Expiration_Date__c = Date.parse('09/02/2014');
    competitor_feature.Units_Sold__c = 999;
    competitor_feature.Deal_Link__c = 'www.groupon.com';
    competitor_feature.Division__c = division_name;
    return competitor_feature;
  }

  public static Merchant_Addresses__c buildMerchantAddress(Id merchant_id){
    Merchant_Addresses__c merchant_address = new Merchant_Addresses__c();
    merchant_address.Street_Line_1__c = '600 W. Chicago Ave';
    merchant_address.Street_Line_2__c = 'Suite: AWESOME!!!';
    merchant_address.City__c = 'Chicago';
    merchant_address.State_Province__c = 'IL';
    merchant_address.Country__c = 'US';
    merchant_address.Venue_Name__c = 'Thunderdome';
    merchant_address.Account__c = merchant_id;
    return merchant_address;
  }

  public static Division__c buildDivision(){
    Division__c division = new Division__c();
    division.Name = 'Saint Testingburg';
    division.State__c = 'IL';
    return division;
  }

  public static DealWizardDeal buildDealWizardDeal(Opportunity opportunity) {
    DealWizardDeal deal = new DealWizardDeal();
    Account account = buildAccount();
    deal.id = opportunity.id;
    deal.opportunity = opportunity;
    deal.account_id = account.id;
    deal.name = 'A Great Deal Name';
    deal.stage_name = 'Prospecting';
    return deal;
  }

  public static DealWizardDeal buildDealWizardDeal(Opportunity opportunity, Account account) {
    DealWizardDeal deal = new DealWizardDeal();
    deal.id = opportunity.id;
    deal.opportunity = opportunity;
    deal.account_id = account.id;
    deal.name = 'A Great Deal Name';
    deal.stage_name = 'Prospecting';
    return deal;
  }

  public static DealWizardDealOption buildDealOption() {
    DealWizardDealOption option = new DealWizardDealOption();
    option.discount = 70.0;
    option.display_order = 1;
    option.groupon_take = 15.0;
    option.margin = 23;
    option.max_pledges = 23;
    option.name = 'a great contract test option';
    option.offer_type = 'item';
    option.unit_buy_price = 15.0;
    option.unit_sell_price = 30.0;
    option.unit_value = 100.0;
    option.voucher_subtitle = 'a contract test voucher subtitle';
    return option;
  }

  public static DealWizardDeal buildDealWizardDealWithOption(Opportunity opportunity, Account account) {
    DealWizardDeal deal = new DealWizardDeal();
    deal.id = opportunity.id;
    deal.opportunity = opportunity;
    deal.account_id = account.id;
    deal.name = 'A Great Deal Name';
    deal.stage_name = 'Prospecting';
    deal.options.add( buildDealOption() );
    return deal;
  }

  public static DealWizardPackageComponent buildPackageComponent() {
    DealWizardPackageComponent component = new DealWizardPackageComponent();

    component.description = 'a contract test description';
    component.value = 10.0;
    return component;
  }

  public static Contact buildMerchantContact(){
    Contact contact = new Contact();
    contact.firstname = 'robbby';
    contact.lastname = 'bro';
    contact.email = 'robbybro@robbingraw.com';
    return contact;
  }

  public static OpportunityContactRole buildOpportunityContactRole(String contact_id, String opportunity_id){
    OpportunityContactRole contact_role = new OpportunityContactRole();
    contact_role.OpportunityId = opportunity_id;
    contact_role.ContactId = contact_id;
    return contact_role;
  }
}