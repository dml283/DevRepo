//           Question_DW__c
public class DealWizardQuestion {

  public String answer {get;set;}
  public String deal_id {get;set;}
  public String dw_id {get;set;}
  public String id {get;set;}
  public String question_label {get;set;}
  
  public static final Map<String, String> sobject_to_json_field_map =
    new Map<String, String>{
      'Answer__c'       => 'answer',
      'Opportunity__c'  => 'deal_id',
      'DWID__c'         => 'dw_id',
      'id'              => 'id',
      'Questions__c'    => 'question_label'
    };

	public DealWizardQuestion() { }

  public DealWizardQuestion( Question_DW__c q ) {
    this.question_label = q.questions__c;
    this.deal_id = q.opportunity__c;
    this.dw_id = q.dwid__c;
    this.answer = q.answer__c;
    this.id = q.id;
  }

  public static void load_all_for( DealWizardDeal deal ) {

    for ( question_dw__c q : deal.opportunity.Questions1__r ) {

      deal.questions.add( new DealWizardQuestion( q ) );
    }
  }
  
  public static String build_question_query_string() {
  	return ' SELECT ' +
        'answer__c, ' +
        'dwid__c, ' +
        'id, ' +
        'opportunity__c, ' +
        'questions__c from Questions1__r ';
  }
  
  public static void delete_all_except( Set<Id> question_ids, DealWizardDeal deal ) {
  	
    List< Question_DW__c > questions = [select id from Question_DW__c where id not in :question_ids AND Opportunity__c = :deal.id];
    try {
      Database.delete( questions );
    }
    catch ( DMLException anException ) {
      deal.add_and_log_dml_exception_error( anException, 'questions', new Map<String, String>{ /** N/A **/ } );
    }
    catch ( Exception anException ) {
      deal.add_and_log_exception_error( anException, 'questions', new Map<String, String>{ /** N/A **/ } );
    }
  }
  
  public static Boolean upsert_all_for( DealWizardDeal deal ) {
  	
    List<Question_DW__c> question_sobj = new List<Question_DW__c>();
    Set<Id> question_ids_to_persist = new Set<id>();
    Boolean saved_without_error = true;
    
    try {
        if ( deal.questions!=null && deal.questions.size()>0 ) {
        	
          for(DealWizardQuestion q : deal.questions){
          	
            question_sobj.add(q.get_sobject());
            
            if ( q.id != null ) {
            	question_ids_to_persist.add(q.id);
            }
          }
        }
    }
    catch ( Exception anException ) {
      deal.add_and_log_exception_error( anException, 'questions', DealWizardQuestion.sobject_to_json_field_map );
      saved_without_error = false;
    }
    
    if ( saved_without_error ) {
	    DealWizardQuestion.delete_all_except( question_ids_to_persist, deal );
    }
    
    try{
      Database.upsert(question_sobj);
    }
    catch ( DMLException anException ) {
      deal.add_and_log_dml_exception_error( anException, 'questions', DealWizardQuestion.sobject_to_json_field_map );
      saved_without_error = false;
    }
    catch ( Exception anException ) {
      deal.add_and_log_exception_error( anException, 'questions', DealWizardQuestion.sobject_to_json_field_map );
      saved_without_error = false;
    }

    if ( saved_without_error ) {
      DealWizardQuestion.load_all_for( deal );
    }
    
    return saved_without_error;
  }

  public Question_DW__c get_sobject() {
    Question_DW__c q;
    if (this.id!=null || this.id!='') {
      q= new Question_DW__c(id=this.id, opportunity__c = this.deal_id);
    }
    else {
      q= new Question_DW__c(opportunity__c = this.deal_id);
    }
    
      q.answer__c = this.answer;
      q.dwid__c = this.dw_id;
      q.questions__c = this.question_label;
      return q;
  }

}