//01pc00000008hHg
@RestResource(urlMapping='/quantum_lead/account_activity')

global class RESTAccountActivityAPI {

    @HttpGET
    global static List<AccountActivity> get() {
        Map<String, String> params = RestContext.request.params;
        if(params.containsKey('owner_id')) {
            String ownerid = params.get('owner_id');
            Date minDate = Date.today().addDays(-180);

            List<Account> accounts = getUserAccounts(ownerid);
            List<Task> tasks = getUserTasks(ownerid, minDate);
            Map<Id,Task> taskMap = mapAccountIdToLastTask(tasks);

            List<AccountActivity> response = new List<AccountActivity>();
            for (Account account : accounts) {
              AccountActivity accountActivity = new AccountActivity();
              accountActivity.account = account;
              accountActivity.lastCompletedActivity = taskMap.get(account.id);

              response.add(accountActivity);
            }

            return response;
        } else {
            restContext.response.statusCode = 400;
            return null;
        }
    }

    global static List<Account> getUserAccounts(String ownerid) {
        return [select id, parentid, name, owner.name, Most_Recent_Last_Close_Date__c,
                  Acct_Owner_Change_Date__c, Previous_Account_Owner__r.name, CreatedDate,
                  Created_Date_Custom__c, Sales_Value__c, Call_List_Priority__c,
                  Most_Recent_Expiry_Date__c, Lead_Source_Custom__c, Top_Merchant_Campaign__c,
                  Research_Ranking__c, Merchant_Tier__c, Total_GP__c, Number_of_Features__c,
                  Most_Recent_Feature__c, Hot_Lead__c, Date_of_Hotness__c, Inbound_Team__c,
                  (
                    select echosign_dev1__DateSentDate__c, echosign_dev1__StatusVisible__c
                    from echosign_dev1__Agreements__r
                    where echosign_dev1__DateSentDate__c != null
                    order by echosign_dev1__DateSentDate__c desc
                    limit 1
                  ),(
                    select id, CloseDate, RecordType.name, ownerid, StageName,
                      Groupon_Expiration_Date__c, Expiration_Type__c,
                      GrouponLite_Cancellation_Reason__c, GrouponLite_Cancellation_Request_Date__c
                    from Opportunities
                    where StageName = 'Closed Won'
                    order by CloseDate desc
                    limit 1
                  )
                from Account
                where ownerid = :ownerid
               ];
    }

    global static List<Task> getUserTasks(String ownerid, Date minDate) {
        return [select accountid, CallDisposition, qbdialer__Call_Date_Time__c, qbdialer__Call_Lead_Status__c, Completed_Date__c, Merchant_Status__c, CallType, Type
                from Task
                where ownerid = :ownerid and Completed_Date__c >= :minDate
                order by Completed_Date__c
        ];
    }

    global static Map<Id, Task> mapAccountIdToLastTask(List<Task> tasks) {
        Map<Id, Task> result = new Map<Id, Task>();
        for (Task task : tasks) {
            result.put(task.accountid, task); //assumes tasks are sorted by date and we want the latest one
        }

        return result;
    }

    global class AccountActivity {
      public Account account            { get; set; }
      public Task lastCompletedActivity { get; set; }
    }

    @isTest
    static void testGet() {
        RestContext.request = new RestRequest();
        RestContext.request.httpMethod = 'GET';

        String repId = '005C00000045LzC';
        RestContext.request.addParameter('owner_id', repId);
        Account a = new Account(ownerid = repId, name = 'account name');
        Insert a;

        //TODO create an activity

        List<AccountActivity> accountActivities = RESTAccountActivityAPI.get();

        System.assert(accountActivities.size() > 0);

        for (AccountActivity accountActivity : accountActivities) {
            System.assert(accountActivity.account.OwnerId == repId);
            System.assert(accountActivity.account.CreatedDate != null);
        }
    }

    @isTest
    static void testGetWithRelatedActivities() {
        /*
         * We should get tasks that are associated with the rep's accounts' opportunities
         */

        RestContext.request = new RestRequest();
        RestContext.request.httpMethod = 'GET';

        String repId = '005C00000045LzC';
        RestContext.request.addParameter('owner_id', repId);

        Account a = new Account(ownerid = repId, name = 'account name');
        Insert a;

        Opportunity opp = new Opportunity(Accountid = a.id, Name = 'foo', StageName = 'Prospecting', CloseDate = Date.today()); //not sure why CloseDate is required, but apparently it is.
        Insert opp;

        Task task = new Task(ownerid = repId, whatid = opp.id, Completed_Date__c = Date.today());
        Insert task;

        AccountActivity accountActivity = RESTAccountActivityAPI.get().get(0);
        System.assert(accountActivity.lastCompletedActivity != null);
        System.assert(accountActivity.lastCompletedActivity.id == task.id);
    }
}