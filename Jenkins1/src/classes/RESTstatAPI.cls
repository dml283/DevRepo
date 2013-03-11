@RestResource(urlMapping='/v1.0/stats/my')

global class RESTstatAPI{

@HttpGET
global static stat getStats(){
        stat my_stats = new Stat();
        return my_stats;
    }

global class stat{

    public decimal my_deals {get;set;}
    public decimal my_irs {get;set;}
    public decimal my_contracts {get;set;}
    public decimal my_tasks {get;set;}
    
    public stat(){
        list<sales_goal__c> goals = [select id, Division__r.name, GP_Goal__c, Contract_Goal__c FROM sales_goal__c WHERE ownerid = :UserInfo.getUserId() and goal_start_date__c = this_month];
        decimal goal =1;
        list<string> divisions = new list<string>();
        for(sales_goal__c g : goals){
            divisions.add(g.division__r.name);
        } 
        AggregateResult[] ar3 = [SELECT count(id) ir FROM Information_request__c WHERE opportunity__r.ownerid = :UserInfo.getUserId() AND Issue_Resolved__c = false AND opportunity__r.feature_date__c > :system.today() AND opportunity__r.stageName = 'Closed Won'];
        for(AggregateResult agg : ar3){
        my_irs=decimal.valueOf(String.valueOf(agg.get('ir')));
        }
        AggregateResult[] ar4 = [SELECT count(id) pipe FROM Opportunity WHERE ownerid = :UserInfo.getUserId() AND Feature_date__c >=:system.today()];
        for(AggregateResult agg : ar4){
        my_deals=decimal.valueOf(String.valueOf(agg.get('pipe')));
        }
        AggregateResult[] ar5 = [SELECT count(id) tasks FROM Task WHERE ownerid = :UserInfo.getUserId() AND ActivityDate <=:system.today() AND isClosed !=true];
        for(AggregateResult agg : ar5){
        my_tasks=decimal.valueOf(String.valueOf(agg.get('tasks')));
        }
        AggregateResult[] ar6 = [SELECT count(id) contracts FROM Opportunity WHERE ownerid = :UserInfo.getUserId() AND stageName = 'Contract Sent'];
        for(AggregateResult agg : ar6){
        my_contracts=decimal.valueOf(String.valueOf(agg.get('contracts')));
        }
    }
}
       
}