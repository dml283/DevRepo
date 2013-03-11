// 01pc00000008hxD
@RestResource(urlMapping = '/quantum_lead/user_account_statistics_for_assignment')

global class RESTUserAccountStatisticsForAssignment {

  @HttpPOST
  global static List<UserStatistics> post(List<String> repids) {
    List<AggregateResult> newAccountsResults =  [select ownerid, count(id) number_of_new_accounts FROM account where
            OwnerId IN :repids AND Number_of_Features__c = 0 group by OwnerId order by ownerid];

    List <AggregateResult> totalAccountsResults =  [select ownerid, count(id) total_number_of_accounts FROM account where
            OwnerId IN :repids group by OwnerId order by ownerid];

    Map<String, UserStatistics> statsMap = new Map<String, UserStatistics>();

    for (AggregateResult result : totalAccountsResults) {
      String ownerid = (String) result.get('OwnerId');
      Integer count = (Integer) result.get('total_number_of_accounts');
      UserStatistics stats = new UserStatistics(ownerid, 0, 0);
      stats.total_number_of_accounts = count;
      statsMap.put(ownerid, stats);
    }


    for (AggregateResult result : newAccountsResults) {
      String ownerid = (String) result.get('OwnerId');
      Integer count = (Integer) result.get('number_of_new_accounts');
      UserStatistics stats = statsMap.get(ownerid);
      stats.number_of_new_accounts = count;
    }

    return statsMap.values();
  }

  global class UserStatistics {
    public String owner_id { get; set; }
    public Integer number_of_new_accounts { get; set; }
    public Integer total_number_of_accounts { get; set; }

    public UserStatistics(String owner_id, Integer number_of_new_accounts,
        Integer total_number_of_accounts) {
      this.owner_id = owner_id;
      this.number_of_new_accounts = number_of_new_accounts;
      this.total_number_of_accounts = total_number_of_accounts;
    }

  }

  @isTest
  static void testPost() {
      RestRequest req = new RestRequest();
      RestResponse res = new RestResponse();
      req.httpMethod = 'POST';

      RestContext.request = req;

      String id = '005C000000456gx';

      Account a1 = new Account();
      a1.ownerId = id;
      a1.Name = 'test merchant';
      Insert a1;

      List<String> repids = new List<String>();
      repids.add(id);

      List<UserStatistics> stats = post(repids);

      System.assert(stats.get(0).number_of_new_accounts == 1);
      System.assert(stats.get(0).total_number_of_accounts == 1);
  }
}