@isTest
public class AMrulesEngineTest {
  private static User u1;
  private static account a;
  private static opportunity o;
  private static task t;

  private static void setup() {
    Profile p = [select id from profile where name = 'System Administrator'];

    u1 = new User(alias = 'standt',
                  email = 'standarduser@groupon.com',
                  emailencodingkey = 'UTF-8',
                  lastname = 'Testing',
                  languagelocalekey = 'en_US',
                  localesidkey = 'en_US',
                  profileid = p.Id,
                  timezonesidkey = 'America/Los_Angeles',
                  username = 'standarduser1@groupon.com');
    insert u1;

    User u2 = new User(alias = 'user2',
                  email = 'standarduser2@groupon.com',
                  emailencodingkey = 'UTF-8',
                  lastname = 'Testing',
                  languagelocalekey = 'en_US',
                  localesidkey = 'en_US',
                  profileid = p.Id,
                  timezonesidkey = 'America/Los_Angeles',
                  username = 'standarduser2@groupon.com');
    insert u2;

    User u3 = new User(alias = 'user3',
                  email = 'standarduser3@groupon.com',
                  emailencodingkey = 'UTF-8',
                  lastname = 'Testing',
                  languagelocalekey = 'en_US',
                  localesidkey = 'en_US',
                  profileid = p.Id,
                  timezonesidkey = 'America/Los_Angeles',
                  username = 'standarduser3@groupon.com');
    insert u3;

    User u4 = new User(alias = 'user4',
                  email = 'standarduser4@groupon.com',
                  emailencodingkey = 'UTF-8',
                  lastname = 'Testing',
                  languagelocalekey = 'en_US',
                  localesidkey = 'en_US',
                  profileid = p.Id,
                  timezonesidkey = 'America/Los_Angeles',
                  username = 'standarduser4@groupon.com');
    insert u4;

    Division__c d = new Division__c();
    d.Name ='Test';
    d.State__c ='IL';
    d.City_CEO__c = u2.id;
    d.dsm__c = u3.id;
    d.market_planner__c = u4.id;
    insert d;

    a = new Account();
    a.Name = 'testing account';
    a.Division__c = d.id;
    a.BillingStreet = '123456 test';
    a.BillingCity = 'Chicago';
    a.BillingState = 'IL';
    a.BillingPostalCode = '60640';
    a.BillingCountry = 'US';
    a.Payments_Active_Status__c = 'Prospect';
    a.Payments_Eligible__c = 'Yes';
    a.Payments_Product_Sales_Status__c = 'Status';
    a.Payments_Lead_Source__c = 'AM Contacted - In Progress';
    a.Payments_Manager__c = u1.Id;
    a.Category_v3__c = 'Food and Drink';
    a.POS_Interest__c = 'AM Contacted - In Progress';
    a.POS_Manager__c = u1.Id;
    insert a;

    date closeDate = date.parse('12/31/2012');
    date featureDateChangeDate = date.parse('11/21/1985');
    date featureDateEndDate = date.parse('11/28/1985');
    o = new opportunity();
    o.name = 'test oppty';
    o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
    o.division__c = 'Test';
    o.Division_Dynamic__c = d.id;
    o.Deal_strengh__c = 'A Sure Thing';
    o.AccountId = a.id;
    o.StageName = 'Closed Won';
    o.CloseDate = closeDate;
    o.Category__c = 'Health & Beauty';
    o.city_manager__c = null;
    o.divisional_sales_manager__c = NULL;
    o.user__c = NULL;
    o.Feature_Date_Change_Date__c = featureDateChangeDate;
    o.Feature_End_Date__c = featureDateEndDate;
    o.GrouponLite_Monthly_Cap__c = 1.0;
    insert o;

    Merchant_Temperature__c temperature = new Merchant_Temperature__c();
    temperature.Account__c = a.Id;
    temperature.Overall_Experience_Ranking__c = 10;
    insert temperature;

    Case kase = new Case();
    kase.AccountId = a.id;
    kase.type = 'Normal Case';
    kase.status = 'Escalated';
    insert kase;

    Multi_deal__c md = new Multi_deal__c();
    md.opportunity__c = o.id;
    insert md;

    address__c addy = new Address__c();
    addy.opportunity__c = o.id;
    addy.street_line_1__c = 'some street';
    addy.city__c = 'city';
    addy.state__c ='ST';
    insert addy;
  }

  static testMethod void GetMerchantsTest() {
    setup();

    System.RunAs(u1)
    {
      test.StartTest();

      AMrulesEngine engine = new AMrulesEngine();
      Set<Id> ids = new Set<Id>();
      ids.add(a.id);
      List<AMrulesEngine.Merchant> merchants = engine.getMerchants(ids);
      AMrulesEngine.Merchant merchant = merchants[0];
      AMrulesEngine.Deal opportunity = merchant.opportunities[0];

      System.assertEquals(merchant.id, a.id);
      System.assertEquals(NULL, merchant.last_activity_date);
      System.assertEquals(a.Payments_Active_Status__c, merchant.payments_active_status);
      System.assertEquals(a.Payments_Eligible__c, merchant.payments_eligible);
      System.assertEquals(a.Payments_Product_Sales_Status__c, merchant.payments_product_sales_status);
      System.assertEquals(u1.Id, merchant.payments_manager);
      System.assertEquals('AM Contacted - In Progress', merchant.payments_lead_source);
      System.assertEquals(u1.Id, merchant.pos_manager);
      System.assertEquals('AM Contacted - In Progress', merchant.pos_interest);
      System.assertEquals('Food and Drink', merchant.category);
      System.assertEquals(o.Feature_Date_Change_Date__c, opportunity.feature_date_change_date);
      System.assertEquals(o.Feature_End_Date__c, opportunity.feature_end_date);
      System.assertEquals(o.Go_Live_Date__C, opportunity.go_live_date);
      System.assertEquals(o.StageName, opportunity.stage_name);
      System.assertEquals(o.GrouponLite_Monthly_Cap__c, opportunity.groupon_lite_monthly_cap);
      System.assertEquals(0, merchant.temperatures.size());
      System.assertEquals(1, merchant.cases.size());
      System.debug(json.serializePretty(merchants));

      Test.StopTest();
    }
  }

  public class MockSendMerchantDataHttp implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
      System.assertEquals('POST', request.getMethod());
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      response.setBody('{"foo":"bar"}');
      response.setStatusCode(200);
      return response;
    }
  }

  static testMethod void sendMerchantDataTest() {
    Test.setMock(HttpCalloutMock.class, new MockSendMerchantDataHttp());
    Set<Id> accountIds = new Set<Id>();
    AMrulesEngine.sendMerchantData(accountIds);
  }
}