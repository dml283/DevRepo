global class insertMerchantStatusRecord implements database.Batchable<SObject>, Database.Stateful {

  global Database.QueryLocator start (Database.BatchableContext bc) {
    Date todayVal = system.Today();
    Date yesterdayVal = system.Today() - 1;
    Date NinetyDaysAgo = system.today() - 90;
    Date TwentyNineDaysAgo = system.today() - 29;
    String query;
    query = ' SELECT id,Highest_QL_Rank__c,Highest_Sales_Value__c,Call_List_Priority__c,lastActivityDate,research_ranking__c,result_of_merchant_survey__c,account_status__c,ownerid,owner.name,Rejected_Groupon_not_interested__c,Inactive_Merchant_Not_Interested__c,Most_Recent_Last_Close_Date__c,Acct_Status_Change_Date__c,';
    query += '(SELECT id,AccountId,Deal_Strengh__c,createdDate,stageName,closeDate,feature_date__c,groupon_expiration_date__c FROM Opportunities ORDER BY CreatedDate DESC LIMIT 100)';
    query += ' FROM Account WHERE Evaluate_Merchant_Status__c = True OR LastActivityDate =: todayVal OR (LastActivityDate =: yesterdayVal AND Acct_Status_Change_Date__c !=: yesterdayVal) OR LastActivityDate =: NinetyDaysAgo OR LastActivityDate =: TwentyNineDaysAgo OR Most_Recent_Expiry_Date__c =: todayVal';
    return Database.getQueryLocator (query);
  }

  global void execute (Database.BatchableContext BC, List<sObject> scope) {
    List<Account> accounts = (List<Account>) scope;
    List<Task> accountTasks = new List<Task>();
    List<Account> acctsToUpdate = new List<Account>();
    Set<String> doNotRunStatuses = new Set<String> {'Do Not Run - Failed Credit Model', 'Do Not Run - Bankruptcy / Out of Business', 'Do Not Run - CS Issues', 'Do Not Run - High Refunds', 'Do Not Run - Low Customer Satisfaction', 'Do Not Run - Merchant Risk / Fraud', 'Do Not Run - Editorial Red Flag', 'Do Not Run - Historical', 'Do Not Run - Legal', 'Pay on Redemption Only', 'Merchant Research Flag', 'Do Not Run - Pay on Redemption Only'};
    MerchantStatus merch_status;

    List<Task> taskList = [SELECT Id, OwnerId, AccountId, WhatId, Status, CreatedDate, ActivityDate, Calltype, CallDisposition, Merchant_status__c, Call_List_Priority__c, Sales_Value__c, Type, Completed_Date__c, Completed_Date_Time__c FROM Task WHERE Type != 'Email - Click' AND Type != 'Email - Inbound' AND Type != 'Email - Inbound POS' AND Type != 'Email - Open' AND Type != 'Email - Marketing' AND Status = 'Completed' AND AccountId IN: accounts ORDER BY Completed_Date_Time__c DESC]; 

    Map<Id, List<Task>> accountTaskMap = new Map<Id, List<Task>>();
    for (Task t : taskList) {
      if(accountTaskMap.containsKey(t.AccountId)) {
        List<Task> taskIds = accountTaskMap.get(t.AccountId);
        taskIds.add(t);
        accountTaskMap.put(t.AccountId, taskIds);
      } else {
        accountTaskMap.put(t.AccountId, new List<Task> {t});
      }
    }

    for (Account a : accounts) {
      Boolean updateAccount = False;
      if (isDoNotRun (a.Account_Status__c, doNotRunStatuses) == false) {
        if(accountTaskMap.get(a.Id) != null) {
          accountTasks = accountTaskMap.get(a.Id);
        }
        //PASS IN QL RECORDS TO MERCHANT STATUS CLASS
        merch_status = new MerchantStatus (a, a.opportunities, accountTasks);
        String MerchantStatus = getMerchStatusValues (merch_status).Merchant_Status;
        String MerchantStatusReason = getMerchStatusValues (merch_status).Merchant_Status_Reason;
        if (a.Account_Status__c != MerchantStatusReason || a.Result_of_Merchant_Survey__c != MerchantStatus) {
          a.Result_of_Merchant_Survey__c = MerchantStatus;
          a.Account_Status__c = MerchantStatusReason;
          a.Acct_Status_Change_Date__c = system.Today();
          a.Evaluate_Merchant_Status__c = false;
          updateAccount = True;
        }
        
        if ((a.Highest_QL_Rank__c == null || merch_status.highest_ql_priority < a.Highest_QL_Rank__c) && merch_status.highest_ql_priority != null) {
          a.Highest_QL_Rank__c = merch_status.highest_ql_priority;
          a.Highest_QL_Rank_Date_Stamp__c = system.Today();
          a.Evaluate_Merchant_Status__c = false;
          updateAccount = True;
        }
          
        if((a.Highest_Sales_Value__c == null || merch_status.highest_sales_value > a.Highest_Sales_Value__c) && merch_status.highest_sales_value != null) {
          a.Highest_Sales_Value__c = merch_status.highest_sales_value;
          a.Highest_Sales_Value_Date_Stamp__c = system.Today();
          a.Evaluate_Merchant_Status__c = false;
          updateAccount = True;
        }
      }

      if(updateAccount == True) {
        acctsToUpdate.add (a);
      }
      accountTasks.clear();
    }
    database.update (acctsToUpdate);
  }

  global void finish (Database.BatchableContext BC) {
  }

  public class MerchantStatusValsReturn {
    public String Merchant_Status;
    public String Merchant_Status_Reason;
  }

  public boolean isDoNotRun (string accountValue, set<string> doNotRunStatuses) {
    boolean isInSet = false;
    if (doNotRunStatuses.contains (accountValue)) {
      isInSet = true;
    }
    return isInSet;
  }

  public MerchantStatusValsReturn getMerchStatusValues (MerchantStatus ms) {
    MerchantStatusValsReturn msvr = new MerchantStatusValsReturn();
    Datetime last_activity_date = ms.activities.most_recent_completed_date;

    if (last_activity_date == null || last_activity_date < ms.merchant_last_activity_date) {
      last_activity_date = ms.merchant_last_activity_date;
    }

    if (ms.rejected_groupon_not_interested == 'Viability/Bankruptcy - Permanent' || ms.rejected_groupon_not_interested == 'Out of Business') {
      msvr.Merchant_Status = 'Groupon Not Interested';
      msvr.Merchant_Status_Reason = 'Out of Business';
    } else if (ms.rejected_groupon_not_interested == 'Banned Category') {
      msvr.Merchant_Status = 'Groupon Not Interested';
      msvr.Merchant_Status_Reason = 'Banned Category';
    } else if(ms.activities.most_recent_merchant_status == 'Groupon Not Interested - Out of Business'){
      msvr.Merchant_Status = 'Groupon Not Interested';
      msvr.Merchant_Status_Reason = 'Merchant Research Flag';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Not Interested Today'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Not Interested Today';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Closed for the Season'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Closed for the Season';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Prior Bad Experience'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Prior Bad Experience';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Financial: Margin'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Financial: Margin';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Brand: Does Not Discount'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Brand: Does Not Discount';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Doesn\'t Have Capacity'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Doesn\'t Have Capacity';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Competitor Account: Margin'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Competitor Account: Margin';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Financial: Deal Structure'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Financial: Deal Structure';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Brand: Association With Groupon'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Brand: Association With Groupon';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Competitor Account: Other'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Competitor Account: Other';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Unfavorable Payment Terms'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Unfavorable Payment Terms';
    } else if (ms.activities.most_recent_merchant_status == 'Merchant Not Interested - Poor Customer Quality'
               && last_activity_date > system.now() - 29) {
      msvr.Merchant_Status = 'Merchant Not Interested';
      msvr.Merchant_Status_Reason = 'Poor Customer Quality';
    } else if (ms.deals.deal_count == 0 && last_activity_date == null) {
      msvr.Merchant_Status = 'Uncontacted';
      msvr.Merchant_Status_Reason = 'No Outbound Activity';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
        msvr.Merchant_Status_Reason = 'Lacks a Sales Rep';
      }
    } else if (
      (ms.deals.most_recent_close_date != null && ms.deals.most_recent_stage_name == 'Closed Won' && ms.deals.most_recent_close_date <= system.today() && ms.deals.most_recent_close_date >= system.today() - 90)
      ||
      (ms.last_close_date != null && ms.last_close_date >= system.today() - 90 && (ms.deals.most_recent_close_date != null &&
          ms.deals.most_recent_stage_name != 'Closed Lost' && ms.deals.most_recent_stage_name != 'Closed Expired'))
    ) {
      msvr.Merchant_Status = 'Active';
      msvr.Merchant_Status_Reason = 'Closed Current Period';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if (
      (ms.deals.most_recent_stage_name == 'Closed Won' && (ms.deals.most_recent_expiration_date >= system.Today() || ms.deals.most_recent_expiration_date == null)
       && ms.deals.most_recent_close_date >= system.Today() - 180 && ms.deals.most_recent_close_date < system.Today() - 90 && (ms.deals.most_recent_feature_date == null || ms.deals.most_recent_close_date < ms.deals.most_recent_feature_date))
      ||
      (
        ms.deals.most_recent_stage_name != 'Closed Lost' && ms.deals.most_recent_stage_name != 'Closed Expired' && ms.deals.most_recent_close_date != null &&
        (ms.deals.most_recent_expiration_date >= system.Today() || ms.deals.most_recent_expiration_date == null) && ms.last_close_date != null && ms.last_close_date >= system.Today() - 180
        && ms.last_close_date < system.Today() - 90 && (ms.deals.most_recent_feature_date == null || ms.deals.most_recent_close_date < ms.deals.most_recent_feature_date))
    ) {
      msvr.Merchant_Status = 'Active';
      msvr.Merchant_Status_Reason = 'Closed Prior Period';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if (ms.deals.deal_count == 0 && last_activity_date >= system.today() - 90) {
      msvr.Merchant_Status = 'Prospecting';
      msvr.Merchant_Status_Reason = 'Contacted';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if ( (ms.deals.deal_count >= 1 && ms.deals.most_recent_stage_name != null) &&
                (
                  ( (ms.deals.most_recent_stage_name == 'Closed Lost' || ms.deals.most_recent_stage_name == 'Closed Expired') &&
                    (ms.deals.most_recent_expiration_date == null || ms.deals.most_recent_expiration_date < system.today() || ms.deals.most_recent_feature_date == null) &&
                    ( (ms.deals.most_recent_expiration_date == null || ms.deals.most_recent_expiration_date >= system.today() - 90) && last_activity_date >= system.today() - 90))
                  ||
                  (ms.deals.most_recent_expiration_date >= system.today() - 90 && ms.deals.most_recent_expiration_date < system.today() && ms.deals.most_recent_stage_name == 'Closed Won')
                  || (ms.deals.most_recent_stage_name == 'Closed Won' && (ms.deals.most_recent_expiration_date == null || ms.deals.most_recent_expiration_date < system.today()) && last_activity_date >= system.today() - 90)
                )) {
      msvr.Merchant_Status = 'Prospecting';
      msvr.Merchant_Status_Reason = 'Contacted';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if (ms.deals.most_recent_stage_name == 'Contract Sent' && last_activity_date >= system.today() - 90 && ms.deals.most_recent_created_date >= system.today() - 90) {
      msvr.Merchant_Status = 'Prospecting';
      msvr.Merchant_Status_Reason = 'Contract Sent';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if (ms.deals.most_recent_stage_name != 'Closed - Lost' && ms.deals.most_recent_stage_name != 'Closed Lost' && ms.deals.most_recent_stage_name != 'Closed - Expired' && ms.deals.most_recent_stage_name != 'Closed Expired' && ms.deals.most_recent_stage_name != 'Contract Sent' && ms.deals.most_recent_stage_name != 'Closed Won' && ms.deals.most_recent_created_date >= system.today() - 90) {
      msvr.Merchant_Status = 'Prospecting';
      msvr.Merchant_Status_Reason = 'Opportunity Identified/In Negotiations';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if (last_activity_date >= system.today() - 90 && ms.activities.most_recent_call_result == 'Decision Maker Contacted') {
      msvr.Merchant_Status = 'Prospecting';
      msvr.Merchant_Status_Reason = 'Spoke to Decision Maker';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else if ( (ms.deals.most_recent_expiration_date == null || ms.deals.most_recent_expiration_date < system.today())
                && (last_activity_date < system.today() - 90)) {
      msvr.Merchant_Status = 'Prospecting';
      msvr.Merchant_Status_Reason = 'Stale Prospect';
      if (ms.owner_id == '00580000001YaJIAA0') {
        msvr.Merchant_Status = 'Unassigned';
      }
    } else {
      msvr.Merchant_Status = ms.merchant_status_value;
      msvr.Merchant_Status_Reason = ms.merchant_status_reason_value;
    }
    return msvr;
  }
}