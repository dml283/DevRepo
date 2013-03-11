public without sharing class poTaxonomyClass{
    //PO ID AND CATEGORY VARS
    public id ctrlId{get;set;}
    public string ctrlCat{get;set;}
    //CAT AND SUBCAT
    public string SelectedCategory {get;set;}
    public string SelectedSubCategory {get;set;}
    //ALL SERVICES VARS
    public string services{get;set;}
    public list<string> preSelectedServices {get;set;}
    public string SelectedServicesArray {get;set;}
    //ALL ATTRIBUTES VARS
    public string attributes{get;set;}
    public list<string> preSelectedAttributes {get;set;}
    public string SelectedMerchAttributesArray {get;set;}
    //SUCCESS & ERROR MESSAGING VARS
    public string successMessages{get;set;}
    public string errorMessages{get;set;}
    
    public poTaxonomyClass(){}
    
    public poTaxonomyClass(ApexPages.StandardController controller)
        {
            ctrlId = ApexPages.currentPage().getParameters().get('Id');
            loadPreSelectedVals();
        }
    
    public void loadPreSelectedVals(){
        Purchase_Order__c po = [SELECT Services__c, Merchant_Attributes__c FROM Purchase_Order__c WHERE Id =: ctrlId LIMIT 1];
        if(po.Services__c != null){
                services = po.Services__c ;
                string[] setofsrvcs = services.split('\\|');
                preSelectedServices = new List<String>();
                for(string s : setofsrvcs){
                        preSelectedServices.add(s);
                    }
            }
            else{
                   list<string> servicesVal = new list<string>{''};
                   preSelectedServices = (servicesVal);
               }
                  
         if(po.Merchant_Attributes__c != null){
                 attributes = po.Merchant_Attributes__c;
                 string[] setofattributes = attributes.split('\\|');
                 preSelectedAttributes = new List<String>();
                 for(string s : setofattributes){
                         preSelectedAttributes.add(s);
                     }
             }
             else{
                     list<string> attributesVal = new list<string>{''};
                     preSelectedAttributes = (attributesVal);
                 }
    }
    
    public class HeaderGrouping{
            public string Header {get;set;}
            public list<string> MerchServices {get;set;}
        }
    //POPULATE TEMPLATE WITH SERVICE OPTIONS TO SELECT
    @RemoteAction
    public static list<headerGrouping> getServiceOptions(String queryCat, String currentId){
             poTaxonomyClass poTaxClass = new poTaxonomyClass();
             set<string> alreadySelectedServices = new set<string>();
             Purchase_Order__c currentPO = [SELECT Services__c FROM Purchase_Order__c WHERE Id =: currentId LIMIT 1];
             //POPULATE ALREADY SELECTED SERVICES SET SO OPTIONS THAT ARE ALREADY SELECTED DO NOT APPEAR AS OPTIONS
             if(currentPO.Services__c != null){
                     string services = currentPO.Services__c;
                     string[] setOfSrvcs = services.split('\\|');
                     list<string> preSelectedServices = new list<string>();
                     for(string s:setOfSrvcs){
                             preSelectedServices.add(s.trim());
                         }
                     for(string selected : preSelectedServices){
                             alreadySelectedServices.add(selected);
                         }
                 }
            //BUILD LIST OF OPTIONS GROUPED BY HEADER TO BE REFERENCED BY JS TEMPLATING IN THE VF PAGE     
            list<headerGrouping> HG = new list<headerGrouping>();
            list<taxonomy_support__c> poServices = [SELECT Name__c, Type__c, Header__c
                                                    FROM Taxonomy_Support__c
                                                    WHERE Category__c = :queryCat and Type__c = 'Merchant Service' and Name__c NOT IN : alreadySelectedServices];
            map<string,list<string>> servicesMap = new map <string,List<string>>();
            set<string> categories = new set<string>();
            system.debug('POservices!!!!!!!!!!!!!!!!!!!!!!!!!!!!' + POservices);
            for(taxonomy_support__c ts : poServices){
                    categories.add(ts.header__c);
                    boolean contains = servicesMap.containsKey(ts.header__c);
                    
                    if(contains == true){
                            list<string> srvcList = servicesMap.get(ts.header__c);
                            srvcList.add(ts.name__c);
                            servicesMap.put(ts.header__c, srvcList);
                        }
                        else
                            {
                                 list<string> srvcList = new list<string>();
                                 srvcList.add(ts.name__c);
                                 servicesMap.put(ts.header__c,srvcList);
                            }
                }
            for(string s : categories){
                    headerGrouping h = new headerGrouping();
                    h.header = s;
                    h.MerchServices = servicesMap.get(s);
                    HG.add(h);
                }
            return HG;
        }         
    //POPULATE TEMPLATE WITH ATTRIBUTE OPTIONS TO SELECT
    @RemoteAction
    public static list<headerGrouping> getAttributeOptions(String queryCat, String currentId){
            poTaxonomyClass poTaxClass = new poTaxonomyClass();
            set<string> alreadySelectedAttributes = new set<string>();
            Purchase_Order__c currentPO = [SELECT merchant_attributes__c FROM Purchase_Order__c WHERE Id =: currentId LIMIT 1]; 
            //POPULATE ALREADY SELECTED ATTRIBUTES SET SO OPTIONS THAT ARE ALREADY SELECTED DO NOT APPEAR AS OPTIONS
            if(currentPO.merchant_attributes__c != null){
                    string services = currentPO.merchant_attributes__c;
                    string[] setOfAttrs = services.split('\\|');
                    list<string> preSelectedAttributes = new list<string>();
                for(string a:setOfAttrs){
                        preSelectedAttributes.add(a.trim());
                    }
                for(string selected : preSelectedAttributes){
                        alreadySelectedAttributes.add(selected);
                    }
                }
            //BUILD LIST OF OPTIONS GROUPED BY HEADER TO BE REFERENCED BY JS TEMPLATING IN THE VF PAGE     
            list<headerGrouping> HG = new list<headerGrouping>();
            list<taxonomy_support__c> poAttributes = [SELECT Name__c, Type__c, Header__c
                                                    FROM Taxonomy_Support__c
                                                    WHERE Category__c = :queryCat and Type__c = 'Merchant Attribute' and Name__c NOT IN : alreadySelectedAttributes];
            map<string,list<string>> attributesMap = new map <string,List<string>>();
            set<string> categories = new set<string>();
            for(taxonomy_support__c ts : poAttributes){
                    categories.add(ts.header__c);
                    boolean contains = attributesMap.containsKey(ts.header__c);
                    
                    if(contains == true){
                            list<string> attrList = attributesMap.get(ts.header__c);
                            attrList.add(ts.name__c);
                            attributesMap.put(ts.header__c, attrList);
                        }
                        else
                            {
                                 list<string> attrList = new list<string>();
                                 attrList.add(ts.name__c);
                                 attributesMap.put(ts.header__c,attrList);
                            }
                }
            for(string s : categories){
                    headerGrouping h = new headerGrouping();
                    h.header = s;
                    h.MerchServices = attributesMap.get(s);
                    HG.add(h);
                }
            return HG;
        }
    //SAVE CHANGES TO PO
    public void updatePO(){
            successMessages = '';
            errorMessages = '';
            Purchase_Order__c currentPO = [SELECT Id, Category_v3__c, Subcategory_v3__c, Services__c, Merchant_Attributes__c FROM Purchase_Order__c WHERE Id =: ctrlID];
            currentPO.Category_v3__c = SelectedCategory;
            currentPO.Subcategory_v3__c = SelectedSubCategory;
            currentPO.Services__c = SelectedServicesArray;
            currentPO.Merchant_Attributes__c = SelectedMerchAttributesArray;
            try{
                update currentPO;
                successMessages = 'Your Selections have been Saved!';
                }catch(DMLexception e){
                    errorMessages = e.getDmlMessage(0);
                }
        }
    
    @istest
    static void poTaxonomyClass(){
            grouponTestUtil gTestUtil = new grouponTestUtil();
            User u = gTestUtil.createTestUser('System Administrator');
            insert u;
            System.RunAs(u){
                    //Division__c Div = gTestUtil.createDivision();
                    //insert div;
                    
                    Taxonomy_Support__c ts1 = gTestUtil.txnmySupportTest();
                    ts1.Name__c = 'TestName';
                    ts1.Category__c = 'TestCategory';
                    ts1.Header__c = 'TestHeader';
                    ts1.Type__c = 'Merchant Service';
                    insert ts1;

                    Taxonomy_Support__c ts2 = gTestUtil.txnmySupportTest();
                    ts2.Name__c = 'TestName';
                    ts2.Category__c = 'TestCategory';
                    ts2.Header__c = 'TestHeader';
                    ts2.Type__c = 'Merchant Attribute';
                    insert ts2;
                    
                    Purchase_Order__c po = gTestUtil.createPO();
                    po.Category_v3__c = 'TestCategory';
                    po.Services__c = 'TestPOservices';
                    po.Merchant_Attributes__c = 'TestMerchAttr';
                    insert po;
                    
                    Purchase_Order__c po2 = gTestUtil.createPO();
                    insert po2;
                    
                    PageReference pr = page.poTaxonomyVF;
                    Test.setCurrentPageReference(pr);
                    
                    string currentid = ApexPages.currentPage().getParameters().put('id', po.id);
                    ApexPages.StandardController stdController = new ApexPages.StandardController(po); 
                    poTaxonomyClass poTaxClass = new  poTaxonomyClass(stdController);          
                     
                    poTaxClass.loadPreSelectedVals();
                    poTaxonomyClass.getServiceOptions('TestCategory', po.id);
                    poTaxonomyClass.getAttributeOptions('TestCategory', po.id);
                    poTaxClass.updatePO();
                    poTaxonomyClass POtest = new poTaxonomyClass();
                    
                    string currentid2 = ApexPages.currentPage().getParameters().put('id', po2.id);
                    ApexPages.StandardController stdController2 = new ApexPages.StandardController(po2); 
                    poTaxonomyClass poTaxClass2 = new  poTaxonomyClass(stdController2);
                    poTaxClass2.loadPreSelectedVals();
                }
        }
}