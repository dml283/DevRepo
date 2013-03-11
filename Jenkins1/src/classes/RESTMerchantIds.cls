//01pc00000008mG4
@RestResource(urlMapping='/quantum_lead/merchant_ids')

global class RESTMerchantIds {

    @HttpGET
    global static List<Account> get() {
      Map<String, String> params = RestContext.request.params;
      String division = params.get('division');
      String ownerId = params.get('owner_id');

      if (division != null && ownerId != null) {
        //To get rep (or house) accounts in a division
        return [SELECT id FROM account WHERE division__r.permalink__c = :division and ownerid = :ownerId];
      } else if (division != null) {
        //To get division accounts
        return [SELECT id FROM account WHERE division__r.permalink__c = :division];
      } else if (ownerId != null) {
        //To get rep accounts
        return [SELECT id FROM account WHERE ownerid = :ownerId];
      } else {
        restContext.response.statusCode = 400;
        return null;
      }
    }

    @istest
    public static void test_get() {
        GrouponTestUtil util = new GrouponTestUtil();

        User u = util.createTestUser('API/DEV');
        Insert u;

        Division__c d = new Division__c(permalink__c = 'cleveland', state__c = 'IL');
        Insert d;

        Account a = new Account(name = 'account name', division__c = d.id, ownerid = u.id);
        Insert a;

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/quantum_lead/merchant_ids';
        req.httpMethod = 'GET';
        RestContext.request = req;

        //with just division
        req.params.put('division', 'cleveland');
        List<Account> accounts = RESTMerchantIds.get();
        System.assert(accounts.size() == 1);

        //with division and owner_id
        req.params.put('owner_id', u.id);
        accounts = RESTMerchantIds.get();
        System.assert(accounts.size() == 1);

        //with just owner_id
        req.params.put('division', null);
        accounts = RESTMerchantIds.get();
        System.assert(accounts.size() == 1);
    }
}