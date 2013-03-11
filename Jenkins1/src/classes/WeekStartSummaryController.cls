public with sharing class WeekStartSummaryController {
    /*
    public Player_Daily_Summary__c summary {
        get {
            return summary;
        }   
        set {
            summary = [SELECT Id, User__c, Player__c FROM Player_Daily_Summary__c WHERE Id = :value.Id];
            Id userId = summary.User__c;
            user = [SELECT Id, FirstName, LastName from User where Id = :userId];
            
            Id playerId = summary.Player__c;
            player = [SELECT Id, scoreboard2__Primary_Team__c from scoreboard2__Player__c where Id = :playerId];
            
            List<Game_Settings__c> gs = [SELECT Id, Stat_Definition__c, Name, Start_Date__c, End_Date__c FROM Game_Settings__c WHERE Name = 'March Madness'];
            if(gs.size() == 0) {
                return;
            }
            
            settings = gs[0];
            List<Daily_Multiplier__c> daily = [SELECT Multiplier__c FROM Daily_Multiplier__c WHERE Active_Date__c = :Date.today() AND Game_Settings__c = :settings.Id];
            if(daily.size() == 0 || daily[0].Multiplier__c == null) {
                multiplier = 1;
            }
            else {
                multiplier = daily[0].Multiplier__c.intValue();
            }
            AggregateResult rs = [SELECT count(Id) from scoreboard2__Team__c];
            teamLength = (Integer)rs.get('expr0');
            
            teamStatList = [SELECT Id, scoreboard2__Team__c, scoreboard2__Team__r.Name, scoreboard2__Value__c, scoreboard2__Value_Type__c, scoreboard2__Stat_Definition__c, scoreboard2__Team_Stat_Composite_key__c FROM scoreboard2__Team_Stat__c WHERE scoreboard2__Stat_Definition__c = :settings.Stat_Definition__c ORDER BY scoreboard2__Value__c DESC];
            place = teamStatList.size();
            for(Integer i = 0; i < teamStatList.size(); i++) {
                if(teamStatList[i].scoreboard2__Team__c == player.scoreboard2__Primary_Team__c) {
                    place = i+1;
                }
            }
            
            rs = [SELECT count(Id) FROM scoreboard2__Player_Action__c where CreatedDate = LAST_WEEK and scoreboard2__Player__c = :this.player.id];
            playerDealCount = (Integer)rs.get('expr0');
            
            rs = [SELECT count(Id) FROM scoreboard2__Player_Action__c where CreatedDate = LAST_WEEK and scoreboard2__Player__r.scoreboard2__Primary_Team__c = :this.player.scoreboard2__Primary_Team__c];
            Integer teamTotal = (Integer)rs.get('expr0');
            
            rs = [SELECT count(Id) FROM scoreboard2__Player__c where scoreboard2__Primary_Team__c = :this.player.scoreboard2__Primary_Team__c];
            Integer currentTeamLength = (Integer)rs.get('expr0');
            teamWeeklyAverage = (Decimal)teamTotal / (Decimal)currentTeamLength; 
        }
    }

    public Game_Settings__c settings {get;set;}
    public scoreboard2__Player__c player {get;set;}
    public User user {get;set;} 
    public List<scoreboard2__Team_Stat__c> teamStatList {get;set;}
    public Integer multiplier {get;set;}
    public Integer teamLength {get;set;}
    public Integer place {get;set;}
    
    public Integer playerDealCount {get;set;}
    public Decimal teamWeeklyAverage {get;set;}
        
    public WeekStartSummaryController() {
        teamLength = 0;
        multiplier = 1;
        place = 1;    
    }

    public String getFirstName() {
        if(this.user == null) {
            return '';
        }
        
        return this.user.FirstName;
    }
    
    public Integer getDaysIn() {
        if(settings == null) {
            return 0;
        }
        Date t = Date.today();
        Date start = settings.Start_Date__c;
        return start.daysBetween(t);
    }

    public Integer getDaysLeft() {
        if(settings == null) {
            return 0;
        }
        Date t = Date.today();
        Date endDate = settings.End_Date__c;
        return t.daysBetween(endDate);
    }

    public String getTeamPlace() {
        String suffix = (math.mod(place, 10) == 1 && math.mod(place, 100) != 11) ? 'st' :
                        (math.mod(place, 10) == 2 && math.mod(place, 100) != 12) ? 'nd' :
                        (math.mod(place, 10) == 3 && math.mod(place, 100) != 13) ? 'rd' : 'th';
        return String.valueOf(place) + suffix; 
    }
    
    public Integer getDailyPoints() {
        return (teamLength * multiplier);
    }
    
    public String getEndDate() {
        DateTime dt = DateTime.newInstance(settings.End_Date__c.year(), settings.End_Date__c.month(), settings.End_Date__c.day());
        Integer day = dt.day();
        String suffix = (math.mod(day, 10) == 1 && math.mod(day, 100) != 11) ? 'st' :
                        (math.mod(day, 10) == 2 && math.mod(day, 100) != 12) ? 'nd' :
                        (math.mod(day, 10) == 3 && math.mod(day, 100) != 13) ? 'rd' : 'th';
        
        return dt.format('MMMM d')+suffix;
    }   */

}