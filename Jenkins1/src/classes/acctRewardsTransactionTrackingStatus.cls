public class acctRewardsTransactionTrackingStatus{
            public set<string> opptyStages = new set<string>();
            
    public void updateAcctStatus(set<id> AcctIds){

            list<account> accounts = [SELECT Id, (SELECT Rewards_Transaction_Tracking_Status__c FROM Merchant_Addresses__r), (SELECT StageName FROM Opportunities WHERE RecordType.Name = 'Rewards') FROM Account WHERE id in: AcctIds];
            for(account a : accounts){
                    set<string> maStatuses = new set<string>();
                    for(merchant_addresses__c ma : a.merchant_addresses__r){
                            maStatuses.add(ma.Rewards_Transaction_Tracking_Status__c);
                        }
                    set<string> opptyStages = new set<string>(); 
                    for(opportunity o : a.opportunities){
                            opptyStages.add(o.StageName);    
                        }               
            a.Reward_Transaction_Tracking_Status__c = getRewardsStatus(maStatuses, opptyStages);    
                }
            database.update(accounts);    
        }
    
    public string getRewardsStatus(set<string> merchAddys, set<string> opptyStages){
            string rewardsStatus = '';
            
            if(merchAddys.containsAll(new set<string>{null})){
                    //rewardsStatus = '';
                    boolean rewardOppty = false; 
                    if(opptyStages.contains('Closed Won')){
                            rewardOppty = true;    
                        }
                    if(rewardOppty = true){    
                        rewardsStatus = 'TT Needed (AM)';
                        }else{
                            rewardsStatus = '';
                            }    
                }

            //'TT Needed (AM)'
            if(merchAddys.contains('Test Transaction Pending')){
                    rewardsStatus = 'TT Needed (AM)';
                }
           
            //'Determining Data Tracking Capabilities(Data Ops)'    
            if(merchAddys.contains('Test Transaction Matched') || merchAddys.contains('Activating') || merchAddys.contains('Pending Activation') || merchAddys.contains('Partially Active') || merchAddys.contains('Test Transaction Authenticating')){
                    rewardsStatus = 'Determining Data Tracking Capabilities (Data Ops)';
                }
            //'Data Tracking Turned Off'
            if(merchAddys.contains('Unenrolled')){
                    if(merchAddys.contains('Unenrolled') || merchAddys.contains('')){
                            rewardsStatus = 'Data Tracking Turned Off';
                        }
                }
            //'Unable to Track Data/Unsupported Locations'
            if(merchAddys.containsAll(new set<string>{'Unsupported'})){
                    rewardsStatus = 'Unable to Track Data/Unsupported Locations';
                }
            //'Data Tracking Active (All Locations)' 
            set<string> activeSet = new set<string>{'Active'}  ; 
            if(merchAddys.containsAll(activeSet)){
                    rewardsStatus = 'Data Tracking Active (All Locations)';
                }            
            //'Data Tracking Active (Some Locations)'
            if(merchAddys.contains('Active')){
                    boolean active = true;
                    boolean other = null;   
                        if(merchAddys.contains('Unenrolled') || merchAddys.contains('Unsupported')){
                                other = true;    
                            }       
                    if(active == true && other == true){
                            rewardsStatus = 'Data Tracking Active (Some Locations)'; 
                        }
                }
                
             //'Error: No Longer Tracking Data (Data Ops Investigating)'
            if(merchAddys.contains('Lost Activity')){
                    rewardsStatus = 'Error: Data Tracking Problem (Data Ops Investigating)';
                }
                    
            return rewardsStatus;
        }
            
    @isTest
    public static void rttsAcct(){
            //create account
            account a = new account();
            a.name = 'rewards test' + system.now();
            insert a;
            
            //create opportunity
            opportunity o = new opportunity();
            o.accountId = a.id;
            o.name = 'testRtts';
            o.stageName = 'Closed Won';
            o.CloseDate = System.Today();
            o.division__c = 'Training';
            insert o;
            
            //create set of merchant addresses RTTS
            set<string> merchAddresses = new set<string>();
            
            set<string> opStages = new set<string>();
            //opStages.add(o.StageName);
            
            string RewardsStatus = '';
            
            //initiate class 
            acctRewardsTransactionTrackingStatus rtts = new acctRewardsTransactionTrackingStatus();
            
            //test rewardsStatus returned is null
            merchAddresses.clear();
            merchant_addresses__c testMA_RTTSnull = new merchant_addresses__c();
            testMA_RTTSnull.Account__c = a.id;
            testMA_RTTSnull.Rewards_Transaction_Tracking_Status__c = '';
            merchAddresses.add(testMA_RTTSnull.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('', rewardsStatus);
            
            //test rewardsStatus returned is 'TT Needed (AM)' with Closed Won Oppty
            merchAddresses.clear();
            opStages.add(o.StageName);
            merchant_addresses__c testMA_TTneeded_w_opp = new merchant_addresses__c();
            testMA_TTneeded_w_opp.Account__c = a.id;
            testMA_TTneeded_w_opp.Rewards_Transaction_Tracking_Status__c = null;
            merchAddresses.add(testMA_TTneeded_w_opp.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('TT Needed (AM)', rewardsStatus);
            
            //test rewardsStatus returned is 'TT Needed (AM)'
            merchAddresses.clear();
            opStages.clear();
            merchant_addresses__c testMA_TTneeded = new merchant_addresses__c();
            testMA_TTneeded.Account__c = a.id;
            testMA_TTneeded.Rewards_Transaction_Tracking_Status__c = 'Test Transaction Pending';
            merchAddresses.add(testMA_TTneeded.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertEquals('TT Needed (AM)', rewardsStatus);
            
            //test rewardsStatus returned is 'Error: Data Tracking Problem (Data Ops Investigating)'
            merchant_addresses__c testMA_LostTracking = new merchant_addresses__c();
            testMA_LostTracking.Account__c = a.id;
            testMA_LostTracking.Rewards_Transaction_Tracking_Status__c = 'Lost Activity';
            merchAddresses.add(testMA_LostTracking.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('Error: Data Tracking Problem (Data Ops Investigating)', rewardsStatus);
            
            //test rewardsStatus returned is 'Determining Data Tracking Capabilities (Data Ops)'
            merchAddresses.clear();
            merchant_addresses__c testMA_DataTrackingCapabilities = new merchant_addresses__c();
            testMA_DataTrackingCapabilities.Account__c = a.id;
            testMA_DataTrackingCapabilities.Rewards_Transaction_Tracking_Status__c = 'Test Transaction Matched';
            merchAddresses.add(testMA_DataTrackingCapabilities.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('Determining Data Tracking Capabilities (Data Ops)', rewardsStatus);
                    
            //test rewardsStatus returned is 'Unable to Track Data/Unsupported Locations'
            merchAddresses.clear();
            merchant_addresses__c testMA_Unsupported = new merchant_addresses__c();
            testMA_Unsupported.Account__c = a.id;
            testMA_Unsupported.Rewards_Transaction_Tracking_Status__c = 'Unsupported';
            merchAddresses.add(testMA_Unsupported.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('Unable to Track Data/Unsupported Locations', rewardsStatus);
            
            //test rewardsStatus returned is 'Data Tracking Turned Off'
            merchAddresses.clear();
            merchant_addresses__c testMA_Unenrolled = new merchant_addresses__c();
            testMA_Unenrolled.account__c = a.id;
            testMA_Unenrolled.Rewards_Transaction_Tracking_Status__c = 'Unenrolled';
            merchAddresses.add(testMA_Unenrolled.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('Data Tracking Turned Off', rewardsStatus);
            
            //test rewardsStatus returned is 'Data Tracking Active (Some Locations)'
            merchAddresses.clear();
            merchant_addresses__c testMA_SomeActive = new merchant_addresses__c();
            testMA_SomeActive.Account__c = a.id;
            testMA_SomeActive.Rewards_Transaction_Tracking_Status__c = 'Active';
            merchAddresses.add(testMA_SomeActive.Rewards_Transaction_Tracking_Status__c);
            
            merchant_addresses__c testMA_SomeUnsupported = new merchant_addresses__c();
            testMA_SomeUnsupported.account__c = a.id;
            testMA_SomeUnsupported.Rewards_Transaction_Tracking_Status__c = 'Unsupported';
            merchAddresses.add(testMA_SomeUnsupported.Rewards_Transaction_Tracking_Status__c);
            
            merchant_addresses__c testMA_SomeUnenrolled = new merchant_addresses__c();
            testMA_SomeUnenrolled.account__c = a.id;
            testMA_SomeUnenrolled.Rewards_Transaction_Tracking_Status__c = 'Unenrolled';
            merchAddresses.add(testMA_SomeUnenrolled.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('Data Tracking Active (Some Locations)', rewardsStatus);
            
            //test rewardsStatus returned is 'Data Tracking Active (All Locations)'
            merchAddresses.clear();
            merchant_addresses__c testMA_Active = new merchant_addresses__c();
            testMA_Active.Account__c = a.id;
            testMA_Active.Rewards_Transaction_Tracking_Status__c = 'Active';
            merchAddresses.add(testMA_Active.Rewards_Transaction_Tracking_Status__c);
            rewardsStatus = rtts.getRewardsStatus(merchAddresses, opStages);
            system.assertequals('Data Tracking Active (All Locations)', rewardsStatus);

            //TEST TRIGGER
            database.insert(testMA_TTneeded);
            
            testMA_TTneeded.Rewards_Transaction_Tracking_Status__c = 'Lost Activity';
            database.update(testMA_TTneeded);
            
            rtts.updateAcctStatus(new set<id>{a.id});
            
            account testResult = [SELECT id, Reward_Transaction_Tracking_Status__c FROM Account WHERE id =: a.id];
            system.assertEquals('Error: Data Tracking Problem (Data Ops Investigating)', testResult.Reward_Transaction_Tracking_Status__c);
        }
                       
}