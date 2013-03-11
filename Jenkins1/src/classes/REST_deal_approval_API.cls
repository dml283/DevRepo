@RestResource(urlMapping='/v1.0/wizard/approval')

global class REST_deal_approval_API{

@HttpPOST
global static approval_request post(approval_request deal){
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    if(deal.id!=null){
        Opportunity o = [select id, Submitted_via_Deal_Wizard__c FROM Opportunity WHERE id = :deal.id LIMIT 1];
        o.Submitted_via_Deal_Wizard__c = true;
        try{
            database.update(o);
            }catch(exception e){
                system.debug(e);
            }
        Approval.ProcessSubmitRequest req1 =  new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval via Deal Wizard.');
            req1.setObjectId(o.id);
        // Submit the approval request for the account 
        Approval.ProcessResult result = Approval.process(req1);
        system.debug(result);
        if(result.isSuccess()){
            res.statusCode = 200;
        }else{
            res.statusCode = 400;
           // res.responseBody(result.getErrors())
        }
    }
    return deal;
}  

global class approval_request{
    public string id {get;set;}    
}

}