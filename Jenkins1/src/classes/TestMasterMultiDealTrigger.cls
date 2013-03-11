@isTest
private class TestMasterMultiDealTrigger {

    static testMethod void testSkuError() {     
        User u = TestUtil.createUserWithUsername('Inside Sales', 'mdTest@groupon.com', 'mdTest@groupon.com');

        //System.runAs(u){
        Test.startTest();
            Account a = setupAccount(); 
            Opportunity o = setupOpp(a);
            Multi_Deal__c m1 = setupMD1(o);
            System.assertEquals(m1.Product_SKU__c, '123');  
            Multi_Deal__c m2 = setupMD2(o);
            
            try{
                m2.Product_SKU__c = '123';
                update m2;  
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('This sku already exists on another multi deal!') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);
            }   
         Test.stopTest();
        //}
    }
    
    static Account setupAccount(){
        User s = TestUtil.createUserWithUsername('System Administrator', 'mdTestAdmin1@groupon.com', 'mdTestAdmin1@groupon.com');
        Account a;
        System.runAs(s){
            a= TestUtil.createAccount();
        }
        return a;
    }
    
    static Opportunity setupOpp(Account a){
        User s1 = TestUtil.createUserWithUsername('System Administrator', 'mdTestAdmin2@groupon.com', 'mdTestAdmin2@groupon.com');
        Division__c div;
        Opportunity o;
        System.runAs(s1){
            div = TestUtil.createDivision();
            o= TestUtil.createOpptywAcctDivStrengthStage(a, div, 'test','test');
        }
        return o;
    }
    
    static Multi_Deal__c setupMD1(Opportunity o){
        User s2 = TestUtil.createUserWithUsername('System Administrator', 'mdTestAdmin3@groupon.com', 'mdTestAdmin3@groupon.com');
        Multi_Deal__c m1;
        System.runAs(s2){
            m1 = TestUtil.createMDwithSku(o, '123');
        }
        insert m1;
        return m1;
    }
    
    static Multi_Deal__c setupMD2(Opportunity o){
        User s3 = TestUtil.createUserWithUsername('System Administrator', 'mdTestAdmin4@groupon.com', 'mdTestAdmin4@groupon.com');
        Multi_Deal__c m2;
        System.runAs(s3){
            m2 = TestUtil.createMDwithSku(o, '124');
        }
        insert m2;
        return m2;
    }
    
}