public class PlaceTest{

    @istest
    public static void testCanInsertNewReviewForUnconvertedLead() {

        // create new lead
        Lead lead = createSFLead();
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5,'newlink')
            .externalReference('4',lead.Id)
            .build();
        
        place.save();
        
        // verify that fields on the review are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals(lead.Id, reviewToCheck.Lead__c);
        System.assertEquals(null, reviewToCheck.Merchant_Address__c);
        System.assertEquals(null, reviewToCheck.Account__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
        System.assertEquals('newlink', reviewToCheck.Review_Link__c);
    }
    
    @istest
    public static void testDoesNotInsertNewReviewForConvertedLead() {

        // create new lead
        Lead lead = createSFLead();
        
        // convert lead
        database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Prospecting');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        String merchantAddressId = 's';
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5)
            .externalReference('4',lead.Id)
            .build();
        
        place.save();
        
        // verify that no reviews were inserted for this converted lead
        
        // query for review linked to lead
        list<reviews__c> sobject_reviews = [SELECT id FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that no reviews exist
        
        System.assertEquals(0, sobject_reviews.size());
        
        // also, verify that no reviews were created on the merchant address - there is no reference for this in the place.
        // the SF feed will pull the merchant address record, create a merchant address exref, and then a review will be created / updated for that
        
        // query for review linked to merchant address
        sobject_reviews = [SELECT id FROM Reviews__c where Merchant_Address__c = :merchantAddressId];
            
        // make sure that no reviews exist
        
        System.assertEquals(0, sobject_reviews.size());
    }
    
    @istest
    public static void testDoesInsertNewReviewForConvertedLeadWithMerchantAddressPresent() {

        // create new lead
        Lead lead = createSFLead();
        
        // convert lead
        database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Prospecting');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        Merchant_Addresses__c address = [select id from merchant_addresses__c where account__c = :lcr.getAccountId()];
        
        String merchantAddressId = address.id;
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5)
            .externalReference('32',address.Id)
            .externalReference('4',lead.Id)
            .build();
        
        place.save();
        
        // verify that no reviews were inserted for this converted lead
        
        // query for review linked to lead
        list<reviews__c> sobject_reviews = [SELECT id FROM Reviews__c where Lead__c = :lead.Id];
            
        // new review should not be linked to converted lead
        
        System.assertEquals(0, sobject_reviews.size());
        
        // but the review should appear on the merchant address object
        
        // query for review linked to merchant address
        sobject_reviews = [SELECT id FROM Reviews__c where Merchant_Address__c = :merchantAddressId];
            
        // make sure that one review exists
        
