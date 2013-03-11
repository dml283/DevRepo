//01pC0000000I3xO
global class SalesValue_API {
  public static set<string> offset{ get; set; }

  global class SalesValue {

    public Decimal sales_value_demand { get; set; }
    public String account_owner_id    { get; set; }
    public List<String> sales_value_reasons { get; set; }
    public Decimal sales_value        { get; set; }
    public String call_list_priority  { get; set; }
    public String salesforce_id       { get; set; }
    public String quantum_lead_tag    { get; set; }

    public SalesValue() {}

    public salesValue(Account acc) {
      this.salesforce_id = acc.Id;
      this.sales_value = acc.sales_value__c;
      this.call_list_priority = acc.Call_List_Priority__c;
      this.account_owner_id = acc.OwnerId;
      this.sales_value_demand = acc.sales_value_demand__c;
      this.sales_value_reasons = acc.sales_value_reasons__c != null ? acc.sales_value_reasons__c.split('\\|') : null;
      this.quantum_lead_tag = acc.quantum_lead_tag__c;
    }

    global Account JSONresponse_account(SalesValue_API.salesValue sv) {
      return getAccount(sv);
    }

    global Account getAccount(SalesValue_API.salesValue sv) {
      Account accs;
      if (sv.salesforce_id != null && sv.salesforce_id.length() > 0) {
        accs = new Account(Id = sv.salesforce_id);
      }
      if (sv.sales_value != null) {
        accs.sales_value__c = sv.sales_value;
      }
      if (sv.call_list_priority != null && sv.call_list_priority.length() > 0) {
        accs.Call_List_Priority__c = sv.call_list_priority;
      }
      if (sv.account_owner_id != null) {
        accs.OwnerId = sv.account_owner_id;
      }
      if (sv.sales_value_reasons != null) {
        accs.sales_value_reasons__c = format_reasons(sv.sales_value_reasons);
      }
      if (sv.sales_value_demand != null) {
        accs.sales_value_demand__c = sv.sales_value_demand;
      }
      if (sv.quantum_lead_tag != null) {
        accs.quantum_lead_tag__c = sv.quantum_lead_tag;
      }

      return accs;
    }

    private String format_reasons(List<String> sales_value_reasons) {
      String result = StringUtils.joinArray(sales_value_reasons, '|');
      if (result.length() > 255) {
        result = result.substring(0, 240) + '... and more';
      }

      return result;
    }
  }

  @Istest
    public static void testme() {
      taxonomy_support__c tax = new taxonomy_support__c();
      tax.C3_Id__c = '123';
      tax.category__c = 'Test';
      tax.Subcategory__c = 'Test';
      insert tax;
      division__c div = new division__c();
      div.state__c = 'IL';
      div.name = 'chicago';
      div.permalink__c = 'chicago';
      Insert div;

      Account Acc = new Account();
      Acc.name = 'Test';
      Acc.division__c = div.id;
      Acc.billingstate = 'CA';
      Acc.Call_List_Priority__c = '123';
      Acc.sales_value__c = 123;
      Insert Acc;


      merchant_addresses__c addy = new merchant_addresses__c();
      addy.account__c = Acc.Id;
      Insert addy;

      SalesValue_API.salesValue sales_value = new salesValue();
      SalesValue_API.salesValue Sv = new salesValue(Acc);
      sales_value.JSONresponse_account(Sv);
      //sales_value.getMerchant_Info('chicago', 100, null); //broken test

    }

}