@RestResource(urlMapping='/v2.0/merchant/deals/*')
global without sharing class RESTMerchantDealsAPIv2 {

    @HttpGET
    global static List<Deal> getDeals() {
        RestRequest req = RestContext.request;
        List<Deal> deals = new List<Deal>();
        String id = EncodingUtil.urlDecode(req.params.get('salesforce_id'), 'UTF-8');

        List<Opportunity> opportunities = getOpportunities(id);
        for (Opportunity opportunity : opportunities) {
            Deal deal = new Deal(opportunity);
            deals.add(deal);
        }

        return deals;
    }

    global class Deal {
        public Id              id                     { get; set; }
        public Decimal         ccFee                  { get; set; }
        public Decimal         daysToPayment          { get; set; }
        public Decimal         eppm                   { get; set; }
        public Decimal         gp                     { get; set; }
        public Decimal         monthsToExpiration     { get; set; }
        public Decimal         payment1Amount         { get; set; }
        public Decimal         payment1Days           { get; set; }
        public Decimal         payment2Amount         { get; set; }
        public Decimal         payment2Days           { get; set; }
        public Decimal         payment3Amount         { get; set; }
        public Decimal         payment3Days           { get; set; }
        public Decimal         percentPayment         { get; set; }
        public Decimal         postGp                 { get; set; }
        public Decimal         postUnits              { get; set; }
        public Decimal         refundedUnits          { get; set; }
        public Decimal         refunds                { get; set; }
        public Decimal         totalUnits             { get; set; }
        public Integer         age                    { get; set; }
        public Integer         irCount                { get; set; }
        public List<Agreement> agreements             { get; set; }
        public List<Contact>   contacts               { get; set; }
        public List<Option>    options                { get; set; }
        public String          accountId              { get; set; }
        public String          accountNumber          { get; set; }
        public String          bankName               { get; set; }
        public String          billingCity            { get; set; }
        public String          billingCountry         { get; set; }
        public String          billingState           { get; set; }
        public String          billingStreet          { get; set; }
        public String          billingZip             { get; set; }
        public String          closeDate              { get; set; }
        public String          conditions             { get; set; }
        public String          dealStatus             { get; set; }
        public String          dealStrength           { get; set; }
        public String          division               { get; set; }
        public String          editorialStatus        { get; set; }
        public String          expirationDate         { get; set; }
        public String          expirationType         { get; set; }
        public String          featureDate            { get; set; }
        public String          featureEndDate         { get; set; }
        public String          goLiveDate             { get; set; }
        public String          lastContactDate        { get; set; }
        public String          merchantPermalink      { get; set; }
        public String          name                   { get; set; }
        public String          nextPayment            { get; set; }
        public String          payableTo              { get; set; }
        public String          payment1Date           { get; set; }
        public String          payment2Date           { get; set; }
        public String          payment3Date           { get; set; }
        public String          paymentPreference      { get; set; }
        public String          paymentTerms           { get; set; }
        public String          permalink              { get; set; }
        public String          prefeatureStatus       { get; set; }
        public String          privateSale            { get; set; }
        public String          recordType             { get; set; }
        public String          redemptionInstructions { get; set; }
        public String          routingNumber          { get; set; }
        public String          routingNumberValid     { get; set; }
        public String          salesRep               { get; set; }
        public String          stage                  { get; set; }
        public String          statusFeatureDate      { get; set; }
        public String          statusGettingReady     { get; set; }
        public String          statusIntro            { get; set; }
        public String          statusMerchantCenter   { get; set; }
        public String          statusPreviewApproved  { get; set; }
        public String          statusPreviewSent      { get; set; }

        public String          featureDateTaskId      { get; set; }
        public String          gettingReadyTaskId     { get; set; }
        public String          introTaskId            { get; set; }
        public String          merchantCenterTaskId   { get; set; }
        public String          previewApprovedTaskId  { get; set; }
        public String          previewSentTaskId      { get; set; }

        public String          featureDateTaskDescription      { get; set; }
        public String          gettingReadyTaskDescription     { get; set; }
        public String          introTaskDescription            { get; set; }
        public String          merchantCenterTaskDescription   { get; set; }
        public String          previewApprovedTaskDescription  { get; set; }
        public String          previewSentTaskDescription      { get; set; }

        public Deal(Opportunity o) {
            Boolean goneLive = (o.Go_Live_Date__c != null && o.Go_Live_Date__c.daysBetween(Date.today()) >= 0);
            Boolean featureBegun = (o.Feature_Date__c != null && o.Feature_Date__c.daysBetween(Date.today()) >= 0);
            Boolean featureEnded = (o.Feature_End_Date__c != null && o.Feature_End_Date__c.daysBetween(Date.today()) >= 0);
            Boolean featureExpired = (o.Groupon_expiration_Date__c != null && o.Groupon_expiration_Date__c.daysBetween(Date.today()) >= 0);
            Boolean firstPaymentPast = (o.X1st_Payment_Date__c != null && o.X1st_Payment_Date__c.daysBetween(Date.today()) >= 0);
            Boolean secondPaymentPast = (o.X2nd_Payment_Date__c != null && o.X2nd_Payment_Date__c.daysBetween(Date.today()) >= 0);
            Boolean thirdPaymentPast = (o.X3rd_Payment_Date__c != null && o.X3rd_Payment_Date__c.daysBetween(Date.today()) >= 0);

            this.id = o.Id;
            this.accountId = o.AccountId;
            this.ccFee = o.CC_Fee__c;
            this.conditions = o.Conditions__c;
            this.daysToPayment = o.Days_from_Feature_to_1st_Payment__c;
            this.percentPayment = o.Percent_Payment__c;
            this.division = o.Division__c;
            this.editorialStatus = o.Writeup_Status_del__c;
            this.expirationType = o.Expiration_Type__c;
            this.eppm = o.ePPM__c;
            this.gp = o.Total_GP__c.setScale(0);
            this.merchantPermalink = o.Merchant_Permalink__c;
            this.monthsToExpiration = o.Months_to_Expiration__c;
            this.name = o.Name;
            this.payableTo = o.Make_Checks_Payable_to__c;
            this.payment1Amount = o.X1st_Payment__c;
            this.payment2Amount = o.X2nd_Payment__c;
            this.payment3Amount = o.X3rd_Payment__c;
            this.payment1Days = o.X1st_Payment_Days__c;
            this.payment2Days = o.X2nd_Payment_Days__c;
            this.payment3Days = o.X3rd_Payment_Days__c;
            this.paymentPreference = o.Payment_Preference__c;
            this.paymentTerms = o.Payment_Terms__c;
            this.permalink = o.Permalink__c;
            this.prefeatureStatus = o.Pre_Feature_Status__c;
            this.privateSale = o.Straight_to_Private_Sale__c;
            this.redemptionInstructions = o.Coupon_instructions__c;
            this.recordType = o.RecordType.Name;
            this.salesRep = o.Owner.Name;
            this.stage = o.StageName;
            this.totalUnits = o.Total_Units_Sold__c.setScale(0);

            if (o.Account != null) {
                this.bankName = o.Account.Bank_Name__c;
                this.billingCity = o.Account.BillingCity;
                this.billingCountry = o.Account.BillingCountry;
                this.billingState = o.Account.BillingState;
                this.billingStreet = o.Account.BillingStreet;
                this.billingZip = o.Account.BillingPostalCode;
                this.routingNumberValid = o.Account.Valid_Routing__c;
                if (o.Account.Account_Number__c != null) {
                    this.accountNumber = '*****' + o.Account.Account_Number__c.substring(5);
                }
                if (o.Account.Routing_Number_enc__c != null) {
                    this.routingNumber = '*****' + o.Account.Routing_Number_enc__c.substring(5);
                }
            }

            if (o.RecordType != null && o.RecordType.Name == 'gLite') {
                this.dealStatus = 'G2';
            } else if (goneLive && !featureBegun) {
                this.dealStatus = 'Prefeature';
            } else if (featureBegun && !featureEnded) {
                this.dealStatus = 'Feature';
            } else if (o.Deal_Bank_Eligible__c == 'Opt-In' && featureEnded && !featureExpired) {
                this.dealStatus = 'Deal Bank';
            } else if (featureExpired) {
                this.dealStatus = 'Expired';
            } else {
                this.dealStatus = 'Open';
            }

            if (o.Financial_Records__r != null) {
                this.refundedUnits = 0;
                this.postGp = 0;
                this.postUnits = 0;
                for (Financial_Records__c record : o.Financial_Records__r) {
                    if (record.Units_Refunded__c != null) {
                        this.refundedUnits -= record.Units_Refunded__c;
                    }

                    if (record.Collection_Date__c != null && o.Feature_End_Date__c != null && record.Collection_Date__c.daysBetween(o.Feature_End_Date__c) < 0) {
                        if (record.Revenue_Amount__c != null) {
                            this.postGp += record.Revenue_Amount__c;
                        }
                        if (record.Revenue_Amount__c != null && record.Revenue_Amount__c > 0) {
                            this.postUnits++;
                        }
                        this.refundedUnits.setScale(0);
                        this.postUnits.setScale(0);
                    }
                }
            }

            if (o.OpportunityContactRoles != null) {
                this.contacts = new List<Contact>();
                for (OpportunityContactRole contact : o.OpportunityContactRoles) {
                    this.contacts.add(new Contact(contact));
                }
            }

            if (o.X1st_Payment_Date__c != null && !firstPaymentPast) {
                this.nextPayment = new LibrarySimpleIsoDatetime(o.X1st_Payment_Date__c).formatIso8601Gmt();
            } else if (o.X2nd_Payment_Date__c != null && !secondPaymentPast) {
                this.nextPayment = new LibrarySimpleIsoDatetime(o.X2nd_Payment_Date__c).formatIso8601Gmt();
            } else if (o.X3rd_Payment_Date__c != null && !thirdPaymentPast) {
                this.nextPayment = new LibrarySimpleIsoDatetime(o.X3rd_Payment_Date__c).formatIso8601Gmt();
            } else {
                this.nextPayment = null;
            }

            if (o.X1st_Payment_Date__c != null) {
                this.payment1Date = new LibrarySimpleIsoDatetime(o.X1st_Payment_Date__c).formatIso8601Gmt();
            }

            if (o.X2nd_Payment_Date__c != null) {
                this.payment2Date = new LibrarySimpleIsoDatetime(o.X2nd_Payment_Date__c).formatIso8601Gmt();
            }

            if (o.X3rd_Payment_Date__c != null) {
                this.payment3Date = new LibrarySimpleIsoDatetime(o.X3rd_Payment_Date__c).formatIso8601Gmt();
            }

            if (o.CreatedDate != null) {
                this.age = o.CreatedDate.date().daysBetween(Date.today());
            }

            if (o.Go_Live_Date__c != null) {
                this.goLiveDate = new LibrarySimpleIsoDatetime(o.Go_Live_Date__c).formatIso8601Gmt();
            }

            if (o.Groupon_expiration_Date__c != null) {
                this.expirationDate = new LibrarySimpleISODatetime(o.Groupon_expiration_Date__c).formatIso8601Gmt();
            }

            if (o.CloseDate != null) {
                this.closeDate = new LibrarySimpleISODatetime(o.CloseDate).formatIso8601Gmt();
            }

            if (o.Feature_Date__c != null) {
                this.featureDate = new LibrarySimpleIsoDatetime(o.Feature_Date__c).formatIso8601Gmt();
            }

            if (o.Feature_End_Date__c != null) {
                this.featureEndDate = new LibrarySimpleIsoDatetime(o.Feature_End_Date__c).formatIso8601Gmt();
            }

            this.statusIntro            = 'Not Started';
            this.statusFeatureDate      = 'Not Started';
            this.statusGettingReady     = 'Not Started';
            this.statusMerchantCenter   = 'Not Started';
            this.statusPreviewSent      = 'Not Started';
            this.statusPreviewApproved  = 'Not Started';
            if (o.Tasks != null && o.Tasks.size() > 0) {
                if (o.Tasks.get(0).ActivityDate != null) {
                    this.lastContactDate = new LibrarySimpleIsoDatetime(o.Tasks.get(0).ActivityDate).formatIso8601Gmt();
                }

                for (Task task : o.Tasks) {
                    if (task.Subject == 'Prep: Intro Call') {
                        this.statusIntro = task.Status;
                        this.introTaskId = task.Id;
                        this.introTaskDescription = task.Description;
                    }
                    if (task.Subject == 'Prep: Feature Date Communicated' ||
                        task.Subject == 'Prep: Feature Date Confirmed') {
                        this.statusFeatureDate = task.Status;
                        this.featureDateTaskId = task.Id;
                        this.featureDateTaskDescription = task.Description;
                    }
                    if (task.Subject == 'Prep: Getting Ready Email Sent' ||
                        task.Subject == 'Prep: Getting Ready') {
                        this.statusGettingReady = task.Status;
                        this.gettingReadyTaskId = task.Id;
                        this.gettingReadyTaskDescription = task.Description;
                    }
                    if (task.Subject == 'Prep: Merchant Center Walkthrough' ||
                        task.Subject == 'Prep: MC Walkthrough') {
                        this.statusMerchantCenter = task.Status;
                        this.merchantCenterTaskId = task.Id;
                        this.merchantCenterTaskDescription = task.Description;
                    }
                    if (task.Subject == 'Prep: Preview Sent' ||
                        task.Subject == 'Prep: Preview Delivered') {
                        this.statusPreviewSent = task.Status;
                        this.previewSentTaskId = task.Id;
                        this.previewSentTaskDescription = task.Description;
                    }
                    if (task.Subject == 'Prep: Preview Approved') {
                        this.statusPreviewApproved = task.Status;
                        this.previewApprovedTaskId = task.Id;
                        this.previewApprovedTaskDescription = task.Description;
                    }
                }
            }

            this.dealStrength = o.Deal_Strengh__c;
            if (o.StageName == 'Closed Won') {
                if (featureExpired) {
                    this.stage = 'Feature Expired';
                } else if (goneLive) {
                    this.stage = 'Featured';
                } else if (o.Deal_Strengh__c == 'Vetted' || o.Deal_Strengh__c == 'A Sure Thing') {
                    this.stage = 'Prep';
                } else {
                    this.stage = 'Closed Won';
                }
            } else if (o.StageName == 'Closed Lost' || o.StageName == 'Closed Expired') {
                this.stage = o.StageName;
            } else {
                this.stage = 'Prospecting';
                this.dealStrength = o.StageName;
            }

            if (o.Information_Requests__r != null) {
                this.irCount = o.Information_Requests__r.Size();
            }

            if (o.Multi_Deals__r != null) {
                Set<String> option_ids = new Set<String>();
                this.options = new List<Option>();

                for (Multi_Deal__c multiDeal : o.Multi_deals__r) {
                    this.options.add(new Option(multiDeal));
                }
            }

            if (o.Echosign_Dev1__R00N70000001hM2REAU__r != null) {
                this.agreements = new List<Agreement>();

                for (Echosign_Dev1__SIGN_Agreement__c agreement : o.Echosign_Dev1__R00N70000001hM2REAU__r) {
                    this.agreements.add(new Agreement(agreement));
                }
            }
        }
    }

    public static List<Opportunity> getOpportunities(String id) {
        return [
            SELECT
                Id,
                Account.Account_Number__c,
                Account.Bank_Name__c,
                Account.BillingCity,
                Account.BillingCountry,
                Account.BillingPostalCode,
                Account.BillingState,
                Account.BillingStreet,
                Account.Routing_Number_enc__c,
                Account.Valid_Routing__c,
                AccountId,
                CC_Fee__c,
                CloseDate,
                Conditions__c,
                Coupon_instructions__c,
                CreatedDate,
                Days_from_Feature_to_1st_Payment__c,
                Deal_Bank_Eligible__c,
                Deal_Status__c,
                Deal_strengh__c,
                Division__c,
                Enable_Staggered_Expiration__c,
                EPPM__c,
                Expiration_Policy__c,
                Expiration_Type__c,
                Feature_Date__c,
                Feature_End_Date__c,
                Go_Live_Date__c,
                Groupon_expiration_Date__c,
                GrouponLite_Status__c,
                Merchant_Permalink__c,
                Make_Checks_Payable_to__c,
                Months_to_Expiration__c,
                Name,
                Owner.Name,
                Payment_Preference__c,
                Payment_Terms__c,
                Percent_Payment__c,
                Permalink__c,
                Pre_Feature_Status__c,
                RecordType.Name,
                StageName,
                Straight_to_Private_Sale__c,
                Total_gp__c,
                Total_Units_Sold__c,
                Writeup_Status_del__c,
                X1st_Payment__c,
                X1st_Payment_Date__c,
                X1st_Payment_Days__c,
                X2nd_Payment__c,
                X2nd_Payment_Date__c,
                X2nd_Payment_Days__c,
                X3rd_Payment__c,
                X3rd_Payment_Date__c,
                X3rd_Payment_Days__c,
                (
                    SELECT
                        Id,
                        Enable_Staggered_Expiration__c,
                        GrouponLite_Monthly_Cap__c,
                        Name,
                        Total_Deal_Max__c,
                        Unit_Buy_Price__c,
                        Unit_Sell_Price__c,
                        Unit_Value__c,
                        Units_Sold__c
                    FROM Multi_deals__r
                    LIMIT 200
                ), (
                    SELECT
                        ContactId,
                        Contact.Name,
                        Contact.Email,
                        Contact.Phone,
                        Contact.MobilePhone,
                        Contact.Title,
                        Role,
                        IsPrimary
                    FROM OpportunityContactRoles
                    LIMIT 200
                ), (
                    SELECT
                        Id,
                        ActivityDate,
                        Description,
                        IsClosed,
                        Status,
                        Subject
                    FROM Tasks
                    ORDER BY ActivityDate DESC
                    LIMIT 200
                ), (
                    SELECT
                        Id,
                        Name
                    FROM Information_Requests__r
                    WHERE Issue_Resolved__c = false
                    LIMIT 200
                ), (
                    SELECT
                        Id,
                        Name
                    FROM Echosign_Dev1__R00N70000001hM2REAU__r
                    LIMIT 200
                ), (
                    SELECT
                        Units_Refunded__c,
                        Collection_Date__c,
                        Revenue_Amount__c
                    FROM Financial_Records__r
                    LIMIT 200
                )
            FROM Opportunity
            WHERE AccountId = :id
            ORDER BY Feature_Date__c DESC
            LIMIT 50
        ];
    }

    public class Agreement {
        public Id id { get; set; }
        public String name { get; set; }

        public Agreement(Echosign_Dev1__SIGN_Agreement__c agreement) {
            this.id = agreement.Id;
            this.name = agreement.Name;
        }
    }

    public class Contact {
        public Id id { get; set; }
        public Boolean primary { get; set; }
        public String email { get; set; }
        public String mobile { get; set; }
        public String name { get; set; }
        public String phone { get; set; }
        public String role { get; set; }
        public String title { get; set; }

        public Contact(OpportunityContactRole opportunityContact) {
            this.id = opportunityContact.ContactId;
            this.primary = opportunityContact.IsPrimary;
            if (opportunityContact.Contact != null) {
                this.email = opportunityContact.Contact.Email;
                this.mobile = opportunityContact.Contact.MobilePhone;
                this.name = opportunityContact.Contact.Name;
                this.phone = opportunityContact.Contact.Phone;
                this.role = opportunityContact.Contact.Title;
                this.title = opportunityContact.Contact.Title;
            }
        }
    }

    public class Option {
        public Id id { get; set; }
        public Boolean expirationStaggering { get; set; }
        public Decimal buyPrice { get; set; }
        public Decimal monthlyCap { get; set; }
        public Decimal sellPrice { get; set; }
        public Decimal unitCap { get; set; }
        public Decimal unitsSold { get; set; }
        public Decimal value { get; set; }
        public String name { get; set; }

        public Option(Multi_Deal__c multiDeal) {
            this.id = multiDeal.Id;
            this.buyPrice = multiDeal.Unit_Buy_Price__c;
            this.expirationStaggering = multiDeal.Enable_Staggered_Expiration__c;
            this.monthlyCap = multiDeal.GrouponLite_Monthly_Cap__c;
            this.name = multiDeal.Name;
            this.sellPrice = multiDeal.Unit_Sell_Price__c;
            this.unitCap = multiDeal.Total_Deal_Max__c;
            this.unitsSold = multiDeal.Units_Sold__c;
            this.value = multiDeal.Unit_Value__c;
        }
    }
}