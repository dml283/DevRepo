@RestResource(urlMapping='/v1.0/ir')

global class RESTirAPI{

@HttpGET
global static list<ir> getIR(){

    list<ir> irs = new list<ir>();
    for(information_request__c i : [select id, opportunity__r.Pre_Feature_Status__c, opportunity__r.deal_strengh__c, Write_Up_Status__c, Who_do_you_need_information_from__c, Please_describe_the_information_you_need__c, What_is_Missing__c, opportunity__r.name, opportunity__r.feature_date__c, name from Information_request__c where opportunity__r.ownerid = :UserInfo.getUserId() AND Issue_Resolved__c = false AND opportunity__r.feature_date__c > :system.today() AND opportunity__r.stageName = 'Closed Won' ORDER BY opportunity__r.feature_date__c desc]){
            irs.add(new ir(i));        }
    return irs;

    }
    
   
global class ir{
    public string name {get;set;}
    public string id {get;set;}
    public string what_is_missing {get;set;}
    public string feature_date {get;set;}
    public string details {get;set;}
    public string from_who {get;set;}
    public string writeup_status {get;set;}
    public string deal_strength {get;set;}
    public integer days_to_feature {get;set;}
    public ir(information_request__c i){
        this.name=i.opportunity__r.name;
        this.id=i.id;
        this.deal_strength = i.opportunity__r.deal_strengh__c;
        this.from_who = i.Who_do_you_need_information_from__c;
        this.details = i.Please_describe_the_information_you_need__c;
        this.what_is_missing = i.What_is_Missing__c;
        this.writeup_status = i.Write_Up_Status__c;
        if(i.opportunity__r.feature_date__c!=null){
        if(i.opportunity__r.Pre_Feature_Status__c=='Opt-In'){
                this.days_to_feature = system.today().daysBetween(i.opportunity__r.feature_date__c.addDays(-1));
                this.feature_date = i.opportunity__r.feature_date__c.addDays(-1).format();
            }else{
                this.days_to_feature = system.today().daysBetween(i.opportunity__r.feature_date__c);
                this.feature_date = i.opportunity__r.feature_date__c.format();
                }
            
            }
    }
}    
     
}