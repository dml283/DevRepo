public class AddressHelper {
    public boolean newMode{get;set;}
    public boolean viewMode{get;set;}
    private Id defaultAccountId;     
    private Id ctrlId;
    public string RecTypeName;
    list<Merchant_Addresses__c> AccountList;
    list<Address__c> OpptyList;
    public string street1 {get;set;}
    public string street2 {get;set;}
    public string city {get;set;}
    public string state {get;set;}
    public string country {get;set;}
    public string zip {get;set;}
    public string venue {get;set;}
    public string phone {get;set;}
    public string merchantId {get;set;}
    public string terminalId {get;set;}
    public string type {get;set;}
	
	//new comment
	//new Comment 2 - Some New Implementation
	//new Comment 3 - My Brand New Implementation
	//new COmment 4 - Shiny new IMplementations
    public AddressHelper(ApexPages.StandardController ctrl) 
        {
             ctrlId = ctrl.getID();
             defaultAccountId = [SELECT AccountId FROM Opportunity WHERE Id = :ctrlId LIMIT 1].AccountId;
             RecTypeName = [SELECT RecordType.Name FROM Opportunity WHERE Id = :ctrlId LIMIT 1].RecordType.Name;
             viewMode = true;
             newMode = false;
        } 

    public void insertAddy()
        {
            viewMode = false;
            newMode = true;
        }
            
    public void cancelNewAddy()
        {
            viewMode = true;
            newMode = false;
        }    
         
    public void resetMerchAddy()
       {
           street1=null;
           street2=null;
           city=null;
           state=null;
           country=null;
           zip=null;
           venue=null;
           phone=null;
           merchantId=null;
           terminalId=null;
           type=null;
       }
    
    //GRABS OPPTY ID BECAUSE OF SWITCH TO VOID VS PAGEREFERENCE
    public id getOpptyId()
        {
            id o = ctrlid;
            return o;
        }
    
    //GRABS ACCT ID BECAUSE OF SWITCH TO VOID VS PAGEREFERENCE
    public id getactId()
        {
            id o = defaultAccountId;
            return o;
        }
    
    //CREATES MERCHANT ADDRESS RECORD THEN REDEMPTION ADDRESS RECORD - TRY CATCH MAY BE WEIRD HERE JUST FYI
    public Void addMerchantAddress()
        {
            Merchant_Addresses__c ma = new Merchant_Addresses__c();
                    ma.street_line_1__c = street1;
                    ma.account__c = defaultAccountId;
                    ma.phone_number__c = phone;
                    ma.street_line_2__c = street2;
                    ma.city__c = city;
                    ma.state_province__c = state;
                    ma.zip_postal_code__c = zip;
                    ma.Venue_Name__c = venue;
                    ma.Country__c = country;
                    ma.merchant_ID__c = merchantid;
                    ma.terminal_ID__c = terminalid;
                    ma.type__c = type;              
            try {insert ma;
                 
                 Address__c ra = new Address__c();
                    ra.opportunity__c = getOpptyId();
                    ra.merchant_addresses__c = ma.id;
                    ra.account__c = ma.account__c;
                    ra.phone_number__c = ma.phone_number__c;
                    ra.enrollment_status__c = ma.enrollment_status__c;
                    ra.street_line_1__c = ma.street_line_1__c;
                    ra.street_line_2__c = ma.street_line_2__c;
                    ra.city__c = ma.city__c;
                    ra.state__c = ma.state_province__c;
                    ra.zip_postal_code__c = ma.zip_postal_code__c;
                    ra.Country__c = ma.country__c;
                    ra.Venue_Name__c = ma.Venue_Name__c;
                    ra.merchant_ID__c = ma.merchant_id__c;
                    ra.terminal_ID__c = ma.terminal_ID__c;
                    ra.type__c = ma.type__c;
                    ra.Subdivision__c = ma.Subdivision__c;
                try {insert ra;} 
                    catch (DMLException e) 
                        {
                            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Salesforce@groupon.com if you believe this is in error'));
                            ApexPages.addMessages(e);
                        }
                } 
                        catch (DMLException e) 
                            {
                               //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Salesforce@groupon.com if you beleive this is in error'));
                               ApexPages.addMessages(e);
                            }
            
            resetMerchAddy();
            viewMode = true;
            newMode = false;
        }
        
    //DELETE SELECTED REDEMPTION ADDRESSES
    public Void deleteRedemptionAddress()
        {
            try {Database.DeleteResult[] DR_Dels = Database.delete(RedemptionAddresses);} 
                    catch (DMLException e) 
                        {
                            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Salesforce@groupon.com if you believe this is in error' + e));
                            ApexPages.addMessages(e);
                        }
        }   
    
    //ADD SELECTED MERCHANT ADDRESSES AS REDEMPTION ADDRESSES
    public Void addRedemptionAddress()
        {

            list<Address__c> SelAddysInsert = new list<address__c>();
            for (string s : MerchantAddresses)
                {
                    if(s!='')
                       {
                            Merchant_Addresses__c m =[select Account__c, Type__c, city__c, Terminal_ID__c, State_Province__c, phone_number__c, Enrollment_Status__c, country__c, merchant_id__c, Street_Line_1__c, Street_Line_2__c, zip_postal_code__c, Venue_Name__c, Subdivision__c from Merchant_Addresses__c where id =: s];     
                            
                            Address__c a = new Address__c();
                                        a.opportunity__c = getOpptyId();
                                        a.merchant_addresses__c = m.id;
                                        a.account__c = m.account__c;
                                        a.phone_number__c = m.phone_number__c;
                                        a.enrollment_status__c = m.enrollment_status__c;
                                        a.street_line_1__c = m.street_line_1__c;
                                        a.street_line_2__c = m.street_line_2__c;
                                        a.city__c = m.city__c;
                                        a.state__c = m.state_province__c;
                                        a.zip_postal_code__c = m.zip_postal_code__c;
                                        a.Country__c = m.Country__c;
                                        a.Venue_Name__c = m.Venue_Name__c;
                                        a.merchant_ID__c = m.merchant_id__c;
                                        a.terminal_ID__c = m.terminal_ID__c;
                                        a.type__c = m.type__c;
                                        a.Subdivision__c = m.Subdivision__c;                                                                                
                                        
                                        if(a.merchant_addresses__c != null)
                                        {
                                            SelAddysInsert.add(a); 
                                        }   
                                }
                    
                }
                try {insert SelAddysInsert;} 
                    catch (DMLException e) 
                        {
                            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Salesforce@groupon.com if you believe this is in error'));
                            ApexPages.addMessages(e);
                        }
                        
                viewMode = true;
                newMode = false;
        } 

    //CREATES LIST OF REDEMPTION ADDRESSES RELATED TO CURRENTLY LOADED OPPORTUNITY
    public list<Address__c> getOpptyList()
        {
            list<address__c> olist = [SELECT Id, Type__c, Venue_Name__c, Phone_Number__c, Full_Address__c, Name, Account__c, City__c, Opportunity__c, State__c, Street_Line_1__c, Street_Line_2__c, Country__c, Zip_Postal_Code__c, Account__r.Name, Merchant_Addresses__c FROM Address__c WHERE Opportunity__c = :ctrlid];
            return olist;
        }
        
    //CREATES A SET OF IDS OF REDEMPTION ADDRESS TO COMPARE TO MERCHANT ADDRESSES SO RECORDS DON'T SHOW IN BOTH BOXES
    public set<id> getAlreadySelected()
        {   
             set<id> setids = new set<id>();  
             list<address__C> olist=getOpptyList();
             for(address__c a:olist)
                 setids.add(a.Merchant_Addresses__c);
             return setids;   
        }         
        
    //Build Merchant Address Selection Box
    String[] MerchantAddresses = new String[]{};
                
        public List<SelectOption> getMerchAddys()
            {
                List<SelectOption> options = new List<SelectOption>();
                set<id> setids = getAlreadySelected();
                list<Merchant_Addresses__c> merchalist =[select Account__c, Type__c, Full_Address__c, city__c, State_Province__c, phone_number__c, Enrollment_Status__c, country__c, merchant_id__c, Street_Line_1__c, Street_Line_2__c, zip_postal_code__c from Merchant_Addresses__c where account__c = :defaultAccountId AND id not in :setids ];
                for (Merchant_Addresses__c ma : merchalist)
                    {
                        if(RecTypeName != 'Groupon Goods' && ma.Type__c != 'Shipping Origination'){
                        options.add(new SelectOption(ma.id, ma.Full_Address__c));
                        }
                        
                        if(RecTypeName == 'Groupon Goods' && ma.Type__c == 'Shipping Origination'){
                        options.add(new SelectOption(ma.id, ma.Full_Address__c));
                        }
                    }
                if (options.size() == 0)
                    {
                        options.add(new SelectOption('', '---NONE AVAILABLE---'));
                    }
                    return options;
            }
        public String[] getMerchantAddresses ()
            {
                return MerchantAddresses;
            }
            
        public void setMerchantAddresses(String[] MerchantAddresses )
            {
                this.MerchantAddresses = MerchantAddresses ;
            }
    
    //Build Redemption Address Selection Box        
    ID[] RedemptionAddresses = new ID[]{};
                
        public List<SelectOption> getRedempAddys()
            {
                List<SelectOption> options = new List<SelectOption>();
                list<address__c> redemplist = [SELECT Id, Type__c, Venue_Name__c, Phone_Number__c, Full_Address__c, Name, Account__c, City__c, Opportunity__c, State__c, Street_Line_1__c, Street_Line_2__c, Country__c, Zip_Postal_Code__c, Account__r.Name, Merchant_Addresses__c FROM Address__c WHERE Opportunity__c = :ctrlid ];
                for (address__c ra : redemplist)
                    {
                        options.add(new SelectOption(ra.id, ra.Full_Address__c));
                    }
                if (options.size() == 0)
                    {
                        options.add(new SelectOption('', '---NONE SELECTED---'));
                    }
                return options;
            }

        public String[] getRedemptionAddresses ()
            {
                return RedemptionAddresses;
            }
            
        public void setRedemptionAddresses(String[] RedemptionAddresses )
            {
                this.RedemptionAddresses = RedemptionAddresses;
            }      
//TEST METHOD :     
@isTest

static void testAddressHelper()
    {
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                      localesidkey='en_US', profileid = p.Id,
                      timezonesidkey='America/Los_Angeles', username='test@groupon.com');
    insert u;
    //run as user
    System.RunAs(u)
        {
                
        //Create a sample account record.
            account a = new account();
                a.name = 'Addy Helper jabbawocki' + system.now();
            insert a;
        
        //Make sure acocunt is created and id is not null
            system.assert(a.id!= null);                        
       
        //Create New Merchant Address
            merchant_addresses__c m = new merchant_addresses__c();
                m.account__c = a.id;
                m.street_line_1__c = 'test street';
                m.street_line_2__c = 'test street 2';
                m.city__c = 'Sunnyvale';
                m.state_province__c = 'CA';
                m.zip_postal_code__c = '12345';
            insert m;

           system.assert(m.id != null);    
         
        //Create a test opportunity to feed it to the standard controller method.
            opportunity o = new opportunity();
                o.name = 'test oppty';
                o.AccountId = a.id;
                o.Deal_Strengh__c = 'Rep Getting Info';
                o.StageName = 'Prospecting';
                o.CloseDate = system.today();
            insert o;
          
            system.assert(o.id != null);
        
        //create a new address 
        // 1) make sure we create one address with good data and 
        // 2) make sure we create one address with bad date for negative testing.
            Address__c addy = new Address__c();
                addy.opportunity__c =o.id;
                addy.merchant_addresses__c = m.id;
                addy.account__c = a.id;
                addy.phone_number__c = '1234567890';
                addy.enrollment_status__c = 'open';
                addy.street_line_1__c = 'test street';
                addy.street_line_2__c = 'test street 2';
                addy.city__c = 'Sunnyvale';
                addy.state__c = 'CA';
                addy.zip_postal_code__c = '12345';  
            
            insert addy;          
        
            system.assert(addy.id != null);
        
            String[] RedemptionAddresses = new string[]{addy.Id};
            string[] merchantaddress = new string[]{m.id};
        //Test the RedemptionAddy page. The below 2 lines are meant to set the current page that needs to be tested.
            PageReference pr = Page.RedemptionAddy;
            Test.setCurrentPageReference(pr);
            
        //string ctrlId = ApexPages.currentPage().getParameters().put('id', o.id);
            string ctrlId = o.id;
            string defaultAccountId = a.id;
            
        //Pass to the standard controller value to the page. Here Opportunity is the standard controller.
            ApexPages.StandardController ApptController = new ApexPages.StandardController(o);
             
        //create a instance for the above class name. Instance is nothing but creating a name to call the class   (only classes which do not have static keyword can be instantiated.) 
        //Ex. public static class{ } cannot be instantiated as below. only class which has public class { } can be instantiated
            
            AddressHelper check = new Addresshelper(ApptController); 
 
        //We prepared the test data and now we are calling methods so that the parameters would passed to the main class and our code coverage gets established.   
            check.defaultAccountid = a.Id;
            check.getMerchantAddresses();
            check.setMerchantAddresses(merchantaddress); 
            check.insertAddy();
            check.cancelNewAddy();
            check.resetMerchAddy();
            check.getOpptyId();
            check.getactId();
            check.addMerchantAddress();
            check.deleteRedemptionAddress();
            check.addRedemptionAddress();
            check.getOpptyList();
            check.getAlreadySelected();
            check.getMerchAddys();
            check.getRedempAddys();
            check.getRedemptionAddresses();
            check.setRedemptionAddresses(RedemptionAddresses);
            }    
    }
 
}