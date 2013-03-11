//
// This class is versioned: git clone github:sales-and-planning-tools/mocha-apex-endpoints
//

@isTest
public class GrouponTestUtil {

    public User createTestUser() {
            Profile profile = [select name from Profile limit 1];
            return createTestUser(profile.name);
        }

    public User createTestUser(String profileName) {
        return createTestUser(profileName, 'standarduser1@groupon.com');
    }

    public User createTestUser(String profileName, String username) {
        Profile p = [SELECT id FROM profile WHERE name = :profileName];
        User u = new User(
                Alias = 'standt',
                Email = 'standarduser@groupon.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocalesIdKey = 'en_US',
                ProfileId = p.Id,
                TimezonesIdKey = 'America/Los_Angeles',
                Username = username);
        return u;
    }

    public Task createCompletedTask(User owner, Date completedOn) {
        Account a = createAccount();
        insert a;

        Task task = new Task(OwnerId = owner.id, Completed_Date__c = completedOn, WhatId = a.id);
        return task;
    }


    public Division__c createDivision() {
        Division__c div = new Division__c(Name = 'Training', State__c = 'IL');
        return div;
    }

    public Subdivision__c createSubDiv() {
        Subdivision__c subdiv = new Subdivision__c(name = 'Chicago');
        return subdiv;
    }

    public Zip_Code__c createZipCode() {
        return new Zip_Code__c(Name = '60642');
    }

    public Zip_Code__c createZipCode(Division__c division, Subdivision__c subdivision) {
        Zip_Code__c zip = createZipCode();
        zip.Division__c = division.Id;
        if(subdivision != null){
            zip.Subdivision__c = subdivision.Id;
        }
        return zip;
    }

    public Lead createLead() {
        Lead lead = new Lead(
                Category_v3__c = 'Test1 | test2 | test3',
                Company = 'Company',
                LastName = 'Last',
                Merchant_Permalink__c = 'TESTPERMA');
        return lead;
    }

    public Account createAccount() {
        Account a = new Account(Name = 'Test Util Acct');
        a.category_v3__c = 'Test1 | test2 | test3';
        a.Merchant_Permalink__c = 'TESTPERMA';
        a.BillingStreet = '600 W Chicago Ave';
        a.BillingCity = 'Chicago';
        a.BillingState = 'IL';
        a.BillingPostalCode = '60654';
        a.BillingCountry = 'USA';
        return a;
    }

    public Contact createContact() {
        return new Contact(firstName = 'TestFirst', lastName=  'TestLast');
    }

    public Opportunity createDeal() {
        return createDeal(createAccount());
    }

    public Opportunity createDeal(Account account) {
        Opportunity o = new Opportunity();
        o.AccountId = account.Id;
        o.Name = 'Test Oppty Name';
        o.StageName = 'Prospecting';
        o.CloseDate = system.Today();
        o.Merchant_name_in_write_up__c = 'TEST hello'+system.today();
        return o;
    }

    public Task createTask(Opportunity deal) {
        return createTask('New Task', deal);
    }

    public Task createTask(String name) {
        return createTask(name, createDeal(), 'Not Started');
    }

    public Task createTask(String name, Opportunity deal) {
        return createTask(name, deal, 'Not Started');
    }

    public Task createTask(String name, String status) {
        return createTask(name, createDeal(), status);
    }

    public Task createTask(String name, Opportunity deal, String status) {
        Task task = new Task();
        task.Status = status;
        task.WhatId = deal.Id;
        task.Subject = name;
        return task;
    }

    public Multi_Deal__c createOption() {
        return createOption(createDeal());
    }

    public Multi_Deal__c createOption(Opportunity opp) {
        Multi_Deal__c md = new Multi_Deal__c();
        // md.Option_Services__c = 'Test1 | Test2 | Test3';
        md.opportunity__c = opp.Id;
        return md;
    }

