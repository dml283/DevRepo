@isTest
public class AM_workbenchPresentationTest {
  static testMethod void merchantPaymentEligibleWithYes() {
    Account a = new Account();
    a.Payments_Eligible__c = 'Yes';
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('Yes', mp.paymentsEligible);
  }

  static testMethod void merchantPaymentEligibleWithNo() {
    Account a = new Account();
    a.Payments_Eligible__c = 'No';
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('No', mp.paymentsEligible);
  }

  static testMethod void merchantPaymentEligibleWithBlank() {
    Account a = new Account();
    a.Payments_Eligible__c = '';
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('Yes', mp.paymentsEligible);
  }

  static testMethod void merchantPaymentEligibleWithNull() {
    Account a = new Account();
    a.Payments_Eligible__c = NULL;
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('Yes', mp.paymentsEligible);
  }

  static testMethod void merchantPaymentInterestedWithTrue() {
    Account a = new Account();
    a.Payments_Interested__c = true;
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('Yes', mp.paymentsInterested);
  }

  static testMethod void merchantPaymentInterestedWithFalse() {
    Account a = new Account();
    a.Payments_Interested__c = false;
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('No', mp.paymentsInterested);
  }

  static testMethod void merchantPaymentsLeadSource() {
    Account a = new Account();
    a.Payments_Lead_Source__c = 'AM Contacted - Not Interested';
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('AM Contacted - Not Interested', mp.paymentsLeadSource);
  }

  static testMethod void merchantPaymentsProductNotes() {
    Account a = new Account();
    a.Payments_Product_Notes__c = 'Some Notes';
    AM_workbench.MerchantPayment mp = new AM_workbench.MerchantPayment(a);
    System.assertEquals('Some Notes', mp.paymentsProductNotes);
  }

  static testMethod void g1PrefeatureShowAsterisk() {
    Opportunity o = new Opportunity();
    o.Name = 'Test Opportunity';
    o.StageName = 'Stage Name';
    o.CloseDate = System.today();
    o.Feature_Date__c = System.today();
    o.Sure_Thing_Date__c = System.today().addDays(-1);
    Database.insert(o);

    o = [SELECT Id, Name, Go_Live_Date__c, Writeup_Status_del__c, Groupon_Expiration_Date__c, Feature_Date__c, Feature_End_Date__c, Deal_Strengh__c, Enable_Staggered_Expiration__c, Of_Days_Extension_for_Deal_Bank__c, Deal_Bank_Eligible__c, Type, Permalink__c, Online_Scheduling_Status__c, Division__c, Opportunity_ID__c, Owner.Name, RecordType.Name FROM Opportunity WHERE Id = :o.Id];

    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals(true, deal.prefeature);
  }

  static testMethod void g1PrefeatureNotShowAsterisk() {
    Opportunity o = new Opportunity();
    o.Name = 'Test Opportunity';
    o.StageName = 'Stage Name';
    o.CloseDate = System.today();
    o.Feature_Date__c = System.today();
    o.Sure_Thing_Date__c = System.today();
    Database.insert(o);

    o = [SELECT Id, Name, Go_Live_Date__c, Writeup_Status_del__c, Groupon_Expiration_Date__c, Feature_Date__c, Feature_End_Date__c, Deal_Strengh__c, Enable_Staggered_Expiration__c, Of_Days_Extension_for_Deal_Bank__c, Deal_Bank_Eligible__c, Type, Permalink__c, Online_Scheduling_Status__c, Division__c, Opportunity_ID__c, Owner.Name, RecordType.Name FROM Opportunity WHERE Id = :o.Id];

    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals(false, deal.prefeature);
  }

