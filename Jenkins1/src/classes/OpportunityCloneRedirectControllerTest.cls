@isTest
private class OpportunityCloneRedirectControllerTest {

     static testMethod void testCustomCloneRedirect() {
         grouponTestUtil gTestUtil = new grouponTestUtil();
                User u = gTestUtil.createTestUser('System Administrator');
                u.UserName = 'cloneOppty@test.com';
                insert u;
                System.RunAs(u){
                        Division__c d = gTestUtil.createDivision();
                        d.Name = 'Evergreen';
                        insert d;
                        
                        Division__c d1 = gTestUtil.createDivision();
                        insert d1;
                        
                        account a = gTestUtil.createAccount();
                        a.name = 'Clone Test Acct';
                        insert a;
                        
                        Opportunity oppty = gTestUtil.createDeal();
                        oppty.AccountId = a.Id;
                        oppty.Division__c = 'Evergreen';
                        insert oppty;
                        
                        Opportunity oppty1 = gTestUtil.createDeal();
                        oppty1.AccountId = a.Id;
                        oppty1.Division__c = 'Training';
                        insert oppty1;
                    
                        Multi_Deal__c md = gTestUtil.createOption();
                        md.Opportunity__c = oppty.Id;
                        insert md;
                        
                        Question_Bank__c qb = new Question_Bank__c();
                        insert qb;
                        
                        Question__c q = new Question__c();
                        q.Opportunity__c = oppty.Id;
                        q.Question_Bank__c = qb.id;
                        insert q;
                        
                        Address__c addy = new Address__c();
                        addy.Opportunity__c = oppty.Id;
                        insert addy;

                        OpportunityCloneRedirectController ctrl = new OpportunityCloneRedirectController(new ApexPages.StandardController(oppty));
                        ctrl.cloneAndRedirect();                     
                        
                        OpportunityCloneRedirectController ctrl1 = new OpportunityCloneRedirectController(new ApexPages.StandardController(oppty1));
                        ctrl1.cloneAndRedirect();
                        
        }
    }
}