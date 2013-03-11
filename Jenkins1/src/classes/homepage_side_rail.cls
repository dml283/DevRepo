public class homepage_side_rail {
public string gp_goal {get;set;}
public string actual_gp{get;set;}
public string refunds_week {get;set;}
public string refunds_month {get;set;}
public string contract_actual {get;set;}
public string contract_goal {get;set;}
public decimal gp_percent {get;set;}
public decimal contract_percent {get;set;}
public Sales_Goal__c sales_goal {get;set;}

public homepage_side_rail(){
        date today = system.today();
        try{
                aggregateResult[] gp_act = database.query(getSOQLgp());
                  for (AggregateResult ar : gp_act) {
                      if(string.valueOf(ar.get('gp'))!=null){
                          this.actual_gp = string.valueOf(ar.get('gp'));
                          }else{this.actual_gp='0';}
                  }
        }catch(exception e){this.actual_gp='0';}
        try{
                aggregateResult[] refunds = database.query(getSOQLrefundsMonth());
                  for (AggregateResult ar : refunds) {
                      if(string.valueOf(ar.get('refund'))!=null){
                          this.refunds_month = string.valueOf(ar.get('refund'));
                          }else{this.refunds_month='0';}
                  }
        }catch(exception e){this.refunds_month='0';}
        try{
                aggregateResult[] refunds_week = database.query(getSOQLrefundsWeek());
                  for (AggregateResult ar : refunds_week) {
                      if(string.valueOf(ar.get('refund'))!=null){
                          this.refunds_week = string.valueOf(ar.get('refund'));
                          }else{this.refunds_week='0';}
                  }
        }catch(exception e){this.refunds_week='0';}
        try{
                aggregateResult[] contracts = database.query(getSOQLclosedDeals());
                  for (AggregateResult ar : contracts) {
                      system.debug('val of contacts=========='+string.valueOf(ar.get('contacts')));
                      if(string.valueOf(ar.get('contacts'))!='0'){
                          system.debug('ok we got in the loop');
                          this.contract_actual = string.valueOf(ar.get('contacts'));
                          }else{this.contract_actual='0';}
                  }
        }catch(exception e){this.contract_actual='0';}
        try{
            sales_goal = [select id, GP_Goal__c, Contract_Goal__c FROM sales_goal__c WHERE ownerid = :UserInfo.getUserId() AND Goal_Start_Date__c < :today AND Goal_End_Date__c >:today LIMIT 1];
            if(sales_goal.gp_goal__c!=null){
                this.gp_goal=string.valueOf(sales_goal.gp_goal__c);
                }else{this.gp_goal='0';}
            if(sales_goal.Contract_Goal__c!=null){
                this.contract_goal=string.valueOf(sales_goal.Contract_Goal__c);
                }else{this.contract_goal='0';}
            if(this.gp_goal!='0'){
                this.gp_percent=(decimal.valueOf(this.actual_gp).divide(decimal.valueOf(this.gp_goal),2,System.RoundingMode.UP)*100);
                }else{this.gp_percent=0;}
            if(this.contract_goal!='0'){
                this.contract_percent=(decimal.valueOf(this.contract_actual).divide(decimal.valueOf(this.contract_goal),2,System.RoundingMode.UP)*100);
                }else{this.contract_percent=0;}           
            }catch(exception e){
                this.gp_goal='0';
                this.contract_goal='0';
                this.contract_percent=0;
                this.gp_percent=0;
                }
 
    }

//Gets the User ID
public id getUserId() {
id UserID = UserInfo.getUserId();
return UserID;
}
//Gets the User Name
public string getUserName() {
string UserName = UserInfo.getName();
return UserName;
}
public string getSOQLgp(){
string soql = 'SELECT sum(Total_GP__c)gp FROM Opportunity WHERE '+getWhere('gp')+' AND feature_date__c = this_month';
return soql;
}
public string getSOQLrefundsWeek(){
string soql = 'SELECT sum(Sum_of_Refunds__c)refund FROM Financial_Records__c WHERE '+getWhere('refund')+' AND Collection_Date__c = this_week';
return soql;
}

public string getSOQLrefundsMonth(){
string soql = 'SELECT sum(Sum_of_Refunds__c)refund FROM Financial_Records__c WHERE '+getWhere('refund')+' AND Collection_Date__c = this_month';
return soql;
}
public string getSOQLclosedDeals(){
string soql ='SELECT count(id)contacts FROM Opportunity WHERE '+getWhere('gp')+' AND closedate = this_month AND stageName=\'Closed Won\'';
return soql;
}

public string getWHERE(string type){
    string filter ='';
    user u = [select id, profile.name from USER where id = :UserInfo.getUserId()];
    string profile = u.profile.name;
    if((profile=='Inside Sales'||profile=='Outside Sales') && type=='gp'){
        filter=' ownerid = \''+UserInfo.getUserId()+'\'';    
        }
    if(profile=='System Administrator' && type=='gp'){
        filter=' ownerid = \''+UserInfo.getUserId()+'\'';    
        }    
    if(profile=='Merchant Manager' && type=='gp'){
        filter=' account.Account_Manager__c = \''+UserInfo.getUserId()+'\'';    
        }
    if((profile=='Inside Sales'||profile=='Outside Sales') && type=='refund'){
        filter=' opportunity__r.ownerid = \''+UserInfo.getUserId()+'\'';    
        }
    if(profile=='System Administrator' && type=='refund'){
        filter=' opportunity__r.ownerid = \''+UserInfo.getUserId()+'\'';    
        }    
    if(profile=='Merchant Manager' && type=='refund'){
        filter=' opportunity__r.account.Account_Manager__c = \''+UserInfo.getUserId()+'\'';    
        }        
    return filter;
}
static testMethod void testSideRailDashboard() {
        homepage_side_rail hr = new homepage_side_rail();
        Profile p = [select id from profile where name='System Administrator'];
        
        User u = new User(alias = 'standt', email='standarduser@groupon.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');

        System.RunAs(u){
                sales_goal__c sg = new sales_goal__c();
                try{
                insert sg;
                }catch(exception e){system.debug(e);}
                homepage_side_rail hr2 = new homepage_side_rail();
                string un = hr2.getUserName();
                id i = hr2.getUserID();
        }
}
}