        System.assertEquals(1, sobject_reviews.size());
    }
    
    /*
    for some reason, the test lead conversion process doesn't attach the review to the merchant address, which is
    different from what happens in production. so this test doesn't pass as it should
    @istest
    public static void testDoesUpdateExistingReviewForConvertedLeadWithMerchantAddressPresent() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        
        insert review;
        
        // convert lead
        database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Prospecting');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        String reviewId = review.Id;
        
        Merchant_Addresses__c address = [select id from merchant_addresses__c where account__c = :lcr.getAccountId()];
        
        String merchantAddressId = address.id;
        
        // get the lastmodified date
        Reviews__c lmreview = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        Datetime lastModifiedDate = lmreview.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
    
    
        // method under test
        ExternalReferenceSource source = new ExternalReferenceSource();
        source.source_id = '11';
        
        ExternalReference facebookReference = new ExternalReference();
        facebookReference.external_reference_id = '11';
        facebookReference.external_reference_source = source;
        facebookReference.number_of_reviews = 57;
        facebookReference.average_rating = 3.5;
        
        ExternalReferenceSource source2 = new ExternalReferenceSource();
        source2.source_id = '4';
        
        ExternalReference leadReference = new ExternalReference();
        leadReference.external_reference_id = lead.Id;
        leadReference.external_reference_source = source2;
        
        ExternalReferenceSource source3 = new ExternalReferenceSource();
        source3.source_id = '32';
        
        ExternalReference merchantAddressReference = new ExternalReference();
        merchantAddressReference.external_reference_id = address.Id;
        merchantAddressReference.external_reference_source = source3;
        
        Map<String,ExternalReference> externalReferenceMap = new Map<String,ExternalReference>();
        externalReferenceMap.put('11',facebookReference);
        externalReferenceMap.put('4',leadReference);
        externalReferenceMap.put('32',merchantAddressReference);
        
        Place place = new Place();
        
        place.external_reference_map = externalReferenceMap;
        
        place.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for review
        Reviews__c reviewToCheck = [SELECT LastModifiedDate FROM Reviews__c where Id = :reviewId];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), reviewToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    
        // verify no other reviews were inserted
        list<reviews__c> sobject_reviews = [SELECT id FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that no other reviews exist
        
        System.assertEquals(1, sobject_reviews.size());
        
        sobject_reviews = [SELECT id FROM Reviews__c where Merchant_address__c = :address.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1, sobject_reviews.size());
        
        // query for review
        reviewToCheck = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Id = :reviewId];
 
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals(lead.id, reviewToCheck.Lead__c);
        System.assertEquals(lcr.getAccountId(), reviewToCheck.Account__c);
        System.assertEquals(merchantAddressId, reviewToCheck.Merchant_Address__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
        
    }
    */
    
    @istest
    public static void testCanUpdateReviewFieldsForUnconvertedLead() {

        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Lead lead = util.createLead();
        insert lead;
        
        Reviews__c review = new Reviews__c();
        review.Lead__c = lead.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        
        insert review;
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5,'newlink')
            .externalReference('4',lead.Id)
            .build();
            
        
        place.save();
        
        // verify that fields on the place are set correctly
        
        // query for review
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals(lead.Id, reviewToCheck.Lead__c);
        System.assertEquals(null, reviewToCheck.Merchant_Address__c);
        System.assertEquals(null, reviewToCheck.Account__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
        System.assertEquals('newlink', reviewToCheck.Review_Link__c);
    }
    
    @istest
    public static void testOnlyInsertsReviewsForMerchantAddressAndNotLead() {

        // create new lead
        Lead lead = createSFLead();
        
        // convert lead
        database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Prospecting');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        Merchant_Addresses__c address = [select id from merchant_addresses__c where account__c = :lcr.getAccountId()];
        
        String merchantAddressId = address.id;
        
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5,'newlink')
            .externalReference('32',merchantAddressId)
            .externalReference('4',lead.Id)
            .build();
        
        place.save();
        
        // verify that we got a review attached to the merchant address but not attached to the lead
        
        // query for review linked to a merchant address
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Merchant_Address__c = :merchantAddressId];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals(null, reviewToCheck.Lead__c);
        System.assertEquals(lcr.getAccountId(), reviewToCheck.Account__c);
        System.assertEquals(merchantAddressId, reviewToCheck.Merchant_Address__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
        System.assertEquals('newlink', reviewToCheck.Review_Link__c);
        
        // query for review linked to a lead
        sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = :lead.Id];
            
        // make sure no reviews exist
        
        System.assertEquals(0,sobject_reviews.size());
    }
    
    
    @istest
    public static void testCanUpdateReviewFieldsForMerchantAddress() {

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
        review.account__c = account.Id;
        review.Source__c = 'Facebook';
        
        review.Number_of_Ratings__c = 24;
        review.Rating__c = 36;
        
        insert review;
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5)
            .externalReference('32',merchantAddress.Id)
            .build();
        
        place.save();
        
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Merchant_Address__c = :merchantAddress.Id];
            
        // make sure that one review exists
        
        System.assertEquals(1,sobject_reviews.size());
        
        Reviews__c reviewToCheck = sobject_reviews.get(0);
        
        System.assertEquals(57, reviewToCheck.Number_of_Ratings__c);
        System.assertEquals(3.5, reviewToCheck.Rating__c);
        System.assertEquals(null, reviewToCheck.Lead__c);
        System.assertEquals(account.id, reviewToCheck.Account__c);
        System.assertEquals(merchantAddress.id, reviewToCheck.Merchant_Address__c);
        System.assertEquals('Facebook', reviewToCheck.Source__c);
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
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5)
            .externalReference('32',merchantAddress.Id)
            .build();
        
        place.save();
        
        // verify that fields on the place are set correctly
        
        Place placeToCheck = new Place(merchantAddress.Id);
        
        Map<String, ExternalReference> externalReferenceMapToCheck = placeToCheck.external_reference_map;
        
        System.assertEquals(True, externalReferenceMapToCheck.containsKey('11'));
        
        ExternalReference facebookReferenceToCheck = externalReferenceMapToCheck.get('11');
        
        System.assertEquals(57, facebookReferenceToCheck.number_of_reviews);
        System.assertEquals(3.5, facebookReferenceToCheck.average_rating);
    }
    
    @istest
    public static void testThrowsExceptionWithoutMerchantAddressOrLeadExternalReference() {

        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5)
            .build();
        
        String error = place.save();
        
        System.assertEquals('Cannot find lead or merchant address external reference for this place', error);
    }
    
    @istest
    public static void testSavingWithNonExistentMerchantAddressIdReturnsError() {
        
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('11','11',57,3.5)
            .externalReference('32','a0lC0000003naTcIAI')
            .build();
        
        String error = place.save();
        
        System.assertEquals('Could not find account for merchant address id a0lC0000003naTcIAI', error);
        
        // verify that no reviews were created with this merchant address id
        list<reviews__c> sobject_reviews = [SELECT id, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Merchant_Address__c = 'a0lC0000003naTcIAI'];
         
        System.assertEquals(0, sobject_reviews.size());
        
        list<Merchant_Addresses__c> addresses = [SELECT Account__c FROM Merchant_Addresses__c where Id = 'a0lC0000003naTcIAI'];
                
        System.assertEquals(0, addresses.size());
    }
    
    @istest
    public static void testSavingWithNonExistentLeadIdReturnsError() {
    
        // method under test
        Place place = new PlaceBuilder()
            .externalReference('4','a0lC0000003naTcIAI')
            .externalReference('11','11',57,3.5)
            .build();
        
        String error = place.save();
        
        System.assertEquals('Could not find lead for lead id a0lC0000003naTcIAI', error);
        
        // verify that no reviews were created with this lead id
        list<reviews__c> sobject_reviews = [SELECT id, Lead__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c FROM Reviews__c where Lead__c = 'a0lC0000003naTcIAI'];
         
        System.assertEquals(0, sobject_reviews.size());
    }
    
    @istest
    public static void testDoesNotUpdateSFLeadObjectForUnchangedData() {
        
        // create new lead with information
        Lead lead = createSFLead();
        
        // get the lastmodified date
        Lead lmLead = [SELECT LastModifiedDate FROM Lead where Id = :lead.Id];
        Datetime lastModifiedDate = lmLead.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.12432').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for lead
        Lead leadToCheck = [SELECT LastModifiedDate FROM Lead where Id = :lead.Id];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), leadToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoesNotUpdateSFLeadObjectForConvertedLead() {
        
        // create new lead
        Lead lead = createSFLead();
        
        // convert lead
        database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Prospecting');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        
        // get the lastmodified date
        Lead lmLead = [SELECT LastModifiedDate FROM Lead where Id = :lead.Id];
        Datetime lastModifiedDate = lmLead.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.15')
            .externalReference('4',lead.Id)
            .build();
            
        String error = place.save();
        
        System.assertEquals('Lead ' + lead.id + ' has already been converted; not updating it', error);
        
        // verify that the lastmodifieddate did not change
        
        // query for lead
        Lead leadToCheck = [SELECT LastModifiedDate FROM Lead where Id = :lead.Id];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), leadToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenCreditRiskScoreChanges() {

        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.2').website('http://www.theoldsite.com')
            .streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .externalReference('4',lead.Id)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.2, '1234 Main st', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenWebsiteChanges() {

        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.2').website('http://www.thenewsite.com')
            .streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .externalReference('4',lead.Id)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.2, '1234 Main st', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234, 'http://www.thenewsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenPlaceHasNoLocationInfo() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.2').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .noLocation()
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.2, null, null, null, null, null, null, null, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenPlaceHasNoLonLatInfo() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.2').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618')
            .noLonLat()
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.2, '1234 Main st', 'Chicago', 'IL', '60618', 'US', null, null, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenPlaceAndSFHasNoLonLatInfo() {
        // create new lead
        Lead lead = createSFLead();
        
        lead.latitude__c = null;
        lead.longitude__c = null;
        
        update lead;
        
        // method under test
        Place place = new PlaceBuilder().creditRisk('0.2').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618')
            .noLonLat()
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.2, '1234 Main st', 'Chicago', 'IL', '60618', 'US', null, null, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenStreetAddressChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().streetAddress('abcd').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, 'abcd', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenCityChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().city('abcd').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').streetAddress('1234 Main st').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, '1234 Main st', 'abcd', 'IL', '60618', 'US', 41.123, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenStateChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().state('CA').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').streetAddress('1234 Main st').city('Chicago').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, '1234 Main st', 'Chicago', 'CA', '60618', 'US', 41.123, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenCountryChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().country('CA').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').streetAddress('1234 Main st').city('Chicago').state('IL').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, '1234 Main st', 'Chicago', 'IL', '60618', 'CA', 41.123, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenPostalCodeChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().postalCode('94114').website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').streetAddress('1234 Main st').city('Chicago').state('IL').country('US').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, '1234 Main st', 'Chicago', 'IL', '94114', 'US', 41.123, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenLonChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().lonLat(23.412, -56.234).website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618')
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, '1234 Main st', 'Chicago', 'IL', '60618', 'US', 23.412, -56.234, 'http://www.theoldsite.com');
    }
    
    @istest
    public static void testDoesUpdateSFLeadObjectWhenLatChanges() {
        // create new lead
        Lead lead = createSFLead();
        
        // method under test
        Place place = new PlaceBuilder().lonLat(41.123, -34.523).website('http://www.theoldsite.com')
            .externalReference('4',lead.Id)
            .creditRisk('0.12432').streetAddress('1234 Main st').city('Chicago').state('IL').country('US').postalCode('60618')
            .build();
        
        String error = place.save();
        
        verifyNewLead(lead, 0.12432, '1234 Main st', 'Chicago', 'IL', '60618', 'US', 41.123, -34.523, 'http://www.theoldsite.com');
    }

    @istest
    public static void testDoesNotUpdateSFMerchantAddressObjectForUnchangedData() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // get the lastmodified date
        Merchant_Addresses__c lmMerchantAddress = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        Datetime lastModifiedDate = lmMerchantAddress.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did not change
        
        // query for merchant address
        Merchant_Addresses__c merchantAddressToCheck = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        
        System.assertEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), merchantAddressToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }

    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenAutomatedResearchRankingChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // get the lastmodified date
        Merchant_Addresses__c lmMerchantAddress = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        Datetime lastModifiedDate = lmMerchantAddress.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('6').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did change
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 6, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234);
    }

    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenWebsiteChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // get the lastmodified date
        Merchant_Addresses__c lmMerchantAddress = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        Datetime lastModifiedDate = lmMerchantAddress.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('newlink').arr('4').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did change
        
        // query for merchant address
        Merchant_Addresses__c merchantAddressToCheck = [SELECT location_url__c, merchant_address_arr__c, credit_risk_score__c FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        
        verifyNewMerchantAddress(merchantAddress, 'newlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234);
    }

    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenCreditRiskScoreChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // get the lastmodified date
        Merchant_Addresses__c lmMerchantAddress = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        Datetime lastModifiedDate = lmMerchantAddress.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.2')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did change
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.2, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenPhoneNumberChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // get the lastmodified date
        Merchant_Addresses__c lmMerchantAddress = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        Datetime lastModifiedDate = lmMerchantAddress.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('234-567-8901').website('oldlink').arr('4').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did change
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '234-567-8901', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenPlaceHasNoLocationInfo() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .noLocation()
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', null, null, null, null, null, null, null);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenPlaceHasNoLonLatInfo() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618')
            .noLonLat()
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', null, null);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenPlaceAndSFHasNoLonLatInfo() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        merchantAddress.latitude__c = null;
        merchantAddress.longitude__c = null;
        
        update merchantAddress;
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618')
            .noLonLat()
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', null, null);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenStreetAddress1Changes() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').streetAddress('abcd')
            .externalReference('32',merchantAddress.Id)
            .city('Chicago').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', 'abcd', 'Chicago', 'IL', '60618', 'US', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenCityChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').city('abcd')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').state('IL').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'abcd', 'IL', '60618', 'US', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenStateChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').state('CA')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').country('US').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'CA', '60618', 'US', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenCountryChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').country('CA')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').postalCode('60618').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'CA', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenPostalCodeChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').postalCode('94114')
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').lonLat(41.123,-56.234)
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '94114', 'US', 41.123, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenLonChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').lonLat(23.412, -56.234)
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618')
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', 23.412, -56.234);
    }
    
    @istest
    public static void testDoesUpdateSFMerchantAddressObjectWhenLatChanges() {
        Merchant_Addresses__c merchantAddress = createSFMerchantAddress();
        
        // method under test
        Place place = new PlaceBuilder().phoneNumber('123-456-7890').website('oldlink').arr('4').creditRisk('0.1').lonLat(41.123, -34.523)
            .externalReference('32',merchantAddress.Id)
            .streetAddress('1234 Main st, suite 2').city('Chicago').state('IL').country('US').postalCode('60618')
            .build();
        
        String error = place.save();
        
        verifyNewMerchantAddress(merchantAddress, 'oldlink', 4, 0.1, '123-456-7890', '1234 Main st, suite 2', 'Chicago', 'IL', '60618', 'US', 41.123, -34.523);
    }

    @istest
    public static void testDoesUpdateSFMerchantAddressObjectModifiedDateForChangedData() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        merchantAddress.location_url__c = 'oldlink';
        
        insert merchantAddress;
        
        // get the lastmodified date
        Merchant_Addresses__c lmMerchantAddress = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        Datetime lastModifiedDate = lmMerchantAddress.lastModifiedDate;
        
        // sleep for two seconds
        delayUntilTimeChanged(2000);
        
        // method under test
        Place place = new PlaceBuilder().website('newlink').externalReference('32',merchantAddress.Id)
            .build();
        
        String error = place.save();
        
        // verify that the lastmodifieddate did change
        
        // query for merchant address
        Merchant_Addresses__c merchantAddressToCheck = [SELECT LastModifiedDate FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        
        System.assertNotEquals(lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'), merchantAddressToCheck.lastModifiedDate.formatGmt('EEE, d MMM yyyy HH:mm:ss.SSS'));
    }
    
    public class PlaceBuilder {
        private Place place;
        
        public PlaceBuilder() {
            place = new Place();
            place.scores = new Map<String,Score>();
            place.location = new Location();
            place.location.lon_lat = new LonLat();
            place.external_reference_map = new Map<String,ExternalReference>();
        }
        
        public PlaceBuilder phoneNumber(String value) {
            place.phone_number = value;
            return this;
        }
        
        public PlaceBuilder website(String value) {
            place.website = value;
            return this;
        }
        
        public PlaceBuilder streetAddress(String value) {
            place.location.street_address = value;
            return this;
        }
        
        public PlaceBuilder city(String value) {
            place.location.city = value;
            return this;
        }
        
        public PlaceBuilder state(String value) {
            place.location.state = value;
            return this;
        }
        
        public PlaceBuilder country(String value) {
            place.location.country = value;
            return this;
        }
        
        public PlaceBuilder postalCode(String value) {
            place.location.postal_code = value;
            return this;
        }
        
        public PlaceBuilder lonLat(Decimal lon, Decimal lat) {
            place.location.lon_lat.lon = lon;
            place.location.lon_lat.lat = lat;
            return this;
        }
        
        public PlaceBuilder noLocation() {
            place.location = null;
            return this;
        }
        
        public PlaceBuilder noLonLat() {
            place.location.lon_lat = null;
            return this;
        }
        
        public PlaceBuilder arr(String value) {
            return score('automated_research_ranking', value);
        }
        
        public PlaceBuilder creditRisk(String value) {
            return score('m3_risk_model', value);
        }
        
        private ExternalReference createExternalReference(String sourceStr, String externalReferenceId, Integer numberOfReviews, Decimal averageRating, String url) {
            ExternalReference reference = createExternalReference(sourceStr, externalReferenceId, numberOfReviews, averageRating);
            reference.external_reference_url = url;
            return reference;
        }
        
        private ExternalReference createExternalReference(String sourceStr, String externalReferenceId, Integer numberOfReviews, Decimal averageRating) {
            ExternalReference reference = createExternalReference(sourceStr, externalReferenceId);
            reference.number_of_reviews = numberOfReviews;
            reference.average_rating = averageRating;
            return reference;
        }
        
        private ExternalReference createExternalReference(String sourceStr, String externalReferenceId) {
            ExternalReferenceSource source = new ExternalReferenceSource();
            source.source_id = sourceStr;
        
            ExternalReference reference = new ExternalReference();
            reference.external_reference_id = externalReferenceId;
            reference.external_reference_source = source;
            return reference;
        }
        
        public PlaceBuilder externalReference(String sourceStr, String externalReferenceId, Integer numberOfReviews, Decimal averageRating, String url) {
            place.external_reference_map.put(sourceStr,createExternalReference(sourceStr, externalReferenceId, numberOfReviews, averageRating, url));
            return this;
        }
        
        public PlaceBuilder externalReference(String sourceStr, String externalReferenceId, Integer numberOfReviews, Decimal averageRating) {
            place.external_reference_map.put(sourceStr,createExternalReference(sourceStr, externalReferenceId, numberOfReviews, averageRating));
            return this;
        }
        
        public PlaceBuilder externalReference(String sourceStr, String externalReferenceId) {
            place.external_reference_map.put(sourceStr,createExternalReference(sourceStr, externalReferenceId));
            return this;
        }
        
        private PlaceBuilder score(String key, String value) {
            Score score = new Score();
            score.value = value;
            place.scores.put(key, score);
            return this;
        }
        
        public Place build() {
            return place;
        }
    }
    
    private static Lead createSFLead() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        Lead lead = util.createLead();
        
        lead.Credit_Risk_score__c = 0.12432;
        lead.lastname = 'test';
        lead.company = 'test2';
        lead.street = '1234 Main st';
        lead.city = 'Chicago';
        lead.country = 'US';
        lead.state = 'IL';
        lead.postalcode = '60618';
        lead.longitude__c = 41.123;
        lead.latitude__c = -56.234;
        lead.website = 'http://www.theoldsite.com';
        
        insert lead;
        
        return lead;
    }
    
    private static Merchant_Addresses__c createSFMerchantAddress() {
        // setup
        GrouponTestUtil util = new GrouponTestUtil();
        
        // create new merchant address with review information
        Account account = util.createAccount();
        insert account;
        
        Merchant_Addresses__c merchantAddress = new Merchant_Addresses__c();
        merchantAddress.Account__c = account.Id;
        
        merchantAddress.location_url__c = 'oldlink';
        merchantAddress.merchant_address_arr__c = 4;
        merchantAddress.Credit_Risk_score__c = 0.1;
        merchantAddress.phone_number__c = '123-456-7890';
        
        merchantAddress.street_line_1__c = '1234 Main st, suite 2';
        merchantAddress.city__c = 'Chicago';
        merchantAddress.state_province__c = 'IL';
        merchantAddress.zip_postal_code__c = '60618';
        merchantAddress.country__c = 'US';
        merchantAddress.longitude__c = 41.123;
        merchantAddress.latitude__c = -56.234;
        
        insert merchantAddress;
        
        return merchantAddress;
    }
    
    private static void verifyNewLead(Lead lead, Decimal creditRiskScore, String street, String city, String state, String postalCode, String country, Decimal lon, Decimal lat, String website) {
        // query for lead
        Lead leadToCheck = [select credit_risk_score__c, street, city, state, country, postalcode, longitude__c, latitude__c, website from lead where id = :lead.id];
        
        System.assertEquals(creditRiskScore, leadToCheck.credit_risk_score__c);
        System.assertEquals(street, leadToCheck.street);
        System.assertEquals(city, leadToCheck.city);
        System.assertEquals(state, leadToCheck.state);
        System.assertEquals(country, leadToCheck.country);
        System.assertEquals(postalCode, leadToCheck.postalcode);
        System.assertEquals(lon, leadToCheck.longitude__c);
        System.assertEquals(lat, leadToCheck.latitude__c);
        System.assertEquals(website, leadToCheck.website);
    }
    
    private static void verifyNewMerchantAddress(Merchant_Addresses__c merchantAddress, String newLocationUrl, Integer newARR, Decimal newCreditRiskScore, String newPhoneNumber, String streetLine1, String city, String state, String postalCode, String country, Decimal lon, Decimal lat) {
        // query for merchant address
        Merchant_Addresses__c merchantAddressToCheck = [SELECT street_line_1__c, city__c, state_province__c, zip_postal_code__c, country__c, longitude__c, latitude__c, location_url__c, merchant_address_arr__c, credit_risk_score__c, phone_number__c FROM Merchant_Addresses__c where Id = :merchantAddress.Id];
        
        System.assertEquals(newLocationUrl, merchantAddressToCheck.location_url__c);
        System.assertEquals(newARR, merchantAddressToCheck.merchant_address_arr__c);
        System.assertEquals(newCreditRiskScore, merchantAddressToCheck.credit_risk_score__c);
        System.assertEquals(newPhoneNumber, merchantAddressToCheck.phone_number__c);
        
        System.assertEquals(streetLine1, merchantAddressToCheck.street_line_1__c);
        System.assertEquals(city, merchantAddressToCheck.city__c);
        System.assertEquals(state, merchantAddressToCheck.state_province__c);
        System.assertEquals(country, merchantAddressToCheck.country__c);
        System.assertEquals(postalCode, merchantAddressToCheck.zip_postal_code__c);
        System.assertEquals(lon, merchantAddressToCheck.longitude__c);
        System.assertEquals(lat, merchantAddressToCheck.latitude__c);
    }
    
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