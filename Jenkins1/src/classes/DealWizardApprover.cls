global class DealWizardApprover {
	static final Boolean NONTRANSACTIONAL = false;

	public Boolean success { get;set; }
	public List<DealWizardError> errors { get;set; }

	public DealWizardApprover process( Id id, String comment ){
		Approval.ProcessResult result = submit_for_approval( id, comment);

		//if ( auto_approved ){
		//	result = approve( result );
		//}

		this.success = result.isSuccess();
		if ( this.success ){
			this.errors = new List<DealWizardError>();
		} else {
			this.errors =  format_errors( result );
		}
    return this;
	}

	private Approval.ProcessResult submit_for_approval( Id id, String comments ){
		Approval.ProcessSubmitRequest approval_request = new Approval.ProcessSubmitRequest();
		approval_request.setComments( comments );
		approval_request.setObjectId( id );

		return Approval.process( approval_request, NONTRANSACTIONAL );
  }

  private Approval.ProcessResult approve( Approval.ProcessResult approval_result ){
    Approval.ProcessWorkitemRequest approval_work_request = new Approval.ProcessWorkitemRequest();
    approval_work_request.setComments( 'Auto approved by Deal Wizard' );
    approval_work_request.setAction( 'Approve' );
    approval_work_request.setWorkitemId( approval_result.getNewWorkitemIds().get(0) );

    return Approval.process( approval_work_request, NONTRANSACTIONAL);
  }

  private List<DealWizardError> format_errors( Approval.ProcessResult approval_result ) {
  	if (approval_result.errors.isEmpty() ){
  		return new List<DealWizardError>();
  	} else {
	    List<DealWizardError> formatted_errors = new List<DealWizardError>();

	    List<Database.Error> approval_errors = approval_result.getErrors();

	    for ( Database.Error error : approval_errors ) {
	      DealWizardError formatted_error = new DealWizardError( error );

	      formatted_errors.add( formatted_error );
	    }
	    return formatted_errors;
	  }
  }
}