  static testMethod void g1DealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = 'G1';
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('G1 - Test Opportunity', deal.name);
  }

  static testMethod void gLiteDealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = 'gLite';
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('GLITE - Test Opportunity', deal.name);
  }

  static testMethod void grouponLiveDealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = 'GrouponLive';
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('LIVE - Test Opportunity', deal.name);
  }

  static testMethod void grouponGetawaysDealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = 'Groupon Getaways';
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('GETAWAYS - Test Opportunity', deal.name);
  }

  static testMethod void grouponGoodsDealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = 'Groupon Goods';
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('GOODS - Test Opportunity', deal.name);
  }

  static testMethod void newDealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = 'National';
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('NATIONAL - Test Opportunity', deal.name);
  }

  static testMethod void missingDealName() {
    Opportunity o = new Opportunity();
    RecordType r = new RecordType();
    r.Name = NULL;
    o.RecordType = r;
    o.Name = 'Test Opportunity';
    AM_workbench.g1 deal = new AM_workbench.g1(o, true);
    System.assertEquals('Test Opportunity', deal.name);
  }

  static testMethod void hasPaymentStatus() {
    Account a = new Account();
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
  }

  static testMethod void greenPaymentStatus() {
    Account a = new Account();
    a.Payments_Active_Status__c = 'Activated';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-success', m.paymentStatus.css);
  }

  static testMethod void lightGrayPaymentStatus() {
    Account a = new Account();
    a.Payments_Eligible__c = 'No';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single', m.paymentStatus.css);
  }

  static testMethod void darkGrayPaymentStatus() {
    Account a = new Account();
    a.Payments_Eligible__c = 'Yes';
    a.Payments_Product_Sales_Status__c = 'Not Interested';
    a.Payments_Lead_Source__c = '';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-inverse', m.paymentStatus.css);

    a.Payments_Eligible__c = '';
    a.Payments_Product_Sales_Status__c = 'Not Interested';
    a.Payments_Lead_Source__c = '';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-inverse', m.paymentStatus.css);

    a.Payments_Eligible__c = '';
    a.Payments_Product_Sales_Status__c = 'Merchant Not Interested';
    a.Payments_Lead_Source__c = '';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-inverse', m.paymentStatus.css);

    a.Payments_Eligible__c = '';
    a.Payments_Product_Sales_Status__c = '';
    a.Payments_Lead_Source__c = 'AM Contacted - Not Interested';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-inverse', m.paymentStatus.css);
  }

  static testMethod void bluePaymentStatus() {
    Account a = new Account();
    a.Payments_Eligible__c = 'Yes';
    a.Payments_Lead_Source__c = 'Referral - AM';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-info', m.paymentStatus.css);

    a.Payments_Eligible__c = 'Yes';
    a.Payments_Lead_Source__c = 'AM Contacted - Interested';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-info', m.paymentStatus.css);

    a.Payments_Eligible__c = '';
    a.Payments_Lead_Source__c = '';
    a.Payments_Manager__c = '005c0000000Mufy';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-info', m.paymentStatus.css);
  }

  static testMethod void orangePaymentStatus() {
    Account a = new Account();
    a.Payments_Eligible__c = 'Yes';
    a.Payments_Product_Sales_Status__c = '';
    a.Payments_Lead_Source__c = 'AM Contacted - In Progress';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-warning', m.paymentStatus.css);

    a.Payments_Eligible__c = '';
    a.Payments_Product_Sales_Status__c = '';
    a.Payments_Lead_Source__c = 'AM Contacted - In Progress';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-warning', m.paymentStatus.css);
  }

  static testMethod void redPaymentStatus() {
    Account a = new Account();
    a.Payments_Eligible__c = 'Yes';
    a.Payments_Product_Sales_Status__c = '';
    a.Payments_Lead_Source__c = '';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-danger', m.paymentStatus.css);

    a.Payments_Eligible__c = '';
    a.Payments_Product_Sales_Status__c = '';
    a.Payments_Lead_Source__c = '';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('P', m.paymentStatus.value);
    System.assertEquals('badge-single badge-danger', m.paymentStatus.css);
  }

  static testMethod void statusCodesINNotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Intro Call';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('IN', objs[0].value);
    System.assertEquals('Prep: Intro Call', objs[0].subject);
    System.assertEquals('', objs[0].css);
  }

  static testMethod void statusCodesINInProgressTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Intro Call';
    task.Status = 'In Progress';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('IN', objs[0].value);
    System.assertEquals('Prep: Intro Call', objs[0].subject);
    System.assertEquals('bg-caution', objs[0].css);
  }

  static testMethod void statusCodesINCompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Intro Call';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('IN', objs[0].value);
    System.assertEquals('Prep: Intro Call', objs[0].subject);
    System.assertEquals('bg-inverse', objs[0].css);
  }

  static testMethod void statusCodesINDeferredTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Intro Call';
    task.Status = 'Deferred';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('IN', objs[0].value);
    System.assertEquals('Prep: Intro Call', objs[0].subject);
    System.assertEquals('bg-inverse', objs[0].css);
  }

  static testMethod void statusCodesGRNotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Getting Ready';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('GR', objs[1].value);
    System.assertEquals('Prep: Getting Ready', objs[1].subject);
    System.assertEquals('', objs[1].css);
  }

  static testMethod void statusCodesGRCompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Getting Ready';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('GR', objs[1].value);
    System.assertEquals('Prep: Getting Ready', objs[1].subject);
    System.assertEquals('bg-inverse', objs[1].css);
  }

  static testMethod void statusCodesFDNotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Feature Date Confirmed';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('FD', objs[2].value);
    System.assertEquals('Prep: Feature Date Confirmed', objs[2].subject);
    System.assertEquals('', objs[2].css);
  }

  static testMethod void statusCodesFDInProgressTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Feature Date Confirmed';
    task.Status = 'In Progress';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('FD', objs[2].value);
    System.assertEquals('Prep: Feature Date Confirmed', objs[2].subject);
    System.assertEquals('bg-caution', objs[2].css);
  }

  static testMethod void statusCodesFDCompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Feature Date Confirmed';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('FD', objs[2].value);
    System.assertEquals('Prep: Feature Date Confirmed', objs[2].subject);
    System.assertEquals('bg-inverse', objs[2].css);
  }

  static testMethod void statusCodesFDDeferredTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Feature Date Confirmed';
    task.Status = 'Deferred';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('FD', objs[2].value);
    System.assertEquals('Prep: Feature Date Confirmed', objs[2].subject);
    System.assertEquals('bg-danger', objs[2].css);
  }

  static testMethod void statusCodesMCNotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: MC Walkthrough';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('MC', objs[3].value);
    System.assertEquals('Prep: MC Walkthrough', objs[3].subject);
    System.assertEquals('', objs[3].css);
  }

  static testMethod void statusCodesMCInProgressTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: MC Walkthrough';
    task.Status = 'In Progress';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('MC', objs[3].value);
    System.assertEquals('Prep: MC Walkthrough', objs[3].subject);
    System.assertEquals('bg-caution', objs[3].css);
  }

  static testMethod void statusCodesMCDeferredTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: MC Walkthrough';
    task.Status = 'Deferred';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('MC', objs[3].value);
    System.assertEquals('Prep: MC Walkthrough', objs[3].subject);
    System.assertEquals('bg-inverse', objs[3].css);
  }

  static testMethod void statusCodesMCCompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: MC Walkthrough';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('MC', objs[3].value);
    System.assertEquals('Prep: MC Walkthrough', objs[3].subject);
    System.assertEquals('bg-inverse', objs[3].css);
  }

  static testMethod void statusCodesPSNotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Delivered';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PS', objs[4].value);
    System.assertEquals('Prep: Preview Delivered', objs[4].subject);
    System.assertEquals('', objs[4].css);
  }

  static testMethod void statusCodesPSWaitingTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Delivered';
    task.Status = 'Waiting on someone else';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PS', objs[4].value);
    System.assertEquals('Prep: Preview Delivered', objs[4].subject);
    System.assertEquals('bg-caution', objs[4].css);
  }

  static testMethod void statusCodesPSCompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Delivered';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PS', objs[4].value);
    System.assertEquals('Prep: Preview Delivered', objs[4].subject);
    System.assertEquals('bg-inverse', objs[4].css);
  }

  static testMethod void statusCodesPANotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Approved';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PA', objs[5].value);
    System.assertEquals('Prep: Preview Approved', objs[5].subject);
    System.assertEquals('', objs[5].css);
  }

  static testMethod void statusCodesPAInProgressTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Approved';
    task.Status = 'In Progress';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PA', objs[5].value);
    System.assertEquals('Prep: Preview Approved', objs[5].subject);
    System.assertEquals('bg-caution', objs[5].css);
  }

  static testMethod void statusCodesPAWaitingTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Approved';
    task.Status = 'Waiting on someone else';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PA', objs[5].value);
    System.assertEquals('Prep: Preview Approved', objs[5].subject);
    System.assertEquals('bg-caution', objs[5].css);
  }

  static testMethod void statusCodesPACompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Prep: Preview Approved';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PA', objs[5].value);
    System.assertEquals('Prep: Preview Approved', objs[5].subject);
    System.assertEquals('bg-inverse', objs[5].css);
  }

  static testMethod void statusCodesDANotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Day After';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('DA', objs[6].value);
    System.assertEquals('Maintenance: Day After', objs[6].subject);
    System.assertEquals('', objs[6].css);
  }

  static testMethod void statusCodesDAInProgressTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Day After';
    task.Status = 'In Progress';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('DA', objs[6].value);
    System.assertEquals('Maintenance: Day After', objs[6].subject);
    System.assertEquals('bg-caution', objs[6].css);
  }

  static testMethod void statusCodesDADeferredTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Day After';
    task.Status = 'Deferred';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('DA', objs[6].value);
    System.assertEquals('Maintenance: Day After', objs[6].subject);
    System.assertEquals('bg-inverse', objs[6].css);
  }

  static testMethod void statusCodesDACompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Day After';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('DA', objs[6].value);
    System.assertEquals('Maintenance: Day After', objs[6].subject);
    System.assertEquals('bg-inverse', objs[6].css);
  }

  static testMethod void statusCodesPENotStartedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Pre Expiration';
    task.Status = 'Not Started';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PE', objs[7].value);
    System.assertEquals('Maintenance: Pre Expiration', objs[7].subject);
    System.assertEquals('', objs[7].css);
  }

  static testMethod void statusCodesPEInProgressTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Pre Expiration';
    task.Status = 'In Progress';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PE', objs[7].value);
    System.assertEquals('Maintenance: Pre Expiration', objs[7].subject);
    System.assertEquals('bg-caution', objs[7].css);
  }

  static testMethod void statusCodesPEDeferredTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Pre Expiration';
    task.Status = 'Deferred';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PE', objs[7].value);
    System.assertEquals('Maintenance: Pre Expiration', objs[7].subject);
    System.assertEquals('bg-inverse', objs[7].css);
  }

  static testMethod void statusCodesPECompletedTest() {
    List<Task> tasks = new List<Task>();
    Task task = new Task();
    task.Subject = 'Maintenance: Pre Expiration';
    task.Status = 'Completed';
    tasks.add(task);

    AM_Workbench workbench = new AM_workbench();
    List<AM_Workbench.Obj> objs = workbench.getStatusCodes(tasks, AM_workbench.getDefaultStatusCodes('1234567890'));

    System.assertEquals('PE', objs[7].value);
    System.assertEquals('Maintenance: Pre Expiration', objs[7].subject);
    System.assertEquals('bg-inverse', objs[7].css);
  }

  static testMethod void dealStrengthExceptionalCaseTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = '';
    o.Deal_Bank_Eligible__c = 'Opt-In';
    o.Of_Days_Extension_for_Deal_Bank__c = 1;
    o.Feature_end_date__c = System.today();
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals(NULL, g1.dealStrength.css);
    System.assertEquals('', g1.dealStrength.value);
  }

  static testMethod void dealStrengthSTTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'A Sure Thing';
    o.Feature_Date__c = System.today().addDays(1);
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('ST', g1.dealStrength.value);
  }

  static testMethod void dealStrengthDBTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = '';
    o.Deal_Bank_Eligible__c = 'Opt-In';
    o.Of_Days_Extension_for_Deal_Bank__c = 1;
    o.Feature_Date__c = System.today();
    o.Feature_end_date__c = System.today();
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-success', g1.dealStrength.css);
    System.assertEquals('DB', g1.dealStrength.value);

    o.Deal_Strengh__c = '';
    o.Deal_Bank_Eligible__c = 'Opt-In';
    o.Of_Days_Extension_for_Deal_Bank__c = 30;
    o.Feature_Date__c = System.today().addDays(7);
    o.Feature_End_Date__c = System.today().addDays(14);
    g1 = new AM_workbench.g1(o, true);
    System.assertNotEquals('DB', g1.dealStrength.value);
  }

  static testMethod void dealStrengthNEGTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'Renegotiate';
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('NEG', g1.dealStrength.value);
  }

  static testMethod void dealStrengthHoldTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'Hold';
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('HOLD', g1.dealStrength.value);
  }

  static testMethod void dealStrengthREJTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'Rejected';
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('REJ', g1.dealStrength.value);
  }

  static testMethod void dealStrengthVETTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'Vetted';
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('VET', g1.dealStrength.value);
  }

  static testMethod void dealStrengthRECTest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'Recommended';
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('REC', g1.dealStrength.value);
  }

  static testMethod void dealStrengthRGITest() {
    Opportunity o = new Opportunity();
    o.Deal_Strengh__c = 'Rep Getting Info';
    AM_workbench.g1 g1 = new AM_workbench.g1(o, true);
    System.assertEquals('label-inverse', g1.dealStrength.css);
    System.assertEquals('RGI', g1.dealStrength.value);
  }

  static testMethod void getUSDefaultStatusCodes() {
    List<AM_workbench.Obj> statuses = AM_workbench.getDefaultStatusCodes('1234567890');
    System.assertEquals( 'IN', statuses[0].value );
    System.assertEquals( 'GR', statuses[1].value );
    System.assertEquals( 'FD', statuses[2].value );
    System.assertEquals( 'MC', statuses[3].value );
    System.assertEquals( 'PS', statuses[4].value );
    System.assertEquals( 'PA', statuses[5].value );
    System.assertEquals( 'DA', statuses[6].value );
    System.assertEquals( 'PE', statuses[7].value );
  }

  static testMethod void getUKDefaultStatusCodesLongOrgID() {
    List<AM_workbench.Obj> statuses = AM_workbench.getDefaultStatusCodes(AM_workbench.UK_staging);
    System.assertEquals( 'PREP', statuses[0].value );
    System.assertEquals( 'EMAIL', statuses[1].value );
    System.assertEquals( 'MC', statuses[2].value );
    System.assertEquals( 'PS', statuses[3].value );
    System.assertEquals( 'PA', statuses[4].value );
    System.assertEquals( 'DA', statuses[5].value );
    System.assertEquals( 'PE', statuses[6].value );
  }

  static testMethod void getUKDefaultStatusCodesShortOrgID() {
    List<AM_workbench.Obj> statuses = AM_workbench.getDefaultStatusCodes(AM_workbench.shortId(AM_workbench.UK_staging));
    System.assertEquals( 'PREP', statuses[0].value );
    System.assertEquals( 'EMAIL', statuses[1].value );
    System.assertEquals( 'MC', statuses[2].value );
    System.assertEquals( 'PS', statuses[3].value );
    System.assertEquals( 'PA', statuses[4].value );
    System.assertEquals( 'DA', statuses[5].value );
    System.assertEquals( 'PE', statuses[6].value );
  }

  static testMethod void schedulerStatusDefaultTest() {
    Account a = new Account();
    a.Eligible_for_Scheduler__c = 'No';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('S', m.schedulerStatus.value);
    System.assertEquals('badge-single', m.schedulerStatus.css);
  }

  static testMethod void schedulerStatusInverseTest() {
    Account a = new Account();
    a.Eligible_for_Scheduler__c = 'Yes';
    a.Groupon_Scheduler_Strength__c = 'Rejected - Product Constraints';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Rejected - Ineligible';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Declined';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Deactivated';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = '';
    a.Scheduler_Eligibility_Status__c = 'Rejected - Product Constraints';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);

    a.Scheduler_Eligibility_Status__c = 'Rejected - Ineligible';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);

    a.Scheduler_Eligibility_Status__c = 'Not Interested';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-inverse', m.schedulerStatus.css);
  }

  static testMethod void schedulerStatusDangerTest() {
    Account a = new Account();
    a.Eligible_for_Scheduler__c = 'Yes';
    a.Scheduler_Eligibility_Status__c = '';
    a.Groupon_Scheduler_Strength__c = '';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-danger', m.schedulerStatus.css);
  }

  static testMethod void schedulerStatusWarningTest() {
    Account a = new Account();
    a.Eligible_for_Scheduler__c = 'Yes';
    a.Scheduler_Eligibility_Status__c = 'Contacted';
    a.Groupon_Scheduler_Strength__c = '';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-warning', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Contacted';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-warning', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Pending Contact';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-warning', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Merchant Unresponsive';
    a.Scheduler_Eligibility_Status__c = '';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-warning', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = 'Merchant Unresponsive';
    a.Scheduler_Eligibility_Status__c = 'Not Interested';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-warning', m.schedulerStatus.css);
  }

  static testMethod void schedulerStatusInfoTest() {
    Account a = new Account();
    a.Eligible_for_Scheduler__c = 'Yes';
    a.Scheduler_Eligibility_Status__c = 'Referred';
    a.Groupon_Scheduler_Strength__c = 'In Process';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-info', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = '';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-info', m.schedulerStatus.css);

    a.Scheduler_Eligibility_Status__c = 'Hot Transferred';
    a.Groupon_Scheduler_Strength__c = 'In Process';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-info', m.schedulerStatus.css);

    a.Groupon_Scheduler_Strength__c = '';
    m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-info', m.schedulerStatus.css);
  }

  static testMethod void schedulerStatusSuccessTest() {
    Account a = new Account();
    a.Eligible_for_Scheduler__c = 'Yes';
    a.Groupon_Scheduler_Strength__c = 'Active';
    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    System.assertEquals('badge-single badge-success', m.schedulerStatus.css);
  }

  static testMethod void breadcrumbStatusGreenTest() {
    Account a = new Account();
    POS_Order__c b = new POS_Order__c();
    b.POS_Sales_Status__c = 'Closed Won';
    b.HSA_GoLive__c = DateTime.now().addDays(-5);

    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-success', m.breadcrumbStatus.css);
  }

  static testMethod void breadcrumbStatusInverseTest() {
    Account a = new Account();
    a.POS_Lead_Source__c = 'AM Contacted - Not Interested';
    POS_Order__c b = new POS_Order__c();
    b.POS_Sales_Status__c = 'Closed Lost';

    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-inverse', m.breadcrumbStatus.css);

    b.POS_Sales_Status__c = 'Not Currently Interested';

    m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-inverse', m.breadcrumbStatus.css);
  }

  static testMethod void breadcrumbStatusBlueTest() {
    Account a = new Account();
    POS_Order__c b = new POS_Order__c();
    b.POS_Sales_Status__c = 'Closed Won';

    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-info', m.breadcrumbStatus.css);

    b.HSA_GoLive__c = DateTime.now().addDays(5);

    m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-info', m.breadcrumbStatus.css);
  }

  static testMethod void breadcrumbStatusOrangeTest() {
    Account a = new Account();
    POS_Order__c b = new POS_Order__c();
    b.POS_Sales_Status__c = 'Prospecting';

    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-warning', m.breadcrumbStatus.css);

    b.POS_Sales_Status__c = 'Interested';

    m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-warning', m.breadcrumbStatus.css);

    b.POS_Sales_Status__c = 'Very Interested';

    m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-warning', m.breadcrumbStatus.css);

    b.POS_Sales_Status__c = 'Contract Sent';

    m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-warning', m.breadcrumbStatus.css);
  }

  static testMethod void breadcrumbStatusRedTest() {
    Account a = new Account();
    POS_Order__c b = new POS_Order__c();

    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-danger', m.breadcrumbStatus.css);
  }

  static testMethod void breadcrumbStatusDefaultTest() {
    Account a = new Account();
    POS_Order__c b = new POS_Order__c();

    AM_workbench.Merchant m = new AM_workbench.Merchant(a);
    m.managerId = 'abc';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);

    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single', m.breadcrumbStatus.css);

    m.category = 'Food & Drink';
    m.setBreadcrumbStatus(b.POS_Sales_Status__c, b.HSA_GoLive__c);
    System.assertEquals('B', m.breadcrumbStatus.value);
    System.assertEquals('badge-single badge-danger', m.breadcrumbStatus.css);
  }

  static testMethod void CLPStatusGreen() {
    Account account = new Account();
    AM_workbench.Merchant merchant = new AM_workbench.Merchant(account);

    merchant.salesValue = 1.0;
    merchant.setCLPStatus(0);
    System.assertEquals('Q', merchant.clpStatus.value);
    System.assertEquals('badge-single badge-success', merchant.clpStatus.css);

    merchant.salesValue = 1.0;
    merchant.setCLPStatus(0.5);
    System.assertEquals('Q', merchant.clpStatus.value);
    System.assertEquals('badge-single badge-success', merchant.clpStatus.css);
  }

  static testMethod void CLPStatusYellow() {
    Account account = new Account();
    AM_workbench.Merchant merchant = new AM_workbench.Merchant(account);

    merchant.salesValue = 1.0;
    merchant.setCLPStatus(0.51);
    System.assertEquals('Q', merchant.clpStatus.value);
    System.assertEquals('badge-single badge-caution', merchant.clpStatus.css);

    merchant.salesValue = 1.0;
    merchant.setCLPStatus(1);
    System.assertEquals('Q', merchant.clpStatus.value);
    System.assertEquals('badge-single badge-caution', merchant.clpStatus.css);
  }

  static testMethod void CLPStatusLightGray() {
    Account account = new Account();
    AM_workbench.Merchant merchant = new AM_workbench.Merchant(account);
    merchant.salesValue = null;
    merchant.setCLPStatus(0);
    System.assertEquals('Q', merchant.clpStatus.value);
    System.assertEquals('badge-single', merchant.clpStatus.css);

    merchant.salesValue = 0.0;
    merchant.setCLPStatus(1);
    System.assertEquals('Q', merchant.clpStatus.value);
    System.assertEquals('badge-single', merchant.clpStatus.css);
  }

  static testMethod void getMerchantListInLast7Styles() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a = AM_workbenchUnitTest.buildAccount(u);
      Opportunity o = AM_workbenchUnitTest.buildOpportunity(a);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a));
      AM_workbench.g1 d = new AM_workbench.g1(o, true);
      d.featureDate = System.today().addDays(-6).format();
      merchants[0].g1deals.add(d);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals('last', orderedMerchants[0].sectionStyle);
      System.assertEquals('-10', orderedMerchants[0].endCap);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListInNext7Styles() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a = AM_workbenchUnitTest.buildAccount(u);
      Opportunity o = AM_workbenchUnitTest.buildOpportunity(a);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a));
      AM_workbench.g1 d = new AM_workbench.g1(o, true);
      d.featureDate = System.today().addDays(6).format();
      merchants[0].g1deals.add(d);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals('next', orderedMerchants[0].sectionStyle);
      System.assertEquals('+10', orderedMerchants[0].endCap);

      Test.stopTest();
    }
  }

  static testMethod void getMerchantListNext7OverLast7Styles() {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
    insert u;

    System.RunAs(u)
    {
      Account a = AM_workbenchUnitTest.buildAccount(u);
      Opportunity o = AM_workbenchUnitTest.buildOpportunity(a);

      List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();
      merchants.add(new AM_workbench.Merchant(a));
      AM_workbench.g1 d = new AM_workbench.g1(o, true);
      d.featureDate = System.today().format();
      merchants[0].g1deals.add(d);

      Test.startTest();

      AM_workbench workbench = new AM_workbench();
      List<AM_workbench.Merchant> orderedMerchants = workbench.orderMerchants(merchants);
      System.assertEquals('next', orderedMerchants[0].sectionStyle);
      System.assertEquals('+10', orderedMerchants[0].endCap);

      Test.stopTest();
    }
  }
}