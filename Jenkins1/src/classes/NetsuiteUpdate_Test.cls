@isTest(seeAllData=true)
public class NetsuiteUpdate_Test{

  //Relates an account and a netsuite purchase order information object
  //to an opportunity and sets essential fields on all three objects
  static void setRequiredFields(Opportunity opportunity, Netsuite_Purchase_Order_Info__c nspoi){
    Account account = new Account();
    account.name = 'Test Account, Inc.';  
    insert account;
    
    opportunity.name = 'Test Opportunity'; 
    opportunity.accountID = account.id; 
    opportunity.stageName = 'Deal Structure Approved'; 
    opportunity.closeDate = date.newInstance(2012, 12, 15); 
    insert opportunity;
    
    nspoi.opportunity__c = opportunity.ID;
    insert nspoi;
  }

  //Generates request and sends to to /netsuite/update
  static void sendUpdateRequest(ID opportunityID){
    System.RestContext.request = new RestRequest();
    RestContext.request.requestURI = '/netsuite/update';
    RestContext.request.requestBody = blob.ValueOf('[{' +
      '"po_es_status" : "Test status",' +
      '"internalid" : "01234",' +  
      '"tranid" : "PO_USGG006c0000002tQLeAAM",' + 
      '"custbody_po_sf_opp_id" : "' + opportunityID + '",' +
      '"po_es_error_code" : "No error",' +
      '"po_create_datetime" : "09012012131059",' +
      '"po_update_datetime" : "09022013011059",' +  
      '"echosign_link" : "echosignlink.com"}]');
    NetsuiteUpdate.doPost();
  }

  //Tests that fields are correctly set when the call is the first from 
  //Netsuite (the first call will initialize more fields)
  static testMethod void testInitialPOST(){
    //Set up for opportunity, account and netsuite purchase order
    Opportunity opportunity = new Opportunity();
    Netsuite_Purchase_Order_Info__c nspoi = new netsuite_purchase_order_info__c(); 
    setRequiredFields(opportunity, nspoi); 
    
    sendUpdateRequest(opportunity.ID);
   
    //Retrieve purchase order and check fields 
    Netsuite_Purchase_Order_Info__c nspoiUpdated = [SELECT id, echosign_link__c,
      netsuite_po_es_message__c, netsuite_po_number__c, netsuite_internal_id__c,  
      netsuite_po_es_status__c, netsuite_po_create_date_time__c 
      FROM netsuite_purchase_order_info__c WHERE opportunity__c =: opportunity.ID]; 
     
    System.assertEquals('Test status', nspoiUpdated.netsuite_po_es_status__c); 
    System.assertEquals('01234', nspoiUpdated.netsuite_internal_ID__c);
    System.assertEquals('echosignlink.com', nspoiUpdated.echosign_link__c);
    System.assertEquals('No error', nspoiUpdated.netsuite_po_es_message__c);  
    System.assertEquals('PO_USGG006c0000002tQLeAAM', nspoiUpdated.netsuite_po_number__c);
     
  }
  
  //Tests that fields that would have already been initialized in the first call
  //aren't overwritten
  static testMethod void testUpdatePost(){
    //Set up for opportunity, account and netsuite purchase order
    Opportunity opportunity = new Opportunity();
    Netsuite_Purchase_Order_Info__c nspoi = new netsuite_purchase_order_info__c(); 
    setRequiredFields(opportunity, nspoi); 
    
    nspoi.netsuite_po_number__c = 'PO_USGG006c0000002tQLeAAN'; 
    update nspoi; 
    
    sendUpdateRequest(opportunity.ID); 

    //Retrieve purchase order and check fields 
    Netsuite_Purchase_Order_Info__c nspoiUpdated = [SELECT id, netsuite_po_number__c 
      FROM netsuite_purchase_order_info__c WHERE opportunity__c =: opportunity.ID]; 
     
    System.assertEquals('PO_USGG006c0000002tQLeAAN', nspoiUpdated.netsuite_po_number__c);
  }
}