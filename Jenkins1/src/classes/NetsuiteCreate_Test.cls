@isTest(seeAllData=true)
public class NetsuiteCreate_Test{

  //Relates an opportunity to account and sets essential fields on both
  //the opportunity and the account
  static void setRequiredFields(Account account, Opportunity opportunity){
    account.name = 'Test Account, Inc.';  
    insert account;
    
    opportunity.name = 'Test Opportunity'; 
    opportunity.accountID = account.id; 
    opportunity.stageName = 'Deal Structure Approved'; 
    opportunity.closeDate = date.newInstance(2012, 12, 15); 
    insert opportunity;
  }

  //Tests that the Netsuite_Purchase_Order_Information object is created on the 
  //opportunity
  static testMethod void testNspoiCreation(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
    
    Test.startTest();
    NetsuiteCreate.createNSPOI(opportunity.id);  
    NetsuiteCreate.addOpportunity(opportunity.id);
    
    Test.stopTest();   
    
    List<Netsuite_Purchase_Order_Info__c> nspois = [SELECT id
      FROM netsuite_purchase_order_info__c WHERE opportunity__c =: opportunity.ID]; 
      
    System.assert(!nspois.isEmpty()); 
  }
  
  //Tests that the internalID is set to empty when there isn't one
  static testMethod void testGetInternalIDNull(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
        
    Test.startTest(); 
    NetsuiteCreate.createNSPOI(opportunity.id); 
    Test.stopTest();
    
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>) JSON.deserializeUntyped(body);
    Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1'); 
    Map<String, Object> purchaseOrder = (Map<String, Object>) opp.get('po');
    
    System.debug('OPP OBJECT' + opp); 
    
