//01pc00000008hI5
@RestResource(urlMapping='/quantum_lead/accounts_from_house_account')

global class RESTAccountsFromHouseAccount {

    @HttpGET
    global static List<Account> get() {
        Map<String, String> params = RestContext.request.params;
        String divisionPermalink = params.get('division_permalink');
        Integer lim = Integer.valueOf(params.get('limit'));

        return queryAccountsFromHouseAccount(divisionPermalink, lim);
    }

    static List<Account> queryAccountsFromHouseAccount(String divisionPermalink, Integer lim) {
        return [select id, name, owner.id, Previous_Account_Owner__c, Category_v3__c, division__r.permalink__c, Sales_Value__c
                from Account
                where division__r.permalink__c = :divisionPermalink
                order by Sales_Value__c desc
                limit :lim];
    }

    @isTest
    static void testGet_returnsGoodAccountsFirst() {
        Division__c div = new Division__c( name = 'Cleveland', Permalink__c = 'cleveland', State__c = 'OH');
        Insert div;

        for (Integer i = 0; i < 10; i++) {
          Insert new Account(name = 'account name', division__c = div.id, Sales_Value__c = 0);
        }

        Insert new Account(name = 'good account', division__c = div.id, Sales_Value__c = 10);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'GET';
        req.addParameter('division_permalink', 'cleveland');
        req.addParameter('limit', '5');

        RestContext.request = req;
        RestContext.response = res;
        List<Account> accounts = get();

        System.assert(accounts.get(0).name == 'good account');
    }

    @isTest
    static void testGet() {
        Division__c div = new Division__c( name = 'Cleveland', Permalink__c = 'cleveland', State__c = 'OH');
        Insert div;

        for (Integer i = 0; i < 10; i++) {
          Insert new Account(name = 'account name', division__c = div.id);
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'GET';
        req.addParameter('division_permalink', 'cleveland');
        req.addParameter('limit', '5');

        RestContext.request = req;
        RestContext.response = res;
        List<Account> accounts = get();

        System.assert(accounts.size() == 5);
    }
}