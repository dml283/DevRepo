public class bulk_geocoder {
  public bulk_geocoder() {}

  public bulk_geocoder (ApexPages.StandardController stdController) {
    this.acct_id = stdController.getId();
    if (this.acct_id != null) {
      this.merch_addy = [select id, Street_Line_1__c, Street_Line_2__c, city__c, State_Province__c, precision__c, Accuracy__c,  Zip_Postal_Code__c, country__c, latitude__c, Longitude__c, neighborhood__c, failed_geocode__c, Failed_Geo_Code_Reason__c FROM merchant_addresses__c WHERE failed_geocode__c != true AND latitude__c = null AND account__c = : this.acct_id LIMIT 5];
    }
  }
  public void geocode() {
    if (this.merch_addy != null) {
      for (merchant_addresses__c ma : this.merch_addy) {
        doCallOut (ma);
      }
    }
  }
  public id acct_id {get; set;}
  public list<merchant_addresses__c> merch_addy {get; set;}

  public void doCallOut (merchant_addresses__c addy) {
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    string url = 'http://geodetails.groupondev.com/v1/coordinate.json?loc_string=';
    string address = addy.Street_Line_1__c + ' ';
    if (addy.Street_Line_2__c != null) {
      address += addy.Street_Line_2__c + ' ';
    }
    if (addy.city__c != null) {
      address += addy.city__c + ' ';
    }
    if (addy.State_Province__c != null) {
      address += addy.State_Province__c + ' ';
    }
    if (addy.Zip_Postal_Code__c != null) {
      address += addy.Zip_Postal_Code__c + ' ';
    }
    if (addy.country__c != null) {
      address += addy.country__c + ' ';
    }
    req.setMethod ('GET');
    string encoded = EncodingUtil.urlEncode (address, 'UTF-8');
    url += encoded + '&key=salesforce';
    req.setEndpoint (url);
    HttpResponse res = h.send (req);
    if (res.getStatusCode() == 200) {
      geocode g = (geocode) JSON.deserialize (res.getBody(), geocode.class);
      g.updateGeocode (addy);
    } else {
      GeocodeError geoFailureError = (GeocodeError)JSON.deserialize (res.getBody(), GeocodeError.class);
      addy.failed_geocode__c = true;
      addy.latitude__c = null;
      addy.Longitude__c = null;
      addy.GeoCode_Date__c = system.today();
      addy.Failed_Geo_Code_Reason__c = geoFailureError.error;
      database.update (addy);
    }
  }
  public class geocode {
    public boolean success {get; set;}
    public decimal lat {get; set;}
    public decimal lng {get; set;}
    public string precision {get; set;}
    public decimal accuracy {get; set;}
    public effectiveNeighborhood effectiveNeighborhood {get; set;}

    public void updateGeocode (merchant_addresses__c addy) {
      addy.latitude__c = this.lat;
      addy.Longitude__c = this.lng;
      addy.accuracy__c = this.accuracy;
      addy.precision__c = this.precision;
      addy.neighborhood__c = this.effectiveNeighborhood.name;
      addy.GeoCode_Date__c = system.today();
      database.update (addy);
    }
    public void updateGeocodeLead (lead l) {
      l.latitude__c = this.lat;
      l.Longitude__c = this.lng;
      l.neighborhood__c = this.effectiveNeighborhood.name;
      database.update (l);
    }

  }
  public class effectiveNeighborhood {
    public string name {get; set;}
  }
  public class GeocodeError {
    public string error {get; set;}
  }
}