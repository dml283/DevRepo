public class reviews_controller{

    public boolean displayeditmode{get;set;}
    public string  strSelectedRec{get;set;}
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    public reviews__c reviewvalue = new reviews__c();
    public List<addresswrapper> merchantaddresslist = new List<addresswrapper>();
    public List<merchant_addresses__c> selectedaddress = new List<merchant_addresses__c>();
    public boolean Generalreview_cxbox{get;set;}
    public string errorMessage{get;set;}
    public list<deal_reviews__c> generalReviewsList{get;set;}
    public list<deal_reviews__c> locationReviewsList{get;set;}
    public reviews_controller(ApexPages.StandardController controller) {

        }

    public reviews__c getreviewvalue()
        {
            return reviewvalue;
        }
    
    public PageReference savenew()
        {
            errormessage='';
            
                   reviews__c r;
                                      
                   if (Generalreview_cxbox == false && selectedaddress.size() == 0) {
                       errorMessage='Select General or a specific location to add a review';
                   } else if (reviewvalue.Source__c == null || (reviewvalue.Source__c == 'Other' && reviewvalue.Other_Source__c == null)) {
                       errorMessage='You must select a Source to add a review';
                   }
                   
                   if(Generalreview_cxbox == true && reviewvalue.Source__c != null)
                       {
                           r = new reviews__c();
                           r.account__c = CurrentId;                   
                           r.Description__c = reviewvalue.Description__c;
                           r.Max_Possible_Rating__c = reviewvalue.Max_Possible_Rating__c;
                           r.Number_of_Ratings__c = reviewvalue.Number_of_Ratings__c;                                      
                           r.Rating__c = reviewvalue.Rating__c;
                           r.Source__c = reviewvalue.Source__c;
                           r.Type__c = reviewvalue.Type__c;
                           r.Unit__c = reviewvalue.Unit__c;
                           r.Review_Link__c = reviewvalue.Review_Link__c;
                           r.of_1_star_Reviews__c = reviewvalue.of_1_star_Reviews__c;
                           r.of_2_star_Reviews__c = reviewvalue.of_2_star_Reviews__c;
                           r.of_3_star_Reviews__c = reviewvalue.of_3_star_Reviews__c;
                           r.of_4_star_Reviews__c = reviewvalue.of_4_star_Reviews__c;
                           r.of_5_star_Reviews__c = reviewvalue.of_5_star_Reviews__c;
                           r.of_Complaints__c = reviewvalue.of_Complaints__c;
                           r.BBB_Accredited__c = reviewvalue.BBB_Accredited__c;
                           r.BBB_Grade__c = reviewvalue.BBB_Grade__c;
                           r.Quote__c = reviewvalue.Quote__c;
                           r.Quote_Attribution__c = reviewvalue.Quote_Attribution__c;
                           r.Mixed_Lede__c = reviewvalue.Mixed_Lede__c;
                           r.Facebook_of_Fans__c = reviewvalue.Facebook_of_Fans__c;
                           r.Twitter_of_Followers__c = reviewvalue.Twitter_of_Followers__c;
                           r.Highly_Suspect__c = reviewvalue.Highly_Suspect__c;
                           r.Press_Source__c = reviewvalue.Press_Source__c;
                           r.Other_Source__c = reviewvalue.Other_Source__c;
                           
                           if (Generalreview_cxbox == true && selectedaddress.size() > 0)
                               {
                                   errorMessage='A General Review cannot also be added to a specific location';
                               }
                           else if(r != null && r.Source__c != null)
                               {
                                   try
                                   {
                                       Database.SaveResult SR = database.insert(r);
                                       if(SR.ISsuccess())
                                           {
                                               system.debug('CREATED : SAVE' + r);
                                           }
                                   }
                                   catch(exception ex)
                                   {
                                       Apexpages.Addmessages(ex);
                                   }
                               }
                       } 
                   if(Generalreview_cxbox == false)
                       {
                           for(integer i=0;i<selectedaddress.size();i++)
                               {
                                   r = new reviews__c();
                                   r.account__c = CurrentId;                   
                                   r.Merchant_Address__c = selectedaddress[i].id;
                                   r.Description__c = reviewvalue.Description__c;
                                   r.Max_Possible_Rating__c = reviewvalue.Max_Possible_Rating__c;
                                   r.Number_of_Ratings__c = reviewvalue.Number_of_Ratings__c;                                      
                                   r.Rating__c = reviewvalue.Rating__c;
                                   r.Source__c = reviewvalue.Source__c;
                                   r.Type__c = reviewvalue.Type__c;
                                   r.Unit__c = reviewvalue.Unit__c;
                                   r.Review_Link__c = reviewvalue.Review_Link__c;
                                   r.of_1_star_Reviews__c = reviewvalue.of_1_star_Reviews__c;
                                   r.of_2_star_Reviews__c = reviewvalue.of_2_star_Reviews__c;
                                   r.of_3_star_Reviews__c = reviewvalue.of_3_star_Reviews__c;
                                   r.of_4_star_Reviews__c = reviewvalue.of_4_star_Reviews__c;
                                   r.of_5_star_Reviews__c = reviewvalue.of_5_star_Reviews__c;
                                   r.of_Complaints__c = reviewvalue.of_Complaints__c;
                                   r.BBB_Accredited__c = reviewvalue.BBB_Accredited__c;
                                   r.BBB_Grade__c = reviewvalue.BBB_Grade__c;
                                   r.Quote__c = reviewvalue.Quote__c;
                                   r.Quote_Attribution__c = reviewvalue.Quote_Attribution__c;
                                   r.Mixed_Lede__c = reviewvalue.Mixed_Lede__c;
                                   r.Facebook_of_Fans__c = reviewvalue.Facebook_of_Fans__c;
                                   r.Twitter_of_Followers__c = reviewvalue.Twitter_of_Followers__c;
                                   r.Highly_Suspect__c = reviewvalue.Highly_Suspect__c;
                                   r.Press_Source__c = reviewvalue.Press_Source__c;
                                   r.Other_Source__c = reviewvalue.Other_Source__c;
                                            
                                   system.debug('New Review' + r);
                           
                                   if(Generalreview_cxbox == false && selectedaddress.size() == 0)
                                       {
                                           errorMessage='You must select a location to add an address';
                                       }
                                   else if(r != null)
                                       {
                                           try
                                           {
                                               Database.SaveResult SR = database.insert(r);
                                               if(SR.ISsuccess())
                                                   {
                                                       system.debug('CREATED : SAVE' + r);
                                                   }
                                           }
                                           catch(exception ex)
                                           {
                                               Apexpages.Addmessages(ex);
                                           }
                                       }
                                }
                        }  
             return null;
        }
        
    //Display General Location Reviews
    public string getDisplayGenReviews()
        {
            list<reviews__c> generalReviewsList = new list<reviews__c>();
            for(reviews__c r : [select id, Account__c, CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Merchant_Address__c,Highly_Suspect__c,Press_Source__c,Other_Source__c,
                                            BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Created_Date__c, Mixed_Lede__c, Facebook_of_Fans__c, Twitter_of_Followers__c
                                     from reviews__c
                                     where Merchant_Address__c = null AND Account__c =: currentId
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
              list<reviews__c> locationReviewsList = new list<reviews__c>();
              for(reviews__c r : [select id,Account__c,CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Merchant_Address__c,Highly_Suspect__c,Press_Source__c,Other_Source__c,
                                  BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Created_Date__c, Mixed_Lede__c, Facebook_of_Fans__c, Twitter_of_Followers__c
                                  from reviews__c
                                  where Merchant_Address__c != null AND Account__c =: currentId
                                  order by CreatedDate DESC])
                                      {
                                          locationReviewsList.add(r);    
                                      }
                    
              return JSON.serialize(locationReviewsList);
          }
  
    //Method   : getmerchaddydata()
    //Called By: VF page:  when the page loads the List of reviews are displayed by calling this method.
    //Purpose  : Queries the addresses associated with the account/locations and displays to the user.
    public List<addresswrapper> getmerchaddydata()
        {
            system.debug('Current ID' + currentid);
            merchantaddresslist.clear();
            for(merchant_addresses__c mercha : [select id, Account__c,name,street_line_1__c, Street_Line_2__c,City__c,State_Province__c,Zip_Postal_Code__c,Phone_Number__c, account__r.name, Reviews__c, Venue_Name__c
                                                from merchant_addresses__c 
                                                where account__c =: currentId])        
            merchantaddresslist.add(new addresswrapper(mercha));
            return merchantaddresslist;
        }
    
    //Method   : getSelected()
    //Called By: VF page:  when the user clicks the checkbox next to the list of available addresses the selected records are store in a list to 
    //           be rendered in another pageblocktable.
    //Purpose  : Checks if the user selected any record from the List of available addresses and if the user selected aleast one record
    //           the records are added to the Selectedmultideal list.
    public PageReference getSelected()
        {
     
            selectedaddress.clear();
            for(addresswrapper merchawrapper: merchantaddresslist)
            if(merchawrapper.selected == true)
                {
                    selectedaddress.add(merchawrapper.addy);
                }

            return null;
        }

    //Display General Location Reviews
    public list<reviews__c> getGeneralRevs()
        {
        list<reviews__c> revs = [select id, Account__c,Created_Date__c,CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Highly_Suspect__c,Press_Source__c,Other_Source__c,
                                        BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c, Mixed_Lede__c, Facebook_of_Fans__c, Twitter_of_Followers__c
                                 from reviews__c
                                 where  merchant_address__c = null AND Account__c =: CurrentId
                                 order by CreatedDate DESC];
        return  revs;
        }
  
    //Class    : addresswrapper()
    //Called By: Checkbox_class .
    //Purpose  : This wrapper class contains the user inputs. The wrapper class is a temproary holder where the basic data types
    //           when not available, we can create a holder and get the user selected values.
    public class addresswrapper
    {
        public Merchant_Addresses__c addy{get; set;}
        public Boolean selected {get; set;}
        public reviews__c revs{get;set;}
        //public list<wrapperforreviews> locationReviews = new list<wrapperforreviews>();
        public List<reviews__c> selectedreviews = new List<reviews__c>();
        public addresswrapper(Merchant_Addresses__c a)
        
        {
            addy = a;
            selected = false;
        }
        
        public list<reviews__c> getrevmeth()
            {
            list<reviews__c> revs = [select id, Account__c, Created_Date__c,CreatedDate,Name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Highly_Suspect__c,Press_Source__c,Other_Source__c,
                                            BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c, Mixed_Lede__c, Facebook_of_Fans__c, Twitter_of_Followers__c
                                     from reviews__c
                                     where  merchant_address__c =: addy.Id
                                     order by CreatedDate DESC];
                return  revs;
            }
        
    }
    
    @istest
    static void reviews_controller()
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
             
             merchant_addresses__c m = new merchant_addresses__c();     
             m.street_line_1__c = '600 W. Chicago';
             m.Street_Line_2__c = '';
             m.City__c = '';
             m.State_Province__c = '';
             m.Zip_Postal_Code__c = '';
             m.Phone_Number__c = '';
             m.account__c = a.id;
             insert m;
             
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
             r.Mixed_Lede__c  = 'Test';
             r.Facebook_of_Fans__c = 500;
             r.Twitter_of_Followers__c = 2000;
             r.Press_Source__c = 'PRESS SOURCE1';
             r.Other_Source__c = 'Other';
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
             r2.Facebook_of_Fans__c = 700;
             r2.Twitter_of_Followers__c = 4000;
             r2.Press_Source__c = 'PRESS SOURCE2';
             r2.Other_Source__c = 'Other 2';
             insert r2;

        Test.stopTest();
        
        //Test the ReviewsAcct page
        PageReference p1 = Page.ReviewsAcct;
        Test.setCurrentPageReference(p1);
            
        //Add the current page Id
        string currentid = ApexPages.currentPage().getParameters().put('id', a.id);          
        
        //Pass to the controller the Account value
        ApexPages.StandardController ApptController = new ApexPages.StandardController(a); 
        reviews_controller check = new reviews_controller(ApptController);
        
        //Create the instance for the class and fill the merchantaddresslist from the wrapper class.
        check.merchantaddresslist.add(new reviews_controller.addresswrapper(m));
        System.Assert(check.merchantaddresslist!= null);
        
        check.getSelected();
        //Set one of the wrapper values to be selected.
        for(reviews_controller.addresswrapper checksel : check.merchantaddresslist)
            {
                checksel.revs=r;
                checksel.selected = true;  
                system.assertnotEquals(checksel.addy, null);
                check.selectedaddress.add(checksel.addy);
                checksel.getrevmeth();
            }
        
        check.errorMessage = 'You must select a location to add an address';
        check.getGeneralRevs();
        check.Generalreview_cxbox = true;
        check.savenew();
        check.Generalreview_cxbox = false;
        check.savenew();
        check.getreviewvalue();
        check.getmerchaddydata();
        check.getGeneralRevs();
        check.getDisplayGenReviews();
        check.getDisplayAddyReviews();
                      
          } 
     }               
}