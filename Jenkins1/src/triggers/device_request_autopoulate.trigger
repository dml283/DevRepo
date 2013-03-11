trigger device_request_autopoulate on Device_Request__c (before insert,before update) 

{
    //we need to create a set to store the ids of all Devier Requests in this trigger instance
    set<id> idSet = new set<id>();
    //now lets populate the set with th IDs of either the NOW or the Opportunity
    for(device_request__c d : trigger.new)
        {
            if(d.Groupon_Now__c !=null)
                idSet.add(d.Groupon_Now__c);
            if(d.opportunity__c !=null)
                idSet.add(d.opportunity__c);   
        }
    
    //create a map to hold the key:pair of the related device request and the Account id
    map<id,id> idMap = new map<id,id>();
    
    //lets get all of the opptys that were included with a device request
    list<opportunity> olist = [select id, AccountId from Opportunity where id in:idSet];
    
    //populate the map with the opportunity ID and the Account ID
    for(opportunity o :olist)
        {
            idMap.put(o.id,o.AccountId);
        }
    
    //now we need to get all of the Groupon NOW records that have a device request related to them and the account id    
    list<GrouponNow__c> nowList = [select id, Account_Name__c from GrouponNow__c where id in:idSet];
    //populate the id:id map with the Groupon NOW record ID and the Account ID
    for(GrouponNow__c g: nowList)
        {
            idMap.put(g.id,g.Account_Name__c);
        }    
    //now that we have our data prepared we can start working with the device request obj
    for(device_request__c d : trigger.new)
    {      
          //if its null, we should use the idMap and get the Account ID
          if(d.Groupon_NOW__c != null)
          {            
             d.Account__c = idMap.get(d.Groupon_Now__c);
          }else if
              (d.opportunity__c != null)
                      {  
                         d.Account__c = idMap.get(d.opportunity__c);
                      } 
          
     }

}