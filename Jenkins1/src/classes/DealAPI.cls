Global class DealAPI{

/*
Class contains all methods to support the Deals API
API Version: 1.0
Author: Chris Bland
Support: CBland@groupon.com

*/

// The JSON formatted object we will return;
public Deal JSONResponse(string theId)
    {
      deal d;
      try{
          Opportunity o = getOpp(theId);
          list<multi_deal__c> multiDealList = getMultiDeals(theId);
          //This is where we need the method which will get all the taxonomy stuff.
          taxonomy_support__c taxonomy = gettaxonomysupport(theId);
          //taxonomy_support__c taxonomy = [select id,name__c,c3_Id__c from taxonomy_support__c where Category__c!= null and subCategory__c != null limit 1];
          D = formatDeal(o,multiDealList, theId,taxonomy);
          }catch(exception e){d=new deal();}
      return D;
    }

//Method to transform an Opportunity in to a Deal
public deal formatDeal(opportunity o, list<multi_deal__c> multiDealList, string theId,taxonomy_support__c taxSupport)
    {
        Deal D = new Deal();
//DEAL WIZARD FIELD ADDITIONS
          d.primary_service = o.Primary_Deal_Services__c;
          //QPR d.questions       = addquestions(o);
          d.available_date   = o.Available_Date__c;
          d.Payment_Terms    = o.Payment_Terms__c;
          d.CC_Fee           = o.CC_Fee__c;
          d.custom_redemption_codes = o.Merchant_Provided_Codes__c;

//END OF DEAL WIZARD FIELD ADDITIONS.
          d.launch_at=o.Feature_Date__c;
          d.purchasibility_region = o.Purchasibility_Region__c;
          d.marquee_merchant = o.account.Marquee_Merchant__c;
          d.redeem_at = o.Redeem_At__c;
          d.close_at=o.Feature_End_Date__c;
          d.fine_print=o.Editorial_Fine_Print__c;
          d.relevance_type = o.type;
          d.coupon_instructions = o.coupon_instructions__c;
          d.pledge_expires_at_text=o.Expiration_Date__c;
          d.salesforce_id=o.id;
          d.voucher_title=o.name;
          d.DealOptions = addDealOptions(o,multiDealList);
          d.area_names=o.landing_page__c;
          d.subdivision_name=o.Subdivision__c;
          d.target_by_proximity=o.Show_in_Deals_Nearby__c;
          d.affiliate=o.affiliate_id__c;
          //if(o.Targeting_Criteria__c != 'No Targeting'){d.using_relevance = true;}else{d.using_relevance = false;}
          d.minimum_placement=o.Min_Subs__c;
          d.maximum_placement=o.Max_subs__c;
          d.collected_quantity=o.TotalOpportunityQuantity;
          d.maximum_radius=o.Radius__c;
          d.tipping_point=o.Min_Units__c;
          d.rerun_exclude_impressions_after=o.Exclude_users_from_this_feature__c;
          d.sfdc_category=o.Global_SFDC_Category__c;
          d.redemption_location=o.Redemption_Address__c;
          d.category=o.Category__c;
          d.deal_type = [Select RecordTypeId, RecordType.Name from Opportunity WHERE id=:o.id].RecordType.Name;
          d.subcategory=o.Subcategory__c;
          d.use_merchant_specific_voucher_codes=o.Merchant_Provided_Codes__c;
          d.email_list_to=o.Email_List_To__c;
          d.city_planner_id=o.user__c;
          d.merchant_manager_id=o.AccountCoordinator__c;
          d.sales_rep_id=o.ownerid;
          d.external_purchase_url =o.Unique_Redemption_Website_Notes__c;
          d.deal_website = o.Deal_Website__c;
          d.divisional_sales_manager_id=o.Divisional_Sales_Manager__c;
          d.deal_vetter=o.deal_vette_1__c;
          d.last_modified_date=o.LastModifiedDate;
          d.projected_sales_count=o.Projected_Quantity__c;
          d.extended_purchase_max_percentage=o.of_units_for_deal_bank__c;
          d.extended_purchase_period_in_days=o.of_Days_Extension_for_Deal_Bank__c;
          d.payment_until=o.Max_Pay_Date__c;
          d.purchasability_region=o.purchasibility_region__c;
          d.reward_program_earning_period=o.Earning_Period__c;
          d.reward_program_spend_goal=o.Spend_Target__c;
          d.fulfillment_method=o.Fulfillment_Method__c; // added by Sulabh on Nov 7, 2012
          d.brand_name=o.Brand_Manufacturer__c; // added by Sulabh on Nov 8, 2012
          d.do_not_collect_tax=o.Do_Not_Collect_Tax__c; // added by Sulabh on Jan 7, 2013
          d.reward_program_redemption_period=o.Loyalty_Expiration_Date__c;
          d.division_name=o.Division__c;
          if(o.opt_out_of_mulligan__c){d.allows_mulligans=false;}else{d.allows_mulligans=true;}
          d.extended_access_period_enabled=o.Deal_Bank_Eligible__c;
          d.personas = addPersonas(theId);
          //d.taxonomy = new taxonomy(o);
          d.taxonomy = new taxonomy(taxSupport);
          d.locations=addLocations(o.id);
          d.planning_records = addPlanningRecords (o.id);
          d.targeted_locations = getTarget_Zips(o.id);
          d.general_reviews = getGeneral_reviews_Deal(o.Id);
          d.merchant_account = o.AccountID;
          d.merchant_permalink = o.Account.Merchant_Permalink__c;
          d.months_to_expiration =o.Months_to_Expiration__c;
          d.expiration_type = o.Expiration_Type__c;
          d.expiration_policy = o.Expiration_Policy__c;
          d.days_to_expiration = o.DaystoExpiration__c;
          d.delay_voucher_release = defer_voucher_release(o.id);
          d.getaways_deal_filter = o.getaways_deal_filter__c;
          d.groupon_live_deal_type  = o.grouponlive_deal_type__c;
          d.use_relevance = o.targeting_criteria__c;
          d.do_not_show_in_deals_nearby = o.Show_in_Deals_Nearby__c;
          d.multi_account_multi_deal = o.Primary_Secondary__c;
          d.deal_strength = o.Deal_Strengh__c;
          d.partner_deal_source = o.partner_deal_source__c;
          d.merchant_name_in_write_up = o.Merchant_name_in_write_up__c;
          d.tax_category_id = o.tax_code__c;
          d.travel_quality =  o.travel_quality__c;
          d.pre_feature_status = o.Pre_FeatureStatus__c;
          d.clone_opportunity_ids = cloneOpportunityIds(theId);
          d.post_purchase_message = o.Post_Purchase_Message_From_Merchant__c;

          if(o.Straight_to_Private_Sale__c == 'Yes'){d.straight_to_private_sale=true;}else{d.straight_to_private_sale=false;}
          //d.straight_to_private_sale = o.Straight_to_Private_Sale__c;
          if(o.Groupon_Scheduler_Strength__c == 'Active'){d.scheduler=true;}else{d.scheduler=false;}
          d.merchant = new merchant(o);

          integer locationCount = 0;
          for(location l : d.locations){
              if(l.lat==null || l.lat==''){
                  if(locationCount < 10){
                      l.geocode();
                      locationCount ++;
                  }
              }
          }
          system.debug('LocationCount***' + locationCount);
          for(multi_deal__c md: multiDealList){
                  if(md.Option_Services__c!=null){
                  string[] services = md.Option_Services__c.split('\\|');
                  /*for(string s: services)
                      d.taxonomy.services.add(s.trim());*/
                  }
                  if(md.Option_Attributes__c!=null){
                  string[] attributes = md.Option_Attributes__c.split('\\|');
                  /*for(string s:attributes)
                      d.taxonomy.attributes.add(s.trim());*/
                   }
              }
          d.team = new list<team_member>();
             if(o.ownerid!=null) d.team.add(new team_member(o.ownerid,'Sales Rep')); //sales rep
             if(o.User__c!=null) d.team.add(new team_member(o.User__c,'City Planner')); //city planner
             if(o.DV__c!=null) d.team.add(new team_member(o.DV__c,'Deal Vetter')); //deal vetter
             if(o.City_Manager__c!=null) d.team.add(new team_member(o.City_Manager__c, 'City Manager')); //city manager
             if(o.AccountCoordinator__c!=null) d.team.add(new team_member(o.AccountCoordinator__c, 'Merchant Manager')); //merchant manager
             if(o.Divisional_Sales_Manager__c!=null) d.team.add(new team_member(o.Divisional_Sales_Manager__c, 'Divisional Sales Manager')); //divisional sales manager

        return d;
    }
//==========================CUSTOM OBJECTS=====================================

// the Deal Object
Global class Deal
    {
//DEAL WIZARD FIELD ADDITIONS
        public string primary_service {get;set;}
        //QPR public list<questions> questions{get;set;}
        public string available_date{get;set;}
        public string Payment_Terms{get;set;}
        public decimal CC_Fee{get;set;}
//DEAL WIZARD FIELD ADDITIONS
        public string title {get;set;}
        public string redeem_at {get;set;}
        public string purchasibility_region {get;set;}
        public boolean marquee_merchant {get;set;}
        public taxonomy taxonomy {get;set;}
        public string relevance_type {get;set;}
        public date launch_at {get;set;}
        public date close_at {get;set;}
        public boolean scheduler {get;set;}
        public string fine_print {get;set;}
        public string coupon_instructions {get;set;}
        public string custom_redemption_codes {get;set;}
        public string pledge_expires_at_text {get;set;}
        public boolean pledge_staggered_expiration {get;set;}
        public string salesforce_id {get;set;}
        public string voucher_title {get;set;}
        public list<option> DealOptions{get;set;}
        public string area_names {get;set;}
        public string subdivision_name {get;set;}
        public boolean target_by_proximity {get;set;}
        public string affiliate {get;set;}
        public boolean using_relevance {get;set;}
        public decimal minimum_placement {get;set;}
        public decimal maximum_placement {get;set;}
        public double collected_quantity {get;set;}
        public double maximum_radius {get;set;}
        public date rerun_exclude_impressions_after {get;set;}
        public string deal_type {get;set;}
        public string sfdc_category {get;set;}
        public string deal_website {get;set;}
        public string redemption_location {get;set;}
        public string category {get;set;}
        public string subcategory {get;set;}
        public string use_merchant_specific_voucher_codes {get;set;}
        public string email_list_to {get;set;}
        public string city_planner_id {get;set;}
        public string merchant_manager_id {get;set;}
        public string sales_rep_id {get;set;}
        public string divisional_sales_manager_id {get;set;}
        public string deal_vetter {get;set;}
        public string stage_name {get;set;}
        public datetime last_modified_date {get;set;}
        public double projected_sales_count {get;set;}
        public double extended_purchase_max_percentage {get;set;}
        public double extended_purchase_period_in_days {get;set;}
        public date payment_until {get;set;}
        public string purchasability_region {get;set;}
        public string reward_program_earning_period {get;set;}
        public double reward_program_spend_goal {get;set;}
        public string reward_program_redemption_period {get;set;}
        public string division_name {get;set;}
        public boolean allows_mulligans {get;set;}
        public string extended_access_period_enabled {get;set;}
        public list<Persona> Personas {get;set;}
        public list<location> Locations {get;set;}
        public list<review> general_reviews{get;set;}
        public string external_purchase_url {get;set;}
        public string custom_checkout {get;set;}
        public string tipping_point {get;set;}
        public string type {get;set;}
        public merchant merchant {get;set;}
        public list<string> targeted_locations {get;set;}
        public string merchant_account {get;set;}
        public string merchant_permalink {get;set;}
        public list<team_member> team {get;set;}
        public decimal months_to_expiration {get;set;}
        public string expiration_type {get;set;}
        public string expiration_policy {get;set;}
        public decimal days_to_expiration {get;set;}
        public string delay_voucher_release {get;set;}
        public string getaways_deal_filter {get;set;}
        public string groupon_live_deal_type {get;set;}
        public string use_relevance {get;set;}
        public boolean do_not_show_in_deals_nearby {get;set;}
        public string partner_deal_source {get;set;}
        public string merchant_name_in_write_up {get;set;}
        public string tax_category_id {get;set;}
        public string travel_quality {get;set;}
        public boolean pre_feature_status {get;set;}
        public boolean straight_to_private_sale {get; set;}
        public list<string> clone_opportunity_ids {get; set;}
        public string fulfillment_method {get;set;}
        public string brand_name {get;set;}
        public string do_not_collect_tax {get; set;}
        public string multi_account_multi_deal {get; set;}
        public string deal_strength {get; set;}
        public string post_purchase_message {get; set;}
        public List<Planning> planning_records {get; set;}
    }
//Question_DW object realted to Deal Wizard
/*QPR
global class questions{
public string salesforce_id{get;set;}
public string answers{get;set;}
public string questions{get;set;}
public string dw_id{get;set;}
public string opportunity{get;set;}
global questions(question_dw__c q){
this.salesforce_id = q.Id;
this.answers       = q.answer__c;
this.questions     = q.questions__c;
this.dw_id         = q.DWID__c;
this.opportunity   = q.opportunity__c;
}
}*/
// the pledge object
global class Option
  {
  //DEAL WIZARD FIELDS
    public decimal groupons_take{get;set;}
  //DEAL WIZARD FILEDS
    public string salesforce_id{get;set;}
    public string voucher_title{get;set;}
    public decimal unit_buy_price {get;set;}
    public decimal unit_price {get;set;}
    public decimal unit_value {get;set;}
    public decimal buyer_max {get;set;}
    public boolean collect_email {get;set;}
    public boolean collect_shipping {get;set;}
    public string max_pledges {get;set;}
    public decimal buyer_min {get;set;}
    public string expiration_date {get;set;}
    public string expiration_type {get;set;}
    public decimal days_to_expiration {get;set;}
    public decimal months_to_expiration {get;set;}
    public boolean enable_staggered_expiration {get;set;}
    public string product_sku_number {get;set;}
    public double ordering {get;set;}
    public string voucher_subtitle {get;set;}
    public decimal shipping_cost {get;set;}
    //public string partner_deal_source {get;set;}
    public string host_system_name {get;set;}
    public string event_code {get;set;}
    public string seating_price_level {get;set;}
    public string event_start_date {get;set;}
    public string event_start_time {get;set;}
    public decimal groupon_lite_monthly_cap {get; set;}
    public string cloned_from {get; set;}
    public decimal gift_wrapping_surcharge {get; set;}
    public string expedited_shipping_charge {get;set;}
    public boolean third_party_bookable {get; set;}
    public string third_party_booking_url {get; set;}
    public string third_party_booking_notes {get; set;}
    public option(){}
    /*
    public option(opportunity o){
          this.expiration_date = o.Expiration_Date__c;
          this.expiration_type = o.Expiration_Type__c;
          this.months_to_expiration = o.Months_to_Expiration__c;
          this.salesforce_id=o.id;
          this.product_sku_number = o.Product_SKU__c;
          this.voucher_title=o.name;
          this.unit_buy_price=o.unit_buy_price__c;
          this.unit_price=o.Unit_Sell_Price__c;
          this.unit_value=o.Value_of_Unit__c;
          this.max_pledges=o.Max_Units__c;
          this.ordering=o.Display_Order__c;
          this.enable_staggered_expiration = o.enable_staggered_expiration__c;
        }
    */
    public option(multi_deal__c md){
          if(md.Alternative_Expiration_Date__c!=null)this.expiration_date = md.Alternative_Expiration_Date__c.format();
          this.expiration_type = md.Expiration_Type__c;
          this.months_to_expiration = md.Months_to_Expiration__c;
          this.product_sku_number = md.Product_SKU__c;
          this.salesforce_id=md.id;
          this.unit_buy_price=md.Unit_Buy_Price__c;
          if(md.Unit_sell_Price__c != null && md.Unit_Buy_Price__c!= null)
          {this.groupons_take = md.Unit_sell_Price__c - md.Unit_Buy_Price__c;}
          else {this.groupons_take = 0;}
          this.buyer_max = md.Buyer_Max__c;
          this.buyer_min = md.of_Vouchers_Units_Per_Option__c;
          this.collect_email =md.Collect_Email__c;
          this.collect_shipping = md.Collect_Shipping_Address__c;
          this.unit_price=md.Unit_Sell_Price__c;
          this.unit_value=md.Unit_Value__c;
          this.max_pledges=string.valueOf(md.Total_Deal_Max__c);
          this.ordering=md.Display_Order__c;
          this.enable_staggered_expiration = md.enable_staggered_expiration__c;
          this.voucher_title = md.Voucher_Title__c;
          this.voucher_subtitle = md.Voucher_Subtitle__c;
          this.shipping_cost = md.Shipping_Handling__c;
          //this.partner_deal_source = md.partner_deal_source__c;
          this.host_system_name = md.tm_host_system_name__c;
          this.event_code = md.tm_event_code__c;
          this.seating_price_level = md.seating_price_level__c;
          this.event_start_date = string.valueOf(md.event_start_date__c);
          this.event_start_time = string.valueOf(md.event_start_time__c);
          this.groupon_lite_monthly_cap = md.GrouponLite_Monthly_Cap__c;
          this.cloned_from = md.Cloned_From__c;
          this.gift_wrapping_surcharge = md.Gifting_Surcharge__c; // added by Sulabh on Nov 8, 2012
          this.expedited_shipping_charge = md.Expedited_Shipping__c; // added by Sulabh on Nov 8, 2012
          this.third_party_bookable = md.X3rd_Party_Bookable__c;
          this.third_party_booking_url = md.X3rd_Party_Booking_URL__c;
          this.third_party_booking_notes = md.X3rd_Party_Booking_Notes__c;
        }
  }

   public class Planning{
    public string division {get; set;}
    public string position {get; set;}
    public string priority {get; set;}
    public date start_date {get; set;}
    public date end_date {get; set;}
    public id opportunity_id {get; set;}
    public boolean account_management_ready {get; set;}
    public boolean editorial_complete {get; set;}
    public id planning_record_id {get; set;}

    public Planning(Planning__c p){
      this.division = p.division__r.Name;
      this.position = p.position__c;
      this.priority = p.priority__c;
      this.start_date = p.start_date__c;
      this.end_date = p.end_date__c;
      this.opportunity_id = p.opportunity__c;
      this.account_management_ready = p.Account_Management_Ready__c;
      this.editorial_complete = p.Editorial_Complete__c;
      this.planning_record_id = p.Id;
    }
  }

public class Merchant
  {
    public string permalink{get;set;}
    public id account_id {get;set;}
    public list<review> Merchant_general_reviews {get;set;}
    public string merchant_permalink {get;set;}
    public string merchant_name {get;set;}
        public Merchant(opportunity o){
            this.permalink = o.Account.Merchant_Permalink__c;
            this.account_id = o.AccountID;
            this.Merchant_general_reviews = new list<review>() ;
            this.merchant_name = o.Merchant_name_in_write_up__c;
            this.merchant_permalink = o.account.Merchant_Permalink__c;
        }
  }
public class taxonomy{
        public primaryService primaryService{get;set;}
        public taxonomy(taxonomy_support__c tax_support){
            this.primaryService  = new primaryService(tax_support);
        }
    }
public class primaryservice{
    public string name{get;set;}
    public string uuid{get;set;}
    public string tax_record_Id{get;set;}

    public primaryservice(taxonomy_support__c tax_support){
        this.name = tax_support.name__c;
        this.uuid= tax_support.c3_Id__c;
        this.tax_record_Id = tax_support.Id;
    }
}
// the pledge object
public class Persona
  {
    public string name{get;set;}
    public string Alternate_Name_adjective{get;set;}
    public string Alternate_Name_noun{get;set;}
  }
global class location
    {
        public string name{get;set;}
        public string address1{get;set;}
        public string address2{get;set;}
        public string state{get;set;}
        public string zip{get;set;}
        public string city{get;set;}
        public string country{get;set;}
        public string phone_number{get;set;}
        public string lat{get;set;}
        public string lng {get;set;}
        public string neighborhood {get;set;}
        public id merchant_address_id {get;set;}
        public id salesforce_id {get;set;}
        public string address_type {get;set;}
        public id parent_address_id {get;set;}
        public list<review> location_reviews {get;set;}

        public void geoCode(){
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            string url = 'http://geodetails.groupondev.com/v1/coordinate.json?loc_string=';
            string address = this.address1+' ';

            if(this.address2 !=null) address += this.address2+' ';
            if(this.city != null) address += this.city+' ';
            if(this.state != null) address += this.state+' ';
            if(this.zip != null) address += this.zip+' ';

            req.setMethod('GET');
            string encoded = EncodingUtil.urlEncode(address, 'UTF-8');
            url+=encoded+'&key=salesforce';
            req.setEndpoint(url);

            HttpResponse res = h.send(req);

            system.debug('response body============'+res.getBody());
            system.debug('response code============='+res.getStatus());

            if(res.getStatusCode()==200){
                Map<String, Object> geocode_resp = (Map<String, Object>)  JSON.deserializeUntyped(res.getBody());
                //geocode g = (geocode)JSON.deserialize(res.getBody(), geocode.class);
                Map<String, Object> neighborhood_obj = (Map<String, Object>)geocode_resp.get('effectiveNeighborhood');
                system.debug('=========='+neighborhood_obj);

                this.lng = string.valueOf(geocode_resp.get('lng'));
                this.lat = string.valueOf(geocode_resp.get('lat'));
                this.neighborhood = string.valueOf(neighborhood_obj.get('name'));
                if(this.parent_address_id  != null){
                    Merchant_Addresses__c parent_address = new Merchant_Addresses__c(id=this.parent_address_id);
                    parent_address.Latitude__c = decimal.valueOf(this.lat);
                    parent_address.Longitude__c = decimal.valueOf(this.lng);
                    parent_address.neighborhood__c = this.neighborhood;
                    try{
                        database.update(parent_address);
                        }catch(exception e){
                            system.debug(e);
                        }
                    }
            }else{
               system.debug(res);
            }
        }
        public location(address__c a){
            this.address1 = a.Street_Line_1__c;
            this.address2 = a.Street_Line_2__c;
            this.state = a.state__c;
            this.zip = a.Zip_Postal_Code__c;
            this.city = a.City__c;
            this.country = a.country__c;
            this.name = a.Venue_Name__c;
            this.phone_number = a.Phone_Number__c;
            this.address_type = a.type__c;
            if(a.Merchant_Addresses__r.Longitude__c != null){
                    this.lng = string.valueOf(a.Merchant_Addresses__r.Longitude__c);
                }
            if(a.Merchant_Addresses__r.Latitude__c != null){
                    this.lat = string.valueOf(a.Merchant_Addresses__r.Latitude__c);
                }
            this.salesforce_id = a.id;
            this.neighborhood = a.Merchant_Addresses__r.neighborhood__c;
            this.merchant_address_id = a.Merchant_Addresses__r.id;
            this.location_reviews = reviewinfo(a);
            //Street_Line_1__c, Street_Line_2__c, state__c, Zip_Postal_Code__c, City__c, country__c, Phone__c, Address_GEO__r.Address_Latitude__c, Address_GEO__r.Address_Longitude__c
         }
         public list<review> reviewinfo(address__c addy)
        {
            list<review> revs = new list<review>();
            if(addy.id!=null){
            list<deal_reviews__c> reviews = [select id,name,of_1_star_Reviews__c ,of_2_star_Reviews__c ,of_3_star_Reviews__c ,of_4_star_Reviews__c ,of_5_star_Reviews__c ,of_Complaints__c ,BBB_Accredited__c ,BBB_Grade__c ,Created_Date__c ,Description__c ,Facebook_of_Fans__c  ,Full_Review__c,Highly_Suspect__c,Max_Possible_Rating__c,Merchant_Review__c   ,Mixed_Lede__c,Number_of_Ratings__c ,Opportunity__c,Press_Source__c,Quote__c,Quote_Attribution__c,Rating__c,Redemption_Address__c,Score_out_of_5__c,Source__c,Twitter_of_Followers__c,Type__c,Unit__c,Review_Link__c, Other_Source__c from deal_reviews__c where Redemption_Address__c =: addy.id ];
            for(deal_reviews__c deal_revs: reviews)
            {
            revs.add(new review(deal_revs));
            }
            }
            return revs;
        }

    }
    public class Review{
        public string   name {get;set;}
        public decimal  Facebook_of_Fans{get;set;}
        public decimal  Max_Possible_Rating{get;set;}
        public string   Mixed_Lede{get;set;}
        public decimal  Number_of_Ratings{get;set;}
        public string   Opportunity{get;set;}
        public string   Press_Source{get;set;}
        public string   Quote{get;set;}
        public string   Quote_Attribution{get;set;}
        public decimal  Rating{get;set;}
        public string   Source{get;set;}
        public decimal  Twitter_of_Followers{get;set;}
        public string   Type{get;set;}
        public string   Unit{get;set;}
        public string   Review_Link{get;set;}
        public string   Redemption_Address{get;set;}
        public review(deal_reviews__c location_revs)
        {
            this.name                 =  location_revs.name;
            this.Facebook_of_Fans     =  location_revs.Facebook_of_Fans__c;
            this.Max_Possible_Rating  =  location_revs.Max_Possible_Rating__c;
            this.Mixed_Lede           =  location_revs.Mixed_Lede__c;
            this.Number_of_Ratings    =  location_revs.Number_of_Ratings__c;
            this.Opportunity          =  location_revs.Opportunity__c;
            this.Press_Source         =  location_revs.Press_Source__c;
            this.Quote                =  location_revs.Quote__c;
            this.Quote_Attribution    =  location_revs.Quote_Attribution__c;
            this.Rating               =  location_revs.Rating__c;
            this.Redemption_Address   =  location_revs.Redemption_Address__c;
            system.debug('#####Source: ' + location_revs.Source__c);
            system.debug('#####Other Source: ' + location_revs.Other_Source__c);
            if(location_revs.Source__c == 'Other' && location_revs.Other_Source__c != null) {
                this.Source           =  location_revs.Other_Source__c;
            } else {
                this.Source           =  location_revs.Source__c;
            }

            //this.Source               =  location_revs.Source__c;
            this.Twitter_of_Followers =  location_revs.Twitter_of_Followers__c;
            this.Type                 =  location_revs.Type__c;
            this.Unit                 =  location_revs.Unit__c;
            this.Review_Link          =  location_revs.Review_Link__c;
        }
    }
public class team_member{
        public string first_name {get;set;}
        public string last_name {get;set;}
        public string full_name {get;set;}
        public string email {get;set;}
        public string phone {get;set;}
        public id salesforce_id {get;set;}
        public string job_title {get;set;}
        public string role {get;set;}
        public team_member(id i, string role){
                user u = [select name, firstName, lastName, title, email, phone, id from User where id = :i LIMIT 1];
                if(u!=null){
                        this.first_name = u.firstname;
                        this.last_name = u.lastName;
                        this.full_name = u.name;
                        this.email = u.email;
                        this.phone = u.phone;
                        this.salesforce_id = u.id;
                        this.job_title = u.title;
                        this.role=role;
                     }
            }
    }
public list<string> getTarget_Zips(id i){
        list<string> zips = new list<string>();
        list<Target_Zip__c> tzip = [select id,Target_Zip_Code__c from Target_Zip__c WHERE opportunity__c = :i];
        for(Target_Zip__c z :tzip)
            zips.add(z.Target_Zip_Code__c);
        return zips;
    }
//==========================DEAL METHODS=====================================
public list<review> getGeneral_reviews_Deal(Id theId){
    list<review> general_reviews = new list<review>();
    list<deal_reviews__c> reviews = [select id,name,of_1_star_Reviews__c ,of_2_star_Reviews__c ,of_3_star_Reviews__c ,of_4_star_Reviews__c ,of_5_star_Reviews__c ,of_Complaints__c ,BBB_Accredited__c ,BBB_Grade__c ,Created_Date__c ,Description__c ,Facebook_of_Fans__c  ,Full_Review__c,Highly_Suspect__c,Max_Possible_Rating__c,Merchant_Review__c   ,Mixed_Lede__c,Number_of_Ratings__c ,Opportunity__c,Press_Source__c,Quote__c,Quote_Attribution__c,Rating__c,Redemption_Address__c,Score_out_of_5__c,Source__c,Twitter_of_Followers__c,Type__c,Unit__c,Review_Link__c, Other_Source__c from deal_reviews__c where opportunity__c =: theId and Redemption_Address__c =: null];
            for(deal_reviews__c deal_revs: reviews)
            {
            general_reviews .add(new review(deal_revs));
            }
    return general_reviews ;
}
/*QPR
public list<questions> addquestions(opportunity o){
list<questions> ques = new list<questions>();
list<question_dw__c> quests= database.query(getdealwizardquestions(o.id));
for(question_dw__c q: quests){
ques.add(new questions(q));
}
return ques;
}*/
public list<option> addDealOptions(opportunity o, list<multi_deal__c> multiDealList)
  {
    list<option> OptionList = new list<option>();
    //option opt = new Option(o);

    //OptionList.add(opt);
    for(multi_deal__c md : multiDealList)
      {
        option m = new Option(md);
        OptionList.add(m);
      }

    return OptionList;
  }
public list<Persona> addPersonas(string theId)
  {
    list<persona> ReturnList = new list<persona>();
    list<Persona__c> plist = getPersonas(theId);
    for(persona__c p :plist)
      {
        Persona a = new Persona();
          a.name=p.Persona__r.name;
          a.Alternate_Name_adjective=p.Persona__r.Alternate_Name_adjective__c;
          a.Alternate_Name_noun=p.Persona__r.Alternate_Name_noun__c;
        ReturnList.add(a);
      }
    return ReturnList;
  }
public list<location> addLocations(string theId){
    list<address__c> addyList = database.query(getAddressQuery(theId));

    list<location> Locations = new list<location>();
    for(address__c a: addyList){
        locations.add(new Location(a));
    }
    return locations;
}

public List<Planning> addPlanningRecords (string s){
    String queryString = getPlanningRecordsQuery (s);
    List<Planning__c> planList = database.query (queryString);
    List<Planning> returnList = new List<Planning>();
    for (planning__c p : planList){
      returnList.add (new Planning (p));
    }
    return returnList;
  }

public list<string> cloneOpportunityIds(string parentDealOpportunityId) {
    list<Opportunity> clones = database.query(getOpportunityClones(parentDealOpportunityId));

    list<string> cloneIds = new list<string>();
    for(Opportunity clone: clones){
        cloneIds.add(clone.id);
    }
    return cloneIds;
}
//==========================SOQL BUILDERS=====================================
//Builds the SOWL Query for Taxonomysupport
/*QPR
public string getdealwizardquestions(string oppId){
string questions_list = 'select id,answer__c,questions__c,DWID__c,opportunity__c from question_dw__c where opportunity__c = \''+oppId+'\' ';
return questions_list;
}*/
public taxonomy_support__c gettaxonomysupport(string theId)
    {
        opportunity Opp  = database.query(getOpportunityQuery(theId));
        if(opp.Primary_Deal_Services__c != null){
            list<taxonomy_support__c> taxonomy = new list<taxonomy_support__c>();
            taxonomy = [select id,c3_id__c,name__c from taxonomy_support__c where category__c =: opp.category_v3__c and name__c =: opp.primary_deal_services__c limit 1];
            if(taxonomy != null){
            for(taxonomy_support__c ts : taxonomy){
                    return ts;
                }
            }
            taxonomy_support__c nullTaxonomyId = new taxonomy_support__c();
            return nullTaxonomyId;
            }else{
                taxonomy_support__c nullTaxonomy = new taxonomy_support__c();
                return nullTaxonomy;
            }
    }
//Builds the SOQL query for Opportunity
public string getOpportunityQuery(string theId)
    {
    string s = 'select Post_Purchase_Message_From_Merchant__c, Primary_Secondary__c, Deal_Strengh__c, Do_Not_Collect_Tax__c, id, name, Straight_to_Private_Sale__c,tax_code__c,travel_quality__c,Pre_FeatureStatus__c,grouponlive_deal_type__c,CC_Fee__c, Partner_Deal_Source__c, Payment_Terms__c, Available_Date__c,Primary_Deal_Services__c, getaways_deal_filter__c, Editorial_Fine_Print__c , Unique_Redemption_Website_Notes__c, account.Marquee_Merchant__c, Redeem_At__c, Category_v3__c,Subcategory_v3__c, Groupon_Scheduler_Strength__c, DaystoExpiration__c, Merchant_name_in_write_up__c, account.name, Months_to_Expiration__c, Expiration_Type__c, Expiration_Policy__c, DV__c, City_Manager__c, enable_staggered_expiration__c, Account.Merchant_Permalink__c, Feature_Date__c, Feature_End_Date__c, conditions__c, coupon_instructions__c, Expiration_Date__c, Max_Units__c, Min_Units__c, unit_buy_price__c, unit_Sell_Price__c, Value_of_Unit__c, Landing_Page__c, Subdivision__c, Show_in_Deals_Nearby__c, Affiliate_ID__c, Targeting_Criteria__c, Min_Subs__c, Max_Subs__c, TotalOpportunityQuantity, Radius__c, Exclude_users_from_this_feature__c, Type, Global_SFDC_Category__c, Category__c, Redemption_Address__c, Subcategory__c, Merchant_Provided_Codes__c, AccountID, Email_List_To__c, User__c,AccountCoordinator__c,OwnerId,Divisional_Sales_Manager__c,Deal_Vette_1__c,StageName,LastModifiedDate, Projected_Quantity__c, of_Units_for_Deal_Bank__c,of_Days_Extension_for_Deal_Bank__c,Max_Pay_Date__c,Purchasibility_Region__c,Earning_Period__c,Spend_Target__c,Loyalty_Expiration_Date__c,Fulfillment_Method__c,Brand_Manufacturer__c,Display_Order__c,Division__c,opt_out_of_mulligan__c,Deal_Bank_Eligible__c,Deal_Website__c';
        s+=' FROM opportunity ';
        s+=' WHERE id = \''+theId+'\' ';
        s+=' LIMIT 1';
        return s;
    }
//Builds the SOQL query for Multi_deal
public string getMultidealQuery(string theId)
    {
        string s = 'SELECT X3rd_Party_Bookable__c, X3rd_Party_Booking_URL__c, X3rd_Party_Booking_Notes__c, Cloned_From__c,Gifting_Surcharge__c,Expedited_Shipping__c,GrouponLite_Monthly_Cap__c, TM_Host_System_Name__c, TM_Event_Code__c, Seating_Price_Level__c, of_Units_for_Deal_Bank__c, Shipping_Handling__c, Voucher_Title__c, Voucher_Subtitle__c, of_Vouchers_Units_Per_Option__c, Collect_Email__c, Collect_Shipping_Address__c, Option_Attributes__c,Option_Services__c, DaystoExpiration__c, Product_SKU__c, Expiration_Type__c, Months_to_Expiration__c,  Enable_Staggered_Expiration__c, opportunity__r.Max_Units__c, of_Tickets_per_Groupon__c, of_Tickets_Sold__c, of_Nights__c, of_Days_Extenstion_for_Deal_Bank__c, gLive_Category1__c, Valid_gLive_Margin__c, Units_Sold__c, Unit_Value__c, Unit_Sell_Price__c, Unit_Buy_Price__c, True_Up_Quantity_Paid__c, True_Up_Amount_Paid__c, Total_Deal_Max__c, Tiered_Margin_Split__c, TM_Fees__c, SystemModstamp, Subcategory__c, Section__c, Rolling_Refund_Unit_Total__c, Retail_Value__c, Refund_Escrow_Quantity_Deducted__c, Refund_Escrow_Quantity_Current__c, Promotional_Value__c, Projected_Revenue__c, Projected_Groupon_Share_of_GP__c, Processing_Fee__c, Per_Voucher_Payment__c, Partner_Deal_Source__c, Partner_Deal_Source_DNU__c, Opportunity__c, Name, Multi_deal_Projected_GMS__c, Multi_Deal_Setup_Change_Date__c, Multi_Deal_Expiration_Date__c, Margin__c, Margin_Percent__c, MD_NPSID__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Individual_Purchase_Max__c, Id, Groupon_Share_of_GP__c, Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, G_Live_Margin_Override__c, GP__c, GMS__c, Final_Quantity_Paid__c, Feature_Date__c, Face_Value__c, Event_Start_Time__c, Event_Start_Date__c, Event_End_Date__c, Event_Category_Override__c, Estimated_Check_Ammount__c, Display_Order__c, Discount__c, Deal_Bank_Eligible__c, Current_Refund_Dollar_Amount__c, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, Category__c, CP_Projection__c, CC_Fee__c, CC_Fee_NEW__c, Buyer_Max__c, Bundling_Options__c, Bundle_Package_Calculator__c, Alternative_Highlights__c, Alternative_Expiration_Date__c, Alt_Exp_Date__c ';
        s+=' FROM Multi_deal__c ';
        s+=' WHERE Opportunity__c = \''+theId+'\' ';
        return s;
    }

public string getOptionQuery(string theId)
    {
        string s = 'SELECT X3rd_Party_Bookable__c, X3rd_Party_Booking_URL__c, X3rd_Party_Booking_Notes__c, Cloned_From__c,Gifting_Surcharge__c,Expedited_Shipping__c,GrouponLite_Monthly_Cap__c, TM_Host_System_Name__c, TM_Event_Code__c, Seating_Price_Level__c, of_Units_for_Deal_Bank__c, Shipping_Handling__c, Voucher_Title__c, Voucher_Subtitle__c, of_Vouchers_Units_Per_Option__c, Collect_Email__c, Collect_Shipping_Address__c, Option_Attributes__c,Option_Services__c, DaystoExpiration__c, Product_SKU__c, Expiration_Type__c, Months_to_Expiration__c,  Enable_Staggered_Expiration__c, opportunity__r.Max_Units__c, of_Tickets_per_Groupon__c, of_Tickets_Sold__c, of_Nights__c, of_Days_Extenstion_for_Deal_Bank__c, gLive_Category1__c, Valid_gLive_Margin__c, Units_Sold__c, Unit_Value__c, Unit_Sell_Price__c, Unit_Buy_Price__c, True_Up_Quantity_Paid__c, True_Up_Amount_Paid__c, Total_Deal_Max__c, Tiered_Margin_Split__c, TM_Fees__c, SystemModstamp, Subcategory__c, Section__c, Rolling_Refund_Unit_Total__c, Retail_Value__c, Refund_Escrow_Quantity_Deducted__c, Refund_Escrow_Quantity_Current__c, Promotional_Value__c, Projected_Revenue__c, Projected_Groupon_Share_of_GP__c, Processing_Fee__c, Per_Voucher_Payment__c, Partner_Deal_Source__c, Partner_Deal_Source_DNU__c, Opportunity__c, Name, Multi_deal_Projected_GMS__c, Multi_Deal_Setup_Change_Date__c, Multi_Deal_Expiration_Date__c, Margin__c, Margin_Percent__c, MD_NPSID__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Individual_Purchase_Max__c, Id, Groupon_Share_of_GP__c, Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, G_Live_Margin_Override__c, GP__c, GMS__c, Final_Quantity_Paid__c, Feature_Date__c, Face_Value__c, Event_Start_Time__c, Event_Start_Date__c, Event_End_Date__c, Event_Category_Override__c, Estimated_Check_Ammount__c, Display_Order__c, Discount__c, Deal_Bank_Eligible__c, Current_Refund_Dollar_Amount__c, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, Category__c, CP_Projection__c, CC_Fee__c, CC_Fee_NEW__c, Buyer_Max__c, Bundling_Options__c, Bundle_Package_Calculator__c, Alternative_Highlights__c, Alternative_Expiration_Date__c, Alt_Exp_Date__c ';
        s+=' FROM Multi_deal__c ';
        s+=' WHERE id = \''+theId+'\' ';
        return s;
    }

//Builds the SOQL query for Persona
public string getPersonaQuery(string theId)
    {
    string s = 'SELECT Persona__r.name, Persona__r.Alternate_Name_adjective__c, Persona__r.Alternate_Name_noun__c';
        s+=' FROM Persona__c ';
        s+=' WHERE Opportunity__c = \''+theId+'\' ';
        return s;
    }
public string getAddressQuery(string theId)
    {
    string s = 'SELECT type__c,Street_Line_1__c,Opportunity__c,Venue_Name__c, Phone_Number__c, Street_Line_2__c, state__c, Zip_Postal_Code__c, City__c, country__c, Phone__c, Merchant_Addresses__r.Latitude__c, Merchant_Addresses__r.Longitude__c, Merchant_Addresses__r.neighborhood__c,  Merchant_Addresses__r.id';
        s+=' FROM Address__C ';
        s+=' WHERE Opportunity__c = \''+theId+'\' ';
     return s;
    }
//Builds the SOQL query for Opportunity Clones
public string getOpportunityClones(string theParentDealId) {
    string query = 'select id';
    query +=' FROM opportunity ';
    query +=' WHERE Cloned_From__c = \''+theParentDealId+'\' ';
    return query;
}
 public string getPlanningRecordsQuery (string theId){
    string s = 'SELECT Id,Account_Management_Ready__c,Division__c,division__r.Name,Editorial_Complete__c,End_Date__c,Opportunity__c,Position__c,Priority__c,Start_Date__c';
    s += ' FROM Planning__c';
    s += ' WHERE Opportunity__c = \'' + theId +'\' ';
    return s;
  }

//=========================Methods to get the records out of the database==============

//Gets the Opportunity we will be working with
public opportunity getOpp(string theId)
    {
        //get the SOQL string we will use to query by passing in the ID of the opportunity we are looking for
        string queryString = getOpportunityQuery(theId);

        //run the SOQL query using database.query method
        opportunity o = database.query(queryString);

        return o;
    }
//gets the Multi-Deals that will be asscoiated with this deal
public list<multi_deal__c> getMultiDeals(string theId)
  {
    string queryString = getMultidealQuery(theId);
      system.debug('### Query string' + queryString );
        //run the SOQL query using database.query method
        list<multi_deal__c> mdlist = database.query(queryString);
        return mdlist;
  }
//gets the Personas that will be asscoiated with this deal
public list<Persona__c> getPersonas(string theId)
  {
    string queryString = getPersonaQuery(theId);

        //run the SOQL query using database.query method
        list<Persona__c> pList = database.query(queryString);

        return pList;
  }
public option getOptionById(string s){
        option opt;
        //if(s.substring(0,3)=='006'){
                //opportunity o = database.query(getOpportunityQuery(s));
               // [select id, Product_SKU__c, name, enable_staggered_expiration__c, Account.Merchant_Permalink__c, Feature_Date__c, Feature_End_Date__c, conditions__c, coupon_instructions__c, Expiration_Date__c, Max_Units__c, Min_Units__c, unit_buy_price__c, unit_Sell_Price__c, Value_of_Unit__c, Landing_Page__c, Subdivision__c, Show_in_Deals_Nearby__c, Affiliate_ID__c, Targeting_Criteria__c, Min_Subs__c, Max_Subs__c, TotalOpportunityQuantity, Radius__c, Exclude_users_from_this_feature__c, Type, Global_SFDC_Category__c, Category__c, Redemption_Address__c, Subcategory__c, Merchant_Provided_Codes__c, AccountID, Email_List_To__c, User__c,AccountCoordinator__c,OwnerId,Divisional_Sales_Manager__c,Deal_Vette_1__c,StageName,LastModifiedDate, Projected_Quantity__c, of_Units_for_Deal_Bank__c,of_Days_Extension_for_Deal_Bank__c,Max_Pay_Date__c,Earning_Period__c,Spend_Target__c,Loyalty_Expiration_Date__c,Display_Order__c,Division__c,opt_out_of_mulligan__c,Deal_Bank_Eligible__c FROM opportunity where ID = :s LIMIT 1];
                //opt = new option(o);
            //}else{
                multi_deal__c md = database.query(getOptionQuery(s));
                //[SELECT of_Units_for_Deal_Bank__c, Option_Attributes__c,Option_Services__c, DaystoExpiration__c, Product_SKU__c, Expiration_Type__c, Months_to_Expiration__c,  Enable_Staggered_Expiration__c, opportunity__r.Max_Units__c, of_Tickets_per_Groupon__c, of_Tickets_Sold__c, of_Nights__c, of_Days_Extenstion_for_Deal_Bank__c, gLive_Category1__c, Valid_gLive_Margin__c, Units_Sold__c, Unit_Value__c, Unit_Sell_Price__c, Unit_Buy_Price__c, True_Up_Quantity_Paid__c, True_Up_Amount_Paid__c, Total_Deal_Max__c, Tiered_Margin_Split__c, TM_Fees__c, SystemModstamp, Subcategory__c, Section__c, Rolling_Refund_Unit_Total__c, Retail_Value__c, Refund_Escrow_Quantity_Deducted__c, Refund_Escrow_Quantity_Current__c, Promotional_Value__c, Projected_Revenue__c, Projected_Groupon_Share_of_GP__c, Processing_Fee__c, Per_Voucher_Payment__c, Partner_Deal_Source__c, Partner_Deal_Source_DNU__c, Opportunity__c, Name, Multi_deal_Projected_GMS__c, Multi_Deal_Setup_Change_Date__c, Multi_Deal_Expiration_Date__c, Margin__c, Margin_Percent__c, MD_NPSID__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Individual_Purchase_Max__c, Id, Groupon_Share_of_GP__c, Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, G_Live_Margin_Override__c, GP__c, GMS__c, Final_Quantity_Paid__c, Feature_Date__c, Face_Value__c, Event_Start_Time__c, Event_Start_Date__c, Event_End_Date__c, Event_Category_Override__c, Estimated_Check_Ammount__c, Display_Order__c, Discount__c, Deal_Bank_Eligible__c, Current_Refund_Dollar_Amount__c, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, Category__c, CP_Projection__c, CC_Fee__c, CC_Fee_NEW__c, Buyer_Max__c, Bundling_Options__c, Bundle_Package_Calculator__c, Alternative_Highlights__c, Alternative_Expiration_Date__c, Alt_Exp_Date__c FROM multi_deal__c where id = :s LIMIT 1];
                opt = new option(md);
            //}

        return opt;
    }
//=========================HELPER METHODS===================
private string relevance(string s)
  {
    string relevance='';
    if(s==''){relevance = '';}else if(s=='Male'){relevance='male';}else if(s=='Female'){relevance='female';}else if(s=='Location'){relevance='proximity';}else if(s=='No Targeting'){relevance='';}
    return relevance;
  }
private string defer_voucher_release(string theId){
    string answer='';
    string vouch_release='';
    list<question__c> questions = [select id, Answer__c FROM question__c where Question_Bank__c = 'a0ZC0000002N5rM' AND opportunity__c = :theId];
    if(questions.size()>0)
        //vouch_release = questions[0].Answer__c;
        answer = questions[0].Answer__c;
        if(answer == '12 hours'){
                vouch_release = '12';
            }else if(answer == '24 hours'){
                vouch_release = '24';
            }else if(answer == '48 hours'){
                vouch_release = '48';
            }else if(answer == '72 hours'){
                vouch_release = '72';
            }else{
                vouch_release = null;
            }
    //Choose an option;12 hours;24 hours;48 hours;72 hours;N/A
    //a0ZC0000002N5rM
    return vouch_release;
}

}