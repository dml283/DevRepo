public class MerchantStatusDeals{
    public integer deal_Count {get;set;}
    public date most_recent_created_date {get;set;}
    public string most_recent_stage_name {get;set;}
    public date most_recent_close_date {get;set;}
    public date most_recent_feature_date {get;set;}
    public date most_recent_expiration_date {get;set;}
    
    public MerchantStatusDeals(list<opportunity> olist){
        this.deal_Count = 0;
        for(opportunity o : olist){
            
            //deal_count
            deal_Count ++;
            if(deal_count >= 1){
                //set most_recent_created_date & most_recent_stage_name & most_recent_close_date & most_recent_feature_date
                if(this.most_recent_created_date == null){
                    this.most_recent_created_date = o.createdDate.date();
                    this.most_recent_stage_name = o.stageName;
                    //closed won loop so only a date is populated if the deal is closed won
                    if(o.stageName == 'Closed Won'){
                        this.most_recent_close_date = o.closeDate;
                        //add sure thing loop here so only featured deals info is populated
                        if(o.deal_strengh__c == 'A Sure Thing'){
                            this.most_recent_feature_date = o.feature_date__c;
                            this.most_recent_expiration_date = o.groupon_expiration_date__c;
                        }
                    }else{
                        this.most_recent_close_date = most_recent_close_date;
                        this.most_recent_feature_date = most_recent_feature_date;
                        this.most_recent_expiration_date = most_recent_expiration_date;
                    }
                }else if(this.most_recent_created_date != null && o.createdDate > this.most_recent_created_date){
                    this.most_recent_created_date = o.createdDate.date();
                    this.most_recent_stage_name = o.stageName;
                    if(o.stageName == 'Closed Won'){
                        this.most_recent_close_date = o.closeDate;
                        //add sure thing loop here so only featured deals info is populated
                        if(o.deal_strengh__c == 'A Sure Thing'){
                            this.most_recent_feature_date = o.feature_date__c;
                            this.most_recent_expiration_date = o.groupon_expiration_date__c;
                        }
                    }else{
                        this.most_recent_close_date = most_recent_close_date;
                        this.most_recent_feature_date = most_recent_feature_date;
                        this.most_recent_expiration_date = most_recent_expiration_date;
                    }
                }
            }
        }
    }
    //empty constructor
    public MerchantStatusDeals(){
        this.deal_Count = 0;
        this.most_recent_created_date = null;
        this.most_recent_stage_name = null;
        this.most_recent_close_date = null;
        this.most_recent_feature_date = null;
        this.most_recent_expiration_date = null;
    }
}