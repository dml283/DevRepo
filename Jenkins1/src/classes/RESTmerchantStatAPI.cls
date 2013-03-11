@RestResource(urlMapping='/v1.0/merchant/stats')

global class RESTmerchantStatAPI{

@HttpGET
global static merchant_stat merchant_stats(){
     merchant_stat stats = new merchant_stat();
     string ranking='0';
     string lead_ranking='0';
     string num_leads ='0';
     string num_accounts='0';
     AggregateResult[] ar = [SELECT sum(Total_GP__c) gp, sum(Research_Ranking_num__c) ranking , sum(Total_Refunds__c) refunds, sum(Number_of_Features__c) num_deals, count(id) closed FROM Account WHERE ownerid = :UserInfo.getUserId() AND Total_GP__c>0];
        for(AggregateResult agg :ar){
        stats.total_gp_earned = string.valueOf(agg.get('gp'));
        stats.total_refunds = string.valueOf(agg.get('refunds'));
        stats.total_deals = string.valueOf(agg.get('num_deals'));
        stats.merchants_closed = string.valueOf(agg.get('closed'));
        ranking = string.valueOf(agg.get('ranking'));
        }
     AggregateResult[] ar1 = [SELECT count(id) num_leads, sum(Research_Ranking_num__c) ranking FROM Lead WHERE ownerid = :UserInfo.getUserId() AND isconverted=false];
        for(AggregateResult agg :ar1){  
        lead_ranking = string.valueOf(agg.get('ranking'));
        num_leads = string.valueOf(agg.get('num_leads'));
        }
     AggregateResult[] ar2 = [SELECT count(id)accounts FROM Account WHERE ownerid = :UserInfo.getUserId()];
        for(AggregateResult agg :ar2){
            num_accounts = string.valueOf(agg.get('accounts'));
        }
    
     stats.num_merchants = integer.valueOf(num_accounts) + integer.valueOf(num_leads);
     if(lead_ranking!=null & ranking!=null)stats.avg_ranking=(decimal.valueOf(lead_ranking)+decimal.valueOf(ranking))/stats.num_merchants;
     if(stats.avg_ranking!=null)stats.avg_ranking=stats.avg_ranking.setScale(2);
     if(stats.total_deals !=null && decimal.valueOf(stats.total_deals)>0)stats.avg_gp_deal = decimal.valueOf(stats.total_gp_earned)/decimal.valueOf(stats.total_deals);
     if(stats.avg_refund_rate !=null && decimal.valueOf(stats.total_gp_earned)>0)stats.avg_refund_rate = decimal.valueOf(stats.total_refunds)/decimal.valueOf(stats.total_gp_earned);
     if(stats.avg_refund_rate!=null)stats.avg_refund_rate=stats.avg_refund_rate.setScale(2);
     if(stats.avg_gp_deal!=null)stats.avg_gp_deal=stats.avg_gp_deal.setScale(2);
     return stats;
}    
global class merchant_stat{
    public integer num_merchants {get;set;}
    public string merchants_closed {get;set;}
    public decimal avg_ranking {get;set;}
    public string total_gp_earned {get;set;}
    public decimal avg_gp_deal {get;set;}
    public decimal avg_refund_rate {get;set;}
    public string total_refunds {get;set;}
    public string total_deals {get;set;}
 }
}