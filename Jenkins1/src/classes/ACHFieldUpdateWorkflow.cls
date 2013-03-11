/* ===================================================================
* Account

* @author.....: Matt Koss

* @date.......: 2013/26/02

* @Last Change: 2013/26/02 by MK

* Description.: Class to run before update on Account. Populates Last ACH Update date and validates the routing number

* Dependencies: AccountTrigger
* ===================================================================
*/

public with sharing class ACHFieldUpdateWorkflow implements TriggerWorkflow {
  Map<ID, Account> newMap;
  Map<ID, Account> oldMap;

  public ACHFieldUpdateWorkflow (Map<ID, Account> newMap, Map<ID, Account> oldMap) {
    this.newMap = newMap;
    this.oldMap = oldMap;
  }

  public static Boolean hasExecuted {get{if (hasExecuted == null) { hasExecuted = false; } return hasExecuted; } private set; }

  //business logic
  public void execute() {
    if (!hasExecuted && !System.isBatch() && !System.isFuture()) {
      for (Account a : newMap.values()) {
        populateLastACHUpdate(a);
        validRoutingNumberUpdate(a);
      }

      hasExecuted = true;
    }
  }

  public void populateLastACHUpdate (Account a) {
    Boolean updateCheck = false;
    Account oldAccount = oldMap.get(a.Id);
    Account newAccount = newMap.get(a.Id);

    if (oldAccount.Routing_Number_enc__c != null && newAccount.Routing_Number_enc__c != null && oldAccount.Routing_Number_enc__c != newAccount.Routing_Number_enc__c) {
      updateCheck = true;
    }

    if (oldAccount.Account_Number__c != null && newAccount.Account_Number__c != null && oldAccount.Account_Number__c != newAccount.Account_Number__c) {
      updateCheck = true;
    }

    if (oldAccount.BillingStreet != newAccount.BillingStreet ||
        oldAccount.BillingCity != newAccount.BillingCity ||
        oldAccount.BillingState != newAccount.BillingState ||
        oldAccount.BillingPostalCode != newAccount.BillingPostalCode ||
        oldAccount.BillingCountry != newAccount.BillingCountry ||
        oldAccount.Make_Checks_Payable_To__c != newAccount.Make_Checks_Payable_To__c ||
        (oldAccount.Beneficiary_Bank_Account_Number__c != newAccount.Beneficiary_Bank_Account_Number__c && newAccount.Beneficiary_Bank_Account_Number__c != '') ||
        oldAccount.Beneficiary_Bank_Address_1__c != newAccount.Beneficiary_Bank_Address_1__c ||
        oldAccount.Beneficiary_Bank_Address_2__c != newAccount.Beneficiary_Bank_Address_2__c ||
        oldAccount.Beneficiary_Bank_Address_3__c != newAccount.Beneficiary_Bank_Address_3__c ||
        oldAccount.Beneficiary_Bank_Address_4__c != newAccount.Beneficiary_Bank_Address_4__c ||
        oldAccount.Beneficiary_Bank_Name__c != newAccount.Beneficiary_Bank_Name__c ||
        oldAccount.Beneficiary_Bank_Routing_Number__c != newAccount.Beneficiary_Bank_Routing_Number__c ||
        oldAccount.Beneficiary_Bank_Sort_Code__c != newAccount.Beneficiary_Bank_Sort_Code__c ||
        oldAccount.Beneficiary_Bank_Swift_Code__c != newAccount.Beneficiary_Bank_Swift_Code__c ||
        oldAccount.Intermediate_Bank_Name__c != newAccount.Intermediate_Bank_Name__c ||
        oldAccount.Intermediate_Bank_Routing_Number__c != newAccount.Intermediate_Bank_Routing_Number__c ||
        oldAccount.Intermediate_Bank_Swift_Code__c != newAccount.Intermediate_Bank_Swift_Code__c ||
        oldAccount.Intermediate_Bank_Address_1__c != newAccount.Intermediate_Bank_Address_1__c ||
        oldAccount.Intermediate_Bank_Address_2__c != newAccount.Intermediate_Bank_Address_2__c ||
        oldAccount.Intermediate_Bank_Address_3__c != newAccount.Intermediate_Bank_Address_3__c ||
        oldAccount.Intermediate_Bank_Address_4__c != newAccount.Intermediate_Bank_Address_4__c ||
        oldAccount.Remittance_Instruction_1__c != newAccount.Remittance_Instruction_1__c ||
        oldAccount.Remittance_Instruction_2__c != newAccount.Remittance_Instruction_2__c ||
        oldAccount.Remittance_Instruction_3__c != newAccount.Remittance_Instruction_3__c ||
        oldAccount.Remittance_Instruction_4__c != newAccount.Remittance_Instruction_4__c ||
        oldAccount.Payment_Preference__c != newAccount.Payment_Preference__c) {
      updateCheck = true;
    }

    if (updateCheck) {
      newAccount.Last_ACH_Update__c = Date.Today();
    }
  }

  public void validRoutingNumberUpdate (Account a) {
    a.Valid_Routing__c = 'N/A';

    if (a.Payment_Preference__c == 'ACH (Direct Deposit)' && a.TransitNumber__c != null && a.BillingCountry == 'CA') {
      String transitNumber = String.valueOf(a.TransitNumber__c);
      transitNumber = transitNumber.replaceAll(' ', '');
      transitNumber = transitNumber.replaceAll('-', '');

      if (transitNumber.length() == 8) {
        String routingNumber = '0';
        routingNumber += String.valueOf(transitNumber.substring(5, 6));
        routingNumber += String.valueOf(transitNumber.substring(6, 7));
        routingNumber += String.valueOf(transitNumber.substring(7, 8));
        routingNumber += String.valueOf(transitNumber.substring(0, 1));
        routingNumber += String.valueOf(transitNumber.substring(1, 2));
        routingNumber += String.valueOf(transitNumber.substring(2, 3));
        routingNumber += String.valueOf(transitNumber.substring(3, 4));
        routingNumber += String.valueOf(transitNumber.substring(4, 5));
        a.Routing_Number_enc__c = routingNumber;
      }
    }

    Boolean validAch = false;

    if (a.Payment_Preference__c == 'ACH (Direct Deposit)' && a.TransitNumber__c == null && a.Routing_Number_enc__c != null && a.BillingCountry == 'US') {
      String routingNumber = String.valueOf(a.Routing_Number_enc__c);
      if (routingNumber.length() == 9) {
        Integer var1 = Integer.valueOf(routingNumber.substring(0, 1));
        Integer var2 = Integer.valueOf(routingNumber.substring(1, 2));
        Integer var3 = Integer.valueOf(routingNumber.substring(2, 3));
        Integer var4 = Integer.valueOf(routingNumber.substring(3, 4));
        Integer var5 = Integer.valueOf(routingNumber.substring(4, 5));
        Integer var6 = Integer.valueOf(routingNumber.substring(5, 6));
        Integer var7 = Integer.valueOf(routingNumber.substring(6, 7));
        Integer var8 = Integer.valueOf(routingNumber.substring(7, 8));
        Integer var9 = Integer.valueOf(routingNumber.substring(8, 9));

        Integer checkSum = ((var1*3) + (var2*7) + (var3*1) + (var4*3) + (var5*7) + (var6*1) + (var7*3) + (var8*7) + (var9*1));
        system.debug('Checksum Value: ' + checkSum);

        Integer remainder = Math.mod(checksum, 10);
        system.debug('Remainder Value: ' + remainder);
        if (checksum != 0 && remainder == 0 && Integer.valueOf(routingNumber.substring(0, 1)) != 5) {
          validAch = true;
        }
      }
    }
    
    if (validACH == true) {
      a.Valid_routing__c = 'Yes';
    } else if (a.Payment_Preference__c=='ACH (Direct Deposit)' && a.routing_number_enc__c != '' && a.BillingCountry == 'US') {
      a.Valid_routing__c = 'No';
    } else {
      a.Valid_Routing__c = 'N/A';
    }
  }
}