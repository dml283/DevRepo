public with sharing class NetSuiteCreationWorkflow implements TriggerWorkflow 
{
    Map<ID, Opportunity> newMap;
    Map<ID, Opportunity> oldMap;
    public Boolean calloutToNetSuiteCreateDone {get; private set;}
    
    public NetSuiteCreationWorkflow(Map<ID, Opportunity> newMap, Map<ID, Opportunity> oldMap)
    {
        this.newMap = newMap;
        this.oldMap = oldMap;
        this.calloutToNetSuiteCreateDone = false;
    }
    
    public static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} set;}
    //business logic
    public void execute()
    {
        if(!hasExecuted)
        {
            for(Opportunity oppty: newMap.values())
                sendToNetSuite(oppty);
        }   
    }
    
    public void sendToNetsuite(Opportunity o) 
    {
      System.debug('*CREATION WORKFLOW: sendToNetsuite call');
      Opportunity newOppty = newMap.get(o.Id);
      Opportunity oldOppty = oldMap.get(o.Id);
      System.debug('\n\nnewOppty.Fulfillment_Method__c ='+fulfillmentMethods+'\n\n');
      System.debug('\n\nFulfillment_Method__c =Drop ship (Groupon small parcel)\n\n');
      SYstem.debug('\n\nnew stagename = '+newOppty.StageName+'\n\n');
      SYstem.debug('\n\nold stagename = '+oldOppty.StageName+'\n\n');
      if (newOppty != null && 
          oldOppty != null &&
          newOppty.StageName != oldOppty.StageName &&
          fulfillmentMethods.contains(newOppty.Fulfillment_Method__c) &&
          newOppty.StageName == Constants.OPPORTUNITY_STAGE_DEAL_STRUCTURE_APPROVED &&
          newOppty.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get(Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GOODS)
          
      ) 
      {
      	hasExecuted = true;
      	if(Test.isRunningTest())
      	{
      		this.calloutToNetSuiteCreateDone = true;
      	}
      	else
      	{
      		System.debug('*CREATION WORKFLOW: createNSPOI call');
	        NetsuiteCreate.createNSPOI(o.Id);
	        System.debug('*CREATION WORKFLOW: addOpportunity call');
	        NetsuiteCreate.addOpportunity(o.Id);
      	}
      } 
    } 
    
    private Set<String> fulfillmentMethods
    {
        get
        {
            if(fulfillmentMethods == null)
            {
                fulfillmentMethods = new Set<String>();
                fulfillmentMethods.add(Constants.FULFILLMENT_METHOD_DROP_SHIP_SUPPLIER_SMALL_PARCEL);
                fulfillmentMethods.add(Constants.FULFILLMENT_METHOD_DROP_SHIP_GROUPON_SMALL_PARCEL);
                fulfillmentMethods.add(Constants.FULFILLMENT_METHOD_POST_DEAL_PURCHASE_3PL);
                fulfillmentMethods.add(Constants.FULFILLMENT_METHOD_PRE_DEAL_PURCHASE_3PL);
            }
            
            return fulfillmentMethods;
        }
        
        set;
    } 
}