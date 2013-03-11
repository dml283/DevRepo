/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/26/02

* @Last Change: 2013/26/02 by MK

* Description.: Class to run before update on Account. Populates Rewards Offer Status on Account

* Dependencies: AccountTrigger, rewardsOfferStatus
* ===================================================================
*/

public with sharing class RewardsOfferStatusWorkflow implements TriggerWorkflow {
  Map<ID, Account> newMap;
  Map<ID, Account> oldMap;
  Map<Id, List<Opportunity>> accountToOpportunityMap;

  public RewardsOfferStatusWorkflow (Map<ID, Account> newMap, Map<ID, Account> oldMap) {
    this.newMap = newMap;
    this.oldMap = oldMap;
    accountToOpportunityMap = new Map<Id, List<Opportunity>>();
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      loadOpportunities();
      for (Account a : newMap.values()) {
        setRewardsOfferStatus(a);
      }
      
      hasExecuted = true;
    }
  }

   private void loadOpportunities() {
    for(Account a: [SELECT Id, Count_of_Rewards_Opportunities__c, (SELECT Id, AccountId, StageName, Feature_date__c, Feature_end_date__c FROM Opportunities WHERE RecordType.Name='Rewards') FROM Account WHERE Id IN : newMap.keyset()]) {
      if(a.getSObjects('Opportunities') != null && a.getSObjects('Opportunities').size() > 0) {
        accountToOpportunityMap.put(a.Id, a.Opportunities);
      } else {
        accountToOpportunityMap.put(a.Id, new List<Opportunity>());
      }      
    }
  }

  public void setRewardsOfferStatus (Account a) {
    if(accountToOpportunityMap.get(a.Id) != null) {
      List<Opportunity> opportunityList = accountToOpportunityMap.get(a.Id);
      rewardsOfferStatus ros = new rewardsOfferStatus(a, opportunityList);
    }
  }
}