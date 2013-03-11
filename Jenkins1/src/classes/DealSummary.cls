public class DealSummary implements Comparable{
    public String          accelerator {get;set;}
    public String          accountName {get;set;}
    public Id              accountId {get;set;}
    public Decimal         commission {get;set;}
    public String          category {get;set;}
    public String          division {get;set;}
    public DealAccelerator dealAccelerator {get;set;}
    public decimal         dealBankGP {get;set;}
    public decimal         dealBankGB {get;set;}
    public Decimal         first30DaysGP {get;set;}
    public Decimal         first30DaysGB {get;set;}
    public String          featureDate {get;set;}
    public String          featureEndDate {get;set;}
    public decimal         featureGB {get;set;}
    public decimal         featureGP {get;set;}
    public Decimal         grossBillings {get;set;}
    public Decimal         grossBillingsWithAccelerator {get;set;}
    public Decimal         grossProfit {get;set;}
    public Decimal         grossProfitWithAccelerator {get;set;}
    public Id              id {get;set;}
    public Boolean         inMarket {get;set;}
    public Decimal         kicker {get;set;}
    public String          name {get;set;}
    public Boolean         outOfMarket {get;set;}
    public String          permalink {get;set;}
    public Decimal         post30DaysGP {get;set;}
    public Decimal         post30DaysGB {get;set;}
    public List<String>    previouslyReceivedAccelerators {get;set;}
    public Decimal         rate {get;set;}
    public Boolean         refeature {get;set;}
    public Decimal         refunds {get;set;}    
    public List<DealTransaction> transactions {get;set;}
    public String          type {get;set;}
    public Decimal         thresholdAmount {get;set;}          
    public list<Threshold>       thresholds {get;set;}
    public Date goLiveDate {get; set;}
    public Opportunity oppty {get; set;}
    public Integer compareTo(Object compareTo) {
        DealSummary ds = (DealSummary)compareTo;
        if(Date.parse(featureDate) == date.parse(ds.featureDate)) return 0;
        else if(date.parse(featureDate) > date.parse(ds.featureDate)) return 1;
        else return -1;
    }
        
    public DealSummary(opportunity o, date commissionDate){
        this.dealAccelerator = new DealAccelerator(o);
        this.thresholds = new list<Threshold>();
        this.previouslyReceivedAccelerators = new list<string>();
        if(o.account.Previously_Received_Accelerators__c!=null){
            this.previouslyReceivedAccelerators = o.account.Previously_Received_Accelerators__c.split(',');
        }
        this.oppty = o;
        this.id = o.id;
        this.goLiveDate = o.Go_Live_Date__c;
        this.kicker = 1;
        this.featureGP = 0;
        this.featureGB = 0;
        this.dealBankGP = 0;
        this.dealBankGB = 0;
        this.first30DaysGP = 0;
        this.first30DaysGB = 0;
        this.post30DaysGP = 0;
        this.post30DaysGB = 0;
        this.category = o.account.Category_v3__c;
        this.accelerator = '';
        this.name = o.name;
        this.accountName = o.account.name;
        this.grossBillings = 0;
        if(o.feature_date__c !=null){
            this.featureDate = o.feature_date__c.format();
        }
        if(o.feature_end_date__c !=null){
            this.featureEndDate = o.feature_end_date__c.format();
        }
        this.grossProfit = 0;
        this.grossProfitWithAccelerator = 0;
        this.grossBillingsWithAccelerator = 0;
        this.refunds =0;
        this.type = o.recordType.name;
        this.inMarket = false;
        this.accountId = o.accountid;
        this.transactions = new list<DealTransaction>();
        this.division = o.division__c;
        this.permalink = o.permalink__c;
        if(o.Feature_or_Refeature__c =='New Deal'){
            this.refeature= false;
        }else {this.refeature = true;}
        
        if(o.Financial_Records__r!=null){
            date startOfMonth = commissionDate.toStartOfMonth();
            date windowForAccelerators = o.feature_date__c.addDays(30);
            for(Financial_Records__c fr : o.Financial_Records__r){
                DealTransaction dealTransaction = new DealTransaction(fr);
                this.transactions.add(dealTransaction);
                boolean Exclude;
                date feature_date = o.feature_date__c.toStartOfMonth();
                if(feature_date == Date.Parse('12/1/2012') && fr.collection_date__c  >= Date.Parse('1/1/2013') && fr.collection_date__c  <= Date.Parse('1/4/2013')){
                    exclude = true;
                }else{
                    exclude = false;
                }
                if(feature_date == Date.Parse('12/1/2012') && o.feature_end_date__c >= fr.collection_date__c){
                    exclude = true;
                }
                if(!exclude){
                    if(fr.Gross_Profit_Salesforce__c!=null){
                        this.grossProfit += fr.Gross_Profit_Salesforce__c;
                    }
                    if(fr.Refunds_for_Commission__c!=null){
                        this.refunds += fr.Refunds_for_Commission__c;
                        this.grossProfit += fr.Refunds_for_Commission__c;
                    }
                    if(fr.Gross_Billings__c!=null){
                        this.grossBillings += fr.GB_Net_Discounts__c;
                    }
                    if(fr.Discount_Sales__c!=null){
                        this.grossProfit -= fr.Discount_Sales__c;
                    }
                    if(fr.collection_date__c < windowForAccelerators ){
                        this.first30DaysGP += fr.Gross_Profit_Salesforce__c;
                        if(fr.Refunds_for_Commission__c!=null){
                            this.first30DaysGP += fr.Refunds_for_Commission__c;
                        }
                        if(fr.Discount_Sales__c!=null){
                            this.first30DaysGP -= fr.Discount_Sales__c;
                        }
                        this.first30DaysGB += fr.GB_Net_Discounts__c;
                    }else{
                        this.post30DaysGP += fr.Gross_Profit_Salesforce__c;
                        if(fr.Refunds_for_Commission__c!=null){
                            this.first30DaysGP += fr.Refunds_for_Commission__c;
                        }
                        if(fr.Discount_Sales__c!=null){
                            this.post30DaysGP -= fr.Discount_Sales__c;
                        }
                        this.post30DaysGB += fr.GB_Net_Discounts__c;
                    }
                    if(fr.collection_date__c <= o.feature_end_date__c){
                        this.featureGP += fr.Gross_Profit_Salesforce__c;
                        if(fr.Refunds_for_Commission__c!=null){
                            this.featureGP += fr.Refunds_for_Commission__c;
                        }
                        if(fr.Discount_Sales__c!=null){
                            this.featureGP -= fr.Discount_Sales__c;
                        }
                        this.featureGB += fr.GB_Net_Discounts__c;
                    }else{
                        this.dealBankGP += fr.Gross_Profit_Salesforce__c;
                        if(fr.Refunds_for_Commission__c!=null){
                            this.dealBankGP += fr.Refunds_for_Commission__c;
                        }
                        if(fr.Discount_Sales__c!=null){
                            this.dealBankGP -= fr.Discount_Sales__c;
                        }
                        this.dealBankGB += fr.GB_Net_Discounts__c;
                    }
                }
            }
         }
    }
    public decimal getMargin(){
        return (this.grossProfit/this.grossBillings);
    }
    public void calculateCommission(CommissionTable payout){
        this.commission =  0;
        if(this.inMarket){
            if(this.refeature == true){
                this.commission = this.grossProfitWithAccelerator * payout.reFeatureRate;
                this.rate = (payout.reFeatureRate).setScale(4);
            }else{
                this.commission = this.grossProfitWithAccelerator * payout.newDealRate;
                this.rate = (payout.newDealRate).setScale(4);
            }
        }else{
            this.commission = this.grossProfitWithAccelerator * payout.outOfMarketRate;
            this.rate = (payout.outOfMarketRate).setScale(4);
        }
        this.rate = this.rate.setScale(4);
    }
    public boolean isInMarket(SalesGoal SG){
        boolean inmkt = false;
            for(string s : sg.divisions){
                if(s == this.division){
                    inmkt=true;
                }
            }
        return inmkt;
    }
public class threshold{
    public string name {get;set;}
    public decimal value {get;set;}
   
    public threshold(string name, decimal value){
        this.name = name;
        this.value = value;
    }
}    

}