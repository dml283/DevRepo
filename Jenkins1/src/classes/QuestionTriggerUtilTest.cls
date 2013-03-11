/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class QuestionTriggerUtilTest {

    static testMethod void testUpdateFinePrintAndRelatedOpportunity() {
        String categoryToTest = 'Food & Drink';
        String subcategoryToTest = 'Bars';
        
        Question_Bank__c testQB1 = TestUtil.createQuestionBank('AQB1?', false, 'Text', null, null);
        Question_Bank__c testQB2 = TestUtil.createQuestionBank('AQB2?', false, 'Text', null, null);
        List<Category__c> catList = [SELECT Id, Name FROM Category__c WHERE Name = :categoryToTest];
        if(catList.size() > 0) {
            Question_Category__c testQC1 = TestUtil.createQuestionCategory(catList[0].Id, testQB1.Id);
            Question_Category__c testQC2 = TestUtil.createQuestionCategory(catList[0].Id, testQB2.Id);
            testQB1.Fine_Print_Template__c = 'QB 1 {ans}!';
            testQB2.Fine_Print_Template__c = 'QB 2 {ans}!';
            testQB1.Question_Section__c = 'Fine Print';
            testQB2.Question_Section__c = 'Fine Print';
            update testQB1;
            update testQB2;
            testQC1.Order__c = 2;
            testQC2.Order__c = 1;
            update testQC1;
            update testQC2;
            Opportunity testOpp = TestUtil.createOppty(categoryToTest, subcategoryToTest);
            List<Question__c> qList = [SELECT Id FROM Question__c WHERE Opportunity__c = :testOpp.Id];
            System.debug('Questions on Oppty: '+qList.size()); 
            for(Question__c q : qList) {
                q.Answer__c = 'Test Ans';
            }
            update qList;
            Opportunity finalizedOpp = [SELECT Id, conditions__c FROM Opportunity WHERE Id = :testOpp.Id LIMIT 1];
            System.debug('Opp Id:' + finalizedOpp.Id);
            System.debug('Opp Conditions:' + finalizedOpp.conditions__c);
            System.assertNotEquals(-1, finalizedOpp.conditions__c.indexOf('QB 2 Test Ans'));
            System.assertNotEquals(-1, finalizedOpp.conditions__c.indexOf('QB 1 Test Ans'));
            System.assert(finalizedOpp.conditions__c.indexOf('QB 2 Test Ans') < finalizedOpp.conditions__c.indexOf('QB 1 Test Ans!'));                      
        }
    }
    
    static testMethod void testDetermineHasBeenAnswered() {
        String categoryToTest = 'Food & Drink';
        String subcategoryToTest = 'Bars';
        
        
        Opportunity testOpp = TestUtil.createOppty(categoryToTest, subcategoryToTest);
        List<Question__c> qList = [SELECT Answer__c FROM Question__c WHERE Opportunity__c = :testOpp.Id];
        for(Question__c q : qList) {
            System.assertEquals(false, (q.Answer__c != null && q.Answer__c.trim() != ''));
        }
        if(qList.size() > 0) {
            qList[0].Answer__c = 'An Answer';
            update qList;
            qList = [SELECT Answer__c FROM Question__c WHERE Opportunity__c = :testOpp.Id];
            Integer count = 0;
            for(Question__c q : qList) {
                if(q.Answer__c != null && q.Answer__c.trim() != '') count++;
            }           
            System.assertEquals(1, count);
        }
   }
        
}