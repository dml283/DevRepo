public class AcctTaxonomy {
    
    public id ctrlId{get;set;}
    public string ctrlCat{get;set;}
    public string services{get;set;}
    public list<string> preSelectedServices{get;set;}
    public string attributes{get;set;}
    public list<string> preSelectedAttributes{get;set;}
    public string pageURL{get;set;}
    public string SelectedCategory {get;set;}
    public string SelectedSubCategory {get;set;}
    public string SelectedServicesArray {get;set;}
    public string SelectedMerchAttributesArray {get;set;}
    public string errorMessages{get;set;}
    public string successMessages{get;set;}
    public AcctTaxonomy(){}
       
    public AcctTaxonomy(ApexPages.StandardController controller)
        {
            ctrlId = ApexPages.currentPage().getParameters().get('Id');
            pageURL = ctrlId;
            loadCategory();
        }
    
    public void loadCategory()
       {
           Account acct = [SELECT Category_v3__c, Services_Offered__c,Merchant_Attributes__c FROM Account WHERE Id =: ctrlId LIMIT 1];
           ctrlCat = acct.Category_v3__c ;
           //BUILD LIST OF PRESELECTED SERVICES
           
           if(acct.Services_Offered__c != null)
               {
                   services = acct.Services_Offered__c ;
                   string[] setofsrvcs = services.split('\\|');
                   preSelectedServices  = new List<String>();
               
                   for(string s : setofsrvcs)
                       {
                           preSelectedServices.add(s);
                       }
               }else
                  {
                      list<string> blanksrvc = new list<string>{''};
                      preSelectedServices= (blanksrvc);
                  }
           //BUILD LIST OF PRESELECTED ATTRIBUTES
           if(acct.Merchant_Attributes__c != null)
               {
                   attributes = acct.Merchant_Attributes__c;
                   string[] setofattributes = attributes.split('\\|');
                   preSelectedAttributes = new List<String>();

                   for(string s : setofattributes)
                       {
                           preSelectedAttributes.add(s);
                       }
               }else
                  {
                      list<string> blankattr = new list<string>{''};
                      preSelectedAttributes = (blankattr);
                  }
       }
    
    public class HeaderGrouping
        {
            public string Header {get;set;}
            public list<string> MerchServices {get;set;}
        }
@RemoteAction        
    public static list<headerGrouping> getServiceOptions(String queryCat, String currentIDservices)
        {
            AcctTaxonomy Accttax = new AcctTaxonomy();
            
            Set<string> alreadySelectedServices = new Set<string>();
            Account currentAcct = [SELECT Services_Offered__c FROM Account WHERE Id =: currentIDservices LIMIT 1];
        
            if(currentAcct.Services_Offered__c != null)
              {
                string services = currentAcct.Services_Offered__c ;
                string[] setofsrvcs = services.split('\\|');
                list<String> preSelectedServices = new List<String>();
              
                for(string s : setofsrvcs)
                    {
                        preSelectedServices.add(s.trim());
                    }
                for(string selected : preSelectedServices)
                    {
                        alreadySelectedServices.add(selected);
                    }
              }
            
            
            //This is the list that we will return at the end
            list<headerGrouping> HG = new list<headerGrouping>();
            //This is the Query we use to get all of the records we need
            List<Taxonomy_Support__c> aServices = [SELECT Name__c, Type__c, Header__c FROM Taxonomy_Support__c WHERE Category__c =: queryCat and Type__c = 'Merchant Service' and Name__c NOT IN : alreadySelectedServices];
            //This map is: map of Header as the Key and the Pair is the list of all services returned ex: Beauty==>{hair,nails....} 
            map<string,list<string>> servicesMap = new map<string,list<string>>();
            //set of all cateogries without dupes
            set<string> Categories = new set<string>();
            
            //loop over the query we ran so that we cna parse out the taxonmy in to the HeaderGrouping Class
            for(Taxonomy_Support__c t : aServices)
                {
                    //Adding value in Header__c field to Categories set
                    Categories.add(t.Header__c);
                    //checking that header value is in TaxMap if non-exist create new list
                    Boolean contains = servicesMap.containsKey(t.Header__c);
                    
                    if(contains == true)
                        {
                            list<string> slist = servicesMap.get(t.header__c);
                            slist.add(t.name__c);
                            servicesMap.put(t.header__c,slist);
                        }else{
                                list<string> slist = new list<string>();
                                slist.add(t.name__c);
                                servicesMap.put(t.header__c,slist);
                             }
                }
                
           for(string s : categories)
                {
                    HeaderGrouping h = new HeaderGrouping();
                    h.Header = s;
                    h.MerchServices = servicesMap.get(s);
                    HG.add(h);
                }
            
            return hg;
        }

@RemoteAction    
    public static List<headerGrouping> getAttributeOptions(String queryCat, String currentIDattributes)
        {
            AcctTaxonomy Accttax = new AcctTaxonomy();
            
            Set<string> alreadySelectedAttributes = new Set<string>();
            Account currentAcct = [SELECT Merchant_Attributes__c FROM Account WHERE Id =: currentIDattributes LIMIT 1];
            
            if(currentAcct.Merchant_Attributes__c != null)
              {
                string attributes = currentAcct.Merchant_Attributes__c ;
                string[] setofattrs = attributes.split('\\|');
                list<String> preSelectedAttributes = new List<String>();
              
                for(string s : setofattrs)
                    {
                        preSelectedAttributes.add(s.trim());
                    }
                for(string selected : preSelectedAttributes)
                    {
                        alreadySelectedAttributes.add(selected);
                    }
              }
            
            //This is the list that we will return at the end for the Attribute Options
            list<headerGrouping> HG = new list<headerGrouping>();
            //This is the Query we use to get all of the records we need
            List<Taxonomy_Support__c> aAttributes = [SELECT Name__c, Type__c, Header__c FROM Taxonomy_Support__c WHERE Category__c =: queryCat and Type__c = 'Merchant Attribute' /*and Name__c NOT IN : alreadySelected*/];
            //This map is: map of Header as the Key and the Pair is the list of all services returned ex: Beauty==>{hair,nails....} 
            map<string,list<string>> attributesMap = new map<string,list<string>>();
            //set of all cateogries without dupes
            set<string> Categories = new set<string>();
            
            //loop over the query we ran so that we cna parse out the taxonmy in to the HeaderGrouping Class
            for(Taxonomy_Support__c t : aAttributes)
                {
                    //Adding value in Header__c field to Categories set
                    Categories.add(t.Header__c);
                    //checking that header value is in TaxMap if non-exist create new list
                    Boolean contains = attributesMap.containsKey(t.Header__c);
                    
                    if(contains == true)
                        {
                            list<string> slist = attributesMap.get(t.header__c);
                            slist.add(t.name__c);
                            attributesMap.put(t.header__c,slist);
                        }else{
                                list<string> slist = new list<string>();
                                slist.add(t.name__c);
                                attributesMap.put(t.header__c,slist);
                             }
                }
                
           for(string s : categories)
                {
                    HeaderGrouping h = new HeaderGrouping();
                    h.Header = s;
                    h.MerchServices = attributesMap.get(s);
                    HG.add(h);
                }
            
            return hg;
        }
        
    public void inlineSave()
        {
            successMessages = '';
            errorMessages = '';
            Account cA = [SELECT Id, Category_v3__c, subcategory_v3__c, Services_Offered__c, Merchant_Attributes__c FROM Account WHERE Id =: ctrlID];
            cA.Category_v3__c = SelectedCategory;
            cA.Subcategory_v3__c = SelectedSubCategory;
            cA.Services_Offered__c = SelectedServicesArray;
            cA.Merchant_Attributes__c = SelectedMerchAttributesArray;
            try{
                update cA;
                successMessages = 'Your Selections have been Saved!';
                }catch(DMLexception e){
                    errorMessages = e.getDmlMessage(0);
                    //ApexPages.addMessages(e);
                } 
        }     
        
    @istest
    static void AcctTaxonomy()
    {                          
         Profile p = [select id from profile where name='System Administrator'];
                      User u = new User(alias = 'standt', email='standarduser@groupon.com',
                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                      localesidkey='en_US', profileid = p.Id,
                      timezonesidkey='America/Los_Angeles', username='acctTaxonomy@groupon.com');
                      insert u;
          //run as user
         System.RunAs(u)
         {
             account a = new account();
             a.name = 'Acct Taxonomy Account'+system.now();
             a.Category_v3__c = 'Food & Drink';
             a.Services_Offered__c = 'Bar - Ice';
             a.Merchant_Attributes__c = 'Afternoon Tea';
             a.phone = '3698754123';
             account a2 = new account();
             a2.name = 'Acct 2qwerty';
             a2.phone = '8547536158';
             
             taxonomy_support__c ts1 = new taxonomy_support__c();
             ts1.category__c = 'Food & Drink';
             ts1.header__c = 'Bar / Club / Hall Type';
             ts1.name__c = 'Bar - Ice';
             ts1.type__c = 'Merchant Service';
             insert ts1;
             
             taxonomy_support__c ts2 = new taxonomy_support__c();
             ts2.category__c = 'Food & Drink';
             ts2.header__c = 'Bar / Club / Hall Type';
             ts2.name__c = 'Other';
             ts2.type__c = 'Merchant Service';
             insert ts2;
             
             taxonomy_support__c ts3 = new taxonomy_support__c();
             ts3.category__c = 'Food & Drink';
             ts3.header__c = 'Bar / Club / Hall Type';
             ts3.name__c = 'Afternoon Tea';
             ts3.type__c = 'Merchant Attribute';
             insert ts3;
             
             taxonomy_support__c ts4 = new taxonomy_support__c();
             ts4.category__c = 'Food & Drink';
             ts4.header__c = 'Bar / Club / Hall Type';
             ts4.name__c = 'Bar / Lounge';
             ts4.type__c = 'Merchant Attribute';
             insert ts4;
             
             //Test.starttest();
             insert a;
             insert a2;
             //Test.stopTest();
             
             PageReference p1 = Page.MerchantTaxonomyAcct;
             Test.setCurrentPageReference(p1);
            
             //add the current page id for test acct 'a'.
             string currentid = ApexPages.currentPage().getParameters().put('id', a.id);             
             
             //Pass to the controller the Opportunity value
             ApexPages.StandardController ApptController = new ApexPages.StandardController(a); 
             AcctTaxonomy check = new  AcctTaxonomy(ApptController);          
             
             //call the subsequent methods.
             check.loadCategory();
             AcctTaxonomy.getServiceOptions('Food & Drink', a.id);
             AcctTaxonomy.getAttributeOptions('Food & Drink', a.id);
             check.inlineSave();          
            
             //add the current page id for test acct 'a2'
             string currentid2 = ApexPages.currentPage().getParameters().put('id', a2.id);
             
             //Pass to the controller the Opportunity value for 'a2'
             ApexPages.StandardController ApptController2 = new ApexPages.StandardController(a2); 
             AcctTaxonomy check2 = new  AcctTaxonomy(ApptController2);       
             
             //call the subsequent methods.
             check2.loadCategory();
          } 
     }                
        
}