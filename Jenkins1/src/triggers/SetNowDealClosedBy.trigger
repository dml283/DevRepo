trigger SetNowDealClosedBy on Account (before update)
{

  for(account a : trigger.new)
    {   
     if(a.now_deal_closed_by__c==null && a.now_status__c =='closed won' && a.now_deal_owner__c != null )    
        {
            a.now_deal_closed_by__c = a.now_deal_owner__c;

        }
    }

}