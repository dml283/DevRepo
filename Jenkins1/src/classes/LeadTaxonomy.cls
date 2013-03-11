public without sharing class LeadTaxonomy {

    public id ctrlId{get;set;}
    public string ctrlCat{get;set;}
    public string services{get;set;}
    public list<string> preSelectedServices {get;set;}
    public string attributes{get;set;}
    public list<string> preSelectedAttributes {get;set;}
    public string SelectedServicesArray {get;set;}
    public string SelectedMerchAttributesArray {get;set;}
    public string SelectedCategory {get;set;}
    public string SelectedSubCategory {get;set;}
    public string successMessages{get;set;}
    public string errorMessages{get;set;}
    public LeadTaxonomy(){}
    
    public LeadTaxonomy(ApexPages.StandardController controller)
        {
            ctrlId = ApexPages.currentPage().getParameters().get('Id');
            loadCategory();
        }
    
    public void inlineSave()
        {
            successMessages = '';
            errorMessages = '';
            Lead cL = [SELECT Id, Category_v3__c, Subcategory_v3__c, Services_Offered__c, Merchant_Attributes__c FROM Lead WHERE Id =: ctrlID];
            cL.Category_v3__c = SelectedCategory;
            cL.Subcategory_v3__c = SelectedSubCategory;
            cL.Services_Offered__c = SelectedServicesArray;
            cL.Merchant_Attributes__c = SelectedMerchAttributesArray;
            try{
                update cL;
                successMessages = 'Your Selections have been Saved!';
                }catch(DMLexception e){
                    errorMessages = e.getDmlMessage(0);
                }
        }
    
    public class HeaderGrouping
      {
        public string Header {get;set;}
        public list<string> MerchServices {get;set;}
      }
    
    //Get the category from the current record. Check if services/attributes have already been selected and populate values in a list
    public void loadCategory()
      {
        Lead l = [SELECT Services_Offered__c,Merchant_Attributes__c FROM Lead WHERE Id =: ctrlId LIMIT 1];

        if(l.Services_Offered__c != null)
          {
            services = l.Services_Offered__c ;
            string[] setofsrvcs = services.split('\\|');
            preSelectedServices = new List<String>();
          
            for(string s : setofsrvcs)
                {
                    preSelectedServices.add(s);
                }
          } 
          else 
            {
             list<string> servicesVal = new list<string>{''};
             preSelectedServices = (servicesVal);
            }
                  
         if(l.Merchant_Attributes__c != null)
           {
             attributes = l.Merchant_Attributes__c;
             string[] setofattributes = attributes.split('\\|');
             preSelectedAttributes = new List<String>();
           
             for(string s : setofattributes)
                 {
                     preSelectedAttributes.add(s);
                 }
           }
           else
             {
              list<string> attributesVal = new list<string>{''};
              preSelectedAttributes = (attributesVal);
             }
      }         
     
    //Create a list of taxonomy support records that contain the category from the lead record where type = merchant service 
@RemoteAction    
    public static list<headerGrouping> getServiceOptions(String queryCat, String currentID)
      {
        LeadTaxonomy tax = new LeadTaxonomy();
        Set<string> alreadySelectedServices = new Set<string>();
        Lead currentLead = [SELECT Services_Offered__c FROM Lead WHERE Id =: currentID LIMIT 1];
        
        if(currentLead.Services_Offered__c != null)
          {
            string services = currentLead.Services_Offered__c ;
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
        
        list<headerGrouping> HG = new list<headerGrouping>();
        list<Taxonomy_Support__c> lServices = [SELECT Name__c, Type__c, Header__c FROM Taxonomy_Support__c WHERE Category__c = :queryCat and Type__c = 'Merchant Service' and Name__c NOT IN : alreadySelectedServices];
        map<string,list<string>> servicesMap = new map<string,list<string>>();
        set<string> Categories = new set<string>();
        
        //Loop through the list and add all headers to the set. Check if the services map already contains the header
        for(Taxonomy_Support__c t : lServices)
          {
            Categories.add(t.Header__c);
            Boolean contains = servicesMap.containsKey(t.Header__c);
            
            //If the map already contains the header then add any new services to the list in the map
            if(contains == true)
              {
                list<string> slist = servicesMap.get(t.header__c);
                slist.add(t.name__c);
                servicesMap.put(t.header__c,slist);
              //If the map doesn't already contain the header then create a new list of all services related to the header and add the header and list to the map
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
        return HG;
      }

//Create a list of taxonomy support records that contain the category from the lead record where type = merchant attribute      
@RemoteAction  
    public static list<headerGrouping> getAttributeOptions(String queryCat, String currentIDattr)
      {
        LeadTaxonomy tax = new LeadTaxonomy();
        Set<string> alreadySelectedAttributes = new Set<string>();
        Lead currentLead = [SELECT Merchant_Attributes__c FROM Lead WHERE Id =: currentIDattr LIMIT 1];
        
        if(currentLead.Merchant_Attributes__c != null)
          {
            string attributes = currentLead.Merchant_Attributes__c ;
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
        
        list<headerGrouping> HG = new list<headerGrouping>();
        list<Taxonomy_Support__c> lAttributes = [SELECT Name__c, Type__c, Header__c FROM Taxonomy_Support__c WHERE Category__c =: queryCat and Type__c = 'Merchant Attribute'and Name__c NOT IN : alreadySelectedAttributes];
        map<string,list<string>> attributesMap = new map<string,list<string>>();
        set<string> Categories = new set<string>();
            
        for(Taxonomy_Support__c t :lAttributes)
          {
            Categories.add(t.Header__c);
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
              
        return HG;
      }
   
   @istest(SeeAllData=true) 
    static void LeadTaxonomy()
    {                          
         Profile p = [select id from profile where name='System Administrator'];
                      User u = new User(alias = 'standt', email='standarduser@groupon.com',
                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                      localesidkey='en_US', profileid = p.Id,
                      timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
                      insert u;
          //run as user
         System.RunAs(u)
         {
             lead l = new lead();
             l.lastname = 'zxcvbhi';
             l.company = 'qwerpouy';
             l.Category_v3__c = 'Food & Drink';
             l.Services_Offered__c = 'Bar - Ice';
             l.Merchant_Attributes__c = 'Afternoon Tea';
             l.phone = '9876543210';
             
             lead l2 = new lead();
             l2.lastname = 'lorem ipsum';
             l2.company = 'dolor';
             l2.phone = '4561237984';
             
             Test.starttest();
             insert l;
             insert l2;
             Test.stopTest();
             
             PageReference p1 = Page.MerchantTaxonomyLead;
             Test.setCurrentPageReference(p1);
            
             //add the current page id.
             string currentid = ApexPages.currentPage().getParameters().put('id', l.id);
            
             //getAttributeOptions(String queryCat, String currentIDattr)
             //Pass to the controller the Opportunity value
             ApexPages.StandardController ApptController = new ApexPages.StandardController(l); 
             LeadTaxonomy check = new  LeadTaxonomy(ApptController);          
             
             //call the subsequent methods.
             check.loadCategory();
             LeadTaxonomy.getServiceOptions('Food & Drink', l.id);
             LeadTaxonomy.getAttributeOptions('Shopping', l2.id);
             check.inlineSave();
             
             string currentid2 = ApexPages.currentPage().getParameters().put('id',l2.id);
             ApexPages.StandardController ApptController1 = new ApexPages.StandardController(l2); 
             LeadTaxonomy check2 = new  LeadTaxonomy(ApptController1);          
             
             //call the subsequent methods.
             check2.loadCategory();
             
          } 
     }               
    

}