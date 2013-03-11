@RestResource(urlMapping='/v1.0/deal-locations')
/*
API Version 1.0
Author: Chris Bland
Support: CBland@groupon.com
Classes included: DealAPI.cls <==where the magic happens

##########
===Methods===
httpGet = Deals?id={SALESFORCE OPPORTUNITY ID}
returns a JSON Obj that is ready for Deal Import
*/

global class RESTlocationAPI{
@HttpGet
  global static list<String> getLocationJSON(RestRequest req, RestResponse res) {
      return null;
  }
    

}