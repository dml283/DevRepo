@RestResource(urlMapping='/v1.0/leaderboard/sales')

global class RESTleaderboard_salesAPI{

@HttpGET
global static leaderboard get(){
    leaderboard lb = new Leaderboard();
        lb.add_players();
        lb.merchants_closed_this_month.sort();
        lb.total_gp.sort();
        lb.percent_to_goal.sort();
    return lb;
}
global class leaderboard{
    
    public list<merchants_closed> merchants_closed_this_month {get;set;}
    public list<total_gp> total_gp {get;set;}
    public list<percent_to_goal> percent_to_goal {get;set;}
    //public list<percent_to_goal> percent_to_goal {get;set;}
    public void add_merchants_closed(){
    
    }
    
    public void add_players(){
        this.merchants_closed_this_month = new list<merchants_closed>();
        this.total_gp = new list<total_gp>();
        this.percent_to_goal = new list<percent_to_goal>();
        map<id,sales_rep> sales_reps = new map<id,sales_rep>();
        map<id,user> user_map = new map<id,user>([select id, name, SmallPhotoUrl from user where id!=null and isactive=true]); 
        list<Sales_Goal__c> sales_goals_sobj =  [select id, GP_Goal__c, division__r.name, owner.name, ownerid FROM Sales_Goal__c WHERE Goal_Start_Date__c <= :system.today() AND Goal_End_Date__c >= :system.today() AND GP_Goal__c !=null AND GP_Goal__c >0 AND ownerid in :user_map.keySet()];
        for(Sales_Goal__c sg : sales_goals_sobj){
            sales_rep rep = new sales_rep(sg);
            rep.small_photo_url=user_map.get(rep.id).SmallPhotoUrl;
            sales_reps.put(rep.id,rep);
        }
        AggregateResult[] month_query_result = [SELECT COUNT_DISTINCT(accountId) closed_deals, ownerid owner FROM opportunity where CloseDate = this_month AND StageName = 'Closed Won' AND recordType.name !='Rewards' AND recordType.name !='Now!'  group by ownerid];
           for(AggregateResult ar : month_query_result){
               id i = (id)ar.get('owner');
               if(sales_reps.containsKey(i)){
                   sales_rep rep = sales_reps.get(i);
                   rep.merchants_closed = (decimal)ar.get('closed_deals');
                   if(rep.merchants_closed == null){
                       rep.merchants_closed =0;
                   }
                   sales_reps.put(rep.id,rep);
               }
           }
       AggregateResult[] month_gp = [SELECT SUM(Total_GP__c) gp, ownerid owner FROM opportunity where Feature_date__c = this_month AND StageName = 'Closed Won' AND recordType.name !='Rewards' AND recordType.name !='Now!'  group by ownerid];
           for(AggregateResult ar : month_gp){
                   id i = (id)ar.get('owner');
                   if(sales_reps.containsKey(i)){
                       sales_rep rep = sales_reps.get(i);
                       rep.month_to_date_gp = (decimal)ar.get('gp');
                       rep.month_to_date_gp = rep.month_to_date_gp.setScale(0);
                       if(rep.month_to_date_gp != null && rep.gp_goal >0){
                           rep.gp_percent_to_goal = (rep.month_to_date_gp/rep.gp_goal)*100;
                           rep.gp_percent_to_goal = rep.gp_percent_to_goal.setScale(1);
                       }else{
                           rep.gp_percent_to_goal = 0;
                       }
                       sales_reps.put(rep.id,rep);
                   }
               }
       
       for(sales_rep rep : sales_reps.values()){
           this.merchants_closed_this_month.add(new merchants_closed(rep));
           this.total_gp.add(new total_gp(rep));
           this.percent_to_goal.add(new percent_to_goal(rep));
       }    
    }
} 
public class sales_rep{
    public id id {get;set;}
    public string name {get;set;}
    public string small_photo_url {get;set;}
    public list<string> divisions {get;set;}
    public boolean current_user {get;set;}
    
    public decimal gp_goal {get;set;}
    public decimal month_to_date_gp {get;set;}
    public decimal gp_percent_to_goal {get;set;}    
    public decimal merchants_closed {get;set;}
    
    public sales_rep(Sales_Goal__c sg){
        this.id = sg.ownerid;
        this.name = sg.owner.name;
        if(sg.GP_Goal__c !=null){
            this.gp_goal = sg.GP_Goal__c;
            }else{this.gp_goal = 0;}
        this.divisions = new list<string>();
        this.divisions.add(sg.division__r.name);
        this.merchants_closed =0;
        this.month_to_date_gp = 0;
        if(this.id == UserInfo.getUserId()){
            this.current_user = true;
        }else{this.current_user = false;}
        this.gp_percent_to_goal =0;
    }
}
global class total_gp implements Comparable{
    public sales_rep rep {get;set;}
    
    public total_gp (sales_rep rep){
        this.rep = rep;
    }
    global integer compareTo(Object compareTo) {
        total_gp compareToRanking = (total_gp)compareTo;
        if(rep.month_to_date_gp == compareToRanking.rep.month_to_date_gp) return 0;
        else if(rep.month_to_date_gp < compareToRanking.rep.month_to_date_gp) return 1;
        else return -1;
    }
}
global class percent_to_goal implements Comparable{
    public sales_rep rep {get;set;}
    
    public percent_to_goal (sales_rep rep){
        this.rep = rep;
    }
    global integer compareTo(Object compareTo) {
        percent_to_goal compareToRanking = (percent_to_goal)compareTo;
        if(rep.gp_percent_to_goal == compareToRanking.rep.gp_percent_to_goal) return 0;
        else if(rep.gp_percent_to_goal < compareToRanking.rep.gp_percent_to_goal) return 1;
        else return -1;
    }
}
global class merchants_closed implements Comparable{
    public sales_rep rep {get;set;}
    
    public merchants_closed (sales_rep rep){
        this.rep = rep;
    }
    global integer compareTo(Object compareTo) {
        merchants_closed compareToRanking = (merchants_closed)compareTo;
        if(this.rep.merchants_closed == compareToRanking.rep.merchants_closed) return 0;
        else if(this.rep.merchants_closed < compareToRanking.rep.merchants_closed) return 1;
        else return -1;
    }
}

}