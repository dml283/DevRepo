/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/21/02

* @Last Change: 2013/21/02 by MK

* Description.: Class to run before update on Account. Populates previous account owner and Now Deal Closed By fields

* Dependencies: AccountTrigger
* ===================================================================
*/

public with sharing class AccountFieldAssignmentsWorkflow implements TriggerWorkflow {
  Map<ID, Account> newMap;
  Map<ID, Account> oldMap;

  public AccountFieldAssignmentsWorkflow (Map<ID, Account> newMap, Map<ID, Account> oldMap) {
    this.newMap = newMap;
    this.oldMap = oldMap;
    system.debug('Old Map: ' + this.oldMap);
    system.debug('New Map: ' + this.newMap);
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      for (Account a : newMap.values()) {
        assignPreviousAccountOwner (a);
        assignNowDealClosedBy (a);
      }

      hasExecuted = true;
    }
  }

  public void assignPreviousAccountOwner (Account a) {
    Id oldOwnerId = oldMap.get(a.Id).OwnerId;
    if (oldOwnerId != a.OwnerId) {
      a.Previous_Account_Owner__c = oldOwnerId;
    }
  }

  public void assignNowDealClosedBy (Account a) {
    if (a.Now_Deal_Closed_By__c == null && a.Now_Deal_Owner__c != null && a.Now_Status__c == 'closed won') {
      a.Now_Deal_Closed_By__c = a.Now_Deal_Owner__c;
    }
  }
}