public class DealWizardMerchantContact {

    public String best_contact_method {get;set;}
    public String best_contact_time_of_day {get;set;}
    public String email {get;set;}
    public String id {get;set;}
    public String mobile {get;set;}
    public String name {get;set;}
    public String phone {get;set;}
    
    public DealWizardMerchantContact( contact c ) {
        this.best_contact_method        = c.Best_Contact_Method__c;
        this.best_contact_time_of_day   = c.Best_Contact_Time_of_Day__c;
        this.email                      = c.Email;
        this.id                         = c.Id;
        this.mobile                     = c.MobilePhone;
        this.name                       = c.Name;
        this.phone                      = c.Phone;
    }
}