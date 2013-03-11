@RestResource(urlMapping='/v1.0/commission/mgr/user/*')

global class RESTcommissionManagerViewAPI{

@HttpGET
global static CommissionResult get(){
    RestRequest req = RestContext.Request;
    CommissionResult cr;
    Id sales_rep_id;
    String month_name;
    if(req.params.containsKey('id')){
      sales_rep_id = req.params.get('id');
    }  
    if(req.params.containsKey('month')){
        month_name = req.params.get('month');
    }
    
    if(month_name!=null){
        Date start_date;
        if(month_name == 'January'){
            start_date = Date.Parse('1/1/2013');
        }else if(month_name == 'February'){
            start_date = Date.Parse('2/1/2013');
        }
        else if(month_name == 'March'){
            start_date = Date.Parse('3/1/2013');
        }
        cr = new CommissionResult(sales_rep_id, start_date );
    }else{
         cr = new CommissionResult(sales_rep_id);
    }
      
    try{
        cr.run();
        }catch(exception e){
            system.debug(e);
        }
    return cr;
    } 
}