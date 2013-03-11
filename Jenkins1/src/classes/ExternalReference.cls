/**
 * External reference model. Contains information for Salesforce Review metadata linked to Merchant Addresses.
**/

global class ExternalReference {    
    // linkage ids to Salesforce objects
    public Reviews__c preExistingReview;
    public Merchant_Addresses__c preExistingMerchantAddress;
    public Lead preExistingLead;
    
    // actual data
    public String external_reference_id {get;set;}
    public String external_reference_url {get;set;}
    public ExternalReferenceSource external_reference_source {get;set;}
    public Integer number_of_reviews {get;set;}
    public Decimal average_rating {get;set;}
    public Decimal likes {get;set;}
    public String external_access_timestamp {get;set;}
    
    public ExternalReference(){}
    
    // populate object based on review information
    public void addReviewInformation(reviews__c review) {
        this.external_reference_source = new ExternalReferenceSource(review);
        if(review.Number_of_Ratings__c != null) {
            this.number_of_reviews = review.Number_of_Ratings__c.intValue();
        }
        this.average_rating = review.Rating__c;
        this.external_reference_url = review.Review_Link__c;
        this.likes = review.Facebook_of_Fans__c;
    }
    
    // set Salesforce Account and Merchant Address linkages
    public void setSFIds(Merchant_Addresses__c merchantAddress, Lead lead) {
        System.debug('External reference getting account id ' + (merchantAddress != null ? merchantAddress.Account__c : null) + '; merchant address id ' + (merchantAddress != null ? merchantAddress.Id : null) + '; lead id ' + (lead != null ? lead.id : null));
        preExistingMerchantAddress = merchantAddress;
        preExistingLead = lead;
    }
    
    // set Salesforce Review linkage
    public void setPreExistingReview(Reviews__c review) {
        System.debug('External reference reviewId ' + review.id);   
        this.preExistingReview = review;
    }
    
    // save data - currently only review information
    public void save(){
        // save review information
        if(external_reference_source != null) {
            // grab the review source    
            String sourceName = external_reference_source.getSourceName();
            
            if(sourceName == null) {
                System.debug('Could not find source for id ' + external_reference_source.source_id);
            } else if (hasReviewFieldsToSave()) {
            
                Reviews__c review;
                if(this.preExistingReview == null) {
                    // no review object exists for this source - create one
                    preExistingReview = new Reviews__c();
                    
                    if(preExistingMerchantAddress != null) {
                        // link Account and Merchant Address to this Review
                        preExistingReview.Account__c = preExistingMerchantAddress.Account__c;
                        preExistingReview.Merchant_Address__c = preExistingMerchantAddress.Id;
                    } else if(preExistingLead != null && preExistingLead.IsConverted != True) {
                        // attach to a lead if it has not already been converted to an account
                        preExistingReview.Lead__c = preExistingLead.Id;
                    } else {
                        System.debug('No merchant address or lead to attach this review to!');
                        return;
                    }
                }
                
                // save the review source
                preExistingReview.Source__c = sourceName;

                if(shouldUpdateSFReview()) {
                    // create new review object
                    System.debug('Saving external reference information for ' + sourceName);
                    
                    try{
                        // save!
                        database.upsert(preExistingReview);
                    } catch(DMLexception e){
                        system.debug(e);
                    }
                }
            }
         }
    }
    
    private boolean hasReviewFieldsToSave() {
        return this.number_of_reviews != null || this.average_rating != null;
    }
    
    private boolean shouldUpdateSFReview() {
        // currently we only care about saving the number of rating, average rating, and url
        boolean newOrUnconvertedLead = preExistingLead == null || preExistingLead.IsConverted != True;
        
        boolean linkedToMerchantAddress = preExistingMerchantAddress != null;
        
        // don't consider external_access_timestamp when checking to see if we should update review data
        boolean hasFieldsToUpdate = preExistingReview.Number_of_Ratings__c != this.number_of_reviews ||
            preExistingReview.Rating__c != this.average_rating ||
            preExistingReview.Facebook_of_fans__c != this.likes ||
            preExistingReview.Review_Link__c != external_reference_url;
        
        if(preExistingReview == null || hasFieldsToUpdate) {
            
            System.debug('old # ratings: ' + preExistingReview.Number_of_Ratings__c + '; new # ratings: ' + this.number_of_reviews);
            System.debug('old rating: ' + preExistingReview.Rating__c + '; new rating: ' + this.average_rating);
            System.debug('old review link: ' + preExistingReview.Review_Link__c + '; new review link: ' + this.external_reference_url);
            System.debug('old likes: ' + preExistingReview.Facebook_of_fans__c + '; new likes: ' + this.likes);
            System.debug('old update date: ' + preExistingReview.Review_Update_Date__c + '; new update date: ' + external_access_timestamp);
            
            preExistingReview.Number_of_Ratings__c = this.number_of_reviews;
            preExistingReview.Rating__c = this.average_rating;
            preExistingReview.Review_Link__c = this.external_reference_url;
            preExistingReview.Facebook_of_fans__c = this.likes;
            // if we update review data because it has changed, then we'll update the review update date to match
            // the external_access_timestamp
            if(this.external_access_timestamp != null) {
                preExistingReview.Review_Update_Date__c = Date.valueOf(this.external_access_timestamp);
            }
           
            return true;
        } else {
            return false;
        }
    }
}