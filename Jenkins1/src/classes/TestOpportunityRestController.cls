@isTest(SeeAllData=true)
private class TestOpportunityRestController {
    static testMethod void testUpdateOpportunity() {
    	User u = TestUtil.createUser('System Administrator');       
	    System.runAs(u){  
	    	String notes = 'Test notes';
	       	Opportunity o = TestUtil.createOpptyWacct(); 
	       	String Id = o.Id;  
	        Test.startTest();  	
			    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
			    OpportunityRestController orc = new OpportunityRestController();
			    HttpResponse res = new HttpResponse();
			    PerfectPipeline.addRepNotes(id,notes);
	  			o = PerfectPipeline.findOpportunity(id);
			Test.stopTest();
	    }
    }
}