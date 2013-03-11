@RestResource(urlMapping='/v2.0/purchase_order/')

global class RESTPOControllerv20 {
@HttpPut
  global static PurchaseOrderAPI.Purchase_order putupdatePO(PurchaseOrderAPI.Purchase_order po){
    //PurchaseOrderAPI.Purchase_order po = (PurchaseOrderAPI.Purchase_order)JSON.deserialize(string.valueOf(RestContext.request), PurchaseOrderAPI.Purchase_order.class);
    po.doUpsert();
    purchase_order__c po_return;
    po_return  = [select id,division__r.name,PO_Status__c,Assigned_To__c ,Subdivision__r.name,Rep_PO_Notes__c,PO_Notes__c,Example_Deal_1__c,Example_Deal_2__c ,target_feature_date__c,Ideal_Price_Range__c,Target_GP__c,Target_Revenue__c,Latitude__c,longitude__c,Global_SFDC_Category__c,Global_SFDC_Subcategory_1__c ,Global_SFDC_Subcategory_2__c,category_v3__c,subcategory_v3__c,services__c,merchant_attributes__c,Deal_Builder_Template__c from purchase_order__c where Id =: po.salesforce_id];
    PurchaseOrderAPI.Purchase_order PO_Ret = new PurchaseOrderAPI.Purchase_order(po_return); 
    return PO_Ret;
}
@HttpPost
  global static PurchaseOrderAPI.Purchase_order postupdatePO(PurchaseOrderAPI.Purchase_order po){
    //PurchaseOrderAPI.Purchase_order po = (PurchaseOrderAPI.Purchase_order)JSON.deserialize(string.valueOf(RestContext.request), PurchaseOrderAPI.Purchase_order.class);
    po.doUpsert();
    purchase_order__c po_return;
    po_return  = [select id,division__r.name,PO_Status__c,Assigned_To__c ,Subdivision__r.name,Rep_PO_Notes__c,PO_Notes__c,Example_Deal_1__c,Example_Deal_2__c ,target_feature_date__c,Ideal_Price_Range__c,Target_GP__c,Target_Revenue__c,Latitude__c,longitude__c,Global_SFDC_Category__c,Global_SFDC_Subcategory_1__c ,Global_SFDC_Subcategory_2__c,category_v3__c,subcategory_v3__c,services__c,merchant_attributes__c,Deal_Builder_Template__c from purchase_order__c where Id =: po.salesforce_id];
    PurchaseOrderAPI.Purchase_order PO_Ret = new PurchaseOrderAPI.Purchase_order(po_return); 
    system.debug('#### PO_Ret' + PO_Ret);
    return PO_Ret;
}
@HttpGet
  global static PurchaseOrderAPI.Purchase_order  getPurchaseOrder() {
      RestRequest req = RestContext.request;
      String salesforce_id = req.params.get('salesforce_id');
      
   purchase_order__c po_return;
    po_return  = [select id,PO_Status__c,division__r.name,Assigned_To__c ,Subdivision__r.name,Rep_PO_Notes__c,PO_Notes__c,Example_Deal_1__c,Example_Deal_2__c ,target_feature_date__c,Ideal_Price_Range__c,Target_GP__c,Target_Revenue__c,Latitude__c,longitude__c,Global_SFDC_Category__c,Global_SFDC_Subcategory_1__c ,Global_SFDC_Subcategory_2__c,category_v3__c,subcategory_v3__c,services__c,merchant_attributes__c,Deal_Builder_Template__c from purchase_order__c where Id =: salesforce_id];
    PurchaseOrderAPI.Purchase_order PO_Ret = new PurchaseOrderAPI.Purchase_order(po_return); 
    return PO_Ret;
  
  }

/*@Istest
public static void testmet()
{
grouponTestUtil util = new grouponTestUtil();
purchase_order__c po = util.createPO();
PurchaseOrderAPI.Purchase_Order POAPI = new PurchaseOrderAPI.Purchase_Order(PO);
RESTPOControllerv20.postupdatePO(POAPI);
system.assertEquals(date.today()+7,po.Target_Feature_Date__c);
system.assertEquals('some text',po.Rep_PO_Notes__c);
RESTPOControllerv20.putupdatePO(POAPI);
system.assertEquals(date.today()+7,po.Target_Feature_Date__c);
system.assertEquals('some text',po.Rep_PO_Notes__c);
}*/
}