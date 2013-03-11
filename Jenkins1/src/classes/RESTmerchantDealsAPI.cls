@RestResource(urlMapping='/v1.0/merchant/deals/*')



global class RESTmerchantDealsAPI {

@HttpGET

global static list<deal> get(){

string merchantId = RestContext.request.params.get('id');

list<deal> g1_deals = new list<deal>();
system.debug(get_deal_query() + '\'' + merchantId + '\' ORDER BY Feature_Date__c DESC LIMIT 5 ');
for(Opportunity o:Database.query(get_deal_query() + '\'' + merchantId + '\' ORDER BY Feature_Date__c DESC LIMIT 5 ')){
    g1_deals.add(new deal(o));
}
return g1_deals;
}

 

global class deal{
    public string name {get;set;}
    public string feature_date {get;set;}
    public string stage {get;set;}
    public string division {get;set;}
    public decimal gp {get;set;}
    public decimal gms {get;set;}
    public integer units {get;set;}
    public string sales_rep {get;set;}
    public string permalink {get;set;}
    public string close_date {get;set;}
    public string expiration_date {get;set;}
    public deal(opportunity o){
        this.name = o.name;
        if(o.feature_date__c!=null){
            this.feature_date = o.feature_date__c.format();
        }else{
            this.feature_date ='';
        }
        if(o.Groupon_Expiration_Date__c !=null){
            this.expiration_date = o.Groupon_Expiration_Date__c.format();
        }
        this.stage = o.stageName;
        this.gms = o.Total_GMS__c;
        this.gp = o.Total_GP__c;
        if(o.Total_Units_Sold__c>0)this.units = integer.valueOf(o.Total_Units_Sold__c);
        this.sales_rep = o.owner.name;
        this.division = o.division__c;
        this.permalink=o.permalink__c;
        this.close_date = o.closeDate.format();
    }
}


public static string get_deal_query(){

   return 'SELECT id, name, feature_date__c, stageName, owner.name, Total_GMS__c, Total_GP__c, Total_Units_Sold__c, closeDate, permalink__c, division__c, Groupon_Expiration_Date__c FROM Opportunity where isclosed=true AND feature_date__C !=null AND AccountId = ';

}



}