global class CommissionBatch implements Database.Batchable<sObject>, Database.Stateful{
    String query;
    String email;
    String month_name;
    Global Date start_date;
    Global Date end_date;
    global Set<Id> alreadyProcessedIds = new Set<Id>();
    
    global CommissionBatch(date start_date){
         this.start_date = start_date;
         this.email = UserInfo.getUserEmail();
         this.end_date = start_date.toStartOfMonth().addDays(32).toStartOfMonth().addDays(-1);
    }
    global CommissionBatch(){
        this.start_date = system.today().toStartOfMonth();
        this.end_date = system.today().toStartOfMonth().addDays(32).toStartOfMonth().addDays(-1);
    }
global Database.querylocator start(Database.BatchableContext BC){
    query = 'SELECT OwnerId from Sales_Goal__C WHERE Goal_Start_Date__c = :start_date'; 
    system.debug(query);
    return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC, List<sObject> scope){
    system.debug('================BATCH APEX');
    for(sObject s : scope){Sales_Goal__C sg = (Sales_Goal__C)s;
           if(!alreadyProcessedIds.contains(sg.ownerid)){
               system.debug('================OWNER ID');
               alreadyProcessedIds.add(sg.ownerid);
               CommissionResult cr = new CommissionResult(sg.ownerid, start_date);
               cr.run();
               Commission_Statment__c cs = new Commission_Statment__c();
                   cs.Commission__c = cr.totalCommission;
                   cs.Month__c = string.ValueOf(start_date);
                   cs.Sales_Rep__c = sg.ownerid;
                   cs.Assigned_Market__c = String.ValueOf(cr.goal.divisions);
                   cs.Accelerated_In_Mkt_GP__c = cr.inMarketGPwAccelerator;
                   cs.Accelerated_In_Mkt_GB__c = cr.inMarketGBwAccelerator;
                   cs.Unaccelerated_In_Mkt_GP__c = cr.inMarketGPbeforeAccelerator;
                   cs.Unaccelerated_In_Mkt_GB__c = cr.inMarketGBbeforeAccelerator;
                   cs.Out_of_Market_GP__c = cr.OOMarketGP;
                   cs.Goal__c = cr.goal.gb_goal;
                   cs.Percent_to_Goal__c = cr.percentToGoal;
               insert cs;
           }
        }
}
global void finish(Database.BatchableContext BC){

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    mail.setToAddresses(new String[] {email});
    mail.setReplyTo('Commission-Calculator@groupon.com');
    mail.setSenderDisplayName('Commission Generator');
    mail.setSubject('Commissions are Generated');
    mail.setPlainTextBody('Your commission job has been completed');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}