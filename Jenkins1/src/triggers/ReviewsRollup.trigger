trigger ReviewsRollup on Reviews__c (after insert, after update, after delete) {
    set<ID>AddyIds = new set<Id>();
    set<ID>AccountIds = new set<Id>();
    set<ID>LeadIds = new set<Id>();
    set<ID>MerchantRevIDs = new set<Id>();
    
    if(trigger.isInsert)
        {
            for(Reviews__c r:trigger.new)
                {
                    if(r.Merchant_Address__c != null)
                        {
                            AddyIds.add(r.Merchant_Address__c);
                        }
                    if(r.Account__c != null)
                        {
                            AccountIds.add(r.Account__c);
                        }
                    if(r.Account__c == null)
                         {
                             LeadIds.add(r.Lead__c);
                         }
                }
        }
    
     if(trigger.IsDelete)
         {
             for(Reviews__c r:trigger.old)
                 {
                     AddyIds.add(r.Merchant_Address__c);
                     AccountIds.add(r.Account__c);
                     if(r.Account__c == null)
                         {
                             LeadIds.add(r.Lead__c);
                         }
                 }
         }
    
    if(trigger.isUpdate)
        {
            map<id,Reviews__c> oldMap = new map<id,Reviews__c>();
            map<id,Reviews__c> newMap = new map<id,Reviews__c>();
            for(Reviews__c revOld : trigger.old)
                {                     
                    oldMap.put(revOld.id, revOld);              
                }
            for(Reviews__c revNew : trigger.new)
                {     
                    newMap.put(revNew.id, revNew);              
                }
        
            for(Reviews__c r:trigger.new)
                {
                    MerchantRevIDs.add(r.id);
                    Reviews__c oldr = oldMap.get(r.Id);
                    Reviews__c newr = newMap.get(r.Id);
                    
                    if((r.Type__c == 'Rating' && (oldr.Source__c <> newr.Source__c || oldr.Score_out_of_5__c <> newr.Score_out_of_5__c || oldr.Number_of_Ratings__c <> newr.Number_of_Ratings__c)) || (r.Type__c == 'Social Media' && oldr.Facebook_of_Fans__c <> newr.Facebook_of_Fans__c) || ((r.Type__c == 'Social Media' || r.Type__c == 'Rating') && oldr.Account__c <> newr.Account__c))                    
                        {
                            AddyIds.add(r.Merchant_Address__c);
                            AccountIds.add(r.Account__c);
                        }
                    if(r.Account__c == null && ((r.Type__c == 'Rating' && (oldr.Source__c <> newr.Source__c || oldr.Score_out_of_5__c <> newr.Score_out_of_5__c || oldr.Number_of_Ratings__c <> newr.Number_of_Ratings__c)) || (r.Type__c == 'Social Media' && oldr.Facebook_of_Fans__c <> newr.Facebook_of_Fans__c)))
                        {
                            LeadIds.add(r.Lead__c);
                        }
                }
        }
    
    //Populate Roll up fields on the Merchant Address
    //Average Review Score, Sum of Total Number of Ratings, Sum of Facebook Likes, and Concatenated string of reviews sources
    list<Merchant_Addresses__c>AddysToUpdate = new list<Merchant_Addresses__c>();
    
    for(Merchant_Addresses__c ma: [SELECT Id, Average_Review_Score_Out_of_5__c, Total_Number_of_Reviews__c, Reviews_Sources__c, Total_Facebook_Likes__c
                                   FROM Merchant_Addresses__c
                                   WHERE Id IN: AddyIds])
        {
            string sources = '';
            integer count = 0;
            decimal RollupRatingSum = 0;
            decimal RollupAvg = 0;
            decimal RollupRatings = 0;
            decimal FBlikes = 0;
            ma.Reviews_Sources__c = '';
            
            for(reviews__c r: [SELECT Id, Merchant_Address__c, Type__c, Source__c, Score_out_of_5__c, Number_of_Ratings__c, Facebook_of_Fans__c, Highly_Suspect__c from Reviews__c WHERE ((Type__c = 'Rating' AND Source__c != null AND Number_of_Ratings__c > 0 AND Score_out_of_5__c > 0) OR Facebook_of_Fans__c > 0) AND Highly_Suspect__c != 'Yes' AND Merchant_Address__c =: ma.id])
                {
                    if(r.type__c == 'Rating')
                        {
                            RollupRatings = RollupRatings + ((r.Number_of_Ratings__c == null)?0:r.Number_of_Ratings__c);
                            RollupRatingSum = RollupRatingSum + ((r.Score_out_of_5__c == null)?0:r.Score_out_of_5__c);
                            count = count + 1;
                        }
                    else
                        {
                            FBlikes = FBlikes + ((r.Facebook_of_Fans__c == null)?0:r.Facebook_of_Fans__c);
                        }
                        
                    if(r.Source__c != null)
                        {
                            if(sources.contains(r.Source__c) == False )
                                {
                                    sources += r.Source__c + '/';
                                }
                        }
                    
                }
            if (sources.endsWith('/')){sources = sources.substring(0,sources.lastIndexOf('/'));} 
            ma.Reviews_Sources__c = sources;
            if(count > 0){RollupAvg = RollupRatingSum/count;}
            ma.Average_Review_Score_Out_of_5__c = RollupAvg;
            ma.Total_Number_of_Reviews__c = RollupRatings;
            ma.Total_Facebook_Likes__c = FBlikes;
            AddysToUpdate.add(ma);
        }
    update AddysToUpdate;
    
    
    //Populate Roll up fields on the Account
    //Need to populate roll ups for both General Reviews and all Reviews associated to the Account: Average Review Score, Sum of Total Number of Ratings, Sum of Facebook Likes, and Concatenated string of reviews sources
    list<Account>AcctsToUpdate = new list<Account>();
        list <reviews__c> accountReviews = [SELECT Id, Account__c, Merchant_Address__c, Type__c, Source__c, Number_of_Ratings__c, Score_out_of_5__c, Facebook_of_Fans__c, Highly_Suspect__c from Reviews__c WHERE Account__c != null AND Number_of_Ratings__c != null AND ((Type__c = 'Rating' AND Source__c != null AND Number_of_Ratings__c > 0 AND Score_out_of_5__c > 0) OR Facebook_of_Fans__c > 0) AND Highly_Suspect__c != 'Yes' AND Account__c IN :AccountIds];
    
    for(Account a: [SELECT Id, Average_General_Review_Score_Out_of_5__c, General_Reviews_Sources__c, Total_Number_of_General_Ratings__c, Average_Review_Score_Out_of_5__c, Reviews_Sources__c, Total_Number_of_Ratings__c, Total_Facebook_Likes__c, Total_General_Facebook_Likes__c
                    FROM Account
                    WHERE Id IN: AccountIds])
        {
            //Declare Total Reviews Variables
            string sources = '';
            integer count = 0;
            decimal RollupRatingSum = 0;
            decimal RollupAvg = 0;
            decimal RollupRatings = 0;
            decimal FBlikes = 0;
            a.General_Reviews_Sources__c = '';
            
            //Declare General Reviews Variables
            string Generalsources = '';
            integer Generalcount = 0;
            decimal GeneralRollupRatingSum = 0;
            decimal GeneralRollupAvg = 0;
            decimal GeneralRollupRatings = 0;
            decimal GeneralFBlikes = 0;
            a.Reviews_Sources__c = '';
            
            for(reviews__c r : accountReviews)
                {
                if(r.account__c == a.id)
                {
                     if(r.Merchant_Address__c == null)
                         {
                             if(r.type__c == 'Rating')
                                 {
                                     GeneralRollupRatings = GeneralRollupRatings + ((r.Number_of_Ratings__c == null)?0:r.Number_of_Ratings__c);
                                     GeneralRollupRatingSum = GeneralRollupRatingSum + ((r.Score_out_of_5__c == null)?0:r.Score_out_of_5__c);
                                     Generalcount = Generalcount + 1;
                                 }
                             else
                                 {
                                     
                                     GeneralFBlikes = GeneralFBlikes + ((r.Facebook_of_Fans__c == null)?0:r.Facebook_of_Fans__c);
                                 }
                             if(r.Source__c != null)
                                {
                                    if(Generalsources.contains(r.Source__c) == False)
                                        {
                                            Generalsources += r.Source__c + '/';
                                        }
                                }
                         }
                     
                     if(r.type__c == 'Rating')
                         {
                             RollupRatings = RollupRatings + ((r.Number_of_Ratings__c == null)?0:r.Number_of_Ratings__c);
                             RollupRatingSum = RollupRatingSum + ((r.Score_out_of_5__c == null)?0:r.Score_out_of_5__c);
                             count = count + 1;
                         }
                     else
                         {
                             FBlikes = FBlikes + ((r.Facebook_of_Fans__c == null)?0:r.Facebook_of_Fans__c);
                         }
                     if(r.Source__c != null)
                        {
                            if(sources.contains(r.Source__c) == False )
                                {
                                    sources += r.Source__c + '/';
                                }
                        }
                    }
                }
            //Populate fields for Total Reviews Rollup
            if (sources.endsWith('/')){sources = sources.substring(0,sources.lastIndexOf('/'));} 
            a.Reviews_Sources__c = sources;
            if(count > 0){RollupAvg = RollupRatingSum/count;}
            a.Average_Review_Score_Out_of_5__c = RollupAvg;
            a.Total_Number_of_Ratings__c = RollupRatings;
            a.Total_Facebook_Likes__c = FBlikes;
            
            //Populate fields for General Reviews Rollup
            if (Generalsources.endsWith('/')){Generalsources = Generalsources.substring(0,Generalsources.lastIndexOf('/'));} 
            a.General_Reviews_Sources__c = Generalsources;
            if(Generalcount > 0){GeneralRollupAvg = GeneralRollupRatingSum/Generalcount;}
            a.Average_General_Review_Score_Out_of_5__c = GeneralRollupAvg;
            a.Total_Number_of_General_Ratings__c = GeneralRollupRatings;
            a.Total_General_Facebook_Likes__c = GeneralFBlikes;
            
            AcctsToUpdate.add(a);
        }
    update AcctsToUpdate;
    
    //Populate Roll up fields on the Lead Lead__c =: l.id
    //Need to populate roll ups for both General Reviews and Location Reviews: Average Review Score, Sum of Total Number of Ratings, Sum of Facebook Likes, and Concatenated string of reviews sources
    list<Lead>LeadsToUpdate = new list<Lead>();
    list<reviews__c> leadReviews = [SELECT Id, Lead__c, Account__c, Type__c, Source__c, Number_of_Ratings__c, Score_out_of_5__c, Facebook_of_Fans__c, Highly_Suspect__c, Location_Lead_Review__c from Reviews__c WHERE ((Type__c = 'Rating' AND Source__c != null AND Number_of_Ratings__c > 0 AND Score_out_of_5__c > 0) OR Facebook_of_Fans__c > 0) AND Highly_Suspect__c != 'Yes' AND Merchant_Address__c = null AND Account__c = null AND Lead__c IN: LeadIds];
    for(Lead l: [SELECT Id, Average_Review_Score_Out_of_5__c, Total_Number_of_Ratings__c, Total_General_Facebook_Likes__c, Total_Location_Facebook_Likes__c
                    FROM Lead
                    WHERE Id IN: LeadIds])
        {
            //Declare variables for general reviews
            string generalSources = '';
            integer generalCount = 0;
            decimal generalRollupRatingSum = 0;
            decimal generalRollupAvg = 0;
            decimal generalRollupRatings = 0;
            decimal generalFBlikes = 0;
            l.Reviews_Sources__c = '';
            
            //Declare variables for location reviews
            string locationSources = '';
            integer locationCount = 0;
            decimal locationRollupRatingSum = 0;
            decimal locationRollupAvg = 0;
            decimal locationRollupRatings = 0;
            decimal locationFBlikes = 0;
            l.Location_Reviews_Sources__c= '';

            for(reviews__c r: leadReviews)
                {
                    if(r.lead__c == l.id)
                    {
                    if(r.Location_Lead_Review__c == False)
                        {
                            if(r.type__c == 'Rating')
                                {
                                    generalRollupRatings = generalRollupRatings + ((r.Number_of_Ratings__c == null)?0:r.Number_of_Ratings__c);
                                    generalRollupRatingSum = generalRollupRatingSum + ((r.Score_out_of_5__c== null)?0:r.Score_out_of_5__c);
                                    generalCount = generalCount + 1;
                                }
                            else
                                {
                                    generalFBlikes = generalFBlikes + ((r.Facebook_of_Fans__c == null)?0:r.Facebook_of_Fans__c);
                                }
                            if(r.Source__c != null)
                                {
                                    if(generalSources.contains(r.Source__c) == False )
                                        {
                                            generalSources += r.Source__c + '/';
                                        }
                                }
                        }
                    else
                        {
                            if(r.type__c == 'Rating')
                                {
                                    locationRollupRatings = locationRollupRatings + ((r.Number_of_Ratings__c == null)?0:r.Number_of_Ratings__c);
                                    locationRollupRatingSum = locationRollupRatingSum + ((r.Score_out_of_5__c== null)?0:r.Score_out_of_5__c);
                                    locationCount = locationCount + 1;
                                }
                            else
                                {
                                    locationFBlikes = locationFBlikes + ((r.Facebook_of_Fans__c == null)?0:r.Facebook_of_Fans__c);
                                }
                            if(r.Source__c != null)
                                {
                                    if(locationSources.contains(r.Source__c) == False )
                                {
                                    locationSources += r.Source__c + '/';
                                }
                                }
                        }
                    }
                }
            //Populate fields for General Reviews Rollup
            if (generalSources.endsWith('/')){generalSources = generalSources.substring(0,generalSources.lastIndexOf('/'));} 
            l.Reviews_Sources__c = generalSources;
            if(generalCount > 0){generalRollupAvg = generalRollupRatingSum/generalCount;}
            l.Average_Review_Score_Out_of_5__c = generalRollupAvg ;
            l.Total_Number_of_Ratings__c = generalRollupRatings;
            l.Total_General_Facebook_Likes__c = generalFBlikes;
            
            //Populate fields for Location Reviews Rollup
            if (locationSources.endsWith('/')){locationSources = locationSources.substring(0,locationSources.lastIndexOf('/'));} 
            l.Location_Reviews_Sources__c = locationSources;
            if(locationCount > 0){locationRollupAvg = locationRollupRatingSum/locationCount;}
            l.Average_Location_Review_Score_Out_of_5__c = locationRollupAvg;
            l.Total_Number_of_Location_Ratings__c = locationRollupRatings;
            l.Total_Location_Facebook_Likes__c = locationFBlikes;
            
            LeadsToUpdate.add(l);
        }
        
    update LeadsToUpdate;
    
    //If the merchant review is updated then update all associated Deal Reviews
    list<Deal_Reviews__c>DR = [select Id, Merchant_Review__c from Deal_Reviews__c where Merchant_Review__c IN: MerchantRevIDs];
    list<Deal_Reviews__c>DRsToUpdate = new list<Deal_Reviews__c >();
   if(trigger.new != null && trigger.new.size() > 0)
    {    
    
    for(Reviews__c merchrevs : [select Id,of_1_star_Reviews__c,of_2_star_Reviews__c,of_3_star_Reviews__c,of_4_star_Reviews__c,of_5_star_Reviews__c,of_Complaints__c,
                                      BBB_Accredited__c,BBB_Grade__c,Description__c,Facebook_of_Fans__c,Highly_Suspect__c,Max_Possible_Rating__c,Mixed_Lede__c,Number_of_Ratings__c,Press_Source__c,Quote__c,
                                      Quote_Attribution__c,Rating__c,Source__c,Twitter_of_Followers__c,Type__c,Unit__c,Review_Link__c
                               from Reviews__c
                               where Id in: trigger.new])
        {
            for(Deal_Reviews__c dealrevs: DR)
                {
                    if(dealrevs.Merchant_Review__c == merchrevs.Id)
                        {
                            dealrevs.of_1_star_Reviews__c = merchrevs.of_1_star_Reviews__c;
                            dealrevs.of_2_star_Reviews__c = merchrevs.of_2_star_Reviews__c;
                            dealrevs.of_3_star_Reviews__c = merchrevs.of_3_star_Reviews__c;
                            dealrevs.of_4_star_Reviews__c = merchrevs.of_4_star_Reviews__c;
                            dealrevs.of_5_star_Reviews__c = merchrevs.of_5_star_Reviews__c;
                            dealrevs.of_Complaints__c = merchrevs.of_Complaints__c;
                            dealrevs.BBB_Accredited__c = merchrevs.BBB_Accredited__c; 
                            dealrevs.BBB_Grade__c = merchrevs.BBB_Grade__c;
                            dealrevs.Description__c = merchrevs.Description__c;
                            dealrevs.Facebook_of_Fans__c = merchrevs.Facebook_of_Fans__c;
                            dealrevs.Highly_Suspect__c = merchrevs.Highly_Suspect__c;
                            dealrevs.Max_Possible_Rating__c = merchrevs.Max_Possible_Rating__c;
                            dealrevs.Mixed_Lede__c = merchrevs.Mixed_Lede__c;
                            dealrevs.Number_of_Ratings__c = merchrevs.Number_of_Ratings__c;
                            dealrevs.Press_Source__c = merchrevs.Press_Source__c;
                            dealrevs.Quote__c = merchrevs.Quote__c;
                            dealrevs.Quote_Attribution__c = merchrevs.Quote_Attribution__c;
                            dealrevs.Rating__c = merchrevs.Rating__c;
                            dealrevs.Source__c = merchrevs.Source__c;
                            dealrevs.Twitter_of_Followers__c = merchrevs.Twitter_of_Followers__c;
                            dealrevs.Type__c = merchrevs.Type__c;
                            dealrevs.Unit__c = merchrevs.Unit__c;
                            dealrevs.Review_Link__c = merchrevs.Review_Link__c;
                    
                            DRsToUpdate.add(dealrevs);
                        }
                }
        }
    update DRsToUpdate;
    }
}