trigger ValidateExpiry on Purchase_Order__c (before update) {

    map<id,Purchase_Order__c>oldPOstatus = new map<id,Purchase_Order__c>();
    map<id,Purchase_Order__c>newPOstatus = new map<id,Purchase_Order__c>();
    
    for(Purchase_Order__c prevPO : trigger.old)
        {
            oldPOstatus.put(prevPO.id,prevPO);
        }
    
    for(Purchase_Order__c currentPO : trigger.new)
        {
            newPOstatus.put(currentPO.id,currentPO);
        }
        
    for(Purchase_Order__c po:trigger.new)
        {
            Purchase_Order__c oldPO = oldPOstatus.get(po.id);
            Purchase_Order__c newPO = newPOstatus.get(po.id);
            
            if(oldPO.PO_Status__c=='Approved' && newPO.PO_Status__c=='Expired')
                {
                    po.PO_Status__c='Approved';
                } 
        }
}