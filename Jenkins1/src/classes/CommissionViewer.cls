public class CommissionViewer{
    
    public CommissionViewer(){
        this.goals = [select id, ownerid, owner.name from Sales_goal__c where goal_start_date__c = last_month ORDER BY Owner.Name ASC];
        this.months = new List<SelectOption>();
        this.months.add(new SelectOption('January', 'January'));
        this.months.add(new SelectOption('February', 'February'));
        this.months.add(new SelectOption('March', 'March'));
        Set<String> already_added = new Set<String>();
        this.items = new List<SelectOption>();
        for(sales_goal__c sg: goals){
            if(!already_added.contains(sg.owner.name)){
                items.add(new SelectOption(sg.ownerid,sg.owner.name));
                already_added.add(sg.owner.name);
            }
        }
    }
    
    public List<Sales_Goal__c> goals {get;set;}
    public List<SelectOption> months {get;set;}
    
    public id selected_user {get;set;}
    public string selected_month {get;set;}
    public List<SelectOption> items {get;set;}
    
    public PageReference viewCommission(){
        PageReference pageRef = new PageReference('/apex/commissionXLS');
        pageRef.getParameters().put('salesrep', selected_user);
        pageRef.getParameters().put('month', selected_month);
        pageRef.setRedirect(true);
        return pageRef;
    }

}