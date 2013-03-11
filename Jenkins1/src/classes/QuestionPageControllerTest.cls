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
private class QuestionPageControllerTest {

    static testMethod void testConstructor() {
        //String rtTestOn = 'Food and Drink';
        String catTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];
        /*
                CR:Jan 17 2011:Defect 2439005: removing opportunity record type
       */       
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Bars');
        Opportunity testOpp = TestUtil.createOppty(catTestOn, 'Bars');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        QuestionPageController qpc = new QuestionPageController(ctrl);
        System.assertEquals('Food and Drink ', qpc.headerValue);
    }
    
    static testMethod void testSave() {
        //String rtTestOn = 'Food and Drink';
        String catTestOn = 'Food and Drink';
        //List<RecordType> rtList = [SELECT Id FROM RecordType WHERE Name = :rtTestOn];     
        //Opportunity testOpp = TestUtil.createOppty(rtList[0].Id, 'Bars');
        Opportunity testOpp = TestUtil.createOppty(catTestOn, 'Bars');
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        
        QuestionPageController qpc = new QuestionPageController(ctrl);
   
        /* MAIN QUESTIONS */
        for(QuestionPageController.QuestionCoupler qc : qpc.mainQuestionsBlank) {
            if(qc.theQuest.Data_Type__c == 'Date') {
                qc.dummyDate.CloseDate = System.today();
                //qc.theQuest.Answer__c = System.today().format();
            } else {
                qc.theQuest.Answer__c = 'FakeAnswer';
            }
        }
        for(QuestionPageController.QuestionCoupler qc : qpc.mainQuestionsFP) {
            if(qc.theQuest.Data_Type__c == 'Date') {
                qc.dummyDate.CloseDate = System.today();
                //qc.theQuest.Answer__c = System.today().format();
            } else {
                qc.theQuest.Answer__c = 'FakeAnswer';
            }
        }   

        for(QuestionPageController.QuestionCoupler qc : qpc.mainQuestionsDetail) {
            if(qc.theQuest.Data_Type__c == 'Date') {
                qc.dummyDate.CloseDate = System.today();
                //qc.theQuest.Answer__c = System.today().format();
            } else {
                qc.theQuest.Answer__c = 'FakeAnswer';
            }
        }       
        
        qpc.saveAnswers();
        List<Question__c> answeredQuestions = [SELECT Answer__c, Data_Type__c FROM Question__c WHERE Opportunity__c = :testOpp.Id];
        for(Question__c currQuest : answeredQuestions) {
            if(currQuest.Data_Type__c == 'Date') {
                System.assertEquals(System.today().format(), currQuest.Answer__c);
            } else {
                System.assertEquals('FakeAnswer', currQuest.Answer__c);
            }
        }
    }    
}