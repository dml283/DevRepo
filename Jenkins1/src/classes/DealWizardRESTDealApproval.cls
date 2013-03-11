@RestResource(urlMapping='/v1.0/wizard/deal/approval')
global class DealWizardRESTDealApproval {

	@HttpPost
	global static DealWizardApprover submit_for_approval(DealWizardDeal deal){
		return deal.submit_for_approval();
	}
}