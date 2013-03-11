/**	  
*	  OpportunityBatch
*	 
*	  author:  Shuji Iida
*	  date:    Jan 18 2011
*	  version: 1.0 
*	
*	 1.  Iterate Over all opportunities
*	 2.  Build new questionnaires set for an opportunity
*	 3.  Ignore duplicates and add new 
				
*    4.  If there is new set Sales Stages to Incomplete	 
*     
Question_Name__c = currQc.Question_Bank__r.Question_Bank_Name__c, Required__c = currQc.Question_Bank__r.Required__c, From_Subcategory__c = false, Add_to_All_Opportunities__c = false,
														 Picklist_Options__c = currQc.Question_Bank__r.Picklist_Options__c, Data_Type__c = currQc.Question_Bank__r.Data_Type__c, Question_Section__c = currQc.Question_Bank__r.Question_Section__c,
														 Opportunity__c = currOpp.Id, Order__c = currQc.Order__c, Fine_Print_Template__c = currQc.Question_Bank__r.Fine_Print_Template__c, Help_Text__c = currQc.Question_Bank__r.Help_Text__c
*/ 

global class OpportunityBatch implements Database.Batchable<sObject>,Database.Stateful{
    
   	global final String Query;
   
   	global OpportunityBatch(String q){
          Query = q;
   	} 

   	global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(Query);
   	}
   //	private Map<Id,Map<Id,Question__c>> createExistingMap(List<Opportunity> oppsList){
   			
   	
   	//}
    global void execute(Database.BatchableContext BC, List<Opportunity> opps){
    	/*
			1. query all questions and construct Map oppId, Map<Question_Bank__c,question>
		*/
 		List<Question__c> existingQuestions =[select id,Question_Bank__c,Answer__c,Question_Name__c, Required__c, 
 											  From_Subcategory__c , Add_to_All_Opportunities__c , Picklist_Options__c, 
 											  Data_Type__c , Question_Section__c, Opportunity__c, Order__c , 
 											  Fine_Print_Template__c , Help_Text__c 
 											  from Question__c
 											  where Opportunity__c in :opps order by Opportunity__c];
 		//System.Debug('OppotunityBatch:existingAllQuestions.size()=' + existingQuestions.size() +'-------------');									  
    	Map<Id,Map<Id,Question__c>> mapOfExistingQuestions = new Map<Id,Map<Id,Question__c>>();
   		// ensure all opportunity id and map created. 
   		for(Opportunity op:opps){
   			mapOfExistingQuestions.put(op.Id,new Map<Id,Question__c>());
   		}	
    	for(Question__c q:existingQuestions){
    	     if(q.Question_Bank__c!=null){
	    	     if(mapOfExistingQuestions.containsKey(q.Opportunity__c)){
	    	     	//System.debug('Suppose to be here!!!!:q.Question_Bank__c=' + q.Question_Bank__c);
	    	     	if(!mapOfExistingQuestions.get(q.Opportunity__c).containsKey(q.Question_Bank__c)){
	    	     		mapOfExistingQuestions.get(q.Opportunity__c).put(q.Question_Bank__c,q);
	    	     	}else{
	    	     			System.debug('This is Exception!:contain duplicate question bank in a opportunity');
	    	     	}
	    	     }
	    	     else
	    	     {
	    	     	System.debug('This is Exception!!!');
	    	     	//if comes to here. exception
	    	     	//Map<Id,Question__c> mapOfQuestions =new Map<Id,Question__c>();
	    	     	//mapOfQuestions.put(q.Question_Bank__c,q);
	    		 	//mapOfExistingQuestions.put(q.Opportunity__c,mapOfQuestions);
	    		 }
    	     }
    	}
        /*
			2. create new set of questions- map oppId, list<question>
		*/
        Map<Id,List<Question__c>> mapOfNewQuestions = createNewQuestions(opps,true,true);
        
        /*	 
        	3. for each opportunity and the new list of questions
        		-prepare for newQuestionsList
				-prepare for deleted. 
                
                go through old questions 

				1. if match found. remove from the list. 
				2. if match not found put in newQuestionList
				3. questions in old list put into deleteList
        */
        List<Question__c> questionsToBeCreatedList= new List<Question__c>();
        List<Question__c> questionsToBeUpdatedList= new List<Question__c>();
        List<Question__c> questionsToBeDeletedList= new List<Question__c>();
        List<Opportunity> oppsListToSetImcomplete = new List<Opportunity>();
        
     	for(Opportunity op: opps){
     		Boolean imcompleteFlag=false;
     		List<Question__c> listOfNewQuestions = mapOfNewQuestions.get(op.Id);
     		//System.Debug('OppotunityBatch:listOfNewQuestions.size()=' + listOfNewQuestions.size() +'-------------');
     		Map<Id,Question__c> existingQuestionsMap = mapOfExistingQuestions.get(op.Id);
     		//System.Debug('OppotunityBatch:Check here:existingQuestions.value().size()=' + existingQuestionsMap.values().size() +'-------------');
     		//Map<Id,Question__c> = 
     		for(Question__c q : listOfNewQuestions){
     		      Question__c existingQ = existingQuestionsMap.get(q.Question_Bank__c);
     		      System.Debug('OppotunityBatch: Check2 :existingQ=' + existingQ +',q.Question_Bank__c=' +q.Question_Bank__c +',q.Id='+q.Id+'-------------');
     		      /*
     		      	1. if match found. remove from the list. 
     		      		also compare values between and if change found 
     		      		put question to updateList
     		      			Question_Name__c
     		      			Required__c  
     		      			Picklist_Options__c   
							Data_Type__c    
							Question_Section__c  
 							Fine_Print_Template__c 
 							Help_Text__c  
     		      	
					2. if match not found put in newQuestionList
					3. if(the question does not have answer__c)questions in old list put into deleteList
     		      */
     			  if(existingQ == null){
     			  	//2. if match not found put in newQuestionList
     			  	 questionsToBeCreatedList.add(q);
     			  	 imcompleteFlag=true;
     			  }else {
     			  	  if(existingQ.Question_Name__c != q.Question_Name__c ||
     		      		 existingQ.Required__c  != q.Required__c ||
     		      		 existingQ.Picklist_Options__c !=  q.Picklist_Options__c ||  
						 existingQ.Data_Type__c != q.Data_Type__c    ||
						 existingQ.Question_Section__c  !=q.Question_Section__c  ||
 						 existingQ.Fine_Print_Template__c != q.Fine_Print_Template__c ||
 						 existingQ.Help_Text__c !=  q.Help_Text__c ){
 					   		 // coppy all fields from new to existing and update
 					   		 existingQ.Question_Name__c = q.Question_Name__c;
     		      		     existingQ.Required__c  = q.Required__c;
     		      		     existingQ.Picklist_Options__c =  q.Picklist_Options__c; 
						     existingQ.Data_Type__c = q.Data_Type__c;
						     existingQ.Question_Section__c  =q.Question_Section__c;
 							 existingQ.Fine_Print_Template__c = q.Fine_Print_Template__c;
 						     existingQ.Help_Text__c = q.Help_Text__c;
 					         // update
 					         questionsToBeUpdatedList.add(existingQ);
 					   } 
     			  	// 1. if match found. remove from the list.
     			  	 existingQuestionsMap.remove(q.Question_Bank__c);
     			  }
     		} 
     		System.Debug('OppotunityBatch: Check 1 :questionsToBeCreatedList.size()=' + questionsToBeCreatedList.size() +'-------------');
     		//3. questions in old list put into deleteList 
     		System.Debug('OppotunityBatch: Check 2 :existingQuestionsMap.values().size()=' + existingQuestionsMap.values().size() +'-------------');
     		for(Question__c qa: existingQuestionsMap.values()){
     		  // if(qa.Answer__c==null){
     		   	  questionsToBeDeletedList.add(qa);
     		  //}
     		}
     		if(imcompleteFlag==true){
     			op.Sales_Stages__c='Incomplete';
     			oppsListToSetImcomplete.add(op);
     		}
     		System.Debug('OppotunityBatch: Check 3 :questionsToBeDeletedList.size()=' + questionsToBeDeletedList.size() +'-------------');
     	 }	
     	 System.Debug('OppotunityBatch: Check 5 :questionsToBeUpdatedList.size()=' + questionsToBeUpdatedList.size() +'-------------');
     	if(oppsListToSetImcomplete.size()>0){
     		update oppsListToSetImcomplete;
     	} 
     	if(questionsToBeCreatedList.size()>0){ 
     		insert questionsToBeCreatedList;
     	}
     	if(questionsToBeUpdatedList.size()>0){ 
     		update questionsToBeUpdatedList;
     	}
     	if(questionsToBeDeletedList.size()>0){
     		delete questionsToBeDeletedList;
     	}
      
     	
    }

   global void finish(Database.BatchableContext BC){
   
   } 
   
   private Map<Id,List<Question__c>>  createNewQuestions(List<Opportunity> ops, Boolean includeMain, Boolean includeSub) {
	//	Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name, DeveloperName FROM RecordType]);
		
		Integer count = 0;
		String currType = '', query = 'SELECT Id, Name, Category__r.Name, Category__r.Id,Question_Bank__r.Id,Question_Bank__r.Add_to_All_Opportunities__c, Question_Bank__r.Question_Bank_Name__c, Question_Bank__r.Data_Type__c, Category__r.Subcategory__c, ' +
												'Order__c, Question_Bank__r.Fine_Print_Template__c, Question_Bank__r.Question_Section__c, ' +
		                                        'Question_Bank__r.Help_Text__c, Question_Bank__r.Picklist_Options__c, Question_Bank__r.Required__c FROM Question_Category__c WHERE ';

		/**
			additional req:
			If Add_to_All_Opportunities__c flag in Question_Bank__c is checked, add to them to Opportunity 
		*/
		List<Question_Bank__c> questionBanksAddToAllList = [SELECT Id, Name, Question_Bank_Name__c, Data_Type__c,Fine_Print_Template__c, Question_Section__c, Help_Text__c, Picklist_Options__c, Required__c FROM Question_Bank__c WHERE Add_to_All_Opportunities__c = true];
		
		
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
				query += '(Category__r.Name = \'' + currType + '\' OR (Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + subCategory + '\'))';
				//query += '(Category__r.Name = \'' + currType + '\' OR (Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + currOpp.Subcategory__c + '\'))';
			else if(includeMain)
				query += 'Category__r.Name = \'' + currType + '\'';
			else if(includeSub)
				query += '(Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + subCategory + '\')';
				//query += '(Category__r.Subcategory__c = \'Yes\' AND Category__r.Name = \'' + currOpp.Subcategory__c + '\')';
			
			//this is throwing the error. 	
			//query += count > 0 ? ' OR ' : '';
			// so I changed to this. 
			if(count==0 && ops.size()==1){
				query +='';
			}else	{
			    query +=  ' OR ';
			} 
			count++;
		}
	   
		if(count > 1) {
			query = query.substring(0, query.length() - 4);
		}
	    System.Debug('OppotunityBatch: Check 4 :query=' +  query +'-------------');
		List<Question_Category__c> qcList = Database.query(query);
		Map<String, List<Question_Category__c>> typeToCat = new Map<String, List<Question_Category__c>>();

		for(Question_Category__c qc : qcList) {
			if(typeToCat.containsKey(qc.Category__r.Subcategory__c + '-' + qc.Category__r.Name)) {
				typeToCat.get(qc.Category__r.Subcategory__c + '-' + qc.Category__r.Name).add(qc);
			} else {
				typeToCat.put(qc.Category__r.Subcategory__c + '-' + qc.Category__r.Name, new List<Question_Category__c>{qc});
			}
			
		}
		
		
        Map<Id,List<Question__c>> mapOfNewQuestions = new Map<Id,List<Question__c>>();
		for(Opportunity currOpp : ops) {
			List<Question__c> qList = new List<Question__c>();
			//if(includeMain && typeToCat.containsKey('No-' + rtMap.get(currOpp.RecordTypeId).Name)) {
			if(includeMain && typeToCat.containsKey('No-' + currOpp.Category__c)) {
				//for(Question_Category__c currQc : typeToCat.get('No-' + rtMap.get(currOpp.RecordTypeId).Name)) {
				for(Question_Category__c currQc : typeToCat.get('No-' + currOpp.Category__c)) {
					if(!currQc.Question_Bank__r.Add_to_All_Opportunities__c){
						Question__c aQuest = new Question__c( Question_Bank__c = currQc.Question_Bank__r.Id,Question_Name__c = currQc.Question_Bank__r.Question_Bank_Name__c, Required__c = currQc.Question_Bank__r.Required__c, From_Subcategory__c = false, Add_to_All_Opportunities__c = false,
														 Picklist_Options__c = currQc.Question_Bank__r.Picklist_Options__c, Data_Type__c = currQc.Question_Bank__r.Data_Type__c, Question_Section__c = currQc.Question_Bank__r.Question_Section__c,
														 Opportunity__c = currOpp.Id, Order__c = currQc.Order__c, Fine_Print_Template__c = currQc.Question_Bank__r.Fine_Print_Template__c, Help_Text__c = currQc.Question_Bank__r.Help_Text__c);					
						qList.add(aQuest);
					}
				}	
			}
			
			if(includeSub && typeToCat.containsKey('Yes-' + currOpp.Subcategory__c)) {
				for(Question_Category__c currQc : typeToCat.get('Yes-' + currOpp.Subcategory__c)) {
					if(!currQc.Question_Bank__r.Add_to_All_Opportunities__c){
						Question__c aQuest = new Question__c( Question_Bank__c = currQc.Question_Bank__r.Id,Question_Name__c = currQc.Question_Bank__r.Question_Bank_Name__c, Required__c = currQc.Question_Bank__r.Required__c, From_Subcategory__c = true, Add_to_All_Opportunities__c = false,
														 Picklist_Options__c = currQc.Question_Bank__r.Picklist_Options__c, Data_Type__c = currQc.Question_Bank__r.Data_Type__c, Question_Section__c = currQc.Question_Bank__r.Question_Section__c,
														 Opportunity__c = currOpp.Id, Order__c = currQc.Order__c, Fine_Print_Template__c = currQc.Question_Bank__r.Fine_Print_Template__c, Help_Text__c = currQc.Question_Bank__r.Help_Text__c);					
						qList.add(aQuest);
					}
				}					
			}
		    for(Question_Bank__c qb: questionBanksAddToAllList){
		    		Question__c aQuest = new Question__c( Question_Bank__c = qb.Id,Question_Name__c = qb.Question_Bank_Name__c, Required__c = qb.Required__c, From_Subcategory__c = true, Add_to_All_Opportunities__c = true,
														 Picklist_Options__c = qb.Picklist_Options__c, Data_Type__c = qb.Data_Type__c, Question_Section__c = qb.Question_Section__c,
														 Opportunity__c = currOpp.Id, Fine_Print_Template__c = qb.Fine_Print_Template__c, Help_Text__c = qb.Help_Text__c);					
					qList.add(aQuest);
		    }
		    
		    mapOfNewQuestions.put(currOpp.Id,qList);
		}
	    
	    return mapOfNewQuestions;
	}

}