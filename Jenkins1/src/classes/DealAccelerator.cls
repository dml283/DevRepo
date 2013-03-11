public class DealAccelerator{
    public string name {get;set;}
    public Decimal GrossBillingsAccelerator {get;set;}
    public Decimal GrossProfitAccelerator {get;set;}
    public list<string> Accelerators {get;set;}
    public Boolean g2Kicker {get;set;}
    
    public decimal getGrossBillings(Decimal PreKicker){
        return PreKicker*this.GrossBillingsAccelerator;
    }
    public decimal getGrossProfit(Decimal ProfitBeforeAccelerator, Decimal BillingsBeforeAccelerator){
         decimal gp = ProfitBeforeAccelerator + (this.GrossProfitAccelerator*BillingsBeforeAccelerator);
         return gp;
    }
    public DealAccelerator(opportunity o){
        this.Accelerators = new list<string>();
        this.GrossBillingsAccelerator = 1;
        this.GrossProfitAccelerator = 0;
        
        if(o.account.Top_Merchant_Campaign__c == 'LS'){
            this.Accelerators.add('LS +50%');
        }
        if(o.account.Top_Merchant_Campaign__c == 'DreamList'){
            //this.GrossBillingsAccelerator +=1;
           // this.GrossProfitAccelerator += 1;
            this.Accelerators.add('DreamList +100%');
        }
        if(o.account.Top_Merchant_Campaign__c == 'High Value Attrition'){
            //this.GrossBillingsAccelerator +=.15;
            //this.GrossProfitAccelerator += .15;
            //this.Accelerators.add('High Value Attrition +15%');
        }
        if(o.recordType.Name == 'gLite'){
            this.g2Kicker=false;
          //  this.Accelerators.add('gLite +20%');
            //this.GrossBillingsAccelerator += .2;
        }else{
            this.g2Kicker = false;
        }
        if(o.account.Category_v3__c == 'Food & Drink'){
            //this.GrossBillingsAccelerator+=1;
            //this.GrossProfitAccelerator += 1;
            this.Accelerators.add('Food & Drink +100%');
        }
    }
    public DealAccelerator(){}
}