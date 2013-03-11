//01pc00000008imfAAA
@RestResource(urlMapping='/quantum_lead/sales_rep/daily_capacity')
global class RESTSalesRepDailyCapacityAPI {
    private static List<String> log;

    private static String listToString(List<Integer> l) {
        String str = '';

        for(Integer i : l) {
            String s = String.valueOf(i);

            if(str.length() == 0) {
                str = s;
            } else {
                str += '; ' + s;
            }
        }

        return str;
    }

    private static String listToString(List<String> l) {
        String str = '';

        for(String s : l) {
            if(str.length() == 0) {
                str = s;
            } else {
                str += '; ' + s;
            }
        }

        return str;
    }

    @HttpGET
    global static List<SalesRepCapacity> getCapacities() {
        Map<String, String> params = RestContext.request.params;
        List<String> repIds = params.get('repIds').split(',');

        return getCapacities(repIds);
    }

    @HttpPOST
    global static List<SalesRepCapacity> getCapacities(List<String> repIds) {
        log = new List<String>();

        List<SalesRepCapacity> capacities = new List<SalesRepCapacity>();
        Map<String, Integer> capacitiesByRepId = calculateAverageDailyCapacities(repIds);

        for(String repId : capacitiesByRepId.keySet()) {
            capacities.add(new SalesRepCapacity(repId, capacitiesByRepId.get(repId)));
        }

        if(log.size() > 0) {
            RestContext.response.addHeader('X-Debug-Log', listToString(log));
        }

        return capacities;
    }

    private static Map<String, Integer> calculateAverageDailyCapacities(String[] repIds) {
        Map<String, Map<DateTime, Integer>> totalMerchantTouchesPerRepDay = new Map<String, Map<DateTime, Integer>>();
        List<AggregateResult> merchantsWithTasksByRepDay = getNumberOfMerchantsWithTasksPerDay(repIds);
        List<AggregateResult> merchantsWithEventsByRepDay = getNumberOfMerchantsWithEventsPerDay(repIds);

        for (String repId : repIds) {
            ID case_safe_id = repId;
            totalMerchantTouchesPerRepDay.put(case_safe_id, new Map<DateTime, Integer>());
        }

        for (AggregateResult result : merchantsWithTasksByRepDay) {
            String repId              = (String) result.get('OwnerId');
            Integer numberOfMerchants = (Integer) result.get('number_of_merchants');
            DateTime completed_date   = (DateTime) result.get('Completed_Date__c');

            totalMerchantTouchesPerRepDay.get(repId).put(completed_date, numberOfMerchants);
        }

        for (AggregateResult result : merchantsWithEventsByRepDay) {
            String repId              = (String) result.get('OwnerId');
            Integer numberOfMerchants = (Integer) result.get('number_of_merchants');
            DateTime activity_date    = (DateTime) result.get('ActivityDate');

            Map<DateTime, Integer> rep = totalMerchantTouchesPerRepDay.get(repId);
            Integer taskMerchantCount = rep.get(activity_date);
            if (taskMerchantCount == null) {
                totalMerchantTouchesPerRepDay.get(repId).put(activity_date, numberOfMerchants);
            } else {
                totalMerchantTouchesPerRepDay.get(repId).put(activity_date, numberOfMerchants + taskMerchantCount);
            }
        }

        Map<String, Integer> averageMerchantsPerDayPerRep = new Map<String, Integer>();

        for(String repId : totalMerchantTouchesPerRepDay.keySet()) {
            List<Integer> merchantCounts = totalMerchantTouchesPerRepDay.get(repId).values();

            if(merchantCounts.size() > 0) {
                Integer sum = 0;
                for(Integer count : merchantCounts) {
                    sum += count;
                }

                averageMerchantsPerDayPerRep.put(repId, sum / merchantCounts.size());
            } else {
                averageMerchantsPerDayPerRep.put(repId, 0);
            }
        }

        return averageMerchantsPerDayPerRep;
    }

    private static List<AggregateResult> getNumberOfMerchantsWithTasksPerDay(String[] repIds) {
        Date startDate = getStartDate();
        Date endDate = getEndDate();

        return [SELECT OwnerId, Completed_Date__c, COUNT_DISTINCT(Account.id) number_of_merchants
                FROM Task
                WHERE OwnerId IN :repIds
                AND AccountId != null
                AND Completed_Date__c != NULL
                AND Completed_Date__c >= :startDate
                AND Completed_Date__c <= :endDate
                AND Type NOT IN ('Email - Click', 'Email - Inbound', 'Email - Inbound POS', 'Email - Open')
                GROUP BY OwnerId, Completed_Date__c
                HAVING COUNT_DISTINCT(Account.id) > 0
                ORDER BY Completed_Date__c];
    }

    private static List<AggregateResult> getNumberOfMerchantsWithEventsPerDay(String[] repIds) {
        Date startDate = getStartDate();
        Date endDate = getEndDate();

        return [SELECT OwnerId, ActivityDate, COUNT_DISTINCT(Account.id) number_of_merchants
                FROM event
                WHERE OwnerId IN :repIds
                AND AccountId != null
                AND ActivityDate >= :startDate
                AND ActivityDate <= :endDate
                GROUP BY OwnerId, ActivityDate
                ORDER BY ActivityDate];
    }

    global class SalesRepCapacity {
        public String sales_rep_id { get; set; }
        public Integer daily_capacity { get; set; }

        public SalesRepCapacity(String sales_rep_id, Integer capacity) {
            this.sales_rep_id = sales_rep_id;
            this.daily_capacity = capacity;
        }
    }

    private static Date getStartDate(){
      return Date.today().addDays(-13);
    }

    private static Date getEndDate(){
      return Date.today();
    }

    @isTest
    static void test() {
      GrouponTestUtil test = new GrouponTestUtil();
      User user = test.createTestUser();
      insert user;

      Task task = test.createCompletedTask(user, Date.today());
      task.completed_date__c = Date.today().addDays(-5);
      insert task;

      RestRequest req = new RestRequest();
      req.httpMethod = 'GET';
      req.addParameter('repIds', (String)user.id);
      RestContext.request = req;

      RestResponse res = new RestResponse();
      RestContext.response = res;

      List<SalesRepCapacity> capacities = getCapacities();

    }

    @isTest
    static void testDateRange() {
      System.assert(getStartDate() == Date.today().addDays(-13));
      System.assert(getEndDate() == Date.today());
    }

    @isTest
    static void testSalesRepCapacity() {
      SalesRepCapacity src = new SalesRepCapacity('some-rep-id', 10);
      System.assert(src.sales_rep_id == 'some-rep-id');
      System.assert(src.daily_capacity == 10);
    }

    @isTest
    static void testListToString() {
      List<String> strings = new List<String>();
      strings.add('a');
      strings.add('b');
      strings.add('c');
      List<Integer> numbers = new List<Integer>();
      numbers.add(1);
      numbers.add(2);
      numbers.add(3);

      System.assert(listToString(strings) == 'a; b; c');
      System.assert(listToString(numbers) == '1; 2; 3');
    }
}