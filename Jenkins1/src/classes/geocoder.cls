public class geocoder {
public merchant_addresses__c addy {get;set;}
    public geocoder(ApexPages.StandardController controller) {    
        if(ApexPages.currentPage().getParameters().get('id')!=null)addy = [SELECT Account__c, failed_geocode__c, City__c, Country__c, CreatedById, CreatedDate, IsDeleted, Enrollment_Feedback__c, Enrollment_Status__c, Full_Address__c, LastActivityDate, LastModifiedById, LastModifiedDate, Latitude__c, Longitude__c, Name, Merchant_Id__c, Phone_Number__c, ConnectionReceivedId, Id, Rewards_Transaction_Qualification_Status__c, Rewards_Transaction_Tracking_Status__c, neighborhood__c, ConnectionSentId, State_Province__c, Street_Line_1__c, Street_Line_2__c, Subdivision__c, Swipe_Registered__c, SystemModstamp, Terminal_ID__c, Test_Transaction_Date__c, Swipe_Completed__c, Venue_Name__c, Zip_Code__c, Zip_Postal_Code__c FROM Merchant_Addresses__c where id = :ApexPages.currentPage().getParameters().get('id')];

    }

public PageReference nextPage(){
    system.debug('addy id = ================'+ApexPages.currentPage().getParameters().get('id'));
    if(addy!=null){doCallOut(addy);}
    id i = [select id from Merchant_addresses__c where latitude__c = null AND failed_geocode__c !=true ORDER BY lastmodifiedDate asc LIMIT 1].id;
    PageReference pageRef = Page.geocode;
    pageRef.getParameters().put('id', i);
    return pageRef.setRedirect(true);
}
public void doCallOut(merchant_addresses__c addy){
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    string url = 'http://geodetails.groupondev.com/v1/coordinate.json?loc_string=';
    string address = addy.Street_Line_1__c+' ';
    if(addy.Street_Line_2__c!=null)address+=addy.Street_Line_2__c+' ';
    if(addy.city__c!=null)address+=addy.city__c+' ';
    if(addy.State_Province__c!=null)address+=addy.State_Province__c+' ';
    if(addy.Zip_Postal_Code__c!=null)address+=addy.Zip_Postal_Code__c+' ';
    req.setMethod('GET');
    string encoded = EncodingUtil.urlEncode(address, 'UTF-8');
    url+=encoded+'&key=salesforce_backfill';
    req.setEndpoint(url);
    HttpResponse res = h.send(req);
    system.debug('response body============'+res.getBody());
    system.debug('response code============='+res.getStatus());
    if(res.getStatusCode()==200){
        geocode g = (geocode)JSON.deserialize(res.getBody(), geocode.class);
        g.updateGeocode(addy);
    }else{
        addy.failed_geocode__c = true;
        update addy;
    }
}    
public class geocode{
    public boolean success {get;set;}
    public decimal lat {get;set;}
    public decimal lng {get;set;}
    public effectiveNeighborhood effectiveNeighborhood {get;set;}
    public void updateGeocode(merchant_addresses__c addy){
        addy.latitude__c = this.lat;
        addy.Longitude__c = this.lng;
        addy.neighborhood__c = this.effectiveNeighborhood.name;
        database.update(addy);
    }
    
}
public class effectiveNeighborhood{
        public string name {get;set;}
    }
}