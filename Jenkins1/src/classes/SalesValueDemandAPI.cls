global class SalesValueDemandAPI {

  public List<Deal> findDemand(Date demand_start_date,
                               string division,
                               integer querylimit,
                               Datetime start_date) {
    List <Opportunity> closedOpportunities = new List<Opportunity>();
    List <Deal> closedDeals = new List<Deal>();

    Date demand_end_date = demand_start_date.addMonths(3);
    Date two_weeks_ago = date.today().addDays(-14);

    Division__c div = [SELECT name
                        FROM Division__c
                       WHERE Permalink__c = :division
                       LIMIT 1];
    string division_permalink = div.Name;

    closedOpportunities = [SELECT id, CreatedDate, RecordType.Name,
                                  Primary_Deal_Services__c, category_v3__c,
                                  subcategory_v3__c, Deal_Attributes__c,
                                  CloseDate, Feature_End_Date__c, Feature_Date__c,
                                  Division__c, Subdivision__c,
                                  TotalOpportunityQuantity, Global_SFDC_Category__c,
                                  Total_Projected_Units__c, Owner_lookup__c,
                                  Redemption_Address__c, ownerid, Projected_Quantity__c,
                                  AccountID, Account.Name
                           FROM Opportunity
                           WHERE ( ((Deal_Strengh__c = 'Vetted' OR Deal_Strengh__c = 'A Sure Thing') AND (Feature_Date__c = null OR (Feature_Date__c  <= :demand_end_date AND Feature_Date__c > :demand_start_date )))
                                  OR ((Deal_Strengh__c = 'Rep Getting Info' OR Deal_Strengh__c = 'Recommended' ) AND CloseDate >= :two_weeks_ago ))
                                  AND StageName = 'Closed Won'
                                  AND Division__c = :division_permalink
                                  AND CreatedDate > :start_date
                                  AND Repeat_Deal__c != 'National/Online Deal'
                                  AND Repeat_Deal__c != 'National: Online'
                                  AND Repeat_Deal__c != 'Evergreen'
                                  AND RecordType.Name != 'G-Team'
                                  AND RecordType.Name != 'Rewards'
                                  ORDER BY CreatedDate ASC
                                  LIMIT :querylimit ];

    Option option = new Option();
    for (Opportunity opp : closedOpportunities){
      Deal dealy  = BuildDealFromOpportunity(opp);
      closedDeals.add(dealy);
    }

    return closedDeals;
  }

  public Deal BuildDealFromOpportunity(Opportunity o) {
    deal d;
    string theId = o.id;
    list<multi_deal__c> multiDealList = getMultiDeals(theId);
    D = formatDeal(o,multiDealList, theId);

    return D;
  }

  public deal formatDeal(opportunity o,
                         list<multi_deal__c> multiDealList,
                         string theId) {
    Deal D = new Deal();
    d.id                    = o.id;
    d.division              = o.Division__c;
    d.subdivision           = o.Subdivision__c;
    d.locations             = addLocations(o.id);
    d.options               = addDealOptions(o, multiDealList);
    d.account               = new Account(o.Account.Name, o.Account.ID);
    d.close_date            = o.CloseDate;
    d.feature_start_date    = o.Feature_Date__c;
    d.feature_end_date      = o.Feature_End_Date__c;
    d.category              = o.category_v3__c;
    d.subcategory           = o.subcategory_v3__c;
    d.account_owner_id      = o.Owner_lookup__c;
    d.page_last_date        = o.CreatedDate;
    d.record_type           = o.RecordType.Name;
    d.total_projected_units = o.Total_Projected_Units__c;

    if (o.Primary_Deal_Services__c !=null){
      string[] primary_services = o.Primary_Deal_Services__c.split('\\|');
      d.primary_deal_services = primary_services;
    }

    for(multi_deal__c md: multiDealList) {
      if (md.Option_Services__c != null) {
        string[] services = md.Option_Services__c.split('\\|');
      }
      if (md.Option_Attributes__c != null) {
        string[] attributes = md.Option_Attributes__c.split('\\|');
      }
    }

    return d;
  }


  public list<option> addDealOptions(opportunity o, list<multi_deal__c> multiDealList) {
    list<option> OptionList = new list<option>();

    for(multi_deal__c md : multiDealList) {
      option m = new Option(md);
      OptionList.add(m);
    }

    return OptionList;
  }


  public list<location> addLocations(string theId) {
    list<address__c> addyList = database.query(getAddressQuery(theId));

    list<location> Locations = new list<location>();
    for (address__c a: addyList) {
      locations.add(new Location(a));
    }

    return locations;
  }


  public class location {
    public string name         {get; set;}
    public string address1     {get; set;}
    public string address2     {get; set;}
    public string city         {get; set;}
    public string state        {get; set;}
    public string zip_code     {get; set;}
    public string country      {get; set;}
    public string lat          {get; set;}
    public string lng          {get; set;}
    public string neighborhood {get; set;}
    public id salesforce_id    {get; set;}

    public location(address__c a) {
      this.address1      = a.Street_Line_1__c;
      this.address2      = a.Street_Line_2__c;
      this.state         = a.state__c;
      this.zip_code      = a.Zip_Postal_Code__c;
      this.city          = a.City__c;
      this.country       = a.country__c;
      this.name          = a.Venue_Name__c;
      this.salesforce_id = a.id;
      this.neighborhood  = a.Merchant_Addresses__r.neighborhood__c;
      if (a.Merchant_Addresses__r.Longitude__c != null) {
        this.lng = string.valueOf(a.Merchant_Addresses__r.Longitude__c);
      }
      if (a.Merchant_Addresses__r.Latitude__c != null) {
        this.lat = string.valueOf(a.Merchant_Addresses__r.Latitude__c);
      }
    }
  }


  global class Deal {
    public string id                          {get; set;}
    public string division                    {get; set;}
    public string subdivision                 {get; set;}
    public list<location> locations           {get; set;}
    public list<option> options               {get; set;}
    public Account account                    {get; set;}
    public date close_date                    {get; set;}
    public date feature_start_date            {get; set;}
    public date feature_end_date              {get; set;}
    public string category                    {get; set;}
    public string subcategory                 {get; set;}
    public list<string> primary_deal_services {get; set;}
    public string account_owner_id            {get; set;}
    public DateTime page_last_date            {get; set;}
    public string record_type                 {get; set;}
    public decimal total_projected_units      {get; set;}
  }


  public class Account {
    public string id   {get; set;}
    public string name {get; set;}

    public Account(string name, string id) {
      this.name = name;
      this.id = id;
    }
  }


  global class Option {
    public string category         {get; set;}
    public string subcategory      {get; set;}
    public string salesforce_id    {get; set;}
    public decimal buy_price       {get; set;}
    public decimal sell_price      {get; set;}
    public decimal value           {get; set;}
    public decimal max_units       {get; set;}
    public list<string> services   {get; set;}
    public decimal projected_units {get; set;}
    public decimal units_sold      {get; set;}
    public option(){}

    public option(multi_deal__c md) {
      this.subcategory     = md.Subcategory_v3__c;
      this.category        = md.Category_v3__c;
      this.salesforce_id   = md.id;
      this.buy_price       = md.Unit_Buy_Price__c;
      this.sell_price      = md.Unit_Sell_Price__c;
      this.value           = md.Unit_Value__c;
      this.max_units       = md.Total_Deal_Max__c;
      this.projected_units = md.CP_Projection__c;
      this.units_sold      = md.Units_Sold__c;
      if (md.Option_Services__c!=null) {
        this.services = md.Option_Services__c.split('\\|');
      }
    }
  }


  public string getMultidealQuery(string theId) {
    string s = 'SELECT Category_v3__c, Subcategory_v3__c, Total_Deal_Max__c, Option_Attributes__c, Option_Services__c, opportunity__r.Max_Units__c, Valid_gLive_Margin__c, CP_Projection__c, Units_Sold__c, Unit_Value__c, Unit_Sell_Price__c, Unit_Buy_Price__c, Subcategory__c, Section__c, Rolling_Refund_Unit_Total__c, Opportunity__c, Name, Margin_Percent__c, MD_NPSID__c, Id, Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, Feature_Date__c, Event_Start_Date__c, Event_End_Date__c, Event_Category_Override__c, Estimated_Check_Ammount__c, CreatedDate, CreatedById, Category__c, Buyer_Max__c ';
    s += ' FROM Multi_deal__c ';
    s += ' WHERE Opportunity__c = \''+theId+'\' LIMIT 10';
    return s;
  }


  public string getAddressQuery(string theId) {
    string s = 'SELECT Street_Line_1__c,Opportunity__c, Venue_Name__c, Phone_Number__c, Street_Line_2__c, state__c, Zip_Postal_Code__c, City__c, country__c, Phone__c, Merchant_Addresses__r.Latitude__c, Merchant_Addresses__r.Longitude__c, Merchant_Addresses__r.neighborhood__c';
    s += ' FROM Address__C ';
    s += ' WHERE Opportunity__c = \''+theId+'\' LIMIT 10';
    return s;
  }


  public list<multi_deal__c> getMultiDeals(string theId) {
    string queryString = getMultidealQuery(theId);
    list<multi_deal__c> mdlist = database.query(queryString);
    return mdlist;
  }


  // TODO: some tests should create their data sted of using SeeAllData
  // I do believe seeAllData should be used for the main endpoint method
  // as it will check that the endpoint will still work when moving to a
  // larger data set
  @isTest
  static void testGetMultiDeals() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    list<multi_deal__c> multiList = sv.getMultiDeals('006C000000fI3aDIAS');
    System.assert(multiList != null);
  }

  @isTest
  static void testBuildDealFromOpportunity() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    Opportunity o = new Opportunity();
    o.name = 'testDeally';
    o.StageName = 'Closed Won';
    o.CloseDate = Date.today();
    database.upsert(o);
    Deal deal =  sv.BuildDealFromOpportunity(o);
    System.assert(deal != null);
  }

  @isTest
  static void testOption() {
    multi_deal__c md = new multi_deal__c();
    Option o = new Option(md);
    System.assert(o!=null);

    Option o2 = new Option();
    System.assert(o2!=null);
  }

  @isTest
  static void testAddLocation() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    list<location> locations =  sv.addLocations('006C000000fI3aDIAS');
    System.assert(locations != null);
  }

  @isTest
  static void testGetMultidealQuery() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    string qString = sv.getMultidealQuery('');
    System.assert(qString!=null);
  }

  @isTest
  static void testaddDealOptions() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    Opportunity o = new Opportunity();
    list<multi_deal__c> multiDealList = sv.getMultiDeals('006C000000fI3aDIAS');
    multi_deal__c md = new multi_deal__c();

    md.Option_Services__c = 'handyman';
    md.Option_Attributes__c = 'gardening';
    multiDealList.add(md);

    list<option> options =  sv.addDealOptions(o,multiDealList);
  }

  @isTest
  static void testGetAddressQuery() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    string qString = sv.getAddressQuery('');
    System.assert(qString!=null);
  }

  @isTest
  static void testFormatDeal() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    Opportunity o = new Opportunity();
    o.name = 'testDeally';
    o.StageName = 'Closed Won';
    o.CloseDate = Date.today();
    o.Primary_Deal_Services__c = 'Handyman';
    list<multi_deal__c> multiDealList = sv.getMultiDeals('006C000000fI3aDIAS');

    multi_deal__c md  = new multi_deal__c();

    md.Option_Services__c = 'handyman';
    md.Option_Attributes__c = 'gardening';
    multiDealList.add(md);

    string theId = '006C000000fI3aDIAS';

    database.upsert(o);
    Deal dl = sv.formatDeal(o, multiDealList, theId);
    System.assert(dl != null);
  }

  @isTest
  static void testLocation() {
    address__c a = new address__c();
    location loc = new location(a);
    System.assert(loc != null);
  }

  @isTest
  static void testDeal(){
    Deal deal = new Deal();
    System.assert(deal != null);
  }

  @isTest
  static void testAccount() {
    Account acc = new Account('name', 'id');
    System.assert(acc != null);
  }

  @isTest
  static void testFindDemand() {
    SalesValueDemandAPI sv = new SalesValueDemandAPI();
    Date closed_after = date.valueOf('2012-08-01');
    Date pagination_date = date.valueOf('2001-01-01');
    List<Deal> dealList =  new List<Deal>();

    Division__c d = new Division__c();
    d.name = 'philadelphia';
    d.State__c = 'PA';
    d.Permalink__c = 'philadelphia';
    Insert d;

    Opportunity op = new Opportunity();
    op.Deal_Strengh__c = 'Vetted';
    op.StageName = 'Closed Won';
    op.Division__c = 'philadelphia';
    op.Name = 'Money for Nothing';
    op.CloseDate = date.Today();
    op.Feature_Date__c = null;
    Insert op;

    dealList = sv.findDemand(closed_after, 'philadelphia', 50, pagination_date);

    System.assert(dealList != null);
  }
}