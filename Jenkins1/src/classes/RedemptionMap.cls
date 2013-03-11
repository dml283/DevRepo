public class RedemptionMap {

public Id recordId {get;set;}

//Create a constructor for the Apex Standard Controller & assign the record Id 
public RedemptionMap(ApexPages.StandardController controller) {
    recordId = controller.getId();
}
public RedemptionMap (){}
// method to get a list of Markers related to the Opportunity currently being displayed
public String getMarkers(){
    List<Marker> markers = new List<Marker>();
    if(recordId !=null){
        for(address__c a : database.query(getQuery())){
            markers.add(new Marker(a));
        }
    }
    return JSON.serialize(markers);
}         
//Google Maps Marker Class, this holds the Lat/Lng and the data for the InfoWindow       
public class marker{
    public Decimal lat {get;set;}
    public Decimal lng {get;set;}
    public Id Id {get;set;}
    public String fullAddress {get;set;}
    public String StreetLine1 {get;set;}
    public String StreetLine2 {get;set;}
    public String City {get;set;}
    public String State {get;set;}
    public String Zip {get;set;}
    public String Country {get;set;}
    public String VenueName {get;set;}
    public String Neighborhood {get;set;}
    public String Subdivision {get;set;}
    public String Phone {get;set;}
    
    public Marker(address__c address){
        this.lat = address.Merchant_Addresses__r.Latitude__c;
        this.lng = address.Merchant_Addresses__r.Longitude__c;
        this.fullAddress = address.Full_Address__c;
        this.StreetLine1 = address.Street_Line_1__c;
        this.StreetLine2 = address.Street_Line_2__c;
        this.City = address.City__c;
        this.State = address.State__c;
        this.Zip = address.Zip_Postal_Code__c;
        this.Country = address.Country__c;
        this.VenueName = address.Venue_Name__c;
        this.Id = address.Merchant_Addresses__c;
        this.Neighborhood = address.Neighborhood__c;
        this.Subdivision = address.Subdivision__r.Name;
        this.Phone = address.Phone_Number__c;
    }
    //default contrsuctor
    public marker(){}
}
//query string for Redmeption Addresses
public string getQuery(){
    string query;
    query = 'SELECT id, Merchant_Addresses__c, Merchant_Addresses__r.Latitude__c, Merchant_Addresses__r.Longitude__c, Street_Line_1__c, Street_Line_2__c, City__c, State__c, Zip_Postal_Code__c, Country__c , Venue_Name__c , Neighborhood__c , Subdivision__r.name, Phone_Number__c, Full_Address__c FROM Address__C where opportunity__c = \''+recordId+'\'';
    return query;
}

private static testMethod void verifyMarkers(){
    grouponTestUtil  util = new grouponTestUtil();
    Opportunity oppty = util.createDeal();
    insert oppty;
    address__c addy = util.createRedemptionAddress();
    addy.opportunity__c = oppty.id;
    insert addy;
    
    RedemptionMap rm = new RedemptionMap();
    rm.recordId = oppty.id;
    
    string jsonString = rm.getMarkers();
    
}
}