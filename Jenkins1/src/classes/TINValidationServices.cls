public with sharing class TINValidationServices {
  public String tin {get; set;}
  public String legal_name {get; set;}
  public Http http {get; set;}
  public HttpRequest req {get; set;}
  public HttpResponse res {get; set;}
  //Create Custom Setting
  final String baseEndpoint = 'https://msse-staging.groupondev.com/v0/validations/tin_validation';

  public TINValidationServices (String tin, String legal_name) {
    this.tin = tin;
    this.legal_name = legal_name;
    this.req = new HttpRequest();
    this.req.setMethod ('GET');
    this.req.setEndpoint (getURL(tin, legal_name));
    this.req.setTimeout(60000);
    this.http = new Http();
  }

  public string getURL (String tin, String legal_name) {
    string params = '?tin='
                    + EncodingUtil.urlEncode (tin, 'UTF-8')
                    + '&legal_name='
                    + EncodingUtil.urlEncode (legal_name, 'UTF-8');
    return baseEndpoint + params;
  }

  public void sendRequest() {
    res = http.send (req);
  }

  public boolean isRequestValid() {
    if (res.getStatusCode() == 200) {
      return true;
    } else {
      return false;
    }
  }

  public class TinStatus {
    public String valid {get; set;}
    public String feedback {get; set;}
  }

  
  public string returnStatus () {
    String tin_status;
    sendRequest();
    TinStatus ts = (TinStatus)JSON.deserialize (res.getBody(), TinStatus.class);
    if (isRequestValid()) {
      if (ts.valid == 'true'){
        tin_status = 'Valid';
        return tin_status;
      }else {
        tin_status = 'Invalid';
        return tin_status;
      }
    } else {
      tin_status = 'Invalid';
      return tin_status;
    }
  }
}