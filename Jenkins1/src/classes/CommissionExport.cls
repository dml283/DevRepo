public class CommissionExport {
    public CommissionExport(){
        this.SalesRep = ApexPages.currentPage().getParameters().get('salesrep');  
        id sales_rep_id = this.SalesRep;
        this.Month = ApexPages.currentPage().getParameters().get('month');
        Date start_date;
        if(this.month=='January'){
            start_date = Date.Parse('1/1/2013');
        }
        if(this.month=='February'){
            start_date = Date.Parse('2/1/2013');
        }
        if(this.month=='March'){
            start_date = Date.Parse('3/1/2013');
        }
        this.commission = new CommissionResult(sales_rep_id,start_date);
        this.commission.run();      
    }
    public CommissionResult commission {get; set;}
    public String SalesRep {get;set;}
    public String Month {get;set;}
}