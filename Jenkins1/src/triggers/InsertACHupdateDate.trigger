trigger InsertACHupdateDate on Account (before update) { 
   
    map<id,account> oldMap = new map<id,account>();
    map<id,account> newMap = new map<id,account>();
    for(Account acctOld : trigger.old)
        {                     
                oldMap.put(acctOld.id, acctOld);              
        }
    for(account acctNew : trigger.new)
        {     
                newMap.put(acctNew.id, acctNew);              
        }
        
    for(account a :trigger.new)
        {
            boolean updateCheck = false;
            account oldA = oldMap.get(a.id);
            account newA = newMap.get(a.id);            
                       
            if(oldA.Routing_Number_enc__c != null && newA.Routing_Number_enc__c != null){
                    if(oldA.Routing_Number_enc__c != newA.Routing_Number_enc__c){
                            updateCheck = true;
                        }
                }
               
            if(oldA.Account_Number__c != null && newA.Account_Number__c != null){
                    if(oldA.Account_Number__c != newA.Account_Number__c){
                            updateCheck = true;
                        }
                }
            
            if(oldA.BillingStreet != newA.BillingStreet){
                    updateCheck = true;
                }
                         
            if(oldA.BillingCity != newA.BillingCity){
                    updateCheck = true;
                }
                
            if(oldA.BillingState != newA.BillingState){
                    updateCheck = true;
                }
                
            if(oldA.BillingPostalCode != newA.BillingPostalCode){
                    updateCheck = true;
                }
                
            if(oldA.BillingCountry != newA.BillingCountry){
                    updateCheck = true;
                }
                
            if(oldA.Make_Checks_Payable_To__c != newA.Make_Checks_Payable_To__c){
                    updateCheck = true;
                }
                  if(oldA.Beneficiary_Bank_Account_Number__c !=newA.Beneficiary_Bank_Account_Number__c){
                    updateCheck = true;
                    }
                    
                    if(oldA.Beneficiary_Bank_Address_1__c !=newA.Beneficiary_Bank_Address_1__c){
                    updateCheck = true;
                    }
                     if(oldA.Beneficiary_Bank_Address_2__c !=newA.Beneficiary_Bank_Address_2__c){
                    updateCheck = true;
                    }
                     if(oldA.Beneficiary_Bank_Address_3__c !=newA.Beneficiary_Bank_Address_3__c){
                    updateCheck = true;
                    }
                     if(oldA.Beneficiary_Bank_Address_4__c !=newA.Beneficiary_Bank_Address_4__c){
                    updateCheck = true;
                    }
                     if(oldA.Beneficiary_Bank_Name__c !=newA.Beneficiary_Bank_Name__c){
                    updateCheck = true;
                    }
                    if(oldA.Beneficiary_Bank_Routing_Number__c !=newA.Beneficiary_Bank_Routing_Number__c){
                    updateCheck = true;
                    }
                    if(oldA.Beneficiary_Bank_Sort_Code__c !=newA.Beneficiary_Bank_Sort_Code__c){
                    updateCheck = true;
                    }
                    if(oldA.Beneficiary_Bank_Swift_Code__c !=newA.Beneficiary_Bank_Swift_Code__c){
                    updateCheck = true;
                    }
                    
                    
                    
                    if(oldA.Intermediate_Bank_Name__c !=newA.Intermediate_Bank_Name__c){
                    updateCheck = true;
                    }
                    if(oldA.Intermediate_Bank_Routing_Number__c !=newA.Intermediate_Bank_Routing_Number__c){
                    updateCheck = true;
                    }
                    if(oldA.Intermediate_Bank_Swift_Code__c !=newA.Intermediate_Bank_Swift_Code__c){
                    updateCheck = true;
                    }
                    
                    
                    
                    
                    
                    
                     if(oldA.Intermediate_Bank_Address_1__c !=newA.Intermediate_Bank_Address_1__c){
                    updateCheck = true;
                    }
                    if(oldA.Intermediate_Bank_Address_2__c !=newA.Intermediate_Bank_Address_2__c){
                    updateCheck = true;
                    }
                    if(oldA.Intermediate_Bank_Address_3__c !=newA.Intermediate_Bank_Address_3__c){
                    updateCheck = true;
                    }
                    if(oldA.Intermediate_Bank_Address_4__c !=newA.Intermediate_Bank_Address_4__c){
                    updateCheck = true;
                    }
                     if(oldA.Remittance_Instruction_1__c !=newA.Remittance_Instruction_1__c){
                    updateCheck = true;
                    }
                    if(oldA.Remittance_Instruction_2__c !=newA.Remittance_Instruction_2__c){
                    updateCheck = true;
                    }
                    if(oldA.Remittance_Instruction_3__c !=newA.Remittance_Instruction_3__c){
                    updateCheck = true;
                    }
                    if(oldA.Remittance_Instruction_4__c !=newA.Remittance_Instruction_4__c){
                    updateCheck = true;
                    }          
            if(oldA.Payment_Preference__c != newA.Payment_Preference__c){
                    updateCheck = true;
                }
            
            if(updateCheck){
                    a.Last_ACH_Update__c = Date.Today();
                }      
        }                                             
}