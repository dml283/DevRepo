trigger masterPinnedMerchanttrigger on PinnedMerchant__c (after update, after insert, after delete) 
{
    List<Id>                    poInfo            = new List<Id>();
    List<Purchase_order__c>     poRelatedToPinned = new List<Purchase_order__c>();
    Set<Id>     acctRelatedToPinned = new Set<Id>();
    Set<Id>     leadRelatedToPinned = new Set<Id>();
    List<Account>     accountsToUpdate = new List<Account>();
    List<Lead>     leadsToUpdate = new List<Lead>();
    Aggregateresult[]           Agg               = new aggregateresult[]{}; 
    map<id,aggregateResult>     POMap             = new map <id,aggregateResult>();
    List<pinnedmerchant__c>     pinnedInfo        = new List<Pinnedmerchant__c>();
    decimal                     accountranking    = 0;
    //check the condition after the pinned merchant is updated/Inserted.
     if(Trigger.isAfter) 
     {
      //Check if we are doing an new Pinned Merchant Insert.
        if(Trigger.isInsert) 
        {
            //1) Get the POinfo realted to the current Pinnedmerchant being edited.
            for(pinnedmerchant__c Pinned : Trigger.new)
            {
                    poInfo.add(Pinned.purchase_order__c);
                    if(Pinned.Account__c != null && Pinned.Account__r.Pinned__c != True)
                        {
                            acctRelatedToPinned.add(Pinned.Account__c);
                        }
                    if(Pinned.Lead__c != null && Pinned.Lead__r.Pinned__c != True)
                        {
                            leadRelatedToPinned .add(Pinned.Lead__c);
                        }
            }
        }
       //Check if we are editing a PO 
         if(Trigger.isUpdate) 
        {
           //If the PO is null and a new value is updated enter the loop below.
            for(pinnedmerchant__c Pinned : Trigger.new)
            {
                if(Pinned.purchase_order__c != null)
                {          
                        poInfo.add(Pinned.purchase_order__c);
                }
            }
            //If the PO had a value and the user is clearing the PO value then enter the loop below.
             for(pinnedmerchant__c Pinned : Trigger.old)
            {
                if(Pinned.purchase_order__c != null)
                {          
                        poInfo.add(Pinned.purchase_order__c);
                }
            }
        }
     }     
     //check the condition before the pinned merchant is deleted.
      if(Trigger.isafter) 
     {
        if(Trigger.isdelete) 
        {
        system.debug('Entering Delete Loop');
            //1) Get the POinfo realted to the current Pinnedmerchant being edited.
            for(pinnedmerchant__c Pinned : Trigger.old)
            {
                    poInfo.add(Pinned.purchase_order__c);
            }
        }
     }       
//From the above conditions we generate the PO Info.
            if(poInfo.size() > 0)
            {
                Agg  = [select purchase_order__c poId, count(Id) countval from pinnedmerchant__c  where (purchase_order__c!=null and purchase_order__c IN: poInfo and  Id!= null) GROUP BY purchase_order__c ];
                pinnedInfo        = [select opportunity__r.account.research_ranking__c,Lead__r.research_ranking__c,account__r.research_ranking__c from pinnedmerchant__c where purchase_order__c IN: poInfo and Id!= null];
                poRelatedToPinned = [select id,Merchant_Count__c,Research_Ranking_account__c from Purchase_order__c where Id IN: poInfo and Id!= null FOR UPDATE ];                
            }
//From the aggreagate result find the Merchant Count related to the PO.
            for(Aggregateresult a : Agg)
            {
            POMap.put((Id)a.get('poId'),a);
            }
//From the Pinned merchant Info find the research ranking value on Account.
            for(pinnedmerchant__c pin : pinnedInfo)        
            {
                 if(pin.opportunity__r.account.research_ranking__c != null)
                 {
                    accountranking += decimal.valueof(pin.opportunity__r.account.research_ranking__c);
                 }
                  else if(pin.Lead__r.research_ranking__c != null)
                 {
                    accountranking += decimal.valueof(pin.Lead__r.research_ranking__c);
                 }
                 else if(pin.account__r.research_ranking__c != null)
                 {
                    accountranking += decimal.valueof(pin.account__r.research_ranking__c);
                 }
           
            }
            
//If there is atleast one PO realted to the pinned merchant then update the count on the PO and the reserch ranking related to the account.
            if(poRelatedToPinned.size()>0)
            {
                for(purchase_order__c poList : poRelatedToPinned)
                {
                    aggregateResult ar = POMap.get(poList.id);
                    if(ar!=null)
                    {
                    poList.Merchant_Count__c            = (decimal)ar.get('countval');
                    poList.Research_Ranking_account__c  =  accountranking/poList.Merchant_Count__c ;
                    }
                }

                update poRelatedToPinned;
            }
            
//Mark the leads and accounts related to Pinned Merchants as Pinned
    if(trigger.isinsert)
        {   
                     
            for(lead l : [select Id, Pinned__c from Lead where Id IN : leadRelatedToPinned]){
                    l.Pinned__c = True;
                    leadsToUpdate.add(l);
                }
            
            for(account a : [select Id, Pinned__c from Account where Id IN : acctRelatedToPinned]){
                    a.Pinned__c = True;
                    accountsToUpdate.add(a);
                }

            update leadsToUpdate;
            update accountsToUpdate;
        }
   
}