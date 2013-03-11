@RestResource(urlMapping='/v1.0/divisions/goals/*')
/*
API Version 1.0
Author: Chris Bland
Support: CBland@groupon.com

##########
===Methods===

*/

global class RESTgoalAPI{
@HttpGet
  global static list<Division_Goals.division_goal> getDivisionGoals(RestRequest req, RestResponse res) {
  Division_Goals d = new Division_Goals();
  date start_date = date.valueOf(req.params.get('start_date'));
  date end_date = date.valueOf(req.params.get('end_date'));
  string division = req.params.get('division');
    //Call our method and get the Divisions
    try{
            return d.getDivisionGoal(division,start_date,end_date);
        }catch(exception e){
                            string ErrorString = 'There was an error with your request and it was: '+e;
                          //  return ErrorString;
                          return null;
                            }     
  }

}