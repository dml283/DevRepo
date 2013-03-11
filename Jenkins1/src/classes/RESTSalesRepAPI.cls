//01pc00000008gAj
@RestResource(urlMapping='/quantum_lead/sales_rep')

global class RESTSalesRepAPI {

    @HttpGET
    global static List<User> get() {
        RestResponse response = RestContext.response;
        Map<String, String> params = RestContext.request.params;
        String divisionPermalink = params.get('division_permalink');
        if (divisionPermalink == '' || divisionPermalink == null) {
          response.statusCode = 400;
          return null;
        }

        List<User> users = new List<User>();

        Division__c division = getDivision(divisionPermalink);
        if (division != null) {
            users = allSalesRepsInDivision(division.name);
        }

        return users;
    }

    global static List<User> allSalesRepsInDivision(String divisionName) {
        List<Sales_Goal__c> goals = [
            select ownerid
            from Sales_Goal__c
            where Goal_Start_Date__c <= :Date.today()
              and Goal_End_Date__c >= :Date.today()
              and Division__r.name = :divisionName
              and Lead_Eligible__c = 'Yes'
        ];

        List<Id> ids = new List<Id>();
        for (Sales_Goal__c goal : goals) {
            ids.add(goal.ownerid);
        }

        return [select id, name, Profile.Name, UserRole.RollupDescription, Specialization__c, Geographic_Specialization__c
               from User
               where id in :ids and isActive = true];
    }

    global static Division__c getDivision(String divisionPermalink) {
        List<Division__c> divisions = [select name from Division__c where Permalink__c =: divisionPermalink limit 1];
        if (divisions.size() == 0) {
            return null;
        } else {
            return divisions.get(0);
        }
    }

    @isTest
    static void testSalesReps() {
        Division__c division = new Division__c();
        division.name = 'Cleveland';
        division.Permalink__c = 'cleveland';
        division.State__c = 'OH';
        Insert division;

        User user = new GrouponTestUtil().createTestUser();
        insert user;

        Date start_date = Date.today().addDays(-10);
        Date end_date = Date.today().addDays(10);

        Sales_Goal__c goal = new Sales_Goal__c(Goal_Start_Date__c = start_date, Goal_End_Date__c = end_date, Division__c = division.id, Ownerid = user.id, Lead_Eligible__c = 'Yes');
        insert goal;

        RestContext.request = new RestRequest();
        RestContext.request.httpMethod = 'GET';
        RestContext.request.addParameter('division_permalink', 'cleveland');

        List<User> response = RESTSalesRepApi.get();
        System.assert(response.size() > 0);
    }
}