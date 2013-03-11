//01pc00000008gBX
global class SalesValuePurchaseOrderAPI {

  global class PurchaseOrder {
    public string salesforce_id { get; set; }
    public string Division { get; set; }
    public string Subdivision { get; set; }
    public date TargetFeatureDate { get; set; }
    public Taxonomy taxonomy { get; set; }
    public string RepNotes { get; set; }
    public string PONotes { get; set; }
    public list<string> MultiAssign { get; set; }
    public string ExampleDeal1 { get; set; }
    public string ExampleDeal2 { get; set; }
    public string DealBuilder { get; set; }
    public string IdealPrice { get; set; }
    public string TargetGP { get; set; }
    public string TargetGMS { get; set; }
    public dates dates { get; set; }
    public financial financial { get; set; }
    public list<string> assignedTo { get; set; }
    public decimal lat { get; set; }
    public decimal lng { get; set; }
    public proposed_locations proposed_location { get; set; }
    public Boolean NeedsResearch { get; set; }
    public datetime ResearchCompletedDate { get; set; }
    public datetime ResearchRequestedDate { get; set; }
    public string MerchantResearcher { get; set; }
    public string Type { get; set; }

    public PurchaseOrder() {}
    public PurchaseOrder(purchase_order__c PO) {

      this.salesforce_id = po.Id;
      if(po.division__r.name != null )
        this.Division = [select id,name from Division__c where name = :po.division__r.name limit 1].name;

      if(po.Subdivision__r.name != null)
        this.Subdivision = [select id,name from Subdivision__c where name = :po.Subdivision__r.name limit 1].name;

      if(po.target_feature_date__c != null)
        this.TargetFeatureDate= po.target_feature_date__c;

      this.taxonomy = new taxonomy(po);

      if(po.Rep_PO_Notes__c != null)
        this.RepNotes= po.Rep_PO_Notes__c;

      if(po.po_notes__c != null)
        this.PONotes = po.po_notes__c;

      if(po.example_deal_1__c != null)
        this.ExampleDeal1 = po.example_deal_1__c;

      if(po.example_deal_2__c != null)
        this.ExampleDeal2 = po.example_deal_2__c;

      if(po.Deal_Builder_Template__c != null)
        this.DealBuilder= po.Deal_Builder_Template__c;

      if(po.Ideal_Price_Range__c != null)
        this.IdealPrice= po.Ideal_Price_Range__c;

      if(po.Target_GP__c != null)
        this.TargetGP = string.valueof(po.Target_GP__c);

      if(po.Target_Revenue__c != null)
        this.TargetGMS = string.valueof(po.Target_Revenue__c);

      if (po.Needs_Research__c != null)
        this.NeedsResearch = po.Needs_Research__c;

      if (po.Research_Completed_Date__c != null)
        this.ResearchCompletedDate = po.Research_Completed_Date__c;

      if (po.Research_Requested_Date__c != null)
        this.ResearchRequestedDate = po.Research_Requested_Date__c;

      if (po.Type__c != null)
        this.Type = po.Type__c;

      this.dates = new dates(po);
      this.financial = new financial(po);
      list<string> stringval = new list<string>();
      List<assignedto__c> assigned = [select id,assigned_to__r.name from assignedto__c where purchase_order__c =: Po.Id];
      for(assignedTo__c assign : assigned)
      {
        stringval.add(assign.assigned_to__r.name);
      }
      this.assignedTo = stringval;
      if(po.latitude__c != null)
        this.lat= po.latitude__c;
      if(po.longitude__c != null)
        this.lng= po.longitude__c;
      this.proposed_location = new proposed_locations(po);
    }


    public void doUpsert(){
      Purchase_order__c po ;
      if(this.salesforce_Id != null && this.salesforce_Id.length() != 0){
        po   = [select id,division__r.name,PO_Status__c,subdivision__r.name,Assigned_To__c ,PO_Notes__c,Example_Deal_1__c,Example_Deal_2__c ,target_feature_date__c,Ideal_Price_Range__c,Target_GP__c,Target_Revenue__c,Latitude__c,longitude__c,Global_SFDC_Category__c,Global_SFDC_Subcategory_1__c ,Global_SFDC_Subcategory_2__c,category_v3__c,subcategory_v3__c,services__c,merchant_attributes__c,Deal_Builder_Template__c,Type__c from purchase_order__c where Id =: this.salesforce_id];
      } else {po = new Purchase_order__c();}
      if(this.division != null && this.division.length() != 0){po.division__c = [select id from Division__c where name = :this.division limit 1].id;}
      if(this.subdivision != null && this.subdivision.length() != 0){po.subdivision__c = [select id from Subdivision__c where name = :this.Subdivision limit 1].id;}
      if(this.TargetFeatureDate != null)
        po.target_feature_date__c = this.TargetFeatureDate;
      if(this.RepNotes != null)
        po.Rep_PO_Notes__c = this.RepNotes;
      if(this.PONotes != null)
        po.PO_Notes__c = this.PONotes;
      list<AssignedTo__c> assigned = new list<AssignedTo__c>();
      List<AssignedTo__c> alreadyAssigned = new List<AssignedTo__c>();
      Map<string,Id> Assignmap = new Map<string,Id>();
      List<AssignedTo__c > deletelist = new List<AssignedTo__c >();

      if(this.proposed_location != null)
      {
        if(this.proposed_location.lat != null)
          po.latitude__c = this.proposed_location.lat;
        if(this.proposed_location.lng != null)
          po.longitude__c = this.proposed_location.lng;
      }
      if(this.ExampleDeal1 != null)
      {
        po.Example_deal_1__c = this.ExampleDeal1;
      }
      if(this.ExampleDeal2 != null)
      {
        po.Example_deal_2__c = this.ExampleDeal2;
      }
      if(this.DealBuilder != null)
      {
        po.Deal_Builder_Template__c = this.DealBuilder;
      }
      if (this.NeedsResearch != null)
      {
        po.Needs_Research__c = this.NeedsResearch;
      }
      if (this.ResearchCompletedDate != null)
      {
        po.Research_Completed_Date__c = this.ResearchCompletedDate;
      }
      if (this.ResearchRequestedDate != null)
      {
        po.Research_Requested_Date__c = this.ResearchRequestedDate;
      }
      if (this.MerchantResearcher != null){
        if (this.MerchantResearcher ==''){
          po.Merchant_Researcher__c = null;
        }else {
          po.Merchant_Researcher__c = this.MerchantResearcher;
        }

      }
      if (this.Type != null)
      {
        po.Type__c = this.Type;
      }

      if(this.taxonomy != null)
      {
        if(this.taxonomy.v2_category != null)
          po.Global_SFDC_Category__c = this.taxonomy.v2_category;
        if(this.taxonomy.v2_subcategory1!= null)
          po.Global_SFDC_Subcategory_1__c = this.taxonomy.v2_subcategory1;
        if(this.taxonomy.v2_subcategory2!= null)
          po.Global_SFDC_Subcategory_2__c = this.taxonomy.v2_subcategory2;
        if(this.taxonomy.v3_category != null)
          po.Category_v3__c = this.taxonomy.v3_category;
        if(this.taxonomy.v3_subcategory != null)
          po.Subcategory_v3__c = this.taxonomy.v3_subcategory;

        if(this.taxonomy.v3_services != null)
        {
          po.Services__c = '';
          for(integer i=0;i<this.taxonomy.v3_services.size();i++)
          {
            if(i>0)
            {
              po.Services__c += ' | ';
            }
            po.Services__c += this.taxonomy.v3_services[i];

          }
        }
        if(this.taxonomy.v3_attributes != null)
        {
          po.Merchant_Attributes__c = '';
          for(integer i=0;i<this.taxonomy.v3_attributes.size();i++)
          {
            if(i>0)
            {
              po.Merchant_Attributes__c += ' | ';
            }
            po.Merchant_Attributes__c += this.taxonomy.v3_attributes[i];

          }
        }
      }
      if(this.dates != null){
        po.Target_Feature_Date__c = this.dates.target_date;
      }

      database.upsertresult UR= database.upsert(po);
      if(UR.isSuccess())
      {

        this.salesforce_Id = po.Id;
      }
      if(this.assignedTo != null && (this.salesforce_Id != null && string.valueof(this.salesforce_Id).length() != 0))
      {
        string[] splitnames = new string[]{};
        for(string s : this.assignedTo)
        {
          splitnames.add(s);
        }
        alreadyAssigned = [select id,Assigned_To__c,Assigned_To__r.name from AssignedTo__c where purchase_order__c =: this.salesforce_Id];
        for(AssignedTo__c assig : alreadyAssigned )
        {
          Assignmap.put(assig.Assigned_To__r.name,assig.Id);
        }
        for(string name : splitnames )
        {
          if(name == null || name == '')
          {
            //donothing
          }
          else
          {
            if(Assignmap.containsKey(name)){
              AssignedTo__c a_update = new AssignedTo__c(
                  Assigned_To__c = [select id,name from User where name =: name and IsActive =: true limit 1].id,
                  purchase_order__c = this.salesforce_Id,
                  Id = Assignmap.get(name));
              assigned.add(a_update);
              Assignmap.remove(name);
            }
            else{
              AssignedTo__c a_insert = new AssignedTo__c(
                  Assigned_To__c = [select id,name from User where name =: name and IsActive =: true limit 1].id,
                  purchase_order__c = this.salesforce_Id);
              assigned.add(a_insert);
              Assignmap.remove(name);
            }
          }
        }
        if(Assignmap.Keyset()!= null)
        {
          deletelist = [select id from AssignedTo__c where assigned_to__r.name IN:Assignmap.Keyset()];
        }
      }
      if(deletelist.size()>0)
      {
        database.delete(deletelist);
      }
      if(assigned.size()>0){
        database.upsert(assigned);
      }
    }
  }
  public class taxonomy {
    public string v1_category { get; set; }
    public string v1_subcategory { get; set; }
    public string v2_category { get; set; }
    public string v2_subcategory1 { get; set; }
    public string v2_subcategory2 { get; set; }
    public string v3_category { get; set; }
    public string v3_subcategory { get; set; }
    public list<string> v3_services { get; set; }
    public list<string> v3_attributes { get; set; }
    public taxonomy(purchase_order__c po)
    {
      this.v2_category          =   po.Global_SFDC_Category__c;
      this.v2_subcategory1      =   po.Global_SFDC_Subcategory_1__c;
      this.v2_subcategory2      =   po.Global_SFDC_Subcategory_2__c;
      this.v3_category          =   po.Category_v3__c;
      this.v3_subcategory       =   po.Subcategory_v3__c;
      string[] servicessplit    =   new string[]{};
      string[] attributessplit  =   new string[]{};
      if(po.Services__c != null)
      {
        po.Services__c.replace(' | ','|');
        for(String s: po.Services__c.split('\\|'))
        {
          servicessplit.add(s);
        }
      }
      this.v3_services          =  servicessplit ;
      if(po.Merchant_Attributes__c != null)
      {
        po.Merchant_Attributes__c.replace(' | ','|');
        for(String s: po.Merchant_Attributes__c.split('\\|'))
        {
          attributessplit.add(s);
        }
      }
      this.v3_attributes        =   attributessplit  ;
    }
  }
  public class dates{
    public date target_date  { get; set; }
    public dates(purchase_order__c po)
    {
      this.target_date = po.target_feature_date__c;
    }
  }
  public class financial{
    public string PriceRange { get; set; }
    public string TargetGP { get; set; }
    public string TargetGMS { get; set; }
    public financial (purchase_order__c PO)
    {
      this.PriceRange = po.Ideal_price_range__c;
      this.TargetGP   = string.valueof(po.Target_GP__c);
      this.TargetGMS  = string.valueof(po.Target_Revenue__c);
    }

  }
  public class proposed_locations{
    public decimal lat  { get; set; }
    public decimal lng  { get; set; }
    public proposed_locations(purchase_order__c po)
    {
      this.lat = po.latitude__c;
      this.lng = po.longitude__c;
    }
  }
  private static testMethod void testInsertPO(){

    grouponTestUtil util = new grouponTestUtil();

    purchase_order__c po = util.createPO();
    insert po;

    List<string> assignedto = new list<string>();
    assignedto__c assign = util.createassignedto();
    insert assign;
    assignedto.add(assign.assigned_to__r.name);

    Profile p = [select id from profile where name='System Administrator'];

    division__c div = util.createDivision();
    insert div;

    subdivision__c s = util.createsubdiv();
    insert s;

    string[] teststring = new string[]{'V3_Services','V3_Attributes'};
    taxonomy t = new taxonomy(po);
    t.v2_category = 'cat v2';
    t.v2_subcategory1 = 'subcat v2';
    t.v2_subcategory2 = 'v2subcat 2';
    t.v3_category = 'v3 cat';
    t.v3_subcategory = 'v3 sub';
    t.v3_services = (teststring) ;
    t.v3_attributes = (teststring) ;

    dates d = new dates(po);
    d.target_date = date.today();

    financial fin = new financial(po);
    fin.PriceRange = 'Test';
    fin.TargetGP   = '123';
    fin.TargetGMS  = '123';

    proposed_locations prop = new proposed_locations(po);
    prop.lat = 123;
    prop.lng = 321;

    PurchaseOrder api = new PurchaseOrder(po);
    api.salesforce_id =po.id;
    api.Division = div.name;
    api.Subdivision = s.name;
    api.TargetFeatureDate = system.today();
    api.taxonomy = t;
    api.Repnotes = 'maybe notes?';
    api.PONotes = 'maybe notes?';
    api.ExampleDeal1 ='some ex';
    api.ExampleDeal2 ='some ex';
    api.DealBuilder='some ex';
    api.IdealPrice='some ex';
    api.TargetGP='some ex';
    api.TargetGMS ='some ex';
    api.doUpsert();
    system.assertequals('Training',api.division);
    system.assertequals('Chicago',api.Subdivision);
  }
}