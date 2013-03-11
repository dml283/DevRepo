public with sharing class QuestionsCRUDWorkflow implements TriggerWorkflow 
{
	Boolean isInsert;
	Boolean isUpdate;
	Boolean isDelete;
	List<Opportunity> oldOps;
	List<Opportunity> newOps;
	
	public QuestionsCRUDWorkflow(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<Opportunity> oldOps, List<Opportunity> newOps)
	{
		this.isInsert = isInsert;
		this.isUpdate = isUpdate;
		this.isDelete = isDelete;
		this.oldOps = oldOps;
		this.newOps = newOps;	
	}
	
	//business logic
	public void execute()
	{
		if(isInsert)
		{
			createQuestions(newOps,true, true,true);
		}	
		if(isUpdate)
		{
			updateQuestions(oldOps, newOps);
		}
		if(isDelete)
		{
			deleteQuestions(oldOps, true, true);
		}
	}
	
	private static Boolean hasExecutedCreateQuestions{ get{if(hasExecutedCreateQuestions == null) hasExecutedCreateQuestions = false; return hasExecutedCreateQuestions;} private set;}
	private void createQuestions(List<Opportunity> ops, Boolean includeMain, Boolean includeSub,Boolean isInsert) 
	{
    //  Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name, DeveloperName FROM RecordType]);
        if(!hasExecutedCreateQuestions)
        {
	        Integer count = 0;
	        String currType = '', query = 'SELECT Id, Name, Category__r.Name, Category__r.Id,Question_Bank__r.Id,Question_Bank__r.Add_to_All_Opportunities__c, Question_Bank__r.Question_Bank_Name__c, Question_Bank__r.Data_Type__c, Category__r.Subcategory__c, ' +
	                                                'Order__c, Question_Bank__r.Fine_Print_Template__c, Question_Bank__r.Question_Section__c, ' +
	                                                'Question_Bank__r.Help_Text__c, Question_Bank__r.Picklist_Options__c, Question_Bank__r.Required__c FROM Question_Category__c WHERE ';
	        
	        /**
	            additional req:
	            If Add_to_All_Opportunities__c flag in Question_Bank__c is checked, add to them to Opportunity 
	            This only happends for insert
	        */
	        List<Question_Bank__c> questionBanksAddToAllList=new List<Question_Bank__c>();
	        if(isInsert){
	             questionBanksAddToAllList = [SELECT Id, Name, Question_Bank_Name__c, Data_Type__c,Fine_Print_Template__c, Question_Section__c, Help_Text__c, Picklist_Options__c, Required__c FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];
	        }
	        
	        for(Opportunity currOpp : ops) {
	            //currType = rtMap.containsKey(currOpp.RecordTypeId) ? rtMap.get(currOpp.RecordTypeId).Name : '';
	            /*
	                CR:Jan 17 2011:Defect 2439005: removing opportunity record type
	            */
	            currType = currOpp.Category__c!=null? currOpp.Category__c:'';
	            currType = currType.replace('\'', '\\\'');
	            String subCategory = currOpp.Subcategory__c!=null?currOpp.Subcategory__c:'';
	            subCategory = subCategory.replace('\'', '\\\'');
	            
	            if(includeMain && includeSub)
	                //query += '(Category__r.Name = \'' + currType + '\' OR (Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + currOpp.Subcategory__c + '\'))';
	                query += '(Category__r.Name = \'' + currType + '\' OR (Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + subCategory + '\'))';
	            else if(includeMain)
	                query += 'Category__r.Name = \'' + currType + '\'';
	            else if(includeSub)
	                //query += '(Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + currOpp.Subcategory__c + '\')';
	                query += '(Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + subCategory + '\')';
	            if(count==0 && ops.size()==1){
	                query +='';
	            }else   {
	                query +=  ' OR ';
	            } 
	            // original
	            //query += count > 0 ? ' OR ' : '';
	            count++;
	        }
	    
	        if(count > 1) {
	            query = query.substring(0, query.length() - 4);
	        }
	    
	        List<Question_Category__c> qcList = Database.query(query);
	        Map<String, List<Question_Category__c>> typeToCat = new Map<String, List<Question_Category__c>>();
	
	        for(Question_Category__c qc : qcList) {
	            if(typeToCat.containsKey(qc.Category__r.Subcategory__c + '-' + qc.Category__r.Name)) {
	                typeToCat.get(qc.Category__r.Subcategory__c + '-' + qc.Category__r.Name).add(qc);
	            } else {
	                typeToCat.put(qc.Category__r.Subcategory__c + '-' + qc.Category__r.Name, new List<Question_Category__c>{qc});
	            }
	            
	        }
	        
	        List<Question__c> qList = new List<Question__c>();
	
	        for(Opportunity currOpp : ops) {
	            //if(includeMain && typeToCat.containsKey('No-' + rtMap.get(currOpp.RecordTypeId).Name)) {
	            if(includeMain && typeToCat.containsKey('No-' + currOpp.Category__c)) {
	                //for(Question_Category__c currQc : typeToCat.get('No-' + rtMap.get(currOpp.RecordTypeId).Name)) {
	                for(Question_Category__c currQc : typeToCat.get('No-' + currOpp.Category__c)) {
	                    if(!currQc.Question_Bank__r.Add_to_All_Opportunities__c){
	                        Question__c aQuest = new Question__c(Question_Name__c = currQc.Question_Bank__r.Question_Bank_Name__c, Question_Bank__c = currQc.Question_Bank__r.Id, Required__c = currQc.Question_Bank__r.Required__c, From_Subcategory__c = false, Add_to_All_Opportunities__c = false,
	                                                         Picklist_Options__c = currQc.Question_Bank__r.Picklist_Options__c, Data_Type__c = currQc.Question_Bank__r.Data_Type__c, Question_Section__c = currQc.Question_Bank__r.Question_Section__c,
	                                                         Opportunity__c = currOpp.Id, Order__c = currQc.Order__c, Fine_Print_Template__c = currQc.Question_Bank__r.Fine_Print_Template__c, Help_Text__c = currQc.Question_Bank__r.Help_Text__c);                    
	                        qList.add(aQuest);
	                    }
	                }   
	            }
	            
	            if(includeSub && typeToCat.containsKey('Yes-' + currOpp.Subcategory__c)) {
	                for(Question_Category__c currQc : typeToCat.get('Yes-' + currOpp.Subcategory__c)) {
	                    if(!currQc.Question_Bank__r.Add_to_All_Opportunities__c){
	                        Question__c aQuest = new Question__c(Question_Name__c = currQc.Question_Bank__r.Question_Bank_Name__c, Question_Bank__c = currQc.Question_Bank__r.Id,Required__c = currQc.Question_Bank__r.Required__c, From_Subcategory__c = true, Add_to_All_Opportunities__c = false,
	                                                         Picklist_Options__c = currQc.Question_Bank__r.Picklist_Options__c, Data_Type__c = currQc.Question_Bank__r.Data_Type__c, Question_Section__c = currQc.Question_Bank__r.Question_Section__c,
	                                                         Opportunity__c = currOpp.Id, Order__c = currQc.Order__c, Fine_Print_Template__c = currQc.Question_Bank__r.Fine_Print_Template__c, Help_Text__c = currQc.Question_Bank__r.Help_Text__c);                    
	                        qList.add(aQuest);
	                    }
	                }                   
	            }
	            for(Question_Bank__c qb: questionBanksAddToAllList){
	                    Question__c aQuest = new Question__c(Question_Name__c = qb.Question_Bank_Name__c, Required__c = qb.Required__c, Question_Bank__c = qb.Id,From_Subcategory__c = true, Add_to_All_Opportunities__c = true,
	                                                         Picklist_Options__c = qb.Picklist_Options__c, Data_Type__c = qb.Data_Type__c, Question_Section__c = qb.Question_Section__c,
	                                                         Opportunity__c = currOpp.Id, Fine_Print_Template__c = qb.Fine_Print_Template__c, Help_Text__c = qb.Help_Text__c);                  
	                    qList.add(aQuest);
	            }
	            
	        }
	    
	        insert qList;
	        hasExecutedCreateQuestions = true;
        }
    }
    
    private static Boolean hasExecutedDeleteQuestions{ get{if(hasExecutedDeleteQuestions == null) hasExecutedDeleteQuestions = false; return hasExecutedDeleteQuestions;} private set;}
	private  void deleteQuestions(List<Opportunity> ops, Boolean includeMain, Boolean includeSub) {
		if(!hasExecutedDeleteQuestions)
		{
	        List<Id> deleteThese = new List<Id>();
	        List<Id> updateThese = new List<Id>();
	        for(Opportunity o : ops) {
	            deleteThese.add(o.Id);
	        }
	        /**
	            Feb 14 2011:Design Change: do not delete the question with Question_Bank__r.Add_to_All_Opportunities__c = true
	        */
	        List<Question__c> listOfQuestions = new List<Question__c>();
	        if(includeMain && includeSub) {
	            listOfQuestions=[SELECT Id,Question_Bank__r.Add_to_All_Opportunities__c FROM Question__c WHERE Opportunity__c in :deleteThese LIMIT 10000];
	        } else if(includeMain) {
	            listOfQuestions=[SELECT Id,Question_Bank__r.Add_to_All_Opportunities__c FROM Question__c WHERE Opportunity__c in :deleteThese AND (From_Subcategory__c = FALSE OR Add_to_All_Opportunities__c = true) LIMIT 10000];
	        } else if(includeSub) {
	            listOfQuestions=[SELECT Id,Question_Bank__r.Add_to_All_Opportunities__c FROM Question__c WHERE Opportunity__c in :deleteThese AND (FROM_Subcategory__c = TRUE OR Add_to_All_Opportunities__c = true) LIMIT 10000];
	        }
	        List<Question__c> listOfQuestionsToDelete = new List<Question__c>();
	        for(Question__c q: listOfQuestions){
	            /*
	                if the q.Question_Bank__r.Add_to_All_Opportunities__c == true not delete
	            */
	            if(q.Question_Bank__r.Add_to_All_Opportunities__c==false){
	                 listOfQuestionsToDelete.add(q);
	            }
	        }
	        
	        if(listOfQuestionsToDelete.size()>0){
	            delete listOfQuestionsToDelete;
	        }
	        
	        hasExecutedDeleteQuestions = true;
		}
    }
    
    private static Boolean hasExecutedUpdateQuestions{ get{if(hasExecutedUpdateQuestions == null) hasExecutedUpdateQuestions = false; return hasExecutedUpdateQuestions;} private set;}
	private void updateQuestions(List<Opportunity> oldOps, List<Opportunity> newOps) {
		if(!hasExecutedUpdateQuestions)
		{ 
	        List<Opportunity> ops = filterOpportunities(oldOps, newOps, true, true);
	
	        if(ops.size() > 0) {
	            deleteQuestions(ops, true, true);
	            createQuestions(ops, true, true,false);
	        }
	        
	        ops = filterOpportunities(oldOps, newOps, true, false);
	        
	        if(ops.size() > 0) {
	            deleteQuestions(ops, true, false);
	            createQuestions(ops, true, false,false);
	        }
	        
	        ops = filterOpportunities(oldOps, newOps, false, true);
	        
	        if(ops.size() > 0) {
	            deleteQuestions(ops, false, true);
	            createQuestions(ops, false, true,false);
	        }
	        
	        hasExecutedUpdateQuestions = true;       
		}
    }
    
    private List<Opportunity> filterOpportunities(List<Opportunity> oldOps, List<Opportunity> newOps, Boolean includeMain, Boolean includeSub) {
        
        List<Opportunity> filteredList = new List<Opportunity>();
        for(Integer index = 0; index < oldOps.size(); index++) {
            if(includeMain && includeSub) {
                //if(oldOps[index].RecordTypeId != newOps[index].RecordTypeId && oldOps[index].Subcategory__c != newOps[index].Subcategory__c) {
                if(oldOps[index].Category__c != newOps[index].Category__c && oldOps[index].Subcategory__c != newOps[index].Subcategory__c) {
                    filteredList.add(newOps[index]);
                }
            } else if(includeMain) {
                //if(oldOps[index].RecordTypeId != newOps[index].RecordTypeId && oldOps[index].Subcategory__c == newOps[index].Subcategory__c) {
                if(oldOps[index].Category__c != newOps[index].Category__c && oldOps[index].Subcategory__c == newOps[index].Subcategory__c) {
                    filteredList.add(newOps[index]);
                }
            } else if(includeSub) {
                //if(oldOps[index].Subcategory__c != newOps[index].Subcategory__c && oldOps[index].RecordTypeId == newOps[index].RecordTypeId) {
                if(oldOps[index].Subcategory__c != newOps[index].Subcategory__c && oldOps[index].Category__c == newOps[index].Category__c) {
                    filteredList.add(newOps[index]);
                }
            }
        }
        
        return filteredList;
    }
}