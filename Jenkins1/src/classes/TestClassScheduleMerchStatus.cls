@istest
class TestClassScheduleMerchStatus {

    public static testmethod void testBusinessLogic(){
       
        list<account> acctsToInsert = new list<account>();
        list<opportunity> opptysToInsert1 = new list<opportunity>();
        list<opportunity> opptysToInsert2 = new list<opportunity>();
        list<task> tasksToInsertU1 = new list<task>();
        list<task> tasksToInsertU2 = new list<task>();
        list<task> tasksToInsert = new List<Task>();
        List<Contact> contactsToInsert = new List<Contact>();
        
        Profile p = [select id from profile where name='System Administrator'];
       
        User u1 = new User();
        u1.alias = 'standt';
        u1.email='standarduser@groupon.com';
        u1.emailencodingkey='UTF-8';
        u1.lastname='Testing';
        u1.languagelocalekey='en_US';
        u1.localesidkey='en_US';
        u1.profileid = p.Id;
        u1.timezonesidkey='America/Los_Angeles';
        u1.username='merchstatUser1@groupon.com';
        insert u1;
       
        User u2 = new User();
        u2.alias = 'standt';
        u2.email='standarduser@groupon.com';
        u2.emailencodingkey='UTF-8';
        u2.lastname='Testing';
        u2.languagelocalekey='en_US';
        u2.localesidkey='en_US';
        u2.profileid = p.Id;
        u2.timezonesidkey='Australia/Sydney';
        u2.username='merchstatUser2@groupon.com';
        insert u2;
        
        //create account
        account a = new account();
        a.name = 'MerchStatus Test 1' + system.now()+1;
        a.result_of_merchant_survey__c = 'Unqualified';
        a.account_status__c = 'Lacks a Sales Rep';
        a.Evaluate_Merchant_Status__c = true;
        acctsToInsert.add(a);
        
        account a1 = new account();
        a1.name = 'MerchStatus Test 1' + system.now()+1;
        a1.result_of_merchant_survey__c = 'Unqualified';
        a1.account_status__c = 'Lacks a Sales Rep';
        a1.Evaluate_Merchant_Status__c = true;
        acctsToInsert.add(a1);
        
        database.insert(acctsToInsert);
        system.debug('***a1***' + a1);
        
        contact c1 = new contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'C1 First Name';
        c1.LastName = 'C1 Last Name';
        contactsToInsert.add(c1);

        database.insert(contactsToInsert);
        system.debug('***C1***' + c1);
        
        //run as user
        System.RunAs(u1){
            task t1 = new task();
            t1.ownerId = u1.id;            
            t1.whoId = c1.id;
            t1.Type = 'Call - Outbound';
            t1.status = 'Completed';
            t1.activityDate = system.today();
            insert t1;
            
            task t2 = new task();
            t2.ownerId = u1.id;
            t2.whatId = a1.id;
            t2.Type = 'Call - Outbound';
            t2.status = 'Completed';
            t2.activityDate = system.today();
            insert t2;
            
            opportunity o1 = new opportunity();
            o1.accountId = a1.id;
            o1.name = 'testRtts';
            o1.stageName = 'Closed Won';
            o1.CloseDate = System.Today();
            o1.division__c = 'Training';
            o1.Deal_Strengh__c = 'A Sure Thing';
            o1.closeDate = system.today();
            o1.feature_date__c = system.today()-7;
            o1.groupon_expiration_date__c = system.today()+14;
            opptysToInsert1.add(o1);
            
            opportunity o3 = new opportunity();
            o3.accountId = a1.id;
            o3.name = 'testRtts';
            o3.stageName = 'Closed Won';
            o3.CloseDate = System.Today()+14;
            o3.division__c = 'Training';
            o3.Deal_Strengh__c = 'Rep Getting Info';
            o3.stageName = 'Prospecting';
            o3.closeDate = system.today()+1;
            opptysToInsert1.add(o3);
            database.insert(opptysToInsert1);
        }

        System.RunAs(u2){
            task t3 = new task();
            t3.ownerId = u1.id;
            t3.whatId = a1.id;
            t3.Type = 'Call - Outbound';
            t3.status = 'In Progress';
            t3.activityDate = system.today();
            insert t3;
            
            task t4 = new task();
            t4.ownerId = u2.id;
            t4.whatId = a1.id;
            t4.Type = 'Call - Outbound';
            t4.status = 'Completed';
            t4.activityDate = system.today();
            insert t4;
            
            opportunity o2 = new opportunity();
            o2.accountId = a1.id;
            o2.name = 'testRtts';
            o2.stageName = 'Closed Won';
            o2.CloseDate = System.Today();
            o2.division__c = 'Training';
            o2.Deal_Strengh__c = 'A Sure Thing';
            o2.closeDate = system.today()+1;
            o2.feature_date__c = system.today()-5;
            o2.groupon_expiration_date__c = system.today()+21;
            opptysToInsert2.add(o2);
            database.insert(opptysToInsert2);        
        }
        /*
        List<Account> testQ = [SELECT id,(SELECT id,AccountId, status, isclosed FROM activityHistories) FROM Account];
        system.debug('***activityHistories***' + testQ);
        List<Task> taskQ = [SELECT id,status, isclosed FROM Task WHERE AccountId =: a1.id];
        system.debug('***taskQ***' + taskQ);
        for(Account z : testQ){
            system.debug('***histories***' + z.activityHistories);
        }
        */
        Test.StartTest();
            Database.executeBatch(new insertMerchantStatusRecord ());
            MerchantStatus status = new MerchantStatus(); 
            MerchantStatusDeals statusDeals = new MerchantStatusDeals(); 
            MerchantStatusActivites statusActivities = new MerchantStatusActivites();       
        Test.StopTest();

    }
    
