public with sharing class deal_structure_emails_controller {
  public String assignedtoId {get; set;}
  
  public deal_structure_emails_controller() {
    opportunityFieldNameToLabel = new Map<String,String>();
    multiDealFieldNameToLabel = new Map<String,String>();
    getFieldDescribe();
  }

  List<OpportunityFieldHistory> opportunityHistory = new List<OpportunityFieldHistory>();
  List<Multi_deal__c> multideals = new List<Multi_deal__c>();
  List<Multi_Deal__History> multiDealHistory = new List<Multi_Deal__History>();
  List<Opportunity> past = new List<Opportunity>();
  public Map<String, String> opportunityFieldNameToLabel {get;set;}
  public Map<String, String> multiDealFieldNameToLabel {get;set;}
  

  public List<Multi_deal__c> getmultideals() {
    multideals = [SELECT Id, Name, Unit_buy_price__c, Unit_sell_price__c, Unit_value__c, GrouponLite_Monthly_Cap__c, Total_Deal_Max__c, Margin__c, Discount__c, Margin_Percent__c, Expiration_Type__c, Alternative_Expiration_Date__c, Months_to_Expiration__c FROM Multi_deal__c WHERE Opportunity__c = : assignedtoId];
    return multideals;
  }

  public Opportunity getOpportunity () {
    Opportunity Opp = [SELECT Id, Name, Feature_or_Refeature__c, Owner.Name, Division__c, Subdivision__c, Account.Top_Merchant_Campaign__c, Account.Highest_QL_Rank__c, Account.Eligible_for_Refeature__c, Account.Sales_Value_Reasons__c,
                       Account.Name, Account.Merchant_Tier__c, Merchant_Quality_Ranking__c, CC_Fee__c, Max_Units__c, Payment_Preference__c, Submitted_via_Deal_Wizard__c, Straight_to_Private_Sale__c,
                       Payment_Terms__c, Conditions__c, Deal_Structure_Approval_Notes__c, Primary_Deal_Services__c, RecordType.Name, Amount_of_Multi_Deal_Children__c, Margin_Alert__c, Margin_Percent__c, Category_v3__c, Available_Date__c,
                       Now_Sales_Info__c, Total_Feature_Deal_Max__c, Rewards_Sales_Info__c, QL_Rank__c, QL_Sales_Value__c FROM Opportunity WHERE Id = : assignedtoId];
    return Opp;
  }

  public List<OpportunityFieldHistory> getOpportunityHistory () {
    opportunityHistory = [SELECT OpportunityId, OldValue, NewValue, IsDeleted, Id, Field, CreatedDate, CreatedById, CreatedBy.Name, Opportunity.Name FROM OpportunityFieldHistory WHERE OpportunityId = : assignedtoId AND Field != 'Locked' AND Field != 'Unlocked' AND Field != 'Created' ORDER BY CreatedDate DESC];
    
    return opportunityHistory;
  }

  public List<Multi_Deal__History> getMultiDealHistory () {
    multiDealHistory = [SELECT ParentId, OldValue, NewValue, IsDeleted, Id, Field, CreatedDate, CreatedById, CreatedBy.Name, Parent.Name FROM Multi_Deal__History WHERE Field != 'Created' AND ParentId IN: multideals ORDER BY ParentId,CreatedDate DESC];
    
    return multiDealHistory;
  }

  public list<Opportunity> getPastDeals() {
    List<Opportunity> oppIds = [SELECT Id, Account.Id FROM Opportunity WHERE Id =: assignedtoId];
    Id AcctID;
                
    for(Opportunity o : oppIds) {
      AcctID = o.Account.Id;
    }
                
    List <Opportunity> past = [SELECT Id, Account.Id, Name, Division__c, Feature_Date__c, Permalink__c, Deal_Strengh__c, Total_GP__c, Total_Units_Sold__c FROM Opportunity WHERE Account.Id = :AcctID AND StageName = 'Closed Won' AND Id != :assignedtoId ORDER BY Feature_Date__c DESC LIMIT 5];
    return past;
  }

  public void getFieldDescribe() {
    Map<String, Schema.SObjectField> opportunityFieldMap = Opportunity.getSObjectType().getDescribe().fields.getMap();
    Map<String, Schema.SObjectField> multiDealFieldMap = Multi_Deal__c.getSObjectType().getDescribe().fields.getMap();
    
    for(String fieldApiName : opportunityFieldMap.keySet()) {
      Schema.DescribeFieldResult f = opportunityFieldMap.get(fieldApiName).getDescribe();
      if(f.getName() == 'OwnerId') {
        opportunityFieldNameToLabel.put('Owner',f.getLabel());
      } else {
        opportunityFieldNameToLabel.put(f.getName(),f.getLabel());
      }
    }
    
    for(String fieldApiName : multiDealFieldMap.keySet()) {
      Schema.DescribeFieldResult f = multiDealFieldMap.get(fieldApiName).getDescribe();
      if(f.getName() == 'OwnerId') {
        multiDealFieldNameToLabel.put('Owner',f.getLabel());
      } else {
        multiDealFieldNameToLabel.put(f.getName(),f.getLabel());
      }
    }
  }
}