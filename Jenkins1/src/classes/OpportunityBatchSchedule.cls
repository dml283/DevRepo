global class OpportunityBatchSchedule  implements Schedulable {
	global void execute(SchedulableContext sc) {
           String query='select '
			            + 'Id, '
			            + 'Category__c,'
			            + 'Subcategory__c ,' 
				        + 'Sales_Stages__c '
			            + 'from Opportunity ' 
			            + 'WHERE (NOT StageName LIKE \'%CLOSED%\')';  
			OpportunityBatch oppBatch = new OpportunityBatch(query);
			 
            //Id batchprocessid = Database.executeBatch(oppBatch);
            Id batchprocessid = Database.executeBatch(oppBatch,100);		 
   }
   
   static testmethod void testSchedule() {
   Test.startTest();
      String jobId = System.schedule('test',
      '0 0 0 3 9 ? 2022', 
         new OpportunityBatchSchedule());

      CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];
    
      System.assertEquals('0 0 0 3 9 ? 2022', 
         ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);
      
      System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));

   	 Test.stopTest();
   }
}