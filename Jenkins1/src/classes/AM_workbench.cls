public class AM_workbench {
  public Map<Id, List<Task>> opp_tasks = new map<id,list<task>>();
  public Map<Id, POS_Order__c> merchant_orders = new map<id,POS_Order__c>();
  public Set<Id> oppIds = new set<id>();
  public List<Merchant> myMerchants {get;set;}
  public static Set<String> statusStrings = new set<string>{
    'Prep: Intro Call',
    'Prep: Prep Call',
    'Prep: Email',
    'Prep: Getting Ready',
    'Prep: Feature Date Confirmed',
    'Prep: MC Walkthrough',
    'Prep: Merchant Center Walkthrough',
    'Prep: Preview Delivered',
    'Prep: Preview Approved',
    'Maintenance: Day After',
    'Maintenance: Pre Expiration',
    'Maintenance: Merchant Temperature Follow Up',
    'Maintenance: Sign of Life'
  };
  public static Set<String> typeStrings = new set<string>{'G1', 'gLite'};
  public static Set<Date> exceptionalExpirationDates = new Set<Date>{Date.parse('1/1/1900'), Date.parse('1/1/2100')};
  public static String US_staging    = '00Dc0000000w1BpEAI';
  public static String US_production = '00D80000000KhmyEAC';
  public static String UK_staging    = '00DP00000007iDSMAY';
  public static String UK_production = '00D20000000MeJAEA0';
  public static final String MERCHANT_ID = '005C00000045Ln1IAE';

  public static Set<String> strengths = new Set<String>{'Rejected - Product Constraints', 'Rejected - Ineligible', 'Declined', 'Deactivated'};
  public static Set<String> eligibilities = new Set<String>{'Rejected - Product Constraints', 'Rejected - Ineligible', 'Not Interested'};
  public static Set<String> warningStrengths = new Set<String>{'', NULL, 'Contacted', 'Pending Contact'};
  public Boolean showAll {get; set;}
  public Integer numberOfScriptStatements {get; set;}

  public static String getUser() {
    return UserInfo.getUserId();
  }

  public class UserLocation {
  }

  public static AM_workbenchTaskFactory.FactoryInterface getMerchantTaskFactory() {
    if ( getIsInternational() ) {
      return new AM_workbenchTaskFactory.International();
    } else {
      return new AM_workbenchTaskFactory.Us();
    }
  }

  public static boolean getIsInternational() {
    return AM_workbench.isUKInstance(UserInfo.getOrganizationId());
  }

  public static boolean getIsUK() {
    return AM_workbench.getIsInternational() && (AM_workbench.findLocaleKey(AM_workbench.getUser()) == 'en_GB');
  }

  public static String shortId(String longId) {
    return longId.substring(0,15);
  }

  public static boolean isUKInstance( String organizationId ){
    return UK_staging == organizationId || shortId(UK_staging) == organizationId || UK_production == organizationId || shortId(UK_production) == organizationId;
  }

  public static boolean isStaging( String organizationId ){
    return UK_staging == organizationId || shortId(UK_staging) == organizationId || US_staging == organizationId || shortId(US_staging) == organizationId;
  }

  public static boolean isProduction( String organizationId ){
    return UK_production == organizationId || shortId(UK_production) == organizationId || US_production == organizationId || shortId(US_production) == organizationId;
  }

  public static String findUserName(Id userId) {
    User[] users = [SELECT Name FROM User WHERE Id = :userId];
    String name = '';

    if (users.size() > 0) {
      name = users[0].Name;
    }

    return name;
  }

  public static String findLocaleKey(Id userId) {
    User[] locales = [SELECT LocaleSidKey FROM User WHERE Id = :userId];
    String locale = '';

    if (locales.size() > 0) {
      locale = locales[0].LocaleSidKey;
    }

    return locale;
  }

  public class MerchantTask {
    public String id {get;set;}
    public String subject {get;set;}
    public String status {get;set;}
    public String description {get;set;}
    public String whatId {get;set;}
    public List<String> statuses {get;set;}
    public Boolean openModal {get;set;}
    
    public MerchantTask() {
    }

    public MerchantTask(Task t, String defaultSubject, String defaultWhatId) {
      this.subject = defaultSubject;
      this.whatId = defaultWhatId;
    }
  }

  @RemoteAction
  public static MerchantTask getPrepTask(string subject, string whatId){
    Task t = new Task();

    try {
      t = [select id, subject, Status, Description, WhatId from Task where WhatId = :whatId and subject = :subject LIMIT 1];
    } catch (exception e) {
      System.debug(e);
    }

    return getMerchantTaskFactory().build( t, subject, whatId );
  }

  @RemoteAction
  public static list<DealOption> getOptions(string id){
    List<DealOption> deal_options = new List<DealOption>();
    List<Multi_deal__c> multi_deals = [select id, name, Unit_Value__c, Unit_sell_Price__c, Discount__c, Total_Deal_Max__c, GrouponLite_Monthly_Cap__c from Multi_deal__c where opportunity__c = :id];
    for (Multi_deal__c md : multi_deals) {
      DealOption d = new DealOption();
      d.id = md.id;
      d.name = md.name;
      d.unitValue = md.Unit_Value__c;
      d.unitSellPrice = md.Unit_sell_Price__c;
      d.discount = md.Discount__c;
      d.optionCap = md.Total_Deal_Max__c;
      d.grouponLiteMonthlyCap = md.GrouponLite_Monthly_Cap__c;

      deal_options.add(d);
    }
    return deal_options;
  }

  @RemoteAction
  public static MerchantPayment getPaymentModal(string id) {
    Account a = [select Id, Name, Payments_Eligible__c, Payments_Product_Sales_Status__c, Payments_Active_Status__c, Payments_Interested__c, Payments_Lead_Source__c, Payments_Product_Notes__c, Payments_Manager__c from Account where Id = :id][0];
    return new MerchantPayment(a);
  }

  @RemoteAction
  public static Scheduler getSchedulerModal(String id) {
    return new Scheduler([SELECT Id, Scheduler_Eligibility_Status__c, Name, Groupon_Scheduler_Strength__c, Scheduler_Specialist__c, Scheduler_Specialist__r.Name, (SELECT Id, Name, Groupon_Scheduler_Strength__c FROM Opportunities WHERE stageName = 'Closed Won' AND RecordType.Name !='Rewards') FROM account WHERE Id = :id LIMIT 1] );
  }

  @RemoteAction
  public static Breadcrumb getBreadcrumbModal(String id) {
    Account a = [select Id, Name, Category_v3__c, POS_Interest__c, POS_Lead_Source__c, POS_Manager__c, POS_Lead_Source_Other__c from Account where Id = :id][0];
    List<POS_Order__c> blist = [select Id, POS_Sales_Status__c, HSA_GoLive__c from POS_Order__c where Account__c = :id];
    return new Breadcrumb(a, blist);
  }

  @RemoteAction
  public static QuantumLead getQuantumLeadModal(String id) {
    List<Quantum_Lead__c> leads = [SELECT Sales_Value_Reasons__c, Sales_Value__c, Call_List_Priority__c FROM Quantum_Lead__c WHERE Account__c = :id];
    Quantum_Lead__c lead = new Quantum_Lead__c();
    if (leads.size() > 0) {
      lead = leads[0];
    }
    return new QuantumLead(lead);
  }

  @RemoteAction
  public static void prioritize() {
    date feature_min_date = System.today().addDays(-365);
    date expiration_min_date = System.today().addDays(-91);
    List<Merchant> merchants = new List<Merchant>();
    Set<Id> accountIds = new Set<Id>();

    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT AccountId FROM Opportunity WHERE (Account.Account_Manager__c = :AM_workbench.getUser() OR AccountCoordinator__c = :AM_workbench.getUser()) AND stageName = 'Closed Won' AND (recordType.name in :AM_workbench.typeStrings OR (recordType.name = 'Groupon Getaways' AND Travel_Quality__c = '4. No Getaways; Approved for G1') OR (recordType.name = 'GrouponLive' AND AccountCoordinator__c = :AM_workbench.getUser() )) AND ((Feature_Date__c > :feature_min_date OR Feature_Date__c = null) AND (Groupon_Expiration_Date__c > :expiration_min_date OR Groupon_Expiration_Date__c IN :AM_workbench.exceptionalExpirationDates OR Groupon_Expiration_Date__c = null))]);
    Set<Id> opportunityIds = opportunityMap.keySet();
    for (Opportunity o : opportunityMap.values()) {
      accountIds.add(o.AccountId);
    }

    List<Account> accounts = [SELECT Id FROM Account WHERE Account_Manager__c = :AM_workbench.getUser() OR Id IN :accountIds];
    Set<Id> ids = new Set<Id>();
    for (Account account: accounts) {
      ids.add(account.Id);
    }

    AM_workbenchBatch batch = new AM_workbenchBatch(ids, 100);
    while( batch.hasNext() )
    {
      AMrulesEngine.sendMerchantData( batch.next() );
    }
  }

  @RemoteAction
  public static void prioritize_merchant(string id) {
    Id accountId = id;
    Set<Id> accountIds = new Set<Id>{accountId};
    AMrulesEngine.sendMerchantData(accountIds);
  }

  @RemoteAction
  public static list<Merchant> grouponNow(string id) {
    List<Account> accounts = [Select id, name, Now_Merchant_Activity__c, Interested_in_NOW__c, Total_Now_Revenue__c, Total_Now_Units__c, Last_Week_Active__c, (select id, Stage__c, Account_Name__r.Name, Account_Name__c, Deal_Owner__R.name, Now_Category__c, Deal_Name__c, Close_Date__c, Account_Name__r.Now_Merchant_Activity__c FROM Groupon_Now__r) FROM ACCOUNT WHERE id =  :id];
    List<Merchant> merchants = new List<Merchant>();
    for (Account a : accounts) {
      Merchant m = new Merchant();

      m.id = a.Id;
      m.name = a.Name;
      m.nowMerchantActivity = a.Now_Merchant_Activity__c;
      m.interestedInNow = a.Interested_in_NOW__c;
      m.totalNowRevenue = a.Total_Now_Revenue__c;
      m.totalNowUnits = a.Total_Now_Units__c;
      m.lastWeekActive = a.Last_Week_Active__c;
      m.now_deals = new List<Now>();

      for (GrouponNow__c g : a.Groupon_Now__r) {
        Now n = new Now(g);
        n.id = g.Id;
        n.stage = g.Stage__c;
        if (g.Account_Name__c != null) {
          n.accountNameName = g.Account_Name__r.Name;
          n.accountNameNowMerchantActivity = g.Account_Name__r.Now_Merchant_Activity__c;
        }
        n.accountName = g.Account_Name__c;
        if (g.Deal_Owner__r != null) {
          n.dealOwnername = g.Deal_Owner__r.Name;
        }
        n.category = g.Now_Category__c;
        n.dealName = g.Deal_Name__c;
        n.closeDate = g.Close_Date__c;
        m.now_deals.add(n);
      }

      merchants.add(m);
    }

    return merchants;
  }

  @RemoteAction
  public static list<MerchantReward> rewards(string theId){
    List<Opportunity> opportunities = [select id, name, stageName, closeDate, owner.name, Division__c, account.Category_v3__c, account.Rewards_Offer_Status__c, Account.Reward_Transaction_Tracking_Status__c from Opportunity where RecordType.name='Rewards' AND accountid = :theId];
    List<MerchantReward> rewards = new List<MerchantReward>();
    for (Opportunity o : opportunities) {
      MerchantReward reward = new MerchantReward();
      reward.id = o.Id;
      reward.name = o.Name;
      reward.stageName = o.StageName;
      reward.closeDate = o.CloseDate;
      if (o.Owner != NULL) {
        reward.ownerName = o.Owner.Name;
      } else {
        reward.ownerName = '';
      }
      reward.division = o.Division__c;
      if (o.Account != NULL) {
        reward.accountCategory = o.Account.Category_v3__c;
        reward.accountRewardsOfferStatus = o.Account.Rewards_Offer_Status__c;
        reward.accountRewardsTransactionTrackingStatus = o.Account.Reward_Transaction_Tracking_Status__c;
      } else {
        reward.accountCategory = '';
        reward.accountRewardsOfferStatus = '';
        reward.accountRewardsTransactionTrackingStatus = '';
      }
      rewards.add(reward);
    }
    return rewards;
  }

  @RemoteAction
  public static Obj taskIt(Task task){
    task.ActivityDate = System.today();
    database.upsert(task);
    return new AM_workbench().getStatusCode(task);
  }

  public Obj getStatusCode(Task task) {
    Map<String, Obj> statusCode = AM_workbenchTaskFactory.subjectStatusCode.get(task.Subject);
    return statusCode.get(task.Status);
  }

  @RemoteAction
  public static List<MerchantContact> merchant_contacts(String contactId, String dealId){
    List<Contact> contacts = [SELECT Id, Name, Phone, Email, MobilePhone, AccountId FROM Contact WHERE AccountId = :contactId];
    List<MerchantContact> merchantContacts = new List<MerchantContact>();

    for (Contact c : contacts) {
      MerchantContact mc = new MerchantContact();
      mc.id = c.Id;
      mc.name = c.Name;
      mc.phone = c.Phone;
      mc.email = c.Email;
      mc.mobilePhone = c.MobilePhone;
      mc.accountId = c.AccountId;
      mc.dealId = dealId;
      merchantContacts.add(mc);
    }

    return merchantContacts;
  }

  public list<obj> getStatusCodes(list<task> tasks, List<Obj> status){
    if( getIsInternational() ){
      for( task t: tasks ){
        if( t.subject == 'Prep: Prep Call' ){
          status[0] = getStatusCode( t );
        }else if( t.subject == 'Prep: Email' ){
          status[1] = getStatusCode( t );
        }else if( t.subject == 'Prep: Merchant Center Walkthrough' ){
          status[2] = getStatusCode( t );
        }else if( t.subject == 'Prep: Preview Delivered' ){
          status[3] = getStatusCode( t );
        }else if( t.subject == 'Prep: Preview Approved' ){
          status[4] = getStatusCode( t );
        }else if( t.subject == 'Maintenance: Day After' ){
          status[5] = getStatusCode( t );
        }else if( t.subject == 'Maintenance: Pre Expiration' ){
          status[6] = getStatusCode( t );
        }
      }
    } else {
      for( task t: tasks ){
        if( t.subject == 'Prep: Intro Call' ){
          status[0] = getStatusCode( t );
        }else if( t.subject == 'Prep: Getting Ready' ){
          status[1] = getStatusCode( t );
        }else if( t.subject == 'Prep: Feature Date Confirmed' ){
          status[2] = getStatusCode( t );
        }else if( t.subject == 'Prep: MC Walkthrough' ){
          status[3] = getStatusCode( t );
        }else if( t.subject == 'Prep: Preview Delivered' ){
          status[4] = getStatusCode( t );
        }else if( t.subject == 'Prep: Preview Approved' ){
          status[5] = getStatusCode( t );
        }else if( t.subject == 'Maintenance: Day After' ){
          status[6] = getStatusCode( t );
        }else if( t.subject == 'Maintenance: Pre Expiration' ){
          status[7] = getStatusCode( t );
        }
      }
    }

    return status;
  }

  @RemoteAction
  public static List<Merchant> searchMerchants(String searchString) {
    AM_workbench workbench = new AM_workbench();
    return workbench.getMerchantList(searchString);
  }

  public static List<Obj> getDefaultStatusCodes(String organizationId) {
    if( isUKInstance( organizationId )){
      return new List<Obj>{
        new Obj('PREP', 'Prep: Prep Call', ''),
        new Obj('EMAIL', 'Prep: Email', ''),
        new Obj('MC', 'Prep: Merchant Center Walkthrough', ''),
        new Obj('PS', 'Prep: Preview Delivered', ''),
        new Obj('PA', 'Prep: Preview Approved', ''),
        new Obj('DA', 'Maintenance: Day After', ''),
        new Obj('PE', 'Maintenance: Pre Expiration', '')
      };
    } else {
      return new List<Obj>{
        new Obj('IN', 'Prep: Intro Call', ''),
        new Obj('GR', 'Prep: Getting Ready', ''),
        new Obj('FD', 'Prep: Feature Date Confirmed', ''),
        new Obj('MC', 'Prep: MC Walkthrough', ''),
        new Obj('PS', 'Prep: Preview Delivered', ''),
        new Obj('PA', 'Prep: Preview Approved', ''),
        new Obj('DA', 'Maintenance: Day After', ''),
        new Obj('PE', 'Maintenance: Pre Expiration', '')
      };
    }
  }

  public List<Merchant> getMerchantList(String searchString) {
    date feature_min_date = Date.parse('1/1/1900');
    date expiration_min_date = Date.parse('1/1/1900');
    List<Merchant> merchants = new List<Merchant>();
    Set<Id> accountIds = new Set<Id>();
    Set<Id> merchantIds = new Set<Id>();
    Set<Id> opportunityIds = new Set<Id>();

    for (Opportunity o : Database.query(AM_workbench.getOpportunityQuery() + ' AND (Name LIKE \'%' + searchString + '%\' OR Account.Name LIKE \'%' + searchString + '%\')')) {
      accountIds.add(o.AccountId);
      opportunityIds.add(o.Id);
    }

    for (Contact c : Database.query(AM_workbench.getContactQuery(searchString))) {
      accountIds.add(c.AccountId);

      for (Opportunity o : Database.query(AM_workbench.getOpportunityQuery() + ' AND AccountId = \'' + c.AccountId + '\'')) {
        opportunityIds.add(o.Id);
      }
    }

    for (Account a : Database.query(AM_workbench.getMerchantSearchQuery(searchString))) {
      merchants.add(new Merchant(a));
      merchantIds.add(a.Id);
    }

    opp_tasks = getTaskMap(opportunityIds);
    merchant_orders = getOrderMap(merchantIds);

    List<Obj> defaultStatusCodes = AM_workbench.getDefaultStatusCodes(UserInfo.getOrganizationId());

    for (Merchant merchant : merchants) {
      merchant.sortStrategy = 'clp';
    }
    merchants.sort();
    Decimal size = merchants.size();

    for (integer index = 0; index < size; index += 1) {
      Merchant merchant = merchants[index];
      for (g1 deal: merchant.g1deals) {
        if (opp_tasks.containsKey(deal.id)) {
          deal.tasks = opp_tasks.get(deal.id);
        } else {
          deal.tasks = new List<Task>();
        }
        deal.status = getStatusCodes(deal.tasks, defaultStatusCodes.clone());
      }

      if (merchant_orders.containsKey(merchant.id)) {
        POS_Order__c order = merchant_orders.get(merchant.id);
        merchant.setBreadcrumbStatus(order.POS_Sales_Status__c, order.HSA_GoLive__c);
      } else {
        POS_Order__c order = new POS_Order__c();
        merchant.setBreadcrumbStatus(order.POS_Sales_Status__c, order.HSA_GoLive__c);
      }

      merchant.setCLPStatus(index / size);
    }

    return orderMerchants(merchants);
  }

  public List<Merchant> getMerchantList() {
    showAll = true;

    Date feature_min_date = System.today().addDays(-365);
    Date expiration_min_date = System.today().addDays(-91);
    List<Merchant> merchants = new List<Merchant>();
    Set<Id> accountIds = new Set<Id>();
    Set<Id> merchantIds = new Set<Id>();
    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([SELECT AccountId FROM Opportunity WHERE (Account.Account_Manager__c = :AM_workbench.getUser() OR AccountCoordinator__c = :AM_workbench.getUser()) AND stageName = 'Closed Won' AND (recordType.name in :AM_workbench.typeStrings OR (recordType.name = 'Groupon Getaways' AND Travel_Quality__c = '4. No Getaways; Approved for G1') OR (recordType.name = 'GrouponLive' AND AccountCoordinator__c = :AM_workbench.getUser() )) AND ((feature_date__c > :feature_min_date OR feature_date__c = null) AND (Groupon_Expiration_Date__c > :expiration_min_date OR Groupon_Expiration_Date__c IN :AM_workbench.exceptionalExpirationDates OR Groupon_Expiration_Date__c = null))]);
    Set<Id> opportunityIds = opportunityMap.keySet();
    for (Opportunity o : opportunityMap.values()) {
      accountIds.add(o.AccountId);
    }

    Integer scriptStatementLimit = 190000;
    if (ApexPages.currentPage().getParameters().containsKey('limit')) {
      scriptStatementLimit = Integer.valueOf(ApexPages.currentPage().getParameters().get('limit'));
    }

    for (Account account : sortAccountByFeatureDate(Database.query(AM_workbench.getMerchantQuery()))) {
      if (Limits.getScriptStatements() < scriptStatementLimit) {
        if (account.Opportunities.size() > 0) {
          merchants.add(new Merchant(account));
          merchantIds.add(account.Id);
        }
      } else {
        showAll = false;
      }
    }

    opp_tasks = getTaskMap(opportunityIds);
    merchant_orders = getOrderMap(merchantIds);

    List<Obj> defaultStatusCodes = AM_workbench.getDefaultStatusCodes(UserInfo.getOrganizationId());

    for (Merchant merchant : merchants) {
      merchant.sortStrategy = 'clp';
    }
    merchants.sort();
    Decimal size = merchants.size();

    for (integer index = 0; index < size; index += 1) {
      Merchant merchant = merchants[index];
      for (g1 deal: merchant.g1deals) {
        if (opp_tasks.containsKey(deal.id)) {
          deal.tasks = opp_tasks.get(deal.id);
        } else {
          deal.tasks = new List<Task>();
        }
        deal.status = getStatusCodes(deal.tasks, defaultStatusCodes.clone());
      }

      if (merchant_orders.containsKey(merchant.id)) {
        POS_Order__c order = merchant_orders.get(merchant.id);
        merchant.setBreadcrumbStatus(order.POS_Sales_Status__c, order.HSA_GoLive__c);
      } else {
        POS_Order__c order = new POS_Order__c();
        merchant.setBreadcrumbStatus(order.POS_Sales_Status__c, order.HSA_GoLive__c);
      }

      merchant.setCLPStatus(index / size);
    }

    for (Merchant merchant : merchants) {
      merchant.sortStrategy = 'priority';
    }
    merchants.sort();
    List<Merchant> orderedMerchants = orderMerchants(merchants);
    numberOfScriptStatements = Limits.getScriptStatements();
    return orderedMerchants;
  }

  public void mapAccountWithFeatureDate(Account account, List<Date> featureDates, Map<Date, List<Account>> accountMap) {
      List<Account> values = new List<Account>();
      Date lastFeatureDate = System.today().addDays(-365);

      if (featureDates.size() > 0) {
        featureDates.sort();
        lastFeatureDate = featureDates[featureDates.size() - 1];
      }

      if (accountMap.containsKey(lastFeatureDate)) {
        values = accountMap.get(lastFeatureDate);
        values.add(account);
        accountMap.put(lastFeatureDate, values);
      } else {
        values.add(account);
        accountMap.put(lastFeatureDate, values);
      }
  }

  public List<Account> sortAccountByFeatureDate(List<Account> accounts) {
    Map<Date, List<Account>> accountMap = new Map<Date, List<Account>>();
    for (Account account : accounts) {
      List<Date> featureDates = new List<Date>();

      for (Opportunity opportunity : account.opportunities) {
        featureDates.add(opportunity.Go_Live_Date__c);
      }

      mapAccountWithFeatureDate(account, featureDates, accountMap);
    }

    List<Date> dates = new List<Date>(accountMap.keySet());
    dates.sort();

    List<Account> sortedAccounts = new List<Account>();
    for (Integer index = dates.size() - 1; index >= 0; index -= 1) {
      sortedAccounts.addAll(accountMap.get(dates[index]));
    }

    return sortedAccounts;
  }

  private List<Merchant> filterMerchants(List<Merchant> merchants, String style, String label, Date startDate, Date endDate) {
    List<Merchant> filteredMerchants = new List<Merchant>();
    for (Merchant m : merchants) {
      List<Date> featureDates = new List<Date>();
      boolean added = false;
      for (g1 deal : m.g1deals) {
        if (deal.featureDate != null) {
          Date featureDate = Date.parse(deal.featureDate);
          if (featureDate >= startDate && featureDate < endDate) {
            if (!added) {
              if (m.sectionStyle == null) {
                m.sectionStyle = style;
                m.endCap = label;
              }
              filteredMerchants.add(m);
              featureDates.add(featureDate);
              added = true;
            }
          }
        }
      }

      if (featureDates.size() > 0) {
        m.dateToSort = featureDates[0];
      }
    }

    for (Merchant merchant : merchants) {
      merchant.sortStrategy = 'today';
    }
    filteredMerchants.sort();
    return filteredMerchants;
  }

  private List<Merchant> reverse(List<Merchant> merchants) {
    List<Merchant> reversed = new List<Merchant>();
    for (integer index = merchants.size() - 1; index >= 0; index -= 1) {
      reversed.add(merchants[index]);
    }
    return reversed;
  }

  public List<Merchant> orderMerchants(List<Merchant> merchants) {
    integer priorityOrder = 0;
    for (Merchant m : merchants) {
      priorityOrder += 1;
      m.priorityOrder = priorityOrder;
    }

    List<Merchant> sortedMerchants = new List<Merchant>();
    List<Merchant> nextMerchants = filterMerchants(merchants, 'next', '+10', System.today(), System.today().addDays(10));

    integer counter = 0;
    for (Merchant m : reverse(nextMerchants)) {
      counter += 1;
      m.nextOrder = counter;
      sortedMerchants.add(m);
    }

    counter = nextMerchants.size();
    for (Merchant m : merchants) {
      if (m.nextOrder == null) {
        counter += 1;
        m.nextOrder = counter;
        sortedMerchants.add(m);
      }
    }

    List<Merchant> lastMerchants = filterMerchants(merchants, 'last', '-10', System.today().addDays(-9), System.today());

    counter = 0;
    for (Merchant m : lastMerchants) {
      counter += 1;
      m.lastOrder = counter;
    }

    counter = lastMerchants.size();
    for (Merchant m : merchants) {
      if (m.lastOrder == null) {
        counter += 1;
        m.lastOrder = counter;
      }
    }

    return sortedMerchants;
  }

  public Map<Id, List<Task>> getTaskMap(Set<Id> opportunityIds) {
    for (Task t: [SELECT Id, Subject, WhatId, Status, IsClosed FROM Task WHERE WhatId IN :opportunityIds AND Subject IN :AM_workbench.statusStrings]) {
      if (opp_tasks.containsKey(t.whatId)) {
        list<task> tk = opp_tasks.get(t.whatId);
        tk.add(t);
        opp_tasks.put(t.whatId, tk);
      } else {
        list<task> tk = new list<task>();
        tk.add(t);
        opp_tasks.put(t.whatId, tk);
      }
    }

    return opp_tasks;
  }

  public Map<Id, POS_Order__c> getOrderMap(Set<Id> accountIds) {
    for (POS_Order__c o: [SELECT Id, POS_Sales_Status__c, HSA_GoLive__c, Account__c FROM POS_Order__c WHERE Account__c IN :accountIds]) {
      if (!merchant_orders.containsKey(o.Account__c)) {
        merchant_orders.put(o.Account__c, o);
      }
    }

    return merchant_orders;
  }

  public class MerchantTemperature {
    public Date tempDate {get;set;}
    public Decimal overallRanking {get;set;}
    public String category {get;set;}
    public String overallComments {get;set;}
    public String source {get;set;}
    
    public MerchantTemperature() {}

    public MerchantTemperature(Merchant_Temperature__c data) {
      this.category = data.Category__c;
      this.overallComments = data.Overall_Experience_Comments__c;
      this.overallRanking = data.Overall_Experience_Ranking__c;
      this.tempDate = data.Merchant_Temperature_Date__c;
      this.source = this.DetermineSource(data.CreatedById, MERCHANT_ID);
    }

    public String DetermineSource(String createdById, String merchantUserId)
    {
      return (createdById == merchantUserId) ? 'Merchant' : 'AM';
    }
  }

  public class MerchantContact {
    public String id {get;set;}
    public String name {get;set;}
    public String phone {get;set;}
    public String email {get;set;}
    public String mobilePhone {get;set;}
    public String accountId {get;set;}
    public String dealId {get;set;}
  }

  public class MerchantReward {
    public String id {get;set;}
    public String name {get;set;}
    public String stageName {get;set;}
    public Date closeDate {get;set;}
    public String ownerName {get;set;}
    public String division {get;set;}
    public String accountCategory {get;set;}
    public String accountRewardsOfferStatus {get;set;}
    public String accountRewardsTransactionTrackingStatus {get;set;}
  }

  public class MerchantRefeature {
    public string id {get;set;}
    public string name {get;set;}
    public string refeatureNotes {get;set;}
    public string refeatureStatus {get;set;}
    public string notInterestedReason {get;set;}
  }

  public class MerchantPayment {
    public String id {get;set;}
    public String name {get;set;}
    public String paymentsEligible {get;set;}
    public String paymentProductSalesStatus {get;set;}
    public String paymentsActiveStatus {get;set;}
    public String paymentsInterested {get;set;}
    public String paymentsLeadSource {get;set;}
    public String paymentsProductNotes {get;set;}
    public String paymentsManagerName {get;set;}

    public MerchantPayment(Account a) {
      this.id = a.Id;
      this.name = a.Name;
      this.paymentsEligible = formatPaymentsEligible(a.Payments_Eligible__c);
      this.paymentProductSalesStatus = a.Payments_Product_Sales_Status__c;
      this.paymentsActiveStatus = a.Payments_Active_Status__c;
      this.paymentsInterested = formatPaymentsInterested(a.Payments_Interested__c);
      this.paymentsLeadSource = a.Payments_Lead_Source__c;
      this.paymentsProductNotes = a.Payments_Product_Notes__c;
      this.paymentsManagerName = findUserName(a.Payments_Manager__c);
    }

    private String formatPaymentsEligible(String paymentsEligible) {
      if (paymentsEligible == '' || paymentsEligible == NULL) {
        return 'Yes';
      } else {
        return paymentsEligible;
      }
    }

    private String formatPaymentsInterested(Boolean paymentInterested) {
      return paymentInterested ? 'Yes' : 'No';
    }
  }

  public class DealOption {
    public String id {get;set;}
    public String name {get;set;}
    public Decimal unitValue {get;set;}
    public Decimal unitSellPrice {get;set;}
    public Decimal discount {get;set;}
    public Decimal optionCap {get;set;}
    public Decimal grouponLiteMonthlyCap {get;set;}
  }

  public class Merchant implements Comparable {
    public Date dateToSort {get;set;}
    public String category {get;set;}
    public String endCap {get;set;}
    public String id {get;set;}
    public String interestedInNow {get;set;}
    public Date lastWeekActive {get;set;}
    public String last_modified {get;set;}
    public String msat_date {get;set;}
    public String name {get;set;}
    public String nowCSS {get;set;}
    public String nowMerchantActivity {get;set;}
    public String nowStage {get;set;}
    public String permalink {get;set;}
    public String sectionStyle {get;set;}
    public String star {get;set;}
    public Decimal totalNowRevenue {get;set;}
    public Decimal totalNowUnits {get;set;}
    public Decimal priority {get;set;}
    public String website {get;set;}
    public Boolean has_deals {get;set;}
    public Boolean out_of_business {get;set;}
    public Decimal msat {get;set;}
    public Id ownerid {get;set;}
    public Integer lastOrder {get;set;}
    public Integer nextOrder {get;set;}
    public Integer priorityOrder {get;set;}
    public Integer clp {get;set;}
    public List<MerchantTemperature> temperature {get;set;}
    public List<g1> g1deals {get;set;}
    public List<Now> now_deals {get;set;}
    public List<Task> tasks {get;set;}
    public Obj contact_reason {get;set;}
    public Obj breadcrumbStatus {get;set;}
    public Obj nowStatus {get;set;}
    public Obj paymentStatus {get;set;}
    public Obj rewardsStatus {get;set;}
    public Obj schedulerStatus {get;set;}
    public Obj clpStatus {get;set;}
    public String merchantStatus {get;set;}
    public String sortStrategy {get; set;}
    public String interest {get;set;}
    public String leadSource {get;set;}
    public String managerId {get;set;}
    public String leadSourceNotes {get;set;}
    public String salesValueReasons {get;set;}
    public Decimal salesValue {get;set;}

    public Merchant() {
    }

    public Merchant(account a) {
      this(a, 0);
    }

    public Merchant(account a, integer priorityOrder) {
      this.priority = a.AM_Priority__c;
      this.priorityOrder = priorityOrder;
      if (a.lastModifiedDate != NULL) {
        this.last_modified = a.lastModifiedDate.format();
      }

      this.temperature = new List<MerchantTemperature>();
      for (Merchant_Temperature__c temp : a.Merchant_Temperatures__r) {
        this.temperature.add(new MerchantTemperature(temp));
      }

      this.out_of_business = (a.Account_Status__c == 'Do Not Run - Bankruptcy / Out of Business' || a.Do_Not_Run_Again__c);

      if (a.Eligible_for_Scheduler__c == 'No') {
        this.schedulerStatus = new obj('S', 'badge-single');
      } else if (a.Eligible_for_Scheduler__c == 'Yes') {
        if (a.Groupon_Scheduler_Strength__c == 'Merchant Unresponsive') {
          this.schedulerStatus = new obj('S', 'badge-single badge-warning');
        } else if (AM_workbench.strengths.contains(a.Groupon_Scheduler_Strength__c) || AM_workbench.eligibilities.contains(a.Scheduler_Eligibility_Status__c)) {
          this.schedulerStatus = new obj('S', 'badge-single badge-inverse');
        } else if (String.isBlank(a.Groupon_Scheduler_Strength__c) && String.isBlank(a.Scheduler_Eligibility_Status__c)) {
          this.schedulerStatus = new obj('S', 'badge-single badge-danger');
        } else if (a.Scheduler_Eligibility_Status__c == 'Contacted' && AM_workbench.warningStrengths.contains(a.Groupon_Scheduler_Strength__c)) {
          this.schedulerStatus = new obj('S', 'badge-single badge-warning');
        } else if ((a.Scheduler_Eligibility_Status__c == 'Referred' || a.Scheduler_Eligibility_Status__c == 'Hot Transferred') &&
                   (a.Groupon_Scheduler_Strength__c == 'In Process' || String.isBlank(a.Groupon_Scheduler_Strength__c))) {
          this.schedulerStatus = new obj('S', 'badge-single badge-info');
        } else if (a.Groupon_Scheduler_Strength__c == 'Active') {
          this.schedulerStatus = new obj('S', 'badge-single badge-success');
        } else {
          this.schedulerStatus = new obj('S', 'badge-single');
        }
      } else {
        this.schedulerStatus = new obj('S', 'badge-single');
      }

      //now status
      if(a.Now_Status__c=='Not Contacted' || a.Now_Status__c ==null){
        this.nowStatus = new obj('N','badge-single badge-danger');
      }else if(a.Now_Status__c=='Contacted' || a.Now_Status__c=='In Negotiations' || a.now_status__c =='Needs Followup'){
        this.nowStatus = new obj('N','badge-single badge-warning');
      }else if(a.Now_Status__c=='Closed Won' && a.Now_Merchant_Activity__c == 'Live') {
        this.nowStatus = new obj('N','badge-single badge-success');
      }else if(a.Now_Status__c=='Closed Won'){
        this.nowStatus = new obj('N','badge-single badge-info');
      }else if(a.Now_Status__c=='Closed Expired' || a.Now_Status__c=='Self Service Exclusive' || a.Now_Status__c=='Closed Lost'){
        this.nowStatus = new obj('N','badge-single badge-inverse');
      }else{
        this.nowStatus = new obj('N','badge-single');
      }

      //rewards status
      if(a.Rewards_Offer_Status__c=='Not Contacted' || a.Rewards_Offer_Status__c ==null || a.Rewards_Offer_Status__c=='Paused'){
        this.rewardsStatus = new obj('R','badge-single badge-danger');
      }else if(a.Rewards_Offer_Status__c=='Contacted' || a.Rewards_Offer_Status__c=='In Negotiations' || a.Rewards_Offer_Status__c=='Contract Sent'){
        this.rewardsStatus = new obj('R','badge-single badge-caution');
      }else if(a.Rewards_Offer_Status__c=='Closed Lost' || a.Rewards_Offer_Status__c=='Closed Expired' || a.Rewards_Offer_Status__c=='Rejected'){
        this.rewardsStatus = new obj('R','badge-single badge-inverse');
      }else if(a.Rewards_Offer_Status__c=='Closed Won'){
        this.rewardsStatus = new obj('R','badge-single badge-info');
      }else if(a.Rewards_Offer_Status__c=='Live'){
        this.rewardsStatus = new obj('R','badge-single badge-success');
      }else{
        this.rewardsStatus = new obj('R','badge-single');
      }

      if (a.Payments_Active_Status__c == 'Activated') {
        this.paymentStatus = new obj('P', 'badge-single badge-success');
      } else if (a.Payments_Eligible__c == 'Yes' || String.isBlank(a.Payments_Eligible__c)) {
        if ((String.isNotBlank(a.Payments_Product_Sales_Status__c) && a.Payments_Product_Sales_Status__c.contains('Not Interested')) ||
             a.Payments_Lead_Source__c == 'AM Contacted - Not Interested') {
          this.paymentStatus = new obj('P', 'badge-single badge-inverse');
        } else if (a.Payments_Lead_Source__c == 'Referral - AM' ||
                   a.Payments_Lead_Source__c == 'AM Contacted - Interested' ||
                   String.isNotBlank(a.Payments_Manager__c)) {
          this.paymentStatus = new obj('P', 'badge-single badge-info');
        } else if (String.isBlank(a.Payments_Product_Sales_Status__c) &&
                   a.Payments_Lead_Source__c == 'AM Contacted - In Progress') {
          this.paymentStatus = new obj('P', 'badge-single badge-warning');
        } else if (String.isBlank(a.Payments_Product_Sales_Status__c) &&
                   String.isBlank(a.Payments_Lead_Source__c)) {
          this.paymentStatus = new obj('P', 'badge-single badge-danger');
        } else {
          this.paymentStatus = new obj('P', 'badge-single');
        }
      } else {
        this.paymentStatus = new obj('P', 'badge-single');
      }

      this.breadcrumbStatus = new obj('B', 'badge-single');

      if (this.out_of_business) {
        this.rewardsStatus = new obj('R','badge-single');
        this.nowStatus = new obj('N','badge-single');
        this.schedulerStatus = new obj('S','badge-single');
      }

      if (a.AM_Priority__c < 0) {
        this.contact_reason =  new Obj(a.AM_Priority_Reason__c, 'label-info');
      } else if (a.AM_Priority__c < 8) {
        this.contact_reason =  new Obj(a.AM_Priority_Reason__c, 'label-danger');
      } else if (a.AM_Priority__c < 14) {
        this.contact_reason =  new Obj(a.AM_Priority_Reason__c, 'label-warning');
      } else if (a.AM_Priority__c < 21) {
        this.contact_reason =  new Obj(a.AM_Priority_Reason__c, 'label-caution');
      } else if (a.AM_Priority__c < 30) {
        this.contact_reason =  new Obj(a.AM_Priority_Reason__c, 'label-success');
      } else {
        this.contact_reason =  new Obj(a.AM_Priority_Reason__c, 'label-info');
      }

      this.website = a.website;
      this.permalink = a.Merchant_Permalink__c;
      addG1Deals(a.Opportunities);
      this.has_deals = (this.g1deals.size() > 1);

      if (a.Merchant_Surveys__r.size() > 0) {
        this.msat = a.Merchant_Surveys__r.get(0).Overall_Satisfaction__c;
        this.msat_date = a.Merchant_Surveys__r.get(0).Merchant_Survey_Date__c.format();
      }

      if (a.Groupon_Now__r.size() > 0) {
        this.nowStage = '';
      } else {
        this.nowStage = 'Not Contacted';
      }
      this.category = a.category_v3__c;
      this.name = a.name;
      this.id = a.id;

      if (a.Quantum_Leads__r.size() > 0) {
        this.salesValueReasons = a.Quantum_Leads__r[0].Sales_Value_Reasons__c;
        this.salesValue = a.Quantum_Leads__r[0].Sales_Value__c;
        if (a.Quantum_Leads__r[0].Call_List_Priority__c == null) {
          this.clp = 0;
        } else {
          this.clp = Integer.valueOf(a.Quantum_Leads__r[0].Call_List_Priority__c);
        }
      }

      if ( !getIsInternational() ) {
        if (a.Total_GP__c > 0 && a.Most_Recent_Feature__c != null) {
          if (a.Merchant_Partner_Progress__c == 'Merchant Partner' || a.Merchant_Partner_Progress__c == 'Renewed Merchant Partner') {
            this.star = 'gold';
          } else {
            this.star = 'black';
          }
        } else {
          this.star = 'none';
        }
      }

      this.interest = a.POS_Interest__c;
      this.leadSource = a.POS_Lead_Source__c;
      this.managerId = a.POS_Manager__c;
      this.leadSourceNotes = a.POS_Lead_Source_Other__c;
      
      if (!getIsInternational()) {
        if (a.White_Glove_Merch__c == 'White Glove') {
          this.merchantStatus = 'white';
        } else if (a.White_Glove_Merch__c == 'Super White Glove') {
          this.merchantStatus = 'super white';
        } else {
          this.merchantStatus = 'none';
        }
      } else {
        if (a.Status__c == 'Open Case/Escalation' || a.Status__c == 'On Probation') {
          this.merchantStatus = 'alert';
        } else if (a.Status__c == 'Burned Account') {
          this.merchantStatus = 'skull';
        } else {
          this.merchantStatus = 'none';
        }
      }
    }

    public void addG1Deals(List<Opportunity> opportunities) {
      this.g1deals = new List<g1>();
      for (Opportunity o : opportunities) {
        this.g1deals.add(new g1(o, false));
      }

      this.g1deals.sort();

      if (this.g1deals.size() > 0)  {
        this.g1deals[0].setDisplay(true);
      }
    }

    public void setCLPStatus(Decimal clpRanking) {
      if (this.salesValue == null || this.salesValue == 0.0) {
        this.clpStatus = new Obj('Q', 'badge-single');
      } else if (clpRanking <= 0.5) {
        this.clpStatus = new Obj('Q', 'badge-single badge-success');
      } else {
        this.clpStatus = new Obj('Q', 'badge-single badge-caution');
      }
    }

    public void setBreadcrumbStatus(String bcSalesStatus, DateTime bcGoLiveDate) {
      if (this.category != 'Food & Drink') {
        this.breadcrumbStatus = new obj('B', 'badge-single');
      }
      else {
        if (bcSalesStatus == 'Closed Won' && bcGoLiveDate != null && DateTime.parse(bcGoLiveDate.format()) <= System.today()) {
          this.breadcrumbStatus = new obj('B', 'badge-single badge-success');
        } else if (bcSalesStatus == 'Closed Won') {
          this.breadcrumbStatus = new obj('B', 'badge-single badge-info');
        } else if ((bcSalesStatus == 'Closed Lost' || bcSalesStatus == 'Not Currently Interested') &&
                  this.leadSource == 'AM Contacted - Not Interested') {
          this.breadcrumbStatus = new obj('B', 'badge-single badge-inverse');
        } else if (bcSalesStatus == 'Prospecting' || bcSalesStatus == 'Interested' ||
                 bcSalesStatus == 'Very Interested' || bcSalesStatus == 'Contract Sent') {
          this.breadcrumbStatus = new obj('B', 'badge-single badge-warning');
        } else if (this.managerId == null && this.interest == null) {
          this.breadcrumbStatus = new obj('B', 'badge-single badge-danger');
        } else  {
          this.breadcrumbStatus = new obj('B', 'badge-single badge-danger');
        }
      }
    }

    public Integer compareTo(Object compareToObject) {
      Merchant compareTo = (Merchant) compareToObject;

      if (this.sortStrategy == 'priority') {
        if (this.priority != null && compareTo.priority != null) {
          return Integer.valueOf(this.priority - compareTo.priority);
        } else {
          if (this.priority == null && compareTo.priority == null) {
            return 0;
          } else if (this.priority == null) {
            return 1;
          } else {
            return -1;
          }
        }
      } else if (this.sortStrategy == 'clp') {
        if (this.clp != null && compareTo.clp != null) {
          return this.clp - compareTo.clp;
        } else {
          if (this.clp == null && compareTo.clp == null) {
            return 0;
          } else if (this.clp == null) {
            return 1;
          } else {
            return -1;
          }
        }
      } else {
        if (this.dateToSort != null && compareTo.dateToSort != null) {
          if (this.dateToSort > compareTo.dateToSort) {
            return -1;
          } else if (this.dateToSort < compareTo.dateToSort){
            return 1;
          } else {
            return this.priorityOrder - compareTo.priorityOrder;
          }
        } else {
          return 1;
        }
      }
    }
  }

  public class now {
    public String name {get;set;}
    public String launch_date {get;set;}
    public String id {get;set;}
    public String stage {get;set;}
    public String accountNameName {get;set;}
    public String accountName {get;set;}
    public String dealOwnername {get;set;}
    public String category {get;set;}
    public String dealName {get;set;}
    public Date closeDate {get;set;}
    public String accountNameNowMerchantActivity {get;set;}

    public now(GrouponNow__c gnow){
      this.id = gnow.id;
      this.stage = gnow.stage__c;
    }
  }

  public class Scheduler{
    public string eligibility {get;set;}
    public string name {get;set;}
    public string strength {get;set;}
    public string specialist {get;set;}
    public string book_now {get;set;}
    public list<Scheduler_deal> deals {get;set;}

    public Scheduler(account a){
      this.name=a.name;
      this.eligibility = a.Scheduler_Eligibility_Status__c;
      this.strength = a.Groupon_Scheduler_Strength__c;
      if(a.Scheduler_Specialist__c !=null){
        this.specialist = a.Scheduler_Specialist__r.name;
      }
      if(a.opportunities!=null){
        this.deals = new list<Scheduler_deal>();

        for(opportunity o: a.opportunities){
          this.deals.add(new Scheduler_deal(o));
        }
      }
    }
  }

  public class QuantumLead {
    public String salesValueReasons {get;set;}
    public Decimal salesValue {get;set;}
    public Decimal callListPriority {get;set;}

    public QuantumLead(Quantum_Lead__c lead) {
      this.salesValueReasons = lead.Sales_Value_Reasons__c;
      this.salesValue = lead.Sales_Value__c;
      if (lead.Call_List_Priority__c == null) {
        this.callListPriority = 0;
      } else {
        this.callListPriority = Integer.valueOf(lead.Call_List_Priority__c);
      }
    }
  }

  public class Breadcrumb{
    public string name {get;set;}
    public string interest {get;set;}
    public string leadSource {get;set;}
    public string category {get;set;}
    public string manager {get;set;}
    public string leadSourceNotes {get;set;}
    public string salesStatus {get;set;}
    public string goLiveDate {get;set;}

    public Breadcrumb(Account a, List<POS_Order__c> blist){
      this.name = a.Name;
      this.interest = a.POS_Interest__c;
      this.leadSource = a.POS_Lead_Source__c;
      this.category = a.Category_v3__c;
      this.manager = findUserName(a.POS_Manager__c);
      this.leadSourceNotes = a.POS_Lead_Source_Other__c;
      if (blist.size() > 0) {
        POS_Order__c b = blist[0];
        this.salesStatus = b.POS_Sales_Status__c;
        if (b.HSA_GoLive__c == null) {
          this.goLiveDate = '';
        } else {
          this.goLiveDate = b.HSA_GoLive__c.format();
        }
      }
    }
  }

  public class Scheduler_deal {
    public string name {get;set;}
    public string id {get;set;}
    public boolean using_scheduler {get;set;}
    public Scheduler_deal(opportunity o){
      this.name = o.name;
      this.id = o.id;
      this.using_scheduler = (o.Groupon_Scheduler_Strength__c  =='Active');
    }
  }

  public class g1 implements Comparable {
    public string name {get;set;}
    public string id {get;set;}
    public string opportunityId {get;set;}
    public boolean display {get;set;}
    public string featureDate {get;set;}
    public string expirationDate {get;set;}
    public boolean prefeature {get;set;}
    public string permalink {get;set;}
    public boolean staggeredExp {get;set;}
    public list<task> tasks {get;set;}
    public string displayCSS {get;set;}
    public string dealstrengthCSS {get;set;}
    public obj dealStrength {get;set;}
    public list<obj> status {get;set;}
    public boolean using_scheduler {get;set;}
    public string sales_rep {get;set;}
    public string deal_bank {get;set;}
    public string division {get;set;}
    public string writeup_status {get;set;}

    public g1(opportunity o, boolean disp) {
      this.name = dealNamePrefix(o.recordType.Name) + o.name;
      this.status = new list<obj>();
      this.id = o.id;
      this.opportunityId = o.Opportunity_ID__c;
      this.writeup_status = o.Writeup_Status_del__c;
      this.division = o.division__c;
      this.sales_rep = o.owner.name;
      this.deal_bank = o.Deal_Bank_Eligible__c;
      this.using_scheduler = (o.Online_Scheduling_Status__c == 'Active');
      this.permalink = o.permalink__c;
      this.staggeredExp = o.Enable_Staggered_Expiration__c;

      if (o.Groupon_Expiration_Date__c != null) {
        this.expirationDate = o.Groupon_Expiration_Date__c.format();
      }

      if (o.Go_Live_Date__c != null) {
        this.featureDate = o.Go_Live_Date__c.format();
      }

      setDisplay(disp);

      if (o.Feature_Date__c != null && o.Go_Live_Date__c != null) {
        this.prefeature = (o.Feature_Date__c.format() == o.Go_Live_Date__c.format());   
      } else {
        this.prefeature = false;
      }
      this.dealStrength = newDealStrength(o);
    }

    public void setDisplay(boolean disp) {
      this.display = disp;
      if (disp) {
        this.displayCSS = '';
      } else {
        this.displayCSS = 'display:none;';
      }
    }

    private Date getFeatureDate(String featureDate) {
      if (featureDate == null) {
        return System.today().addDays(365 * 10);
      } else {
        return Date.parse(featureDate);
      }
    }

    public Integer compareTo(Object compareToObject) {
      g1 compareTo = (g1) compareToObject;
      Date thisFeatureDate = getFeatureDate(this.featureDate);
      Date otherFeatureDate = getFeatureDate(compareTo.featureDate);

      if (thisFeatureDate < System.today() && otherFeatureDate < System.today()) {
        return thisFeatureDate.daysBetween(otherFeatureDate);
      } else if (thisFeatureDate < System.today() && otherFeatureDate >= System.today()) {
        return 1;
      } else if (thisFeatureDate >= System.today() && otherFeatureDate < System.today()) {
        return -1;
      } else if (thisFeatureDate >= System.today() && otherFeatureDate >= System.today()) {
        return otherFeatureDate.daysBetween(thisFeatureDate);
      } else {
        return 0;
      }
    }

    private String dealNamePrefix(String recordTypeName) {
      if (recordTypeName == 'G1') {
        return 'G1 - ';
      } else if (recordTypeName == 'gLite') {
        return 'GLITE - ';
      } else if (recordTypeName == 'GrouponLive') {
        return 'LIVE - ';
      } else if (recordTypeName == 'Groupon Getaways') {
        return 'GETAWAYS - ';
      } else if (recordTypeName == 'Groupon Goods') {
        return 'GOODS - ';
      } else if (String.isNotEmpty(recordTypeName)) {
        return recordTypeName.toUpperCase() + ' - ';
      } else {
        return '';
      }
    }

    private obj newDealStrength(Opportunity o) {
      obj dealStrength = new obj();
      double daysBetween = 0;
      boolean dealBank = false;

      if (o.feature_date__c <= System.today() &&
          o.feature_end_date__c != null &&
          o.of_Days_Extension_for_Deal_Bank__c != null &&
          o.Deal_Bank_Eligible__c == 'Opt-In' &&
          o.feature_end_date__c.daysBetween(System.today()) < o.Of_Days_Extension_for_Deal_Bank__c) {
          dealBank = true;
      }

      if (o.Deal_Strengh__c == 'A Sure Thing' && o.Go_Live_Date__c > System.today()) {
        dealStrength.css = 'label-inverse';
        dealStrength.value ='ST';
      } else if (o.Deal_Strengh__c == 'A Sure Thing' && o.Go_Live_Date__c <= System.today() && o.Feature_End_Date__c >= System.today()) {
        dealStrength.css = 'label-success';
        dealStrength.value = 'LIVE';
      } else if (dealBank) {
        dealStrength.css = 'label-success';
        dealStrength.value = 'DB';
      } else if (o.Feature_End_Date__c < System.today() && System.today() < o.Groupon_Expiration_Date__c) {
        dealStrength.css = 'label-inverse';
        dealStrength.value='OPEN';
      } else if (o.deal_strengh__c == 'Renegotiate') {
        dealStrength.css = 'label-inverse';
        dealStrength.value ='NEG';
      } else if (o.deal_strengh__c == 'HOLD') {
        dealStrength.css = 'label-inverse';
        dealStrength.value ='HOLD';
      } else if(o.deal_strengh__c == 'Rejected') {
        dealStrength.css = 'label-inverse';
        dealStrength.value = 'REJ';
      } else if(o.deal_strengh__c == 'Vetted') {
        dealStrength.css = 'label-inverse';
        dealStrength.value ='VET';
      } else if (o.deal_strengh__c == 'Recommended') {
        dealStrength.css = 'label-inverse';
        dealStrength.value = 'REC';
      } else if (o.deal_strengh__c == 'Rep Getting Info') {
        dealStrength.css = 'label-inverse';
        dealStrength.value= 'RGI';
      } else if (o.deal_strengh__c == 'A Sure Thing' && System.today() > o.Groupon_Expiration_Date__c) {
        dealStrength.css = 'label';
        dealStrength.value = 'EXP';
      } else if (o.deal_strengh__c == 'CP Needs Info') {
        dealStrength.css = 'label-inverse';
        dealStrength.value = 'CPNI';
      } else if (o.deal_strengh__c == 'A Sure Thing') {
        dealStrength.css = 'label-inverse';
        dealStrength.value = 'ST';
      } else {
        dealStrength.value = o.deal_strengh__c;
      }

      return dealStrength;
    }
  }

  public class obj {
    public string value {get;set;}
    public string css {get;set;}
    public string subject {get;set;}

    public obj(string value) {
      this.value = value;
      this.css = '';
      this.subject = '';
    }

    public obj(string value, string subject, string css) {
      this.value = value;
      this.css = css;
      this.subject = subject;
    }

    public obj(string value, string css) {
      this.value = value;
      this.css = css;
      this.subject = '';
    }

    public obj(){}
  }

  private static String getOpportunityQuery() {
    return 'SELECT AccountId FROM Opportunity WHERE (Account.Account_Manager__c = \'' + AM_workbench.getUser() + '\' OR AccountCoordinator__c = \'' + AM_workbench.getUser() + '\') AND stageName = \'Closed Won\' AND (recordType.name IN :typeStrings OR (recordType.name = \'Groupon Getaways\' AND Travel_Quality__c = \'4. No Getaways; Approved for G1\') OR (recordType.name = \'GrouponLive\' AND AccountCoordinator__c = \'' + AM_workbench.getUser() + '\')) AND ((Groupon_Expiration_Date__c > :expiration_min_date OR Groupon_Expiration_Date__c IN :exceptionalExpirationDates OR Groupon_Expiration_Date__c = null))';
  }

  private static String getContactQuery(String searchString) {
    return 'SELECT AccountId FROM Contact WHERE Account.Account_Manager__c = \'' + AM_workbench.getUser() + '\' AND (Phone LIKE \'%' + searchString + '%\' OR Name LIKE \'%' + searchString + '%\')';
  }

  private static String getMerchantQuery() {
    String query = 'SELECT Id, Name, Category_v3__c, Groupon_Scheduler_Strength__c, Status__c, Scheduler_Eligibility_Status__c, Eligible_for_Scheduler__c, Re_Feature_Status_MM__c, Not_Interested_in_Refeature_Reasons_MM__c, lastModifiedDate, AM_Priority__c, AM_Priority_Reason__c, website, Merchant_Permalink__c, Now_Status__c, Rewards_Offer_Status__c, Merchant_Partner_Progress__c, ownerid, Reward_Transaction_Tracking_Status__c, Now_Merchant_Activity__c, Do_Not_Run_Again__c,Most_Recent_Feature__c, Rewards_Hand_off__c, Total_GP__c, Most_Recent_Last_Close_Date__c, Account_Status__c, Payments_Eligible__c, Payments_Product_Sales_Status__c, Payments_Active_Status__c, Payments_Interested__c, Payments_Lead_Source__c, Payments_Product_Notes__c, Payments_Manager__c, White_Glove_Merch__c, POS_Interest__c, POS_Lead_Source__c, POS_Manager__c, POS_Lead_Source_Other__c,';
    query += '(SELECT Id, Overall_Satisfaction__c, Merchant_Survey_Date__c FROM Merchant_Surveys__r WHERE Merchant_Survey_Date__c  != null ORDER BY Merchant_Survey_Date__c DESC LIMIT 1),';
    query += '(SELECT Id, Subject, IsClosed FROM Tasks),';
    query += '(SELECT Stage__c FROM Groupon_Now__r),';
    query += '(SELECT Id, Merchant_Temperature_Date__c, Overall_Experience_Ranking__c, Overall_Experience__c, Overall_Experience_Comments__c, Category__c, CreatedById from Merchant_Temperatures__r ORDER BY Merchant_Temperature_Date__c desc),';
    query += '(SELECT Id, Name, Go_Live_Date__c, Writeup_Status_del__c, Groupon_Expiration_Date__c, feature_date__c, Feature_End_Date__c, Deal_Strengh__c, Enable_Staggered_Expiration__c, of_Days_Extension_for_Deal_Bank__c, Deal_Bank_Eligible__c, Type, permalink__c, Online_Scheduling_Status__c, division__c, Opportunity_ID__c, Owner.Name, RecordType.Name from Opportunities WHERE Id in :opportunityIds ORDER BY feature_date__c desc),';
    query += '(SELECT Sales_Value_Reasons__c, Sales_Value__c, Call_List_Priority__c FROM Quantum_Leads__r)';
    query += 'FROM Account ';
    query += 'WHERE Account_Manager__c = \'' + AM_workbench.getUser() + '\' OR Id in :accountIds ';
    query += 'ORDER BY AM_Priority__c NULLS LAST LIMIT 1000';
    return query;
  }

  private static String getMerchantSearchQuery(String searchString) {
    String query = 'SELECT Id, Name, Category_v3__c, Groupon_Scheduler_Strength__c, Status__c, Scheduler_Eligibility_Status__c, Eligible_for_Scheduler__c, Re_Feature_Status_MM__c, Not_Interested_in_Refeature_Reasons_MM__c, lastModifiedDate, AM_Priority__c, AM_Priority_Reason__c, website, Merchant_Permalink__c, Now_Status__c, Rewards_Offer_Status__c, Merchant_Partner_Progress__c, ownerid, Reward_Transaction_Tracking_Status__c, Now_Merchant_Activity__c, Do_Not_Run_Again__c,Most_Recent_Feature__c, Rewards_Hand_off__c, Total_GP__c, Most_Recent_Last_Close_Date__c, Account_Status__c, Payments_Eligible__c, Payments_Product_Sales_Status__c, Payments_Active_Status__c, Payments_Interested__c, Payments_Lead_Source__c, Payments_Product_Notes__c, Payments_Manager__c, White_Glove_Merch__c, POS_Interest__c, POS_Lead_Source__c, POS_Manager__c, POS_Lead_Source_Other__c,';
    query += '(SELECT Id, Overall_Satisfaction__c, Merchant_Survey_Date__c FROM Merchant_Surveys__r WHERE Merchant_Survey_Date__c  != null ORDER BY Merchant_Survey_Date__c DESC LIMIT 1),';
    query += '(SELECT Id, Subject, IsClosed FROM Tasks),';
    query += '(SELECT Stage__c FROM Groupon_Now__r),';
    query += '(SELECT Id, Merchant_Temperature_Date__c, Overall_Experience_Ranking__c, Overall_Experience__c, Overall_Experience_Comments__c, Category__c, CreatedById from Merchant_Temperatures__r ORDER BY Merchant_Temperature_Date__c desc),';
    query += '(SELECT Id, Name, Go_Live_Date__c, Writeup_Status_del__c, Groupon_Expiration_Date__c, feature_date__c, Feature_End_Date__c, Deal_Strengh__c, Enable_Staggered_Expiration__c, of_Days_Extension_for_Deal_Bank__c, Deal_Bank_Eligible__c, Type, permalink__c, Online_Scheduling_Status__c, division__c, Opportunity_ID__c, Owner.Name, RecordType.Name from Opportunities WHERE Id in :opportunityIds ORDER BY feature_date__c desc),';
    query += '(SELECT Sales_Value_Reasons__c, Sales_Value__c, Call_List_Priority__c FROM Quantum_Leads__r)';
    query += 'FROM Account ';
    query += 'WHERE Id in :accountIds OR (Account_Manager__c = \'' + AM_workbench.getUser() + '\' AND Name LIKE \'%' + searchString + '%\') ';
    query += 'ORDER BY AM_Priority__c NULLS LAST LIMIT 1000';
    return query;
  }
}