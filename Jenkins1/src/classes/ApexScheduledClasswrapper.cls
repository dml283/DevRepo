global class ApexScheduledClasswrapper Implements Schedulable
{
         public static String sch = '0 0 13 * * ? ';
        global void execute(SchedulableContext sc)
        {
            
           ApexScheduledClass schedule = new  ApexScheduledClass();
 
            system.schedule('Merge Job', sch, schedule);

        
        }   
@istest(SeeAllData = true)
static void testme()
{
   Test.startTest();

ApexScheduledClasswrapper  check = new ApexScheduledClasswrapper ();

   // Schedule the test job 
    

      String jobId = System.schedule('testBasicScheduledApex',
      ApexScheduledClasswrapper.sch, 
        new  ApexScheduledClass() );
   // Get the information from the CronTrigger API object 
    

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

 String sch1 = '0 0 13 * * ? ';

system.schedule('testing job',sch1,check);
   Test.stopTest();


}
                 
}