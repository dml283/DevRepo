/**
 * This class allows Netsuite to send POST requests to 
 * https://[instance].salesforce.com/services/apexrest/netsuite/update
 * that update opportunities in Salesforce. 
 */

@RestResource(urlMapping='/netsuite/update')
global with sharing class NetsuiteUpdate{

  @HttpPost
  global static void doPost(){ 
    String requestBody = RestContext.request.requestBody.toString(); 
    System.debug('UPDATE BODY: ' + requestBody); 
    List<NetsuiteUpdateObject> updates = (List<NetsuiteUpdateObject>) 
      JSON.deserialize(requestBody, List<NetsuiteUpdateObject>.class);
       
    for (integer i = 0; i<updates.size(); i++) {
      singleUpdate(updates.get(i));
    }
  }
  
  // Updates the fields on an opportunity and the opportunity's 
  // Netsuite_Purchase_Order_Info__c object with the information 
  // contained in the NetsuiteUpdateObject
  public static void singleUpdate(NetsuiteUpdateObject updateInfo){
    Opportunity opportunity = [SELECT id, name, accountid, 
      option_effective_end_date__c, option_effective_date__c FROM Opportunity 
      WHERE id =: (ID) updateInfo.custbody_po_sf_opp_id]; 
    
    updateNSPOI(updateInfo, opportunity); 
    updateOpportunity(updateInfo, opportunity); 
  }
  
  // Updates the option_effective_date and option_effective_end_date fields on 
  // the opportunity iff the new info isn't null 
  private static void updateOpportunity(NetsuiteUpdateObject updateInfo, Opportunity opportunity){
    if(updateInfo.option_effective_date != null && updateInfo.option_effective_date.length() == 8){
      opportunity.option_effective_date__c = parseDate(updateInfo.option_effective_date); 
      update Opportunity; 
    }
    if(updateInfo.option_effective_end_date != null && updateInfo.option_effective_end_date.length() == 8){
      opportunity.option_effective_end_date__c = parseDate(updateInfo.option_effective_end_date); 
      update Opportunity; 
    }
  }
  
  // Updates the fields on the opportunity's NSPOI  
  private static void updateNSPOI(NetsuiteUpdateObject updateInfo, Opportunity opportunity){
    netsuite_purchase_order_info__c nspoi = [SELECT id, netsuite_po_number__c,
      netSuite_po_create_date_time__c FROM netsuite_purchase_order_info__c 
      WHERE opportunity__c =: opportunity.ID]; 
       
    //Fields to populate only if it is the initial callback
    if (nspoi.netsuite_po_number__c == null) {
      Account account = [SELECT id, name, phone, account_manager_email__c 
        FROM Account WHERE id =: opportunity.accountID]; 
       
      nspoi.netsuite_po_number__c = updateInfo.tranid; 
      nspoi.account__c = account.id; 
    }
            
    if (nspoi.netsuite_po_create_date_time__c == null) {
      if(updateInfo.po_create_datetime != null && updateInfo.po_update_datetime.length() == 14){
        Datetime createDate = parseDateTime(updateInfo.po_create_datetime); 
        nspoi.netsuite_po_create_date_time__c = createDate;
      }
    }
           
    nspoi.netSuite_internal_id__c = updateInfo.internalid; 
    nspoi.netSuite_po_es_status__c = updateInfo.po_es_status; 
    nspoi.netSuite_po_es_message__c = updateInfo.po_es_error_code; 
    if (updateInfo.po_update_datetime != null && updateInfo.po_update_datetime.length() == 14){
      nspoi.netSuite_po_update_date_time__c = parseDateTime(updateInfo.po_update_datetime);
    }
    if (updateInfo.po_revision != null && updateInfo.po_revision != ''){
        nspoi.netsuite_po_revision__c = updateInfo.po_revision; 
    }
    nspoi.echosign_link__c = updateInfo.echosign_link; 
    update nspoi; 
  }
  
  // Converts a date in string form into a Date
  private static Date parseDate(String dateString){
    Integer month = Integer.valueOf(dateString.mid(0, 2)); 
    Integer day = Integer.valueOf(dateString.mid(2, 2));
    Integer year = Integer.valueOf(dateString.mid(4, 4));
    
    return date.newInstance(year, month, day); 
  }
  
  // Converts a date time in string form into a Datetime
  private static Datetime parseDateTime(String dateTimeString){
    Integer month = Integer.valueOf(dateTimeString.mid(0, 2));
    Integer day = Integer.valueOf(dateTimeString.mid(2, 2));
    Integer year = Integer.valueOf(dateTimeString.mid(4, 4));
    Integer hour = Integer.valueOf(dateTimeString.mid(8, 2));
    Integer minute = Integer.valueOf(dateTimeString.mid(10, 2));
    Integer second = Integer.valueOf(dateTimeString.mid(12, 2));
    
    if (isDaylightSavings()){
      hour = hour + 7;
    }
    else{
      hour = hour + 8; 
    }
            
    Datetime formattedDate = datetime.newInstanceGMT(year, month, day, hour, minute, second);
    return formattedDate; 
  }
  
  //Determines if daylight savings is in effect checking years 2013-2025
  private static boolean isDaylightSavings(){
    Datetime currentTime = Datetime.now();
    
    if (((datetime.newInstanceGMT(2013, 3, 10) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2013, 11, 3))) ||
        ((datetime.newInstanceGMT(2014, 3, 9) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2014, 11, 2))) ||
        ((datetime.newInstanceGMT(2015, 3, 8) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2015, 11, 1))) ||
        ((datetime.newInstanceGMT(2016, 3, 13) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2016, 11, 6))) ||
        ((datetime.newInstanceGMT(2017, 3, 12) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2017, 11, 5))) ||
        ((datetime.newInstanceGMT(2018, 3, 11) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2018, 11, 4))) ||
        ((datetime.newInstanceGMT(2019, 3, 10) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2019, 11, 3))) ||
        ((datetime.newInstanceGMT(2020, 3, 8) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2020, 11, 1))) ||
        ((datetime.newInstanceGMT(2021, 3, 14) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2021, 11, 7))) ||
        ((datetime.newInstanceGMT(2022, 3, 13) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2022, 11, 6))) ||
        ((datetime.newInstanceGMT(2023, 3, 12) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2023, 11, 5))) ||
        ((datetime.newInstanceGMT(2024, 3, 10) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2024, 11, 3))) ||
        ((datetime.newInstanceGMT(2025, 3, 9) <= currentTime) && 
          (currentTime <= datetime.newInstanceGMT(2025, 11, 2))) ){
      return true; 
    }
    return false; 
  }
}