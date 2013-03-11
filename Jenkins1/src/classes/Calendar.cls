Global Class Calendar{
public Calendar(workbench wb){}
global static list<calendar.cal> getMyCalendar(){
    list<calendar.cal> mycal = new list<calendar.cal>();
    date low_range = system.today().addDays(-60);
    for(opportunity o : [select id,deal_issues__c,Subdivision__c, Pre_Feature_Status__c, account.name, division__c, Projected_GP__c,Writeup_Status_del__c, Merchant_name_in_write_up__c, Multi_Deal_Projected_GP__c,  Deal_Strengh__c, Total_GP__c, Subcategory_v3__c, Category_v3__c, name, feature_date__c, feature_end_date__c from opportunity where ownerid = :UserInfo.getUserId() AND feature_date__c !=null AND feature_end_date__c !=null AND feature_date__c > :low_range ORDER by Feature_date__c DESC]){
        mycal.add(new cal(o));
    }
    return mycal;
}

global static calendar.status getMyDealStatus(){
    calendar.status banner = new calendar.status();
    list<opportunity> status = [select id,Pre_Feature_Status__c, Multi_Deal_Projected_GP__c, Projected_GP__c, deal_issues__c, deal_strengh__c FROM opportunity WHERE ownerid = :UserInfo.getUserId() AND stageName ='Closed Won' AND feature_date__c >= :system.today()];
    for(opportunity o : status){
        if(o.deal_strengh__c=='A Sure Thing'){banner.sure_thing++;}
        if(o.deal_strengh__c=='Rep Getting Info'){banner.getting_info++;}
        if(o.deal_strengh__c!='Rep Getting Info' && o.deal_strengh__c!='A Sure Thing'){banner.in_progress++;}
        banner.projected_gp = o.Multi_Deal_Projected_GP__c+o.Projected_GP__c;    
    }
    return banner;
}

global class status{
    public integer sure_thing{get;set;}
    public integer in_progress {get;set;}
    public integer getting_info {get;set;}
    public decimal projected_gp {get;set;}
    public status(){
        this.sure_thing=0;
        this.in_progress=0;
        this.getting_info=0;
        this.projected_gp=0;
    }
}
global class cal{
    public string start_date {get;set;}
    public string end_date {get;set;}
    public string name {get;set;}
    public string id {get;set;}
    public string category {get;set;}
    public decimal total_gp{get;set;}
    public string subcategory {get;set;}
    public string deal_strength {get;set;}
    public decimal proj_gp {get;set;}
    public string merchant_name {get;set;}
    public string writeup_status {get;set;}
    public string division {get;set;}
    public string subdivision {get;set;}
    public string backgroundColor {get;set;}
    
    public cal(opportunity o){
            if(o.Pre_Feature_Status__c=='Opt-In'){
                this.start_date = o.Feature_Date__c.addDays(-1).format();
            }else{
                this.start_date = o.Feature_Date__c.format();
                }
            this.end_date = o.feature_end_date__c.format();
            this.name = o.name;
            if(o.Total_GP__c>0)
              this.name+=' $'+o.Total_GP__c.SetScale(0)+' GP';
            this.id = o.id;
            this.category =o.Category_v3__c;
            this.total_gp = o.Total_GP__c.SetScale(0);
            this.subcategory = o.Subcategory_v3__c;
            this.deal_strength = o.Deal_Strengh__c;
            if(o.Merchant_name_in_write_up__c!=null){this.merchant_name = o.Merchant_name_in_write_up__c;}else{this.merchant_name=o.account.name;}
            this.proj_gp = o.Multi_Deal_Projected_GP__c+o.Projected_GP__c;
            this.writeup_status = o.Writeup_Status_del__c;
            this.subdivision=o.subdivision__c;
            this.division=o.division__c;
            
            if(o.deal_issues__c!='No Issues'){this.backgroundColor='red';}else if(o.deal_strengh__c!='A Sure Thing'){this.backgroundColor='grey';}else{this.backgroundColor='black';}
        }
}

}