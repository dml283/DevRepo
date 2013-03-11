trigger HotLeadsTrigger_Events on Event (after insert, after update) {
    //Define sets for leads and accounts to be updated
    List<Event> outboundEventsInTrigger = new List<Event>();
    Set<Id> outboundLeadsInTrigger = new Set<Id>();
    Set<Id> outboundAcctsInTrigger = new Set<Id>();
    Set<Id> outboundContactsInTrigger = new Set<Id>();
    Map<Id,Event> oldEvent = new map<Id,Event>();

    if(trigger.isUpdate) {  
        for(Event EventOld : trigger.old) {                     
            oldEvent.put(EventOld.id, EventOld);              
        }
    }

    //Retrieve the Outbound Activities in the trigger based on Type. Only include when created or when updated and Type is changed
    outboundEventsInTrigger = [select id, WhoId, WhatId, Type from Event where (Type = 'Merchant Call' OR Type = 'Merchant Meeting') AND Id IN :Trigger.new];

    //Determine if the outbound task in on a lead or account and add to the related set
    for (event e :outboundEventsInTrigger ) {
        if(Trigger.isInsert || (Trigger.isUpdate && oldEvent.get(e.Id).Type != e.Type)) {
                    /*if(e.whoid!=null) {
                            String eventWhoId = e.whoid;
                            
                                   
                            if(eventWhoId.substring(0,3)=='00Q') {
                                    Id outboundLeadId = e.WhoId;
                                    outboundLeadsInTrigger.add(outboundLeadId);
                            }
                                    
                            if(eventWhoId.substring(0,3)=='003') {
                                    Id outboundContactId = e.WhoId;
                                    outboundContactsInTrigger.add(outboundContactId);
                            }
                    }*/
                                            
                    if(e.whatid!=null) {
                            String eventWhatId = e.whatid;
                                                            
                            if(eventWhatId.substring(0,3)=='001') {
                                    Id outboundAccountId = e.WhatId;
                                    outboundAcctsInTrigger.add(outboundAccountId);
                            }
                    }
                }
     }
            
    //for(Contact c : [SELECT Id, Account.Id FROM Contact WHERE Id IN: outboundContactsInTrigger]) {
    //    outboundAcctsInTrigger.add(c.Account.Id);
    //}
            
    HotLeads.UpdateOutboundAcct(outboundAcctsInTrigger);
    //HotLeads.UpdateOutboundLead(outboundLeadsInTrigger);

}