//01pc00000008hwt
@RestResource(urlMapping = '/quantum_lead/category_statistics_for_assignment')

global class RESTCategoryStatisticsForAssignment {

  @HttpPOST
  global static List<CategoryStatistics> post(List<String> repids) {
    List<AggregateResult> results =  [select ownerid, count(id) category_count, Category_v3__c FROM account where
            OwnerId IN :repids group by OwnerId, Category_v3__c];

    List<CategoryStatistics> stats = new List<CategoryStatistics>();
    for (AggregateResult result : results) {
      stats.add(new CategoryStatistics( (String) result.get('ownerid'),
            (Integer) result.get('category_count'),
            (String) result.get('Category_v3__c')));
    }

    return stats;
  }

  global class CategoryStatistics {
    public String owner_id { get; set; }
    public Integer category_count { get; set; }
    public String category { get; set; }

    public CategoryStatistics(String owner_id, Integer category_count, String category) {
      this.owner_id = owner_id;
      this.category_count = category_count;
      this.category = category;
    }
  }

  @isTest
  public static void testmethod_REST_Valid_POST() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/v1.0/quantum_lead/sales_rep_portfolio';
    req.httpMethod = 'POST';
    RestContext.request = req;
    String id = '005C0000003SW5QIAW';
    Account a = new Account();
    a.name = 'test merchant';
    a.ownerId = id;
    Insert a;
    List<String> repIds = new List<String>();
    repIds.add(id);
    List<CategoryStatistics> stats = post(repIds);

    System.Assert(stats.size() == 1);
  }
}