    public static testMethod void testReturnValues(){
        List<MerchantStatus> msList = new List<MerchantStatus>();
        
        MerchantStatus ms = new MerchantStatus();
        ms.rejected_groupon_not_interested = 'Viability/Bankruptcy - Permanent';
        msList.add(ms);
        
        MerchantStatus ms0 = new MerchantStatus();
        ms0.activities.most_recent_merchant_status = 'Merchant Not Interested - Not Interested Today';
        ms0.activities.activity_count = 1;
        ms0.activities.most_recent_completed_date = system.today();
        msList.add(ms0);
        
        MerchantStatus ms1 = new MerchantStatus();
        ms1.activities.most_recent_merchant_status = 'Merchant Not Interested - Prior Bad Experience';
        ms1.activities.activity_count = 1;
        ms1.activities.most_recent_completed_date = system.today();
        msList.add(ms1);
        
        MerchantStatus ms2 = new MerchantStatus();
        ms2.activities.most_recent_merchant_status = 'Merchant Not Interested - Financial: Margin';
        ms2.activities.activity_count = 1;
        ms2.activities.most_recent_completed_date = system.today();
        msList.add(ms2);
        
        MerchantStatus ms3 = new MerchantStatus();
        ms3.activities.most_recent_merchant_status = 'Merchant Not Interested - Brand: Does Not Discount';
        ms3.activities.activity_count = 1;
        ms3.activities.most_recent_completed_date = system.today();
        msList.add(ms3);
 
        MerchantStatus ms4 = new MerchantStatus();
        ms4.activities.most_recent_merchant_status = 'Merchant Not Interested - Doesnt Have Capacity';
        ms4.activities.activity_count = 1;
        ms4.activities.most_recent_completed_date = system.today();
        msList.add(ms4);

        MerchantStatus ms5 = new MerchantStatus();
        ms5.activities.most_recent_merchant_status = 'Merchant Not Interested - Competitor Account: Margin';
        ms5.activities.activity_count = 1;
        ms5.activities.most_recent_completed_date = system.today();
        msList.add(ms5);
        
        MerchantStatus ms6 = new MerchantStatus();
        ms6.deals.deal_count = 0; 
        ms6.activities.activity_count = 0;
        ms6.owner_id = '00580000001YaJIAA0';
        msList.add(ms6);
 
        //UNASSIGNED STARTS HERE
        string uAstring = '00580000001YaJIAA0';
        
        MerchantStatus ms7 = new MerchantStatus();
        ms7.deals.most_recent_close_date = system.today();
        ms7.deals.most_recent_stage_name = 'Closed Won';
        ms7.deals.most_recent_close_date = system.today()-1;
        ms7.owner_id = uAstring;
        msList.add(ms7);
        
        MerchantStatus ms8 = new MerchantStatus();
        ms8.deals.most_recent_stage_name = 'Closed Won'; 
        ms8.deals.most_recent_expiration_date = system.Today();
        ms8.deals.most_recent_close_date = system.Today()-95 ;
        ms8.deals.most_recent_feature_date = null;
        ms8.owner_id = uAstring;
        msList.add(ms8);
 
        MerchantStatus ms9 = new MerchantStatus();
        ms9.deals.deal_count = 0;
        ms9.activities.activity_count = 1; 
        ms9.activities.most_recent_completed_date = system.today();
        ms9.owner_id = uAstring;
        msList.add(ms9);
        
        MerchantStatus ms10 = new MerchantStatus();
        ms10.deals.deal_count = 1;
        ms10.deals.most_recent_stage_name = 'Closed Lost';
        ms10.deals.most_recent_expiration_date = null; 
        ms10.activities.activity_count = 1;  
        ms10.activities.most_recent_completed_date = system.today();
        ms10.owner_id = uAstring;
        msList.add(ms10);
 
        MerchantStatus ms11 = new MerchantStatus();
        ms11.activities.most_recent_completed_date = system.today();
        ms11.activities.most_recent_call_result = 'Decision Maker Contacted';
        ms11.owner_id = uAstring;
        msList.add(ms11);
        
        MerchantStatus ms12 = new MerchantStatus();
        ms12.deals.most_recent_stage_name = 'Prospecting';
        ms12.activities.most_recent_completed_date = system.today();
        ms12.owner_id = uAstring;
        msList.add(ms12);

        MerchantStatus ms13 = new MerchantStatus();
        ms13.deals.most_recent_stage_name = 'Contract Sent';
        ms13.activities.most_recent_completed_date = system.today();
        ms13.owner_id = uAstring;
        msList.add(ms13);
        
        MerchantStatus ms14 = new MerchantStatus();
        ms14.activities.activity_count = 1;
        ms14.deals.most_recent_expiration_date = system.today()-3;
        ms14.activities.most_recent_completed_date = system.today()-95;
        ms14.owner_id = uAstring;
        msList.add(ms14);
        
        MerchantStatus ms15 = new MerchantStatus();
        ms15.activities.most_recent_merchant_status = 'Merchant Not Interested - Closed for the Season';
        ms15.activities.activity_count = 1;
        ms15.activities.most_recent_completed_date = system.today();
        msList.add(ms15);

        MerchantStatus ms16 = new MerchantStatus();
        ms16.activities.most_recent_merchant_status = 'Merchant Not Interested - Financial: Deal Structure';
        ms16.activities.activity_count = 1;
        ms16.activities.most_recent_completed_date = system.today();
        msList.add(ms16);

        MerchantStatus ms17 = new MerchantStatus();
        ms17.activities.most_recent_merchant_status = 'Merchant Not Interested - Brand: Association With Groupon';
        ms17.activities.activity_count = 1;
        ms17.activities.most_recent_completed_date = system.today();
        msList.add(ms17);

        MerchantStatus ms18 = new MerchantStatus();
        ms18.activities.most_recent_merchant_status = 'Merchant Not Interested - Competitor Account: Other';
        ms18.activities.activity_count = 1;
        ms18.activities.most_recent_completed_date = system.today();
        msList.add(ms18);

        MerchantStatus ms19 = new MerchantStatus();
        ms19.activities.most_recent_merchant_status = 'Merchant Not Interested - Unfavorable Payment Terms';
        ms19.activities.activity_count = 1;
        ms19.activities.most_recent_completed_date = system.today();
        msList.add(ms19);

        MerchantStatus ms20 = new MerchantStatus();
        ms20.activities.most_recent_merchant_status = 'Merchant Not Interested - Poor Customer Quality';
        ms20.activities.activity_count = 1;
        ms20.activities.most_recent_completed_date = system.today();
        msList.add(ms20);
        
        insertMerchantStatusRecord imsr = new insertMerchantStatusRecord();
        Test.StartTest();
            for(MerchantStatus msTest : msList){
                imsr.getMerchStatusValues(msTest);
            }
        Test.StopTest();
    }
}