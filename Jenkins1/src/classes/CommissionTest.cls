@IsTest
public class CommissionTest{

public static void testCommissionResultCreationWithDate(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    Division__c testDivision = util.createDivision();
    insert testDivision;
    
    Decimal testGrossBillingGoal = 150000;
    
    System.runAs(testUser){
        CommissionResult result = new CommissionResult(testUser.id, System.today());
    }
 }

public static void testSalesGoalCreation(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    Division__c testDivision = util.createDivision();
    insert testDivision;
    
    Decimal testGrossBillingGoal = 150000;
    
    System.runAs(testUser){
        CommissionResult result = new CommissionResult();
        Sales_Goal__c testSalesGoal = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
        insert testSalesGoal;
    
        test.StartTest();
            result.setGoal();
            System.AssertEquals(result.goal.gb_goal, testGrossBillingGoal);
            System.AssertEquals(result.goal.highTarget, false);
            System.AssertEquals(result.goal.divisions.size(), 1);
            
            Sales_Goal__c testSalesGoal2 = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
            insert testSalesGoal2;
            
            result = new CommissionResult();
            result.setGoal();
            System.AssertEquals(result.goal.gb_goal, (testGrossBillingGoal*2));
            System.AssertEquals(result.goal.highTarget, True);
            System.AssertEquals(result.goal.divisions.size(), 2);
        
        test.StopTest();

    }
}
@istest
public static void testDealSummary(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;
        
        Account testAccount = util.createAccount();
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
        testOpportunity.feature_date__c = system.today().toStartOfMonth();
        testOpportunity.feature_end_date__c = system.today();
        testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 100000;
        Decimal GrossBillings = 200000;
        Decimal Refunds = 100;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;
        
        CommissionResult result = new CommissionResult();
    
        test.StartTest();
            result.addDeals();
            //system.assertEquals(result.deals.size(), 1);
           // system.assertEquals(result.deals[0].transactions.size(), 1);
           // system.assertEquals(result.deals[0].grossBillings, GrossBillings);
           // system.assertEquals(result.deals[0].grossProfit, GrossProfit);
           // system.assertEquals(result.deals[0].refunds, Refunds);
        test.StopTest();
    }
}
@istest
public static void testDealSummaryMultipleCollectionsDates(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Services';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
         testOpportunity.feature_date__c = system.today().toStartOfMonth();
         testOpportunity.feature_end_date__c = system.today();
            testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 50000;
        Decimal GrossBillings = 200000;
        Decimal Refunds = 100;
        
        Deal_Accelerator_Threshold__c dat = new Deal_Accelerator_Threshold__c();
            dat.division__c = testDivision.id;
            dat.category__c = 'Services';
            dat.Food_and_Drink_Threshold__c = 500;
            dat.DreamList_Threshold__c = 500;
            dat.HVA_Threshold__c = 500;
            dat.LS_Threshold__c = 500;
        insert dat;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;
        
        Financial_Records__c testFinancialRecord2 = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord2;
        
        CommissionResult result = new CommissionResult();
    
        test.StartTest();
            result.addDeals();
           // system.assertEquals(result.deals.size(), 1);
           // system.assertEquals(result.deals[0].transactions.size(), 2);
           // system.assertEquals(result.deals[0].grossBillings, 2*GrossBillings);
           // system.assertEquals(result.deals[0].grossProfit, 2*GrossProfit);
           // system.assertEquals(result.deals[0].refunds, 2*Refunds);
           // system.assertEquals(result.deals[0].getMargin(), .25);
        test.StopTest();
    }
}
@istest
public static void testPayoutTable(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        CommissionTable commissionTable = new CommissionTable();
        Decimal MinTarget = 1.1;
        Decimal MaxTarget = 1.15;
        Decimal NewDeal = .03;
        Decimal Refeature = .025;
        Decimal OutOfMarket = .015;
        Decimal Kicker = 7.5;
        Boolean highTarget = false;
        
        CommissionTable testCommissionTableWithNoPayouts = new CommissionTable(1.125,false);
        System.assertEquals(testCommissionTableWithNoPayouts.newDealRate, 0);
        
        PayoutTable__c testPayoutTable = util.getPayoutTable();
        commissionTable.setPayout(testPayoutTable);
        System.AssertEquals(commissionTable.newDealRate, .005);
        
        PayoutTable__c testPayoutTable2 = util.getPayoutTable(MinTarget,MaxTarget,NewDeal,Refeature,OutOfMarket,Kicker,highTarget);
        insert testPayoutTable2;
        
        //test setting the payout table
        commissionTable.setPayout(testPayoutTable2);
        System.AssertEquals(commissionTable.newDealRate, NewDeal);
        
        //create a payout for hightarget and no kicker
        NewDeal = .0375;
        Refeature = .0325;
        OutOfMarket = .015;
        highTarget = true;
        
        PayoutTable__c testPayoutTable3 = util.getPayoutTable(MinTarget,MaxTarget,NewDeal,Refeature,OutOfMarket,Kicker,highTarget);
        insert testPayoutTable3;
        
        //test to make sure that the two payout tables return different results based on high or low target - currently at 250k
        CommissionTable testCommissionTable = new CommissionTable(1.125,false);
        //System.AssertEquals(testCommissionTable.newDealRate, .03);
        
        CommissionTable testCommissionTable2 = new CommissionTable(1.125,true);
       // System.AssertEquals(testCommissionTable2.newDealRate, .0375);
    }
}
@istest
public static void testDealSummaryWithSingleKicker(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;

        Decimal testGrossBillingGoal = 100000;
    
        Sales_Goal__c testSalesGoal = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
        insert testSalesGoal;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Services';
            testAccount.Top_Merchant_Campaign__c = 'LS';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
        testOpportunity.feature_date__c = system.today().toStartOfMonth();
        testOpportunity.feature_end_date__c = system.today();
        testOpportunity.division__c = testDivision.name;
        testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Deal_Accelerator_Threshold__c dat = new Deal_Accelerator_Threshold__c();
            dat.division__c = testDivision.id;
            dat.category__c = 'Services';
            dat.Food_and_Drink_Threshold__c = 500;
            dat.DreamList_Threshold__c = 500;
            dat.HVA_Threshold__c = 500;
            dat.LS_Threshold__c = 500;
        insert dat;
        
        Decimal GrossProfit = 10000;
        Decimal GrossBillings = 50000;
        Decimal Refunds = 100;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;
        
        Financial_Records__c testFinancialRecord2 = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord2;
        
        CommissionResult result = new CommissionResult();
            
        test.StartTest();
            result.run();
           // System.AssertEquals(result.percentToGoal,1);
           // System.AssertEquals(result.deals[0].grossBillings, 100000);
        test.StopTest();
    }
}
@istest
public static void testDealSummaryWithTwoKickers(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;

        Decimal testGrossBillingGoal = 100000;
    
        Sales_Goal__c testSalesGoal = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
        insert testSalesGoal;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Food & Drink';
            testAccount.Top_Merchant_Campaign__c = 'DreamList';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
        testOpportunity.feature_date__c = system.today().toStartOfMonth();
        testOpportunity.feature_end_date__c = system.today();
        testOpportunity.division__c = testDivision.name;
        testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 10000;
        Decimal GrossBillings = 50000;
        Decimal Refunds = 100;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;
        
        Financial_Records__c testFinancialRecord2 = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord2;
        
        CommissionResult result = new CommissionResult();
            
        test.StartTest();
            result.addDeals();
            result.setGoal();
            //result.calculatePercentToGoal();
           // System.AssertEquals(result.percentToGoal,1);
           // System.AssertEquals(result.deals[0].grossBillings, 100000);
        test.StopTest();
    }
}
@istest
public static void testDealSummaryWithThreeKickers(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;

        Decimal testGrossBillingGoal = 100000;
    
        Sales_Goal__c testSalesGoal = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
        insert testSalesGoal;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Food & Drink';
            testAccount.Top_Merchant_Campaign__c = 'DreamList';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
            testOpportunity.feature_date__c = system.today().toStartOfMonth();
            testOpportunity.feature_end_date__c = system.today();
            testOpportunity.division__c = testDivision.name;
            testOpportunity.RecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' and Name = 'gLite'].Id;
            testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 10000;
        Decimal GrossBillings = 50000;
        Decimal Refunds = 100;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;
        
        Financial_Records__c testFinancialRecord2 = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord2;
        
        CommissionResult result = new CommissionResult();
            
        test.StartTest();
            result.run();
           // System.AssertEquals(result.percentToGoal,1);
           // System.AssertEquals(result.deals[0].grossBillings, 100000);
        test.StopTest();
    }
}
@istest
public static void testDealSummaryWithFeatureDateInPast(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;

        Decimal testGrossBillingGoal = 100000;
    
        Sales_Goal__c testSalesGoal = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
        insert testSalesGoal;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Food & Drink';
            testAccount.Top_Merchant_Campaign__c = 'DreamList';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
            testOpportunity.feature_date__c = Date.parse('11/13/2012');
            testOpportunity.feature_end_date__c = system.today();
            testOpportunity.division__c = testDivision.name;
            testOpportunity.RecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' and Name = 'gLite'].Id;
            testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 10000;
        Decimal GrossBillings = 50000;
        Decimal Refunds = 100;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;
        
        Financial_Records__c testFinancialRecord2 = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord2;
        
        CommissionResult result = new CommissionResult(testUser.id);
            
        test.StartTest();
            result.run();
           // System.AssertEquals(result.percentToGoal,1);
           // System.AssertEquals(result.deals[0].grossBillings, 100000);
        test.StopTest();
    }
}
@istest
public static void testRoundingModeVerifyRoundsDown(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;

        Decimal testGrossBillingGoal = 100000;
    
        Sales_Goal__c testSalesGoal = util.createSalesGoal(testGrossBillingGoal,testUser,testDivision);
        insert testSalesGoal;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Services';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
        testOpportunity.feature_date__c = system.today().toStartOfMonth();
        testOpportunity.feature_end_date__c = system.today();
        testOpportunity.division__c = testDivision.name;
        testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 10000;
        Decimal GrossBillings = 104999;
        Decimal Refunds = 100;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        insert testFinancialRecord;

        
        CommissionResult result = new CommissionResult();
            
        test.StartTest();
            result.run();
            system.assertEquals(result.percentToGoal,1.04);
        test.StopTest();
    }
}
@istest
public static void testFailingFoodAndDrinkOutsideOfCurrentMonth(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Food & Drink';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
         testOpportunity.feature_date__c = Date.Parse('1/30/2013');
         testOpportunity.feature_end_date__c = Date.Parse('2/3/2013');
            testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 50000;
        Decimal GrossBillings = 9980;
        Decimal Refunds = 100;
        
        Sales_Goal__c testSalesGoal = util.createSalesGoal(50000,testUser,testDivision);
        testSalesGoal.goal_start_date__c = Date.Parse('1/1/2013');
        testSalesGoal.goal_end_date__c = Date.Parse('1/31/2013');
        insert testSalesGoal;
        
        Deal_Accelerator_Threshold__c dat = new Deal_Accelerator_Threshold__c();
            dat.division__c = testDivision.id;
            dat.category__c = 'Food & Drink';
            dat.Food_and_Drink_Threshold__c = 10000;
        insert dat;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        testFinancialRecord.collection_date__c = Date.Parse('1/30/2013');
        insert testFinancialRecord;
        
        CommissionResult result = new CommissionResult(testUser.id, Date.Parse('1/1/2013'));
    
        test.StartTest();
            result.run();
            system.AssertEquals(1, result.deals[0].dealAccelerator.GrossBillingsAccelerator);
        test.StopTest();
    }
}
@istest
public static void testFoodAndDrinkOutsideOfCurrentMonth(){
    GrouponTestUtil util = new GrouponTestUtil();
    
    User testUser = util.createTestUser('System Administrator');
    insert testUser;
    
    system.runAs(testUser){
        Division__c testDivision = util.createDivision();
        insert testDivision;
        
        Account testAccount = util.createAccount();
            testAccount.Category_v3__c = 'Food & Drink';
        insert testAccount;
        
        Opportunity testOpportunity = util.createDeal(testAccount);
         testOpportunity.feature_date__c = Date.Parse('1/30/2013');
         testOpportunity.feature_end_date__c = Date.Parse('2/3/2013');
         testOpportunity.Division__c = testDivision.name;
         testOpportunity.Division_Dynamic__c = testDivision.id;
         testOpportunity.deal_strengh__c = 'A Sure Thing';
        insert testOpportunity;
        
        Multi_Deal__c testOption = util.createOption(testOpportunity);
        insert testOption;
        
        Decimal GrossProfit = 50000;
        Decimal GrossBillings = 9980;
        Decimal Refunds = 100;
        
        Deal_Accelerator_Threshold__c dat = new Deal_Accelerator_Threshold__c();
            dat.division__c = testDivision.id;
            dat.category__c = 'Food & Drink';
            dat.Food_and_Drink_Threshold__c = 10000;
        insert dat;
        
        Sales_Goal__c testSalesGoal = util.createSalesGoal(50000,testUser,testDivision);
        testSalesGoal.goal_start_date__c = Date.Parse('1/1/2013');
        testSalesGoal.goal_end_date__c = Date.Parse('1/31/2013');
        insert testSalesGoal;
        
        Financial_Records__c testFinancialRecord = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        testFinancialRecord.collection_date__c = Date.Parse('1/30/2013');
        insert testFinancialRecord;
        
        Financial_Records__c testFinancialRecord2 = util.createFinancialRecord(testOpportunity, GrossProfit, GrossBillings, Refunds);
        testFinancialRecord2.collection_date__c = Date.Parse('2/1/2013');
        insert testFinancialRecord2;
        
        CommissionResult result = new CommissionResult(testUser.id, Date.Parse('1/1/2013'));
    
        test.StartTest();
            result.run();
            system.AssertEquals(2, result.deals[0].dealAccelerator.GrossBillingsAccelerator);
        test.StopTest();
    }
}
}