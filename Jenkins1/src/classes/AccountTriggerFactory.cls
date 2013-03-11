public class AccountTriggerFactory
{
/*
public list<Account> triggerNew {get;set;}
public list<Account> triggerOld {get;set;}
public set<id> triggerNew_id_set{get;set;}
public set<id> triggerOld_id_set{get;set;}
public Map<Id,Account> triggernewmap{get;set;}
public Map<Id,Account> triggeroldmap{get;set;}
public list<address__c> addresses {get;set;}

list<taxonmyMap__c> taxList = new list<taxonmyMap__c>();
List<Id> AccountId= new List<Id>();
List<string> ServicesOfferedOld = new List<string>();
List<string> ServicesOfferedNew = new List<string>();
List<string> Category = new List<string>();
map <id,string> OldAcctStatus = new map <id,string>();
map <id,id> AcctIdPrevRepId = new map<id, id>();
map<string,taxonmyMap__c> taxMapNewV3 = new map<string,taxonmyMap__c>();

//Constructor
public AccountTriggerFactory(list<Account> triggerNew, list<Account> triggerOld, set<id>TriggerNewId, set<id> TriggerOldId,Map<Id,Account> Triggernmap,Map<Id,Account> Triggeromap)
    {
        this.triggerNew = triggerNew;
        this.triggerOld = triggerOld;
        this.triggerNew_id_set = TriggerNewId;
        this.triggerOld_id_set = TriggerOldId;
        this.triggernewmap = Triggernmap;
        this.triggeroldmap = triggeromap;
    }
    
//set up the data we will use, this manages all of the calls    
public void init()
    {
        buildAccountStatusMap();
        buildPrevOwnerMap();
        buildTaxonomyCollections();
    }
    
/*where the magic happens  
Triggers covered here : 
1) InsertACHupdateDate                :  insertACH()
2) rewardsStatus                      :  rewards()
3) PrevAcctOwner                      :  prevOwner()
4) updateTaxonmyAccount               :  updateTaxonomy()
5) insertSelectedTaxonomyRecordsAcct  :  insertTaxonomy()
6) ACHcheckSum                        :  achCheckSum()
7) SetNowDealClosedBy                 :  nowDealClosed()
*/

/*
public void run(){
    if(batchapexstop.stopbatchapex == false){

        init();
        for(account a: TriggerNew){              
            system.debug('LOOP 1 complete' + Limits.getQueries() + Limits.getLimitQueries());        
            insertACH(a);
            system.debug('LOOP 2 complete' + Limits.getQueries() + Limits.getLimitQueries());
            rewards(a);
            system.debug('LOOP 3 complete' + Limits.getQueries() + Limits.getLimitQueries());
            prevOwner(a);
            system.debug('LOOP 4 complete'+ Limits.getQueries() + Limits.getLimitQueries());
            updateTaxonomy(a);
            system.debug('LOOP 5 complete'+ Limits.getQueries() + Limits.getLimitQueries());
            insertTaxonomy(a);
            system.debug('LOOP 6 complete'+ Limits.getQueries() + Limits.getLimitQueries());
            achCheckSum(a);
            system.debug('LOOP 7 complete'+ Limits.getQueries() + Limits.getLimitQueries());
            nowDealClosed(a);
        }

        batchapexstop.stopbatchapex =true;
        system.debug('IS FIRING WAIT');
        }
    }
    
//*******************INIT FUNCTIONS****************************

public void buildAccountStatusMap()
    {
        rewardsOfferStatus ros = new rewardsOfferStatus(trigger.newMap.keySet());
        for(account a:triggerNew)
            {
                a.rewards_offer_status__c = ros.offerStatus.get(a.id);            
            }
    }
    
public void buildPrevOwnerMap()
    {
        for (account a: triggerOld)
            {
                OldAcctStatus.put(a.id,a.Account_Status__c);
                AcctIdPrevRepId.put (a.id, a.ownerid);
            }
    }
    
public void buildTaxonomyCollections()
    {
        taxList = [select id, Object__c, Category_v3__c, Subcategory_v3__c, newCategory__c, newSubcategory__c, newSubcategory1__c, direct__c from TaxonmyMap__c where Object__c = 'Lead/Account'];
        system.debug('----This is the Taxonomy List---- ' + taxList);
        
        for(taxonmyMap__c t : taxList)
            {
                taxMapNewV3.put(t.Subcategory_v3__c,t);
            }
    }

//*******************MODIFIER FUNCTIONS****************************

/*Capture the Last ACH Update date if any of the following fields are changed: Routing Number, Account Number, Billing Street, Billing City, 
  Billing State, Billing Zip, Billing Country, ,Make Checks Payable To, Payment Preference*/
  
/*
public void insertACH(account a)
    {        
        boolean updateCheck = false;            
        if(triggeroldmap.get(a.id).Routing_Number_enc__c != null && triggernewmap.get(a.id).Routing_Number_enc__c != null){
            if(triggeroldmap.get(a.id).Routing_Number_enc__c != triggernewmap.get(a.id).Routing_Number_enc__c){
                updateCheck = true;
            }
        }
                   
        if(triggeroldmap.get(a.id).Account_Number__c != null && triggernewmap.get(a.id).Account_Number__c != null){
            if(triggeroldmap.get(a.id).Account_Number__c != triggernewmap.get(a.id).Account_Number__c){
                updateCheck = true;
            }
        }
        
            system.debug('-----OLD BILLING STREET-----' + triggeroldmap.get(a.id).BillingStreet);
            system.debug('-----NEW BILLING STREET-----' + triggerNEWmap.get(a.id).BillingStreet);
        if(triggeroldmap.get(a.id).BillingStreet != triggernewmap.get(a.id).BillingStreet){
            system.debug('-----AM I GETTING HERE???-----');
            updateCheck = true;
        }
                             
        if(triggeroldmap.get(a.id).BillingCity != triggernewmap.get(a.id).BillingCity){
            updateCheck = true;
        }
                    
        if(triggeroldmap.get(a.id).BillingState != triggernewmap.get(a.id).BillingState){
            updateCheck = true;
        }
                    
        if(triggeroldmap.get(a.id).BillingPostalCode != triggernewmap.get(a.id).BillingPostalCode){
            updateCheck = true;
        }
                    
        if(triggeroldmap.get(a.id).BillingCountry != triggernewmap.get(a.id).BillingCountry){
            updateCheck = true;
        }
                    
        if(triggeroldmap.get(a.id).Make_Checks_Payable_To__c != triggernewmap.get(a.id).Make_Checks_Payable_To__c){
            updateCheck = true;
        }
                
        if(triggeroldmap.get(a.id).Payment_Preference__c != triggernewmap.get(a.id).Payment_Preference__c){
            updateCheck = true;
        }
                
        if(updateCheck){
            a.Last_ACH_Update__c = Date.Today();
        }      
    }

/*Populate the Rewards Offer Status field on the account. This should be "Live" if the current date is between feature start and end date, "Pulled" if
  the feature end date is in the past, and should be set to the opportunity stage if feature start and end dates are blank*/

/*
public void rewards(account a)
    {
        rewardsOfferStatus ros = new rewardsOfferStatus(triggernewmap.keySet());
        a.rewards_offer_status__c = ros.offerStatus.get(a.id);            
    }

/*Populate the Previous Account Owner field when Account Owner is changed*/

/*
public void prevOwner(account a)
    {
        if(a.ownerid != AcctIdPrevRepId.get(a.id))
            {
                a.previous_account_owner__c = AcctIdPrevRepId.get(a.id);
            }
    
        if(a.Account_Status__c != OldAcctStatus.get(a.id))
            {
                a.previous_acct_status__c = OldAcctStatus.get(a.id);   
            }
    }

/*Map the new V3 Taxonomy values to the Global SFDC Category and Subcategory fields using the Taxonomy Map object*/

/*
public void updateTaxonomy(account a)
    {
        // Maps from v3 taxonomy to global taxonomy
        if(a.Subcategory_v3__c != null && triggeroldmap.get(a.id).Subcategory_v3__c  != triggernewmap.get(a.id).Subcategory_v3__c)
            {
                system.debug('---------inside the new map: v3 to global and old');
                taxonmyMap__c t = new TaxonmyMap__c();
                t = taxMapNewV3.get(a.Subcategory_v3__c);
                if(t!=null && t.Object__c == 'Lead/Account')
                    {   
                        a.Global_SFDC_Category__c = t.newCategory__c;
                        a.Global_SFDC_Subcategory_1__c = t.newSubcategory__c;
                    }
            }
    }

/*Insert a Selected Taxonomy record when V3 taxonomy is entered. Update that record if the taxonomy is changed*/

/*
public void insertTaxonomy(account a)
    {
        list<insertSupportTaxonomyRecords.async_helper> async = new list<insertSupportTaxonomyRecords.async_helper>();
        if(triggeroldmap.get(a.id).Services_Offered__c != triggernewmap.get(a.id).Services_Offered__c)
            {
                AccountId.add(a.Id);
                            
                if(triggeroldmap.get(a.id).Services_Offered__c != null)
                    {
                        ServicesOfferedOld.add(triggeroldmap.get(a.id).Services_Offered__c);
                    }
                if(triggernewmap.get(a.id).Services_Offered__c != null)
                    {
                        ServicesOfferedNew.add(triggernewmap.get(a.id).Services_Offered__c);
                    }
                Category.add(triggernewmap.get(a.id).Category_v3__c);
                
                async.add(new insertSupportTaxonomyRecords.async_helper(AccountId,ServicesOfferedOld,ServicesOfferedNew,Category));
                insertSupportTaxonomyRecords.insertSupportTaxonomy(JSON.Serialize(async));
            }
            
        stopInsertSupportTaxonomyRecords.stopFutureCallout = true;
   } 

/*Check if the Routing Number is valid based on billing country and populate the Valid Routing #? field as Yes, No, or N/A (if payment preference is Check). Only for U.S.*/

/*
public void achCheckSum(account a)
    {
        if(a.Payment_Preference__c!='ACH (Direct Deposit)')
            {
                a.Valid_Routing__c = 'N/A';
            }
        else
            {
                a.Valid_Routing__c = 'N/A';
                if(a.Payment_Preference__c=='ACH (Direct Deposit)' && a.TransitNumber__c!=null && a.BillingCountry=='CA')
                    {
                        string newRouting='0';
                        a.Valid_Routing__c = 'N/A';
                        string rn = string.valueOf(a.TransitNumber__c);
                        rn=rn.replaceAll(' ','');
                        rn=rn.replaceAll('-','');
                        if(rn.length()==8)
                            {
                                string var1=string.valueOf(rn.substring(0,1));
                                string var2=string.valueOf(rn.substring(1,2));
                                string var3=string.valueOf(rn.substring(2,3));
                                string var4=string.valueOf(rn.substring(3,4));
                                string var5=string.valueOf(rn.substring(4,5));
                                string var6=string.valueOf(rn.substring(5,6));
                                string var7=string.valueOf(rn.substring(6,7));
                                string var8=string.valueOf(rn.substring(7,8));
                                newRouting+=var6;
                                newRouting+=var7;
                                newRouting+=var8;
                                newRouting+=var1;
                                newRouting+=var2;
                                newRouting+=var3;
                                newRouting+=var4;
                                newRouting+=var5;
                                a.Routing_Number_enc__c = newRouting;
                            }   
                    } 
            }      
    
        boolean ValidAch=false;
        system.debug('---------------before first If--- '+a.routing_number_enc__c);
            
        if(a.Payment_Preference__c!='ACH (Direct Deposit)')
            {
                a.Valid_Routing__c = 'N/A';
            }
        else if(a.Payment_Preference__c=='ACH (Direct Deposit)' && a.TransitNumber__c==null && a.routing_number_enc__c !=null && a.BillingCountry=='US')      
            {                     
                string rn = '-';
                if(a.Routing_Number_enc__c!=null)
                    {
                        rn = string.valueOf(a.Routing_Number_enc__c);
                        system.debug('---------------Inside 2nd If--- '+a.routing_number_enc__c);
                    }        
                if(rn.length()==9)
                    {
                        integer var1=integer.valueOf(rn.substring(0,1));
                        integer var2=integer.valueOf(rn.substring(1,2));
                        integer var3=integer.valueOf(rn.substring(2,3));
                        integer var4=integer.valueOf(rn.substring(3,4));
                        integer var5=integer.valueOf(rn.substring(4,5));
                        integer var6=integer.valueOf(rn.substring(5,6));
                        integer var7=integer.valueOf(rn.substring(6,7));
                        integer var8=integer.valueOf(rn.substring(7,8));
                        integer var9=integer.valueOf(rn.substring(8,9));
                                            
                        integer CheckSum=((var1*3)+(var2*7)+(var3*1)+(var4*3)+(var5*7)+(var6*1)+(var7*3)+(var8*7)+(var9*1));
                        integer remainder = math.mod(checksum,10);
                        if(checksum != 0 && remainder==0 && integer.valueOf(rn.substring(0,1))!=5)
                            {
                                ValidAch=true;
                            }
                    }
            }
                 
        if(validACH==true)
            {
                a.Valid_routing__c='Yes';
            }
        else if(validACH==false && a.Payment_Preference__c=='ACH (Direct Deposit)' && a.routing_number_enc__c !=''&& a.billingcountry=='US')
            {
                a.Valid_routing__c='No';
            }
        else
            {
                a.Valid_Routing__c = 'N/A';
            }
    }

/*Populate the Now! Deal Closed By field when the stage on a GrouponNow deal is set to Closed Won */

/*
public void nowDealClosed(account a)
    {
        if(a.now_deal_closed_by__c==null && a.now_status__c =='closed won' && a.now_deal_owner__c != null )    
            {
                a.now_deal_closed_by__c = a.now_deal_owner__c;
            }
    }

@isTest
static void AccountTest(){
 Profile p = [select id from profile where name='System Administrator'];
                     User u = new User(alias = 'standt', email='AccountTriggerFactory@groupon.com',
                     emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                     localesidkey='en_US', profileid = p.Id,
                     timezonesidkey='America/Los_Angeles', username='AccountTriggerFactory@groupon.com');
                     insert u;
        //run as user
        System.RunAs(u) {
        
            taxonmyMap__c t = new taxonmyMap__c(Object__c = 'Lead/Account', Category_v3__c = 'Food & Drink', Subcategory_v3__c = 'Bar / Club / Hall', newCategory__c = 'Restaurant', newSubcategory__c = 'Bar'); 
            insert t;
            
            list<taxonmyMap__c> taxList = [select id, Subcategory_v3__c from taxonmyMap__c where id =: t.id];
            
            division__c d = new division__c(name = 'test',state__c = 'CA'); 
            insert d;
            
            subdivision__c s = new subdivision__c(name = 'Downtown - South(Chicago)', Is_Active__c = True);
            insert s;
            
            Zip_Code__c z = new Zip_Code__c(name = '60601', Subdivision__c = s.Id);
            insert z;
            
            Account a1 = new Account(name='achAcct Canada Test Ipsum' + system.now(), OwnerId = u.id, BillingStreet = '123 Canada Street', BillingCity = 'Victoria', BillingState = 'BC', BillingPostalCode = 'V5Y 1V4', BillingCountry='CA', eligibility__c='Eligible', Tax_Identification_Number__c ='12345', TransitNumber__c = '87654321', Routing_Number_enc__c ='89456124', Payment_Preference__c='ACH (Direct Deposit)', Category_v3__c = 'Food & Drink',Subcategory_v3__c = 'Bar / Club / Hall',Services_Offered__c = 'Club / Music Venue');
            insert a1;
            
            }
}
@isTest
static void AccountTriggerFactory()
    {
        Profile p = [select id from profile where name='System Administrator'];
                     User u = new User(alias = 'standt', email='AccountTriggerFactory@groupon.com',
                     emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                     localesidkey='en_US', profileid = p.Id,
                     timezonesidkey='America/Los_Angeles', username='AccountTriggerFactory@groupon.com');
                     insert u;
        //run as user
        System.RunAs(u) {
        
            taxonmyMap__c t = new taxonmyMap__c(Object__c = 'Lead/Account', Category_v3__c = 'Food & Drink', Subcategory_v3__c = 'Bar / Club / Hall', newCategory__c = 'Restaurant', newSubcategory__c = 'Bar'); 
            insert t;
            
            list<taxonmyMap__c> taxList = [select id, Subcategory_v3__c from taxonmyMap__c where id =: t.id];
            
            division__c d = new division__c(name = 'test',state__c = 'CA'); 
            insert d;
            
            subdivision__c s = new subdivision__c(name = 'Downtown - South(Chicago)', Is_Active__c = True);
            insert s;
            
            Zip_Code__c z = new Zip_Code__c(name = '60601', Subdivision__c = s.Id);
            insert z;
            
            Account a = new Account(name='achAcct Test Ipsum' + system.now(), OwnerId = u.id, BillingStreet = '303 E. Wacker', BillingCity = 'Chicago', BillingState = 'IL', BillingPostalCode = '60601', BillingCountry='US', eligibility__c='Eligible', Tax_Identification_Number__c ='12345', Routing_Number_enc__c ='789456124', Payment_Preference__c='ACH (Direct Deposit)', Category_v3__c = 'Food & Drink',Subcategory_v3__c = 'Bar / Club / Hall',Services_Offered__c = 'Club / Music Venue');
            insert a;
                                                                
            opportunity o = new opportunity();
            o.name = 'Rewards Deal';
            o.OwnerId = u.id;
            o.RecordTypeId = '012C0000000UK9N';
            o.StageName = 'Prospecting';
            o.CloseDate = date.today();
            o.Feature_Date__c = date.today();
            o.Groupon_Expiration_Date__c = date.today();
            o.AccountId = a.Id;
            o.Division_Dynamic__c  = d.Id;
            insert o;
            
            Merchant_Addresses__c addy = new Merchant_Addresses__c();
            addy.Account__c = a.id;
            addy.Street_Line_1__c = '303 E Wacker Dr';
            addy.Street_Line_2__c = '26th Floor';
            addy.City__c = 'Chicago';
            addy.State_Province__c = 'IL';
            addy.Zip_Postal_Code__c = '60601';
            addy.Country__c = 'US';
            insert addy;
            
            a.BillingStreet = '600 W. Chicago';
            a.BillingCity = 'Chi';
            a.BillingState = 'IL';
            a.BillingPostalCode = '60654';
            a.BillingCountry='US';
            update a;

           }
    }
*/
}