public class CloneIt {

  public CloneIt() {
    this.divisions = [select id, name from Division__C order by name];
  }

  @RemoteAction
  public static void cloneIt (string oppId, string DivName, string divId) {
    System.debug('#### in cloneIt');
    Id currentOppId = oppId;
    List <Question__c> clonedQuestions = new List<Question__c>();
    List <Multi_Deal__c> clonedMultiDeals = new List<Multi_Deal__c>();
    List <Address__c> clonedAddress = new List<Address__c>();
    List<Deal_Reviews__c> clonedReviews = new List<Deal_Reviews__c>();
    List<Question_DW__c> clonedDWQuestions = new List<Question_DW__c>();

    Opportunity currentOpp = [SELECT   Id, RecordTypeId, IsDeleted, AccountId, Name, Amount, Opt_Out_of_Mulligan__c, Tax_Code__c, Primary_Deal_Services__c,
                              Type, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, HasOpportunityLineItem, unit_buy_price__c, value_of_unit__c, unit_sell_price__c,
                              Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                              FiscalQuarter, FiscalYear, Fiscal, conditions__c, Max_Units__c, Min_Units__c, Margin__c, Margin_Percent__c, Discount__c, Post_Before_Date__c,
                              Projected_GP__c, sales_points__c, gp__c, COGS__c, projactual_gp__c,Account.Pay_On_Redemption_Only__c,
                              GMS__c, money_saved__c, Referrer_Email__c, gp_override__c,
                              Vendor_Password__c, coupon_instructions__c, Available_Date__c, Expiration_Date__c,
                              Projection_Error_Percent__c, Details__c, Commission_Rate__c, Commission_Amount__c, CC_Fee__c, Is_Featured__c,
                              Other_costs__c, Send_Satisfaction_Survey__c, Redemption_Address__c, Image_Notes__c,
                              Merchant_Provided_Codes__c, Merchant_Editorial_Review_Required__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c,
                              Billing_Address__c, Email_List_To__c, Category__c, Projection_Error__c, Custom_Payment_Terms__c,
                              Reviews_Writer__c, Reviews_Ready__c, Researcher__c, Details_Reviews_Ready__c, Fact_Checker__c, Fact_Check__c,
                              Voice_Editor__c, VW_Ready__c, Copy_Editor__c, Reviewed_by_Copy_Editor__c, Site_Editor__c, Final_Copy_Edit__c,
                              Image_Designer__c, Image_Ready__c, Deal_Creator__c, Deal_Set_Up__c, Reviewed_by_ME__c,
                              Email_Query_String__c, PPM__c, Groupons_Subscriber__c,
                              Opportunity_ID__c, Warnings__c, Baseline_GP__c, Estimated_Check_Amount__c, Reviews__c, Number_of_Buy_Buttons__c,
                              Subcategory__c, Baseline_Variance__c, Baseline_Variance_Percent__c, Number_of_Reviews__c, Payment_Terms__c, QPM__c,
                              Our_CC_Fee__c, Vendor_CC_Fee__c, Number_of_Locations__c, Extraordinary_Press__c, Merchant_Event__c, Select_for_GROUPONICUS__c,
                              Hub_or_Spoke__c, Sales_Promotion__c, Closed_Lost_Reasons__c, Other_Closed_Lost_Reason__c, Deal_Status__c,
                              Rejected_Renegotiate_Reasons__c, Other_Rejected_Renegotiate_Reason__c,  Alternate_Deal_Vetter__c, Reason_for_VNI__c, X1st_Deal_Planner__c,
                              Alternate_Deal_Planner__c, of_Observations__c, AccountCoordinator__c, Account_Coordinator_Notes__c, Sales_Stages__c, City_Planning_Stages__c, Date_Account_Coord_Spoke_to_Merchant__c,
                              Affiliate_ID__c, Completed_Date__c, Deal_Score__c, Does_feature_date_work__c, Does_tentative_month_work__c,
                              Is_vendor_ready_for_Grouponicus__c, Merchant_Notified_of_Feature_Date__c, Most_recent_call_to_vendor__c, Placement_Count__c, Talk_to_Vendor__c,
                              Tentative_Run_Month__c, Tool_Projected_Units__c, Tool_Projected_GP__c, Tool_Projected_Revenue__c, Merchant_Ambassador__c, Deal_Vetter_Stages__c, A_Sure_Thing__c,
                              Deal_Attributes__c, Owner.IsActive,  Record_Completness__c, Repeat_Deal__c, Num_Required__c, Num_Required_Answered__c, Multi_Deal_Units_Sold__c, Multi_Deal_GMS__c,
                              Multi_Deal_GP__c, Total_GP__c, Total_GMS__c, Total_Units_Sold__c, Deal_Strengh__c, Deal_Package_Content_Ranking__c, Location_Ranking__c, Merchant_Quality_Ranking__c,
                              Price_Point_Discount_Ranking__c, Restrictions_Ranking__c, Merchant_Permalink__c, X1st_Payment__c, X1st_Payment_Days__c, X2nd_Payment__c, X2nd_Payment_Days__c, X3rd_Payment__c, X3rd_Payment_Days__c,
                              Pay_on_Redemption__c, division__c, Copy_Coordinator__c, Deal_Bank_Eligible__c, Enable_Staggered_Expiration__c, feature_date__c, feature_end_date__c, Revenue_Type__c, Approved_for_G1__c,
                              Deal_wizard__c, Submitted_via_Deal_Wizard__c, Dealwizard_manual_update__c, Addtl_Email_List_To__c, Proof_of_Cancellation__c, cancellation_policy_url__c, Days_from_Feature_to_1st_Payment__c, 
                              GrouponLite_Monthly_Cap__c, Percent_Payment__c, Proof_of_License__c, proof_of_licensing_url__c, Proof_of_Pricing__c, proof_of_pricing_website__c, Redeem_At__c, Merchandising_Event__c, Merchant_Code_Type__c, 
                              Special_Redemption_Code_Instructions__c, Purchase_Location_Site__c, Merchant_name_in_write_up__c, 
                              Purchasibility_Region__c, Deal_Vette_1_Date__c, Opt_Out_of_Humor__c, Editorial_Fine_Print__c, AccountCoordinator_Notes__c, Groupon_Expiration_Date__c, Expiration_Policy__c, Expiration_Type__c, Months_to_Expiration__c, CC_Done__c,
                              Unique_Redemption_Website_Notes__c, Subdivision__c FROM Opportunity WHERE Id = : currentOppId];

    List<Question__c> oppQuestions = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Answer__c, Required__c, Data_Type__c,
                                      Picklist_Options__c, Question_Name__c, From_Subcategory__c, Question_Bank__c, Fine_Print_Template__c, Fine_Print__c, Order__c, Question_Section__c, Opportunity__c,
                                      Help_Text__c, Has_Been_Answered__c FROM Question__c WHERE Opportunity__c = : currentOppId];


