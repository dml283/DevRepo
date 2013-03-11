public class NOW {
        
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    list<lead>NowLeads;
    list<GrouponNow__c>NOWDeal;
    list<string> ValidZips = new list <string>();
    list<lead> FullNowLead;
    double Contacted;
    double Uncontacted;
    double lost;
    double contactedYesterday;
    double contactedLast5;
    list<string> RedemptionLocations;
    
        
    public list <Zip_Code__c> ValidZipCodes =   [Select name 
                                                 from Zip_Code__c
                                                 WHERE Valid_for_Now__c = true AND Division__r.name ='DC' ];
                                                 
   
        public list<lead> getNOWLeads()
                {
                                        for(Zip_Code__c zips : ValidZipCodes)
                                                                {
                                                                        ValidZips.add(zips.name);
                                                                }
                        if(NOWLeads==null)
                                        {       
                                                 NOWLeads= [SELECT  id, company, Email, phone, category__c, subcategory__c, NOW_Status__c, division__c, Quality__c, NOW_Deal_Vetter__r.name, Last_Activity_Date__c, PostalCode
                                                           FROM lead
                                                           WHERE isconverted = false AND NOW_Deal_Vetter__r.name =null AND division__c ='DC' AND NOW_Status__c != 'Rejected' AND PostalCode IN :ValidZips AND (not company like '%DUPLICATE%')
                                                           LIMIT 50];
                                        }
                         // FullNowLead=NOWLeads;              
                    return NOWLeads;
                }                    
        
         
        public double getContacted()
                {       
                          double counterScript=0;
                          double countContacted=0;
                          for(Zip_Code__c zips : ValidZipCodes)
                             {
                               ValidZips.add(zips.name);
                             }
                        if(FullNowLead==null)
                                        {       
                                          FullNowLead= [SELECT  id, company, Email, phone, category__c, subcategory__c, NOW_Status__c, division__c, Quality__c, NOW_Deal_Vetter__r.name, Last_Activity_Date__c, PostalCode
                                          FROM lead
                                          WHERE isconverted = false  AND division__c ='DC' AND NOW_Status__c != 'Rejected' AND PostalCode IN :ValidZips AND (not company like '%DUPLICATE%')
                                          ];
                                        }
                        for (lead full : FullNowLead)
                                {
                                        if (full.NOW_Status__c=='Contacted')
                                                {
                                                        countContacted++;
                                                }
                                }
                        return countContacted;  
                }
                
             public double getUncontacted()
                {       
                          double countUncontacted=0;
                          for(Zip_Code__c zips : ValidZipCodes)
                             {
                               ValidZips.add(zips.name);
                             }
                        if(FullNowLead==null)
                                        {       
                                          FullNowLead= [SELECT  id, company, Email, phone, category__c, subcategory__c, NOW_Status__c, division__c, Quality__c, NOW_Deal_Vetter__r.name, Last_Activity_Date__c, PostalCode
                                          FROM lead
                                          WHERE isconverted = false  AND division__c ='DC' AND NOW_Status__c != 'Rejected' AND PostalCode IN :ValidZips AND (not company like '%DUPLICATE%')
                                          ];
                                        }
                        for (lead full : FullNowLead)
                                {
                                        if (full.NOW_Status__c=='Uncontacted')
                                                {
                                                        countUncontacted++;
                                                }
                                }
                        return countUncontacted;  
                }
               public double getUnassigned()
                {       
                          double countUnassigned=0;
                          for(Zip_Code__c zips : ValidZipCodes)
                             {
                               ValidZips.add(zips.name);
                             }
                        if(FullNowLead==null)
                                        {       
                                          FullNowLead= [SELECT  id, company, Email, phone, category__c, subcategory__c, NOW_Status__c, division__c, Quality__c, NOW_Deal_Vetter__r.name, Last_Activity_Date__c, PostalCode
                                          FROM lead
                                          WHERE isconverted = false  AND division__c ='DC' AND NOW_Status__c != 'Rejected' AND PostalCode IN :ValidZips AND (not company like '%DUPLICATE%')
                                          ];
                                        }
                        for (lead full : FullNowLead)
                                {
                                        if (full.NOW_Deal_Vetter__r==null)
                                                {
                                                        countUnassigned++;
                                                }
                                }
                        return countUnassigned;  
                }              
             /*   
        public list<GrouponNow__c> getNOWDeal()
                {
                        if(NOWDeal == null)
                                {
                                  NOWDeal = [SELECT  id, Account_Name__c, Close_Date__c, Stage__c, Subcategory__c, Deal_Owner__r.name, Category__c
                                                  FROM GrouponNow__c
                                             ];
                                }
                        return NOWDeal; 
                }                
                   
        public list<NOW_Schedule__c> NOWSchd = 
                                  [SELECT  id, Groupon_Now__c 
                  FROM NOW_Schedule__c
                  ];
                  
        public list<Now_Redemption_Address__c> NOWAddress = 
                                  [SELECT  id, Groupon_Now__r.id, Address_Line_1__c, Address_Line_2__c, City__c, State__c, Zip_Code__c
                  FROM Now_Redemption_Address__c
                  ];
                  
    public list<lead> getAllNowLeads()
                {
                        list<lead> ListOfNowLeads = new list<lead>();
                                                for (Lead n : NOWLeads)
                                                        {
                                                             ListOfNowLeads.add(n);
                                                        }
                                        return ListOfNowLeads;
                }
   public list<lead> getAllNowDeals()
                {
                        list<GrouponNow__c> ListOfNowDeals = new list<GrouponNow__c>();
                                                for (GrouponNow__c g : NOWDeal)
                                                        {
                                                             ListOfNowDeals.add(g);
                                                        }
                                        return ListOfNowDeals;
                }            
             */     
    public void doSortLeads(){
        String order = 'asc';
        
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
       
        //To sort the table we simply need to use this one line, nice!
        superSort.sortList(NOWLeads,sortField,order);
    }
    public void doSortNow(){
        String order = 'asc';
        
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
       
        //To sort the table we simply need to use this one line, nice!
        superSort.sortList(NOWDeal,sortField,order);
    }
                  
        
private testMethod static void testNOWfunctions()
        {
                list <lead> insertLeads = new list <lead>();
                list <lead> testNowLeads = new list <lead>();
                Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
                        insert u;
        
                //run as user
                System.RunAs(u)
                    {   
                        //Build the Division
                                Division__c divs = new Division__c(Name ='test',State__c ='IL');
                                insert divs;
                        
                        //Build the account
                                Account a = new Account(name='a1', BillingCountry='MyCountry', eligibility__c='Eligible', division__c = divs.ID, Tax_Identification_Number__c ='12345');
                                insert a;
                                
                                Zip_Code__c z = new Zip_Code__c (name='60656', Valid_for_Now__c = true);
                                Zip_Code__c z1 = new Zip_Code__c (name='60651', Valid_for_Now__c = true);
                                insert z;
  
                                                        
                        //build the lead(s)
                            lead l1 = new lead();
                                l1.company = 'test company';
                                l1.category__c = 'Food & Drink';
                                l1.subcategory__c = 'test company';
                                l1.division__c ='Chicago';
                                l1.lastname='LastName';
                                l1.Quality__c='Gold';
                                l1.PostalCode='60656';
                                l1.NOW_Deal_Vetter__c=u.id;
                                l1.NOW_Status__c='Contacted';
                            insertleads.add(l1);
                            
                            lead l2 = new lead();
                                l2.company = 'test company';
                                l2.category__c = 'Health & Beauty';
                                l2.subcategory__c = 'test company';
                                l2.division__c ='Chicago';
                                l2.lastname='LastName';
                                l2.Quality__c='Gold';
                                l2.PostalCode='60651';
                             insertleads.add(l2);
                            lead l3 = new lead();
                                l3.company = 'test company';
                                l3.category__c = 'Retail';
                                l3.subcategory__c = 'test company';
                                l3.division__c ='Denver';
                                l3.lastname='LastName';
                                l3.Quality__c='Gold';
                             insertleads.add(l3);    
                                 
                            insert insertleads;
                            double tester;
                            NOW constructor = new NOW();
                                testNowLeads = constructor.getNOWLeads();
                                tester = constructor.getContacted();
                                tester = constructor.getUncontacted();
                                tester = constructor.getUnassigned();
                    }
        }

}