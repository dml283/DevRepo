public with sharing class TestUtil {
    
    public static Set <Id> createAccountsMany(Integer inte){   
        Set <Id> acctIds = new Set <Id>();     
        for(Integer i = 0;i<inte;i++){
            Account a = new Account();
            a.Name = 'Test Acct' + i; 
            acctIds.add(a.Id);
        }          
        return acctIds;
     }
     
     public static List <Account> createAccountsList(Integer inte){     
        List <Account> accts = new List<Account>();
        for(Integer i = 0;i<inte;i++){
            Account a = new Account();
            a.Name = 'Test Acct' + i; 
            accts.add(a);
        }
        insert accts;
        return accts; 
     }
     
    public static Account createAccount(String name, Boolean doInsert)
    {
        Account a = new Account(Name = name);
        if(doInsert) insert a;
        
        return a;       
    }
     
    public static Opportunity createOpptywAcctDivStrengthStage(Account a, Division__c div, String d, String s){
        Opportunity o = new Opportunity();
        o.name = 'test oppty';
        o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
        o.division__c = 'Test';
        o.Division_Dynamic__c = div.id;
        o.Deal_strengh__c = d;
        o.AccountId = a.id;
        o.StageName = s;
        o.CloseDate = System.today();
        o.Category__c = 'Health & Beauty';
        o.city_manager__c = null;
        o.divisional_sales_manager__c = NULL;
        o.user__c = NULL;
        o.Feature_Date_Change_Date__c = System.today().addDays(30);
        o.Feature_End_Date__c = System.today().addDays(30);
        o.GrouponLite_Monthly_Cap__c = 1.0;
        insert o;
        return o;
    }
    
    public static Opportunity createOpptyWacct(){
        Opportunity o = new Opportunity(
                Name = 'TEST' + System.currentTimeMillis(), 
                CloseDate = System.today().addDays(30),
                StageName = 'stage',
                Amount = 0,
                Type = 'test' );
        
        o.AccountId = createAccount('TA' + System.currentTimeMillis() ).Id; 
        insert o;
        return o;
    }

    public static Opportunity createOppty(String categoryId, String subcategory) {
        Opportunity o = new Opportunity(Name = 'TEST' + System.currentTimeMillis(), Subcategory__c = subcategory, StageName = 'Contract Sent', CloseDate = System.today().addDays(30),Category__c=categoryId);
        o.AccountId = createAccount('TA' + System.currentTimeMillis()).Id;
        insert o;
        return o;   
    }
    
    public static Opportunity createOpptyWithCat(String categoryId, String subcategory, Id catID) {
        Opportunity o = new Opportunity(Name = 'TEST' + System.currentTimeMillis(), Subcategory__c = subcategory, StageName = 'Contract Sent', CloseDate = System.today().addDays(30), Category__c=categoryId);
        o.AccountId = createAccount('TA' + System.currentTimeMillis()).Id;
        insert o;
        return o;   
    }
    
    public static Opportunity createOpportunity(Account acct, String name, String stage, Date closedDate, Boolean doInsert)
    {
        Opportunity oppty = new Opportunity();
        oppty.AccountID = acct.ID;
        oppty.Name = name;
        oppty.StageName = stage;
        oppty.CloseDate = closedDate;
        
        if(doInsert) insert oppty;
        
        return oppty;
    }
    
    public static Division__c createDivision() {
        Division__c div = new Division__c(Name = 'Training', State__c = 'IL');
        return div;
    }

    public static Subdivision__c createSubDiv() {
        Subdivision__c subdiv = new Subdivision__c(name = 'Chicago');
        return subdiv;
    }
    
    public static Category__c createCategory(String name, Boolean isSubCategory) {
        Category__c c = new Category__c(Name = name, Subcategory__c = (isSubCategory ? 'Yes' : 'No'));
        insert c;
        return c;
    }
    
    public static Question_Category__c createQuestionCategory(Id categoryId, Id questionBankId) {
        Question_Category__c qc = new Question_Category__c(Category__c = categoryId, Question_Bank__c = questionBankId);
        insert qc;
        return qc;
    }
    
    public static Question_Bank__c createQuestionBank(String name, Boolean required, String dataType, String picklistOptions, String helpText) {
        Question_Bank__c qb = new Question_Bank__c(Required__c = required, Data_Type__c = dataType, Picklist_Options__c = picklistOptions, Help_Text__c = helpText);
        insert qb;
        return qb;
    }
    
    public static Account createAccount(String name) {
        Account a = new Account(Name = name + system.now());
        insert a;
        return a;
    }
    
    public static Address__c createAddress(Id acctId, Id oppId, String street1, String state, String zip, String city, String country) {
        Address__c a = new Address__c(Opportunity__c = oppId, Account__c = acctId, Street_Line_1__c = street1, State__c = state,
                                      Zip_Postal_Code__c = zip, City__c = city, Country__c = country);
        insert a;
        return a;
    }
    
    public static Address__c createOpptyAddress(Opportunity o){ 
        Address__c addy = new Address__c();
        addy.opportunity__c = o.id;
        addy.street_line_1__c = 'some street';
        addy.city__c = 'city';
        addy.state__c ='ST';
        insert addy;
        return addy;
    }
    
    public static Merchant_Addresses__c createMerchantAddress(Account a){
        
        return createMerchantAddress(a, true);
    }
    
    public static Merchant_Addresses__c createMerchantAddress(Account a, Boolean doInsert){
        Merchant_Addresses__c ma = new Merchant_Addresses__c();
        ma.account__c = a.id;
        ma.Street_Line_1__c = '123 fake st';
        ma.city__c = 'Chicago';
        ma.State_Province__c = 'IL';
        ma.Zip_Postal_Code__c = '60654';
        
        if(doInsert) insert ma;
        
        return ma;
    }
    
    public static List <Merchant_Addresses__c> createMerchantAddressMany(Account a, Integer inte){      
        List <Merchant_Addresses__c> merchAddys = new List <Merchant_Addresses__c>();
        for(Integer i =0; i< inte; i++){
            Merchant_Addresses__c ma = new Merchant_Addresses__c();
            ma.account__c = a.id;
            ma.Street_Line_1__c = '123 fake st' + inte + 1;
            ma.city__c = 'Chicago';
            ma.State_Province__c = 'IL';
            ma.Zip_Postal_Code__c = '60654';
            merchAddys.add(ma);
        }       
        insert merchAddys;
        return merchAddys; 
    }
    
    public static List <Merchant_Addresses__c> createMerchantAddressManyWaccts(List <Account> accts, Integer inte){     
        List <Merchant_Addresses__c> merchAddys = new List <Merchant_Addresses__c>();
        for(Account a: accts){
            Merchant_Addresses__c ma = new Merchant_Addresses__c();
            ma.account__c = a.id;
            ma.Street_Line_1__c = '123 fake st' + inte + 1;
            ma.city__c = 'Chicago';
            ma.State_Province__c = 'IL';
            ma.Zip_Postal_Code__c = '60654';
            merchAddys.add(ma);
        }       
        insert merchAddys;
        return merchAddys; 
    }
    
    public static User createUser(String p){        
        Profile pr = [select id from profile where name=: p];
        User u = new User(alias = 'standt', email='standarduser@groupon.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = pr.Id,timezonesidkey='America/Los_Angeles', username='testemail1@groupon.com');
        insert u;
        return u;
    }
    
    public static User createUser2(String p){       
        Profile pr = [select id from profile where name=: p];
        User u = new User(alias = 'standt', email='standarduser2@groupon.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = pr.Id,timezonesidkey='America/Los_Angeles', username='testemail2@groupon.com');
        insert u;
        return u;
    }
    
    public static User createUserWithUsername(String p, String email, String userName){     
        Profile pr = [select id from profile where name=: p];
        User u = new User(alias = 'standt', email= email,emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = pr.Id,timezonesidkey='America/Los_Angeles', username=userName);
        insert u;
        return u;
    }
    
    public static Multi_deal__c createMD(Opportunity o){
        Multi_deal__c md = new Multi_deal__c();
        md.opportunity__c = o.id; 
        insert md;
        return md;
    }

     public static Lead createLead() {
        Lead lead = new Lead(
        Category_v3__c = 'Test1 | test2 | test3',
        Company = 'Company',
        LastName = 'Last',
        Merchant_Permalink__c = 'TESTPERMA');
        return lead;
    }
    
    public static Contact createContact() {
        return new Contact(firstName = 'TestFirst', lastName=  'TestLast');
    }
    
    public static List<Contact> createContactList(Integer inte) {
        List<Contact>contacts = new List<Contact>();
        for(Integer i=0;i<inte; i++){
            contacts.add(new Contact(firstName = 'TestFirst', lastName=  'TestLast'));
        }
        insert contacts;
        return contacts;
    }
    
    public static Account createAccount() {
        Account a = new Account(Name = 'Test Util Acct');
        a.category_v3__c = 'Test1 | test2 | test3';
        a.Merchant_Permalink__c = 'TESTPERMA';
        a.BillingStreet = '600 W Chicago Ave';
        a.BillingCity = 'Chicago';
        a.BillingState = 'IL';
        a.BillingPostalCode = '60654';
        a.BillingCountry = 'US';
        return a;
    }

    public static Opportunity createDeal() {
        return createDeal(createAccount());
    }

    public static Opportunity createDeal(Account account) {
        Opportunity o = new Opportunity();
        o.AccountId = account.Id;
        o.Name = 'Test Oppty Name';
        o.StageName = 'Prospecting';
        o.CloseDate = system.Today();
        o.Merchant_name_in_write_up__c = 'TEST hello'+system.today();
        return o;
    }

    public static Task createTask(Opportunity deal) {
        return createTask('New Task', deal);
    }

    public static Task createTask(String name) {
        return createTask(name, createDeal(), 'Not Started');
    }

    public static Task createTask(String name, Opportunity deal) {
        return createTask(name, deal, 'Not Started');
    }

    public static Task createTask(String name, String status) {
        return createTask(name, createDeal(), status);
    }
    
    public static Task createTask(String status, Date dueDate, Id whatId) {
        Task t = new Task();
        t.Status = status;
        t.ActivityDate = dueDate;
        t.WhatId = whatId;
        insert t;
        return t;
    }
     
    public static List <Task> createTasksCompleted(List<Account>accts, Integer inte) {        
        List <Task> tasks = new List<Task>();
        for(Integer i = 0;i<inte;i++){
            for(Account a: accts){
                Task t = new Task();
                t.WhatId = a.Id;
                t.status = 'Completed';
                tasks.add(t);
            }
        }
        insert tasks;
        return tasks;
    }
    
    public static List <Task> createTasksOpen(List<Account>accts, Integer inte) {        
        List <Task> tasks = new List<Task>();
        for(Integer i = 0;i<inte;i++){
            for(Account a: accts){
                Task t = new Task();
                t.WhatId = a.Id;
                t.status = 'Not Started';
                tasks.add(t);
            }
        }
        insert tasks;
        return tasks;
    }
    
    public static Task createTask(String name, Opportunity deal, String status) {
        Task task = new Task();
        task.Status = status;
        task.WhatId = deal.Id;
        task.Subject = name;
        return task;
    }

    public static Multi_Deal__c createOption() {
        return createOption(createDeal());
    }

    public static Multi_Deal__c createOption(Opportunity opp) {
        Multi_Deal__c md = new Multi_Deal__c();
        // md.Option_Services__c = 'Test1 | Test2 | Test3';
        md.opportunity__c = opp.Id;
        return md;
    }
    
    public static List <Opportunity> createOpptsList(List<Account>accts, Integer inte) { 
        List <Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0;i<inte;i++){
            for(Account a: accts){
                opps.add(createOpptywAcctDivStrengthStage(a, createDivision(), 'Rep Getting Info', 'Prospecting'));
            }
        }
     insert opps;
     return opps;
    }
    
    public static Event createEvent(String whatID, String whoID, String subject, Boolean doInsert)
    {
        Event evt = new Event();
        evt.WhatId = whatID;
        evt.WhoId = whoID;
        evt.Subject = subject;
        evt.DurationInMinutes = 60;
        
        if(doInsert) insert evt;
        
        return evt;
    }
    
    public static Quantum_Lead__c createQuantumLead(Account acct, Boolean doInsert)
    {
        Quantum_Lead__c ql = new Quantum_Lead__c();
        ql.Account__c = acct.ID;
        ql.Parent_Id__c = acct.ID;
        ql.Call_List_Priority__c = '1';
        ql.Sales_Value__c = 200;
        
        if(doInsert) insert ql;
        
        return ql;
    }
    
    public static Quantum_Lead__c createQuantumLead(Account a, Decimal salesVal, String rank){      
        Quantum_Lead__c q = new Quantum_Lead__c();
        q.Account__c = a.Id;
        q.Parent_Id__c = 'test';
        q.Sales_Value__c = salesVal;
        q.Call_List_Priority__c = rank;
        insert q;
        return q;
    }
    
   public static void checkForUnitTestExecution()
    {
        if(!Test.isRunningTest())
            throw new TestException(Constants.ONLY_AVAILABLE_FOR_UNIT_TEST_EXCEPTION_MSG);
    }
    
   public static Multi_Deal__c createMDwithSku(Opportunity o, String s){
        Multi_deal__c md = new Multi_deal__c();
        md.opportunity__c = o.id; 
        md.Product_SKU__c = s;
        md.GrouponLite_Monthly_Cap__c = 5;
        md.Unit_Sell_Price__c = 15;
        md.Total_Deal_Max__c = 10;
        md.Alternative_Expiration_Date__c = System.today() + 15;
        md.Expiration_Type__c = 'Relative to feature';
        md.Refund_No_Return_Required__c = false;
        md.Event_Start_Time__c = '12:00pm';
        md.Event_Start_Date__c = System.today() +1;
        md.Event_End_Date__c = System.today() + 15; 
        md.Unit_Value__c = 15;
        return md;
    }
    
   public static List <QL_SalesVal__c> createSalesVals(Quantum_Lead__c q ){
        Integer[] valInts = new Integer[]{100, 200, 300};
        List <QL_SalesVal__c> vals = new List <QL_SalesVal__c>();
            
        vals.add(
        new QL_SalesVal__c (
        Date__c = System.today()-40,
        Quantum_Lead__c = q.Id,
        Value__c = valInts.get(0) //1
        ));
        
        vals.add(
        new QL_SalesVal__c (
        Date__c = System.today()-40,
        Quantum_Lead__c = q.Id,
        Value__c = valInts.get(1) //2
        ));
        
        vals.add(
        new QL_SalesVal__c (
        Date__c = System.today()-40,
        Quantum_Lead__c = q.Id,
        Value__c = valInts.get(2) //3
        ));
        
        insert vals;
        return vals;    
   }
   
   public static List <QL_RankVal__c> createRanks(Quantum_Lead__c q ){
        Integer[] rankInts = new Integer[]{1, 2, 3};
        List <QL_RankVal__c> ranks = new List <QL_RankVal__c>();
            
        ranks.add(
        new QL_RankVal__c (
        Date__c = System.today()-40,
        Quantum_Lead__c = q.Id,
        Value__c = rankInts.get(0) //1
        ));
        
        ranks.add(
        new QL_RankVal__c (
        Date__c = System.today()-40,
        Quantum_Lead__c = q.Id,
        Value__c = rankInts.get(1) //2
        ));
        
        ranks.add(
        new QL_RankVal__c (
        Date__c = System.today()-40,
        Quantum_Lead__c = q.Id,
        Value__c = rankInts.get(2) //3
        ));
        
        insert ranks;
        return ranks;
   }
    /*
    public static List <MessageBusLog__c> createMessageBusLogs(String result, Set <Id> ids, String objectType, String action){
        List <MessageBusLog__c> logs = new List <MessageBusLog__c>();    
         for(Id i: ids){
            logs.add(new MessageBusLog__c(
                Id__c = '\'' + i + '\'',
                SFObject__c = objectType,
                action__c = action,
                result__c = result 
                ));
         }        
         insert logs;
         return logs;
    }

    
    public static ZenDesk_Quantum_Lead__c createZenDeskQuantumLead(String reason, boolean doInsert)
    {
        ZenDesk_Quantum_Lead__c zdql = new ZenDesk_Quantum_Lead__c();
        zdql.Name = 'name1';
        zdql.Quantum_Lead_Flag_Reason__c = reason;
        
        if(doInsert) insert zdql;
        
        return zdql;
    }
    
    public static ZenDesk_Instances__c createZenDeskInstance(String name, String endPoint, String userName, String password, Boolean doInsert)
    {
        ZenDesk_Instances__c zdi = new ZenDesk_Instances__c();
        zdi.name = name;
        zdi.EndPoint__c = endPoint;
        zdi.UserName__c = userName;
        zdi.Password__c = password;
        
        if(doInsert) insert zdi;
        
        return zdi;
    }
    */
    public static User getTestUser(String userName, String profileName)
    {
        String profileId;
        try
        {
            profileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id;
        }
        catch(Exception ex)
        {
            System.debug(ex);
            System.assert(false, 'No profile exists with name'+ profileName);
        }
        User testUser = new User();
        testUser.LastName = 'test ' + UserName;
        testUser.Alias = UserName;  
        testUser.Email = UserName+'@test.com';
        testUser.Username = UserName+UserName+'@groupon.com';
        testUser.CommunityNickname = 'a'+UserName;
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.ProfileId = profileId;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.IsActive = true;
        
        return testUser;    
    }
    
    public static User createInsideSalesUser(String userName, Boolean doInsert)
    {
        User u = getTestUser(userName, 'Iniside Sales/DSM');
        
        if(doInsert) insert u;
        
        return u;
    }
    
    public static User getSystemAdminUser(String userName, Boolean doInsert)
    {
        User u = getTestUser(userName, 'System Administrator');
        
        if(doInsert) insert u;
        
        return u;
    }
    
    public static Zip_Code__c createZipCode(String zipCodeName, Boolean doInsert)
    {
        Zip_Code__c zc1 = new Zip_Code__c(Name = zipCodeName);
        if(doInsert) insert zc1;
        
        return zc1;
    }
    
    
    public static TaxonmyMap__c createTaxonmyMap(String obj, String primarySrvc, String catV3, String subCatV3, String oldCat, String oldSubCat, String newCat, String newSubCat, String newSubCat1, Boolean doInsert)
    {
        TaxonmyMap__c tm = new TaxonmyMap__c();
        tm.Object__c = obj;
        tm.Primary_Service__c = primarySrvc;
        tm.Category_v3__c = catV3;
        tm.Subcategory_v3__c = subCatV3;
        tm.oldCategory__c = oldCat;
        tm.oldSubcategory__c = oldSubCat;
        tm.newCategory__c = newCat;
        tm.newSubcategory__c = newSubCat;
        tm.newSubcategory1__c = newSubCat1;
        
        if(doInsert) insert tm;
        
        return tm;
    }
    
     public static Reviews__c createReview(Account a, Merchant_Addresses__c m)
    {
        Reviews__c r = new Reviews__c();             
         r.Account__c = a.id;                   
         r.Merchant_Address__c = m.id;
         r.Description__c = 'Test Description';
         r.Max_Possible_Rating__c = 10;
         r.Number_of_Ratings__c = 100;                                      
         r.Rating__c = 9;
         r.Source__c = 'Google';
         r.Type__c = 'Rating';
         r.Unit__c = 'Stars';
         r.Review_Link__c = 'www.google.com';
         r.of_1_star_Reviews__c = 1;
         r.of_2_star_Reviews__c = 2;
         r.of_3_star_Reviews__c = 3;
         r.of_4_star_Reviews__c = 4;
         r.of_5_star_Reviews__c = 5;
         r.of_Complaints__c = 0;
         r.BBB_Accredited__c = 'Yes';
         r.BBB_Grade__c = 'A';
         r.Quote__c = 'Quote';
         r.Quote_Attribution__c = 'Quote Attribution';
         r.Mixed_Lede__c = 'Test';
         insert r; 
         return r;         
    }
    
    public static Deal_Reviews__c createDealReview(Reviews__c r)
    {
        Deal_Reviews__c d = new Deal_Reviews__c();
        d.Merchant_Review__c = r.Id;
        insert d;
        return d;
    }
    
    //Koss Additions - 2/26/2013
    public static GrouponNow__c createGrouponNow(Account a, Division__c d)
    {
        GrouponNow__c g = new GrouponNow__c();
        g.Account_Name__c = a.Id;
        g.Division__c = d.Id;
        g.Buy_Price__c = 5;
        g.Sell_Price__c = 10;
        g.Unit_Value__c = 15;
        g.Now_Category__c = 'Food & Drink';
        g.Now_Subcategory__c = 'Bagel Shops';
        g.Deal_Name__c = 'Test Deal';
        g.Fine_Print__c = 'Fine Print';
        g.Deal_Strength__c = 'A Sure Thing';
        g.Limit_Per_Person__c = '1';
        g.Per__c = 'Visit';
        g.Limit_number_of_Groupons_redeemable_at_a__c = 1;
        insert g;
        return g;
    }

    public static Now_Redemption_Address__c createNowAddress(GrouponNow__c g)
    {
        Now_Redemption_Address__c nra = new Now_Redemption_Address__c();
        nra.Groupon_Now__c = g.Id;
        nra.Address_Line_1__c = '600 W. chicago Ave.';
        nra.City__c = 'Chicago';
        nra.State__c = 'IL';
        nra.Zip_Code__c = '60654';
        nra.Country__c = 'US';
        insert nra;
        return nra;
    }
        
    public static NOW_Schedule__c createNowSchedule(GrouponNow__c g)
    {
        NOW_Schedule__c ns = new NOW_Schedule__c();
        ns.Groupon_Now__c = g.Id;
        ns.Daily_Unit_Max_for_this_Schedule__c = 10;
        ns.NOW_Start_Date__c = system.today();
        ns.NOW_End_Date__c = system.today();
        ns.Start_Time__c = '8:00 AM';
        ns.Start_Time__c = '12:00 PM';
        insert ns;
        return ns;
    }
    
    //ss addition 2/28
    public static Planning__c createPlanning(Opportunity o, Division__c d, Boolean isActive)
    {
        Planning__c p = new Planning__c();
        p.Start_Date__c = System.today();
        p.Priority__c = 'test';
        p.Position__c = 'test';
        p.Opportunity__c = o.Id;
        //p.IsActive__c = isActive;
        p.End_Date__c = System.today() + 10;
        //p.Editorial_Complete__c = 'test';
        p.Division__c = d.Id;
        //p.Account_Management_Ready__c =  'test';
        insert p;
        return p;       
    }
    
    public static Case createCase(boolean doInsert,boolean isGlobal){
   	
	   	Account a=createAccount();
	   	insert a;
	   	Case c=new Case();
	   	c.Account_Owner__c=a.OwnerId;
	   	c.AccountId=a.id;
	   	c.Case_Raised_by__c='Merchant';
	   	c.Status='Pending';
	   	c.Least_recent_Deal_Start__c=date.today();
	   	c.Latest_Deal_Validity_End__c=date.today();
	   	c.Escalation_is_related_to__c='One deal';
	   	if(isGlobal){
	   		c.Escalation_Status_Account__c='burned Account';
	   		c.Locking_Reason_Account__c='A1 - Merchant not contactable';
	   		c.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Global Escalation Cases').getRecordTypeId();
	   	}
	   	if(doInsert){
	   		insert c;
	   	}
	   	return c; 	
   }
}