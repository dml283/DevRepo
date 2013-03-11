global class Division_Goals{

public list<division_goal> getDivisionGoal(string division, date goal_start, date goal_end){
        list<division_goal> goals = new list<division_goal>();
        list<Division_Goals__c> dgoals = [select id, division__r.name, division__c, date__c, Profit_goal__c FROM Division_Goals__c WHERE division__r.name = :division AND date__c >= :goal_start AND date__c <= :goal_end];
        for(division_goals__c d: dgoals){
                goals.add(new division_goal(d));
            } 
        return goals;
    }


global class division_goal{
        public string division {get;set;}
        public id division_id {get;set;}
        public date goal_date {get;set;}
        public decimal gp_goal {get;set;}
        
        public division_goal(Division_Goals__c d){
                this.division = d.division__r.name;
                this.division_id = d.division__c;
                this.goal_date = d.date__c;
                this.gp_goal = d.Profit_goal__c;
            }
    }
}