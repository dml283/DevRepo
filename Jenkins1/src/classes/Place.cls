/**
 * Place model, representing Merchant Data "Place" and Salesforce "Merchant Address"
 *
**/
global class Place{

    static final String MERCHANT_ADDRESS_EXTERNAL_REFERENCE_ID = '32';
    static final String LEAD_EXTERNAL_REFERENCE_ID = '4';
    
    static final String MERCHANT_ADDRESS = 'merchant_address';
    static final String LEAD = 'lead';
    
    // linkage for Salesforce Lead
    public Lead preExistingLead = null;
    
    // linkage for Salesforce Merchant Address
    public Merchant_Addresses__c preExistingMerchantAddress = null;
    
    // top level fields
    public Map<String, ExternalReference> external_reference_map {get;set;}
    public Map<String, Score> scores {get;set;}
    public String website {get;set;}
    public String phone_number {get;set;}
    public Location location {get;set;}
    
    // constructor for REST get requests
    public Place(string MerchantAddressId){
        if(merchantAddressId != null) {
            // populate the top-level place data
            populateTopLevelFields(merchantAddressId);
            
            // populate the external reference map
            external_reference_map = new Map<String, ExternalReference>();
            buildExternalReferenceMap(merchantAddressId);
        }
    }
    
    private void populateTopLevelFields(String merchantAddressId) {
        list<Merchant_Addresses__c> addresses = [SELECT Id, location_url__c, Account__c, LastModifiedDate, credit_risk_score__c FROM Merchant_Addresses__c where Id = :merchantAddressId];
                
        if(addresses.size() > 0) {
            this.website = addresses.get(0).location_url__c;
        }
    }
    
    private void buildExternalReferenceMap(String merchantAddressId) {
    
        list<reviews__c> sobject_reviews = [SELECT id, Account__c, Merchant_Address__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c, Facebook_of_Fans__c FROM Reviews__c where Merchant_Address__c = :MerchantAddressId];
        for(reviews__c r : sobject_reviews){
            ExternalReference externalReference = new ExternalReference();
            System.debug('About to get review information for review ' + r.Id);
            externalReference.addReviewInformation(r);
            this.external_reference_map.put(externalReference.external_reference_source.source_id,externalReference);
        }
    }
    
    // constructor for REST post requests
    public Place() {}
    
    public String save() {
        
        String error = linkPlaceToCurrentSFIds();
        if(error == null) {
            if(shouldUpdateSFMerchantAddress()) {
                // if there is a merchant address, update that
                System.debug('Saving place information for merchant address ' + preExistingMerchantAddress.id);
                
                try{
                    // save!
                    database.upsert(preExistingMerchantAddress);
                } catch(Exception e){
                    system.debug(e);
                    return 'Could not upsert merchant address; ' + e.getMessage();
                }
            } else if (shouldUpdateSFLead()) {
                // if there is no merchant address, but there is a lead, update that
                
                System.debug('Saving place information for lead ' + preExistingLead.Id);
                
                try{
                    // save!
                    database.upsert(preExistingLead);
                } catch(Exception e){
                    system.debug(e);
                    return 'Could not upsert lead; ' + e.getMessage();
                }
            }
        
            // save each external reference
            if(external_reference_map != null) {
              for(String sourceId : external_reference_map.keySet()){
                 // tell each external reference to save itself - it will do so if it has data to save
                 ExternalReference externalReference = external_reference_map.get(sourceId);
                 // need to set the account id and merchant address id to each external reference,
                 // in case any of them are not yet linked to reviews
                 // TODO - may be able to remove account id if at some point, we don't need that linkage in salesforce
                 // Chris B. says that we need that linkage right now for report generation
                 
                 externalReference.setSFIds(preExistingMerchantAddress, preExistingLead);
                 externalReference.save();
              }
            }
            return null;
        } else {
            System.debug('Could not link this place to a Salesforce Merchant Address - not saving - ' + error);
            return error;
        }
    }
    
    private boolean shouldUpdateSFMerchantAddress() {
        
        Decimal automated_research_ranking = extractNewAutomatedResearchRanking();
        Decimal credit_risk_score = extractNewCreditRiskScore();
        
        // currently we only care about saving a select few fields
        if(preExistingMerchantAddress != null && anySFMerchantAddressFieldsChanged(automated_research_ranking, credit_risk_score)) {
            
            System.debug('old website: ' + preExistingMerchantAddress.location_url__c + '; new website: ' + this.website);
            System.debug('old automated_research_ranking: ' + preExistingMerchantAddress.merchant_address_arr__c + '; new automated_research_ranking: ' + automated_research_ranking);
            System.debug('old credit_risk_score: ' + preExistingMerchantAddress.credit_risk_score__c + '; new credit_risk_score: ' + credit_risk_score);
            System.debug('old phone_number: ' + preExistingMerchantAddress.phone_number__c + '; new phone_number: ' + phone_number);
            
            preExistingMerchantAddress.location_url__c = this.website;
            preExistingMerchantAddress.merchant_address_arr__c = automated_research_ranking;
            preExistingMerchantAddress.credit_risk_score__c = credit_risk_score;
            preExistingMerchantAddress.phone_number__c = phone_number;
            
            System.debug('old street_line_1: ' + preExistingMerchantAddress.street_line_1__c + '; new: ' + (location != null ? location.street_address : null));
            System.debug('old city: ' + preExistingMerchantAddress.city__c + '; new: ' + (location != null ? location.city : null));
            System.debug('old state: ' + preExistingMerchantAddress.state_province__c + '; new: ' + (location != null ? location.state : null));
            System.debug('old zip: ' + preExistingMerchantAddress.zip_postal_code__c + '; new: ' + (location != null ? location.postal_code : null));
            System.debug('old country: ' + preExistingMerchantAddress.country__c + '; new: ' + (location != null ? location.country : null));
            System.debug('old longitude: ' + preExistingMerchantAddress.longitude__c + '; new: ' + (location != null && location.lon_lat != null ? location.lon_lat.lon : null));
            System.debug('old latitude: ' + preExistingMerchantAddress.latitude__c + '; new: ' + (location != null && location.lon_lat != null ? location.lon_lat.lat : null));
            
            preExistingMerchantAddress.street_line_1__c = location != null ? location.street_address : null;
            preExistingMerchantAddress.city__c = location != null ? location.city : null;
            preExistingMerchantAddress.state_province__c = location != null ? location.state : null;
            preExistingMerchantAddress.zip_postal_code__c = location != null ? location.postal_code : null;
            preExistingMerchantAddress.country__c = location != null ? location.country : null;
            if(location != null) {
                preExistingMerchantAddress.longitude__c = location.lon_lat != null ? location.lon_lat.lon : null;
                preExistingMerchantAddress.latitude__c = location.lon_lat != null ? location.lon_lat.lat : null;
            } else {
                preExistingMerchantAddress.longitude__c = null;
                preExistingMerchantAddress.latitude__c = null;
            }
            
            return true;
        } else {
            return false;
        }
    }
    
    private boolean areAnyMerchantAddressLocationFieldsNotNull() {
        return preExistingMerchantAddress.street_line_1__c != null ||
               preExistingMerchantAddress.city__c != null ||
               preExistingMerchantAddress.state_province__c != null ||
               preExistingMerchantAddress.country__c != null ||
               preExistingMerchantAddress.zip_postal_code__c != null ||
               preExistingMerchantAddress.latitude__c != null ||
               preExistingMerchantAddress.longitude__c != null;
    }
    
    private boolean anySFMerchantAddressLocationFieldsChanged() {
        return 
                (location.lon_lat == null && (preExistingMerchantAddress.latitude__c != null || preExistingMerchantAddress.longitude__c != null)) ||
                (location.lon_lat != null && (
                    location.lon_lat.lon != preExistingMerchantAddress.longitude__c ||
                    location.lon_lat.lat != preExistingMerchantAddress.latitude__c
                )) ||
                preExistingMerchantAddress.street_line_1__c != location.street_address ||
                preExistingMerchantAddress.city__c != location.city ||
                preExistingMerchantAddress.state_province__c != location.state ||
                preExistingMerchantAddress.zip_postal_code__c != location.postal_code ||
                preExistingMerchantAddress.country__c != location.country;
    
    }
    
    private boolean anySFMerchantAddressFieldsChanged(Decimal automated_research_ranking, Decimal credit_risk_score) {
        return
            preExistingMerchantAddress.location_url__c != this.website ||
            preExistingMerchantAddress.merchant_address_arr__c != automated_research_ranking ||
            preExistingMerchantAddress.credit_risk_score__c != credit_risk_score ||
            preExistingMerchantAddress.phone_number__c != phone_number ||
            (areAnyMerchantAddressLocationFieldsNotNull() && location == null) ||
            (location != null && anySFMerchantAddressLocationFieldsChanged());
    }
    
    private boolean shouldUpdateSFLead() {
        Decimal credit_risk_score = extractNewCreditRiskScore();
        
        // currently we only care about saving the credit risk score
        if(preExistingLead != null && preExistingLead.isConverted != True && anySFLeadFieldsChanged(credit_risk_score)) {
            
            System.debug('old credit_risk_score: ' + preExistingLead.credit_risk_score__c + '; new credit_risk_score: ' + credit_risk_score);
            
            preExistingLead.credit_risk_score__c = credit_risk_score;
            
            preExistingLead.street = location != null ? location.street_address : null;
            preExistingLead.city = location != null ? location.city : null;
            preExistingLead.state = location != null ? location.state : null;
            preExistingLead.postalCode = location != null ? location.postal_code : null;
            preExistingLead.country = location != null ? location.country : null;
            preExistingLead.website = website;
            if(location != null) {
                preExistingLead.longitude__c = location.lon_lat != null ? location.lon_lat.lon : null;
                preExistingLead.latitude__c = location.lon_lat != null ? location.lon_lat.lat : null;
            } else {
                preExistingLead.longitude__c = null;
                preExistingLead.latitude__c = null;
            }
           
            return true;
        } else {
            return false;
        }
    }
    
    private boolean areAnyLeadLocationFieldsNotNull() {
        return preExistingLead.street != null ||
               preExistingLead.city != null ||
               preExistingLead.state != null ||
               preExistingLead.country != null ||
               preExistingLead.postalcode != null ||
               preExistingLead.latitude__c != null ||
               preExistingLead.longitude__c != null;
    }
    
    private boolean anySFLeadFieldsChanged(Decimal credit_risk_score) {
        return
            preExistingLead.credit_risk_score__c != credit_risk_score ||
            (areAnyLeadLocationFieldsNotNull() && location == null) ||
            (location != null && anySFLeadLocationFieldsChanged());
    
    }
    
    private boolean anySFLeadLocationFieldsChanged() {
        return
                (location.lon_lat == null && (preExistingLead.latitude__c != null || preExistingLead.longitude__c != null)) ||
                (location.lon_lat != null && (
                    location.lon_lat.lon != preExistingLead.longitude__c ||
                    location.lon_lat.lat != preExistingLead.latitude__c
                )) ||
                preExistingLead.street != location.street_address ||
                preExistingLead.city != location.city ||
                preExistingLead.state != location.state ||
                preExistingLead.postalCode != location.postal_code ||
                preExistingLead.country != location.country ||
                preExistingLead.website != website;
    }
    
    private Decimal extractNewAutomatedResearchRanking() {
        return extractNewScoreValue('automated_research_ranking');
    }
    
    private Decimal extractNewCreditRiskScore() {
        return extractNewScoreValue('m3_risk_model');
    }
    
    private Decimal extractNewScoreValue(String scoreName) {
        // pull out the value for the desired score, if there is one present
        
        try {
            if(scores != null && scores.containsKey(scoreName)) {
                Score scoreInfo = scores.get(scoreName);
                if(scoreInfo != null) {
                    // need to take 6 digits after decimal max
                    return Decimal.valueOf((String)scoreInfo.value).setScale(6, RoundingMode.HALF_UP);
                }
            }
        } catch (Exception e) {
            system.debug(e);
        }
        // didn't find it - return null
        return null;
    }
    
    private String linkPlaceToCurrentSFIds() {
        boolean linkedToSFObject = false;
        
        // identify merchant address id in the external reference map
        if(external_reference_map != null && external_reference_map.containsKey(MERCHANT_ADDRESS_EXTERNAL_REFERENCE_ID)) {
            ExternalReference sfAccountAddressExtRef = external_reference_map.get(MERCHANT_ADDRESS_EXTERNAL_REFERENCE_ID);
            
            // found the merchant address id
            Id SFMerchantAddressId = sfAccountAddressExtRef.external_reference_id;
            
            System.debug('Working with merchant address record ' + SFMerchantAddressId);
            
            if(SFMerchantAddressId != null) {
                List<Merchant_Addresses__c> addresses = [SELECT Id, street_line_1__c, city__c, state_province__c, zip_postal_code__c, country__c, longitude__c, latitude__c, location_url__c, merchant_address_arr__c, credit_risk_score__c, phone_number__c, Account__c FROM Merchant_Addresses__c where Id = :SFMerchantAddressId];

                if(addresses != null && addresses.size() > 0) {
                    preExistingMerchantAddress = addresses.get(0);
                } else {
                    // TODO - when we write the ability to create new merchant addresses, this will need to go away
                    return 'Could not find account for merchant address id ' + SFMerchantAddressId;
                }
            
                linkReviewMetadataToCurrentSFIds(MERCHANT_ADDRESS);
            
                linkedToSFObject = true;
            }
        }
        else if (external_reference_map != null && external_reference_map.containsKey(LEAD_EXTERNAL_REFERENCE_ID)) {
            ExternalReference sfLeadExtRef = external_reference_map.get(LEAD_EXTERNAL_REFERENCE_ID);
            
            // found the lead id
            Id sfLeadId = sfLeadExtRef.external_reference_id;
            
            System.debug('Working with lead id ' + sfLeadId);
            
            
            list<Lead> leads = null;
            
            if(sfLeadId != null) {
                // need to run another query to find this lead
                leads = [SELECT Id, street, city, state, country, postalcode, longitude__c, latitude__c, credit_risk_score__c, website, IsConverted FROM Lead where Id = :sfLeadId];
            }
            
            if(leads != null && leads.size() > 0) {
                if(leads.get(0).IsConverted != True) {
                    preExistingLead = leads.get(0);
                    linkReviewMetadataToCurrentSFIds(LEAD);
                } else {
                    return 'Lead ' + sfLeadId + ' has already been converted; not updating it';
                }
            } else {
                // TODO - when we write the ability to create new leads, this will need to go away
                return 'Could not find lead for lead id ' + sfLeadId;
            }
            linkedToSFObject = true;
        }
        
        if(!linkedToSFObject) {
            // if we could not successfully populate sf ids based on merchant address id or lead id
            // can't create exceptions without a dummy exception class, which seems silly, so just return null
            // TODO - create new leads or merchant addresses in the future
            return 'Cannot find lead or merchant address external reference for this place';
        } else {
            return null;
        }
    }
    
    private void linkReviewMetadataToCurrentSFIds(String objectType) {
    
        list<reviews__c> sobject_reviews = new list<reviews__c>();
        
        if(objectType == MERCHANT_ADDRESS) {
            // grab review info for this merchant address
            sobject_reviews = [SELECT id, Lead__c, Account__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c, Facebook_of_Fans__c FROM Reviews__c where Merchant_Address__c = :preExistingMerchantAddress.Id];
            System.debug('Found ' + sobject_reviews.size() + ' reviews for merchant address ' + preExistingMerchantAddress.Id);
        
        } else if (objectType == LEAD) {
            // grab review info for this merchant address
            sobject_reviews = [SELECT id, Lead__c, Account__c, Source__c, Number_of_Ratings__c, Rating__c, Review_Link__c, Facebook_of_Fans__c FROM Reviews__c where Lead__c = :preExistingLead.Id];
            System.debug('Found ' + sobject_reviews.size() + ' reviews for lead ' + preExistingLead.Id);
        }
        
        // link each SF review metadata to a corresponding external reference
        for(reviews__c r : sobject_reviews) {
            // get the corresponding external reference
            String sourceId = ExternalReferenceSource.getSourceIdByName(r.Source__c);
            System.debug('Current review source is ' + sourceId);
            ExternalReference externalReference = this.external_reference_map.get(sourceId);
            
            if(externalReference != null) {
                // there is an existing external reference for this review
                System.debug('Found external reference for ' + sourceId);

                // link the review
                externalReference.setPreExistingReview(r);
            }
        }
    }
    
}