public virtual class LibraryRESTControllerTestHelpers {

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
    ////opportunity.Division_Dynamic__c = d.id;
    ////opportunity.AccountId = a.id;
    opportunity.StageName = 'Prospecting'; 
    opportunity.CloseDate = Date.parse('09/02/2012');
    opportunity.Category__c = 'Health & Beauty';
    opportunity.city_manager__c = NULL;
    opportunity.divisional_sales_manager__c = NULL;
    opportunity.user__c = NULL;
    return opportunity;
  }

  // TODO: move to LibraryDomainObjectTestHelpers
  public static Account buildAccount() {
    Account account = new Account();
    account.Name              = 'static Test Account Name';
    account.BillingStreet     = '2 Diagon Alley';
    account.BillingCity      = 'Orlando';
    account.BillingCountry   = 'US';
    account.BillingPostalCode = '44444';
    account.BillingState     = 'FL';
    return account;
  }
  
  public static Contact buildContact() {
  	Contact contact = new Contact();
  	contact.FirstName = 'static Test First Name';
  	contact.LastName = 'static Test Last Name';
  	contact.phone = '5551231234';
  	contact.email = 'static@test.com';
  	return contact;
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
}