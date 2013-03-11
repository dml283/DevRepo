@RestResource(urlMapping='/v1.0/finance/transactions/my')

global class RESTdaily_transactionsAPI{

@HttpGET
global static list<daily_transactions> getFinancials(){
   list<daily_transactions> transactions = new list<daily_transactions>();
   
   return transactions;
}
public static string get_query(){
    string query='';
    return query;
}
global class daily_transactions{
    public string name {get;set;}
    public string permalink {get;set;}
    public string feature_date {get;set;}
    public string id {get;set;}
    public string division {get;set;}
    public decimal total_profit {get;set;}
    public decimal total_revenue {get;set;}
    public decimal total_refunds{get;set;}
    public decimal total_feature_gp {get;set;}
    public decimal total_post_feature_gp {get;set;}
    public list<daily_transaction> transactions {get;set;}
    public daily_transactions(opportunity o){
        this.name = o.name;
        this.division = o.division__c;
        this.permalink = o.permalink__c;
        this.feature_date = o.feature_date__c.format();
        this.id = o.id;
        this.total_profit = 0;
        this.total_feature_gp = 0;
        this.total_post_feature_gp = 0;
        this.total_refunds=0;
        this.total_revenue = 0;
        this.transactions = new list<daily_transaction>();
        if(o.Financial_Records__r!=null && o.Financial_Records__r.size()>0){
            for(financial_records__c fr : o.Financial_Records__r){
                transactions.add(new daily_transaction(fr));
                if(fr.Profit_Amount__c >0){
                    this.total_revenue+=fr.Revenue_Amount__c;
                    this.total_profit+=fr.Profit_Amount__c;
                    if(fr.Opportunity__r.feature_end_date__c >= fr.collection_date__c){
                        this.total_feature_gp += fr.Profit_Amount__c;
                    }else{
                            this.total_post_feature_gp += fr.Profit_Amount__c;
                        }
                }else{
                    this.total_refunds+=fr.Revenue_Amount__c;
                }
            }    
        }
    }
}
public class daily_transaction{
    public decimal gross_billing {get;set;}
    public decimal margin {get;set;}
    public string collection_date {get;set;}
    public decimal revenue {get;set;}
    public decimal profit {get;set;}
    public decimal refund {get;set;}
    public boolean feature_period {get;set;}
    
    public daily_transaction(Financial_Records__c fr){
        this.gross_billing = fr.Gross_Billings__c;
        this.margin = fr.Margin__c;
        this.revenue = fr.Revenue_Amount__c;
        this.collection_date = fr.collection_date__c.format();
        if(fr.Profit_Amount__c >0){
            this.profit = fr.Profit_Amount__c;
            }else{
                this.profit=0;
                this.refund = fr.Revenue_Amount__c;
            }
        if(fr.Opportunity__r.feature_end_date__c >= fr.collection_date__c){
            this.feature_period = true;
        }else{
            this.feature_period = false;
        }
    }
}    
       
}