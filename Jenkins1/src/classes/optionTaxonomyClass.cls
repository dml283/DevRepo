public class optionTaxonomyClass {
    
    public id ctrlId{get;set;}
    public id acctId{get;set;}
    public string errorMessages{get;set;}
    public string successMessages{get;set;}
    public string services{get;set;}
    public list<string> preSelectedServices{get;set;}
    public string OptionServicesArray {get;set;}
    public list<string>optionServices{get;set;}
    public list<string> preSelectMerchServices{get;set;}
    public string MerchantServicesArray{get;set;}
    public string MerchantServices{get;set;}
    public string attributes{get;set;}
    public list<string> preSelectedAttributes {get;set;}
    public string OptionAttributesArray {get;set;}
    
    public optionTaxonomyClass(){}
    
    public optionTaxonomyClass(ApexPages.StandardController controller) {
            ctrlId = ApexPages.currentPage().getParameters().get('Id');
            Multi_Deal__c merchant = [SELECT Id, Opportunity__r.AccountId FROM Multi_Deal__c WHERE Id = :ctrlId];
            acctId = merchant.Opportunity__r.AccountId;
            loadPreSelected();
        }

    public void updateTaxonomy(){
            successMessages = '';
            errorMessages = '';
            Multi_Deal__c md = [SELECT Id, Option_Services__c, Option_Attributes__c FROM Multi_Deal__c WHERE Id =: ctrlId];
            md.Option_Services__c = OptionServicesArray;
            md.Option_Attributes__c = OptionAttributesArray;
            try{
                update md;
                successMessages = 'Your Selections have been Saved!';
                }catch(DMLexception e){
                        errorMessages = e.getDmlMessage(0);
                    }
        }
    
    public void updateMerchant(){
            successMessages = '';
            errorMessages = '';
            Account a = [SELECT Id, Services_Offered__c FROM Account WHERE Id = : acctId];
            a.Services_Offered__c = MerchantServicesArray;
            try{
                update a;
                successMessages = 'Your Selections have been Saved!';
                }catch(DMLexception e){
                        errorMessages = e.getDmlMessage(0);
                    }
        }
    
    public void loadPreSelected(){
           Multi_Deal__c md = [SELECT Option_Services__c, Option_Attributes__c FROM Multi_Deal__c WHERE Id =: ctrlId LIMIT 1];
           //BUILD LIST OF PRESELECTED SERVICES
           if(md.Option_Services__c != null)
               {
                   services = md.Option_Services__c;
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
           if(md.Option_Attributes__c != null)
               {
                   attributes = md.Option_Attributes__c;
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
           Account ms = [SELECT  Services_Offered__c FROM Account WHERE Id = : acctId];
           if(ms.Services_Offered__c != null){
                   MerchantServices = ms.Services_Offered__c;
                   string[] setOfMerchantServices = MerchantServices.split('\\|');
                   preSelectMerchServices = new List<string>();
                   for(string s : setOfMerchantServices){
                       preSelectMerchServices.add(s);    
                       }
                   }else{
                           list<string> blankMservice = new list<string>{''};
                           preSelectMerchServices  = (blankMservice);
                           }
        }
        
        public class HeaderGrouping{
                public string Header {get;set;}
                public list<string> MerchServices {get;set;}
            }
        
        public set<string> getServiceOptions(){
                //optionTaxonomyClass optTax = new optionTaxonomyClass();
                
                set<string> alreadySelectedServices = new set<string>();
                Multi_Deal__c currentMD = [SELECT Option_Services__c, Opportunity__r.AccountId FROM Multi_Deal__c WHERE Id =: ctrlId];            
                system.debug('+++++++++++++++++++++++' + ctrlId);
                system.debug('***********************' + currentMD.Id);
                system.debug('^^^^^^^^^^^^^^^^^^^^^^^' + currentMD.Option_Services__c);
                if(currentMD.Option_Services__c != null){
                        string services = currentMD.Option_Services__c;
                        string [] setofServices = services.split('\\|');
                        list<string> preSelectedServices = new list<string>();
                        for(string s : setofServices){
                                preSelectedServices.add(s.trim());
                            }
                        for(string selected : preSelectedServices){
                                alreadySelectedServices.add(selected);
                            }   
                    }
                
                set<string> optionServices = new set<string>();
                string AcctId = currentmd.Opportunity__r.AccountId;
                Account a = [SELECT Services_Offered__c FROM Account WHERE Id =: AcctId];
                if(a.Services_Offered__c != null){
                        string acctServices = a.Services_Offered__c;
                        string[] setofAcctServices = acctServices.split('\\|');
                        for(string s : setofAcctServices){
                                optionServices.add(s.trim());
                            }
                    }
               for(string s : alreadySelectedServices){
                       optionServices.remove(s);
                   }
               return optionServices;      
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
        public static List<headerGrouping> getAttributeOptions(String queryCat, String currentIDattributes){
                optionTaxonomyClass optTax = new optionTaxonomyClass();
                
                Set<string> alreadySelectedAttributes = new Set<string>();
                Multi_Deal__c currentMD = [SELECT Option_Attributes__c FROM Multi_Deal__c WHERE Id =: currentIDattributes LIMIT 1];
                
                if(currentMD.Option_Attributes__c != null)
                  {
                    string attributes = currentMD.Option_Attributes__c;
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
                List<Taxonomy_Support__c> aAttributes = [SELECT Name__c, Type__c, Header__c FROM Taxonomy_Support__c WHERE Category__c =: queryCat and Type__c = 'Deal Attribute' and Name__c NOT IN : alreadySelectedAttributes];
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
    @isTest
    static void optionTaxonomyClass(){
            grouponTestUtil gTestUtil = new grouponTestUtil();
            User u = gTestUtil.createTestUser('System Administrator');
            u.username = 'optionTaxClass@groupon.com';
            insert u;
            System.RunAs(u){
                
                    Taxonomy_Support__c ts1 = gTestUtil.txnmySupportTest();
                    ts1.Name__c = 'TestName';
                    ts1.Category__c = 'Test Category';
                    ts1.Header__c = 'TestHeader';
                    ts1.Type__c = 'Merchant Service';
                    insert ts1;
                    
                    Taxonomy_Support__c ts2 = gTestUtil.txnmySupportTest();
                    ts2.Name__c = 'TestName';
                    ts2.Category__c = 'Test Category';
                    ts2.Header__c = 'TestHeader';
                    ts2.Type__c = 'Merchant Attribute';
                    insert ts2;
                    
                    Taxonomy_Support__c ts3 = gTestUtil.txnmySupportTest();
                    ts3.Name__c = 'TestName';
                    ts3.Category__c = 'Test Category';
                    ts3.Header__c = 'TestHeader';
                    ts3.Type__c = 'Deal Attribute';
                    insert ts3;
                    
                    Account Acct = gTestUtil.createAccount();
                    acct.Category_v3__c = 'Test Category';
                    acct.Services_Offered__c = 'Test 1 | Test 2';
                    insert Acct;
                    
                    Account Acct1 = gTestUtil.createAccount();
                    acct1.Category_v3__c = 'Test2 Lorem';
                    insert Acct1;
                    
                    Opportunity oppty = gTestUtil.createDeal();
                    oppty.AccountId = Acct.Id;
                    insert oppty;
                    
                    Multi_Deal__c md = gTestUtil.createOption();
                    md.Opportunity__c = oppty.Id;
                    md.Option_Services__c = 'Test 1 | Test 2';
                    md.Option_Attributes__c = 'Test Attributes';
                    insert md;

                    Multi_Deal__c md1 = gTestUtil.createOption();
                    md1.Opportunity__c = oppty.Id;
                    insert md1;
                    
                    PageReference pr = page.optionTaxonomyVF;
                    Test.setCurrentPageReference(pr);

                    ApexPages.currentPage().getParameters().put('id',md.id);

                    ApexPages.StandardController mdController = new ApexPages.StandardController(md);
                    system.debug('mdController!!!!!!!!!!!!!!' + mdController); 
                    optionTaxonomyClass optionTaxClass = new  optionTaxonomyClass(mdController);
                    system.debug('optionTaxClass!!!!!!!!!' + optionTaxClass);
                    optionTaxClass.updateTaxonomy();
                    optionTaxClass.updateMerchant();
                    optionTaxClass.getServiceOptions();
                    
                    ApexPages.currentPage().getParameters().put('id', md1.id);
                    ApexPages.StandardController mdController1 = new ApexPages.StandardController(md1); 
                    optionTaxonomyClass optionTaxClass1 = new  optionTaxonomyClass(mdController1);
                    optionTaxClass1.updateTaxonomy();
                    optionTaxClass1.updateMerchant();
                    optionTaxClass1.getServiceOptions();   
                    
                    string acctID1 = Acct.id;
                    optionTaxonomyClass.getServiceOptions('Test Category', acctID1);
                    
                    string acctID2 = Acct1.id;
                    optionTaxonomyClass.getServiceOptions('Test Category', acctID2);
                    
                    string mdID1 = md.id;
                    optionTaxonomyClass.getAttributeOptions('Test Category', mdID1);
                    
                    string mdID2 = md1.id;
                    optionTaxonomyClass.getAttributeOptions('Test Category', mdID2);
                    
                }         
        }            
}