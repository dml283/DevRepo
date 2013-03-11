@RestResource(urlMapping='/v1.0/divisions/all')
/*
API Version 1.0
Author: Chris Bland
Support: CBland@groupon.com
Classes included: Division_Subdivision_API.cls <==where the magic happens

##########
===Methods===

*/

global class RESTdivisionAPI{
@HttpGet
  global static list<Division_Subdivision_API.division> getDivisions(RestRequest req, RestResponse res) {
  Division_Subdivision_API d = new Division_Subdivision_API();
    //Call our method and get the Divisions
    try{
            return d.getDivisions();
        }catch(exception e){
                            string ErrorString = 'There was an error with your request and it was: '+e;
                          //  return ErrorString;
                          return null;
                            }     
  }

}