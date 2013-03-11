public class MerchantAddresses2 {
    public boolean newAddy{get;set;}
    public boolean editAddy{get;set;}
    public boolean viewAddy{get;set;}
    Merchant_Addresses__c merchantaddress = new Merchant_Addresses__c();
    public merchant_addresses__c mercha {GET;SET;}
    public merchant_addresses__c selectedrecord = new merchant_addresses__c();
    public List<Merchant_Addresses__c> MerchAddyList = new List<Merchant_Addresses__c>();
    public List<MerchAddyClass> merchantaddresslist = new List<MerchAddyClass>();
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    public string strDelSelId {get;set;}
    public string strEditSelId {get;set;}
    public string editMode {get;set;}
    public string rowNum{get;set;}
    public string STREETLINE1{get;set;}
    public string STREETLINE2{get;set;}
    set<id> merchid = new set<id>();
        
        public MerchantAddresses2(ApexPages.StandardController controller)
            {
  
               viewAddy = true;
               newAddy = false;
               editAddy = false;
            }
        
        public void insertAddy()
            {
                viewAddy = false;
                newAddy = true;
                editAddy = false;
                strDelSelId = null;
                strEditSelId = null;
            }
        
        public Merchant_Addresses__c getMerchFields()
            {
                return merchantaddress ;
            }
        
        public void saveNewMerchAddy()
            {
                 Merchant_Addresses__c ma = new Merchant_Addresses__c
                 ( 
                     account__c = CurrentId,
                     street_line_1__c = merchantaddress.street_line_1__c,
                     Street_Line_2__c = merchantaddress.Street_Line_2__c,
                     City__c = merchantaddress.City__c,
                     State_Province__c = merchantaddress.State_Province__c,
                     Zip_Postal_Code__c = merchantaddress.Zip_Postal_Code__c,
                     Country__c = merchantaddress.country__c,
                     Phone_Number__c = merchantaddress.Phone_Number__c,
                     Venue_Name__c = merchantaddress.Venue_Name__c,
                     Merchant_Id__c = merchantaddress.Merchant_Id__c,
                     Terminal_ID__c = merchantaddress.Terminal_ID__c
                 );
                 database.insert(ma);
                 merchantaddress.clear();
                 MerchAddyList.clear();
                 newAddy = false;
                 editAddy = false;
                 viewAddy = true; 
            }
            
        public void cancelMerchAddy()
            {
                 newAddy = false;
                 editAddy = false;
                 viewAddy = true;
            }

        public List<MerchAddyClass> getmerchaddydata()
            {
 
                merchantaddresslist.clear();
                for(merchant_addresses__c mercha : [select id, name, type__c, street_line_1__c, Street_Line_2__c,City__c,State_Province__c,Zip_Postal_Code__c,Country__c, Phone_Number__c,Venue_Name__c,Merchant_Id__c,Terminal_ID__c,account__c  
                                                    from merchant_addresses__c 
                                                    where account__c =: currentId])
                merchantaddresslist.add(new MerchAddyClass(mercha));
                return merchantaddresslist ;
          
            }
        
        public PageReference getSelected()
            {
                for(MerchAddyClass Infowrapper: merchantaddresslist)
                    {
                        if(Infowrapper.passId == strEditSelId)
                            {
                                selectedrecord=Infowrapper.merchantaddy;
                            }
                    }
         
                return null;
            }
            
        public merchant_addresses__c GetSelectedMerchAddress()
            {
               getSelected();  
                  
               if(selectedrecord !=null)
               {
                   return selectedrecord;
               }
                return null;
            }
        
        public void updatemethod()
            {
            Merchant_Addresses__c ma ;
          
                  ma = new Merchant_Addresses__c 
                     (
                         id = strEditSelId,
                         account__c = CurrentId,
                         street_line_1__c = selectedrecord.street_line_1__c,
                         Street_Line_2__c = selectedrecord.street_line_2__c,
                         City__c = selectedrecord.City__c,
                         State_Province__c = selectedrecord.State_Province__c,
                         Zip_Postal_Code__c = selectedrecord.Zip_Postal_Code__c,
                         Country__c = selectedrecord.Country__c,
                         Phone_Number__c = selectedrecord.Phone_Number__c,
                         Venue_Name__c = selectedrecord.Venue_Name__c,
                         Merchant_Id__c = selectedrecord.Merchant_Id__c,
                         Terminal_ID__c = selectedrecord.Terminal_ID__c,
                         Type__c = selectedrecord.Type__c
                     );
            try
            {
                    database.saveresult SR = database.update(ma);
                    if(SR.IsSuccess()){}
                    viewAddy = true;
                    newAddy = false;
                    editAddy = false;
                    strEditSelId = null;
            }
            catch (Exception e)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }

      public pagereference editMerchAddy()
            {
                newAddy = false;
                editAddy = true;
                viewAddy = false;
                return null;
            }          
        
        public void delMerchAddy()
            {  
                try
                    {
                        database.delete(strDelSelId);
                        strDelSelId = null;
                    }
                    catch (Exception e)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                    }
                newAddy = false;
                editAddy = false;
                viewAddy = true;
            }
        
        public class MerchAddyClass
            {
             
                public Merchant_Addresses__c merchantaddy{get; set;}
                public Id passId {get;set;}
                public MerchAddyClass(Merchant_Addresses__c addy)
                {
                    merchantaddy = addy;
                    passid = addy.id;
                }
                
            }
            
    @istest 
    static void testMerchantAddresses()
    {                          
         Profile p = [select id from profile where name='System Administrator'];
                      User u = new User(alias = 'standt', email='standarduser@groupon.com',
                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                      localesidkey='en_US', profileid = p.Id,
                      timezonesidkey='America/Los_Angeles', username='MerchAddyTest@groupon.com');
                      insert u;
          //run as user
         System.RunAs(u)
         {
             account a = new account();
                                     a.name = 'test acct';
                                     insert a;                       
             //system.assert(a.id!= null);
             
             Merchant_Addresses__c ma1 = new Merchant_Addresses__c();
             ma1.account__c = a.Id;
             ma1.street_line_1__c = '600 W Chicago';
             ma1.Street_Line_2__c ='6th Floor';
             ma1.City__c = 'Chicago';
             ma1.State_Province__c ='IL';
             ma1.Zip_Postal_Code__c ='60010';
             
             Test.starttest();
             insert ma1;
         
             Test.stopTest();
             PageReference p1 = Page.merchantaddys;
             Test.setCurrentPageReference(p1);
            
             //add the current page id.
             string currentid = ApexPages.currentPage().getParameters().put('id', a.id);
            
             //Pass to the controller the Opportunity value
             ApexPages.StandardController ApptController = new ApexPages.StandardController(a); 
             MerchantAddresses2  check = new  MerchantAddresses2(ApptController);              
             
             check.merchantaddresslist.add(new MerchantAddresses2.MerchAddyClass(ma1));
             
             check.selectedrecord=ma1;
             check.MerchAddyList.add(ma1);
             //call the subsequent methods.
             check.insertAddy();  
             check.getMerchFields();
             check.editMerchAddy();
             check.GetSelectedMerchAddress();
             check.updatemethod();
             check.getSelected();
             check.saveNewMerchAddy();           
             check.getmerchaddydata();            
             check.cancelMerchAddy();
             check.delMerchAddy();
             
          } 
     }               
                        
}