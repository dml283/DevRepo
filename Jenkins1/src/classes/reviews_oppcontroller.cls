public class reviews_oppcontroller{

    public Id defaultAccountId;     
    public Id ctrlId;
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    public List<addresswrapper> redemptionaddresslist = new List<addresswrapper>();
    public list<deal_reviews__c> generalReviewsList{get;set;}
    public list<deal_reviews__c> locationReviewsList{get;set;}
    
    public reviews_oppcontroller(ApexPages.StandardController controller) 
        {
            ctrlId = controller.getID();
            defaultAccountId = [SELECT AccountId FROM Opportunity WHERE Id = :ctrlId LIMIT 1].AccountId;
        }
     
     
    //DELETE SELECTED GENERAL DEAL REVIEWS
    public Void deleteGeneralDealReviews()
        {
            try {Database.DeleteResult[] DR_Dels = Database.delete(GeneralDealReviews);} 
            catch (DMLException e) 
                {
                    ApexPages.addMessages(e);
                }
        }
        
    //ADD SELECTED GENERAL MERCHANT REVIEWS AS GENERAL DEAL REVIEWS
    public Void addGeneralDealReviews()
        {
            list<Deal_Reviews__c> SelRevsInsert = new list<Deal_Reviews__c>();
            list<Reviews__c> GenRevs = [select id,Account__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c, Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from Reviews__c where id != null AND Account__c != null AND Account__c =: defaultAccountId order by CreatedDate DESC];
            for (string s : GeneralMerchantReviews)
                {
                    for (Reviews__c r : GenRevs) {
                        if(s!='' && r.id == s)
                            { 
                                    
                            Deal_Reviews__c dr = new Deal_Reviews__c();
                                dr.opportunity__c = ctrlID;
                                dr.Merchant_Review__c = r.id;
                                dr.Type__c = r.Type__c;
                                dr.Rating__c = r.Rating__c;
                                dr.Source__c = r.Source__c;
                                dr.Max_Possible_Rating__c = r.Max_Possible_Rating__c;
                                dr.Review_Link__c = r.Review_Link__c;
                                dr.Number_of_Ratings__c = r.Number_of_Ratings__c;
                                dr.Unit__c = r.Unit__c;
                                dr.Description__c = r.Description__c;
                                dr.of_1_star_Reviews__c = r.of_1_star_Reviews__c;
                                dr.of_2_star_Reviews__c = r.of_2_star_Reviews__c;
                                dr.of_3_star_Reviews__c = r.of_3_star_Reviews__c;
                                dr.of_4_star_Reviews__c = r.of_4_star_Reviews__c;
                                dr.of_5_star_Reviews__c = r.of_5_star_Reviews__c;
                                dr.of_Complaints__c = r.of_Complaints__c ;
                                dr.BBB_Accredited__c = r.BBB_Accredited__c ; 
                                dr.BBB_Grade__c = r.BBB_Grade__c ;
                                dr.Quote__c = r.Quote__c ;
                                dr.Quote_Attribution__c = r.Quote_Attribution__c ;
                                dr.Mixed_Lede__c = r.Mixed_Lede__c;
                                dr.Facebook_of_Fans__c = r.Facebook_of_Fans__c;
                                dr.Twitter_of_Followers__c = r.Twitter_of_Followers__c;
                                dr.Highly_Suspect__c = r.Highly_Suspect__c;
                                dr.Other_Source__c = r.Other_Source__c;
                                                
                                if(dr.Merchant_Review__c != null)
                                    {
                                        SelRevsInsert.add(dr); 
                                    }
                                } 
                       }
                            
                }
                try {insert SelRevsInsert;} 
                catch (DMLException e) 
                    {
                        ApexPages.addMessages(e);
                    }
        }
        
    //CREATES LIST OF DEAL REVIEWS RELATED TO EACH REDEMPTION ADDRESS
    public list<deal_reviews__c> getOpptyList()
        {
            list<deal_reviews__c> olist = [select id,Created_Date__c,redemption_address__c,opportunity__c,Merchant_Review__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Full_Review__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from deal_reviews__c WHERE id != null AND opportunity__c != null AND opportunity__c = :ctrlId AND redemption_address__c = null order by CreatedDate DESC];
            return olist;
        }
        
    //CREATES A SET OF IDS OF REDEMPTION ADDRESS TO COMPARE TO MERCHANT ADDRESSES SO RECORDS DON'T SHOW IN BOTH BOXES
    public set<id> getAlreadySelected()
        {   
            set<id> setids = new set<id>();  
            list<deal_reviews__c> olist=getOpptyList();
            for(deal_reviews__c dr :olist)
            setids.add(dr.Merchant_Review__c);
            return setids;   
        }
        
    //Build General Selection Box 
    String[] GeneralMerchantReviews = new String[]{};
    public list<SelectOption> getGeneralRevs()
        {
            List<SelectOption> options = new List<SelectOption>();
            set<id> setids = getAlreadySelected();
            list<reviews__c > revList = [select id,Created_Date__c,merchant_address__c,account__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Full_Review__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c, Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from reviews__c where id != null AND account__c != null AND merchant_address__c = null AND account__c =: defaultAccountId AND id not in :setids order by CreatedDate DESC];
            for (reviews__c r: revList)
                {
                    options.add(new SelectOption(r.id, r.Full_Review__c));
                }
            if (options.size() == 0)
                {
                    options.add(new SelectOption('', '---NONE AVAILABLE---'));
                }
                return options;
        }
           
    public String[] getGeneralMerchantReviews()
        {
            return GeneralMerchantReviews;
        }
        
    public void setGeneralMerchantReviews(String[] GeneralMerchantReviews)
        {
            this.GeneralMerchantReviews = GeneralMerchantReviews;
        }
    
    //Build Redemption Address Selection Box        
    ID[] GeneralDealReviews = new ID[]{};
    public List<SelectOption> getGeneralDealRevs()
        {
            List<SelectOption> options = new List<SelectOption>();
            list<deal_reviews__c> dealrevList = [select id,Created_Date__c,opportunity__c,redemption_address__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Full_Review__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from deal_reviews__c where id != null AND opportunity__c != null AND redemption_address__c =null AND opportunity__c =: ctrlId order by CreatedDate DESC];
            for (deal_reviews__c dr: dealrevList)
                {
                    options.add(new SelectOption(dr.id, dr.Full_Review__c));
                }
            if (options.size() == 0)
                {
                    options.add(new SelectOption('', '---NONE AVAILABLE---'));
                }
            return options;
        }
    //Display General Location Reviews
    public string getDisplayGenReviews()
        {
            list<deal_reviews__c> generalReviewsList = new list<deal_reviews__c>();
            for(deal_reviews__c r : [select id,CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Merchant_Review__c,Merchant_Review__r.Name, Other_Source__c,
                                            BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Created_Date__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c
                                     from deal_reviews__c
                                     where id != null AND opportunity__c != null AND redemption_address__c = null AND opportunity__c = :ctrlId
                                     order by CreatedDate DESC])
                                         {
                                             generalReviewsList.add(r);        
                                         }
             system.debug('General List: ' + generalReviewsList);
             return JSON.serialize(generalReviewsList);
        }
        
      //Display Location Reviews
      public string getDisplayAddyReviews()
          {
              list<deal_reviews__c> locationReviewsList = new list<deal_reviews__c>();
              for(deal_reviews__c r : [select id, opportunity__c, CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Redemption_Address__c,Merchant_Review__c,Merchant_Review__r.Name,
                                              BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Created_Date__c,Mixed_Lede__c, Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c
                                       from deal_reviews__c
                                       where id != null AND opportunity__c =: ctrlId AND redemption_address__c != null
                                       order by CreatedDate DESC])
                                           {
                                               locationReviewsList.add(r);        
                                           }
                     return JSON.serialize(locationReviewsList);
         }
    
    public list<deal_reviews__c> getGeneralReviews()
        {
            list<deal_reviews__c> revs = [select id, opportunity__c, CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Highly_Suspect__c,Other_Source__c,
                                                 BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c
                                          from deal_reviews__c
                                          where id != null AND opportunity__c =: ctrlId AND redemption_address__c = null
                                          order by CreatedDate DESC];
                                      return  revs;
        }
        
    public String[] getGeneralDealReviews()
        {
            return GeneralDealReviews;
        }
        
    public void setGeneralDealReviews(String[] GeneralDealReviews)
        {
            this.GeneralDealReviews = GeneralDealReviews;
        }  
        
    //Redemption Addresses
    public List<addresswrapper> getredemptionaddydata()
        {
            system.debug('Current ID' + currentid);
            redemptionaddresslist.clear();
            for(Address__c ra: [select id,Merchant_Addresses__c,opportunity__c,name,street_line_1__c, Street_Line_2__c,City__c,State__c,Zip_Postal_Code__c,Phone_Number__c,Venue_Name__c,Merchant_Id__c,Terminal_ID__c,account__c, account__r.name
                                from Address__c 
                                where opportunity__c =: ctrlId
                                order by CreatedDate DESC])        
            redemptionaddresslist.add(new addresswrapper(ra,defaultAccountId));
            return redemptionaddresslist;
        }
        
    public class addresswrapper
        {
                
            public Address__c addy{get; set;}
            public id defaultAccountId {get;set;}
            public addresswrapper(Address__c a, Id default_id)
                {
                    addy = a;
                    defaultAccountId  = default_id;
                }
            
            //DELETE SELECTED REDEMPTION ADDRESSES
            public Void deleteDealReview()
                {
                    try 
                        {
                            Database.DeleteResult[] DR_Dels = Database.delete(DealReviews);
                        } 
                    catch (DMLException e) 
                        {
                            ApexPages.addMessages(e);
                        }
                }   
                
            //ADD SELECTED MERCHANT ADDRESSES AS REDEMPTION ADDRESSES
            public Void addDealReview()
                {

                    //system.debug('-------' + defaultAccountId);
                    list<Deal_Reviews__c> SelRevsInsert = new list<Deal_Reviews__c>();
                    list<Reviews__c> MerchRevs = [select id,Account__c,Created_Date__c,merchant_address__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,of_1_star_Reviews__c,
                                                  of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c, Facebook_of_Fans__c, 
                                                  Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from Reviews__c where Account__c =: defaultAccountId order by CreatedDate DESC];
                    system.debug('Merchant Reviews String: ' + MerchRevs);
                    for (string s : MerchantReviews)                
                        {
                            for(Reviews__c r : MerchRevs)
                                {
                                    if(s!='' && r.Id == s) {
                                            
                                    Deal_Reviews__c dr = new Deal_Reviews__c();
                                        dr.opportunity__c = addy.opportunity__c;
                                        dr.redemption_address__c = addy.id;
                                        dr.Merchant_Review__c = r.id;
                                        dr.Type__c = r.Type__c;
                                        dr.Rating__c = r.Rating__c;
                                        dr.Source__c = r.Source__c;
                                        dr.Max_Possible_Rating__c = r.Max_Possible_Rating__c;
                                        dr.Review_Link__c = r.Review_Link__c;
                                        dr.Number_of_Ratings__c = r.Number_of_Ratings__c;
                                        dr.Unit__c = r.Unit__c;
                                        dr.Description__c = r.Description__c;
                                        dr.of_1_star_Reviews__c = r.of_1_star_Reviews__c;
                                        dr.of_2_star_Reviews__c = r.of_2_star_Reviews__c;
                                        dr.of_3_star_Reviews__c = r.of_3_star_Reviews__c;
                                        dr.of_4_star_Reviews__c = r.of_4_star_Reviews__c;
                                        dr.of_5_star_Reviews__c = r.of_5_star_Reviews__c;
                                        dr.of_Complaints__c = r.of_Complaints__c ;
                                        dr.BBB_Accredited__c = r.BBB_Accredited__c ; 
                                        dr.BBB_Grade__c = r.BBB_Grade__c ;
                                        dr.Quote__c = r.Quote__c ;
                                        dr.Quote_Attribution__c = r.Quote_Attribution__c ;
                                        dr.Mixed_Lede__c = r.Mixed_Lede__c;
                                        dr.Facebook_of_Fans__c = r.Facebook_of_Fans__c;
                                        dr.Twitter_of_Followers__c = r.Twitter_of_Followers__c;
                                        dr.Highly_Suspect__c = r.Highly_Suspect__c;
                                        dr.Other_Source__c = r.Other_Source__c;
                                                        
                                        if(dr.Merchant_Review__c != null)
                                            {
                                                SelRevsInsert.add(dr); 
                                            }
                                        }
                                }
                                    
                        }
                        try 
                            {
                                insert SelRevsInsert;
                            } 
                        catch (DMLException e) 
                            {
                                ApexPages.addMessages(e);
                            }
                } 
                
                
                //CREATES LIST OF DEAL REVIEWS RELATED TO EACH REDEMPTION ADDRESS
                public list<deal_reviews__c> getOpptyList()
                    {
                        list<deal_reviews__c> olist = [select id,Created_Date__c,redemption_address__c,Merchant_Review__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Full_Review__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from deal_reviews__c WHERE redemption_address__c = :addy.id order by CreatedDate DESC];
                        return olist;
                    }
            
                //CREATES A SET OF IDS OF REDEMPTION ADDRESS TO COMPARE TO MERCHANT ADDRESSES SO RECORDS DON'T SHOW IN BOTH BOXES
                public set<id> getAlreadySelected()
                    {   
                        set<id> setids = new set<id>();  
                        list<deal_reviews__c> olist=getOpptyList();
                        for(deal_reviews__c dr :olist)
                            setids.add(dr.Merchant_Review__c);
                            return setids;   
                    }         
                
                //Build Merchant Address Selection Box 
                String[] MerchantReviews = new String[]{};
                public list<SelectOption> getMerchRevs()
                    {
                        List<SelectOption> options = new List<SelectOption>();
                        set<id> setids = getAlreadySelected();
                        list<reviews__c > revList = [select id, Account__c, Created_Date__c,merchant_address__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Full_Review__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from reviews__c where id != null AND Account__c =: defaultAccountId AND merchant_address__c =: addy.Merchant_Addresses__c AND id not in :setids order by CreatedDate DESC];
                        for (reviews__c r: revList)
                            {
                                options.add(new SelectOption(r.id, r.Full_Review__c));
                            }
                        if (options.size() == 0)
                            {
                                options.add(new SelectOption('', '---NONE AVAILABLE---'));
                            }
                            return options;
                    }
                    
                public String[] getMerchantReviews()
                    {
                        return MerchantReviews;
                    }
                    
                public void setMerchantReviews(String[] MerchantReviews )
                    {
                        this.MerchantReviews = MerchantReviews ;
                    }
                    
                //Build Redemption Address Selection Box        
                ID[] DealReviews = new ID[]{};
                        
                public List<SelectOption> getDealRevs()
                    {
                        List<SelectOption> options = new List<SelectOption>();
                        list<deal_reviews__c> dealrevList = [select id,Created_Date__c,redemption_address__c,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Full_Review__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,BBB_Accredited__c, BBB_Grade__c,Quote__c,Quote_Attribution__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c, Highly_Suspect__c, Other_Source__c from deal_reviews__c where redemption_address__c != null AND redemption_address__c =: addy.id order by CreatedDate DESC];
                        for (deal_reviews__c dr: dealrevList)
                            {
                                options.add(new SelectOption(dr.id, dr.Full_Review__c));
                            }
                        if (options.size() == 0)
                            {
                                options.add(new SelectOption('', '---NONE AVAILABLE---'));
                            }
                            return options;
                    }
                    
                //Display General Location Reviews
                public list<deal_reviews__c> getLocationReviews()
                    {
                        list<deal_reviews__c> revs = [select id,Created_Date__c,CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c, Highly_Suspect__c,Other_Source__c,
                                                             BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Mixed_Lede__c,Facebook_of_Fans__c, Twitter_of_Followers__c
                                                      from deal_reviews__c
                                                      where redemption_address__c =: addy.Id
                                                      order by CreatedDate DESC];
                        return  revs;
                    }
        
                
                public String[] getDealReviews ()
                    {
                        return DealReviews;
                    }
                        
                public void setDealReviews(String[] DealReviews)
                    {
                        this.DealReviews = DealReviews;
                    }      
        
        }
        /*
        public class dealreviewwrapper 
            {
                public deal_reviews__c  drs{get;set;}
                public dealreviewwrapper (deal_reviews__c  dealrevs)
                    {
                        this.drs = dealrevs;
                    }
            } 
            */
    @istest
    static void reviews_oppcontroller()
        {             
        Test.starttest();
        Profile p = [select id from profile where name='System Administrator'];
                     User u = new User(alias = 'standt1', email='standarduser@groupon.com',
                     emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                     localesidkey='en_US', profileid = p.Id,
                     timezonesidkey='America/Los_Angeles', username='standarduser1@groupon.com');
                     insert u;
         //run as user
         System.RunAs(u)
             {             
             
             account a = new account();
             a.name = 'Test Reviews Acct';
             insert a;
             
             opportunity o = new opportunity();
             o.accountId = a.id;
             o.name = 'Test Reviews Opportunity';
             o.StageName = 'Prospecting';
             o.CloseDate = date.parse('12/31/2012');
             insert o;
             
             merchant_addresses__c m = new merchant_addresses__c();     
             m.street_line_1__c = '600 W. Chicago';
             m.Street_Line_2__c = '';
             m.City__c = '';
             m.State_Province__c = '';
             m.Zip_Postal_Code__c = '';
             m.Phone_Number__c = '';
             m.account__c = a.id;
             insert m;
             
             address__c addy = new address__c();     
             addy.street_line_1__c = '600 W. Chicago';
             addy.Street_Line_2__c = '';
             addy.City__c = '';
             addy.State__c = '';
             addy.Zip_Postal_Code__c = '';
             addy.Phone_Number__c = '';
             addy.opportunity__c= o.id;
             insert addy;
             
             reviews__c r = new reviews__c();             
             r.account__c = a.id;                   
             r.Merchant_Address__c = m.id;
             r.Description__c = 'Test Description';
             r.Max_Possible_Rating__c = 10;
             r.Number_of_Ratings__c = 100;                                      
             r.Rating__c = 9;
             r.Source__c = 'Google';
             r.Type__c = 'Rating';
             r.Unit__c = 'Stars';
             r.Review_Link__c = 'www.google.com';
             r.of_1_star_Reviews__c = 1;
             r.of_2_star_Reviews__c = 2;
             r.of_3_star_Reviews__c = 3;
             r.of_4_star_Reviews__c = 4;
             r.of_5_star_Reviews__c = 5;
             r.of_Complaints__c = 0;
             r.BBB_Accredited__c = 'Yes';
             r.BBB_Grade__c = 'A';
             r.Quote__c = 'Quote';
             r.Quote_Attribution__c = 'Quote Attribution';
             r.Mixed_Lede__c = 'Test';
             insert r; 
             
             reviews__c r2 = new reviews__c();             
             r2.account__c = a.id;                   
             r2.Description__c = 'Test Description';
             r2.Max_Possible_Rating__c = 10;
             r2.Number_of_Ratings__c = 100;                                      
             r2.Rating__c = 9;
             r2.Source__c = 'Google';
             r2.Type__c = 'Rating';
             r2.Unit__c = 'Stars';
             r2.Review_Link__c = 'www.google.com';
             r2.of_1_star_Reviews__c = 1;
             r2.of_2_star_Reviews__c = 2;
             r2.of_3_star_Reviews__c = 3;
             r2.of_4_star_Reviews__c = 4;
             r2.of_5_star_Reviews__c = 5;
             r2.of_Complaints__c = 0;
             r2.BBB_Accredited__c = 'Yes';
             r2.BBB_Grade__c = 'A';
             r2.Quote__c = 'Quote';
             r2.Quote_Attribution__c = 'Quote Attribution';
             r2.Mixed_Lede__c = 'Test1';         
             insert r2;
             
             deal_reviews__c d = new deal_reviews__c();             
             d.opportunity__c= o.id;
             d.merchant_review__c = r.id;
             d.redemption_address__c = addy.id;
             d.Description__c = 'Test Description';
             d.Max_Possible_Rating__c = 10;
             d.Number_of_Ratings__c = 100;                                      
             d.Rating__c = 9;
             d.Source__c = 'Google';
             d.Type__c = 'Rating';
             d.Unit__c = 'Stars';
             d.Review_Link__c = 'www.google.com';
             d.of_1_star_Reviews__c = 1;
             d.of_2_star_Reviews__c = 2;
             d.of_3_star_Reviews__c = 3;
             d.of_4_star_Reviews__c = 4;
             d.of_5_star_Reviews__c = 5;
             d.of_Complaints__c = 0;
             d.BBB_Accredited__c = 'Yes';
             d.BBB_Grade__c = 'A';
             d.Quote__c = 'Quote';
             d.Quote_Attribution__c = 'Quote Attribution';
             d.Mixed_Lede__c = 'Test';     
             insert d;
             
             deal_reviews__c d2 = new deal_reviews__c();             
             d2.opportunity__c= o.id;
             d2.merchant_review__c = r.id;
             d2.Description__c = 'Test Description';
             d2.Max_Possible_Rating__c = 10;
             d2.Number_of_Ratings__c = 100;                                      
             d2.Rating__c = 9;
             d2.Source__c = 'Google';
             d2.Type__c = 'Rating';
             d2.Unit__c = 'Stars';
             d2.Review_Link__c = 'www.google.com';
             d2.of_1_star_Reviews__c = 1;
             d2.of_2_star_Reviews__c = 2;
             d2.of_3_star_Reviews__c = 3;
             d2.of_4_star_Reviews__c = 4;
             d2.of_5_star_Reviews__c = 5;
             d2.of_Complaints__c = 0;
             d2.BBB_Accredited__c = 'Yes';
             d2.BBB_Grade__c = 'A';
             d2.Quote__c = 'Quote';
             d2.Quote_Attribution__c = 'Quote Attribution';
             d2.Mixed_Lede__c = 'Test1';       
             insert d2;

        

        Test.stopTest();
        
        //Test the ReviewsAcct page
        PageReference p1 = Page.ReviewsOpp;
        Test.setCurrentPageReference(p1);
            
        //Add the current page Id
        string currentid = ApexPages.currentPage().getParameters().put('id', o.id);          
        
        //Pass to the controller the Account value
        ApexPages.StandardController ApptController = new ApexPages.StandardController(o); 
        reviews_oppcontroller check = new reviews_oppcontroller(ApptController);
        
        //Create the instance for the class and fill the merchantaddresslist from the wrapper class.
        check.redemptionaddresslist.add(new reviews_oppcontroller.addresswrapper(addy,a.Id));
        System.Assert(check.redemptionaddresslist!= null);
        
        for(reviews_oppcontroller.addresswrapper checksel : check.redemptionaddresslist)
            {
                checksel.MerchantReviews = new String[]{r.id};
                checksel.DealReviews = new String[]{d.id};
                checksel.getMerchantReviews();
                checksel.setMerchantReviews(checksel.MerchantReviews);
                checksel.getDealReviews();
                checksel.getOpptyList();
                checksel.getAlreadySelected();
                checksel.getMerchRevs();
                checksel.getDealRevs();
                checksel.deleteDealReview();
                checksel.addDealReview();
                checksel.getLocationReviews();
                
            }
        
        String[] GeneralMerchantReviews = new string[]{r2.Id};
        String[] GeneralDealReviews = new string[]{addy.Id};
        check.getGeneralMerchantReviews();
        check.setGeneralMerchantReviews(GeneralMerchantReviews);
        check.getGeneralDealReviews();
        check.setGeneralDealReviews(GeneralMerchantReviews);
        check.addGeneralDealReviews();
        check.deleteGeneralDealReviews();
        check.getOpptyList();
        check.getAlreadySelected();
        check.getGeneralRevs();
        check.getGeneralDealRevs();
        check.getredemptionaddydata();
        check.getDisplayGenReviews();
        check.getDisplayAddyReviews();
        check.getGeneralReviews();
          } 
     } 
     
                   
}