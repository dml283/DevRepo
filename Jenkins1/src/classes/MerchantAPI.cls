global class MerchantAPI {

    global MerchantAPI(string theId) {}
    global MerchantAPI() {}

    global static MerchantAPI.Merchant getMerchant(string theId){
        return new Merchant(theId);
    }

    global static List<Merchant> getMyMerchants() {
        List<Merchant> merchants = new List<Merchant>();

        for (Account a : MerchantAPI.getAccountsForUser()) {
            merchants.add(new Merchant(a));
        }

        for (Lead l : MerchantAPI.getLeadsForUser()) {
            merchants.add(new Merchant(l));
        }

        return merchants;
    }

    static List<Account> getAccountsForUser() {
        return [
            SELECT
                Id,
                Account_Manager__r.Name,
                Account_Status__c,
                Category_v3__c,
                Do_Not_Run_Again__c,
                Global_SFDC_Category__c,
                Global_SFDC_Subcategory_1__c,
                Global_SFDC_Subcategory_2__c,
                Groupon_Scheduler_Strength__c,
                LastActivityDate,
                M3_id__c,
                Merchant_Attributes__c,
                Merchant_permalink__c,
                Most_Recent_Feature__c,
                Name,
                Now_Launch__c,
                Number_of_Features__c,
                Research_Ranking__c,
                Result_of_Merchant_Survey__c,
                Services_Offered__c,
                Subcategory_v3__c,
                Subdivision__c,
                Total_GP__c,
                Total_Refund__c
            FROM Account
            WHERE Ownerid = :UserInfo.getUserId()
            ORDER BY Research_Ranking__c DESC
        ];
    }

    static List<Lead> getLeadsForUser() {
        return [
            SELECT
                Id,
                Category_v3__c,
                Company,
                Global_SFDC_Category__c,
                Global_SFDC_Subcategory_1__c,
                Global_SFDC_Subcategory_2__c,
                LastActivityDate,
                M3_Id__c,
                Merchant_Attributes__c,
                Research_Ranking__c,
                Services_Offered__c,
                Subcategory_v3__c,
                Subdivision_Dynamic__c
            FROM Lead
            WHERE
                Ownerid = :UserInfo.getUserId()
            AND
                IsConverted = false
            ORDER BY Research_Ranking__c DESC
        ];
    }

    global class Merchant{
        public Id          account_id            { get; set; }
        public Id          owner_id              { get; set; }
        public Date        last_contacted        { get; set; }
        public Decimal     account_gp            { get; set; }
        public Decimal     ePPM                  { get; set; }
        public Decimal     m3_id                 { get; set; }
        public Decimal     num_deals             { get; set; }
        public Decimal     refund_percent        { get; set; }
        public Division    division              { get; set; }
        public List<Deal>  deals                 { get; set; }
        public List<Place> places                { get; set; }
        public String      g1_status             { get; set; }
        public String      last_activity         { get; set; }
        public String      last_feature          { get; set; }
        public String      merchant_manager      { get; set; }
        public String      merchant_permalink    { get; set; }
        public String      merchant_satisfaction { get; set; }
        public String      name                  { get; set; }
        public String      now_status            { get; set; }
        public String      research_ranking      { get; set; }
        public String      scheduler_status      { get; set; }
        public String      status                { get; set; }
        public String      statusDetails         { get; set; }
        public String      subdivision           { get; set; }
        public String      website               { get; set; }
        public Taxonomy    taxonomy              { get; set; }

        global Merchant(Lead l){
            if (l.LastActivityDate != null) {
                this.last_activity = l.LastActivityDate.format();
            }
            this.account_gp = 0;
            this.account_id = l.id;
            this.last_feature  = '-';
            this.m3_id = l.M3_Id__c;
            this.name = l.Company;
            this.num_deals = 0;
            this.refund_percent = 0;
            this.research_ranking = l.Research_Ranking__c;
            this.taxonomy = new taxonomy(l);
        }

        global Merchant(Account a){
            if (a.Do_Not_Run_Again__c == true) {
                this.g1_status = 'badge-danger';
            }

            if (a.Groupon_Scheduler_Strength__c == 'Active') {
                this.scheduler_status = 'badge-success';
            }

            if (a.LastActivityDate != null) {
                this.last_activity = a.LastActivityDate.format();
            }

            if (a.Most_Recent_Feature__c!=null) {
                this.last_feature = a.Most_Recent_Feature__c.format();
            }

            if (a.Now_Launch__c != null) {
                this.now_status = 'badge-success';
            }

            if (a.Total_GP__c > 0 && a.Do_Not_Run_Again__c != true) {
                this.g1_status = 'badge-success';
            }

            this.account_gp = a.Total_GP__c;
            this.account_id = a.Id;
            this.m3_id = a.M3_Id__c;
            this.merchant_manager = a.Account_Manager__r.name;
            this.merchant_permalink = a.Merchant_Permalink__c;
            this.name = a.Name;
            this.num_deals = a.Number_of_Features__c;
            this.refund_percent = a.Total_Refund__c;
            this.research_ranking = a.Research_Ranking__c;
            this.status = a.Result_of_Merchant_Survey__c;
            this.statusDetails = a.Account_Status__c;
            this.taxonomy = new Taxonomy(a);
        }

        global Merchant(String theId){
            if (theId.substring(0,3) == '00Q') {
                Lead l = this.getLeadById(theId);

                this.account_id = l.Id;
                this.deals = new List<Deal>();
                this.division = this.getDivisionById(l.Dynamic_Division__c);
                this.last_contacted = l.LastActivityDate;
                this.m3_id = l.M3_Id__c;
                this.name = l.Company;
                this.research_ranking = l.Research_Ranking__c;
                this.subdivision = l.Subdivision_Dynamic__r.Name;
                this.taxonomy = new Taxonomy(l);

                this.places = new List<Place>();
                this.places.add(new Place(l));
            }

            if (theId.substring(0,3) == '001') {
                Account a;

                try {
                    a = this.getAccountById(theId);
                }
                catch (Exception ex) {
                    System.debug('Error retrieving Account in MerchantAPI');
                    System.debug(ex.getMessage());
                }

                if (a == null) return;
                this.owner_id = a.ownerid;
                this.account_id = a.id;
                this.deals = this.getDealsForAccount(a);
                this.division = this.getDivisionById(a.Division__c);
                this.last_contacted = this.getLastActivityDateForAccount(a);
                this.m3_id = a.M3_Id__c;
                this.merchant_permalink = a.Merchant_Permalink__c;
                this.name = a.name;
                this.places = this.getPlacesForAccount(a);
                this.research_ranking = a.Research_Ranking__c;
                this.subdivision = a.Subdivision__c;
                this.taxonomy = new Taxonomy(a);
                this.website = a.Website;
            }
        }

        Lead getLeadById(String id) {
            Lead[] lead = [
                SELECT
                    Id,
                    Category__c,
                    Category_v3__c,
                    City,
                    Company,
                    Dynamic_Division__c,
                    Global_SFDC_Category__c,
                    Global_SFDC_Subcategory_1__c,
                    Global_SFDC_Subcategory_2__c,
                    LastActivityDate,
                    Latitude__c,
                    Longitude__c,
                    M3_Id__c,
                    Merchant_Attributes__c,
                    Name,
                    Postalcode,
                    Research_Ranking__c,
                    Services_Offered__c,
                    State,
                    Street,
                    Subcategory__c,
                    Subcategory_v3__c,
                    Subdivision_Dynamic__r.Name,
                    Website
                FROM Lead
                WHERE Id = :id
                LIMIT 1
            ];

            if (lead.size() == 0) {
                return null;
            } else {
                return lead[0];
            }
        }

        Account getAccountById(String id) {
            Account[] account = [
                SELECT
                    Id,
                    ownerid,
                    Category_v3__c,
                    Division__c,
                    Global_SFDC_Category__c,
                    Global_SFDC_Subcategory_1__c,
                    Global_SFDC_Subcategory_2__c,
                    M3_Id__c,
                    Merchant_Attributes__c,
                    Merchant_Permalink__c,
                    Name,
                    Research_Ranking__c,
                    Services_Offered__c,
                    Subcategory_v3__c,
                    Subdivision__c,
                    Website
                FROM Account
                WHERE Id = :id
                LIMIT 1
            ];

            if (account.size() == 0) {
                return null;
            } else {
                return account[0];
            }
        }

        Division getDivisionById(Id id) {
            Division__c[] division = [
                SELECT
                    Id,
                    Name
                FROM Division__c
                WHERE Id = :id
                LIMIT 1
            ];

            if (division.size() == 0) {
                return null;
            } else {
                return new Division(division[0]);
            }
        }

        Date getLastActivityDateForAccount(Account account) {
            Task[] task = [
                SELECT
                    Id,
                    ActivityDate
                FROM Task
                WHERE AccountId = :account.id
                ORDER BY ActivityDate DESC
                LIMIT 1
            ];

            if (task.size() == 0) {
                return null;
            } else {
                return task[0].ActivityDate;
            }
        }

        List<Deal> getDealsForAccount(Account account) {
            List<Opportunity> opportunities = [
                SELECT
                    Id,
                    Deal_Strengh__c,
                    Division__c,
                    Feature_date__c,
                    Feature_end_date__c,
                    Global_SFDC_Category__c,
                    Global_SFDC_Subcategory_1__c,
                    Global_SFDC_Subcategory_2__c,
                    Name,
                    Overall_Satisfaction__c,
                    StageName
                FROM Opportunity
                WHERE AccountId = :account.Id
            ];

            List<Deal> deals = new List<Deal>();
            for (Opportunity o : opportunities) {
                deals.add(new deal(o));
            }
            return deals;
        }

        List<Place> getPlacesForAccount(Account account) {
            List<Merchant_Addresses__c> merchantAddresses = [
                SELECT
                    Id,
                    City__c,
                    Latitude__c,
                    Longitude__c,
                    State_Province__c,
                    Street_Line_1__c,
                    Street_Line_2__c,
                    Subdivision__r.Name,
                    Zip_Postal_Code__c
                FROM Merchant_Addresses__c
                WHERE Account__c = :account.id
            ];

            List<Place> places = new List<Place>();
            for (Merchant_Addresses__c m : merchantAddresses) {
                places.add(new Place(m));
            }

            return places;
        }

    }

    public class Division{
        public Id                salesforce_id { get; set; }
        public List<Subdivision> subdivisions  { get; set; }
        public String            name          { get; set; }

        public Division(Division__c d) {
            this.name = d.name;
            this.salesforce_id = d.id;
            this.subdivisions = this.getSubdivisionsForDivision(d);
        }

        List<Subdivision> getSubdivisionsForDivision(Division__c division) {
            List<Subdivision__c> subdivisionsObjects = [
                SELECT
                    Id,
                    Name,
                    Division__c,
                    Rank__c
                FROM Subdivision__c
                WHERE Division__r.Name = :division.Name
                ORDER BY Rank__c DESC
            ];

            List<Subdivision> subdivisions = new List<Subdivision>();
            for (Subdivision__c subdivisionObject : subdivisionsObjects) {
                subdivisions.add(new Subdivision(subdivisionObject));
            }

            return subdivisions;
        }
    }

    public class Taxonomy{
        public List<string> v3_services     { get; set; }
        public String       v1_category     { get; set; }
        public String       v1_subcategory  { get; set; }
        public String       v2_category     { get; set; }
        public String       v2_subcategory1 { get; set; }
        public String       v2_subcategory2 { get; set; }
        public String       v3_attributes   { get; set; }
        public String       v3_category     { get; set; }
        public String       v3_subcategory  { get; set; }

        String[] splitServices(String serviceString) {
            String[] services = new String[]{};

            if (serviceString != null) {
                serviceString.replace(' | ','|');
                for (String s : serviceString.split('\\|')) {
                    services.add(s);
                }
            }

            return services;
        }

        public Taxonomy(Lead l) {
            String[] servicessplit = new String[]{};
            this.v2_category = l.Global_SFDC_Category__c;
            this.v2_subcategory1 = l.Global_SFDC_Subcategory_1__c;
            this.v2_subcategory2 = l.Global_SFDC_Subcategory_2__c;
            this.v3_attributes = l.Merchant_Attributes__c;
            this.v3_category = l.Category_v3__c;
            this.v3_services = this.splitServices(l.Services_Offered__c);
            this.v3_subcategory = l.Subcategory_v3__c;
        }

        public Taxonomy(Opportunity o){
            this.v2_category = o.Global_SFDC_Category__c;
            this.v2_subcategory1 = o.Global_SFDC_Subcategory_1__c;
            this.v2_subcategory2 = o.Global_SFDC_Subcategory_2__c;
        }

        public Taxonomy(Account a){
            this.v2_category = a.Global_SFDC_Category__c;
            this.v2_subcategory1 = a.Global_SFDC_Subcategory_1__c;
            this.v2_subcategory2 = a.Global_SFDC_Subcategory_2__c;
            this.v3_attributes = a.Merchant_Attributes__c;
            this.v3_category = a.Category_v3__c;
            this.v3_services = this.splitServices(a.Services_Offered__c);
            this.v3_subcategory = a.Subcategory_v3__c;
        }
    }

    public class Subdivision {
        public String       name          { get; set; }
        public Id           salesforce_id { get; set; }
        public Id           division_id   { get; set; }
        public List<String> zip_codes     { get; set; }
        public Double       rank          { get; set; }

        public Subdivision(Subdivision__c s){
            this.division_id = s.Division__c;
            this.name = s.Name;
            this.rank = s.Rank__c;
            this.salesforce_id = s.Id;
            this.zip_codes = this.getZipCodesForSubdivision(s);
        }

        List<String> getZipCodesForSubdivision(Subdivision__c subdivision) {
            List<Zip_Code__c> zipCodeObjects = [
                SELECT Name
                FROM Zip_Code__c
                WHERE Subdivision__r.Name = :subdivision.name
            ];

            List<String> zipCodes = new List<String>();

            for (Zip_Code__c zipCodeObject : zipCodeObjects) {
                zipCodes.add(zipCodeObject.Name);
            }

            return zipCodes;
        }
    }

    public class Place {
        public String  salesforce_id { get; set; }
        public String  neighborhood  { get; set; }
        public Decimal lat           { get; set; }
        public Decimal lng           { get; set; }
        public String  street1       { get; set; }
        public String  street2       { get; set; }
        public String  city          { get; set; }
        public String  state         { get; set; }
        public String  postal_code   { get; set; }
        public String  subdivision   { get; set; }

        public Place(Lead l) {
            this.city = l.City;
            this.lat = l.Latitude__c;
            this.lng = l.Longitude__c;
            this.postal_code = l.PostalCode;
            this.state = l.State;
            this.street1 = l.Street;
        }

        public Place(Merchant_Addresses__c m) {
            this.city = m.City__c;
            this.lat = m.Latitude__c;
            this.lng = m.Longitude__c;
            this.postal_code = m.Zip_Postal_Code__c;
            this.salesforce_id = m.Id;
            this.state = m.State_Province__c;
            this.street1 = m.Street_Line_1__c;
            this.street2 = m.Street_Line_2__c;
            this.subdivision = m.Subdivision__r.Name;
        }
    }

    public class deal{
        public Date     close_at      { get; set; }
        public Date     launch_at     { get; set; }
        public Decimal  msat          { get; set; }
        public Id       salesforce_id { get; set; }
        public String   name          { get; set; }
        public String   stage         { get; set; }
        public String   strength      { get; set; }
        public Taxonomy taxonomy      { get; set; }

        public Deal(Opportunity o){
            this.close_at = o.Feature_end_date__c;
            this.launch_at = o.Feature_date__c;
            this.msat = o.Overall_Satisfaction__c;
            this.name = o.Name;
            this.salesforce_id = o.Id;
            this.stage = o.StageName;
            this.strength = o.Deal_Strengh__c;
            this.taxonomy = new Taxonomy(o);
        }
    }

    private static testMethod void testMerchantAPI() {
        Division__c division = new Division__c(Name = 'Chicago', State__c = 'IL');
        insert division;

        Subdivision__c subdivision = new Subdivision__c(Division__c = division.Id);
        insert subdivision;

        Account account = new GrouponTestUtil().createAccount();
        account.Division__c = division.Id;
        account.Name = 'Testing My Name';
        insert account;

        Lead lead = new Lead();
        lead.Division__c = 'Chicago';
        lead.LastName = 'my last name';
        lead.Company = 'my company name';
        lead.Dynamic_Division__c = division.Id;
        lead.Services_Offered__c = 'Service 1 | Service 2';
        insert lead;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'My test opp';
        opportunity.Division__c = 'Chicago';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = System.today();
        insert opportunity;

        Multi_deal__c multiDeal = new Multi_deal__c();
        multiDeal.Opportunity__c = opportunity.Id;
        insert multiDeal;

        Merchant_Addresses__c addresses = new Merchant_Addresses__c();
        addresses.Account__c = account.id;
        insert addresses;

        getMerchant(account.Id);

        RestRequest req = new RestRequest();
        req.addParameter('account_id', account.Id);
        RestResponse res = new RestResponse();
        RESTmerchantAPIv_10.getMerchant(req, res);

        RestRequest req2 = new RestRequest();
        req2.addParameter('account_id', lead.Id);

        RestResponse res2 = new RestResponse();
        RESTmerchantAPIv_10.getMerchant(req2, res2);
    }
}