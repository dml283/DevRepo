public class reviews_leadcontroller{

    public boolean displayeditmode{get;set;}
    public string  strSelectedRec{get;set;}
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    public reviews__c reviewvalue = new reviews__c();
    public boolean Generalreview_cxbox{get;set;}
    public boolean Locationreview_cxbox{get;set;}
    public string errorMessage{get;set;}
    public list<deal_reviews__c> generalReviewsList{get;set;}
    public list<deal_reviews__c> locationReviewsList{get;set;}
    public reviews_leadcontroller(ApexPages.StandardController controller) {

        }

    public reviews__c getreviewvalue()
        {
            return reviewvalue;
        }
    
    public PageReference savenew()
        {
            errormessage='';
            
                   reviews__c r;
                   
                   if (Generalreview_cxbox == false && Locationreview_cxbox == false) {
                       errorMessage='Select General or a specific location to add a review';
                   } else if (reviewvalue.Source__c == null || (reviewvalue.Source__c == 'Other' && reviewvalue.Other_Source__c == null)) {
                       errorMessage='You must select a Source to add a review';
                   }
                   
                   if(Generalreview_cxbox == true)
                       {
                           r = new reviews__c();
                           r.Lead__c = CurrentId;                   
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
                           r.Press_Source__c = reviewvalue.Press_Source__c;
                           r.Highly_Suspect__c = reviewvalue.Highly_Suspect__c;
                           
                           if (Generalreview_cxbox == true && Locationreview_cxbox == true)
                               {
                                   errorMessage='A General Review cannot also be added to a specific location';
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
                   if(Locationreview_cxbox == true)
                       {
                           r = new reviews__c();
                           r.Lead__c = CurrentId;         
                           r.Location_Lead_Review__c = True;          
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
                           r.Press_Source__c = reviewvalue.Press_Source__c;
                           r.Highly_Suspect__c = reviewvalue.Highly_Suspect__c;
                                            
                           system.debug('New Review' + r);
                           
                            if (Generalreview_cxbox == true && Locationreview_cxbox == true)
                               {
                                   errorMessage='A General Review cannot also be added to a specific location';
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
             return null;
        }
        
    //Display General Location Reviews
    public string getDisplayGenReviews()
        {
            list<reviews__c> generalReviewsList = new list<reviews__c>();
            for(reviews__c r : [select id, Lead__c, CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Merchant_Address__c,
                                            BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Created_Date__c, Mixed_Lede__c, 
                                            Facebook_of_Fans__c, Twitter_of_Followers__c, Location_Lead_Review__c, Press_Source__c, Highly_Suspect__c
                                     from reviews__c
                                     where Location_Lead_Review__c != true AND Lead__c =: currentId
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
              for(reviews__c r : [select id,Lead__c,CreatedDate,name,Type__c,Rating__c,Source__c,Max_Possible_Rating__c,Review_Link__c,Number_of_Ratings__c,Unit__c,Description__c,Quote__c,Quote_Attribution__c,Merchant_Address__c,
                                  BBB_Accredited__c,BBB_Grade__c,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,Created_Date__c, Mixed_Lede__c, 
                                  Facebook_of_Fans__c, Twitter_of_Followers__c, Location_Lead_Review__c, Press_Source__c, Highly_Suspect__c
                                  from reviews__c
                                  where Location_Lead_Review__c != false AND Lead__c =: currentId
                                  order by CreatedDate DESC])
                                      {
                                          locationReviewsList.add(r);    
                                      }
                    
              return JSON.serialize(locationReviewsList);
          }
  
    @istest
    static void reviews_leadcontroller()
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
             
             
             lead l = new lead();
             l.company = 'Test Reviews Lead';
             l.FirstName = 'First';
             l.LastName = 'Last';
             l.Division__c = 'Training';
             insert l;
             
             reviews__c r = new reviews__c();             
             r.Lead__c = l.id;                   
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
             r.Press_Source__c = 'Press1';
             r.Highly_Suspect__c = 'No';
             insert r; 
             
             reviews__c r2 = new reviews__c();             
             r2.Lead__c = l.id;                   
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
             r2.Press_Source__c = 'Press2'; 
             r2.Highly_Suspect__c = 'No';
             insert r2;

        Test.stopTest();
        
        //Test the ReviewsAcct page
        PageReference p1 = Page.ReviewsLead;
        Test.setCurrentPageReference(p1);
            
        //Add the current page Id
        string currentid = ApexPages.currentPage().getParameters().put('id', l.id);          
        
        //Pass to the controller the Lead value
        ApexPages.StandardController ApptController = new ApexPages.StandardController(l); 
        reviews_leadcontroller check = new reviews_leadcontroller(ApptController);
        
        check.errorMessage = 'You must select a location to add an address';
        //check.getGeneralRevs();
        check.Generalreview_cxbox = true;
        check.Locationreview_cxbox= true;
        check.savenew();
        check.Generalreview_cxbox = false;
        check.Locationreview_cxbox= false;
        check.savenew();
        check.Generalreview_cxbox = true;
        check.Locationreview_cxbox= false;
        check.savenew();
        check.Generalreview_cxbox = false;
        check.Locationreview_cxbox= true;
        check.savenew();
        check.getreviewvalue();
        //check.getGeneralRevs();
        check.getDisplayGenReviews();
        check.getDisplayAddyReviews();
                      
          } 
     }               
}