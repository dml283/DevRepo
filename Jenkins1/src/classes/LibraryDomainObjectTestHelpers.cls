public virtual class LibraryDomainObjectTestHelpers {

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

  public static Account buildAccount() {
    Account account = new Account();
    account.Name = 'static Test Account Name';
    return account;
  }

}