    List<Multi_Deal__c> oppMultiDeals   = [SELECT Id, IsDeleted, Unit_Value__c, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Opportunity__c, Unit_Buy_Price__c, Unit_Sell_Price__c,
                                           Margin__c, Margin_Percent__c, Buyer_Max__c, Total_Deal_Max__c, Individual_Purchase_Max__c, Category__c, Subcategory__c, Alternative_Highlights__c, Product_SKU__c,
                                           Option_Attributes__c, Option_Services__c, GP__c, GMS__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Selected_Services__c, Deal_Attributes__c, Cloned_From__c,
                                           Purchase_Location_Site__c, of_Vouchers_Units_Per_Option__c, Display_Order__c, Voucher_Title__c, Voucher_Subtitle__c, GrouponLite_Monthly_Cap__c, Alternative_Expiration_Date__c
                                           FROM Multi_Deal__c WHERE Opportunity__c = : currentOppId];

    List <Address__c> oppAddresses      = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Street_Line_1__c, Street_Line_2__c, City__c, State__c,
                                           Country__c, Zip_Postal_Code__c, Full_Address__c, Account__c, Merchant_Addresses__c, Type__c, Opportunity__c, Dynamic_Zip_Code__c, Subdivision__c FROM Address__c WHERE Opportunity__c = : currentOppId];

    List<Deal_Reviews__c> oppReviews    = [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, of_1_star_Reviews__c, of_2_star_Reviews__c, of_3_star_Reviews__c, of_4_star_Reviews__c,
                                           of_5_star_Reviews__c, of_Complaints__c, BBB_Accredited__c, BBB_Grade__c, Description__c, Facebook_of_Fans__c, Highly_Suspect__c, Max_Possible_Rating__c,
                                           Merchant_Review__c, Mixed_Lede__c, Number_of_Ratings__c, Opportunity__c, Other_Source__c, Press_Source__c, Quote__c, Quote_Attribution__c, Rating__c,
                                           Redemption_Address__c, Source__c, Twitter_of_Followers__c, Type__c, Unit__c, Review_Link__c
                                           FROM Deal_Reviews__c WHERE Opportunity__c = : currentOppId];

    List <Question_DW__c> oppDWQuestions      = [SELECT Id, Name, Questions__c, Answer__c, DWID__c, Opportunity__c FROM Question_DW__c WHERE Opportunity__c = : currentOppId];


    opportunity cloneOpp  = currentOpp.clone (false);
    cloneOpp.division__c = divName;
    cloneOpp.CloseDate = date.today();
    cloneOpp.Unit_sell_price__c = null;
    cloneOpp.Unit_buy_price__c = null;
    cloneOpp.Value_of_Unit__c = null;
    cloneOpp.StageName = 'Closed Won';
    cloneOpp.iscloned__c = true;
    cloneOpp.Cloned_from__c = currentOppId;
    if (currentOpp.Owner.IsActive == false) {
      cloneOpp.OwnerId = currentOpp.Acct_Owner__r.Id;
    }
    //Check division and set pay grid fields
    //Set Payment Terms and Pay Grid Fields
    if(currentOpp.Account.Pay_On_Redemption_Only__c == True) {
        cloneOpp.Payment_Terms__c = 'Redemption System';
    } else if (currentOpp.division__c == 'CLONING TEMPLATE (multi-market deals)' || currentOpp.division__c == 'Canadian National Deals Cloning Template' || currentOpp.division__c == 'Evergreen' || currentOpp.division__c == 'Multi-Markets Testing' || currentOpp.division__c == 'NATIONAL DIVISION') {
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
        System.debug('#### in multi deal loop');
        
        Multi_Deal__c cloneM = new Multi_Deal__c();
        cloneM =  c.clone (false);
        cloneM.Opportunity__c = cloneOpp.Id;
        cloneM.Cloned_From__c = c.ID;
        
        if(c.Total_Deal_Max__c == null || c.Total_Deal_Max__c == 0){
            cloneM.Total_Deal_Max__c = 1;
        }       
        clonedMultiDeals.add (cloneM);
      }
      insert clonedMultiDeals;
      

      if (currentOpp.Unit_buy_price__c != null) {
        System.debug('#### in currentOpp.unit price not null');
        
        Multi_Deal__c cloneMnew = new Multi_Deal__c();
        
        if(currentOpp.Max_Units__c == null){
            System.debug('#### max units is null');
            cloneMnew.Total_Deal_Max__c = 1;
            System.debug('#### cloneMnew.Total_Deal_Max__c = ' + cloneMnew.Total_Deal_Max__c);
        }else if(Integer.valueof(currentOpp.Max_Units__c) == 0){ //only evaluate integer value if it's not null
            System.debug('#### max units is null, make it 1');
            cloneMnew.Total_Deal_Max__c = 1;
            System.debug('#### cloneMnew.Total_Deal_Max__c = ' + cloneMnew.Total_Deal_Max__c);
        }else{
            System.debug('#### in else');
            System.debug('#### cloneMnew.Total_Deal_Max__c = ' + cloneMnew.Total_Deal_Max__c);
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

    } else {}
  }

  public list<division__c> divisions {get; set;}

  @RemoteAction
  public static deal getOpp (string theId) {
    System.debug('### in get opp');
    opportunity o = [select id, name, account.name, feature_date__c, feature_end_date__c from opportunity where id = : theId LIMIT 1];
    deal d = new deal (o);
    return d;
  }
  public class deal {
    public string name {get; set;}
    public string account_name {get; set;}
    public string feature_date {get; set;}
    public string feature_end_date {get; set;}

    public deal (opportunity o) {
      this.name = o.name;
      this.account_name = o.account.name;
      this.feature_date = o.feature_date__c.format();
      this.feature_end_date = o.feature_end_date__c.format();
    }
  }

  static testMethod void workbenchAPITest() {

    Profile p = [select id from profile where name = 'System Administrator'];
    User u1 = new User (alias = 'standt', email = 'standarduser@groupon.com',
                        emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                        localesidkey = 'en_US', profileid = p.Id,
                        timezonesidkey = 'America/Los_Angeles', username = 'standarduser1@groupon.com');
    insert u1;
    //run as user
    System.RunAs (u1) {
      User u2 = new User (alias = 'user2', email = 'standarduser2@groupon.com',
                          emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                          localesidkey = 'en_US', profileid = p.Id,
                          timezonesidkey = 'America/Los_Angeles', username = 'standarduser2@groupon.com');
      insert u2;

      User u3 = new User (alias = 'user3', email = 'standarduser3@groupon.com',
                          emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                          localesidkey = 'en_US', profileid = p.Id,
                          timezonesidkey = 'America/Los_Angeles', username = 'standarduser3@groupon.com');
      insert u3;

      User u4 = new User (alias = 'user4', email = 'standarduser4@groupon.com',
                          emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
                          localesidkey = 'en_US', profileid = p.Id,
                          timezonesidkey = 'America/Los_Angeles', username = 'standarduser4@groupon.com');
      insert u4;

      Division__c d = new Division__c();
      d.Name = 'Test';
      d.State__c = 'IL';
      d.City_CEO__c = u2.id;
      d.dsm__c = u3.id;
      d.market_planner__c = u4.id;
      insert d;

      Sales_Goal__c goal = new Sales_Goal__c();
      goal.Goal_Start_Date__c = system.today().addDays (-1);
      goal.goal_end_date__c = system.today().addDays (1);
      goal.GP_Goal__c = 500;
      goal.Contract_Goal__c = 5;
      goal.division__c = d.id;
      insert goal;

      account a =  new account();
      a.name = 'testing account';
      a.division__c = d.id;
      a.BillingStreet = '123456 test';
      a.BillingCity = 'Chicago';
      a.BillingState = 'IL';
      a.BillingPostalCode = '60640';
      a.research_ranking__c = '5';
      insert a;

      date mydate1 = date.parse ('12/31/2012');
      opportunity o = new opportunity();
      o.name = 'test oppty';
      o.recordtypeid = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'G1'].id;
      o.division__c = d.name;
      o.Division_Dynamic__c = d.id;
      o.AccountId = a.id;
      o.StageName = 'Prospecting';
      o.CloseDate = mydate1;
      o.feature_date__c = system.today();
      o.feature_end_date__c = system.today().addDays (1);
      o.Category__c = 'Health & Beauty';
      o.city_manager__c = null;
      o.divisional_sales_manager__c = NULL;
      o.user__c = NULL;
      o.unit_buy_price__c = 5;
      o.TotalOpportunityQuantity = 5;
      o.unit_sell_price__c = 10;
      o.Repeat_Deal__c = 'Evergreen';
      insert o;

      information_request__c ir = new Information_request__c();
      ir.opportunity__c = o.id;
      insert ir;

      Multi_deal__c md = new Multi_deal__c();
      md.opportunity__c = o.id;
      insert md;

      address__c addy = new Address__c();
      addy.opportunity__c = o.id;
      addy.street_line_1__c = 'some street';
      addy.city__c = 'city';
      addy.state__c = 'ST';
      insert addy;
      
      Question_Bank__c qb = TestUtil.createQuestionBank ('Test QB', FALSE, 'Picklist', 'Test Options', 'test');

      Question__c q = new Question__c();
      q.Opportunity__c = o.Id;
      q.Question_Bank__c = qb.id;
      insert q;
    
      Question_DW__c dw = new Question_DW__c();
      dw.Opportunity__c = o.Id;
      dw.Name = 'Test Deal Wizard Question';
      insert dw;
    
      Deal_Reviews__c dr = new Deal_Reviews__c();
      dr.Opportunity__c = o.Id;
      dr.Redemption_Address__c = addy.Id;
      dr.Source__c = 'Yelp';
      dr.Type__c = 'Rating';
      dr.Unit__c = 'Stars';
      dr.Number_of_Ratings__c = 1000;
      dr.Rating__c = 10;
      insert dr;


      task test_task = new task();
      test_task.whatid = a.id;
      insert test_task;

      test.StartTest();
      cloneit.cloneIt (o.id, d.name, d.id);
      deal testDeal =  cloneit.getOpp (o.id);
      cloneit ci = new cloneIt();
      test.StopTest();
    }

  }
}