    System.assertEquals(purchaseOrder.get('internalid'), ''); 
  }
  
  //Tests that the internalID is correctly set when it exists
  static testMethod void testGetInternalID(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
    
    Netsuite_Purchase_Order_Info__c nspoi = new Netsuite_Purchase_Order_Info__c();
    nspoi.account__c = account.id;
    nspoi.opportunity__c = opportunity.id;
    nspoi.netsuite_internal_ID__c = '46762'; 
    insert nspoi; 
    
    Test.startTest(); 
    NetsuiteCreate.createNSPOI(opportunity.id);  
    Test.stopTest();   
    
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>)JSON.deserializeUntyped(body);
     Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1'); 
    Map<String, Object> purchaseOrder =(Map<String, Object>) opp.get('po');
    
    System.assertEquals(purchaseOrder.get('internalid'), '46762'); 
  }
  
  //Tests that the tranID is correctly set when it exists
  static testMethod void testGetTranId(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
    
    Netsuite_Purchase_Order_Info__c nspoi = new Netsuite_Purchase_Order_Info__c();
    nspoi.account__c = account.id;
    nspoi.opportunity__c = opportunity.id;
    nspoi.netsuite_po_number__c = 'PO_USGG006c0000002tQLeAAM'; 
    insert nspoi; 
        
    Test.startTest();
    NetsuiteCreate.createNSPOI(opportunity.id);  
    Test.stopTest();   
    
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>) JSON.deserializeUntyped(body);
     Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1'); 
    Map<String, Object> purchaseOrder = (Map<String, Object>) opp.get('po');
    
    System.assertEquals(purchaseOrder.get('tranid'), 'PO_USGG006c0000002tQLeAAM'); 
  }
  
  //Tests that the tranID is set to empty when there isn't one
  static testMethod void testGetTranIdNull(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
        
    Test.startTest();
    NetsuiteCreate.createNSPOI(opportunity.id);  
    Test.stopTest();   
    
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>)JSON.deserializeUntyped(body);
     Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1'); 
    Map<String, Object> purchaseOrder =(Map<String, Object>) opp.get('po');
    
    System.assertEquals(purchaseOrder.get('tranid'), ''); 
  }
  
  //Tests that the primaryContactEmail is correctly retrieved and set
  static testMethod void testGetPrimaryContactEmail(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 

    Contact contact = new Contact();
    contact.email = 'test@email.com';
    contact.accountID = account.ID; 
    contact.firstName = 'Test'; 
    contact.lastName = 'Person';
    insert contact; 
    
    OpportunityContactRole ocr = new OpportunityContactRole(); 
    ocr.opportunityID = opportunity.id;
    ocr.contactID = contact.id; 
    ocr.isPrimary = TRUE; 
    insert ocr;
   
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>)JSON.deserializeUntyped(body);
    Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1');
    Map<String, Object> purchaseOrder =(Map<String, Object>) opp.get('po');
    
    System.assertEquals(purchaseOrder.get('tobeemailed'), 'test@email.com'); 
  }
  
  //Tests that the primaryContactEmail is correctly set when there is no primary 
  //contact
  static testMethod void testGetPrimaryContactEmailNull(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 

    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>) JSON.deserializeUntyped(body);
    Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1'); 
    Map<String, Object> purchaseOrder = (Map<String, Object>) opp.get('po');
    
    System.assertEquals(purchaseOrder.get('tobeemailed'), ''); 
  }
  
  //Tests that the toBeEmailed field is correctly set when where is a primary contact
  static testMethod void testGetToBeEmailed(){
   Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 

    opportunity.email_list_to__c = 'emaillistto@email.com'; 
    update opportunity; 

    Contact contact = new Contact();
    contact.email = 'test@email.com';
    contact.accountID = account.ID; 
    contact.firstName = 'Test'; 
    contact.lastName = 'Person';
    insert contact; 
    
    OpportunityContactRole ocr = new OpportunityContactRole(); 
    ocr.opportunityID = opportunity.id;
    ocr.contactID = contact.id; 
    ocr.isPrimary = TRUE; 
    insert ocr;
   
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>)JSON.deserializeUntyped(body);
    Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1');
    Map<String, Object> purchaseOrder =(Map<String, Object>) opp.get('po');
    
    System.assertEquals(purchaseOrder.get('tobeemailed'), 'emaillistto@email.com');
  }
  
  //Tests that the JSON structure is created for one multideal
  static testMethod void testMultidealStructure(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
    
    Multi_Deal__c multideal = new Multi_Deal__c();
    multideal.account__c = account.id;
    multideal.opportunity__c = opportunity.id;
    multideal.product_SKU__c = '123456789'; 
    multideal.name = 'Multideal name';
    multideal.BOM_SKU__c = '987654321';
    multideal.product_weight_lbs__c = 1;
    multideal.product_length_in__c = 2;
    multideal.product_width_in__c = 3;
    multideal.product_height_in__c = 4;
    multideal.total_deal_max__c = 1; 
    insert multideal;
    
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>) JSON.deserializeUntyped(body);
    Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1'); 
    Map<String, Object> items = (Map<String, Object>) opp.get('item');
    Map<String, Object> item = (Map<String, Object>) items.get('1'); 
    
    System.assertEquals(item.get('itemid'), '123456789'); 
    System.assertEquals(item.get('purchasedescription'), 'Multideal name'); 
    System.assertEquals(item.get('custitem_item_bom_sku'), '987654321'); 
    System.assertEquals(item.get('weight'), '1.00'); 
    System.assertEquals(item.get('custitem_item_length'), '2.00'); 
    System.assertEquals(item.get('custitem_item_width'), '3.00'); 
    System.assertEquals(item.get('custitem_item_height'), '4.00'); 
  }
  
  //Tests that the JSON structure is created for more than one multideal
  static testMethod void testMultidealStructureMultiple(){
    Account account = new Account();  
    Opportunity opportunity = new Opportunity();
    setRequiredFields(account, opportunity); 
    
    Multi_Deal__c multideal1 = new Multi_Deal__c();
    multideal1.account__c = account.id;
    multideal1.opportunity__c = opportunity.id;
    multideal1.total_deal_max__c = 1; 
    insert multideal1;
    
    Multi_Deal__c multideal2 = new Multi_Deal__c();
    multideal2.account__c = account.id;
    multideal2.opportunity__c = opportunity.id;
    multideal2.total_deal_max__c = 1; 
    insert multideal2; 
    
    String body = NetsuiteCreate.generateOpportunity(opportunity.id); 
    Map<String, Object> jsonStructure = (Map<String, Object>) JSON.deserializeUntyped(body);
    Map<String, Object> opp = (Map<String, Object>) jsonStructure.get('1');
    Map<String, Object> items = (Map<String, Object>) opp.get('item');
    Map<String, Object> item1 = (Map<String, Object>) items.get('1'); 
    Map<String, Object> item2 = (Map<String, Object>) items.get('2'); 
    
    System.assert(item1 != null); 
    System.assert(item2 != null); 
  }
}