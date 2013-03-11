@RestResource(urlMapping='/v1.0/merchants/markers')

global class RESTmerchant_map_markerAPI{

@HttpGET
global static list<merchant> get(){
    list<merchant> merchants = new list<merchant>();
    for(account a : [select id, name, category_v3__c, subcategory_v3__c, Most_Recent_Feature__c, Most_Recent_Expiry_Date__c, Most_Recent_Last_Close_Date__c, (select id, Latitude__c, Longitude__c, Full_Address__c FROM Merchant_Addresses__r) FROM account where ownerid = :UserInfo.getUserId()]){
        merchants.add(new merchant(a));
    }

    return merchants;
}
global class merchant{
    public list<marker> markers {get;set;}
    public string name {get;set;}
    public string category {get;set;}
    public string subcategory {get;set;}
    public list<string> services {get;set;}
    public id id {get;set;}
    public string most_recent_feature {get;set;}
    public string most_recent_close {get;set;}
    public string most_recent_expiration {get;set;}
    
    public merchant(account a){
        this.name = a.name;
        this.id = a.id;
        this.category = a.category_v3__c;
        this.subcategory = a.subcategory_v3__c;
        if(a.Most_Recent_Feature__c!=null){
            this.most_recent_feature = a.Most_Recent_Feature__c.format();
        }else{
            this.most_recent_feature = '';
        }
        if(a.Most_Recent_Last_Close_Date__c!=null){
            this.most_recent_close = a.Most_Recent_Last_Close_Date__c.format();
        }else{
            this.most_recent_close = '';
        }
        if(a.Most_Recent_Expiry_Date__c!=null){
            this.most_recent_expiration = a.Most_Recent_Expiry_Date__c.format();
        }else{
            this.most_recent_expiration = '';
        }
        this.markers = new list<marker>();
        for(Merchant_Addresses__c ma : a.Merchant_Addresses__r){
            this.markers.add(new marker(ma));
        }
    }
}    
   
global class marker{
    public latlng latlng {get;set;}
    public string address {get;set;}
    public marker (Merchant_Addresses__c ma){
        this.address = ma.Full_Address__c;
        this.latLng = new latLng();
            this.latlng.lat = ma.Latitude__c;
            this.latlng.lng = ma.Longitude__c;
    }
    public marker (lead l){
        //this.address = l.address;
        this.latlng = new latLng();
             this.latlng.lat = l.Latitude__c;
             this.latlng.lng = l.Longitude__c;
    }
} 
public class LatLng{
        public decimal lat {get;set;}
        public decimal lng {get;set;}
    }    
}