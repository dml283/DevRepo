@Istest
private class testDealAPI{

    static testmethod void myUnitTest(){
        DealAPI deal_inst = new DealAPI();
        DealAPI.Deal Deal_Vals = new DealAPI.Deal();
        
        Profile p = [select id from profile where name='System Administrator'];
        
        User userOwner = new User();
        userOwner.alias = 'standt';
        userOwner.email='standarduser@groupon.com';
        userOwner.emailencodingkey='UTF-8'; 
        userOwner.lastname='Testing';
        userOwner.languagelocalekey='en_US';
        userOwner.localesidkey='en_US';
        userOwner.profileid = p.Id;
        userOwner.timezonesidkey='America/Los_Angeles';
        userOwner.username='testOwnerDealAPI@groupon.com';
        insert userOwner;
        
        User userCP = new User();
        userCP.alias = 'standt';
        userCP.email='standarduser@groupon.com';
        userCP.emailencodingkey='UTF-8'; 
        userCP.lastname='Testing';
        userCP.languagelocalekey='en_US';
        userCP.localesidkey='en_US';
        userCP.profileid = p.Id;
        userCP.timezonesidkey='America/Los_Angeles';
        userCP.username='testCPDealAPI@groupon.com';
        insert userCP;
        
        account acct = new account();
        acct.Category_v3__c = 'TestCategory';
        acct.Name = 'DealAPITest' + system.now();
        insert acct;
        
        Opportunity O = new opportunity();
        o.ownerId = userOwner.id;
        o.name = 'TestDealAPIoppty';
        o.accountId = acct.id;
        o.stageName = 'Prospecting';
        o.closedate = system.today();
        o.user__c = userCP.id;
        o.Merchant_name_in_write_up__c = 'merchNameWriteUp';
        o.tax_code__c = 'taxVal';
        o.travel_quality__c = 'travelQualVal';
        o.Pre_FeatureStatus__c = true;
        o.primary_deal_services__c = 'TestPDS';
        Insert O;
        
        Multi_Deal__c md1 = new Multi_Deal__c();
            md1.Option_Services__c = 'Test1 | Test2 | Test3';
            md1.Option_Attributes__c = 'Test1 | Test2 | Test3';
            md1.opportunity__c = O.Id;
        Insert md1;
        
        Multi_Deal__c md2 = new Multi_Deal__c();
            md2.Unit_Buy_Price__c = 2;
            md2.Unit_Sell_Price__c = 4;
            md2.opportunity__c = O.Id;
        Insert md2;
        
        List<multi_deal__c> mul = new List<multi_deal__c>();
        mul.add(md1);
        mul.add(md2);
        system.debug('***' + mul);
        
        taxonomy_support__c tax = new taxonomy_support__c();
        tax.category__c = 'TestCategory';
        tax.name__c = 'TestPDS';
        insert tax;
        
        address__c addy = new address__C();
        addy.Opportunity__c = o.Id;
        Insert Addy;
        
        Deal_reviews__c revs = new Deal_reviews__c();
        revs.opportunity__c = o.Id;
        revs.Redemption_Address__c = addy.Id;
        Insert revs;
        
        Persona_Details__c pdTest = new Persona_Details__c();
        pdTest.Alternate_Name_adjective__c = 'adjectiveTest';
        pdTest.Alternate_Name_noun__c = 'nounTest';
        insert pdTest;
        
        Persona__c personaTest = new persona__c();
        personaTest.Persona__c = pdTest.Id;
        personaTest.Opportunity__c = o.id;
        insert personaTest;
        
        deal_inst.getMultiDeals(o.id);
        deal_inst.getOptionQuery(o.id);
        deal_inst.getOptionById(md1.id);
        
        string opId = o.id;
        string mdId = md1.id;
        
        deal_Inst.JSONResponse(opId);
        deal_Inst.JSONResponse(mdId);
        
        DealAPI.Deal testDeal = deal_Inst.formatDeal(o,mul,o.Id,tax); 
        
        //option option_vals = new option(o);
        DealAPI.Merchant Merchant_vals = new DealAPI.Merchant(o);

        //system asserts for deal obj values
        System.assertEquals(o.Merchant_name_in_write_up__c, testDeal.merchant_name_in_write_up);
        System.assertEquals(o.tax_code__c, testDeal.tax_category_id);
        System.assertEquals(o.travel_quality__c, testDeal.travel_quality);
        System.assertEquals(o.Pre_FeatureStatus__c, testDeal.pre_feature_status);
        /*System.assertEquals(
o.Primary_Deal_Services__c, testDeal.primary_service
o.Available_Date__c, testDeal.available_date
o.Payment_Terms__c, testDeal.Payment_Terms
o.CC_Fee__c, testDeal.CC_Fee
//testDeal.title 
o.Redeem_At__c, testDeal.redeem_at
o.Purchasibility_Region__c, testDeal.purchasibility_region
o.account.Marquee_Merchant__c, testDeal.marquee_merchant
o.type, testDeal.relevance_type 
o.Feature_Date__c, testDeal.launch_at
o.Feature_End_Date__c, testDeal.close_at
//testDeal.scheduler
o.Editorial_Fine_Print__c, testDeal.fine_print
o.coupon_instructions__c, testDeal.coupon_instructions
o.Merchant_Provided_Codes__c, testDeal.custom_redemption_codes
testDeal.pledge_expires_at_text 
testDeal.pledge_staggered_expiration 
testDeal.salesforce_id
testDeal.voucher_title
testDeal.area_names
testDeal.subdivision_name
testDeal.target_by_proximity
testDeal.affiliate
testDeal.using_relevance
testDeal.minimum_placement
testDeal.maximum_placement
testDeal.collected_quantity
testDeal.maximum_radius
testDeal.rerun_exclude_impressions_after
testDeal.deal_type
testDeal.sfdc_category
testDeal.redemption_location
testDeal.category
testDeal.subcategory
testDeal.use_merchant_specific_voucher_codes
testDeal.email_list_to
testDeal.city_planner_id
testDeal.merchant_manager_id
testDeal.sales_rep_id
testDeal.divisional_sales_manager_id
testDeal.deal_vetter
testDeal.stage_name
testDeal.last_modified_date
testDeal.projected_sales_count
testDeal.extended_purchase_max_percentage
testDeal.extended_purchase_period_in_days
testDeal.payment_until
testDeal.purchasability_region
testDeal.reward_program_earning_period 
testDeal.reward_program_spend_goal 
testDeal.reward_program_redemption_period 
testDeal.division_name
testDeal.allows_mulligans
testDeal.extended_access_period_enabled 
testDeal.external_purchase_url 
testDeal.custom_checkout 
testDeal.tipping_point 
testDeal.type
testDeal.merchant_account 
testDeal.merchant_permalink 
testDeal.months_to_expiration
testDeal.expiration_type 
testDeal.expiration_policy
testDeal.days_to_expiration 
testDeal.delay_voucher_release
testDeal.getaways_deal_filter
testDeal.groupon_live_deal_type
testDeal.use_relevance
testDeal.do_not_show_in_deals_nearby
testDeal.partner_deal_source
testDeal.merchant_name_in_write_up
testDeal.tax_category_id
testDeal.travel_quality
testDeal.pre_feature_status
testDeal.groupons_take
testDeal.salesforce_id
testDeal.voucher_title
testDeal.unit_buy_price
testDeal.unit_price
testDeal.unit_value
testDeal.buyer_max
testDeal.collect_email
testDeal.collect_shipping
testDeal.max_pledges 
testDeal.buyer_min 
testDeal.expiration_date 
testDeal.expiration_type 
testDeal.days_to_expiration 
testDeal.months_to_expiration 
testDeal.enable_staggered_expiration 
testDeal.product_sku_number 
testDeal.ordering 
testDeal.voucher_subtitle 
testDeal.shipping_cost 
testDeal.host_system_name
testDeal.event_code 
testDeal.seating_price_level
testDeal.event_start_date
testDeal.event_start_time
*/
    }
}