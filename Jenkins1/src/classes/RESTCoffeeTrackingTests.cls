@isTest
global class RESTCoffeeTrackingTests {
    static Account reload(Account account) {
        return [
            SELECT
                Id,
                Coffee_Pressed_At__c,
                Coffee_Pressed_by__c,
                ROI_Viewed_At__c,
                ROI_Viewed_By__c,
                ROI_Viewed_By_Merchant_At__c
            FROM Account
            WHERE id = :account.Id
        ];
    }

    static Lead reload(Lead lead) {
        return [
            SELECT
                Id,
                Coffee_Pressed_At__c,
                Coffee_Pressed_by__c,
                ROI_Viewed_At__c,
                ROI_Viewed_By__c,
                ROI_Viewed_By_Merchant_At__c
            FROM Lead
            WHERE id = :lead.Id
        ];
    }

    static testMethod void accountOrLeadTestDoesNotExist() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            RestContext.request.httpMethod = 'GET';
            RestContext.request.requestURI = '/services/apexrest/v1.0/coffee_tracking/01zz00000000ZZZ';

            RESTCoffeeTracking.TrackingInfo trackingInfo = RESTCoffeeTracking.getTrackingInfo();

            System.assertEquals(null, trackingInfo.merchantLastOpenedRoiAt);
            System.assertEquals(null, trackingInfo.repLastOpenedRoiBy);
            System.assertEquals(null, trackingInfo.repLastOpenedRoiAt);
            System.assertEquals(null, trackingInfo.repLastOpenedCoffeeBy);
            System.assertEquals(null, trackingInfo.repLastOpenedCoffeeAt);
        }
    }

    static testMethod void accountTestGettingTrackingInfoWhenFieldsAreNull() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            Account account = new GrouponTestUtil().createAccount();
            account.ROI_Viewed_By_Merchant_At__c = null;
            account.ROI_Viewed_By__c = null;
            account.ROI_Viewed_At__c = null;
            account.Coffee_Pressed_by__c = null;
            account.Coffee_Pressed_At__c = null;
            insert account;

            RestContext.request.httpMethod = 'GET';
            RestContext.request.requestURI = '/services/apexrest/v1.0/coffee_tracking/' + account.Id;

            RESTCoffeeTracking.TrackingInfo trackingInfo = RESTCoffeeTracking.getTrackingInfo();

            System.assertEquals(account.ROI_Viewed_By_Merchant_At__c, null);
            System.assertEquals(account.ROI_Viewed_By__c, null);
            System.assertEquals(account.ROI_Viewed_At__c, null);
            System.assertEquals(account.Coffee_Pressed_by__c, null);
            System.assertEquals(account.Coffee_Pressed_At__c, null);
        }
    }

    static testMethod void accountTestGettingTrackingInfo() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            Account account = new GrouponTestUtil().createAccount();
            account.ROI_Viewed_By_Merchant_At__c = Datetime.parse('1/2/2003 4:00 AM');
            account.ROI_Viewed_By__c = 'John Doe';
            account.ROI_Viewed_At__c = Datetime.parse('2/3/2004 5:00 AM');
            account.Coffee_Pressed_by__c = 'Jane Doe';
            account.Coffee_Pressed_At__c = Datetime.parse('3/4/2005 6:00 AM');
            insert account;

            RestContext.request.httpMethod = 'GET';
            RestContext.request.requestURI = '/services/apexrest/v1.0/coffee_tracking/' + account.Id;

            RESTCoffeeTracking.TrackingInfo trackingInfo = RESTCoffeeTracking.getTrackingInfo();

            System.assertEquals(new LibrarySimpleISODatetime(account.ROI_Viewed_By_Merchant_At__c).formatISO8601Gmt(),
                                trackingInfo.merchantLastOpenedRoiAt);
            System.assertEquals(account.ROI_Viewed_By__c,
                                trackingInfo.repLastOpenedRoiBy);
            System.assertEquals(new LibrarySimpleISODatetime(account.ROI_Viewed_At__c).formatISO8601Gmt(),
                                trackingInfo.repLastOpenedRoiAt);
            System.assertEquals(account.Coffee_Pressed_by__c,
                                trackingInfo.repLastOpenedCoffeeBy);
            System.assertEquals(new LibrarySimpleISODatetime(account.Coffee_Pressed_At__c).formatISO8601Gmt(),
                                trackingInfo.repLastOpenedCoffeeAt);
        }
    }

    static testMethod void accountTestUpdatingSingleField() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            String merchantLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedRoiBy = 'John Doe';
            String repLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedCoffeeBy = 'Jane Doe';
            String repLastOpenedCoffeeAt = '2012-08-31T02:12:18+00:00';
            Account account = null;

            account = new GrouponTestUtil().createAccount();
            insert account;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + account.Id;
            RESTCoffeeTracking.updateTrackingInfo(merchantLastOpenedRoiAt, null, null, null, null);
            account = reload(account);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(merchantLastOpenedRoiAt), account.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, account.ROI_Viewed_By__c);
            System.assertEquals(null, account.ROI_Viewed_At__c);
            System.assertEquals(null, account.Coffee_Pressed_by__c);
            System.assertEquals(null, account.Coffee_Pressed_At__c);

            account = new GrouponTestUtil().createAccount();
            insert account;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + account.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, repLastOpenedRoiBy, null, null, null);

            account = reload(account);
            System.assertEquals(null, account.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(repLastOpenedRoiBy, account.ROI_Viewed_By__c);
            System.assertEquals(null, account.ROI_Viewed_At__c);
            System.assertEquals(null, account.Coffee_Pressed_by__c);
            System.assertEquals(null, account.Coffee_Pressed_At__c);

            account = new GrouponTestUtil().createAccount();
            insert account;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + account.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, null, repLastOpenedRoiAt, null, null);

            account = reload(account);
            System.assertEquals(null, account.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, account.ROI_Viewed_By__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedRoiAt), account.ROI_Viewed_At__c);
            System.assertEquals(null, account.Coffee_Pressed_by__c);
            System.assertEquals(null, account.Coffee_Pressed_At__c);

            account = new GrouponTestUtil().createAccount();
            insert account;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + account.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, null, null, repLastOpenedCoffeeBy, null);

            account = reload(account);
            System.assertEquals(null, account.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, account.ROI_Viewed_By__c);
            System.assertEquals(null, account.ROI_Viewed_At__c);
            System.assertEquals(repLastOpenedCoffeeBy, account.Coffee_Pressed_by__c);
            System.assertEquals(null, account.Coffee_Pressed_At__c);

            account = new GrouponTestUtil().createAccount();
            insert account;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + account.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, null, null, null, repLastOpenedCoffeeAt);

            account = reload(account);
            System.assertEquals(null, account.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, account.ROI_Viewed_By__c);
            System.assertEquals(null, account.ROI_Viewed_At__c);
            System.assertEquals(null, account.Coffee_Pressed_by__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedCoffeeAt), account.Coffee_Pressed_At__c);
        }
    }

    static testMethod void accountTestUpdatingMultipleFields() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            String merchantLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedRoiBy = 'John Doe';
            String repLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedCoffeeBy = 'Jane Doe';
            String repLastOpenedCoffeeAt = '2012-08-31T02:12:18+00:00';
            Account account = new GrouponTestUtil().createAccount();
            insert account;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + account.Id;
            RESTCoffeeTracking.updateTrackingInfo(
                    merchantLastOpenedRoiAt,
                    repLastOpenedRoiBy,
                    repLastOpenedRoiAt,
                    repLastOpenedCoffeeBy,
                    repLastOpenedCoffeeAt);

            account = reload(account);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(merchantLastOpenedRoiAt), account.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(repLastOpenedRoiBy, account.ROI_Viewed_By__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedRoiAt), account.ROI_Viewed_At__c);
            System.assertEquals(repLastOpenedCoffeeBy, account.Coffee_Pressed_by__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedCoffeeAt), account.Coffee_Pressed_At__c);
        }
    }

    static testMethod void leadTestGettingTrackingInfoWhenFieldsAreNull() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            Lead lead = new GrouponTestUtil().createLead();
            lead.ROI_Viewed_By_Merchant_At__c = null;
            lead.ROI_Viewed_By__c = null;
            lead.ROI_Viewed_At__c = null;
            lead.Coffee_Pressed_by__c = null;
            lead.Coffee_Pressed_At__c = null;
            insert lead;

            RestContext.request.httpMethod = 'GET';
            RestContext.request.requestURI = '/services/apexrest/v1.0/coffee_tracking/' + lead.Id;

            RESTCoffeeTracking.TrackingInfo trackingInfo = RESTCoffeeTracking.getTrackingInfo();

            System.assertEquals(lead.ROI_Viewed_By_Merchant_At__c, null);
            System.assertEquals(lead.ROI_Viewed_By__c, null);
            System.assertEquals(lead.ROI_Viewed_At__c, null);
            System.assertEquals(lead.Coffee_Pressed_by__c, null);
            System.assertEquals(lead.Coffee_Pressed_At__c, null);
        }
    }

    static testMethod void leadTestGettingTrackingInfo() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            Lead lead = new GrouponTestUtil().createLead();
            lead.ROI_Viewed_By_Merchant_At__c = Datetime.parse('1/2/2003 4:00 AM');
            lead.ROI_Viewed_By__c = 'John Doe';
            lead.ROI_Viewed_At__c = Datetime.parse('2/3/2004 5:00 AM');
            lead.Coffee_Pressed_by__c = 'Jane Doe';
            lead.Coffee_Pressed_At__c = Datetime.parse('3/4/2005 6:00 AM');
            insert lead;

            RestContext.request.httpMethod = 'GET';
            RestContext.request.requestURI = '/services/apexrest/v1.0/coffee_tracking/' + lead.Id;

            RESTCoffeeTracking.TrackingInfo trackingInfo = RESTCoffeeTracking.getTrackingInfo();

            System.assertEquals(new LibrarySimpleISODatetime(lead.ROI_Viewed_By_Merchant_At__c).formatISO8601Gmt(),
                                trackingInfo.merchantLastOpenedRoiAt);
            System.assertEquals(lead.ROI_Viewed_By__c,
                                trackingInfo.repLastOpenedRoiBy);
            System.assertEquals(new LibrarySimpleISODatetime(lead.ROI_Viewed_At__c).formatISO8601Gmt(),
                                trackingInfo.repLastOpenedRoiAt);
            System.assertEquals(lead.Coffee_Pressed_by__c,
                                trackingInfo.repLastOpenedCoffeeBy);
            System.assertEquals(new LibrarySimpleISODatetime(lead.Coffee_Pressed_At__c).formatISO8601Gmt(),
                                trackingInfo.repLastOpenedCoffeeAt);
        }
    }

    static testMethod void leadTestUpdatingSingleField() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            String merchantLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedRoiBy = 'John Doe';
            String repLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedCoffeeBy = 'Jane Doe';
            String repLastOpenedCoffeeAt = '2012-08-31T02:12:18+00:00';
            Lead lead = null;

            lead = new GrouponTestUtil().createLead();
            insert lead;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + lead.Id;
            RESTCoffeeTracking.updateTrackingInfo(merchantLastOpenedRoiAt, null, null, null, null);

            lead = reload(lead);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(merchantLastOpenedRoiAt), lead.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, lead.ROI_Viewed_By__c);
            System.assertEquals(null, lead.ROI_Viewed_At__c);
            System.assertEquals(null, lead.Coffee_Pressed_by__c);
            System.assertEquals(null, lead.Coffee_Pressed_At__c);

            lead = new GrouponTestUtil().createLead();
            insert lead;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + lead.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, repLastOpenedRoiBy, null, null, null);

            lead = reload(lead);
            System.assertEquals(null, lead.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(repLastOpenedRoiBy, lead.ROI_Viewed_By__c);
            System.assertEquals(null, lead.ROI_Viewed_At__c);
            System.assertEquals(null, lead.Coffee_Pressed_by__c);
            System.assertEquals(null, lead.Coffee_Pressed_At__c);

            lead = new GrouponTestUtil().createLead();
            insert lead;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + lead.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, null, repLastOpenedRoiAt, null, null);

            lead = reload(lead);
            System.assertEquals(null, lead.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, lead.ROI_Viewed_By__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedRoiAt), lead.ROI_Viewed_At__c);
            System.assertEquals(null, lead.Coffee_Pressed_by__c);
            System.assertEquals(null, lead.Coffee_Pressed_At__c);

            lead = new GrouponTestUtil().createLead();
            insert lead;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + lead.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, null, null, repLastOpenedCoffeeBy, null);

            lead = reload(lead);
            System.assertEquals(null, lead.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, lead.ROI_Viewed_By__c);
            System.assertEquals(null, lead.ROI_Viewed_At__c);
            System.assertEquals(repLastOpenedCoffeeBy, lead.Coffee_Pressed_by__c);
            System.assertEquals(null, lead.Coffee_Pressed_At__c);

            lead = new GrouponTestUtil().createLead();
            insert lead;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + lead.Id;
            RESTCoffeeTracking.updateTrackingInfo(null, null, null, null, repLastOpenedCoffeeAt);

            lead = reload(lead);
            System.assertEquals(null, lead.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(null, lead.ROI_Viewed_By__c);
            System.assertEquals(null, lead.ROI_Viewed_At__c);
            System.assertEquals(null, lead.Coffee_Pressed_by__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedCoffeeAt), lead.Coffee_Pressed_At__c);
        }
    }

    static testMethod void leadTestUpdatingMultipleFields() {
        RestContext.request = new RestRequest();
        User user = new GrouponTestUtil().createTestUser('System Administrator');

        System.runAs(user) {
            String merchantLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedRoiBy = 'John Doe';
            String repLastOpenedRoiAt = '2012-08-31T02:12:18+00:00';
            String repLastOpenedCoffeeBy = 'Jane Doe';
            String repLastOpenedCoffeeAt = '2012-08-31T02:12:18+00:00';
            Lead lead = new GrouponTestUtil().createLead();
            insert lead;
            RestContext.request.requestURI = '/v1.0/coffee_tracking/' + lead.Id;
            RESTCoffeeTracking.updateTrackingInfo(
                    merchantLastOpenedRoiAt,
                    repLastOpenedRoiBy,
                    repLastOpenedRoiAt,
                    repLastOpenedCoffeeBy,
                    repLastOpenedCoffeeAt);

            lead = reload(lead);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(merchantLastOpenedRoiAt), lead.ROI_Viewed_By_Merchant_At__c);
            System.assertEquals(repLastOpenedRoiBy, lead.ROI_Viewed_By__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedRoiAt), lead.ROI_Viewed_At__c);
            System.assertEquals(repLastOpenedCoffeeBy, lead.Coffee_Pressed_by__c);
            System.assertEquals(LibrarySimpleISODatetime.parseISO8601(repLastOpenedCoffeeAt), lead.Coffee_Pressed_At__c);
        }
    }
}