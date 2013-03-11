//01pc00000008iDk
@RestResource(urlMapping='/v1.0/sales_value/purchase_order/')

global class RESTPOSalesValueController {

  @HttpGet
  global static List <SalesValuePurchaseOrderAPI.PurchaseOrder> get() {
    RestRequest req = RestContext.request;

    String division = req.params.get('division');
    String category = req.params.get('category');
    String subcategory = req.params.get('subcategory');
    String evergreen_id = req.params.get('evergreen_id');

    List <Purchase_Order__c> po_list;
    List <SalesValuePurchaseOrderAPI.PurchaseOrder> po_return_list = new list<SalesValuePurchaseOrderAPI.PurchaseOrder>();

    if (evergreen_id != null) {
      po_list = [select id, PO_Status__c, division__r.name, Assigned_To__c, Subdivision__r.name, Rep_PO_Notes__c,
              PO_Notes__c, Example_Deal_1__c, Example_Deal_2__c, target_feature_date__c,
              Ideal_Price_Range__c, Target_GP__c, Target_Revenue__c, Latitude__c, longitude__c, Global_SFDC_Category__c,
              Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, category_v3__c, subcategory_v3__c,
              services__c, merchant_attributes__c, Deal_Builder_Template__c, Needs_Research__c, Research_Completed_Date__c,
              Research_Requested_Date__c, Merchant_Researcher__c,
              Type__c
              from purchase_order__c
              where division__r.name =: division and
                subcategory_v3__c =: subcategory and
                category_v3__c =: category and
                source__c = 'Evergreen'
              LIMIT 5];
    }
    else {
      po_list = [select id, PO_Status__c, division__r.name, Assigned_To__c, Subdivision__r.name, Rep_PO_Notes__c,
              PO_Notes__c, Example_Deal_1__c, Example_Deal_2__c, target_feature_date__c, Ideal_Price_Range__c,
              Target_GP__c, Target_Revenue__c, Latitude__c, longitude__c, Global_SFDC_Category__c,
              Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, category_v3__c, subcategory_v3__c,
              services__c, merchant_attributes__c, Deal_Builder_Template__c, Needs_Research__c, Research_Completed_Date__c,
              Research_Requested_Date__c, Merchant_Researcher__c, Type__c
                from purchase_order__c
                where division__r.name =: division and
                  category_v3__c =: category and
                  subcategory_v3__c =: subcategory and
                  Research_Requested_Date__c != null
                LIMIT 5];
    }

    for (Purchase_Order__c po_c : po_list){
      if (po_c != null ) {
        po_return_list.add(new SalesValuePurchaseOrderAPI.PurchaseOrder(po_c));
      }
    }

    return po_return_list;
  }

  @HttpPost
  global static SalesValuePurchaseOrderAPI.PurchaseOrder post(SalesValuePurchaseOrderAPI.PurchaseOrder po) {
      po.doUpsert();
      purchase_order__c po_return;
      po_return  = [select id, division__r.name, PO_Status__c, Assigned_To__c, Subdivision__r.name, Rep_PO_Notes__c,
                 PO_Notes__c, Example_Deal_1__c, Example_Deal_2__c, target_feature_date__c, Ideal_Price_Range__c, Target_GP__c,
                 Target_Revenue__c, Latitude__c, longitude__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c,
                 Global_SFDC_Subcategory_2__c, category_v3__c, subcategory_v3__c, services__c,
                 merchant_attributes__c, Deal_Builder_Template__c, Needs_Research__c, Research_Completed_Date__c,
                 Research_Requested_Date__c, Merchant_Researcher__c, Type__c
                   from purchase_order__c
                   where Id =: po.salesforce_id];
      return new SalesValuePurchaseOrderAPI.PurchaseOrder(po_return);
  }

  @isTest
  public static void itDoesntCrashWhenWePassAnEvergreenId() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/v1.0/sales_value/purchase_order';
    req.httpMethod = 'GET';
    req.params.put('division', 'Fort Worth');
    req.params.put('category', 'Beauty / Wellness / Healthcare');
    req.params.put('subcategory', 'Salon - Nail');
    req.params.put('evergreen_id', 'apparently we dont care what this value is at all... thats a little bit suspicious, maybe it should be a boolean?');
    RestContext.request = req;

    List<SalesValuePurchaseOrderAPI.PurchaseOrder> pos = get();
  }

  @isTest
  public static void itDoesntCrashWithoutAnEvergreenId() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/v1.0/sales_value/purchase_order';
    req.httpMethod = 'GET';
    req.params.put('division', 'chicago');
    req.params.put('category', 'Food & Drink');
    req.params.put('subcategory', 'Restaurant');
    RestContext.request = req;

    List<SalesValuePurchaseOrderAPI.PurchaseOrder> pos = get();
  }

  @isTest
  public static void itDoesntCrashOnAPost() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/v1.0/sales_value/purchase_order';
    req.httpMethod = 'POST';
    RestContext.request = req;
    SalesValuePurchaseOrderAPI.PurchaseOrder po = new SalesValuePurchaseOrderAPI.PurchaseOrder();

    SalesValuePurchaseOrderAPI.PurchaseOrder new_po = post(po);

    System.Assert(new_po != null);
  }

}