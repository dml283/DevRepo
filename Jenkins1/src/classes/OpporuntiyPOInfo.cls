public class OpporuntiyPOInfo {
  //step 1:  for this opportunity find the account related
  //step 2:  find all the pinnedmerchants where  account in the opportunity being edited is the same as  the acccount in the opportunity related to the pinned merchant
  //step 3:  find all the PO's related to these Pinned merchants and insert the Opportunity in the Opportunity of PO only if blank reject all Po's with Opp already existing.
  @FUTURE
  public static void POrelatedtoOpp (List<ID> OppId) {
    Boolean updatePassed = false;
    String accountName;
    String opName;
    String dsmEmail;
    List<Purchase_Order__c> purchase = new List<Purchase_order__c>();
    List<Pinnedmerchant__c> pinnedMerchants = new List<Pinnedmerchant__c>();
    List<Id> purchaseIds = new List<Id>();
    List<Purchase_order__c> finalPurchList = new List<Purchase_order__c>();
    List<Id> accountID = new List<Id>();
    Database.saveresult[] SR;

    //find the opportunity in the current context and get the Account Info.
    List<Opportunity> opp = [SELECT Id, Name, Ownerid, AccountId, Account.Name, Global_sfdc_category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Divisional_Sales_Manager__r.Email FROM Opportunity WHERE RecordTypeId != '012C0000000UK9N' AND Id IN: OppId];

    //If there is atleast one pinnedmerchants  related to the Account of the opportunity then find the purchase order related to the pinnedmerchants .
    for (Opportunity ops : opp) {
      accountID.add (ops.accountId);
    }

    //pinnedmerchants = [select id,Opportunity__c,Purchase_Order__c,Purchase_order__r.Opportunity__c from pinnedmerchant__c where Opportunity__r.accountId =: accountID OR Lead__r.convertedAccountId =: accountID ];
    pinnedMerchants = [SELECT Id, Opportunity__c, Purchase_Order__c, Purchase_order__r.Opportunity__c FROM Pinnedmerchant__c WHERE Account__c = : accountID OR Lead__r.ConvertedAccountId = : accountID ];

    //Get the Purchase orders related to the pinned merchants.
    for(Pinnedmerchant__c pin : pinnedMerchants) {
      purchaseIds.add (pin.Purchase_order__c);
    }

    //Query and find the purchase orders.
    purchase = [SELECT Id, Opportunity__c, PO_status__c, Services__c, Subdivision__r.Name, Po_notes__c, Owner.Name, Owner.Email, OwnerId, Opportunity__r.Name, Target_Feature_Date__c, Subcategory_v3__c, Category_v3__c FROM Purchase_Order__c WHERE Id IN: purchaseIds AND PO_Status__c = 'Open' AND Evergreen_ID__c = '' ORDER BY Target_Feature_Date__c ASC];

    //for all matching PO's
    //1) Insert the Opportunity into the PO's Opportunity field.
    //2) If the update happens then send the record for approval.
    for (Purchase_order__c Purch : purchase) {
      for (Opportunity op : opp) {
        purch.Opportunity__c = op.Id;
        accountName = op.Account.Name;
        opName = op.Name;
        dsmEmail = op.Divisional_Sales_Manager__r.Email;

      }
      finalPurchList.add (Purch);
    }
    try {
      if (finalPurchList.size() > 0) {
        SR = database.update (finalPurchList);
      }
    } catch (Exception ex) {
      System.debug ('#### UPDATE FAILED' + ex);
    }
    if (SR != null && SR.size() > 0) {
      for (Database.saveresult S : SR) {
        if (S.Issuccess()) {
          updatePassed = true;
        }
      }
    }
    if (updatePassed  == true) {
      try {
        string purchaseOrdersList = '';
        list<string> Owner = new list<string>();
        for (purchase_order__c P : finalPurchList) {
          purchaseOrdersList = purchaseOrdersList  +
          '<b>Target Feature Date : </b>' + string.valueof (P.Target_Feature_Date__c).substring (0, 10) + '<br />' +
          '<b>Subdivision : </b>' + P.Subdivision__r.Name + '<br />' +
          '<b>City Planner :</b>' + P.Owner.Name             + '<br />' +
          '<b>Services :</b>'    + P.Services__c            + '<br />' +
          '<b>Category :</b>'    + P.Category_v3__c         + '<br />' +
          '<b>Subcategory :</b>' + P.Subcategory_v3__c      + '<br />' +
          '<b>PO Notes :</b>'    + P.Po_notes__c            + '<br /> ' +
          '<b>Link :</b>'         + 'https://na8.salesforce.com/' + P.Id + '<br /> <br />' ;
          owner.add (P.Owner.Email);
          if(dsmEmail != null) {
            owner.add(dsmEmail);
          }
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        for (Purchase_order__c P : finalPurchList) {
          mail.setSaveAsActivity (false);
          mail.setToAddresses (Owner);
          mail.setHtmlBody (
          'The following opportunity just closed :' + '<br />' +
          '<b>Merchant :</b>'    + accountName + '<br /> ' +
          '<b>Deal Title :</b>'  + opName      + '<br /> ' +
          '<b>Link :</b>'        + 'https://na8.salesforce.com/' + P.opportunity__c + ' <br /> <br />' +
          'This opportunity matches the following PO(s): <br /> <br />' +  purchaseOrdersList.replace ('null', ''));
          mail.setSenderDisplayName ('Recently Closed Opportunity for (' + accountName + ') matches one or more POs');
          mail.setsubject ('Recently Closed Opportunity for (' + accountName + ') matches one or more POs');
        }

        Messaging.sendEmail (new Messaging.SingleEmailMessage[] { mail });
      } catch (Exception Ex) {
        system.debug ('Exception from catch block' + Ex);
      }
    }
  }

  @Istest
  public static void testscenario1() {
    List<Id> oppid = new List<Id>();
    Date myDate = date.newinstance (1960, 2, 17);
    Account Acc = new Account();
    Acc.Name = 'Oppty PO Info' + system.now();
    Insert Acc;

    Opportunity Opp = new Opportunity();
    opp.Global_SFDC_Category__c = 'Charity';
    opp.Global_SFDC_Subcategory_1__c = 'Charity';
    opp.Global_SFDC_Subcategory_2__c = 'Charity';
    Opp.Name = 'Test Opp';
    Opp.Deal_Strengh__c = 'Solid';
    Opp.ForecastCategoryName = 'Pipeline';
    Opp.Stagename = 'Closed Won';
    Opp.CloseDate = myDate ;
    Opp.Accountid = Acc.Id;
    Insert Opp;

    oppid.add(opp.Id);
    Division__c div = new Division__c();
    div.Name = 'Test Div';
    div.State__c = 'CA';
    Insert div;


    Purchase_order__c pur = new Purchase_order__c();
    pur.Division__c = div.Id;
    pur.Target_feature_date__c = myDate ;
    pur.Global_SFDC_Category__c = opp.Global_SFDC_category__c ;
    pur.Global_SFDC_Subcategory_1__c = opp.Global_SFDC_Subcategory_1__c ;
    pur.Global_SFDC_Subcategory_2__c = opp.Global_SFDC_Subcategory_2__c ;
    Insert pur;

    Pinnedmerchant__c pinned = new Pinnedmerchant__c();
    pinned.Opportunity__c = opp.Id;
    pinned.Purchase_order__c = pur.Id;
    Insert pinned;

    system.assert (pur.Opportunity__c == null);

    Test.startTest();
    OpporuntiyPOInfo.POrelatedtoOpp (oppid);
    Test.stopTest();

    system.assert (pur.opportunity__c != '');

  }
}