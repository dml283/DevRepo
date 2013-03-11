public with sharing class QuestionPageController {
        
        public List<QuestionCoupler> mainQuestionsBlank {get; set;}
        public List<QuestionCoupler> mainQuestionsFP {get; set;}
        public List<QuestionCoupler> mainQuestionsDetail {get; set;}
        
        public String headerValue {get; set;}
        public Id currentPageId {get; set;}
        private Opportunity pageOppty {get; set;}
        public Boolean errorFlag{get{
                                                          if(ApexPages.hasMessages()){
                                                                return true;
                                                          }else {
                                                                return false;
                                                          }
                                                        }
                                 set;}
        public QuestionPageController(ApexPages.StandardController ctrl) {
                mainQuestionsBlank = new List<QuestionCoupler>();
                mainQuestionsFP = new List<QuestionCoupler>();
                mainQuestionsDetail = new List<QuestionCoupler>();
 
                currentPageId = ctrl.getId();
                //List<Opportunity> names = [SELECT RecordType.Name, Sales_Stages__c FROM Opportunity WHERE Id = :ctrl.getId()];
                List<Opportunity> names = [SELECT Category__c, Sales_Stages__c FROM Opportunity WHERE Id = :ctrl.getId()];
                if(names.size() > 0) {
                        pageOppty = names[0];
                        //headerValue = names[0].RecordType.Name + ' ';
                        headerValue = names[0].Category__c + ' ';
                } else {
                        headerValue = '';
                }
                
                List<Question__c> falseQuestions = [SELECT Id, Question_Name__c, Answer__c, Data_Type__c, Picklist_Options__c, Required__c, From_Subcategory__c, Question_Section__c, Help_Text__c FROM Question__c WHERE Opportunity__c = :ctrl.getId() order by Order__c asc];
                Integer count = 1;

                for(Question__c currQ : falseQuestions) {
                        if(currQ.Question_Section__c != 'Fine Print' && currQ.Question_Section__c != 'Details & Selling Points')  {
                                  mainQuestionsBlank.add( new QuestionCoupler(currQ, count,this.errorFlag) );
                                  count++;
                        }
                }                                       
                
                for(Question__c currQ : falseQuestions) {
                        if(currQ.Question_Section__c == 'Fine Print') {
                                 mainQuestionsFP.add( new QuestionCoupler(currQ, count,this.errorFlag) );
                                 count++;
                        }
                }

                for(Question__c currQ : falseQuestions) {
                        if(currQ.Question_Section__c == 'Details & Selling Points') {
                                mainQuestionsDetail.add( new QuestionCoupler(currQ, count,this.errorFlag) );
                                count++;
                        }
                }
                                
        } 
        
        private List<Question__c> saveAnswerHelper(List<Question__c> updateableList, List<QuestionCoupler> qcList) {
                for(QuestionCoupler qc : qcList) {
                         
                        if(qc.theQuest.Data_Type__c == 'Date' ) {
                                if(qc.dummyDate.CloseDate != null){
                                        qc.theQuest.Answer__c = qc.dummyDate.CloseDate.format();
                                }else{
                                        qc.theQuest.Answer__c = null;
                                }
                        }
                 
                        updateableList.add(qc.theQuest); 
                }               
                return updateableList;
        }

        public PageReference saveAnswers() {
                List<Question__c> updateableList = new List<Question__c>();
                
                updateableList = saveAnswerHelper(updateableList, mainQuestionsBlank);
                updateableList = saveAnswerHelper(updateableList, mainQuestionsFP);
                updateableList = saveAnswerHelper(updateableList, mainQuestionsDetail);                 
                
                Integer numRequired = 0;
                Integer numRequiredAnswered = 0;
                
                for(QuestionCoupler qc : mainQuestionsBlank) {
                        if(qc.theQuest.Required__c) numRequired++;
                        if(qc.theQuest.Required__c && qc.theQuest.Answer__c != null && qc.theQuest.Answer__c.trim() != '') numRequiredAnswered++;
                }
                for(QuestionCoupler qc : mainQuestionsFP) {
                        if(qc.theQuest.Required__c) numRequired++;
                        if(qc.theQuest.Required__c && qc.theQuest.Answer__c != null && qc.theQuest.Answer__c.trim() != '') numRequiredAnswered++;
                }
                for(QuestionCoupler qc : mainQuestionsDetail) {
                        if(qc.theQuest.Required__c) numRequired++;
                        if(qc.theQuest.Required__c && qc.theQuest.Answer__c != null && qc.theQuest.Answer__c.trim() != '') numRequiredAnswered++;
                }       
                
                if(pageOppty.Sales_Stages__c == 'Complete' && numRequired != numRequiredAnswered) {
                        pageOppty.Sales_Stages__c = 'Incomplete';
                        try{
                                update pageOppty;
                        }catch (DMLException de){
                                 
                        ApexPages.addMessages(de);
                        }
                }                       
                
                try{
                                update updateableList;
                }catch (DMLException de){
                             
                        ApexPages.addMessages(de);
                }
                if(ApexPages.hasMessages()){
                        errorFlag=true;
                }
                return null;
        }
        
        public class QuestionCoupler {
                public Question__c theQuest {get; set;}
                public Integer questionNumber {get; set;}
                public List<SelectOption> picklistOptions {get; set;}
                public Opportunity dummyDate {get; set;}
                
                public QuestionCoupler(Question__c aQuest, Integer qNum,Boolean errorFlag) {
                        theQuest = aQuest;
                        questionNumber = qNum;
                        picklistOptions = new List<SelectOption>();
                 
                        dummyDate = new Opportunity();
                        if(aQuest.Data_Type__c == 'Date' && theQuest.Answer__c != null) {
                                if(theQuest.Answer__c != ''){
                                        try {
                                                dummyDate.CloseDate = Date.parse(theQuest.Answer__c);
                                        } catch(Exception e) {
                                                errorFlag = true;
                                                ApexPages.addMessages(e);
                                        }
                                }else{
                                        dummyDate.CloseDate = null;
                                }       
                        } else if(aQuest.Data_Type__c == 'Picklist' ) {
                                if(aQuest.Picklist_Options__c != null)
                                {
                                        List<String> plSplit = aQuest.Picklist_Options__c.split(';', 0);
                                        //if(plSplit.size() > 0){
                                                //theQuest.Answer__c = plSplit[0];
                                        //}
                                        for(String currOption : plSplit) {
                                                if(currOption!=null){
                                                        currOption=currOption.trim();
                                                }
                                                picklistOptions.add( new SelectOption(currOption, currOption) );
                                        }
                                }
                        }
                        
                }
                
        }
}