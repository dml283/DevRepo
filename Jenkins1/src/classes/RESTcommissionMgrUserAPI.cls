@RestResource(urlMapping='/v1.0/commission/mgr')

global class RESTcommissionMgrUserAPI{

@HttpGET
global static list<user> get(){
    list<User> users = new list<User>();
    set<Id> ids = new set<Id>();
    Id currentUser = UserInfo.getUserId();
    
    list<sales_goal__c> goals = new list<sales_goal__c>();
    goals  = [select ownerid FROM Sales_goal__c where Goal_Start_Date__c = this_month AND DSM__c = :currentUser];
    for(sales_goal__c sg : goals){
        ids.add(sg.ownerid);
    }
    users = [select id, name from User where id = :ids ORDER BY name ASC];
    return users;
}

}