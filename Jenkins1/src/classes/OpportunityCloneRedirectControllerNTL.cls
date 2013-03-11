public with sharing class OpportunityCloneRedirectControllerNTL {

  public Opportunity cloneOpp     {get; set;}
  public Id currentOppId          {get; set;}
  public Opportunity currentOpp   {get; set;}
  public List <Question__c> clonedQuestions {get; set;}
  public List <Multi_Deal__c> clonedMultiDeals {get; set;}
  public List <Address__c> clonedAddress {get; set;}
  public List <Deal_Reviews__c> clonedReviews {get; set;}
  public List <Question_DW__c> clonedDWQuestions {get; set;}

  public OpportunityCloneRedirectControllerNTL (ApexPages.StandardController ctrl) {
    //Grab Cloned Opp and all of the fields they wish to clone.
    currentOppId           = ctrl.getID();

    clonedQuestions = new List<Question__c>();
    clonedMultiDeals = new List<Multi_Deal__c>();
    clonedAddress = new List<Address__c>();
    clonedReviews = new List<Deal_Reviews__c>();
    clonedDWQuestions = new List<Question_DW__c>();
  }
  public PageReference cloneAndRedirectNTL() {
    currentOpp = [SELECT   Id, RecordtypeId, IsDeleted, AccountId, Name, Amount, Opt_Out_of_Mulligan__c,
                  Type, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, HasOpportunityLineItem, unit_buy_price__c, value_of_unit__c, unit_sell_price__c,
                  Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                  FiscalQuarter, FiscalYear, Fiscal, conditions__c, Min_Units__c, Margin__c, Margin_Percent__c, Discount__c, Post_Before_Date__c,
                  Projected_GP__c, sales_points__c, gp__c, COGS__c, projactual_gp__c,
                  GMS__c, money_saved__c, Referrer_Email__c, gp_override__c, Account.Pay_On_Redemption_Only__c,
                  Vendor_Password__c, coupon_instructions__c, Available_Date__c, Expiration_Date__c,
                  Projection_Error_Percent__c, Details__c, Commission_Rate__c, Commission_Amount__c, CC_Fee__c, Is_Featured__c,
                  Other_costs__c, Send_Satisfaction_Survey__c, Redemption_Address__c, Image_Notes__c,
                  Merchant_Provided_Codes__c, Merchant_Editorial_Review_Required__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c,
                  Billing_Address__c, Email_List_To__c, Category__c, Projection_Error__c, Custom_Payment_Terms__c,
                  Reviews_Writer__c, Reviews_Ready__c, Researcher__c, Details_Reviews_Ready__c, Fact_Checker__c, Fact_Check__c,
                  Voice_Editor__c, VW_Ready__c, Copy_Editor__c, Reviewed_by_Copy_Editor__c, Site_Editor__c, Final_Copy_Edit__c,
                  Image_Designer__c, Image_Ready__c, Deal_Creator__c, Deal_Set_Up__c, Reviewed_by_ME__c,
                  Email_Query_String__c, PPM__c, Groupons_Subscriber__c, Subdivision__c,
                  Opportunity_ID__c, Warnings__c, Baseline_GP__c, Estimated_Check_Amount__c, Reviews__c,
                  Subcategory__c, Baseline_Variance__c, Baseline_Variance_Percent__c, Number_of_Reviews__c, Payment_Terms__c, QPM__c,
                  Our_CC_Fee__c, Vendor_CC_Fee__c, Number_of_Locations__c, Extraordinary_Press__c, Merchant_Event__c, Select_for_GROUPONICUS__c,
                  Hub_or_Spoke__c, Sales_Promotion__c, Closed_Lost_Reasons__c, Other_Closed_Lost_Reason__c, Deal_Status__c,
                  Rejected_Renegotiate_Reasons__c, Other_Rejected_Renegotiate_Reason__c,  Alternate_Deal_Vetter__c, Reason_for_VNI__c, X1st_Deal_Planner__c,
                  Alternate_Deal_Planner__c, of_Observations__c, AccountCoordinator__c, Account_Coordinator_Notes__c, Sales_Stages__c, City_Planning_Stages__c, Date_Account_Coord_Spoke_to_Merchant__c,
                  Affiliate_ID__c, Completed_Date__c, Deal_Score__c, Does_feature_date_work__c, Does_tentative_month_work__c,
                  Is_vendor_ready_for_Grouponicus__c, Merchant_Notified_of_Feature_Date__c, Most_recent_call_to_vendor__c, Placement_Count__c, Talk_to_Vendor__c,
                  Tentative_Run_Month__c, Tool_Projected_Units__c, Tool_Projected_GP__c, Tool_Projected_Revenue__c, Merchant_Ambassador__c, Deal_Vetter_Stages__c, A_Sure_Thing__c,
                  Deal_Attributes__c, Primary_Deal_Services__c, Owner.IsActive, Acct_Owner__r.Id, Record_Completness__c, Repeat_Deal__c, Num_Required__c, Num_Required_Answered__c, Multi_Deal_Units_Sold__c, Multi_Deal_GMS__c,
                  Multi_Deal_GP__c, Total_GP__c, Total_GMS__c, Total_Units_Sold__c, Deal_Strengh__c, Deal_Vette_1_Date__c, Deal_Package_Content_Ranking__c, Location_Ranking__c, Merchant_Quality_Ranking__c,
                  Price_Point_Discount_Ranking__c, Restrictions_Ranking__c, Merchant_Permalink__c, X1st_Payment__c, X1st_Payment_Days__c, X2nd_Payment__c, X2nd_Payment_Days__c, X3rd_Payment__c, X3rd_Payment_Days__c,
                  Pay_on_Redemption__c, division__c, Copy_Coordinator__c, Deal_Bank_Eligible__c, Enable_Staggered_Expiration__c, Expiration_Policy__c, Expiration_Type__c, Months_to_Expiration__c, Groupon_Expiration_Date__c,
                  Rewards_Sales_Info__c, Now_Sales_Info__c, Number_of_Buy_Buttons__c, Account_Coordinator__c, Redeem_At__c, Merchandising_Event__c, Merchant_Code_Type__c, Special_Redemption_Code_Instructions__c, Editorial_Fine_Print__c, Max_Units__c,
                  Display_Order__c, Code_Bucket__c, Notes_to_Editorial__c, Merchant_name_in_write_up__c, Editorial_Communication_Warnings__c, coupon_title__c, coupon_subtitle__c,
                  Deal_wizard__c, Submitted_via_Deal_Wizard__c, Dealwizard_manual_update__c, Addtl_Email_List_To__c, Proof_of_Cancellation__c, cancellation_policy_url__c, Days_from_Feature_to_1st_Payment__c, GrouponLite_Monthly_Cap__c, 
                  Percent_Payment__c, Proof_of_License__c, proof_of_licensing_url__c, Proof_of_Pricing__c, proof_of_pricing_website__c, Unique_Redemption_Website_Notes__c, Fulfillment_Method__c, Logistics_Notes__c, Tax_Code__c, Pre_FeatureStatus__c
                  FROM Opportunity WHERE Id = : currentOppId];

    //Also Grab all related objects which in this case is Questions, Multi Deals and Addresses
    List<Question__c> oppQuestions      = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Answer__c, Required__c, Data_Type__c,
                                           Picklist_Options__c, Question_Name__c, From_Subcategory__c, Question_Bank__c, Fine_Print_Template__c, Fine_Print__c, Order__c, Question_Section__c, Opportunity__c,
                                           Help_Text__c, Has_Been_Answered__c FROM Question__c WHERE Question_Name_2__c != 'Expires' AND Question_Name_2__c != 'Specific Expiration Date' AND Opportunity__c = : currentOppId];


    List<Multi_Deal__c> oppMultiDeals   = [SELECT Id, Cloned_From__c, IsDeleted, Unit_Value__c, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Opportunity__c, Unit_Buy_Price__c, Unit_Sell_Price__c,
                                           Margin__c, Margin_Percent__c, Buyer_Max__c, Total_Deal_Max__c, Individual_Purchase_Max__c, Category__c, Subcategory__c, Alternative_Highlights__c, Product_SKU__c,
                                           Option_Attributes__c, Option_Services__c, GP__c, GMS__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Selected_Services__c, Deal_Attributes__c,
                                           Alternative_Expiration_Date__c, Expiration_Type__c, Months_to_Expiration__c, Enable_Staggered_Expiration__c, Voucher_Title__c, Voucher_Subtitle__c, Display_Order__c,
                                           Of_Vouchers_Units_Per_Option__c, GrouponLite_Monthly_Cap__c, Product_height_in__c, Product_length_in__c, Product_weight_lbs__c, Product_width_in__c, Shipping_Handling__c
                                           FROM Multi_Deal__c WHERE Opportunity__c = : currentOppId];

    List <Address__c> oppAddresses      = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Street_Line_1__c, Street_Line_2__c, City__c, State__c,
                                           Country__c, Zip_Postal_Code__c, Full_Address__c, Account__c, Merchant_Addresses__c, Opportunity__c, Venue_Name__c, Phone_Number__c, Dynamic_Zip_Code__c, Subdivision__c FROM Address__c WHERE Opportunity__c = : currentOppId];

    List<Deal_Reviews__c> oppReviews    = [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, of_1_star_Reviews__c, of_2_star_Reviews__c, of_3_star_Reviews__c, of_4_star_Reviews__c,
                                           of_5_star_Reviews__c, of_Complaints__c, BBB_Accredited__c, BBB_Grade__c, Description__c, Facebook_of_Fans__c, Highly_Suspect__c, Max_Possible_Rating__c,
                                           Merchant_Review__c, Mixed_Lede__c, Number_of_Ratings__c, Opportunity__c, Other_Source__c, Press_Source__c, Quote__c, Quote_Attribution__c, Rating__c,
                                           Redemption_Address__c, Source__c, Twitter_of_Followers__c, Type__c, Unit__c, Review_Link__c
                                           FROM Deal_Reviews__c WHERE Opportunity__c = : currentOppId];

    List <Question_DW__c> oppDWQuestions      = [SELECT Id, Name, Questions__c, Answer__c, DWID__c, Opportunity__c
        FROM Question_DW__c WHERE Opportunity__c = : currentOppId];

    //Make copies of current Opp plus all its related objects

    cloneOpp           = currentOpp.clone (false);
    cloneOpp.CloseDate = date.today();
    cloneOpp.Unit_sell_price__c = null;
    cloneOpp.Unit_buy_price__c = null;
    cloneOpp.Value_of_Unit__c = null;
    cloneOpp.StageName = 'Closed Won';
    cloneOpp.iscloned__c = true;
    cloneOpp.Cloned_from__c = currentOppId;
    cloneOpp.division__c = null;
    cloneOpp.Max_Units__c   = '0';

    system.debug ('++++ currentOpp division__c' + currentOpp.division__c);

    if (currentOpp.Owner.IsActive == false) {
      cloneOpp.OwnerId = currentOpp.Acct_Owner__r.Id;
    }
    //Set Payment Terms and Pay Grid Fields
    if(currentOpp.Account.Pay_On_Redemption_Only__c == True) {
        cloneOpp.Payment_Terms__c = 'Redemption System';
    } else if (currentOpp.division__c == 'CLONING TEMPLATE (multi-market deals)' || currentOpp.division__c == 'Canadian National Deals Cloning Template' || currentOpp.division__c == 'Evergreen' || currentOpp.division__c == 'Multi-Markets Testing' || currentOpp.division__c == 'NATIONAL DIVISION') {
      cloneOpp.division__c = null;
      cloneOpp.X1st_Payment__c = currentOpp.X1st_Payment__c;
      cloneOpp.X1st_Payment_Days__c = currentOpp.X1st_Payment_Days__c;
      cloneOpp.X2nd_Payment__c = currentOpp.X2nd_Payment__c;
      cloneOpp.X2nd_Payment_Days__c = currentOpp.X2nd_Payment_Days__c;
      cloneOpp.X3rd_Payment__c = currentOpp.X3rd_Payment__c;
      cloneOpp.X3rd_Payment_Days__c = currentOpp.X3rd_Payment_Days__c;
      cloneOpp.Payment_Terms__c = currentOpp.Payment_Terms__c;
      cloneOpp.Custom_Payment_Terms__c = currentOpp.Custom_Payment_Terms__c;
      cloneOpp.Pay_on_Redemption__c = currentOpp.Pay_on_Redemption__c;
    } else if(currentOpp.Recordtypeid == '012C0000000ULFA') {
        cloneOpp.Payment_Terms__c = 'Continuous';
    } else {
      cloneOpp.X1st_Payment__c = 33;
      cloneOpp.X1st_Payment_Days__c = 1;
      cloneOpp.X2nd_Payment__c = 33;
      cloneOpp.X2nd_Payment_Days__c = 30;
      cloneOpp.X3rd_Payment__c = 34;
      cloneOpp.X3rd_Payment_Days__c = 60;
      cloneOpp.Payment_Terms__c = '1/3 / 30 days';
      cloneOpp.Custom_Payment_Terms__c = '';
      cloneOpp.Pay_on_Redemption__c = False;
    }
    for (multi_deal__c md : oppMultiDeals) {
      if (md.Unit_Sell_Price__c > 998 && cloneOpp.Payment_Terms__c <> 'Redemption System') {
        cloneOpp.Payment_Terms__c = 'Redemption System';
      }
    }
    if (currentopp.Repeat_Deal__c == 'Evergreen' || currentopp.Repeat_Deal__c == 'National: Online' || currentopp.Repeat_Deal__c == 'National/Online Deal' || currentopp.Repeat_Deal__c == 'Multiple Markets' ||
        currentopp.Repeat_Deal__c == 'Local multi-market' || currentopp.Repeat_Deal__c == 'National: Physical locations') {
      insert cloneOpp;
      //Remove standard created questions and replace with cloned ones.
      List<Question__c> deleteDupeQuestions = [SELECT Id, Opportunity__c FROM Question__c WHERE Opportunity__c = : cloneOpp.Id];
      delete deleteDupeQuestions;

      for (Question__c q : oppQuestions) {
        Question__c cloneQ = new Question__c();
        cloneQ =  q.clone (false);
        cloneQ.Opportunity__c = cloneOpp.Id;

        clonedQuestions.add (cloneQ);
      }
      insert clonedQuestions;

      for (Multi_Deal__c c : oppMultiDeals) {
        Multi_Deal__c cloneM = new Multi_Deal__c();
        cloneM =  c.clone (false);
        cloneM.Opportunity__c = cloneOpp.Id;
        cloneM.Cloned_From__c = c.id;
        if(c.Total_Deal_Max__c == null || c.Total_Deal_Max__c == 0){
            cloneM.Total_Deal_Max__c = 1;
        }
        clonedMultiDeals.add (cloneM);

      }
      insert clonedMultiDeals;

      if (currentOpp.Unit_buy_price__c != null) {
        Multi_Deal__c cloneMnew = new Multi_Deal__c();
        
        if(currentOpp.Max_Units__c == null){
            cloneMnew.Total_Deal_Max__c = 1;
        } else if(integer.valueof(currentOpp.Max_Units__c) == 0){ //only evaluate integer value if it's not null
            cloneMnew.Total_Deal_Max__c = 1;
        } else{
        cloneMnew.Total_Deal_Max__c = integer.valueof(currentOpp.Max_Units__c);
        }
        
        if (currentOpp.name.length() > 79) {
          cloneMnew.name = currentOpp.name.substring (0, 79);
        } else {
          cloneMnew.name = cloneopp.name;
        }
        cloneMnew.unit_buy_price__c = currentOpp.Unit_buy_price__c;
        cloneMnew.unit_sell_price__c = currentOpp.Unit_sell_price__c;
        cloneMnew.unit_value__c = currentOpp.value_of_unit__c;
        cloneMnew.clone (false);
        cloneMnew.Opportunity__c = cloneOpp.Id;
        insert cloneMnew;
      }

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
    } else {
      ApexPages.Message myMsg = new ApexPages.Message (ApexPages.Severity.ERROR, 'The National clone button can only be used for National and Multi-Market deals');
      ApexPages.addMessage (myMsg);
      return null;
    }

  }
  @isTest
  public static void testRedirect() {
    Account acc = new account (
      name               = 'CloneNtlTest' + system.now(),
      Account_Status__c  = 'Pay on Redemption Only'
    );
    Insert acc;

    Division__c div = new division__c (
      name = 'Canadian National Deals Cloning Template',
      state__c = 'CA'
    );
    Insert div;

    Opportunity testOpp = new Opportunity (
      accountID = acc.Id,
      Name = 'TEST' + System.currentTimeMillis(),
      Subcategory__c = 'Resturaunt',
      StageName = 'Contract Sent',
      CloseDate = System.today().addDays (30),
      Category__c = 'Food & Drink',
      division__c = div.name,
      Repeat_Deal__c = 'Evergreen',
      Payment_Terms__c = 'Custom Payment Terms',
      Unit_buy_price__c  = 100
    );
    Insert testOpp;

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

    question_bank__c ques_bank = new question_bank__c (
      question_section__c = 'Fine Print'
    );
    Insert ques_bank;

    Question__c  ques = new Question__c (
      opportunity__c = testopp.Id,
      question_bank__c = ques_bank.Id
    );
    Insert ques;

    multi_deal__c multi = new multi_deal__c (
      name = 'test multi',
      opportunity__c = testopp.Id,
      unit_value__c = 123,
      Unit_Sell_Price__c  = 1000,
      Unit_buy_price__c  = 100
    );
    Insert multi;
    
    //Test.startTest();
    OpportunityCloneRedirectControllerNTL ctrl = new OpportunityCloneRedirectControllerNTL (new ApexPages.StandardController (testOpp));
    
    ctrl.cloneAndRedirectNTL();
    //Test.stopTest();
  }
}