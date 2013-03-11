public class MerchantStatus {
  public string account_id {get; set;}
  public MerchantStatusDeals deals {get; set;}
  public MerchantStatusActivites activities {get; set;}
  public String research_ranking {get; set;}
  public String merchant_status_value {get; set;}
  public String merchant_status_reason_value {get; set;}
  public String owner_id {get; set;}
  public String owner_name {get; set;}
  public String rejected_groupon_not_interested {get; set;}
  public String inactive_merchant_not_interested {get; set;}
  public Date merchant_last_activity_date {get; set;}
  public Integer highest_ql_priority {get; set;}
  public Integer highest_sales_value {get; set;}
  public Date last_close_date {get; set;}

  public MerchantStatus (account a, List<Opportunity> oList, List<Task> tList) {
    this.account_id = a.id;
    this.deals = new MerchantStatusDeals (oList);
    this.activities = new MerchantStatusActivites (tList);
    if (a.research_ranking__c != null) {
      this.research_ranking = a.research_ranking__c;
    } else {
      this.research_ranking = '0';
    }
    this.merchant_status_value = a.result_of_merchant_survey__c;
    this.merchant_status_reason_value = a.account_status__c;
    this.owner_id = a.owner.id;
    this.owner_name = a.owner.name;
    this.rejected_groupon_not_interested = a.Rejected_Groupon_not_interested__c;
    this.inactive_merchant_not_interested = a.Inactive_Merchant_Not_Interested__c;
    this.merchant_last_activity_date = a.LastActivityDate;
    if (activities.call_list_priority != null && activities.call_list_priority != '') {
      if (a.ownerId == activities.most_recent_assigned_to) {
        if (a.Highest_QL_Rank__c == null ||  integer.ValueOf(activities.call_list_priority) < a.Highest_QL_Rank__c) {
          this.highest_ql_priority = integer.ValueOf(activities.call_list_priority);
        }
      }
    }

    if (activities.sales_value != null) {
      if (a.ownerId == activities.most_recent_assigned_to) {
        if (a.Highest_Sales_Value__c == null ||  integer.ValueOf(activities.sales_value) > a.Highest_Sales_Value__c) {
          this.highest_sales_value = integer.ValueOf(activities.sales_value);
        }
      }
    }
    this.last_close_date = a.Most_Recent_Last_Close_Date__c;
  }
  //empty constructor
  public MerchantStatus() {
    this.account_id = 'null';
    this.deals = new MerchantStatusDeals();
    this.activities = new MerchantStatusActivites();
    this.research_ranking = '0';
    this.merchant_status_value = 'null';
    this.merchant_status_reason_value = 'null';
    this.owner_id = 'null';
    this.owner_name = 'null';
    this.rejected_groupon_not_interested = 'null';
    this.inactive_merchant_not_interested = 'null';
    this.merchant_last_activity_date = null;
    this.highest_ql_priority = null;
    this.highest_sales_value = null;
    this.last_close_date = null;

  }
}