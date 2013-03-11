@RestResource(urlMapping='/v1.0/commission')

global class RESTcommissionAPI{

@HttpGET
global static CommissionResult get(){
    RestRequest req = RestContext.Request;
    CommissionResult cr;
    if(req.params.containsKey('month')){
        Date start_date;
        String month = req.params.get('month');
        if(month == 'January'){
            start_date = Date.Parse('1/1/2013');
        }else if(month == 'February'){
            start_date = Date.Parse('2/1/2013');
        }
        else if(month == 'March'){
            start_date = Date.Parse('3/1/2013');
        }
        cr = new CommissionResult(UserInfo.getUserID(), start_date);
    }else{
    
        cr = new CommissionResult();
    }
    try{
        cr.run();
        }catch(exception e){
            system.debug(e);
        }
    return cr;
    } 
}