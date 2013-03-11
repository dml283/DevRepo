@RestResource(urlMapping='/v1.0/contracts')

global class RESTcontractAPI{

@HttpGET
global static contract_list getMyContrats(){
     contract_list cl = new contract_list();
     return cl;
    }
global class contract_list{
    public list<contract> outstanding {get;set;}
    public list<contract> closed {get;set;}
    public list<contract> prospecting {get;set;}
    
    public contract_list(){
        this.outstanding = new list<contract>();
        this.closed = new list<contract>();
        this.prospecting = new list<contract>();
        for(opportunity o : [select id, name, accountid, account.name, stageName, closeDate,createdDate,category_v3__c, subcategory_v3__c, (Select ID, echosign_dev1__DateSentDate__c FROM echosign_dev1__R00N70000001hM2REAU__r) FROM opportunity where ownerid = :UserInfo.getUserId() AND stageName = 'Closed Won' AND closeDate = this_month]){
            closed.add(new contract(o));
        }
        for(opportunity o : [select id, name, accountid, account.name, stageName, closeDate,createdDate,category_v3__c, subcategory_v3__c, (Select ID, echosign_dev1__DateSentDate__c FROM echosign_dev1__R00N70000001hM2REAU__r) FROM opportunity where ownerid = :UserInfo.getUserId() AND stageName = 'Contract Sent']){
            outstanding.add(new contract(o));
        }
        for(opportunity o : [select id, name, accountid, account.name, stageName, closeDate,createdDate,category_v3__c, subcategory_v3__c FROM opportunity where ownerid = :UserInfo.getUserId() AND stageName = 'Prospecting']){
            prospecting.add(new contract(o));
        }        
    }
    
}    
global class contract{
    public string merchant_name {get;set;}
    public string deal_name {get;set;}
    public string date_sent {get;set;}
    public string stage {get;set;}
    public string close_date {get;set;}
    public string created_date {get;set;}
    public string category {get;set;}
    public string subcategory {get;set;}
    public id salesforce_id {get;set;}
    public integer days_outstanding{get;set;}
    public integer days_since_created {get;set;}
    public id account_id {get;set;}
    
    public contract(opportunity o){
        this.merchant_name = o.account.name;
        this.deal_name = o.name;
        this.date_sent = '';
        this.stage = o.stageName;
        if(o.closeDate!=null){
            this.close_date = o.closeDate.format();
            }
        if(o.createddate!=null){
            this.created_date = date.valueOf(o.createddate).format();
            this.days_since_created = date.valueOf(o.createddate).DaysBetween(system.today());
            }
        this.category= o.Category_v3__c;
        this.subcategory = o.Subcategory_v3__c;
        this.salesforce_id = o.id;
        this.account_id = o.accountid;
        for(echosign_dev1__SIGN_Agreement__c e : o.echosign_dev1__R00N70000001hM2REAU__r){
          if(e.echosign_dev1__DateSentDate__c!=null){
            this.date_sent = e.echosign_dev1__DateSentDate__c.format();
            this.days_outstanding = e.echosign_dev1__DateSentDate__c.daysBetween(system.today());
            }
        }
        
    }
}    
private static testMethod void myTest() {
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    RestContext.request = req;
    RestContext.response = res;
    string endcoded = EncodingUtil.urlencode('Food & Drink','UTF-8');
    RestContext.request.addParameter('category', endcoded);

    }        
}