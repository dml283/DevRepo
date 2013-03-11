@RestResource(urlMapping='/v1.0/merchant/payments/*')
global class RESTpaymentAPI {

    public String salesforce_id { get; set; }
    public String make_checks_payable_to { get; set; }
    public String street { get; set; }
    public String city { get; set; }
    public String state { get; set; }
    public String zip { get; set; }
    public String country { get; set; }
    public String website { get; set; }
    public String permalink { get; set; }
    public String payment_preference { get; set; }
    public String tin_status { get; set; }
    public String bank_name { get; set; }
    public String bank_account_number { get; set; }
    public String bank_routing_number { get; set; }
    public String valid_routing { get; set; }

    public String business_tax_id { get; set; }

    public List<Contact> contacts { get; set; }
    public List<Address> addresses { get; set; }

    public PaymentsInformation payments_information { get; set; }

    //constructor
    public RESTpaymentAPI(Account a){
        this.salesforce_id = a.id;
        this.make_checks_payable_to = a.Make_Checks_Payable_to__c;
        this.street = a.BillingStreet;
        this.city = a.BillingCity;
        this.state = a.BillingState;
        this.zip = a.BillingPostalCode;
        this.country = a.BillingCountry;
        this.website = a.Website;
        this.permalink = a.Merchant_Permalink__c;
        this.payment_preference = a.Payment_Preference__c;
        this.bank_name = a.Bank_Name__c;
        this.bank_account_number = a.Account_Number__c;
        this.bank_routing_number = a.Routing_Number_enc__c;
        this.valid_routing = a.Valid_Routing__c;
        this.tin_status = a.TIN_Status__c;
        this.business_tax_id = a.Tax_ID__c;

        // now lets add the children, first you need to check to see if they exist
        // notice the __r instead of using __c like you normally would,
        // this is how you do it with chidlren in a nested query
        if (a.Merchant_Addresses__r.size() > 0) {
            this.addresses = new List<Address>();
            // now we will refrence it with __c as we are talking about
            // the object here, not the related list
            for (Merchant_Addresses__c ma : a.Merchant_Addresses__r) {
                this.addresses.add(new Address(ma));
            }
        }
        if (a.Contacts.size() > 0) {
            // here we refrence contacts without the __c contacts
            // are native salesforce objects
            this.contacts = a.contacts;
        }

        this.payments_information = new PaymentsInformation(a);
    }

    //recreate the default constructor
    public RESTpaymentAPI() {}

    public class PaymentsInformation {
        String current_payments_device { get; set; }
        double number_of_units_payments { get; set; }

        Date payments_activation_date { get; set; }
        String payments_active_status { get; set; }
        Date payments_close_date_formula { get; set; }
        String payments_eligible { get; set; }
        Date payments_handoff_date { get; set; }
        ID payments_handoff_made_by { get; set; }
        boolean payments_interested { get; set; }
        String payments_lead_source { get; set; }
        ID payments_manager { get; set; }
        String payments_product_notes { get; set; }
        String payments_product_rejected_reasons { get; set; }
        String payments_product_sales_status { get; set; }
        String payment_manager_total { get; set; }
        String payment_preference { get; set; }

        String pitch_payments_product { get; set; }

        public PaymentsInformation(Account accountInfo) {
            this.current_payments_device = accountInfo.Current_Payments_Device__c;
            this.number_of_units_payments = accountInfo.Number_of_Units_Payments__c;

            this.payments_activation_date = accountInfo.Payments_Activation_Date__c;
            this.payments_active_status = accountInfo.Payments_Active_Status__c;
            this.payments_close_date_formula = accountInfo.Payments_Close_Date_Formula__c;
            this.payments_eligible = accountInfo.Payments_Eligible__c;
            this.payments_handoff_date = accountInfo.Payments_Handoff_Date__c;
            this.payments_handoff_made_by = accountInfo.Payments_Handoff_Made_By__c;
            this.payments_interested = accountInfo.Payments_Interested__c;
            this.payments_lead_source = accountInfo.Payments_Lead_Source__c;
            this.payments_manager = accountInfo.Payments_Manager__c;
            this.payments_product_notes = accountInfo.Payments_Product_Notes__c;
            this.payments_product_rejected_reasons = accountInfo.Payments_Product_Rejected_Reasons__c;
            this.payments_product_sales_status = accountInfo.Payments_Product_Sales_Status__c;
            this.payment_manager_total = accountInfo.Payment_Manager_Total__c;
            this.payment_preference = accountInfo.Payment_Preference__c;

            this.pitch_payments_product = accountInfo.Pitch_Payments_Product__c;
        }
    }

    public class Address {
        public String street_1 { get; set; }
        public String street_2 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String zip { get; set; }
        public String country { get; set; }

        public Address(Merchant_Addresses__c ma) {
            this.street_1 = ma.Street_Line_1__c;
            this.street_2 = ma.Street_Line_2__c;
            this.city = ma.City__c;
            this.state = ma.State_Province__c;
            this.zip = ma.Zip_Code__r.Name;
            this.country = ma.Country__c;
        }
    }

    @HttpGET
    global static RESTpaymentAPI getAccount() {
         final RestRequest request = RestContext.request;
         List<Account> result =
             [SELECT id, Make_Checks_Payable_to__c,
                     BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
                     Website, Merchant_Permalink__c, TIN_Status__c,
                     Bank_Name__c, Routing_Number_enc__c, Account_Number__c,
                     Valid_Routing__c, Tax_ID__c,
                     // Merchant Adresses Relationship
                     (SELECT Id, Street_Line_1__c, Street_Line_2__c,
                             City__c, State_Province__c, Zip_Code__r.Name, Country__c
                        FROM Merchant_Addresses__r),
                     // Contacts Relationship
                     (SELECT id, FirstName, LastName, Title, Email, Phone
                        FROM Contacts),
                     // Payments fields
                     Current_Payments_Device__c, Number_of_Units_Payments__c, Payments_Activation_Date__c,
                     Payments_Active_Status__c, Payments_Close_Date_Formula__c, Payments_Eligible__c,
                     Payments_Handoff_Date__c, Payments_Handoff_Made_By__c, Payments_Interested__c,
                     Payments_Lead_Source__c, Payments_Manager__c, Payments_Product_Notes__c,
                     Payments_Product_Rejected_Reasons__c, Payments_Product_Sales_Status__c,
                     Payment_Manager_Total__c, Payment_Preference__c, Pitch_Payments_Product__c
               FROM Account
              WHERE id = :EncodingUtil.urlDecode(request.params.get('salesforce_id'),'UTF-8')];
         if (result.size() == 1) {
             return new RESTpaymentAPI(result[0]);
         } else {
            return null;
         }
    }

    @HttpPOST
    global static Account post(Account account){
        Database.SaveResult save_result = Database.update(account);
        RestResponse res = RestContext.Response;
        if (save_result.isSuccess()) {
             return account;
        } else {
            res.StatusCode=400;
            return null;
        }
    }

    static testMethod void paymentsGetAccountTest() {
        final Account testAccount = new Account(Name = 'Test Account', Make_Checks_Payable_to__c = 'Test',
           BillingStreet ='42nd Street', BillingCity = 'Nowhere', BillingState = 'NO',
           Merchant_Permalink__c = 'test', Bank_Name__c = 'First Bank', Routing_Number_enc__c = '001',
           Account_Number__c = '100', Valid_Routing__c = 'N/A', Tax_ID__c = '111',
           Payment_Preference__c = 'ACH (Direct Deposit)');
        insert testAccount;

        final Merchant_Addresses__c testAddress = new Merchant_Addresses__c(Street_Line_1__c = '2nd Ave.',
                Country__c = 'US', Account__c = testAccount.id);
        insert testAddress;

        final Contact testContact = new Contact(FirstName = 'First', LastName = 'Contact',
                Email = 'first@contact.com', AccountId = testAccount.id);
        insert testContact;

        final RestRequest request = new RestRequest();
        request.addParameter('salesforce_id', testAccount.id);
        RestContext.request = request;

        final RESTpaymentAPI expectedResult = expectedResult(testAccount,
                new Merchant_Addresses__c[] {testAddress}, new Contact[] {testContact});
        final RESTpaymentAPI result = RESTpaymentAPI.getAccount();
        verifyResult(expectedResult, result);
    }

    static testMethod void paymentsGetAccountInvalidIdTest() {
        final RestRequest request = new RestRequest();
        request.addParameter('salesforce_id', 'aaaaaaaaaaaaaaaaaa');
        RestContext.request = request;

        System.assertEquals(null, RESTpaymentAPI.getAccount());
    }

    private static RESTpaymentAPI expectedResult(Account testAccount,
            List<Merchant_Addresses__c> addresses,
            List<Contact> contacts) {
        RESTpaymentAPI result = new RESTpaymentAPI(testAccount);
        result.make_checks_payable_to = testAccount.Make_Checks_Payable_to__c;
        result.street = testAccount.BillingStreet;
        result.city = testAccount.BillingCity;
        result.state = testAccount.BillingState;
        result.permalink = testAccount.Merchant_Permalink__c;
        result.bank_name = testAccount.Bank_Name__c;
        result.bank_routing_number = testAccount.Routing_Number_enc__c;
        result.bank_account_number = testAccount.Account_Number__c;
        result.valid_routing = testAccount.Valid_Routing__c;
        result.business_tax_id = testAccount.Tax_ID__c;

        result.addresses = new List<Address>();
        for (Merchant_Addresses__c ma : addresses) {
            final Address a = new Address(ma);
            a.street_1 = ma.Street_Line_1__c;
            a.country = ma.Country__c;

            result.addresses.add(a);
        }

        result.contacts = contacts;

        return result;
    }

    private static void verifyResult(RESTpaymentAPI expected, RESTpaymentAPI actual) {
        System.assertEquals(expected.make_checks_payable_to, actual.make_checks_payable_to);
        System.assertEquals(expected.street, actual.street);
        System.assertEquals(expected.city, actual.city);
        System.assertEquals(expected.state, actual.state);
        System.assertEquals(expected.permalink, actual.permalink);

        System.assertEquals(expected.bank_name, actual.bank_name);
        System.assertEquals(expected.bank_routing_number, actual.bank_routing_number);
        System.assertEquals(expected.bank_account_number, actual.bank_account_number);
        System.assertEquals(expected.valid_routing, actual.valid_routing);
        System.assertEquals(expected.business_tax_id, actual.business_tax_id);

        System.assertEquals(expected.contacts.size(), actual.contacts.size());
        Integer i = 0;
        for (Contact expectedContact : expected.contacts) {
            System.assertEquals(expectedContact, actual.contacts[i]);
            i++;
        }

        System.assertEquals(expected.addresses.size(), actual.addresses.size());
        i = 0;
        for (Address expectedAddress : expected.addresses) {
            System.assertEquals(expectedAddress.street_1, actual.addresses[i].street_1);
            System.assertEquals(expectedAddress.country, actual.addresses[i].country);
            i++;
        }
    }
}