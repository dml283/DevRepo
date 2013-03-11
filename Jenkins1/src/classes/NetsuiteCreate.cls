/**
*  This class sends a POST request to Netsuite containing
*  the information on a given opportunity and its
*  related account and multideals. The Netsuite endpoint
*  then creates a PO. 
*/

global with sharing class NetsuiteCreate{

  public static jsonGenerator gen = JSON.createGenerator(false); 

  // Creates Netsuite Purchase Order Info object on the given opportunity 
  // This should be called by the trigger before it calls addOpportunity 
  public static void createNSPOI(ID oppID){
    Netsuite_Purchase_Order_Info__c nspoi;
    List<Netsuite_Purchase_Order_Info__c> nspois = [SELECT id, netsuite_po_es_status__c 
      FROM netsuite_purchase_order_info__c WHERE opportunity__c =: oppID]; 
          
    if (nspois.isEmpty()) { //create a nspoi if one doesn't already exist
      nspoi = new netsuite_purchase_order_info__c(); 
      nspoi.opportunity__c = oppID;
      insert nspoi;
    }
  } 

  // Entry method for generating content and sending it to NetSuite
  public static void addOpportunity(ID oppID){            
    String body = generateOpportunity(oppID); 
    System.debug('BODY:' + body); 
    sendToNetsuite(oppID, body);  
  }
  
  // Sends the request to NetSuite and updates the NSPOI with the call out time 
  // and message to the user. They're paired in the future call so the the call 
  // out timestamp is consistent with when request actually gets processed
  @Future(callout = true)
  private static void sendToNetsuite(ID oppID, String body){
    sendRequest(body); 
    updateNSPOI(oppID);
  }
  
  // Creates the POST request and sends it to NetSuite 
  private static void sendRequest(String body){
    HttpRequest request = new HttpRequest(); 
    
    if (isProd()){ //Netsuite production credentials
      request.setEndpoint('https://rest.netsuite.com/app/site/hosting/restlet.nl?script=98&deploy=1');
       String auth = 'NLAuth nlauth_account=3579761, ' + 
      'nlauth_email=netsuitesalesforceapi@groupon.com, ' + 
      'nlauth_signature=GrPn2013, nlauth_role=3'; 
      request.setHeader('Authorization', auth);
    }
    else{ //Netsuite sandbox credentials 
      request.setEndpoint('https://rest.sandbox.netsuite.com/app/site/hosting/restlet.nl?script=98&deploy=1'); 
       String auth = 'NLAuth nlauth_account=3579761, ' + 
      'nlauth_email=netsuitesalesforceapi@groupon.com, ' + 
      'nlauth_signature=GrPn2013, nlauth_role=3';
       request.setHeader('Authorization', auth);
    }
   
    request.setBody(body); 
    request.setMethod('POST');    
    request.setHeader( 'Accept', '*/*' );
    request.setHeader('Content-Type', 'application/json');
                
    HttpResponse response; 
    if (!Test.IsRunningTest()){
      Http http = new Http();  
      response = http.send(request);
    }    
  }
  
  // Determines if the code is running in production or not 
  private static boolean isProd(){
    if (UserInfo.getOrganizationID() == '00D80000000KhmyEAC'){
      return true; 
    }
    return false; 
  }
    
  // Creates/updates Netsuite Purchase Order Info object on the given opportunity 
  private static void updateNSPOI(ID oppID){
    Netsuite_Purchase_Order_Info__c nspoi;
    List<Netsuite_Purchase_Order_Info__c> nspois = [SELECT id, netsuite_po_es_status__c 
      FROM netsuite_purchase_order_info__c WHERE opportunity__c =: oppID]; 
          
    nspoi = nspois.get(0); 
    nspoi.netsuite_po_es_status__c = 'Waiting for Netsuite to create the PO'; 
    nspoi.netsuite_last_call_date_time__c = datetime.now();
    update nspoi;
  }
  
  //Generates the JSON for an individual opportunity 
  public static String generateOpportunity(ID oppID){
    Opportunity opportunity = [SELECT id, name, accountID, account_coordinator__c,
      ownerID, permalink__c, available_date__c, payment_terms__c, email_list_to__c, 
      fulfillment_method__c, fulfillment_provider__c, freight_allowance__c, 
      freight_terms__c, option_effective_date__c, option_effective_end_date__c,  
      refund_allowance__c, logistics_notes__c, freight_provider__c, goods_manual_PO__c, 
      accountCoordinator__c
      FROM Opportunity WHERE id =: oppID];

    List<Multi_Deal__c> multideals = [SELECT id, name, bom_sku__c, opportunity__c,
      kitting_details__c, unit_sell_price__c, unit_buy_price__c, total_deal_max__c, 
      product_length_in__c, product_height_in__c, product_weight_lbs__c, 
      product_width_in__c,  product_sku__c
      FROM multi_deal__c WHERE Opportunity__c =: opportunity.id];

    Account account = [SELECT id, name, phone, billingStreet,
      billingCity, billingState, billingPostalCode, 
      general_ledger_goods_vendor_id__c
      FROM Account WHERE id =: opportunity.accountID];
        
    gen.writeStartObject(); //start wrapper object
    gen.writeFieldName('1');
    gen.writeStartObject(); //start object for single opportunity
    gen.writeFieldName('po');
    generateOpportunityInfo(opportunity, multideals, account);
    gen.writeFieldName('vendor');
    generateVendorInfo(account);
    gen.writeFieldName('item');
    generateItemInfo(multideals);
    gen.writeEndObject(); //end object for single opportunity
    gen.writeEndObject(); //end wrapper object
    
    return gen.getAsString(); 
  }
    
  // Generates option details for the options listed on the multi deal portion 
  // of the opportunity
  private static void generateItemInfo(List<multi_deal__c> multideals){
    gen.writeStartObject();

    Integer dealCount = 1; 
    for (Multi_Deal__c deal : multideals) {
      if (deal.total_deal_max__c > 0){
        gen.writeFieldName(String.valueOf(dealCount)); 
        gen.writeStartObject();
        gen.writeStringField('itemid', formatString(deal.product_SKU__c));
        gen.writeStringField('purchasedescription', formatString(deal.name));
        gen.writeStringField('custitem_item_bom_sku', formatString(deal.bom_sku__c));
        gen.writeStringField('custitem_item_kitting_details', formatString(deal.kitting_details__c));
        gen.writeStringField('weight', formatDecimal(deal.product_weight_lbs__c));
        gen.writeStringField('custitem_item_length', formatDecimal(deal.product_length_in__c));
        gen.writeStringField('custitem_item_width', formatDecimal(deal.product_width_in__c));
        gen.writeStringField('custitem_item_height', formatDecimal(deal.product_height_in__c));
        gen.writeEndObject();               

        dealCount++; 
      }
    }        
    gen.writeEndObject(); 
  }
    
  // Generates the options from the multi deal portion of the opportunity    
  private static void generateItemLine(List<Multi_Deal__c> multideals){
    gen.writeStartObject();
    
    Integer dealCount = 1; 
    for (Multi_Deal__c deal : multideals) {
      if (deal.total_deal_max__c > 0){
        gen.writeFieldName(String.valueOf(dealCount)); 
        gen.writeStartObject();
        gen.writeStringField('item', formatString(deal.product_SKU__c));
        gen.writeStringField('rate', formatDecimal(deal.unit_buy_price__c));     
        gen.writeStringField('custcol_po_gross_unit_price', formatDecimal(deal.unit_buy_price__c));
        gen.writeStringField('custcol_po_list_price', formatDecimal(deal.unit_sell_price__c));
        gen.writeStringField('quantity', formatDecimal(deal.total_deal_max__c));
        gen.writeEndObject();

        dealCount++;  
      }
    }
    gen.writeEndObject();
  }
    
  // Generates account details for the account on the opportunity
  private static void generateVendorInfo(Account account){
    gen.writeStartObject();
    gen.writeStringField('vendor_external_id', formatString(account.general_ledger_goods_vendor_id__c));
    gen.writeStringField('companyname', formatString(account.name)); 
    gen.writeStringField('phone', formatPhone(account.phone));
    gen.writeFieldName('address');
    gen.writeStartObject(); //start address
    gen.writeStringField('addr1', getAddr1(account.billingStreet)); 
    gen.writeStringField('addr2', getAddr2(account.billingStreet));
    gen.writeStringField('city', formatString(account.billingCity)); 
    gen.writeStringField('state', formatString(account.billingState)); 
    gen.writeStringField('zip', formatString(account.billingPostalCode)); 
    gen.writeEndObject(); // end address  
    gen.writeEndObject();   
  }
    
  // Generates the main information from the opportunity
  private static void generateOpportunityInfo(Opportunity opp, List<multi_deal__c> multideals, Account acc){
    netSuite_purchase_order_info__c nspoi = getNSPOI(opp.ID); 
    List <OpportunityContactRole> contactRoles = [SELECT contact.name, contact.email 
      FROM OpportunityContactRole WHERE opportunityID =: opp.ID AND isPrimary =: TRUE];

    gen.writeStartObject(); 
    gen.writeStringField('tranid', formatString(getTranID(nspoi)));
    gen.writeStringField('internalid', formatString(getInternalID(nspoi)));
    gen.writeStringField('date', formatDate(System.Today()));
    gen.writeStringField('custbody_po_sf_opp_id', formatString(getTruncatedID(opp.id)));
    gen.writeStringField('custbody_po_sf_opp_name', formatString(opp.name));
    gen.writeStringField('custbody_po_sf_permalink', formatString(opp.permalink__c));
    gen.writeStringField('entity', formatString(acc.name));
    gen.writeStringField('location', formatString(opp.fulfillment_provider__c));
    gen.writeStringField('custbody_po_sf_freight_provider', formatString(opp.freight_provider__c));
    gen.writeStringField('custbody_po_sf_logistics_notes', formatString(opp.logistics_notes__c));
    gen.writeStringField('custbody_po_sf_effective_date', formatDate(opp.option_effective_date__c));
    gen.writeStringField('custbody_po_sf_effective_end_da', formatDate(opp.option_effective_end_date__c));
    gen.writeStringField('custbody_po_sf_return_allowance_pct', formatDecimal(opp.refund_allowance__c));
    gen.writeStringField('custbody_po_sf_fulfillment_method', formatString(opp.fulfillment_method__c));
    gen.writeStringField('custbody_po_sf_primary_contact', formatString(getPrimaryContactName(contactRoles)));
    gen.writeStringField('tobeemailed', formatString(getToBeEmailed(opp.email_list_To__c, getPrimaryContactEmail(contactRoles))));
    gen.writeStringField('custbody_po_sf_account_manager_email', formatString(getAccountManagerEmail(opp)));
    gen.writeStringField('custbody_po_sf_opportunity_owner_email', formatString(getOwnerEmail(opp)));
    gen.writeStringField('custbody_po_sf_freight_allowance_pct', formatDecimal(opp.freight_allowance__c));
    gen.writeStringField('custbody_po_sf_freight_terms', formatString(opp.freight_terms__c));
    gen.writeStringField('custbody_po_sf_ship_date', formatString(opp.available_date__c));
    gen.writeStringField('terms', formatString(opp.payment_terms__c));
    gen.writeStringField('custbody_po_goods_manual_po', formatString(opp.goods_manual_po__c));
    gen.writeFieldName('itemline');
    generateItemLine(multideals);
    gen.writeEndObject(); 
  }   

  // Ensures that the phone number sent to Netsuite is between 7 and 22 
  // characters un order to meet their requirements 
  private static String formatPhone(String phoneNum){
    if (phoneNum == null){
      return '';
    }
    else{
      phoneNum = phoneNum.trim(); 
      
      if (phoneNum.length() < 7){
        return ''; 
      }
      else if (phoneNum.length() > 22){
        return phoneNum.substring(0, 22); 
      }
      return phoneNum;
    }
  } 

  // Checks if the address has multiple lines and extracts the first line
  private static String getAddr1(String address){
    if (address != null){
      Integer newline = address.indexOf('\n');
      
      if(newLine == -1){
         return address; 
      }
      else{
        return address.substring(0, newline);
      }
    }
    return ''; 
  }
  
  // Checks if the address has multiple lines and extracts the second line
  private static String getAddr2(String address){
    if(address != null){
      Integer newline = address.indexOf('\n');
      
      if(newLine == -1){
        return ''; 
      }
      else{ 
        return address.substring(newLine + 1); 
      }
    }
    return '';  
  }
  
  // Takes an 18 character ID and returns the 15 character ID
  private static String getTruncatedID(ID opportunityID){
    String idLong = String.valueOf(opportunityID); 
    String idShort = idLong.substring(0,15); 
    return idShort; 
  }
  
  private static String formatDate(Date value){
    if (value == null){
      return '';
    }
    return String.valueOf(value);
  }

  private static String formatString(String value){
    if (value == null){
      return '';
    }
    return value;
  }

  private static String formatInteger(Integer value){
    if (value == null){
      return '';
    }
    return String.valueOf(value);
  }

  private static String formatDecimal(Decimal value){
    if (value == null){
      return '';
    }
    return String.valueOf(value);
  }

  // Retrieves the email of the account manager on the opportunity
  private static String getAccountManagerEmail(Opportunity opp){
    if(opp.accountCoordinator__c != null){
        User manager = [SELECT id, email FROM user WHERE id =: opp.accountCoordinator__c];
        return manager.email; 
    }
    return '';  
  } 
    
  // Gets the netsuite purchase order object associated with an opportunty, 
  // returns null if there isn't one
  private static NetSuite_Purchase_Order_Info__c getNSPOI(ID oppID){
    List<NetSuite_Purchase_Order_Info__c> nspois = [SELECT id, 
      netSuite_po_number__c, netsuite_internal_id__c 
      FROM NetSuite_Purchase_Order_Info__c WHERE opportunity__c =: oppID]; 
    
    if (nspois.isEmpty()) {
      return null; 
    }
    return nspois.get(0);
  }

  // Returns the tranID for the opportunity if there is one
  private static String getTranID(NetSuite_Purchase_Order_Info__c nspoi){
    if (nspoi == null || nspoi.netsuite_po_number__c == null) {
      return ''; 
    }
    return nspoi.netsuite_po_number__c;
  }
  
  // Returns the Netsuite internal ID on the opportunity if there is one
  private static String getInternalID(NetSuite_Purchase_Order_Info__c nspoi){
    if (nspoi == null || nspoi.netsuite_internal_ID__c == null) {
      return '';
    }
    return nspoi.netsuite_internal_ID__c;
  }
  
  // Sets the ToBeEmailed field
  private static String getToBeEmailed(String emailList, String primaryEmail){
    if (emailList != null) {
      return emailList;
    }
    return primaryEmail; 
  }
  
  // Returns the owner email 
  private static String getOwnerEmail(Opportunity opp){
    return [SELECT id, email FROM user WHERE id =: opp.ownerID].get(0).email;   
  }
  
  // Returns the primary contact name if there is one
  private static String getPrimaryContactName(List <OpportunityContactRole> roles){
    if (roles.isEmpty()) {
      return ''; 
    }
    return roles.get(0).contact.name; 
  }
  
  // Returns the primary contact email if there is one
  private static String getPrimaryContactEmail(List <OpportunityContactRole> roles){
    if (roles.isEmpty()) {
      return '';
    }
    return roles.get(0).contact.email; 
  }
}