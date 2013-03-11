public class LeadUpdateMerchant extends DispatchClient implements DispatchContextFilter {

  public override void execute(DispatchContext context) {

    List<Lead> convertedLeads = (List<Lead>) context.changedList(this);

    if (convertedLeads.size() == 0) {
      return;
    }

    Map<Id, Id> leadToAccount = createLeadToAccountMap(convertedLeads);

    updateDataIntegrities(leadToAccount);
    Map<Id, Merchant_Addresses__c> accountToAddresses = insertMissingMerchantAddresses(convertedLeads, leadToAccount);
    updateReviews(leadToAccount, accountToAddresses);      
    updateMerchantEvents(leadToAccount);

  }

  public override void resume(DispatchContext context) {
  }

  public Boolean filter(SObject oldObject, SObject newObject) {
    return ((Lead) newObject).IsConverted == true && ((Lead) oldObject).IsConverted == false;
  }

  private void updateDataIntegrities(Map<Id, Id> leadToAccount) {
    List<Data_Integrity__c> dataIntegrities = [SELECT Lead__c, Account__c FROM Data_Integrity__c WHERE Lead__c IN :leadToAccount.keySet()];
    for (Data_Integrity__c dataIntegrity : dataIntegrities) {
      dataIntegrity.Account__c = leadToAccount.get(dataIntegrity.Lead__c);
    }
    updateObjects(dataIntegrities);
  }

  private void updateMerchantEvents(Map<Id, Id> leadToAccount) {
    List<Merchant_Events__c> merchantEvents = [SELECT Account__c, Lead__c FROM Merchant_Events__c WHERE Lead__c IN :leadToAccount.keySet()];
    for (Merchant_Events__c merchantEvent : merchantEvents) {
      merchantEvent.Account__c = leadToAccount.get(merchantEvent.Lead__c);
    }
    updateObjects(merchantEvents);
  }

  private Map<Id, Merchant_Addresses__c> insertMissingMerchantAddresses(List<Lead> convertedLeads, Map<Id, Id> leadToAccount) {
    List<Merchant_Addresses__c> existingAddresses = [SELECT Id, Account__c FROM Merchant_Addresses__c WHERE Account__c = :leadToAccount.values()];
    Map<Id, Merchant_Addresses__c> accountToAddresses = new Map<Id, Merchant_Addresses__c>();
    for (Lead convertedLead : convertedLeads) {
      Id accountId = leadToAccount.get(convertedLead.Id);
      if (accountNeedsAddress(accountId, existingAddresses)) {
        accountToAddresses.put(accountId, createAddressFor(convertedLead));
      }
    }
    insertObjects(accountToAddresses.values());
    return accountToAddresses;
  }

  private void updateReviews(Map<Id, Id> leadToAccount, Map<Id, Merchant_Addresses__c> accountToAddresses) {
    List<Reviews__c> reviews = [SELECT Id, Merchant_address__c, Lead__c, Account__c, Location_Lead_Review__c FROM Reviews__c WHERE Lead__c IN :leadToAccount.keySet()];
    for (Reviews__c review : reviews) {
      review.Account__c = leadToAccount.get(review.Lead__c);

      Merchant_Addresses__c newAddress = accountToAddresses.get(review.Account__c);
      if (review.Location_Lead_Review__c == true && newAddress != null) {
        review.Merchant_Address__c = newAddress.Id;
      }
    }
    updateObjects(reviews);
  }

  private void updateObjects(List<SObject> objects) {
    if (objects.size() > 0) {
      try {
        update objects;
      } catch(exception ex) {
        System.debug(LoggingLevel.ERROR, ex);
      }
    }
  }

  private void insertObjects(List<SObject> objects) {
    if (objects.size() > 0) {
      try {
        insert objects;
      } catch(exception ex) {
        System.debug(LoggingLevel.ERROR, ex);
      }
    }
  }

  private Map<Id, Id> createLeadToAccountMap(List<Lead> leads) {
    Map<Id, Id> leadToAccount = new Map<Id, Id>();
    for (Lead lead : leads) {
      leadToAccount.put(lead.Id, lead.ConvertedAccountId);
    }
    return leadToAccount;
  }

  private Boolean accountNeedsAddress(Id accountId, List<Merchant_Addresses__c> addresses) {
    Boolean addressNeeded = true;
    for (Merchant_Addresses__c address : addresses) {
      if (address.Account__c == accountId) {
        addressNeeded = false;
      }
    }
    return addressNeeded;
  }

  private Merchant_Addresses__c createAddressFor(Lead convertedLead) {
    return new Merchant_Addresses__c(
      Account__c = convertedLead.ConvertedAccountId,
      Zip_Postal_Code__c = convertedLead.PostalCode,
      Street_Line_1__c = convertedLead.Street,
      State_Province__c = convertedLead.State,
      Phone_Number__c = convertedLead.Phone,
      Country__c = convertedLead.Country,
      City__c = convertedLead.City
    );
  }

}