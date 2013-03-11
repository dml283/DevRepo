@isTest
private class OpportunityTriggerUtilTest {
 /*
 * CR:Jan 17 2011:Defect 2439005: removing opportunity record type
 * Because you cannot use DML to create new record types, I have to use existing information.
 * Create an oppty that matches some random category with subcategory null.  Verify it has correct num ?.
 * Create an oppty that matches a random category and subcategory.  Verify it has correct num ?.
 * for additional req: if there are question banks with add to all opp flag is true
 */
    static testMethod void testCreateQuestions() {  
        String categoryTestOn = 'Food and Drink';
        Integer correctNum = [SELECT count() FROM Question_Category__c WHERE Category__r.Name = :categoryTestOn];
        correctNum += [SELECT count() FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];

        Category__c testCategory = TestUtil.createCategory('Apex Programming', true);
        Question_Bank__c testQB1 = TestUtil.createQuestionBank('Hows apex?', true, 'Text', null, 'Help is on the way');
        Question_Bank__c testQB2 = TestUtil.createQuestionBank('Does apex == visualforce?', true, 'Text', null, 'Help here');
        Question_Bank__c testQB3 = TestUtil.createQuestionBank('Someother question?', false, 'Date', null, 'Help is NOT on the way');
        Question_Bank__c testQB4 = TestUtil.createQuestionBank('Test Add To All Opportunities', true, 'Text', null, 'Help is on the way');
        
        testQB4.Add_to_All_Opportunities__c=true;
        update testQB4;
        
        Question_Category__c testQC1 = TestUtil.createQuestionCategory(testCategory.Id, testQB1.Id);
        Question_Category__c testQC2 = TestUtil.createQuestionCategory(testCategory.Id, testQB2.Id);
        Question_Category__c testQC3 = TestUtil.createQuestionCategory(testCategory.Id, testQB3.Id);
       
        Opportunity testOpp = TestUtil.createOppty(categoryTestOn, 'Apex Programming');
        
        System.assertEquals(correctNum+4, [SELECT count() FROM Question__c WHERE Opportunity__c = :testOpp.Id]);
    }
 /*
 * Create an oppty that matches a random category and subcategory.  Verify it has correct num ?.
 * Update category only...verify new list correct.
 */
 /*
    static testMethod void testUpdateQuestions() {
        String categoryTestOn = 'Food and Drink';

        Category__c testCategory = TestUtil.createCategory('Apex Programming', true);
        Question_Bank__c testQB1 = TestUtil.createQuestionBank('Hows apex?', true, 'Text', null, 'Help is on the way');
        Question_Bank__c testQB2 = TestUtil.createQuestionBank('Does apex == visualforce?', true, 'Text', null, 'Help here');
        Question_Bank__c testQB3 = TestUtil.createQuestionBank('Someother question?', false, 'Date', null, 'Help is NOT on the way');
        Question_Category__c testQC1 = TestUtil.createQuestionCategory(testCategory.Id, testQB1.Id);
        Question_Category__c testQC2 = TestUtil.createQuestionCategory(testCategory.Id, testQB2.Id);
        Question_Category__c testQC3 = TestUtil.createQuestionCategory(testCategory.Id, testQB3.Id);
        Opportunity testOpp3 = TestUtil.createOppty(categoryTestOn, 'Apex Programming');
        
        Integer correctNum = [SELECT count() FROM Question_Category__c WHERE Category__r.Name = :categoryTestOn OR (Category__r.Subcategory__c = 'Yes' AND Category__r.Name = 'Apex Programming')];
        correctNum += [SELECT count() FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];
        System.assertEquals(correctNum, [SELECT count() FROM Question__c WHERE Opportunity__c = :testOpp3.Id]);

        correctNum = [SELECT count() FROM Question_Category__c WHERE Category__r.Name = 'Retail' ];
        correctNum += [SELECT count() FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];  
        Integer count01 =[SELECT count() FROM Question__c WHERE Opportunity__c = :testOpp3.Id]; 
        
        testOpp3.Category__c = 'Retail';
        testOpp3.Subcategory__c = null;
        testOpp3.CloseDate = testOpp3.CloseDate.addDays(1);
        update testOpp3;
        
        //System.assertEquals(correctNum, [SELECT count() FROM Question__c WHERE Opportunity__c = :testOpp3.Id]);
    }
    */        
 /*
 * Delete an oppty with questions.  Verify questions dont exist post delete
 * if there are question banks with add to all opp flag is true
 */  
 /*
    static testMethod void testDeleteQuestions() {
        String categoryTestOn = 'Food and Drink';
        Integer correctNum = [SELECT count() FROM Question_Category__c WHERE Category__r.Name = :categoryTestOn];
        correctNum += [SELECT count() FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];
        
        Category__c testCategory = TestUtil.createCategory('Apex Programming', true);
        Question_Bank__c testQB1 = TestUtil.createQuestionBank('Hows apex?', true, 'Text', null, 'Help is on the way');
        Question_Bank__c testQB2 = TestUtil.createQuestionBank('Does apex == visualforce?', true, 'Text', null, 'Help here');
        Question_Bank__c testQB3 = TestUtil.createQuestionBank('Someother question?', false, 'Date', null, 'Help is NOT on the way');
        
        Question_Category__c testQC1 = TestUtil.createQuestionCategory(testCategory.Id, testQB1.Id);
        Question_Category__c testQC2 = TestUtil.createQuestionCategory(testCategory.Id, testQB2.Id);
        Question_Category__c testQC3 = TestUtil.createQuestionCategory(testCategory.Id, testQB3.Id);
        Opportunity testOpp3 = TestUtil.createOppty(categoryTestOn , 'Apex Programming');
        
        System.assertEquals(correctNum+3, [SELECT count() FROM Question__c WHERE Opportunity__c = :testOpp3.Id]);
        delete testOpp3;
        System.assertEquals(0, [SELECT count() FROM Question__c WHERE Opportunity__c = :testOpp3.Id]);
    }
    */  
}