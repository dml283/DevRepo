public with sharing class Opportunityclonecontroller   {

  public Opportunity cloneOpp     {get; set;}
  public Id currentOppId          {get; set;}
  public Opportunity currentOpp   {get; set;}
  public List <Question__c> clonedQuestions {get; set;}
  public List <Multi_Deal__c> clonedMultiDeals {get; set;}
  public List <Address__c> clonedAddress {get; set;}
  public List <Deal_Reviews__c> clonedReviews {get; set;}
  public List <Question_DW__c> clonedDWQuestions {get; set;}

  public Opportunityclonecontroller (ApexPages.StandardController ctrl) {
    //Grab Cloned Opp and all of the fields they wish to clone.
    currentOppId           = ctrl.getID();

    clonedQuestions = new List<Question__c>();
    clonedMultiDeals = new List<Multi_Deal__c>();
    clonedAddress = new List<Address__c>();
    clonedReviews = new List<Deal_Reviews__c>();
    clonedDWQuestions = new List<Question_DW__c>();
  }
  public PageReference cloneAndRedirect() {

    currentOpp =  [SELECT   AccountId, Amount, StageName, CloseDate, Description, ForecastCategoryName, LeadSource, NextStep, Name,
                   OwnerId, RecordTypeId, CampaignId, IsPrivate, Probability, TotalOpportunityQuantity, Type, Book_Now_Button__c,
                   Getting_Ready_email_sent__c, of_Boomerang_Coupons_Sent__c, of_Days_Extension_for_Deal_Bank__c, of_Nights__c,
                   of_Observations__c, of_Performances__c, of_times_Deal_Structure_Rejected__c, of_Units_for_Deal_Bank__c,
                   X1st_Deal_Planner__c, X1st_Deal_Vette_Date__c, X1st_Payment__c, X1st_Payment_Days__c, X2nd_Lede_Edit_Done__c,
                   X2nd_Payment__c, X2nd_Payment_Days__c, X3rd_Payment__c, X3rd_Payment_Days__c, Account_Coordinator__c, AccountCoordinator_Notes__c,
                   AccountCoordinator__c, Account_Coordinator_Notes__c, Date_Account_Coord_Spoke_to_Merchant__c, Active_Subscribers_on_Feature_Date__c, Add_Message_to_Agreement_Email__c,
                   Addtl_Email_List_To__c, Addtl_Vendor_Password__c, Affiliate_ID__c, Age_Restrictions__c, Alternate_Deal_Planner__c, Alternate_Deal_Vette_Date__c,
                   Alternate_Deal_Vetter__c, Arrival_Departure_Cities_Airports__c, A_Sure_Thing__c, Available_Date__c, Average_Distance__c, Billing_Address__c,
                   Bundle_Package_Calculator__c, Bundling_Options__c, Buyer_Max__c, Callouts__c,
                   Captions_Ready__c, Captions_Writer__c, Captions_Written__c, Category__c, CC_Done_Time__c, CC_Fee__c, City_Property_Location__c, City_Manager__c, User__c,
                   City_Planning_Private_Notes__c, City_Planning_Stages__c, Claimed__c, Client_Preview_sent__c, Closed_Lost_Reasons__c, Competitor_Deals__c, Completed_Date__c,
                   Contract_date__c, Country_Property_Location__c, Coupones_Exception_Rationale_Initials__c,
                   CP_CM_Recommendations__c, CS_Email_Alert__c, Current_Scheduling_Tool__c, Customer_Count__c, Custom_Field_Checkout_Legal_Approval__c, Custom_Payment_Terms__c,
                   Merchant_Provided_Codes__c, Exclude_users_from_this_feature__c, Date_Reviews_Entered__c, Deal_Bank_Eligibility_Change_Date__c, Merchandising_Event__c,
                   Min_Units__c, Deal_Package_Content_Ranking__c, Deal_Quality__c, Deal_Score__c, Deal_Setup_Change_Date__c, Deal_Status__c,
                   Deal_Strengh__c, Deal_Structure_Approval_Notes__c, Deal_Structure_Approved__c, Deal_Structure_Rejected__c, Deal_Structure_Submitted__c, Deal_Vette_1_Date__c, DV__c,
                   Deal_Vette_1__c, Deal_Vetter__c, Deal_Vetter_Stages__c, Result_of_Deal_Vette__c, Destination__c,
                   Display_Order__c, Division__c, Divisional_Sales_Manager__c, Division_Subscribers__c, Does_feature_date_work__c, Does_Merchant_Have_iPhone_or_Android__c, Does_tentative_month_work__c, Show_in_Deals_Nearby__c,
                   Earliest_Redemption_Date__c, Earning_Period__c, Editorial_Communication_Warnings__c, Editorial_Stages__c, Editorial_Project_Notes__c, Email_List_To__c, Emails_Click_Through__c, Emails_Opened__c, Emails_Sent__c, Enable_Staggered_Expiration__c,
                   Event_Category_Override__c, Event_Code__c, Event_Date__c, Event_End_Date__c, Event_Start_Date__c, Event_Start_Time__c, Exceptional_Merchant_Quality__c, Exclude_Pa__c,
                   Expiration_Date__c, Extra_Fees__c, Extraordinary_Press__c, Face_Value__c, Feature_Date__c,
                   Feature_Date_Change_Date__c, Feature_End_Date__c, Final_Quantity_Paid__c, conditions__c,
                   Flag_for_Affiliates__c, Freelance_Writer_Test__c,  Closed_Source__c, gLive_Category__c, G_Live_Margin_Override__c,
                   gLive_Tier__c, gLive_Tier_Notes__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, gp_override__c, Groupon_Deal_Id__c, Groupon_Expiration_Date__c,
                   GrouponLive_Contracting_Party__c, GrouponLive_Import__c, Redemption_Location__c, sales_points__c, Highly_Suspect__c,
                   Home_Channel_Eligible__c, Host_System_Name__c, Humor_Ready__c, Writer__c, Primary_Image_Ready__c, Image_Notes__c,
                   TurnHere_Images_Received__c, Image_Use__c, Initial_Quantity_Paid__c, In_Person_Review__c, iscloned__c, Is_vendor_ready_for_Grouponicus__c,
                   Landing_Page__c, Line_Edit_Done__c, Line_Editor__c, Location_Ranking__c, Loyalty_Expiration_Date__c, Main_Deal_to_Side_Deal__c, Male_Units__c, Max_Subs__c, Merchant_Ambassador__c,
                   Merchant_Editorial_Review_Required__c, Merchant_Event__c, Merchant_Contact_Name__c, Merchant_Interview_Requested__c, Merchant_Interview_Sched__c, Merchant_name_in_write_up__c,
                   Merchant_Notified_of_Feature_Date__c, Merchant_Permalink__c, Coupons_Discounts__c,
                   Min_Subs__c, Miscellaneous_Trends__c, Mixed_Lede__c, Most_recent_call_to_vendor__c, MQS_data__c, Mulligan_Option_Discussed__c, Mulligans_Sold_hard_close__c, Multi_Account_Multi_Deal__c,
                   Multi_Market_Potential__c, Needs_Fast_Track__c, Negative_Press_Name__c, Negative_Press_Severity__c, Negative_Press_URL__c, Neighborhood__c, Now_Coordinator_Email__c, Now_Sales_Info__c, Now_Sales_Info_Notes__c,
                   Number_of_Locations__c, Number_of_Reviews_Places__c, Number_of_Reviews__c, Number_of_Stars__c, Obstructed_Sections__c, Obstructed_Views__c, Details__c, Opt_Out_of_Mulligan__c, Original_Sold_soft_close__c,
                   Other_Closed_Lost_Reason__c, Other_costs__c, Override_Default_Deal_Min_Tipping_Point__c, Override_Pay_Grid__c, Owner_lookup__c, Paid_by_Financial_Engineering__c, Parking_Included__c,
                   Partner_Deal_Source__c, Past_features_discussion_board_activity__c, Pay_at_Printed__c, PayGrid_Date_Change__c, Payment_Terms__c, Payment_Terms_Changed_By__c, Pay_on_Redemption__c,
                   Performer_Team__c, Placement_Count__c, Platform__c, Fine_Print_Policies_FC__c, Fine_Print_FC_Done__c, Post_Before_Date__c,
                   PPM_calculated__c, Unsched_Deal_Stuck__c, Unsched_Stuck_Date__c, Pre_Sched_Writeup__c,
                   Price_Point_Discount_Ranking__c,
                   Projected_Booking_GP_Calculated__c, Projected_Booking_GP_Calculated_Snapshot__c, Projected_Bookings_Calculated__c, Projected_Bookings_Calculated_Snapshot__c,
                   Projected_Quantity__c, Projected_Quantity_Calculated__c, Projected_Quantity_Calculated_Snapshot__c, Projected_Subs_Calculated__c, Projected_Subs_Calculated_Snapshot__c, Projection_Variance_Notes__c, Promoter_Name__c, Purchasibility_Region__c, Purchased_30__c,
                   Purchased_180__c, Purchased_30_60__c, Purchased_90_180__c, Purchase_Location_Site__c, QPM_calculated__c,
                   Merchant_Quality_Exception__c, Merchant_Quality_Exception_Rationale__c, questionid__c, Quickbooks__c,
                   Radius__c, Reason_for_CPNI__c, Reason_for_ENI__c, Reason_for_VNI__c, Recommended_Date__c, Redeem_At__c,
                   Redemption_Address__c, Merchant_Codes_Verified__c, Merchant_Code_Type__c, coupon_instructions__c, Hub_or_Spoke__c, Referrer_Email__c, Refund_Escrow_Amount__c,
                   Refund_Escrow_Opt_Out__c, Refund_Escrow_Quantity_Current__c, Refund_Escrow_Quantity_Deducted__c, Refund_Escrow_Test__c, Refunds__c, Refunds_60__c, Other_Rejected_Renegotiate_Reason__c,
                   Rejected_Renegotiate_Reasons__c, Repeat_Deal__c, Rep_Feature_Projected_GP__c, Restart_Refresh_Daily_Deal__c, Restrictions_Ranking__c, Retro_Refund_Call_Made__c,
                   Retro_Refund_Call_Required1__c, Review_Exception_Reasons__c, Review_Link__c, Reviews_Additional_Info__c, Reviews_do_not_upload__c, Reviews_Social_Media_Sites__c,
                   Reviews_Category__c, Reviews_Exception__c, Reviews_Exception1__c, Rewards_Deal_Creation_Status__c,
                   Rewards_Deal_Status__c, Rolling_Refund_Unit_Total__c, Rollup_Refund_Quantity__c, Rollup_Refund_Amount__c, RPM_calculated__c, Deal_Bank_Eligible__c, Sales_Promotion__c,
                   Sales_Stages__c, Satisfaction_Survey_Date__c, Schedule_By__c, Scheduler_Active_Date__c, Groupon_Scheduler_Status__c, Scheduler_Notes__c, Scheduler_Set_Up__c,
                   Season_Trend__c, Seating_Details__c, Select_for_GROUPONICUS__c, Special_Redemption_Code_Instructions__c,
                   Spend_Target__c, State_Property_Location__c, Structure_Change_post_CW__c, Subcategory__c, Subdivision__c, Subdivision_Dynamic__c, Subscriber_Count__c,
                   coupon_subtitle__c, Sure_Thing_Date__c, Survey_Received__c, Talk_to_Vendor__c, Targeting_Criteria__c, Tentative_Run_Date__c,
                   Tentative_Run_Month__c, TM_Fees__c, Ticket_Type__c, coupon_title__c, TM_Box_Office_Operator_Code__c, TM_Event_Code__c,
                   TM_Host_System_Name__c, Number_of_Buy_Buttons__c, Total_Refunds__c, Total_Revenue_Potential_Estimated__c, Total_Units_Available__c, Translation_complete__c,
                   Travel_Headline__c, Travel_Hotel_Policies__c, Travel_How_to_Book__c, Travel_Channel_Eligible__c, Travel_Quality__c, Travel_Targeting__c,
                   True_Up_Quantity_Paid__c, TurnHere_Requested__c, Unique_Redemption_Website__c, Unique_Redemption_Website_Notes__c,
                   unit_buy_price__c, Unit_Sell_Price__c, Value_of_Unit__c, Vendor_Password__c, Venue_Type__c, Reccomended_Date__c,
                   Video_Editor__c, Video_Ready__c, Vnum__c, Vnum_Bonus__c, Vnum_Humor__c, Vnum_Organization__c, Vnum_Research__c, Vnum_Writing__c,
                   Voice_Writer__c, VW_Ready__c, Warm_Lead_Rep__c, Warnings__c,
                   Reviews__c, Which_Competitors_Called__c, Win_Date__c, Word_Count__c,
                   WOW_Program_End_Date__c, WOW_Program_Start_Date__c, WOW_Type__c, Zendesk_Ticket__c, Division_Dynamic__c, IsABTest__c,
                   Expiration_Policy__c, Expiration_Type__c, Months_to_Expiration__c, Editorial_Fine_Print__c,
                   Deal_wizard__c, Submitted_via_Deal_Wizard__c, Dealwizard_manual_update__c
                   FROM    opportunity
                   WHERE   Id = : currentOppId];

    //Also Grab all related objects which in this case is Questions, Multi Deals and Addresses
    List<Question__c> oppQuestions      = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Answer__c, Required__c, Data_Type__c,
                                           Picklist_Options__c, Question_Name__c, From_Subcategory__c, Question_Bank__c, Fine_Print_Template__c, Fine_Print__c, Order__c, Question_Section__c, Opportunity__c,
                                           Help_Text__c, Has_Been_Answered__c FROM Question__c WHERE Opportunity__c = : currentOppId];
    //-- Fine_Print__c,

    List<Multi_Deal__c> oppMultiDeals   = [SELECT Id, Cloned_From__c, IsDeleted, Name, Unit_Value__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Opportunity__c, Unit_Buy_Price__c, Unit_Sell_Price__c,
                                           Margin__c, Margin_Percent__c, Buyer_Max__c, Total_Deal_Max__c, Individual_Purchase_Max__c, Category__c, Subcategory__c, Alternative_Highlights__c,
                                           GP__c, GMS__c, Alternative_Expiration_Date__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c,
                                           Selected_Services__c, Deal_Attributes__c, CP_Projection__c FROM Multi_Deal__c WHERE Opportunity__c = : currentOppId];

    List <Address__c> oppAddresses      = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Street_Line_1__c, Street_Line_2__c, City__c, State__c,
                                           Country__c, Zip_Postal_Code__c, Full_Address__c, Account__c, Merchant_Addresses__c, Opportunity__c, Dynamic_Zip_Code__c, Subdivision__c FROM Address__c WHERE Opportunity__c = : currentOppId];

    List<Deal_Reviews__c> oppReviews    = [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, of_1_star_Reviews__c, of_2_star_Reviews__c, of_3_star_Reviews__c, of_4_star_Reviews__c,
                                           of_5_star_Reviews__c, of_Complaints__c, BBB_Accredited__c, BBB_Grade__c, Description__c, Facebook_of_Fans__c, Highly_Suspect__c, Max_Possible_Rating__c,
                                           Merchant_Review__c, Mixed_Lede__c, Number_of_Ratings__c, Opportunity__c, Other_Source__c, Press_Source__c, Quote__c, Quote_Attribution__c, Rating__c,
                                           Redemption_Address__c, Source__c, Twitter_of_Followers__c, Type__c, Unit__c, Review_Link__c
                                           FROM Deal_Reviews__c WHERE Opportunity__c = : currentOppId];

    List <Question_DW__c> oppDWQuestions      = [SELECT Id, Name, Questions__c, Answer__c, DWID__c, Opportunity__c FROM Question_DW__c WHERE Opportunity__c = : currentOppId];

    //Make copies of current Opp plus all its related objects

    cloneOpp                = currentOpp.clone (false);
    CloneOpp.name           = '[A/B Test] ' + currentOpp.name;
    cloneopp.cloned_from__c = currentOpp.Id;
    cloneopp.IsABTest__c    = true;
    insert cloneOpp;
    currentOpp.cloned_to__c = cloneOpp.ID;
    currentOpp.name         = '[A/B Test] ' + currentOpp.name;
    currentOpp.IsABTest__c  = true;
    Database.saveresult SR = Database.update (currentOpp);
    //Remove standard created questions and replace with cloned ones.
    List<Question__c> deleteDupeQuestions = [SELECT Id, Opportunity__c FROM Question__c WHERE Opportunity__c = : cloneOpp.Id];


    for (Question__c q : oppQuestions) {
      Question__c cloneQ = new Question__c();
      cloneQ =  q.clone (false);
      cloneQ.Opportunity__c = cloneOpp.Id;

      clonedQuestions.add (cloneQ);
    }

    if (clonedQuestions.size() > 0) {
      delete deleteDupeQuestions;
    }
    insert clonedQuestions;

    for (Multi_Deal__c c : oppMultiDeals) {
      Multi_Deal__c cloneM = new Multi_Deal__c();
      cloneM =  c.clone (false);
      cloneM.Opportunity__c = cloneOpp.Id;
      cloneM.Cloned_From__c = c.id;
      clonedMultiDeals.add (cloneM);
    }
    insert clonedMultiDeals;


    for (Address__c a : oppAddresses) {
      Address__c cloneA = new Address__c();
      cloneA =  a.clone (false);
      cloneA.Opportunity__c = cloneOpp.Id;

      clonedAddress.add (cloneA);
    }
    insert clonedAddress;

    for (Deal_Reviews__c dr : oppReviews) {
      Deal_Reviews__c clonedr = new Deal_Reviews__c();
      clonedr =  dr.clone (false);
      clonedr.Opportunity__c = cloneOpp.Id;

      clonedReviews.add (clonedr);
    }
    insert clonedReviews;

    for (Question_DW__c dw : oppDWQuestions) {
      Question_DW__c clonedw = new Question_DW__c();
      clonedw =  dw.clone (false);
      clonedw.Opportunity__c = cloneOpp.Id;

      clonedDWQuestions.add (clonedw);
    }
    insert clonedDWQuestions;

    return new PageReference ('/' + cloneOpp.Id);
  }
  @istest
  static void testRedirect() {
    String rtTestOn = 'Food and Drink';

    Opportunity testOpp = TestUtil.createOppty (rtTestOn, 'Bars');

    Address__c a = new Address__c();
    a.Street_Line_1__c = 'line1';
    a.City__c = 'city';
    a.State__c = 'IL';
    a.Country__c = 'country';
    a.Zip_Postal_Code__c = '12345';
    a.Opportunity__c = testOpp.Id;
    insert a;

    Deal_Reviews__c dr = new Deal_Reviews__c();
    dr.Max_Possible_Rating__c = 10;
    dr.Number_of_Ratings__c = 500;
    dr.Rating__c = 8;
    dr.Source__c = 'Yelp';
    dr.Type__c = 'Rating';
    dr.Unit__c = 'Stars';
    dr.Opportunity__c = testOpp.Id;
    insert dr;

    multi_deal__c multi = new multi_deal__c();
    multi.name = 'Optionname';
    multi.Opportunity__c = testOpp.Id;
    multi.unit_value__c  = 123;
    insert multi;

    Question_Bank__c QB = new Question_Bank__c();
    QB.Question_section__c = 'Test';
    Insert QB;
    Question__c Q = new Question__c();
    Q.Opportunity__c = testopp.Id;
    q.Question_bank__c = QB.Id;
    Insert Q;

    Opportunityclonecontroller ctrl = new Opportunityclonecontroller (new ApexPages.StandardController (testOpp));
    ctrl.cloneAndRedirect();
  }

}