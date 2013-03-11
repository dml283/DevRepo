public class CommissionManager {
    public CommissionManager(){
        this.delete_all_prior = false;
        this.start_date = system.today().toStartOfMonth();
        this.day='1';
    }
    public Date start_date {get;set;}
    public Boolean delete_all_prior {get;set;}
    public String day {get;set;}
    public String month {get;set;}
    public String year {get;set;}
    
    public void execute(){
        if(delete_all_prior){
            deletePrior();
        }
        start_date =  date.newinstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
        system.debug('========start_date'+start_date);
        CommissionBatch batch = new CommissionBatch(start_date);
        Id batchId = Database.executeBatch(batch,1);
    }
    public void deletePrior(){
        list< Commission_Statment__c> cs = [select id from Commission_Statment__c];
        database.delete(cs);
    }
}