    public Purchase_Order__c createPO() {
        Division__c trainingDiv = createDivision();
        insert trainingDiv;
        subdivision__c subdiv = createsubdiv();
        insert subdiv;
        Purchase_Order__c testPO = new Purchase_Order__c(
                Target_Feature_Date__c = system.Today()+7,
                Global_SFDC_Category__c = 'test',
                Global_SFDC_Subcategory_1__c = 'Test',
                Global_SFDC_Subcategory_2__c = 'Test',
                Category_v3__c = 'test',
                Subcategory_v3__c = 'Test',
                //  Services__c  = 'test1 | test2',
                Ideal_price_range__c = 'Test',
                Rep_po_notes__c = 'some text',
                Example_deal_1__c = 'somedeal',
                Example_deal_2__c = 'Somedeal',
                Po_notes__c = 'some text',
                Deal_Builder_Template__c = 'some dealbuilder',
                Target_GP__c = 123,
                Target_Revenue__c = 123,
                Merchant_Attributes__c = 'test1 | test2',
                Latitude__c = 123,
                Longitude__c = 321);
        return testPO;
    }

    public Assignedto__c createAssignedTo() {
        Purchase_order__c testpo = createPO();
        insert testpo;

        User testUser = createTestUser('standard user', 'standardusertest456@groupon.com');
        insert testUser;
        Assignedto__c assign = new Assignedto__c(
                Purchase_order__c = testpo.Id,
                Assigned_to__c = testUser.id);
        return assign;
    }

    public Taxonomy_Support__c txnmySupportTest() {
        Taxonomy_Support__c testTS = new Taxonomy_Support__c();
        return testTS;
    }

    public TaxonmyMap__c createTaxonomyMap() {
        TaxonmyMap__c taxonomyMapRecord = new TaxonmyMap__c();
        return taxonomyMapRecord;
    }

    public Merchant_Addresses__c createMerchantAddress() {
        return new Merchant_Addresses__c (Country__c = 'US', Zip_Postal_Code__c = '65738');
    }

    public Reviews__c createReview() {
       return new Reviews__c (Type__c = 'Rating', Source__c = 'Yelp', Location_Lead_Review__c = true);
    }

    public Sales_Goal__c createSalesGoal(decimal grossBillingGoal, user u, division__c div){
        Sales_Goal__c SG = new Sales_Goal__c();
        sg.ownerid = u.id;
        sg.division__c = div.id;
        sg.Gross_Billings_Goal__c = grossBillingGoal;
        sg.Goal_Start_Date__c = system.today().toStartOfMonth();
        sg.Goal_End_Date__c = system.today().toStartOfMonth().addDays(32).toStartOfMonth().addDays(-1);
        return sg;
    }

    public PayoutTable__c getPayoutTable(){
        return getPayoutTable(0,.6,.005,.005,.005,0,false);
    }

    public PayoutTable__c getPayoutTable(Decimal min, Decimal max, Decimal newDeal, Decimal refeature, Decimal outOfMarket, Decimal kicker, Boolean Hightarget){
        PayoutTable__c pt = new PayoutTable__c();
        pt.MinTarget__c = min;
        pt.MaxTarget__c = max;
        pt.New_Deals__c = newDeal;
        pt.Out_Of_Market__c = refeature;
        pt.ReFeature__c = outOfMarket;
        pt.PercentToGoalKicker__c  = kicker;
        if(highTarget)pt.Target__c = 'Over';
        if(!highTarget)pt.Target__c = 'Under';
        return pt;
    }

    public Financial_Records__c createFinancialRecord() {
        return createFinancialRecord(createDeal());
    }

    public Financial_Records__c createFinancialRecord(Opportunity deal) {
        Financial_Records__c record = new Financial_Records__c();
        record.Opportunity__c = deal.Id;
        return record;
    }

    public Financial_Records__c createFinancialRecord(Opportunity deal, Decimal GrossProfit, Decimal GrossBillings, Decimal Refunds) {
        Financial_Records__c record = new Financial_Records__c();
        record.Opportunity__c = deal.Id;
        record.Collection_Date__c = system.today();
        record.Gross_Profit_Salesforce__c = GrossProfit;
        record.Refunds_for_Commission__c = Refunds;
        record.Gross_Billings__c = GrossBillings;
        record.GB_Net_Discounts__c = GrossBillings;
        return record;
    }

    public Address__c createRedemptionAddress(){
                Address__c  addy = new address__c();
                addy.Street_Line_1__c = '600 W Chicago';
                addy.Street_Line_2__c = '';
                addy.City__c = 'Chicago';
                addy.State__c ='IL';
                addy.Zip_Postal_code__c = '60654';
                addy.Country__c = 'US';
                return addy;
    }

}