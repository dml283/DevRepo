/**   
*     Test Class for OpportunityBatch
*     author:  Sonja Smith, originally Shuji Iida
*     date:    Jan 16 2013
*     version: 2.0 
*     Description: revised for code clarity and removed code not doing anything   
*/
@isTest
private class OpportunityBatchTest {
    public List<Opportunity> oppList {get;set;}
    public Integer correctNum =0;
    
    static testMethod void testOppBatch01() {
        OpportunityBatchTest tes = new OpportunityBatchTest();
        tes.setupTestData();
      
        List<Question__c> existingQ = [select Id,Question_Bank__c from Question__c where Opportunity__c = :tes.oppList[0].id];
        
        Test.startTest();
        String query='select '
                        + 'Id, '
                        + 'Category__c,'
                        + 'Sales_Stages__c,'
                        + 'Subcategory__c ' 
                        + 'from Opportunity where Name like \'MMUnitTest%\' limit 200' ;  
                        
        OpportunityBatch oppBatch = new OpportunityBatch(query);
        Id batchprocessid = Database.executeBatch(oppBatch);    
        Test.stopTest();
        List<Question__c> newQ = [select Id from Question__c where Opportunity__c = :tes.oppList[0].id];
        System.assertEquals(newQ.size(), existingQ.size()+1);
    }
    
    public void setupTestData(){
	    oppList = new List<Opportunity>();
	    String categoryTestOn='Food and Drink';
	    Account a = TestUtil.createAccount('TestAccount');
	    Id accountId = a.Id;

         for(Integer index=0 ; index<2; index++){
            Opportunity op=createOppwithCat(categoryTestOn,'Apex Programming');
            op.AccountId = accountId;
            oppList.add(op);
         }
        
         correctNum = [SELECT count() FROM Question_Category__c WHERE Category__r.Name = :categoryTestOn];
         correctNum += [SELECT count() FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];
         
         Category__c testCategory = TestUtil.createCategory('Apex Programming', true);
         Question_Bank__c testQB1 = TestUtil.createQuestionBank('Hows apex?', true, 'Text', null, 'Help is on the way');
         Question_Bank__c testQB2 = TestUtil.createQuestionBank('Does apex == visualforce?', true, 'Text', null, 'Help here');
         Question_Bank__c testQB3 = TestUtil.createQuestionBank('Someother question?', false, 'Date', null, 'Help is NOT on the way');
         Question_Category__c testQC1 = TestUtil.createQuestionCategory(testCategory.Id, testQB1.Id);
         Question_Category__c testQC2 = TestUtil.createQuestionCategory(testCategory.Id, testQB2.Id);
         Question_Category__c testQC3 = TestUtil.createQuestionCategory(testCategory.Id, testQB3.Id);
         
         Question_Bank__c testQB4 = TestUtil.createQuestionBank('Test QB 1', true, 'Text', null, 'Help is on the way');
         testQB4.Add_to_All_Opportunities__c=true;
         update testQB4;
         
         insert oppList;
         
         testQB4.Question_Bank_Name__c = 'Test QB: Changing name';
         testQB4.Required__c = false;
         update testQB4;

         delete testQB1; //delelete a question right away since the master detail. 
         
         Question_Bank__c testQB5 = TestUtil.createQuestionBank('Test QB 2', true, 'Text', null, 'Help is on the way');
         testQB5.Add_to_All_Opportunities__c = true;
         update testQB5;
    }
    
    public  Opportunity createOppwithCat(String categoryId, String subcategory) {
        Opportunity o = new Opportunity(Name = 'MMUnitTest' + System.currentTimeMillis(), Subcategory__c = subcategory, StageName = 'Contract Sent', CloseDate = System.today().addDays(30),Category__c=categoryId);
        return o;       
    }
    
   static testmethod void testSchedule() {
   	Test.startTest();
      String jobId = System.schedule('test','0 0 0 3 9 ? 2022', new OpportunityBatchSchedule());

      CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
    
      System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);
      
      System.assertEquals('2022-09-03 00:00:00', 
      String.valueOf(ct.NextFireTime));

   	 Test.stopTest();
   }

}