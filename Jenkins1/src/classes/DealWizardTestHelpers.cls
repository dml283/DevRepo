public virtual class DealWizardTestHelpers {

  public static DealWizardDeal buildDeal() {

    Opportunity opportunity = LibraryDomainObjectTestHelpers.buildOpportunity(); 
    Database.insert( opportunity );

    DealWizardDeal deal = new DealWizardDeal();
    deal.id = opportunity.id;
    
    deal.opportunity = opportunity;
    
    deal.account_id = '0018000000lJaKh';
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

  public static DealWizardPackageComponent buildPackageComponent() {
    DealWizardPackageComponent component = new DealWizardPackageComponent();

    component.description = 'a contract test description';
    component.value = 10.0;
    return component;
  }

}