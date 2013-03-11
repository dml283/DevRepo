//01pc00000008mPp
@RestResource(urlMapping = '/quantum-lead/update-accounts')

global class RESTUpdateAccounts {

    @HttpPOST
    global static List<Account> updateAccount(List<Account> accountList) {
        Database.SaveResult[] saveResults = Database.update(accountList);

        return [select Id, OwnerId, deassignment_warning__c from Account where Id in :accountList];
    }

    @istest
    public static void testmethod_REST_Valid_POST() {
        User u = new GrouponTestUtil().createTestUser('API/DEV');
        Insert u;

        System.runAs(u) {
            Account new_account = new Account();
            new_account.Name = 'Test';
            new_account.BillingStreet = '123 Main';
            new_account.BillingCity = 'Chicago';
            new_account.BillingState = 'IL';
            new_account.BillingPostalCode = '11111';
            new_account.BillingCountry = 'US';
            insert new_account;

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/quantum-lead/update-accounts';
            req.httpMethod = 'POST';

            Account account_to_update = (Account) json.deserialize('{' +
              '"Id" : "' + new_account.id + '",' +
              '"OwnerId" : "' + u.id + '",' +
              '"deassignment_warning__c" : "Reassigned in 8 days unless legitimate new activity."' +
            '}', Account.class);

            RestContext.request = req;
            List<Account> accounts = new List<Account>();
            accounts.add(account_to_update);
            List<Account> response = RESTUpdateAccounts.updateAccount(accounts);

            Account updated_account = response.get(0);
            System.Assert(updated_account.ownerid == u.id);
        }
    }
}