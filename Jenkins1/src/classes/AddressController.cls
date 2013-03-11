public without sharing class AddressController {
        
        public List<AddressCoupler> addyList {get; set;}
        private Id defaultAccountId;
        private Id ctrlId;
        
        public AddressController(ApexPages.StandardController ctrl) {
                addyList = new List<AddressCoupler>();
                ctrlId = ctrl.getID();
                defaultAccountId = [SELECT AccountId FROM Opportunity WHERE Id = :ctrlId LIMIT 1].AccountId;            
                buildCouplingList([SELECT Id, Venue_Name__c, Phone_Number__c, Full_Address__c, Name, Account__c, City__c, Opportunity__c, State__c, Street_Line_1__c, Street_Line_2__c, Country__c, Zip_Postal_Code__c, Account__r.Name, Subdivision__c FROM Address__c WHERE Opportunity__c = :ctrl.getID()]);
        }
        
        private void buildCouplingList(List<Address__c> aList) {
                AddressCoupler tempAc = null;
                for(AddressCoupler ac : addyList) {
                        if(ac.addy.Id == null && !ac.selected) {
                                tempAc = ac;
                        }
                }
                
                addyList.clear();
                
                if(tempAc != null) {
                        addyList.add(tempAc);
                }
                
                for(Address__c a : aList) {
                        addyList.add( new AddressCoupler(a) );
                }
                
                if(addyList.size() == 0) {
                        addyList.add(new AddressCoupler(new Address__c(Opportunity__c = ctrlId, Account__c = defaultAccountId)));
                }               
        }
        
        private List<Address__c> separateCoupling() {
                List<Address__c> aList = new List<Address__c>();
                
                for(AddressCoupler ac : addyList) {
                        aList.add(ac.addy);
                }
                
                return aList;
        }
        
        public PageReference deleteSelected() {
                List<Address__c> aList = new List<Address__c>();
                
                for(AddressCoupler ac : addyList) {
                        if(ac.selected && ac.addy.Id != null) {
                                aList.add(ac.addy);
                        }
                }
                try {
                        delete aList;
                } catch (Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
                buildCouplingList([SELECT Id, Venue_Name__c, Phone_Number__c, Full_Address__c, Name, Account__c, City__c, Opportunity__c, State__c, Street_Line_1__c, Street_Line_2__c, Country__c, Zip_Postal_Code__c, Account__r.Name, Subdivision__c FROM Address__c WHERE Opportunity__c = :ctrlId]);       
                return null;
        }
        
        public PageReference addAddress() {
                Boolean addable = true;
                
                for(AddressCoupler anAddy : addyList) {
                        if(anAddy.addy.Id == null) {
                                addable = false;
                        }
                }
                
                if(addable) {
                        addyList.add(0, new AddressCoupler(new Address__c(Opportunity__c = ctrlId, Account__c = defaultAccountId)));
                } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is already a new redemption address.'));
                }
                return null;
        }
        
        public PageReference saveAddresses() {
                try {
                        upsert separateCoupling();
                        buildCouplingList([SELECT Id, Venue_Name__c, Phone_Number__c, Full_Address__c, Name, Account__c, City__c, Opportunity__c, State__c, Street_Line_1__c, Street_Line_2__c, Country__c, Zip_Postal_Code__c, Account__r.Name, Subdivision__c FROM Address__c WHERE Opportunity__c = :ctrlId]);
                } catch(DMLException de) {
                        
                }
                                
                return null;
        }
        
        public class AddressCoupler {
                public Boolean selected {get; set;}
                public Address__c addy {get; set;}
                
                public AddressCoupler(Address__c theAddy) {
                        selected = false;
                        addy = theAddy;
                }
        }
        
}