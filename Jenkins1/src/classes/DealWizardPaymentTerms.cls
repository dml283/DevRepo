public class DealWizardPaymentTerms {

  public String payment_terms {get;set;}
  public Decimal first_payment_percent {get;set;}
  public Decimal second_payment_percent {get;set;}
  public Decimal third_payment_percent {get;set;}
  public Decimal first_payment_days {get;set;}
  public Decimal second_payment_days {get;set;}
  public Decimal third_payment_days {get;set;}

  public DealWizardPaymentTerms( opportunity o ) {
    this.payment_terms = o.Payment_Terms__c;
    this.first_payment_percent = o.X1st_Payment__c;
    this.second_payment_percent = o.X2nd_Payment__c;
    this.third_payment_percent = o.X3rd_Payment__c;
    this.first_payment_days = o.X1st_Payment_Days__c;
    this.second_payment_days = o.X2nd_Payment_Days__c;
    this.third_payment_days = o.X3rd_Payment_Days__c;
  }  
}