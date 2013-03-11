global class ACHUpdateDate {
//Waiting to Delete
/*
    public static void populateLastACHUpdate(List<Account> accountsInTrigger, Map<Id,Account> triggerNewMap, Map<Id,Account> triggerOldMap) {
        for (Account newAccount : accountsInTrigger) {
          Account oldAccount = triggerOldMap.get(newAccount.Id);
    
          Boolean updateCheck = false;
    
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
            oldAccount.Beneficiary_Bank_Account_Number__c !=newAccount.Beneficiary_Bank_Account_Number__c ||
            oldAccount.Beneficiary_Bank_Address_1__c !=newAccount.Beneficiary_Bank_Address_1__c ||
            oldAccount.Beneficiary_Bank_Address_2__c !=newAccount.Beneficiary_Bank_Address_2__c ||
            oldAccount.Beneficiary_Bank_Address_3__c !=newAccount.Beneficiary_Bank_Address_3__c ||
            oldAccount.Beneficiary_Bank_Address_4__c !=newAccount.Beneficiary_Bank_Address_4__c ||
            oldAccount.Beneficiary_Bank_Name__c !=newAccount.Beneficiary_Bank_Name__c ||
            oldAccount.Beneficiary_Bank_Routing_Number__c !=newAccount.Beneficiary_Bank_Routing_Number__c ||
            oldAccount.Beneficiary_Bank_Sort_Code__c !=newAccount.Beneficiary_Bank_Sort_Code__c ||
            oldAccount.Beneficiary_Bank_Swift_Code__c !=newAccount.Beneficiary_Bank_Swift_Code__c ||
            oldAccount.Intermediate_Bank_Name__c !=newAccount.Intermediate_Bank_Name__c ||
            oldAccount.Intermediate_Bank_Routing_Number__c !=newAccount.Intermediate_Bank_Routing_Number__c ||
            oldAccount.Intermediate_Bank_Swift_Code__c !=newAccount.Intermediate_Bank_Swift_Code__c ||
            oldAccount.Intermediate_Bank_Address_1__c !=newAccount.Intermediate_Bank_Address_1__c ||
            oldAccount.Intermediate_Bank_Address_2__c !=newAccount.Intermediate_Bank_Address_2__c ||
            oldAccount.Intermediate_Bank_Address_3__c !=newAccount.Intermediate_Bank_Address_3__c ||
            oldAccount.Intermediate_Bank_Address_4__c !=newAccount.Intermediate_Bank_Address_4__c ||
            oldAccount.Remittance_Instruction_1__c !=newAccount.Remittance_Instruction_1__c ||
            oldAccount.Remittance_Instruction_2__c !=newAccount.Remittance_Instruction_2__c ||
            oldAccount.Remittance_Instruction_3__c !=newAccount.Remittance_Instruction_3__c ||
            oldAccount.Remittance_Instruction_4__c !=newAccount.Remittance_Instruction_4__c ||
            oldAccount.Payment_Preference__c != newAccount.Payment_Preference__c) {
            updateCheck = true;
          }
    
          if (updateCheck) {
            newAccount.Last_ACH_Update__c = Date.Today();
          }
    }
    }
*/
}