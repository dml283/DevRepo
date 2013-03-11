public with sharing class Commissions {
public commissions(workbench wb){}
public commissions(){}
   public date today =  system.today();
   public id CurrentUser = UserInfo.getUserId();
   public list<id> AssignedDivIds = new list<id>();

   
   public CommissionResult getResult()
       {
           CommissionResult R = init();
           date d;
           date f;
           list<Sales_Goal__c> CurrentGoals = [SELECT id, Goal_Start_Date__c, Goal_End_Date__c, GP_Goal__c, Contracts_in_assigned_market__c, Division__r.name,Division__c, Contract_Goal__c
                                              FROM Sales_Goal__c
                                              WHERE ownerid = :CurrentUser AND Goal_End_Date__c >= :Today AND Goal_Start_Date__c<= :Today AND ownerid=:CurrentUser];
           for(sales_Goal__c s :CurrentGoals)
               {
                   d = s.Goal_Start_Date__c;
                   f = s.Goal_End_Date__c;
                   r.division=s.Division__r.name;
                   if(s.GP_Goal__c>0)
                       r.GPGoal=r.gpGoal+s.GP_Goal__c;
                   r.divisionList.add(s.Division__r.name);
               }                                    
           list<opportunity> pre = getCurrentMonth(d,f);
           
           R = exec(r,pre);
           r = CalcCommission(r);
           return r;
       }
   public CommissionResult CalcCommission(CommissionResult R)
       {
           r.InMktTotalGP = r.InMktNewGP+r.InMktRefeatureGP;
           if(r.InMktTotalGP>0 && r.GPGoal>0)
               r.PercentToGoal = (r.InMktTotalGP/r.GPGoal);
           
           map<string,double> rates = getMyRates((r.PercentToGoal*100));
           
           r.PercentToGoal = (100*(r.PercentToGoal.setScale(4)));  
           
           r.InMktNewRate=(rates.get('New Deal'));
           r.InMktRefeatureRate=(rates.get('Refeature')); 
           if(r.PercentToGoal>60)
               {
                    r.OutOfMarketRate=.015;
               }else{r.OutOfMarketRate=.005;}
           
           r.InMktNewCommission = (r.InMktNewRate*r.InMktNewGP);
           r.InMktRefeatureCommission = (r.InMktRefeatureRate*r.InMktRefeatureGP);
           r.OutOfMarketCommission=(r.OutOfMarketRate*r.OutOfMarketGP);
           
           r.EstCommission=r.InMktNewCommission+r.InMktRefeatureCommission+r.OutOfMarketCommission;
           
           r.InMktNewRate=(r.InMktNewRate*100);
           r.InMktRefeatureRate=(r.InMktRefeatureRate*100); 
           r.OutOfMarketRate=(r.OutOfMarketRate*100);
           
           double projTotal = (r.upcomingInMktRefeatureGP + r.upcomingInMktNewGP + r.InMktTotalGP);
           if(r.GPGoal>0)
               r.ProjectedPercentToGoal = (projTotal/r.GPGoal);
            
           map<string,double> ProjRates = getMyRates((r.ProjectedPercentToGoal*100));
           r.ProjectedPercentToGoal = (100*(r.ProjectedPercentToGoal.setScale(4)));  

           decimal InMktNewRate=(ProjRates.get('New Deal'));
           decimal InMktRefeatureRate=(ProjRates.get('Refeature')); 
           decimal OutOfMarketRate;
           if(r.ProjectedPercentToGoal>60)
               {
                    OutOfMarketRate=(.015);
               }else{OutOfMarketRate=.005;}
          r.ProjectedCommission = (r.upcomingInMktNewGP*InMktNewRate)+(r.InMktNewGP*InMktNewRate)+(r.upcomingInMktRefeatureGP*InMktRefeatureRate)+(r.InMktRefeatureGP*InMktRefeatureRate)+(r.OutOfMarketGP*OutOfMarketRate)+(r.UpcomingOutOfMarketGP*OutOfMarketRate);
              
           return r;
       }
   public boolean InOut(string d,CommissionResult R)
       {
           boolean check = false;
           for(string s : r.DivisionList)
               {
                   if(d==s)
                       check = true;
               }
           return check;    
       
       }
   public CommissionResult exec(CommissionResult R, list<opportunity> olist)
       {
           for(opportunity o : olist)
               {
                 
                   boolean check = InOut(o.division__c,r);
                   if(check)
                       {
                         if(o.feature_date__c<system.today() && o.Total_GP_for_Commission__c >0)
                         {
                           if(o.Feature_or_Refeature__c == 'New Deal' || o.Global_SFDC_Category__c =='Restaurant')
                               {
                                   r.InMkt.add(o);
                                   r.InMktNewGP+=o.Total_GP_For_Commission__c;
                               }else
                           if(o.Feature_or_Refeature__c == 'Refeature')
                               {
                                   r.InMkt.add(o);
                                   r.InMktRefeatureGP+=o.Total_GP_For_Commission__c;
                               }
                          }else 
                              if(o.feature_date__c>=system.today()) 
                                  {
                                       if(o.Feature_or_Refeature__c == 'New Deal' || o.Global_SFDC_Category__c =='Restaurant')
                                           {
                                               r.Upcoming.add(o);
                                               r.UpcomingInMktNewGP+=o.Total_Feature_Projected_GP__c;
                                           }else
                                       if(o.Feature_or_Refeature__c == 'Refeature')    
                                           {
                                               r.upcoming.add(o);
                                               r.upcomingInMktRefeatureGP+=o.Total_Feature_Projected_GP__c;
                                           }
                                   }    
                       }
                   if(!check)
                       {
                          if(o.feature_date__c<system.today()) 
                            {   
                               r.OutOfMkt.add(o);
                               r.OutOfMarketGP+=o.Total_GP_For_Commission__c;
                            }else if(o.feature_date__c>=system.today()) 
                                {   
                                   r.UpComing.add(o);
                                   r.UpcomingOutOfMarketGP+=o.Total_Feature_Projected_GP__c;
                                } 
                              
                       }
               
               }
           
           return r;
       }    
   public list<opportunity> getCurrentMonth(date d, date f)
       {
           list<opportunity> olist = [SELECT id, feature_date__c, Total_GP__c, account.name, name, division__C, account.id, Feature_or_Refeature__c, Total_GP_For_Commission__c, Total_Feature_Projected_GP__c, Global_SFDC_Category__c
                                        FROM opportunity 
                                        WHERE  feature_date__c >= :d AND feature_date__c<=:f AND owner.id=:CurrentUser AND Feature_date__c !=null
                                        ORDER by feature_date__c asc];
           return olist;          
       
       }   
   public CommissionResult init()
       {
           CommissionResult R = new CommissionResult();
                r.EstCommission=5;
                r.GPGoal=0;
                r.InMkt = new list<opportunity>();
                r.InMktNewCommission=0;
                r.InMktNewGP=0;
                r.InMktNewRate=0;
                r.InMktRefeatureCommission=0;
                r.InMktRefeatureGP=0;
                r.InMktRefeatureRate=0;
                r.OutOfMarketCommission=0;
                r.OutOfMarketGP=0;
                r.OutOfMarketRate=0;
                r.OutOfMkt= new list<opportunity>();
                r.Upcoming= new list<opportunity>();
                r.PercentToGoal=0;
                r.ProjectedPercentToGoal=0;
                r.Division='';
                r.InMktTotalGP=0;
                r.UpcomingInMktRefeatureGP=0;
                r.UpcomingInMktNewGP=0;
                r.UpcomingOutofMarketGP=0;
                r.ProjectedGPTotal=0;
                r.ProjectedCommission=0;
                r.DivisionList = new list<string>();
           return r;
       }
   public class CommissionResult
       {
           public decimal PercentToGoal{get;set;}
           public decimal ProjectedPercentToGoal{get;set;}
           public decimal GPGoal{get;set;}
           public list<string> DivisionList{get;set;}
           
           public string Division{get;set;}
           
           public decimal EstCommission{get;set;}
           
           public decimal InMktNewRate{get;set;}
           public decimal InMktRefeatureRate{get;set;}
           public decimal InMktTotalGP{get;set;}
           public decimal OutOfMarketRate{get;set;}
           
           public decimal InMktRefeatureGP{get;set;}
           public decimal InMktNewGP{get;set;}
           public decimal OutOfMarketGP{get;set;}

           public decimal UpcomingInMktRefeatureGP{get;set;}
           public decimal UpcomingInMktNewGP{get;set;}
           public decimal UpcomingOutOfMarketGP{get;set;}
            
           public decimal InMktRefeatureCommission{get;set;}
           public decimal InMktNewCommission{get;set;}
           public decimal OutOfMarketCommission{get;set;}

           public decimal ProjectedGPTotal{get;set;}
           public decimal ProjectedCommission{get;set;}           
           
           public list<opportunity> InMkt{get;set;}
           public list<opportunity> OutOfMkt{get;set;}
           public list<opportunity> Upcoming{get;set;}
       
       }
   public list<Sales_Goal__c> getMyGoals ()
     {

        list<Sales_Goal__c> CurrentGoals = [SELECT id, Goal_Start_Date__c, Goal_End_Date__c, GP_Goal__c, Contracts_in_assigned_market__c, Division__r.name,Division__c, Contract_Goal__c
                                            FROM Sales_Goal__c
                                            WHERE ownerid = :CurrentUser AND Goal_End_Date__c >= :Today AND Goal_Start_Date__c<= :Today AND ownerid=:CurrentUser];     
        return CurrentGoals;
     }       
   public string getMyCities()
       {
           list<sales_goal__c> sglist = getMyGoals();
           string divlist ='My Goal';
           if(sglist.size()!=1)
               divlist+='s';
           divlist+=' for: ';
           double counter=0;     
           for(Sales_goal__c sg: sglist)
               {
                   counter++;
                   AssignedDivIds.add(sg.division__c);
                   divlist+=sg.Division__r.name;
                   if(counter!=sglist.size())
                       {
                           divlist+=' & ';
                       }
               }
           return divlist;    
       }
   public map<string,double> getMyRates(decimal percent)
       {
           map<string,double> cmap = new map <string,double>();
            if(percent>=0&&percent<60)
               {
                 cmap.put('New Deal',0.005);
                 cmap.put('Refeature',0.005);
               }else if(percent>=60&&percent<80)
                   {
                     cmap.put('New Deal',0.0125);
                     cmap.put('Refeature',0.0075);
                   }else if(percent>=80&&percent<100)
                           {
                             cmap.put('New Deal',0.025);
                             cmap.put('Refeature',0.02);
                           }else if(percent>=100&&percent<105)
                               {
                                 cmap.put('New Deal',0.035);
                                 cmap.put('Refeature',0.03);
                               }else if(percent>=105&&percent<110)
                                   {
                                     cmap.put('New Deal',0.0363);
                                     cmap.put('Refeature',0.0313);
                                   }else if(percent>=110&&percent<115)
                                       {
                                         cmap.put('New Deal',0.0375);
                                         cmap.put('Refeature',0.0325);
                                       }else if(percent>=120&&percent<125)
                                           {
                                             cmap.put('New Deal',0.04);
                                             cmap.put('Refeature',0.035);
                                           }
                                           else if(percent>=125&&percent<130)
                                           {
                                             cmap.put('New Deal',0.0408);
                                             cmap.put('Refeature',0.0358);
                                           }
                                           else if(percent>=130&&percent<135)
                                           {
                                             cmap.put('New Deal',0.0417);
                                             cmap.put('Refeature',0.0367);
                                           }
                                           else if(percent>=135&&percent<140)
                                           {
                                             cmap.put('New Deal',0.0425);
                                             cmap.put('Refeature',0.0375);
                                           }
                                           else if(percent>=140&&percent<145)
                                           {
                                             cmap.put('New Deal',0.0433);
                                             cmap.put('Refeature',0.0383);
                                           }
                                           else if(percent>=145&&percent<150)
                                           {
                                             cmap.put('New Deal',0.0433);
                                             cmap.put('Refeature',0.0384);
                                           }
                                           else if(percent>=150&&percent<155)
                                           {
                                             cmap.put('New Deal',0.0442);
                                             cmap.put('Refeature',0.0392);
                                           }
                                           else if(percent>=155&&percent<160)
                                           {
                                             cmap.put('New Deal',0.0450);
                                             cmap.put('Refeature',0.04);
                                           }
                                           else if(percent>=155&&percent<160)
                                           {
                                             cmap.put('New Deal',0.0458);
                                             cmap.put('Refeature',0.0408);
                                           }
                                           else if(percent>=160&&percent<165)
                                           {
                                             cmap.put('New Deal',0.0467);
                                             cmap.put('Refeature',0.0417);
                                           }
                                           else if(percent>=165&&percent<170)
                                           {
                                             cmap.put('New Deal',0.0475);
                                             cmap.put('Refeature',0.0425);
                                           }
                                           else if(percent>=170&&percent<175)
                                           {
                                             cmap.put('New Deal',0.0483);
                                             cmap.put('Refeature',0.0433);
                                           }
                                           else if(percent>=175&&percent<180)
                                           {
                                             cmap.put('New Deal',0.0492);
                                             cmap.put('Refeature',0.0442);
                                           }
                                           else if(percent>=180&&percent<185)
                                           {
                                             cmap.put('New Deal',0.05);
                                             cmap.put('Refeature',0.0450);
                                           }
                                           else if(percent>=185&&percent<190)
                                           {
                                             cmap.put('New Deal',0.0513);
                                             cmap.put('Refeature',0.0463);
                                           }
                                           else if(percent>=190&&percent<195)
                                           {
                                             cmap.put('New Deal',0.0525);
                                             cmap.put('Refeature',0.0475);
                                           }
                                           else if(percent>=195&&percent<200)
                                           {
                                             cmap.put('New Deal',0.0538);
                                             cmap.put('Refeature',0.0488);
                                           }else if(percent>=200)
                                                {
                                                 cmap.put('New Deal',0.055);
                                                 cmap.put('Refeature',0.050);
                                                }
           return cmap;
       }            
  /* 
   public double getMyOutOfMakretRate()
       {
           double oomktrate=0;
           decimal p = getMyGPPercentToGoal();
           if(p<.6)
               {
                   oomktRate=1;
               }else 
                   {
                       oomktRate=1.5;
                   }
               
           return oomktrate;    
       }
   public list<opportunity> getInMktNewDeal()
       {
           list<opportunity> mkt = new list<opportunity>();
           list<opportunity> olist = getInMarket();
           for(opportunity o:olist)
               {
                   if(o.Feature_or_Refeature__c=='New Deal')
                       {
                           mkt.add(o);
                       }
               }
           return mkt;            
       }
   public list<opportunity> getInMktRefeature()
       {
           list<opportunity> mkt = new list<opportunity>();
           list<opportunity> olist = getInMarket();
           for(opportunity o:olist)
               {
                   if(o.Feature_or_Refeature__c=='Refeature')
                       {
                           mkt.add(o);
                       }
               }
           return mkt;            
       }    
   public double getInMktNewDealCommission()
       {
           double rate = getInMktPercentNewDeal();
           double gp = getInMktNewDealGP();
           double commission =0;
           commission=(gp*(rate/100));
           return getFormat(commission);
       }
   public double getInMktRefeatureCommission()
       {
           double rate = getInMktPercentRefeature();
           double gp = getInMktRefeatureGP();
           double commission =0;
           commission=(gp*(rate/100));
           return getFormat(commission);
       }
   public double getOutOfMktCommission()
       {
           double rate = getMyOutOfMakretRate();
           double gp = getOutOfMktGP();
           double commission =0;
           commission=(gp*(rate/100));
           return getFormat(commission);
       }
   public double getFormat(double d)
       {
           decimal value = decimal.valueof(d);
           value =value.setscale(2);
           double dbl=double.valueof(value);
           return dbl;
       }    
   public double getInMktNewDealGP()
       {
            double gp =0;
            list<opportunity> olist = getInMktNewDeal();
            for(opportunity o:olist)
                gp+=o.Total_GP_For_Commission__c;
            return gp;    
            
       }
   public double getInMktRefeatureGP()
       {
           double gp =0;
            list<opportunity> olist = getInMktRefeature();
            for(opportunity o:olist)
                gp+=o.Total_GP_For_Commission__c;
            return gp;    
       }
   public double getOutOfMktGP()
       {
           double gp =0;
            list<opportunity> olist = getOutOfMarket();
            for(opportunity o:olist)
                gp+=o.Total_GP_For_Commission__c;
            return gp;
       }    
       
   public double getTotalCommission()
       {   
           double TotalCommission=0;
           double inMktNew = getInMktNewDealCommission();
           double inMktOld = getInMktRefeatureCommission();
           double outOfMkt = getOutOfMktCommission();
           TotalCommission+=(inMktNew+inMktOld+outOfMkt);
           return getFormat(Totalcommission);
       }              
   
   public double getInMktPercentNewDeal()
       {
           double inp =0;
           decimal p = getMyGPPercentToGoal();
           map<string,double> m = getMyRates(p);
           inp = m.get('New Deal');
           return (inp*100);
       }
   public double getInMktPercentRefeature()
       {
           decimal p = getMyGPPercentToGoal();
           map<string,double> m = getMyRates(p);
           double inp = m.get('Refeature');
           return (inp*100);
       }    
   

   
   public double getOutOfMarketGPTotal()
       {
           double gp=0;
           list <opportunity> olist = getOutOfMarket();
           for(opportunity o:olist)
               {
                   gp+=o.Total_GP_For_Commission__c;
               }
           return gp;
       }
   public double getInMarketGPTotal()
       {
           double gp=0;
           list <opportunity> olist = getInMarket();
           for(opportunity o:olist)
               {
                   gp+=o.Total_GP_For_Commission__c;
               }
           return gp;
       }
  public double getTotalGPGoal()
      {
          double sgTotal=0;
          list<sales_goal__c> s = getMyGoals();
          for(sales_goal__c a:s)
              {
                  sgTotal+=a.GP_Goal__c;
              }
          return sgTotal;
      }
  public decimal getMyGPPercentToGoal()
      {
          decimal inmkt = getInMarketGPTotal();
          decimal gpgoal = getTotalGPGoal();
          decimal percent = inmkt.divide(gpgoal,2);
          percent *=100;
          
          return percent;
      }                 




     
     public list<opportunity> getInMarket()
         {
             list<sales_goal__c> slist=getMyGoals();
             date startdate;
             date enddate;
             for(sales_goal__c s:slist)
                 {
                     AssignedDivIds.add(s.division__c);
                     startdate=s.Goal_Start_Date__c;
                     enddate=s.Goal_End_Date__c;
                     
                 }
             list<opportunity> olist = [SELECT id, feature_date__c, Total_GP__c, account.name, name, division__C, account.id, Feature_or_Refeature__c, Total_GP_For_Commission__c
                                        FROM opportunity 
                                        WHERE division_dynamic__c in :AssignedDivIds AND feature_date__c >= :startdate AND feature_date__c<=:enddate AND Total_GP__c>0 AND owner.id=:CurrentUser
                                        ORDER by feature_date__c asc];
             return olist;                           
         }
    public list<opportunity> getOutOfMarket()
         {
             list<sales_goal__c> slist=getMyGoals();
             date startdate;
             date enddate;
             for(sales_goal__c s:slist)
                 {
                     AssignedDivIds.add(s.division__c);
                     startdate=s.Goal_Start_Date__c;
                     enddate=s.Goal_End_Date__c;
                 }
             list<opportunity> olist = [SELECT id, feature_date__c, Total_GP__c, account.name, name, division__C, account.id, Feature_or_Refeature__c, Total_GP_For_Commission__c
                                        FROM opportunity 
                                        WHERE division_dynamic__c not in :AssignedDivIds AND feature_date__c >= :startdate AND feature_date__c<=:enddate AND Total_GP__c>0 AND owner.id=:CurrentUser
                                        ORDER by feature_date__c asc];
                     
             return olist;                           
         }
       */  
     
  
   private testMethod static void ComTest1()
       {
        
         
         //-----Create the Init Variables
         Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
                        insert u;
        
         //run as user
         System.RunAs(u)
             {
                  date today = system.today();
                  date today2 = today+10;
            
                  //init the commisisons class
                  Commissions com = new Commissions();

                 //Create a division to assign a sales goal to
                 Division__c divs = new Division__c(Name ='test',State__c ='IL');
                     insert divs;
                 
                 //Create an account
                 account a = new account();
                         a.name = 'test acct';
                    insert a;    
                 //Create an oppty
                 opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.StageName = 'Prospecting';
                         o.CloseDate = date.today();
                         o.feature_date__c=date.today();
                         o.unit_Buy_Price__c=5;
                         o.unit_sell_price__c=10;
                         o.TotalOpportunityQuantity=500;
                         o.Deal_Strengh__c = 'Rep Getting Info';
                         o.AccountId = a.Id;
                         o.Division_Dynamic__c=divs.id;
                    insert o;            
                 //Create a Sales Goal
                 Sales_Goal__c sg1 = new Sales_Goal__c(Goal_Start_Date__c=today,Goal_End_Date__c=today2,GP_Goal__c=200,Contracts_in_assigned_market__c=20, Contract_Goal__c = 25, Division__c=divs.id);
                     insert sg1;
                 
                 //Lets now get the Sales Goal we just inserted
                 list<Sales_Goal__c> testSalesGoal = com.getMyGoals();
                     //system.assert(testSalesGoal.size()==1);
                 CommissionResult R = com.getResult();    
                 string teststring = com.getMyCities();
                 //double inmy=com.getInMktPercentNewDeal();
                 //double inmkt=com.getInMktPercentRefeature();
                 //double outofmktgp = com.getOutOfMarketGPTotal();
                 //string mycity = com.getMyCities();
                 //double totalcom = com.getTotalCommission();
             }
       }
}