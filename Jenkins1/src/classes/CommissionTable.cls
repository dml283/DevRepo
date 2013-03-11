public class CommissionTable{
    public Decimal newDealRate {get;set;}
    public Decimal reFeatureRate {get;set;}
    public Decimal outOfMarketRate {get;set;}
    public Decimal percentToGoalKicker {get;set;}
    
    public void setPayout(PayoutTable__c payout){
        this.newDealRate = payout.New_Deals__c;
        this.reFeatureRate = payout.ReFeature__c;
        this.outOfMarketRate = payout.Out_Of_Market__c;
        this.percentToGoalKicker = payout.PercentToGoalKicker__c;
    }    
    
    public CommissionTable(Decimal percentToGoal, Boolean highTarget){
          list<PayoutTable__c> payouts = database.query(getQuery(highTarget));
          
          if(payouts.size()>0){
              for(payoutTable__c pt : payouts){
                  if(percentToGoal >= pt.MinTarget__c && percentToGoal < pt.MaxTarget__c){
                      this.setPayout(pt);
                  }
              }
          }else{
                this.newDealRate = 0;
                this.reFeatureRate = 0;
                this.outOfMarketRate =0;   
                this.percentToGoalKicker=0;
          }    
    }
    public CommissionTable(){
        this.newDealRate = 0;
        this.reFeatureRate = 0;
        this.outOfMarketRate =0;   
    }
    public String getQuery(boolean highTarget){
        String query;
        query = 'SELECT id, MinTarget__c, MaxTarget__c, New_Deals__c, Out_Of_Market__c, ReFeature__c, PercentToGoalKicker__c FROM PayoutTable__c';
        if(highTarget){
            query+= ' WHERE Target__c = \'Over\' ';
        }else{
            query+= ' WHERE Target__c = \'Under\' ';
        }    
        query+= ' ORDER BY MinTarget__c';
        return query;
    }
}