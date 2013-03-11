public class QuestionTriggerUtil {

    public static void updateFinePrintAndRelatedOpportunity(List<Question__c> questions) {

        Map<Id, List<Question__c>> opptyToQuestions = new Map<Id, List<Question__c>>();
        
        for(Question__c currQuest : questions) {
            if(currQuest.Question_Section__c == 'Fine Print') {
                if(currQuest.Answer__c == 'N/A' || currQuest.Answer__c == '--None--') {
                    currQuest.Fine_Print__c = null;
                } else {
                    if(currQuest.Fine_Print_Template__c != null) {
                        currQuest.Fine_Print__c = currQuest.Fine_Print_Template__c.replace('{ans}', (currQuest.Answer__c == null ? '' : currQuest.Answer__c));
                    }
                }
                insertInOrder(currQuest, opptyToQuestions);
            }
        }
        
         
        List<Opportunity> opptyList = [SELECT Id, conditions__c, Num_Required__c, Num_Required_Answered__c, Sales_Stages__c FROM Opportunity WHERE Id in :opptyToQuestions.keySet() ];
        for(Opportunity currOpp : opptyList) {
            String concat = '';
            List<Question__c> qList = opptyToQuestions.get(currOpp.Id);
            for(Question__c currQuest : qList) {
                if(currQuest.Answer__c != null && currQuest.Answer__c != '' && currQuest.Fine_Print__c != null && currQuest.Fine_Print__c != '') {
                    concat += currQuest.Fine_Print__c + '.  ';
                }
            }
            currOpp.conditions__c = concat;
        }
        try {
            update opptyList;
        } catch (DmlException e){
            ApexPages.addMessages(e);
            //return null;
          }
    }

    
    public static void determineHasBeenAnswered(List<Question__c> questions) {
        for(Question__c currQ : questions) {
            currQ.Has_Been_Answered__c = currQ.Answer__c != null && currQ.Answer__c.trim() != '';
        }
    }

    /*
    public static void determineAllowCompleteness(List<Question__c> questions) {
        List<Id> opptyIds = new List<Id>();
        
        for(Question__c q : questions) {
            opptyIds.add(q.Opportunity__c);
        }
        
        List<Opportunity> opptys = [SELECT Id, Name, Opportunity_Group__c FROM Opportunity WHERE Id in :opptyIds];
        questions = [SELECT Id, Name, Opportunity__c, Required__c, Answer__c, Opportunity__r.Opportunity_Group__c FROM Question__c WHERE Opportunity__c in :opptyIds order by Opportunity__r.Opportunity_Group__c asc];
            
        List<Opportunity_Group__c> updateList = new List<Opportunity_Group__c>();
        Boolean allAnswered = true;     
        Id oldId = questions[0].Opportunity__r.Opportunity_Group__c;
        
        for(Integer index = 0; index < questions.size(); index++) {
            if(questions[index].Opportunity__r.Opportunity_Group__c == oldId) {
                if(questions[index].Required__c && (questions[index].Answer__c == null || questions[index].Answer__c.trim() == '')) {
                    allAnswered = false;
                }
            } else {
                Opportunity_Group__c og = new Opportunity_Group__c(Id=questions[index-1].Opportunity__r.Opportunity_Group__c, All_Answered__c = allAnswered);
                if(!allAnswered) og.Sales_Stages__c = 'Incomplete';
                updateList.add( og );
                oldId = questions[index].Opportunity__r.Opportunity_Group__c;
                if(questions[index].Required__c) allAnswered = questions[index].Answer__c != null && questions[index].Answer__c.trim() != '';
                else              allAnswered = true;
            }
        }
        
        Opportunity_Group__c og = new Opportunity_Group__c(Id=questions[questions.size()-1].Opportunity__r.Opportunity_Group__c, All_Answered__c = allAnswered);
        if(!allAnswered) og.Sales_Stages__c = 'Incomplete';
        updateList.add( og );   
        
        update updateList;      
    }*/
    
    private static void insertInOrder(Question__c currQuest, Map<Id, List<Question__c>> opptyToQuestions) {
        if(!opptyToQuestions.containsKey(currQuest.Opportunity__c)) {
            List<Question__c> qList = new List<Question__c>();
            qList.add(currQuest);
            opptyToQuestions.put(currQuest.Opportunity__c, qList);
        } else {
            Boolean found = false;
            for(Integer index = 0; index < opptyToQuestions.get(currQuest.Opportunity__c).size() && !found; index++) {
                if(currQuest.Order__c != null && currQuest.Order__c <= opptyToQuestions.get(currQuest.Opportunity__c)[index].Order__c && !found) {
                    opptyToQuestions.get(currQuest.Opportunity__c).add(index, currQuest);
                    found = true;
                    break;
                }
            }
            if(!found) {
                opptyToQuestions.get(currQuest.Opportunity__c).add(currQuest);
            }
        }
    }
    

}