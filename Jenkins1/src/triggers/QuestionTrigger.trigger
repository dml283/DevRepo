trigger QuestionTrigger on Question__c (before update) {

QuestionTriggerUtil.determineHasBeenAnswered(Trigger.new);
QuestionTriggerUtil.updateFinePrintAndRelatedOpportunity(Trigger.new);

/*
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
           QuestionTriggerUtil.determineHasBeenAnswered(Trigger.new);
           QuestionTriggerUtil.updateFinePrintAndRelatedOpportunity(Trigger.new);  
        } else 
       if(Trigger.isUpdate) {
            QuestionTriggerUtil.determineHasBeenAnswered(Trigger.new);
            QuestionTriggerUtil.updateFinePrintAndRelatedOpportunity(Trigger.new);
        }
    } else if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            QuestionTriggerUtil.determineAllowCompleteness(Trigger.new); 
        } else if(Trigger.isUpdate) {
            QuestionTriggerUtil.determineAllowCompleteness(Trigger.new);
        } 
    }*/

}