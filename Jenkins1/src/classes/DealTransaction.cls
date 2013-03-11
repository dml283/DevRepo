public class DealTransaction{
        public String collectionDate {get;set;}
        public Date collectionsDate {get;set;}
        public Decimal grossProfit {get;set;}
        public Decimal refunds {get;set;}
        public Decimal grossBookings {get;set;}
        public Decimal grossBookingsWithAccelerator {get;set;}
        public Decimal grossProfitWithAccelerator {get;set;}
        public String name {get;set;}
        
        public DealTransaction(Financial_Records__c fr){
            this.collectionsDate = fr.Collection_Date__c;
            try{ this.collectionDate = fr.Collection_Date__c.format(); }catch(exception e){}
            this.grossProfit = fr.Gross_Profit_Salesforce__c;
            if(fr.Refunds_for_Commission__c != null){
                this.grossProfit += fr.Refunds_for_Commission__c;
                if(fr.Discount_Sales__c!=null){
                    this.grossProfit -= fr.Discount_Sales__c;
                }
            }
            this.refunds = fr.Refunds_for_Commission__c;
            this.grossBookings = fr.GB_Net_Discounts__c;
            this.name = fr.Multi_Deal__r.name;
        }
    }