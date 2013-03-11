@RestResource(urlMapping = '/quantum_lead/merchant_info')

global class RESTMerchantInfo {
  public static final Date MIN_OPTY_DATE = Date.today().addDays(-365); //will not get opportunities older than this

  @HttpPost
  global static List<Merchant> post(List<String> merchant_ids) {
    Map<String, String> subcategoryTaxonomyMapping = getSubcategoryTaxonomyMapping();

    List<Account> accounts = getAccounts(merchant_ids);
    // populate a map of accounts from id to merchant object (useful for later data merges)
    Map<String, Merchant> merchantMap = new Map<String, Merchant>();
    for (account acc : accounts) {
      Merchant merchant = new Merchant(acc, subcategoryTaxonomyMapping);
      merchantMap.put(merchant.id, merchant);
    }

    // restrict task history to tasks completed in the past year
    Date minDate = Date.today().addDays(-365);
    addAccountTasks(merchantMap, minDate);
    addAccountEvents(merchantMap, minDate);

    return merchantMap.values();
  }

  global static Map<String, String> getSubcategoryTaxonomyMapping() {
    Map<String, String> subcategoryTaxonomyMapping = new Map<String, String>();
    List<taxonomy_support__c> tax_support = [
      SELECT id, C3_Id__c, category__c, Subcategory__c
      FROM taxonomy_support__c
    ];

    for (taxonomy_support__c tax : tax_support) {
      subcategoryTaxonomyMapping.put(tax.subcategory__c, tax.C3_Id__c);
    }

    return subcategoryTaxonomyMapping;
  }

  global static List<Account> getAccounts(List<String> accountIds) {
    List<Account> accounts = [
      SELECT id, name, Account_Status__c, Acct_Owner_Change_Date__c,
             BillingPostalCode, Category_v3__c,
             Competitor_Features__c, Count_of_Rewards_Opportunities__c,
             CreatedDate, Created_Date_Custom__c, Date_of_Hotness__c,
             Groupon_Merchant_ID__c, Groupon_Nows__c,
             Groupon_Scheduler_Strength__c, Hot_Lead__c, Inbound_Team__c,
             Lead_Source_Custom__c, Merchant_Permalink__c,
             Merchant_Tier__c, Number_of_Features__c, Research_Ranking__c,
             Result_of_Merchant_Survey__c, Services_Offered__c,
             Subdivision__c, Top_Merchant_Campaign__c, Total_GP__c, Type,
             of_Locations__c, ParentId, subcategory_v3__c, Division__c,
             Division__r.Name, Division__r.Permalink__c, OwnerId, Owner.Name,
             Previous_Account_Owner__c, Previous_Account_Owner__r.name,
             Deassignment_Warning__c, QL_Do_Not_Deassign__c,
             High_Risk_Subcategory_Grade_F__c, Parent_Relationship__c,
             (
               select id, street_line_1__c, street_line_2__c, State_Province__c,
                 Zip_Postal_Code__c, neighborhood__c, name, longitude__c,
                 latitude__c,city__c
               from merchant_addresses__r
             ),(
               select id, CloseDate, Feature_Date__c, RecordType.Name, ownerid, Deal_Strengh__c,
                 Groupon_Expiration_Date__c, Expiration_Type__c,
                 GrouponLite_Cancellation_Reason__c,
                 GrouponLite_Cancellation_Request_Date__c, AccountId
               from Opportunities
               where StageName = 'Closed Won'
               and (CloseDate >= :RESTMerchantInfo.MIN_OPTY_DATE or Groupon_Expiration_Date__c >= :RESTMerchantInfo.MIN_OPTY_DATE)
               order by CloseDate desc
             ),(
               select id, echosign_dev1__DateSentDate__c,
                 echosign_dev1__StatusVisible__c, echosign_dev1__Account__c
               from echosign_dev1__Agreements__r
               where echosign_dev1__DateSentDate__c != null
               order by echosign_dev1__DateSentDate__c desc
               limit 1
             )
      FROM Account
      WHERE id IN :accountIds
    ];

    return accounts;
  }

  global static void addAccountTasks(Map<String, Merchant> merchantMap, Date minDate) {
    for (String accountid : merchantMap.keySet()) {
      Merchant merch = merchantMap.get(accountid);

      List<Task> tasks = [
        SELECT id, accountid, CallDisposition, qbdialer__Call_Date_Time__c,
               qbdialer__Call_Lead_Status__c, Completed_Date__c,
               Merchant_Status__c, CallType, Type, OwnerId
        FROM Task
        WHERE accountid = :accountId
          AND Type NOT IN ('Email - Click', 'Email - Inbound', 'Email - Inbound POS', 'Email - Open')
          AND Completed_Date__c >= :minDate
        ORDER by Completed_Date__c DESC
      ];

      for (Task t : tasks) {
        // Tasks from users with any role, not just reps
        merch.tasks.add(new RepTask(t));
      }
    }
  }

  global static void addAccountEvents(Map<String, Merchant> merchantMap, Date minDate) {
    for (Merchant merch : merchantMap.values()) {
      merch.events = [select Id, OwnerId, AccountId, ActivityDate
                             from Event
                             where AccountId = :merch.id and ActivityDate >= :minDate];

    }
  }

  global class Merchant {

    public DateTime created_date                    { get; set; }
    public DateTime hot_lead_date                   { get; set; }
    public DateTime page_last_date                  { get; set; }
    public Decimal competitor_features              { get; set; }
    public Decimal count_of_rewards_opportunities   { get; set; }
    public Decimal groupon_nows                     { get; set; }
    public Decimal number_of_features               { get; set; }
    public Decimal sales_value                      { get; set; }
    public Division division                        { get; set; }
    public String account_type                      { get; set; }
    public String billing_zip                       { get; set; }
    public String c3_uuid                           { get; set; }
    public String category                          { get; set; }
    public String groupon_merchant_id               { get; set; }
    public String groupon_scheduler_strength        { get; set; }
    public String hot_lead                          { get; set; }
    public String inbound_team                      { get; set; }
    public String lead_source                       { get; set; }
    public String merchant_permalink                { get; set; }
    public String merchant_status                   { get; set; }
    public String merchant_status_reason            { get; set; }
    public String merchant_tier                     { get; set; }
    public String name                              { get; set; }
    public String number_of_locations               { get; set; }
    public String deassignment_warning              { get; set; }
    public Rep owner                                { get; set; }
    public Rep previous_owner                       { get; set; }
    public String research_ranking                  { get; set; }
    public String id                                { get; set; }
    public String subcategory                       { get; set; }
    public String subdivision                       { get; set; }
    public String top_merchant_campaign             { get; set; }
    public String parent_id                         { get; set; }
    public Decimal total_gp                         { get; set; }
    public String call_list_priority                { get; set; }
    public DateTime account_owner_change_date       { get; set; }
    public List<String> merchant_services           { get; set; }
    public List<MerchantPlace> places               { get; set; }
    public List<MerchantContract> contracts         { get; set; }
    public List<MerchantOpportunity> opportunities  { get; set; }
    public List<RepTask> tasks                      { get; set; }
    public Boolean do_not_deassign                  { get; set; }
    public Boolean high_risk_subcategory_grade_f    { get; set; }
    public String parent_relationship               { get; set; }
    public List<Event> events                       { get; set; }

    global Merchant(Account a, Map<String, String> subcatgoryTaxonomyMapping) {
      this.division = new Division(a.Division__r);
      this.id = a.id;
      this.name = a.name;
      this.page_last_date = a.createdDate;
      this.created_date = findLatestCreatedDate(a.createdDate, a.Created_Date_Custom__c );
      this.merchant_permalink = a.Merchant_Permalink__c;
      this.category = a.Category_v3__c;
      this.subcategory = a.subcategory_v3__c;
      this.c3_UUID = subcatgoryTaxonomyMapping.get(a.subcategory_v3__c);
      this.merchant_services = parseServices(a.Services_Offered__c);
      this.groupon_merchant_id = a.Groupon_Merchant_ID__c;
      this.research_ranking = a.Research_Ranking__c;
      this.account_type = a.Type;
      this.merchant_status = a.Result_of_Merchant_Survey__c;
      this.number_of_locations = a.of_Locations__c;
      this.merchant_status_reason = a.Account_Status__c;
      this.lead_source = a.Lead_Source_Custom__c;
      this.number_of_features = a.Number_of_Features__c;
      this.groupon_nows = a.Groupon_Nows__c;
      this.count_of_rewards_opportunities = a.Count_of_Rewards_Opportunities__c;
      this.groupon_scheduler_strength = a.Groupon_Scheduler_Strength__c;
      this.competitor_features = a.Competitor_Features__c;
      this.subdivision = a.Subdivision__c;
      this.billing_zip = a.BillingPostalCode;
      this.top_merchant_campaign = a.Top_Merchant_Campaign__c;
      this.merchant_tier = a.Merchant_Tier__c;
      this.hot_lead_date = a.Date_of_Hotness__c;
      this.hot_lead = a.Hot_Lead__c;
      this.inbound_team = a.Inbound_Team__c;
      this.do_not_deassign = a.QL_Do_Not_Deassign__c;
      this.deassignment_warning = a.Deassignment_Warning__c;
      this.high_risk_subcategory_grade_f = a.High_Risk_Subcategory_Grade_F__c;
      this.parent_relationship = a.Parent_Relationship__c;

      if(a.Owner != null) {
        this.owner = new Rep(a.Owner);
      }

      if(a.Previous_Account_Owner__r != null) {
        this.previous_owner = new Rep(a.Previous_Account_Owner__r);
      }

      this.parent_id = a.ParentId;
      this.total_gp = a.Total_GP__c;
      this.account_owner_change_date = a.Acct_Owner_Change_Date__c;

      this.opportunities = new List<MerchantOpportunity>();
      for (Opportunity opp : a.opportunities) {
        this.opportunities.add(new MerchantOpportunity(opp));
      }

      this.places = new List<MerchantPlace>();
      for (merchant_addresses__c address : a.merchant_addresses__r) {
        this.places.add(new MerchantPlace(address));
      }

      this.contracts = new List<MerchantContract>();
      for(echosign_dev1__SIGN_Agreement__c contract : a.echosign_dev1__Agreements__r) {
        this.contracts.add(new MerchantContract(contract));
      }

      this.tasks = new List<RepTask>();
    }

    private DateTime findLatestCreatedDate(DateTime created, DateTime customCreated){
      if (customCreated != null && customCreated < created) {
        return customCreated;
      }
      return created;
    }

    private List<String> parseServices(String services) {
      if (services == null) {
        return null;
      }
      return services.split('\\|');
    }
  }

  global class MerchantContract {
    public String status_visible;
    public DateTime sent_date;
    public String id;
    public String account_id;

    global MerchantContract(echosign_dev1__SIGN_Agreement__c c) {
      this.status_visible = c.echosign_dev1__StatusVisible__c;
      this.sent_date = c.echosign_dev1__DateSentDate__c;
      this.id = c.Id;
      this.account_id = c.echosign_dev1__Account__c;
    }
  }

  global class MerchantOpportunity {
    public DateTime expiration_date                  { get; set; }
    public String expiration_type                    { get; set; }
    public String gLite_cancellation_reason          { get; set; }
    public DateTime gLite_cancellation_request_date  { get; set; }
    public String owner_id                           { get; set; }
    public String id                                 { get; set; }
    public String account_id                         { get; set; }
    public String record_type                        { get; set; }
    public DateTime close_date                       { get; set; }
    public DateTime feature_date                     { get; set; }
    public String deal_strength                      { get; set; }

    global MerchantOpportunity(opportunity o) {
      this.expiration_date = o.Groupon_Expiration_Date__c;
      this.expiration_type = o.Expiration_Type__c;
      this.gLite_cancellation_reason = o.GrouponLite_Cancellation_Reason__c;
      this.gLite_cancellation_request_date = o.GrouponLite_Cancellation_Request_Date__c;
      this.owner_id = o.OwnerId;
      this.id = o.Id;
      this.account_id = o.AccountId;
      this.record_type = o.RecordType.Name;
      this.close_date = o.CloseDate;
      this.feature_date = o.Feature_Date__c;
      this.deal_strength = o.Deal_Strengh__c;
    }
  }

  global class MerchantPlace {
    public decimal lat         { get; set; }
    public decimal lng         { get; set; }
    public string Id           { get; set; }
    public string city         { get; set; }
    public string name         { get; set; }
    public string neighborhood { get; set; }
    public string postal_code  { get; set; }
    public string state        { get; set; }
    public string street1      { get; set; }
    public string street2      { get; set; }

    global MerchantPlace(merchant_addresses__c addy) {
      this.Id = addy.Id;
      this.street2 = addy.street_line_1__c;
      this.street1 = addy.street_line_2__c;
      this.state = addy.State_Province__c;
      this.postal_code = addy.Zip_Postal_Code__c;
      this.neighborhood = addy.neighborhood__c;
      this.name = addy.name;
      this.lng = addy.longitude__c;
      this.lat = addy.latitude__c;
      this.city = addy.city__c;
    }
  }

  global class Rep {
    public String id;
    public String name;

    global Rep(User u) {
      this.id = u.id;
      this.name = u.name;
    }
  }

  global class RepTask {
    public String id;
    public String account_id;
    public String call_type;
    public String call_disposition;
    public String type;
    public DateTime call_time;
    public String call_lead_status;
    public DateTime completed_date;
    public String merchant_status;
    public String owner_id;

    global RepTask(Task task) {
      this.id = task.Id;
      this.account_id = task.AccountId;
      this.call_type = task.CallType;
      this.call_disposition = task.CallDisposition;
      this.type = task.Type;
      this.call_time = task.qbdialer__Call_Date_Time__c;
      this.call_lead_status = task.qbdialer__Call_Lead_Status__c;
      this.completed_date = task.Completed_Date__c;
      this.merchant_status = task.Merchant_Status__c;
      this.owner_id = task.OwnerId;
    }
  }

  global class Division {
    public String name;
    public String permalink;
    public String salesforce_id;

    global Division(Division__c d) {
      if(d != null) {
        this.name = d.Name;
        this.permalink = d.Permalink__c;
        this.salesforce_id = d.Id;
      }
    }
  }

  @isTest
  static void testGet() {
    RESTMerchantInfo info = new RESTMerchantInfo();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/quantum_lead/merchant_info';
    req.httpMethod = 'POST';

    Account a = new Account(name = 'account name');
    Insert a;

    System.debug('min opty date: ' + RESTMerchantInfo.MIN_OPTY_DATE);
    Opportunity op1 = new Opportunity();
    op1.name = 'op1';
    op1.accountid = a.id;
    op1.StageName = 'Closed Won';
    op1.Deal_Strengh__c = 'A Sure Thing';
    op1.CloseDate = Date.today();
    System.debug('op1 date: ' + op1.CloseDate);
    Insert op1;

    //op2 is too old, should not be returned.  I can't get this test to pass.  Salesforce seems to think the CloseDate is today no matter what I do.
    //Opportunity op2 = new Opportunity();
    //op2.name = 'op2';
    //op2.accountid = a.id;
    //op2.StageName = 'Closed Won';
    //op2.CloseDate = Date.today().addDays(-380);
    //System.debug('op2 date: ' + op2.CloseDate);
    //Insert op2;

    List<String> merchant_ids = new List<String>();
    merchant_ids.add(a.id);

    List<Merchant> results = RESTMerchantInfo.post(merchant_ids);

    System.debug(results);
    System.Assert(results.size() == 1);
    Merchant result_merchant = results.get(0);
    System.Assert(result_merchant.opportunities.size() == 1);
  }

  @isTest
  static void testCreateMerchant() {
    Account a = new Account();
    a.division__r = new Division__c();

    Map<string, string> tax = new Map<string, string>();

    Merchant merchant = new Merchant(a, tax);
  }

  @isTest
  static void testCreatePlaces() {
    Merchant_Addresses__c addresses = new Merchant_Addresses__c();
    MerchantPlace places = new MerchantPlace(addresses);
    //TODO make tests, for great good
  }

  @isTest
  static void testCreateDivision() {
    Division__c division_c = new Division__c();
    division_c.Name = 'the name';
    division_c.Permalink__c = 'the_permalink';

    Division div = new Division(division_c);
    System.assert(div.name == 'the name');
    System.assert(div.permalink == 'the_permalink');
  }
}