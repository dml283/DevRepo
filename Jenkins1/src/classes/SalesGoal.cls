public class SalesGoal{
    public Id ownerId {get;set;}
    public Decimal gb_goal {get;set;}
    public List<String> divisions {get;set;}
    public Boolean highTarget {get;set;}
    
    public SalesGoal(List<Sales_goal__c> salesGoals){
    if(salesGoals!=null){
        this.gb_goal = 0;
        for(Sales_goal__c s :salesGoals){
           this.ownerId = s.ownerid;
           this.gb_goal += s.Gross_Billings_Goal__c;
           if(this.divisions!=null){
            divisions.add(s.Division__r.name);
           }else{
            this.divisions = new list<string>{s.Division__r.name};
           }
          }        
         if(this.gb_goal >= 250000){
             this.highTarget = true;
         }else{
             this.highTarget = false;
         }
        }else{
            this.gb_goal = 1;
            this.divisions = new list<string>();
        }
    }
    public SalesGoal(){
        this.divisions = new list<string>();
    }
}