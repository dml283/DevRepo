/**
 * This class is used to deserialize JSON requests
 * from Netsuite into an object that is used to 
 * update opportunities in Salesforce. 
 */

global with sharing class NetsuiteUpdateObject {
  public String custbody_po_sf_opp_id;
  public String tranid;
  public String internalid; 
  public String po_es_status;
  public String po_es_error_code;
  public String po_create_datetime;
  public String po_update_datetime;
  public String po_revision; 
  public String echosign_link; 
  public String option_effective_end_date;
  public String option_effective_date;  
         
  public NetsuiteUpdateObject(String po_es_status, String internalid, 
    String tranid, String custbody_po_sf_opp_id, String po_es_error_code,
    String po_create_datetime, String po_update_datetime, String po_revision, 
    String echosign_link, String option_effective_end_date, 
    String option_effective_date) {
    
    this.custbody_po_sf_opp_id = custbody_po_sf_opp_id;
    this.internalid = internalid; 
    this.tranid = tranid; 
    this.po_es_status = po_es_status; 
    this.po_es_error_code = po_es_error_code; 
    this.po_create_datetime = po_create_datetime;
    this.po_update_datetime = po_update_datetime;
    this.po_revision = po_revision; 
    this.echosign_link = echosign_link; 
    this.option_effective_date = option_effective_date;
    this.option_effective_end_date = option_effective_end_date;  
  }    
     
}