@RestResource(urlMapping='/v1.0/merchant-payments')



global class RESTMerchantPaymentsAPI {

@HttpGET

global static list<merchant_payment> get(){

string merchantId = RestContext.request.params.get('id');

list<merchant_payment> past_payments = new list<merchant_payment>();

for(Merchant_Payment__c pastPayment:Database.query(get_payments_query() + '\'' + merchantId + '\' ORDER BY Payment_Date__c DESC')){

past_payments.add(new merchant_payment(pastPayment));

}

return past_payments;

}

 

global class merchant_payment{
    public decimal amount {get;set;}
    public string fx {get;set;}
    public string payment_method {get;set;}
    public string payment_date {get;set;}
    public string confirmation_number {get;set;}
    
    public merchant_payment(Merchant_Payment__c mp){
        this.amount = mp.amount__c;
        this.fx = mp.currency__c;
        this.payment_method = mp.payment_method__c;
        if(mp.Payment_Date__c!=null){
            this.payment_date = mp.Payment_Date__c.format();
        }
        if(mp.ACH_Confirmation_Number__c !=null){
            this.confirmation_number = mp.ACH_Confirmation_Number__c;
        }else if(mp.Check_Number__c!=null){
            this.confirmation_number = mp.Check_Number__c;
        }
    }
}


public static string get_payments_query(){

   return 'SELECT id,amount__c,currency__c,payment_method__c,Payment_Date__c,ACH_Confirmation_Number__c,Check_Number__c FROM Merchant_Payment__c WHERE Account__c = ';

}



}