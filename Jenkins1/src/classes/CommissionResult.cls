global class CommissionResult{
    public SalesGoal goal {get;set;}
    public String salesRep {get;set;}
    public CommissionTable payout {get;set;}
    public List<DealSummary> deals {get;set;}
    public String salesRepId {get;set;}
    public Decimal inMarketGBwAccelerator {get;set;}
    public Decimal inMarketGBbeforeAccelerator {get;set;}
    public Decimal inMarketGPbeforeAccelerator {get;set;}
    public Decimal inMarketGPwAccelerator {get;set;}
    public Decimal OOMarketGP {get;set;}
    public Decimal refunds {get;set;}
    public Decimal percentToGoal {get;set;}
    public Decimal totalCommission {get;set;}
    public DealAcceleratorThreshold threshold {get;set;}
    public List<Opportunity> foodAndDrinkOpps {get;set;}
    public Map<String,Decimal> FoodAndDrinkGrossBillings {get;set;}
    
    public Map<String, List<Opportunity>> mapActAclKeyToOldestOpptysByGoLiveDate {get; set;}
    public List<String> crossOverOpptysToAccelerateList {get; set;}
    public Date start_date {get;set;}
    public Date end_date {get;set;}
    
    public String result = '';
    public CommissionResult(string salesRepId, date start_date){
        this.salesRepId = salesRepId;
        this.salesRep = [select id, name FROM User WHERE id = :salesRepId].name;
        this.start_date = start_date;
        this.end_date = this.start_date.addDays(32).toStartOfMonth().addDays(-1);
    } 
    
    public CommissionResult(string salesRepId){
        this.salesRepId = salesRepId;
        this.salesRep = [select id, name FROM User WHERE id = :salesRepId].name;
        this.start_date = system.today().toStartOfMonth();
        this.end_date = system.today().toStartOfMonth().addDays(32).toStartOfMonth().addDays(-1);
    } 
    public CommissionResult(){
        this.salesRepId = UserInfo.getUserId();
        this.salesRep = [select id, name FROM User WHERE id = :salesRepId].name;
        this.start_date = system.today().toStartOfMonth();
        this.end_date = system.today().toStartOfMonth().addDays(32).toStartOfMonth().addDays(-1);
    }   
    public void run(){
        setGoal();
        setThreshold();
        addDeals();
        createPreviousOpptyAcceleratorList();
        setOutsideMonthAccelerators();
        groupDealSummariesForSameMonthReFeature();
        calculatePercentToGoal();
        payout = new CommissionTable(this.percentToGoal, goal.highTarget);
        calculateCommission();
        
        //Temp__c t = new Temp__c();
        //t.Name = String.valueOf(DateTime.Now().second()+ DateTime.Now().millisecond());
        //t.Value__c = result;
        //insert t;
        
    }
    public void setThreshold(){
        this.threshold = new DealAcceleratorThreshold();
        this.threshold.addThresholds(this.goal);
    }
    public void calculateCommission(){
        this.totalCommission = 0;
        for(DealSummary dealSummary : this.deals){
            dealSummary.calculateCommission(this.payout);
            this.totalCommission +=  dealSummary.commission;
        } 
        if(this.goal.highTarget == false){
            decimal kickerValue = (this.percentToGoal * 100) * this.payout.percentToGoalKicker;
            if(kickerValue >=5000){
                this.totalCommission += 5000;
            }else{
                this.totalCommission += kickerValue;
            }
        }
        if(totalCommission > (OOMarketGP+inMarketGPwAccelerator)*.1){
            this.totalCommission = (OOMarketGP+inMarketGPwAccelerator)*.1;
        }
        payout.newDealRate = payout.newDealRate*100; 
        payout.reFeatureRate = payout.reFeatureRate*100; 
        payout.outOfMarketRate = payout.outOfMarketRate*100; 
    }
    public void calculatePercentToGoal(){
        this.inMarketGBwAccelerator = 0;
        this.inMarketGBbeforeAccelerator = 0;
        this.inMarketGPbeforeAccelerator = 0;
        this.inMarketGPwAccelerator = 0;
        this.OOMarketGP = 0;
        date foodAndDrinkRangeLow = date.parse('10/1/2011');
        date foodAndDrinkRangeHigh = start_date.addMonths(1).addDays(-1); //end of month
        Set<Id> accountIds = new Set<Id>();
        for(DealSummary ds : this.deals){
            accountIds.add(ds.accountId);
        }
        //foodAndDrinkOpps = [select id, accountid, Go_Live_Date__c from Opportunity WHERE accountId = :accountIds AND Feature_Date__c > :foodAndDrinkRangeLow AND Feature_Date__c < :foodAndDrinkRangeHigh AND Category_v3__c = 'Food & Drink'];
        foodAndDrinkOpps = [select id, accountid, Go_Live_Date__c from Opportunity WHERE accountId = :accountIds AND Go_Live_Date__c > :foodAndDrinkRangeLow AND Go_Live_Date__c <= :foodAndDrinkRangeHigh AND Category_v3__c = 'Food & Drink'];
        
        //Set<String> AccountIdsWithFoodAndDrinkPrior = new Set<String>();
        //for(Opportunity o : foodAndDrinkOpps){
        //    AccountIdsWithFoodAndDrinkPrior.add(o.accountId);
        //}
        Set<ID> oppIdsFAndDPrior = new Set<ID>();
        for(Opportunity thisOppty: foodAndDrinkOpps)
        {
            for(Opportunity comparableOppty: foodAndDrinkOpps)
            {
                if(thisOppty.ID != comparableOppty.ID && thisOppty.AccountID == comparableOppty.AccountID && comparableOppty.Go_Live_Date__c < thisOppty.Go_Live_Date__c)
                {
                    oppIdsFAndDPrior.add(thisOppty.ID);
                }
            }
        }
        for(DealSummary dealSummary : this.deals){
            if(dealSummary.isInMarket(this.goal)){
                Set<String> crossOverOpptysToAccelerate = new Set<String>();
                crossOverOpptysToAccelerate.addAll(crossOverOpptysToAccelerateList);
                this.inMarketGBbeforeAccelerator += dealSummary.grossBillings;
                this.inMarketGPbeforeAccelerator += dealSummary.grossProfit;
                dealSummary.inMarket=true;
                date kickerDate = date.parse(dealsummary.featureDate);
                date kickerStarts = date.parse('11/14/2012');
                //Set<String> LS_previous = new Set<string>
                Set<String> previousAccelerators = new Set<String>();
                previousAccelerators.addAll(dealSummary.previouslyReceivedAccelerators);
                if(kickerDate > kickerStarts){
                    if(this.threshold.thresholdMap.containsKey(dealSummary.division)){
                        map<string,Deal_Accelerator_Threshold__c> catThresholds = this.threshold.thresholdMap.get(dealSummary.division);
                        if(catThresholds.containsKey(dealSummary.category)){
                           for(string s : dealSummary.dealAccelerator.Accelerators){
                               decimal threshold;
                               //key to get the oppty list with least go live date
                               String key = s+String.valueOf(dealSummary.accountId);
                               if( s == 'LS +50%' && (!previousAccelerators.contains('LS') || (previousAccelerators.contains('LS') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))  )
                               //if( s == 'LS +50%' && (!previousAccelerators.contains('LS') || (previousAccelerators.contains('LS') && dealSummary.goLiveDate.addDays(30) >= Date.Today()) )  )
                               //if( s == 'LS +50%' && !previousAccelerators.contains('LS') )
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator += .5;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                                
                                            }
                                        }
                                    }
                               }
                               if( s == 'DreamList +100%' && (!previousAccelerators.contains('DreamList') || (previousAccelerators.contains('DreamList') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))  )
                               //if( s == 'DreamList +100%' && (!previousAccelerators.contains('DreamList') || (previousAccelerators.contains('DreamList') && dealSummary.goLiveDate.addDays(30) >= Date.Today()) )  )
                               //if( s == 'DreamList +100%' && !previousAccelerators.contains('DreamList')) 
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator += 1;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                            }
                                        }
                                    }
                               }
                               if( s == 'High Value Attrition +15%' && (!previousAccelerators.contains('High Value Attrition') || (previousAccelerators.contains('High Value Attrition') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))  )
                               //if( s == 'High Value Attrition +15%' && (!previousAccelerators.contains('High Value Attrition') || (previousAccelerators.contains('High Value Attrition') && dealSummary.goLiveDate.addDays(30) >= Date.Today())  ))
                               //if( s == 'High Value Attrition +15%' && !previousAccelerators.contains('High Value Attrition'))
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator +=.15;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                            }
                                        }
                                    }
                               }
                               if( s == 'Food & Drink +100%' 
                                && (!previousAccelerators.contains('New F&D') || (previousAccelerators.contains('New F&D') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))
                                //&& (!previousAccelerators.contains('New F&D') || (previousAccelerators.contains('New F&D') && dealSummary.goLiveDate.addDays(30) >= Date.Today())   ) 
                                && !oppIdsFAndDPrior.contains(dealSummary.oppty.ID)
                                //if( s == 'Food & Drink +100%' 
                                //&& !previousAccelerators.contains('New F&D')  
                                //&& !AccountIdsWithFoodAndDrinkPrior.contains(dealSummary.accountId)
                                )
                                {
                                   threshold = catThresholds.get(dealSummary.category).Food_and_Drink_Threshold__c;
                                   dealSummary.thresholds.add(new dealSummary.Threshold('Food & Drink',threshold));
                                   if(FoodAndDrinkGrossBillings.containsKey(dealSummary.id))
                                   {
                                       if(threshold < FoodAndDrinkGrossBillings.get(dealSummary.id))
                                       {
                                           if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                            {
                                                for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                                {
                                                    if(oppty.ID == dealSummary.oppty.ID)
                                                    {
                                                        dealSummary.dealAccelerator.GrossBillingsAccelerator +=1;
                                                        result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                                    }
                                                }
                                            }
                                       }
                                   }
                               }
                           }
                        }
                    }
                
                }else{
                    date featureDate = date.parse(dealsummary.featureDate);
                    date startOfMonth = start_date.toStartOfMonth();
                    for(string s : dealSummary.dealAccelerator.Accelerators){
                               String key = s+String.valueOf(dealSummary.accountId);
                               decimal threshold;
                               if( s == 'LS +50%' && (!previousAccelerators.contains('LS') || (previousAccelerators.contains('LS') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))  )
                               //if( s == 'LS +50%' && (!previousAccelerators.contains('LS') || (previousAccelerators.contains('LS') && dealSummary.goLiveDate.addDays(30) >= Date.Today()) )  )
                               //if( s == 'LS +50%' && !previousAccelerators.contains('LS') )
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator += .5;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                            }
                                        }
                                    }
                               }
                               if( s == 'DreamList +100%' && (!previousAccelerators.contains('DreamList') || (previousAccelerators.contains('DreamList') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))  )
                               //if( s == 'DreamList +100%' && (!previousAccelerators.contains('DreamList') || (previousAccelerators.contains('DreamList') && dealSummary.goLiveDate.addDays(30) >= Date.Today()) )  )
                               //if( s == 'DreamList +100%' && !previousAccelerators.contains('DreamList')) 
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator += 1;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                            }
                                        }
                                    }
                               }
                               if( s == 'High Value Attrition +15%' && (!previousAccelerators.contains('High Value Attrition') || (previousAccelerators.contains('High Value Attrition') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID)))  )
                               //if( s == 'High Value Attrition +15%' && (!previousAccelerators.contains('High Value Attrition') || (previousAccelerators.contains('High Value Attrition') && dealSummary.goLiveDate.addDays(30) >= Date.Today()) )  )
                               //if( s == 'High Value Attrition +15%' && !previousAccelerators.contains('High Value Attrition'))
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator +=.15;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                            }
                                        }
                                    }
                               }
                               if( s == 'Food & Drink +100%'
                               && (!previousAccelerators.contains('New F&D') || (previousAccelerators.contains('New F&D') && crossOverOpptysToAccelerate.contains(dealSummary.oppty.ID))) 
                               //&& (!previousAccelerators.contains('New F&D') || (previousAccelerators.contains('New F&D') && dealSummary.goLiveDate.addDays(30) >= Date.Today())   ) 
                               && !oppIdsFAndDPrior.contains(dealSummary.oppty.ID)
                               //if( s == 'Food & Drink +100%' 
                               //&& !previousAccelerators.contains('New F&D') 
                               //&& !AccountIdsWithFoodAndDrinkPrior.contains(dealSummary.accountId)
                               )
                               {
                                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key))
                                    {
                                        for(Opportunity oppty: mapActAclKeyToOldestOpptysByGoLiveDate.get(key))
                                        {
                                            if(oppty.ID == dealSummary.oppty.ID)
                                            {
                                                dealSummary.dealAccelerator.GrossBillingsAccelerator +=1;
                                                result += ' - assigned '+s+' accelerator for oppty '+oppty.ID;
                                            }
                                        }
                                    }
                               }
                           }
                }
            dealSummary.grossBillingsWithAccelerator =  dealSummary.DealAccelerator.getGrossBillings(dealSummary.first30DaysGB) + dealSummary.post30DaysGB;
            dealSummary.grossProfitWithAccelerator = dealSummary.DealAccelerator.getGrossProfit(dealSummary.featureGP, dealSummary.first30DaysGB) + dealSummary.dealBankGP;
            this.inMarketGPwAccelerator += dealSummary.grossProfitWithAccelerator;
            this.inMarketGBwAccelerator += dealSummary.grossBillingsWithAccelerator;
            }else{
                dealSummary.dealAccelerator.accelerators = new list<string>();
                dealSummary.DealAccelerator.GrossBillingsAccelerator = 1;
                dealSummary.DealAccelerator.GrossProfitAccelerator =0;
                dealSummary.grossBillingsWithAccelerator =  dealSummary.grossBillings;
                dealSummary.grossProfitWithAccelerator = dealSummary.grossProfit;
                this.OOMarketGP += dealSummary.grossProfit;
            }
        }
        decimal calculated_percent_to_goal = (this.inMarketGBwAccelerator/this.goal.gb_goal);
        calculated_percent_to_goal = (calculated_percent_to_goal*100).round(System.RoundingMode.DOWN);
        this.percentToGoal = calculated_percent_to_goal/100;
    }
    
    public void addDeals(){
        this.deals = new list<DealSummary>();
        
        Set<Id> oppIds = new set<id>();
        Set<Id> FRids = new set<id>();
        
        List<Financial_Records__c> validOpps = new list<Financial_Records__c>();
               
        Date startOfMonth = system.today().toStartOfMonth();
        Date today = system.today();
        validOpps = [select id, opportunity__c FROM Financial_Records__c WHERE Collection_Date__c >= :start_date AND Collection_Date__c <= :end_date AND opportunity__r.ownerid = :salesRepId AND GB_Net_Discounts__c >0 AND Isdeleted = false];
        
        for(Financial_Records__c fr : validOpps){
            oppIds.add(fr.opportunity__c);
            FRids.add(fr.id);
        }
        
        list<opportunity> opps = new list<opportunity>();
        
        opps = [select id, name, account.name, account.Top_Merchant_Campaign__c, account.Category_v3__c, account.Previously_Received_Accelerators__c, account.First_Groupon_Feature_Date__c, accountid, feature_date__c, Feature_End_Date__c, recordType.name, Feature_or_Refeature__c, division__c, permalink__c, Go_Live_Date__c, (select id, Collection_Date__c, Gross_Profit_Salesforce__c, Refunds_for_Commission__c, Gross_Billings__c, Multi_Deal__r.name, GB_Net_Discounts__c, Discount_Sales__c FROM Financial_Records__r WHERE id = :FRids ORDER BY collection_date__c desc) FROM opportunity where id = :oppIds AND Feature_date__C != null AND Feature_End_Date__c !=null ORDER BY feature_end_date__c];
        
        for(opportunity o : opps){
            DealSummary ds = new DealSummary(o, start_date);
            this.deals.add(ds);
        }
    }
    
    public void setOutsideMonthAccelerators(){
        this.FoodAndDrinkGrossBillings = new Map<String,Decimal>();
        Set<Id> OpportunityIds = new Set<Id>();
        for(DealSummary ds : this.deals){
            if(ds.category == 'Food & Drink'){
                OpportunityIds.add(ds.id);
           }
        }
        List< AggregateResult > foodAndDrinkSummary = [SELECT Sum(GB_Net_Discounts__c) gb, Opportunity__C FROM Financial_Records__c WHERE Opportunity__c = :OpportunityIds AND FoodAndDrinkThreshold__C = 'Yes' GROUP BY Opportunity__c];
        for(AggregateResult ar : foodAndDrinkSummary){
            decimal grossBillings = (Decimal)ar.get('gb');
            string deal_id = (String)ar.get('Opportunity__C');
            FoodAndDrinkGrossBillings.put(deal_id,grossBillings);
        }
        List< AggregateResult > foodAndDrinkSummaryPrefeature = [SELECT Sum(GB_Net_Discounts__c) gb, Opportunity__C FROM Financial_Records__c WHERE Opportunity__c = :OpportunityIds AND FoodAndDrinkThresholdPrefeature__c = 'Yes' GROUP BY Opportunity__c];
        for(AggregateResult ar : foodAndDrinkSummaryPrefeature){
          decimal grossBillings = (Decimal)ar.get('gb');
          string deal_id = (String)ar.get('Opportunity__C');
          if(FoodAndDrinkGrossBillings.containsKey(deal_id)){
              decimal featureGBtoCompare = FoodAndDrinkGrossBillings.get(deal_id);
              if(featureGBtoCompare < grossBillings){
                  FoodAndDrinkGrossBillings.put(deal_id,grossBillings);
              }
          }
        }
    }
    
    public void setGoal(){
        list<sales_goal__c> goals = new list<sales_goal__c>();
        goals  = [select id, division__r.name, ownerid, gp_goal__c, Gross_Billings_Goal__c from Sales_goal__c where Goal_Start_Date__c >= :start_date AND Goal_End_Date__c <= :end_date AND ownerid = :salesRepId];
        this.goal = new SalesGoal(goals); 
    }
    
    public void createPreviousOpptyAcceleratorList()
    {
    	//first determine which permalinks need to be loaded based on Start Date
    	//we need to load perma link from one month prior to the start date
    	if(start_date != null)
    	{
    		String currentMonth = String.valueOf(start_date.month());
    		String currentMonthsYear = String.valueOf(start_date.year());
    		String previousMonth = String.valueOf(start_date.addMonths(-1).month());
    		String previousMonthsYear = String.valueOf(start_date.addMonths(-1).year());
    		
    		
    		
	        crossOverOpptysToAccelerateList = new List<String>();
	        Set<String> permaLinks = new Set<String>();
	        for(Previous_Accelerators__c pa: [Select ID, Permalink__c from Previous_Accelerators__c where Permalink__c !=: null 
	        								and 
		        							( (Month__c =: currentMonth and Year__c =: currentMonthsYear) 
		        								OR 
		        							  (Month__c =: previousMonth and Year__c =: previousMonthsYear) 
		        							)
		        							
	        	])
	        {
	            permaLinks.add(pa.Permalink__c);
	        }
	        
	        if(permaLinks.size() > 0)
	        {
	            for(Opportunity oppty: [Select ID from Opportunity where Permalink__c in: permaLinks])
	                crossOverOpptysToAccelerateList.add(String.valueOf(oppty.ID));
	        }
    	}
    }
    
    public void groupDealSummariesForSameMonthReFeature()
    {
        mapActAclKeyToOldestOpptysByGoLiveDate = new Map<String, List<Opportunity>>();
        if(this.deals != null)
        {
            for(DealSummary ds: this.deals)
            {
                for(String accl: ds.dealAccelerator.Accelerators)
                {
                    String key = accl+String.valueOf(ds.accountId);
                    if(mapActAclKeyToOldestOpptysByGoLiveDate.containsKey(key) )
                    {
                        List<Opportunity> opptysWithOldestGoLiveDate = mapActAclKeyToOldestOpptysByGoLiveDate.get(key);
                        //just check for the first oppty in the list as they all have the same go live date
                        if(ds.goLiveDate <= opptysWithOldestGoLiveDate[0].Go_Live_Date__c )
                        {
                            opptysWithOldestGoLiveDate.add(ds.oppty);
                            mapActAclKeyToOldestOpptysByGoLiveDate.put(key, opptysWithOldestGoLiveDate);
                        } 
                    }
                    else
                    {
                        List<Opportunity> opptysWithOldestGoLiveDate = new List<Opportunity>();
                        opptysWithOldestGoLiveDate.add(ds.oppty);
                        mapActAclKeyToOldestOpptysByGoLiveDate.put(key, opptysWithOldestGoLiveDate);
                    }
                }
            }
        }
    }
}