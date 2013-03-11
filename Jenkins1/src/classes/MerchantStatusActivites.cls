public class MerchantStatusActivites{
  public string most_recent_call_type {get;set;}
  public datetime most_recent_completed_date {get;set;}
  public integer activity_count {get;set;}
  public string most_recent_call_result {get;set;}
  public string most_recent_merchant_status {get; set;}
  public date most_recent_created_date {get;set;}
  public string most_recent_assigned_to {get;set;}
  public string call_list_priority {get;set;}
  public decimal sales_value {get;set;}

  public MerchantStatusActivites(list<Task> taskList){
    this.activity_count = 0;

    for(Task t : taskList){
      activity_count ++;
      if(activity_count >= 1) {
        if(t.Completed_Date__c == system.today() && t.status == 'Completed' && t.merchant_status__c != null && t.merchant_status__c.contains('Merchant Not Interested')) {
          this.most_recent_created_date = t.createdDate.date();
          this.most_recent_completed_date = t.Completed_Date_Time__c;
          this.most_recent_call_type = t.calltype;
          this.most_recent_call_result = t.CallDisposition;
          this.most_recent_merchant_status = t.merchant_status__c;
          this.most_recent_assigned_to = t.OwnerId;
          if(this.call_list_priority == null || Integer.ValueOf(t.Call_List_Priority__c) < Integer.ValueOf(this.call_list_priority)) {
            this.call_list_priority = t.Call_List_Priority__c;
          }
          if(this.sales_value == null || t.Sales_Value__c > this.sales_value) {
            this.sales_value = t.Sales_Value__c;
          }
        } else if(this.most_recent_completed_date == null && t.status == 'Completed'){
          this.most_recent_created_date = t.createdDate.date();
          this.most_recent_completed_date = t.Completed_Date_Time__c;
          this.most_recent_call_type = t.calltype;
          this.most_recent_call_result = t.CallDisposition;
          this.most_recent_merchant_status = t.merchant_status__c;
          this.most_recent_assigned_to = t.OwnerId;
          if(this.call_list_priority == null || Integer.ValueOf(t.Call_List_Priority__c) < Integer.ValueOf(this.call_list_priority)) {
            this.call_list_priority = t.Call_List_Priority__c;
          }
          if(this.sales_value == null || t.Sales_Value__c > this.sales_value) {
            this.sales_value = t.Sales_Value__c;
          }
        } else if(this.most_recent_completed_date != null && t.status == 'Completed' && t.Completed_Date_Time__c > this.most_recent_completed_date) {
          if(this.most_recent_merchant_status == null || (this.most_recent_merchant_status != null && !this.most_recent_merchant_status.contains('Merchant Not Interested'))) {
            this.most_recent_created_date = t.createdDate.date();
            this.most_recent_completed_date = t.Completed_Date_Time__c;
            this.most_recent_call_type = t.calltype;
            this.most_recent_call_result = t.CallDisposition;
            this.most_recent_merchant_status = t.merchant_status__c;
            this.most_recent_assigned_to = t.OwnerId;
            if(this.call_list_priority == null || Integer.ValueOf(t.Call_List_Priority__c) < Integer.ValueOf(this.call_list_priority)) {
              this.call_list_priority = t.Call_List_Priority__c;
            }
            if(this.sales_value == null || t.Sales_Value__c > this.sales_value) {
              this.sales_value = t.Sales_Value__c;
            }
          }
        }
      }
    }
  }
    
  //empty constructor
  public MerchantStatusActivites(){
    this.most_recent_call_type = null;
    this.most_recent_completed_date = null;
    this.activity_count = 0;
    this.most_recent_call_result= null;
    this.most_recent_merchant_status = null;
    this.most_recent_created_date = null;
    this.most_recent_assigned_to = null;
    this.call_list_priority = null;
    this.sales_value = null;
  }  
}