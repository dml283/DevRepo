@RestResource(urlMapping='/v1.0/merchant/bank/*')

global class RESTmerchantBankAPI{

@HttpGET
global static merchant_bank getBankDetails(){
     RestRequest req = RestContext.request;
     string theId = EncodingUtil.urlDecode(req.params.get('salesforce_id'),'UTF-8');
     account a = [select id, Valid_Routing__c, Tax_ID__c, Bank_Name__c, Routing_Number_enc__c, Payment_Preference__c, Account_Number__c, Make_Checks_Payable_to__c FROM account WHERE id =:theId];
     RESTmerchantBankAPI.merchant_bank mb = new RESTmerchantBankAPI.merchant_bank(a);
     return mb;
    }

global class merchant_bank{
    public string bank_account_number {get;set;}
    public string bank_routing_number {get;set;}
    public string bank_name {get;set;}
    public string business_tax_id {get;set;}
    public string salesforce_id {get;set;}
    public string valid_routing {get;set;}
    public string payment_preference {get;set;}
    public string make_checks_payable_to {get;set;}
  public merchant_bank(account a){
      this.bank_account_number = a.Account_Number__c;
      this.bank_routing_number = a.Routing_Number_enc__c;
      this.business_tax_id = a.Tax_ID__c;
      this.bank_name = a.Bank_Name__c;
      this.salesforce_id = a.id;
      this.valid_routing = a.Valid_Routing__c;
      this.payment_preference = a.Payment_Preference__c;
      this.make_checks_payable_to = a.Make_Checks_Payable_to__c;
  }
  }
static testMethod void workbenchTest() 
        {
            
            Profile p = [select id from profile where name='System Administrator'];
                        User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
                        insert u1;
                //run as user
                System.RunAs(u1)
                {
                         account a =  new account();
                         a.name = 'testing account'; 
                         a.BillingStreet = '123456 test'; 
                         a.BillingCity = 'Chicago';
                         a.BillingState = 'IL';
                         a.BillingPostalCode = '60640';
                         a.research_ranking__c = '5';
                         a.Account_Number__c='123456789';
                         a.Routing_Number_enc__c ='123456789';
                         a.Tax_ID__c = '99999';
                         a.Bank_Name__c = 'Lehman Brothers';
                         a.Payment_Preference__c ='ACH (Direct Deposit)';
                         a.Make_Checks_Payable_to__c ='Cash';
                         insert a;
                    RestRequest req = new RestRequest(); 
                    RestResponse res = new RestResponse();

                    req.httpMethod = 'GET';
                    req.addParameter('salesforce_id',a.id);
                    RestContext.request = req;
                    RestContext.response = res;
                    
                    Test.StartTest();
                    RESTmerchantBankAPI.merchant_bank result = RESTmerchantBankAPI.getBankDetails();
                    System.assertEquals('123456789', result.bank_account_number);   
                    System.assertEquals('Lehman Brothers', result.bank_name);  
                    Test.StopTest();

                    }
        }
}