global class AMrulesEngine {
  public static List<String> caseTypes = new List<String>{'Normal Case', 'UK Mass Refunds', 'Factcheck Cases', 'UK PPAS', 'UK Amend Requests', 'UK Partnermanagement', 'UK Escalations'};

  public static void sendMerchantData(Set<Id> accountIds) {
    AMrulesEngine engine = new AMrulesEngine();
    List<Merchant> merchants = engine.getMerchants(accountIds);
    Http h = new Http();

    HttpRequest req = new HttpRequest();
    if (AM_workbench.isStaging(UserInfo.getOrganizationId())) {
      req = engine.getStagingReq();
    } else if (AM_workbench.isProduction(UserInfo.getOrganizationId())) {
      req = engine.getReq();
    } else {
      req = engine.getStagingReq();
    }
    req.setHeader('content-type', 'application/json');
    req.setBody(createJson(merchants, getCountry()));
    system.debug(req);
    HttpResponse res = h.send(req);
    system.debug(res.getBody());
  }

  @RemoteAction(callout=true)
  public static String get_am_json(Id id) {
    AMrulesEngine engine = new AMrulesEngine();
    Set<Id> accountIds = new Set<Id>();
    accountIds.add(id);
    List<Merchant> merchants = engine.getMerchants(accountIds);
    return createJson(merchants, getCountry());
  }

  @RemoteAction(callout=true)
  public static String prioritize(Id id) {
    AMrulesEngine engine = new AMrulesEngine();
    String json = get_am_json(id);
    Http h = new Http();
    HttpRequest request = new HttpRequest();
    if (AM_workbench.isStaging(UserInfo.getOrganizationId())) {
      request = engine.getStagingTestReq();
    } else if (AM_workbench.isProduction(UserInfo.getOrganizationId())) {
      request = engine.getTestReq();
    } else {
      request = engine.getStagingTestReq();
    }
    request.setHeader('content-type', 'application/json');
    request.setBody(json);
    HttpResponse response = h.send(request);
    return response.getBody();
  }

  public static String createJson(List<Merchant> merchants, String country) {
    return json.serialize(new MerchantsContainer(country, merchants));
  }

  public static String getCountry() {
    String localeKey = AM_workbench.findLocaleKey(UserInfo.getUserId());
    return getCountryByLocaleKey(localeKey);
  }

  public static String getCountryByLocaleKey(String localeKey) {
    if (localeKey == 'en_US') {
      return 'USA';
    } else if (localeKey == 'en_GB') {
      return 'UK';
    } else if (localeKey == 'en_IE') {
      return 'Ireland';
    } else if (localeKey == 'de_DE') {
      return 'Germany';
    } else if (localeKey == 'it_IT') {
      return 'Italian';
    } else if (localeKey == 'pt_BR') {
      return 'Brazil';
    } else if (localeKey == 'es_ES') {
      return 'Spain';
    } else if (localeKey == 'nl_NL') {
      return 'Netherlands';
    } else {
      return 'USA';
    }
  }

  public static String getMerchantUserID() {
    return '005C00000045Ln1';
  }

  public static String getDateLimit() {
    return '2013-01-09T06:00:00Z'; // UTC
  }

  private HttpRequest getReq() {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://am-workbench-rules.groupondev.com/GrouponRulesMVC/rest/prioritize');
    req.setMethod('POST');
    return Req;
  }

  private HttpRequest getStagingReq() {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://am-workbench-rules-staging.groupondev.com/GrouponRulesMVC/rest/prioritize');
    req.setMethod('POST');
    return Req;
  }

  private HttpRequest getTestReq() {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://am-workbench-rules.groupondev.com/GrouponRulesMVC/rest/prioritize_noop');
    req.setMethod('POST');
    return Req;
  }

  private HttpRequest getStagingTestReq() {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://am-workbench-rules-staging.groupondev.com/GrouponRulesMVC/rest/prioritize_noop');
    req.setMethod('POST');
    return Req;
  }

  global List<Merchant> getMerchants(Set<Id> accountIds) {
    List<Merchant> merchants = new List<Merchant>();
    List<Account> accounts = Database.query(getQuery(accountIds));
    Set<String> statusStrings = AM_workbench.statusStrings.clone();
    statusStrings.addAll(new Set<String>{ 'Maintenance: G2 Check In', 'Maintenance: G2 Monthly Cap Hit' });
    Date feature_min_date = System.today().addDays(-365);
    Date expiration_min_date = System.today().addDays(-91);
    List<Opportunity> opportunities = [SELECT Id, Name, Feature_Date__c, Feature_Date_Change_Date__c, Feature_End_Date__c, Deal_Vette_1_Date__c, Go_Live_Date__c, RecordType.Name, Groupon_Expiration_Date__c, X1st_Payment_Date__c, X2nd_Payment_Date__c, X3rd_Payment_Date__c, Groupon_Scheduler_Strength__c, NPSID__c, AccountId, StageName, GrouponLite_Monthly_Cap__c, Writeup_Status_del__c,
      (SELECT Id, AccountId, Subject, OwnerId, Status, Owner.Name, Owner.Profile.Name, LastModifiedDate FROM Tasks WHERE Subject in :statusStrings),
      (SELECT CreatedDate FROM Histories WHERE Field = 'Feature_Date__c' ORDER BY CreatedDate DESC)
      FROM Opportunity
      WHERE AccountId in :accounts AND StageName = 'Closed Won' AND (RecordType.Name in :AM_workbench.typeStrings OR (RecordType.Name = 'Groupon Getaways' AND Travel_Quality__c = '4. No Getaways; Approved for G1') OR (RecordType.Name = 'GrouponLive' AND AccountCoordinator__c = :AM_workbench.getUser())) AND ((Feature_Date__c > :feature_min_date OR Feature_Date__c = null) AND (Groupon_Expiration_Date__c > :expiration_min_date OR Groupon_Expiration_Date__c IN :AM_workbench.exceptionalExpirationDates OR Groupon_Expiration_Date__c = null))
    ];

    Map<Id, List<Deal>> accountDeals = new Map<Id, List<Deal>>();

    for (Opportunity o : opportunities) {
      if (accountDeals.containsKey(o.AccountId)) {
        List<Deal> deals = accountDeals.get(o.accountid);
        deals.add(new Deal(o));
        accountDeals.put(o.accountId, deals);
      } else {
        List<Deal> deals = new List<Deal>();
        deals.add(new Deal(o));
        accountDeals.put(o.accountId, deals);
      }
    }

    for (Account a : accounts) {
      Merchant merchant = new Merchant(a);
      if (accountDeals.containsKey(a.id)) {
        merchant.opportunities = accountDeals.get(a.id);
      }
      merchants.add(merchant);
    }

    return merchants;
  }

  public class MerchantsContainer {
    public string country;
    public list<Merchant> merchants;

    public MerchantsContainer(string country, list<Merchant> merchants) {
      this.country = country;
      this.merchants = merchants;
    }
  }

  global class Merchant {
    public String id {get;set;}
    public String tier {get;set;}
    public String now_merchant_activity {get;set;}
    public String rewards_offer_status {get;set;}
    public String reward_transaction_tracking_status {get;set;}
    public String zappedy_status {get;set;}
    public String nps_id {get;set;}
    public Date last_activity_date {get;set;}
    public String payments_eligible {get;set;}
    public String payments_active_status {get;set;}
    public String payments_product_sales_status {get;set;}
    public String payments_manager {get;set;}
    public String payments_lead_source {get;set;}
    public String pos_manager {get;set;}
    public String pos_interest {get;set;}
    public String category {get;set;}
    public String eligible_for_scheduler {get;set;}
    public String groupon_scheduler_strength {get;set;}
    public String scheduler_eligibilty_status {get;set;}

    public List<Deal> opportunities {get;set;}
    public List<GrouponNow__c> now_deals {get;set;}
    public List<Merchant_Survey__c> surveys {get;set;}
    public List<MerchantTemperature> temperatures {get;set;}
    public List<MerchantCase> cases {get;set;}
    public List<Task> tasks {get;set;}
    public String priority_reason {get;set;}
    public Decimal priority {get;set;}

    public Merchant (Account a) {
      this.id = a.Id;
      this.nps_id = a.NPSID__c;
      this.tier = a.Merchant_Tier__c;
      this.now_merchant_activity = a.Now_Merchant_Activity__c;
      this.rewards_offer_status = a.Rewards_Offer_Status__c;
      this.reward_transaction_tracking_status = a.Reward_Transaction_Tracking_Status__c;
      this.zappedy_status = a.Zappedy_Status__c;
      this.payments_eligible = a.Payments_Eligible__c;
      this.payments_active_status = a.Payments_Active_Status__c;
      this.payments_product_sales_status = a.Payments_Product_Sales_Status__c;
      this.payments_manager = a.Payments_Manager__c;
      this.payments_lead_source = a.Payments_Lead_Source__c;
      this.pos_manager = a.POS_Manager__c;
      this.pos_interest = a.POS_Interest__c;
      this.category = a.Category_v3__c;
      this.eligible_for_scheduler = a.Eligible_for_Scheduler__c;
      this.groupon_scheduler_strength = a.Groupon_Scheduler_Strength__c;
      this.scheduler_eligibilty_status = a.Scheduler_Eligibility_Status__c;
      this.last_activity_date = a.LastActivityDate;
      this.now_deals = a.Groupon_now__r;
      this.surveys = a.Merchant_Surveys__r;
      this.priority_reason = a.AM_Priority_Reason__c;
      this.priority = a.AM_Priority__c;

      this.temperatures = new List<MerchantTemperature>();
      for (Merchant_Temperature__c merchantTemperature : a.Merchant_Temperatures__r) {
        MerchantTemperature temperature = new MerchantTemperature();
        temperature.overall_experience_ranking = merchantTemperature.Overall_Experience_Ranking__c;
        temperature.last_modified_date = merchantTemperature.LastModifiedDate;
        this.temperatures.add(temperature);
      }

      this.cases = new List<MerchantCase>();
      for (Case kase : a.Cases) {
        MerchantCase merchantCase = new MerchantCase(kase);
        this.cases.add(merchantCase);
      }

      if (a.tasks != null) {
        this.tasks = a.tasks;
      } else {
        this.tasks = new List<Task>();
      }
    }
  }

  public class MerchantTemperature {
    public Decimal overall_experience_ranking {get;set;}
    public DateTime last_modified_date {get;set;}
  }

  public class MerchantCase {
    public String status { get;set; }

    public MerchantCase(Case kase) {
      this.status = kase.Status;
    }
  }

  public class Deal {
    public List<Task> tasks{get;set;}
    public Id id {get;set;}
    public String name {get;set;}
    public String stage_name {get;set;}
    public Date Feature_Date {get;set;}
    public DateTime Feature_Date_Change_Date {get;set;}
    public Date Feature_End_Date {get;set;}
    public Date Deal_Vette_1_Date{get;set;}
    public String recordTypeName{get;set;}
    public Date Groupon_Expiration_Date{get;set;}
    public Date Go_Live_Date {get;set;}
    public Date X1st_Payment_Date{get;set;}
    public Date X2nd_Payment_Date{get;set;}
    public Date X3rd_Payment_Date{get;set;}
    public String Groupon_Scheduler_Strength{get;set;}
    public String NPSID{get;set;}
    public Decimal groupon_lite_monthly_cap {get;set;}
    public Id accountid {get;set;}
    public String writeup_status {get;set;}

    public Deal(opportunity o) {
      this.id = o.id;
      this.name = o.name;
      this.stage_name = o.StageName;
      this.feature_date = o.Feature_Date__c;

      if (o.Histories.size() > 0) {
        this.feature_date_change_date = o.Histories[0].CreatedDate;
      } else {
        this.feature_date_change_date = o.Feature_Date_Change_Date__c;
      }

      this.feature_end_date = o.Feature_End_Date__c;
      this.go_live_date = o.Go_Live_Date__c;
      this.deal_vette_1_date = o.deal_vette_1_date__c;
      this.recordTypeName = o.recordType.name;
      this.Groupon_Expiration_Date = o.Groupon_Expiration_Date__c;
      this.X1st_Payment_Date = o.X1st_Payment_Date__c;
      this.X2nd_Payment_Date = o.X2nd_Payment_Date__c;
      this.X3rd_Payment_Date = o.X3rd_Payment_Date__c;
      this.Groupon_Scheduler_Strength = o.Groupon_Scheduler_Strength__c;
      this.NPSID = o.NPSID__c;
      this.accountid = o.accountid;
      this.groupon_lite_monthly_cap = o.GrouponLite_Monthly_Cap__c;
      this.writeup_status = o.Writeup_Status_del__c;

      if (o.tasks != null) {
        this.tasks = o.tasks;
      } else {
        this.tasks = new list<task>();
      }
    }
  }

  public string getQuery(Set<Id> accountIds) {
    string query = 'SELECT ID, name, Merchant_Tier__c, NPSID__c, Now_Merchant_Activity__c, Rewards_Offer_Status__c, Reward_Transaction_Tracking_Status__c, Zappedy_Status__c, LastActivityDate, Payments_Eligible__c, Payments_Active_Status__c, Payments_Product_Sales_Status__c, Payments_Manager__c, Payments_Lead_Source__c, Eligible_for_Scheduler__c, Groupon_Scheduler_Strength__c, Scheduler_Eligibility_Status__c, AM_Priority__c, AM_Priority_Reason__c, POS_Manager__c, POS_Interest__c, Category_v3__c, (SELECT Status FROM Cases WHERE TYPE in :caseTypes), (SELECT Id, NOW_Start_Date__c, Stage__c, Deal_Strength__c, Deal_End_Date__c FROM Groupon_Now__r), (SELECT Overall_Satisfaction__c, Run_Another_Deal__c, Recommend__c FROM Merchant_Surveys__r), (SELECT LastModifiedDate, Overall_Experience_Ranking__c FROM Merchant_Temperatures__r WHERE LastModifiedById = \'' + getMerchantUserID() + '\' AND LastModifiedDate >= ' + getDateLimit() + '), (SELECT Id, AccountId, Subject, Status, LastModifiedDate FROM Tasks WHERE Subject in (\'Maintenance: Merchant Temperature Follow Up\', \'Maintenance: Sign of Life\')) FROM ACCOUNT';
    query += ' WHERE id in :accountIds';
    return query;
  }
}