global class HotLeads {
    //Update Phone Bank Call Date on Accounts
    public static void UpdatePhoneBankAcct(Set<Id> inboundAcctsInTrigger) {
        List<Account> inboundAcctsToUpdate = new List<Account>();
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            for(Account a: [SELECT Id FROM Account WHERE Id IN: inboundAcctsInTrigger]) {
                inboundAcctsToUpdate.add(a);
            }
        }

        for(Account a: inboundAcctsToUpdate) {
            Date phoneBankDate = system.today();
            a.Last_Phone_Bank_Call_Date__c = phoneBankDate;
        }
        Database.SaveResult[] lsr = Database.update(inboundAcctsToUpdate,false);
    }

    //Update Phone Bank Call Date on Leads
    public static void UpdatePhoneBankLead(Set<Id> inboundLeadsInTrigger) {
        List<Lead> inboundLeadsToUpdate = new List<Lead>();
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            for(Lead l: [SELECT Id FROM Lead WHERE Id IN: inboundLeadsInTrigger]) {
                inboundLeadsToUpdate.add(l);
            }
        }
        
        for(Lead l: inboundLeadsToUpdate) {
            Date phoneBankDate = system.today();
            l.Last_Phone_Bank_Call_Date__c = phoneBankDate;
        }        
        Database.SaveResult[] lsr1 = Database.update(inboundLeadsToUpdate,false);
    }

    //Update Hot Lead Status on Accounts
    public static void UpdateOutboundAcct(Set<Id> outboundAcctsInTrigger) {
        List<Account> outboundAcctIds = new List<Account>();
        List<Account> outboundAcctsToUpdate = new List<Account>();
        
        if(Limits.getQueries() < Limits.getLimitQueries()) {
            for(Account a: [SELECT Id, Date_of_Hotness__c FROM Account WHERE Date_of_Hotness__c != null AND Id IN: outboundAcctsInTrigger]) {
                if((a.Date_of_Hotness__c.addDays(+10) >= system.today()) && (system.today() >= a.Date_of_Hotness__c)) {
                    a.Hot_Lead_Result__c = 'Contacted While Hot';
                    a.Hot_Lead__c = 'Previously Hot';
                    outboundAcctsToUpdate.add(a);
                }
            }
        } 
        Database.SaveResult[] lsr2 = Database.update(outboundAcctsToUpdate,false);
    }
/*
    //Update Hot Lead Status on Leads
    public static void UpdateOutboundLead(Set<Id> outboundLeadsInTrigger) {
        List<Lead> outboundLeadIds = new List<Lead>();
        List<Lead> outboundLeadsToUpdate = new List<Lead>();
        for(Lead l: [SELECT Id, Date_of_Hotness__c FROM Lead WHERE Date_of_Hotness__c != null AND Id IN: outboundLeadsInTrigger]) {
            if((l.Date_of_Hotness__c.addDays(+10) >= system.today()) && (system.today() >= l.Date_of_Hotness__c)) {
                l.Hot_Lead_Result__c = 'Contacted While Hot';
                l.Hot_Lead__c = 'Previously Hot';
                outboundLeadsToUpdate.add(l);
            }
        }
        Database.SaveResult[] lsr3 = Database.update(outboundLeadsToUpdate ,false);
    }
*/
}