global class PerfectpipelineAPI_V4
{
public list<opportunity> opportunities {get;set;}
public map<id,list<address>> addy_map {get;set;}
public map<id,list<string>> target_zip_codes {get;set;} 
public list<opportunity> location_list = new list<opportunity>();
global PerfectpipelineAPI_V4(string division,date start_date, date end_date){
    this.addy_map = new map<id,list<address>>(); 
    this.target_zip_codes = new map<id,list<string>>();
    this.opportunities = database.query(getopportunity(division,start_date,end_date));
    location_list = database.query(getLocations(division,start_date,end_date));
         for(opportunity o: location_list ){
             list<address> addy_list = new list<address>();
             for(Address__c a : o.Addresses__r){
                     addy_list.add(new address(a));
                 }
             addy_map.put(o.id,addy_list);      
         }
         for(opportunity o: location_list ){
             list<string> zip = new list<string>();
             for(target_zip__c t:o.Target_Zips__r){
                 zip.add(t.Target_Zip_Code__c);
             }
          target_zip_codes.put(o.id,zip); 
         }
}
public string getopportunity(string division,date start_date,date end_date)
{
string start_date_val = string.valueof(start_date);
string end_date_val   = string.valueof(end_date);
start_date_val = start_date_val.substring(0,10);
end_date_val   = end_date_val.substring(0,10);

string query = '';
    query += 'SELECT id,feature_date__c,Redeem_At__c,Division__c,type,Division_Dynamic__r.permalink__c FROM Opportunity where ';
    if(division.length()>0)
      {
       query +='Division_Dynamic__r.name = \''+division+'\' AND ';
      }
    query += 'Feature_Date__c >= '+start_date_val+'AND Feature_Date__c <='+end_date_val+'AND Feature_Date__c !=null AND Type != \'Social Media\' AND Type != \'Sponsorship\' AND Type != \'G-Team\' ';
return query;
}
public string getlocations(string division,date start_date,date end_date)
{
string start_date_val = string.valueof(start_date);
string end_date_val   = string.valueof(end_date);
start_date_val = start_date_val.substring(0,10);
end_date_val   = end_date_val.substring(0,10);
string Query = '';
Query += 'SELECT id,(select id, Target_Zip_Code__c FROM Target_Zips__r),(select City__c, Country__c, State__c,  Street_Line_1__c, Street_Line_2__c, Zip_Postal_Code__c, merchant_addresses__r.Longitude__c,merchant_addresses__r.Latitude__c FROM Addresses__r) FROM Opportunity where ';
if(division.length()>0)
      {
       query +='Division_Dynamic__r.name = \''+division+'\' AND ';
      }
 query += 'Feature_Date__c >= '+start_date_val+' AND Feature_Date__c <='+end_date_val;
return query;
}
public list<pipeline> getPipeline(){
        list<pipeline> pipelines = new list<pipeline>();
        for(opportunity o:opportunities){       
                pipelines.add(new pipeline(o,addy_map.get(o.id),target_zip_codes.get(o.id)));
            }
        return pipelines;    
    }
global class Pipeline{
            public string             type{get;set;}
            public string             DealType{get;set;}
            public date               feature_start_date{get;set;}
            public id                 RecordId{get;set;}
            public list<address>      locations {get;set;}
            public list<string>       targetingZipCodes{get;set;}
            public string             redeem_at{get;set;}
            public string             division{get;set;}
            public string             division_permalink{get;set;}
      public pipeline(Opportunity o,list<address> addy_list,list<string> zips){
            this.type                  ='Deal';
            this.Dealtype             = o.type;
            this.feature_start_date    = o.feature_date__c;
            this.recordId              = o.Id;
            this.locations             = addy_list;
            this.targetingZipCodes     = zips; 
            this.redeem_at             = o.Redeem_At__c;
            this.division              = o.division__c;
            this.division_permalink    = o.Division_Dynamic__r.permalink__c;
        }
}
     public class Address{
            public string street_1 {get;set;}
            public string street_2 {get;set;}
            public string city {get;set;}
            public string state {get;set;}
            public string zip {get;set;}
            public string country {get;set;}
            public id salesforce_id {get;set;}   
            public decimal lat {get;set;}
            public decimal lng {get;set;}
            
            public address(Address__c a){
                  this.street_1         = a.Street_Line_1__c;
                  this.street_2         = a.Street_Line_2__c;
                  this.city             = a.city__c;
                  this.state            = a.State__c;
                  this.zip              = a.zip_postal_code__c;
                  this.country          = a.country__c;
                  this.salesforce_id    = a.id;
                  this.lng              = a.merchant_addresses__r.Longitude__c;
                  this.lat              = a.merchant_addresses__r.Latitude__c;
              }
          }   
@Istest
public static void testme_WithDivision()
{
string division = 'Chicago';
date start_date = date.today()-10;
date end_date   = date.today()+10;
grouponTestUtil test_util = new grouponTestUtil();
Account Acc = new Account();
Acc.name = 'Test Account';
Insert Acc;

division__c div = new division__c();
div.name = division;
div.state__c = 'IL';
Insert div;

Opportunity Opp = new opportunity();
opp.name = 'Test name';
opp.StageName = 'Prospecting';
opp.CloseDate = date.today();
opp.AccountId = Acc.Id;
opp.Type = 'Side Deal';
opp.Feature_Date__c = date.today()+4;
opp.Division_Dynamic__c = div.Id;
Insert Opp;

address__c addy = new address__c();
addy.Opportunity__c = Opp.Id;
Insert addy;
PerfectpipelineAPI_V4 api_Instance = new PerfectpipelineAPI_V4(division,start_date,end_date);
}  
}