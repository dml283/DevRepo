@isTest
public class testOpportunityCloneLive{
        static testMethod void testCloneLiveDeal(){
                grouponTestUtil gTestUtil = new grouponTestUtil();
                User u = gTestUtil.createTestUser('System Administrator');
                u.UserName = 'cloneOppty@test.com';
                insert u;
                System.RunAs(u){
                        Division__c d = gTestUtil.createDivision();
                        insert d;
                        
                        account a = gTestUtil.createAccount();
                        a.name = 'Clone Test Acct';
                        insert a;
                        
                        Opportunity oppty = gTestUtil.createDeal();
                        oppty.AccountId = a.Id;
                        oppty.Division__c = 'Training';
                        insert oppty;
                    
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
                        
                        //TEST OpportunityCloneLive
                        OpportunityCloneLive ctrl3 = new OpportunityCloneLive(new ApexPages.StandardController(oppty));
                        ctrl3.cloneAndRedirectLive();

                    }
            }

    }