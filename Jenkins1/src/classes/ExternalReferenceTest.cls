public class ExternalReferenceTest{

    @istest
    public static void testCanInsertNewReviewForUnconvertedLead() {
    
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'newlink';
        
        String reviewId = review.Id;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        facebookReference.addReviewInformation(review);
        facebookReference.setSFIds(null, lead);
        
        facebookReference.save();
        
        // verify that fields on the review reference are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(24, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(36, reviewToCheck.Rating__c);
        System.assertEquals(lead.Id, reviewToCheck.Lead__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
        System.assertEquals('newlink', reviewToCheck.Review_Link__c);
    }
    
    @istest
    public static void testCannotInsertNewGoogleReviewForUnconvertedLead() {
    
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Google';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'newlink';
        
        String reviewId = review.Id;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        facebookReference.addReviewInformation(review);
        facebookReference.setSFIds(null, lead);
        
        facebookReference.save();
        
        // verify that fields on the review reference are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that no reviews exist
        
        System.assertEquals(0,sobject_reviews.size());
    }
    
    @istest
    public static void testDoesNotInsertNewReviewForConvertedLeadWithNoMerchantAddressInfo() {
    
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        // convert lead
        database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Prospecting');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'newlink';
        
        String reviewId = review.Id;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        facebookReference.addReviewInformation(review);
        facebookReference.setSFIds(null, requeryAfterConversion(lead.id));
        
        facebookReference.save();
        
        // verify that fields on the review reference are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that no reviews exist
        
        System.assertEquals(0,sobject_reviews.size());
    }
    
    @istest
    public static void testDoesUpdateSFReviewObjectForChangedDataForLead() {
 
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for one second
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Lead__c = lead.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 25;
        newreview.Rating__c = 37;
        newreview.Review_Link__c = 'newlink';
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertNotEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoNoInsertReviewsForMissingReviewDataForLead() {
    
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        facebookReference.preExistingLead = lead;
        ExternalReferenceSource source = new ExternalReferenceSource();
        source.source_id = '11';
        facebookReference.external_reference_source = source;
        facebookReference.external_reference_id = 'therefid';
        facebookReference.external_reference_url = 'therefurl';
        
        facebookReference.save();
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // verify that a facebook review did not get created
        System.assertEquals(0,sobject_reviews.size());
    }
    
    @istest
    public static void testDoesNotUpdateSFReviewObjectForUnchangedDataForLead() {

        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for one second
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Lead__c = lead.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 24;
        newreview.Rating__c = 36;
        newreview.Review_Link__c = 'oldlink';
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoesNotUpdateSFReviewObjectForUnchangedExternalAccessTimestampForLead() {

        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        review.Review_Update_Date__c = Date.valueOf('2012-12-07T15:35:05.000Z');
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for one second
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Lead__c = lead.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 24;
        newreview.Rating__c = 36;
        newreview.Review_Link__c = 'oldlink';
        newreview.Review_Update_Date__c = Date.valueOf('2012-12-15T15:35:05.000Z');
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testCanUpdateReviewFields() {
    
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        insert merchantAddress;
        
        Reviews__c review = new Reviews__c();
        review.Merchant_Address__c = merchantAddress.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        review.Facebook_of_Fans__c = 34;
        review.Review_Update_Date__c = Date.valueOf('2012-10-10T15:42:05.000Z');
        
        insert review;
        
        String reviewId = review.Id;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Merchant_Address__c = merchantAddress.Id;
        newreview.Account__c = account.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 57;
        newreview.Rating__c = 3.5;
        newreview.Review_Link__c = 'newlink';
        newreview.Facebook_of_Fans__c = 56;
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.external_access_timestamp = '2012-12-08T15:42:05.000Z';
        
        facebookReference.save();
        
        // verify that fields on the review reference are set correctly
        
        // query for review
        Reviews__c reviewToCheck = [SELECT Number_of_Ratings__c, Facebook_of_Fans__c, Rating__c, Review_Update_Date__c, Review_Link__c FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals('newlink', reviewToCheck.Review_Link__c);
        System.assertEquals(56, reviewToCheck.Facebook_of_Fans__c);
        System.assertEquals('12/8/2012', reviewToCheck.Review_Update_Date__c.format());
    }
    

    @istest
    public static void testCanInsertNewReview() {
    
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        insert merchantAddress;
        
        Reviews__c review = new Reviews__c();
        review.Account__c = account.Id;
        review.Merchant_Address__c = merchantAddress.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'newlink';
        review.Facebook_of_Fans__c = 78;
        
        String reviewId = review.Id;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        facebookReference.addReviewInformation(review);
        facebookReference.setSFIds(merchantAddress, null);
        
        facebookReference.external_access_timestamp = '2012-12-10T15:42:05.000Z';
        
        facebookReference.save();
        
        // verify that fields on the review reference are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Account__c, Merchant_Address__c, Source__c, Facebook_of_Fans__c, Review_Update_Date__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Merchant_Address__c = :merchantAddress.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(24, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(36, reviewToCheck.Rating__c);
        System.assertEquals(account.Id, reviewToCheck.Account__c);
        System.assertEquals(merchantAddress.Id, reviewToCheck.Merchant_Address__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
        System.assertEquals('newlink', reviewToCheck.Review_Link__c);
        System.assertEquals(78, reviewToCheck.Facebook_of_Fans__c);
        System.assertEquals('12/10/2012', reviewToCheck.Review_Update_Date__c.format());
    }
    
    @istest
    public static void testDoNoInsertReviewsForMissingReviewData() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        insert merchantAddress;
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        facebookReference.preExistingMerchantAddress = merchantAddress;
        ExternalReferenceSource source = new ExternalReferenceSource();
        source.source_id = '11';
        facebookReference.external_reference_source = source;
        facebookReference.external_reference_id = 'therefid';
        facebookReference.external_reference_url = 'therefurl';
        
        facebookReference.save();
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Merchant_Address__c = :merchantAddress.Id];
            
        // verify that a facebook review did not get created
        System.assertEquals(0,sobject_reviews.size());
    }
    
    @istest
    public static void testCanSetSalesforceIds() {
        GrouponTestUtil util = new GrouponTestUtil();
        
        Account account1 = util.createAccount();
        insert account1;
        
        Lead lead = util.createLead();
        insert lead;
        
        ExternalReference reference = new ExternalReference();
        
        Merchant_Addresses__c ma = new Merchant_Addresses__c(Id='a0lC0000003haUsIAI', account__c=account1.id);
        
        reference.setSFIds(ma, lead);
        
        System.assertEquals(account1.Id,reference.preExistingMerchantAddress.Account__c);
        System.assertEquals('a0lC0000003haUsIAI',reference.preExistingMerchantAddress.Id);
        System.assertEquals(lead, reference.preExistingLead);
    }
    
    @istest
    public static void testCanSetReview() {
        GrouponTestUtil util = new GrouponTestUtil();
        
        Account account1 = util.createAccount();
        insert account1;
        
        Reviews__c review = new Reviews__c();
        
        ExternalReference reference = new ExternalReference();
        
        reference.setPreExistingReview(review);
        
        System.assertEquals(review,reference.preExistingReview);
    }
    
    @istest
    public static void testDoesNotUpdateSFReviewObjectForUnchangedData() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        insert merchantAddress;
        
        Reviews__c review = new Reviews__c();
        review.Merchant_Address__c = merchantAddress.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        review.Facebook_of_Fans__c = 45;
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Merchant_Address__c = merchantAddress.Id;
        newreview.Account__c = account.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 24;
        newreview.Rating__c = 36;
        newreview.Review_Link__c = 'oldlink';
        newreview.Facebook_of_Fans__c = 45;
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoesNotUpdateSFReviewObjectForGoogle() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with information
        Lead lead = util.createLead();
        lead.Credit_Risk_score__c = 0.12432;
        lead.lastname = 'test';
        lead.company = 'test2';
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Google';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Source__c = 'Google';
        newreview.Number_of_Ratings__c = 24;
        newreview.Rating__c = 36;
        newreview.Review_Link__c = 'newlink';
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        facebookReference.setSFIds(null, requeryAfterConversion(lead.id));
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoesUpdateSFReviewObjectForChangedData() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        insert merchantAddress;
        
        Reviews__c review = new Reviews__c();
        review.Merchant_Address__c = merchantAddress.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Merchant_Address__c = merchantAddress.Id;
        newreview.Account__c = account.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 25;
        newreview.Rating__c = 37;
        newreview.Review_Link__c = 'newlink';
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertNotEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoesUpdateSFReviewObjectForChangedFacebookFans() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        insert merchantAddress;
        
        Reviews__c review = new Reviews__c();
        review.Merchant_Address__c = merchantAddress.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        review.Facebook_of_Fans__c = 46;
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Merchant_Address__c = merchantAddress.Id;
        newreview.Account__c = account.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 24;
        newreview.Rating__c = 36;
        newreview.Review_Link__c = 'oldlink';
        newreview.Facebook_of_Fans__c = 45;
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT rating__c, source__c, review_link__c, facebook_of_fans__c, number_of_ratings__c FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(24, reviewToCheck.number_of_ratings__c);
        System.assertEquals(36, reviewToCheck.rating__c);
        System.assertEquals('oldlink', reviewToCheck.review_link__c);
        System.assertEquals(45, reviewToCheck.facebook_of_fans__c);
        System.assertEquals('Facebook', reviewToCheck.source__c);
    }
    
    @istest
    public static void testDoesUpdateSFReviewObjectForChangedDataForUnconvertedLead() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.lead__c = lead.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 25;
        newreview.Rating__c = 37;
        newreview.Review_Link__c = 'newlink';
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertNotEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    public static void testDoesUpdateSFReviewObjectForChangedFacebookFansForUnconvertedLead() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new lead with review information
        Lead lead = util.createLead();
        
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        review.Review_Link__c = 'oldlink';
        review.Facebook_of_Fans__c = 46;
        
        insert review;
        
        String reviewId = review.Id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        ExternalReference facebookReference = new ExternalReference();
        
        // populate new review info
        Reviews__c newreview = new Reviews__c();
        newreview.Lead__c = lead.Id;
        newreview.Source__c = 'Facebook';
        newreview.Number_of_Ratings__c = 24;
        newreview.Rating__c = 36;
        newreview.Review_Link__c = 'oldlink';
        newreview.Facebook_of_Fans__c = 45;
        facebookReference.addReviewInformation(newreview);
        
        facebookReference.setPreExistingReview(review);
        
        facebookReference.save();
        
        // query for review
        Reviews__c reviewToCheck = [SELECT rating__c, review_link__c, facebook_of_fans__c, number_of_ratings__c FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(24, reviewToCheck.number_of_ratings__c);
        System.assertEquals(36, reviewToCheck.rating__c);
        System.assertEquals('oldlink', reviewToCheck.review_link__c);
        System.assertEquals(45, reviewToCheck.facebook_of_fans__c);
        System.assertEquals('Facebook', reviewToCheck.source__c);
    }
    
    
    
    private static Lead requeryAfterConversion(Id leadId) {
        return [select id, isConverted from lead where id = :leadId];
    }
    
    // TODO - move this into GrouponTestUtil
    private static void delayUntilTimeChanged(Integer delayTimeMS) {

        Integer msPerS = 1000;
        Datetime start = Datetime.now();
        Datetime current = Datetime.now();
    
        // No sleep available so this ugliness
        Integer counter = 0;
        while (current.getTime() < start.getTime() + delayTimeMS) {
            
            Long t1 = System.currentTimeMillis();
            String bigRandomString = '';
            for (Integer i = 0; i < 2000; i++) {
                bigRandomString += Crypto.getRandomLong();
            }
            for (Integer i = 0; i < 50; i++) {
                Blob cryptoKey = Crypto.generateAesKey(256);
                Blob data = Blob.valueOf(bigRandomString);
                Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
                Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
            }
            Long t2 = System.currentTimeMillis();
            
            counter++;
            current = Datetime.now();
        }
    }
    
}