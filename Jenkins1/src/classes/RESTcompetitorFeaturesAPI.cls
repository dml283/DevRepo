@RestResource(urlMapping='/v1.0/competitor-features')



global class RESTcompetitorFeaturesAPI {

@HttpGET

global static list<competitive_feature> get(){

string merchantId = RestContext.request.params.get('id');

list<competitive_feature> comp_features = new list<competitive_feature>();

for(social_living__c comp_feature:Database.query(get_comp_feature_query() + '\'' + merchantId + '\' ORDER BY Feature_Date__c DESC LIMIT 5 ')){

comp_features.add(new competitive_feature(comp_feature));

}

return comp_features;

}

 

global class competitive_feature{
    public string name {get;set;}
    public string url {get;set;}
    public string division {get;set;}
    public string feature_date {get;set;}
    public decimal unit_price {get;set;}
    public decimal revenue {get;set;}
    public decimal units_sold {get;set;}
    public string competitor {get;set;}
    public string expiration_date {get;set;}
    public string id {get;set;}
    public competitive_feature(Social_Living__c cf){
        this.name = cf.name;
        this.id = cf.id;
        this.url = cf.Deal_Link__c;
        this.division = cf.division__c;
        if(cf.Feature_Date__c!=null){
            this.feature_date = cf.Feature_Date__c.format();
        }
        if(cf.Competitors_Deal_Expiration_Date__c!=null){
            this.expiration_date = cf.Competitors_Deal_Expiration_Date__c.format();
        }
        this.revenue = cf.revenue__c;
        this.units_sold = cf.units_sold__c; 
        this.competitor = cf.Provider__c;
        this.unit_price = cf.Deal_Price__c;
    }
}


public static string get_comp_feature_query(){

   return 'SELECT id, name, Deal_Link__c, division__c, Feature_Date__c, revenue__c, units_sold__c, Provider__c, Deal_Price__c, Competitors_Deal_Expiration_Date__c FROM social_living__c WHERE Provider__c != \'nopuorG\' AND Provider__c != \'nopuorG Getaways\' AND Provider__c != \'nopuorG Goods\' AND AccountName__c = ';

}



}