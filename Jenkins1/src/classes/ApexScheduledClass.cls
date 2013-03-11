global with sharing  class ApexScheduledClass Implements Schedulable
{
        global void execute(SchedulableContext sc)
        {
            
            sendmessage b = new sendmessage(); 
            database.executebatch(b,8);

        
        }                    
}