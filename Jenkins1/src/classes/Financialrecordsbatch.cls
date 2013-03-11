global class Financialrecordsbatch implements Schedulable{
   global void execute(SchedulableContext sc) {
      financialbatchclass b = new financialbatchclass(); 
      database.executebatch(b,20);
   }
/*
@istest
static void testme()
{
Test.startTest();
Financialrecordsbatch check = new Financialrecordsbatch ();
      String jobId = System.schedule('testBasicScheduledApex',
      ApexScheduledClasswrapper.sch, 
        new  ApexScheduledClass() );
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];
String sch1 = '0 0 13 * * ? ';
system.schedule('testing job',sch1,check);
Test.stopTest();
} */       
}