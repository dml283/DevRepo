public class marketrollout {

List<Division__c> divs;

 /// getReq() - Reffer to the list in the
 /// visualforce page with "Req" minus the "get" from
 /// controller name.
 public List<Division__c> getDivisions() {
//
  /// Get the data for the list
  divs = [select id, name,city_CEO__C,Actual_Launch__c, Deal_Vetter__c, Deal_Vetter__r.name, Live_Events_Channel_Actual_Launch_Date__c, Travel_Channel_Actual_Launch_Date__c, Smart_Deals_Actual_Launch__c, DSM__c, DSM__r.name, DPM__c, DPM__r.name, Hard_Actual__c, Hard_Planned__c, 
  Inside_Rep_Count__c, Market_Planner__c, Market_Planner__r.name, Original_Launch_Date__c, Outside_Rep_Count__c, Region__c, Revised_Launch__c, RVP__c, RVP__r.name, Merchant_Managers__c, Sales_Reps__c, Saturday_Acutal__c, Saturday_Planned__c, Soft_Actual__c, Soft_Planned__c, 
  State__c, Sunday_Actual__c, Sunday_Planned__c, Total_Rep_Count__c, Training_Begins__c,Weekend_Launch__c,NOW_Actual_Launch_Date__c,Home_Channel_Actual_Launch_Date__c, Now_DSM__r.name, NOW_Reps__c, Market_Planner_2__c, NOW_Planned_Launch_Date__c, Lead_Deal_Planner_s__c, 
  Merchant_Researcher__c
                FROM Division__c 
                WHERE isactive__c = true 
                ORDER BY name ASC ];
  return  divs; 
 }
 public string getMarketRolloutGV(){
                                GoogleViz gv = new GoogleViz();
                                gv.cols = new list<GoogleViz.col> 
                  { 
                    new GoogleViz.Col('col1','Division Name','string'),
                    new GoogleViz.Col('col2','State','string'),
                    new GoogleViz.Col('col3','Actual Launch','string'),
                    new GoogleViz.Col('col4','NOW! Launch','string'),
                    new GoogleViz.Col('col5','Channels - Home Launch','string'),
                    new GoogleViz.Col('col6','Channels - Travel Launch','string'),
                    new GoogleViz.Col('col7','Channels - Live Launch','string'),
                    new GoogleViz.Col('col8','Smart Launch','string'),
                    new GoogleViz.Col('col9','Weekend Launch','string'),
                    new GoogleViz.Col('col10','Sales Team','string'),
                    new GoogleViz.Col('col10','Lead Deal Planner(s)','string'),
                    new GoogleViz.Col('col10','Merchant Researcher','string'),
                    new GoogleViz.Col('col11a','Market Planner', 'string'),                                       
                    new GoogleViz.Col('col12','Divisional Sales Manager','string'),
                    new GoogleViz.Col('col11a','City CEO', 'string'), 
                    new GoogleViz.Col('col13','Planning Coordinator','string'),
                    new GoogleViz.Col('col14','RVP','string'),
                    new GoogleViz.Col('col15','Region','string'),
                    new GoogleViz.Col('col16','DPM','string'),
                    new GoogleViz.Col('col17','Merchant Managers','string'),
                    new GoogleViz.Col('col18','Inside Rep Count','number'),
                    new GoogleViz.Col('col19','Outside Rep Count','number'),
                    new GoogleViz.Col('col20','Total Rep Count','number')
                    
                  };
                  List<Division__c> divs2= [select id, name, Actual_Launch__c, Deal_Vetter__c, Deal_Vetter__r.name, Live_Events_Channel_Actual_Launch_Date__c, Travel_Channel_Actual_Launch_Date__c, Smart_Deals_Actual_Launch__c, DSM__c, DSM__r.name,City_CEO__c,City_CEO__r.name, DPM__c, DPM__r.name, 
                  Hard_Actual__c, Hard_Planned__c, Inside_Rep_Count__c, Market_Planner__c, Market_Planner__r.name, Original_Launch_Date__c, Outside_Rep_Count__c, Region__c, Revised_Launch__c, RVP__c, RVP__r.name, Merchant_Managers__c, Sales_Reps__c, Saturday_Acutal__c, 
                  Saturday_Planned__c, Soft_Actual__c, Soft_Planned__c, State__c, Sunday_Actual__c, Sunday_Planned__c, Total_Rep_Count__c, Training_Begins__c,Weekend_Launch__c,NOW_Actual_Launch_Date__c,Home_Channel_Actual_Launch_Date__c, Lead_Deal_Planner_s__c, Merchant_Researcher__c
                                                                   from Division__c  
                                                                   WHERE isactive__c = true 
                                           ORDER BY name ASC ];
                  for(Division__c d : divs2)
                        {
                        GoogleViz.row r = new GoogleViz.row();
                                if(d.name!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.name));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }


                                        if(d.State__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.State__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.Actual_Launch__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Actual_Launch__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.NOW_Actual_Launch_Date__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.NOW_Actual_Launch_Date__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                       if(d.Home_Channel_Actual_Launch_Date__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Home_Channel_Actual_Launch_Date__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.Travel_Channel_Actual_Launch_Date__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Travel_Channel_Actual_Launch_Date__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.Live_Events_Channel_Actual_Launch_Date__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Live_Events_Channel_Actual_Launch_Date__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.Smart_Deals_Actual_Launch__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Smart_Deals_Actual_Launch__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.Weekend_Launch__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Weekend_Launch__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                        if(d.Sales_Reps__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Sales_Reps__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                         if(d.Lead_Deal_Planner_s__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Lead_Deal_Planner_s__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }   
                                         if(d.Merchant_Researcher__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Merchant_Researcher__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }    
                                         if(d.Market_Planner__r.name!=null)
                                             {
                                              string MarketPlanner ='<a href=https://cs7.salesforce.com/'+d.Market_Planner__c+'>'+d.Market_Planner__r.name+'</a> ';
                                              r.cells.add(new GoogleViz.cell(MarketPlanner)); 
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.DSM__c!=null)
                                             {
                                              string DSM ='<a href=https://cs7.salesforce.com/'+d.DSM__c+'>'+d.DSM__r.name+'</a> ';
                                              r.cells.add(new GoogleViz.cell(DSM)); 
                                             }else
                                             {
                                             r.cells.add ( new GoogleViz.cell('-') );
                                             }
                                              if(d.City_CEO__c!=null)
                                             {
                                              string DSM ='<a href=https://cs7.salesforce.com/'+d.City_CEO__r.name+'>'+d.City_CEO__r.name+'</a> ';
                                              r.cells.add(new GoogleViz.cell(DSM));                                             
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.Deal_Vetter__c!=null)
                                             {
                                              string PlanningCoord ='<a href=https://cs7.salesforce.com/'+d.Deal_Vetter__c+'>'+d.Deal_Vetter__r.name+'</a> ';
                                              r.cells.add(new GoogleViz.cell(PlanningCoord)); 
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.RVP__c!=null)
                                             {
                                              string RVP ='<a href=https://cs7.salesforce.com/'+d.RVP__c+'>'+d.RVP__r.name+'</a> ';
                                              r.cells.add(new GoogleViz.cell(RVP)); 
                                              }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.Region__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Region__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.DPM__c!=null)
                                             {
                                              string DPM ='<a href=https://cs7.salesforce.com/'+d.DPM__c+'>'+d.DPM__r.name+'</a> ';
                                              r.cells.add(new GoogleViz.cell(DPM)); 
                                               }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.Merchant_Managers__c!=null)
                                             {
                                             system.debug('---------------------------------------DEBUG ENTRY'+d.Merchant_Managers__c);
                                             string TextReplace = ((String)d.Merchant_Managers__c).replaceAll('\n',''); 
                                             system.debug('---------------------------------------DEBUG EXIT'+'MM');
                                              r.cells.add(new GoogleViz.cell(d.Merchant_Managers__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('-') );
                                              }
                                                if(d.Inside_Rep_Count__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Inside_Rep_Count__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('0') );
                                              }
                                                if(d.Outside_Rep_Count__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Outside_Rep_Count__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('0') );
                                              }
                                                if(d.Total_Rep_Count__c!=null)
                                             {
                                              r.cells.add(new GoogleViz.cell(d.Total_Rep_Count__c));
                                             }else
                                              {
                                               r.cells.add ( new GoogleViz.cell('0') );
                                              }                                          
                            gv.addRow( r );
                        }
                  system.debug('---------------------------------'+gv);
                   return gv.toJsonString();  
 }
static testMethod void myTest(){
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id, phone = '303-933-1414', 
                        timezonesidkey='America/Los_Angeles', username='marketrollout@groupon.com');
                        insert u;

        Division__c divs = new Division__c(Name ='test',State__c ='IL',isactive__c = true );
        insert divs;
        
        Division__c d = new Division__c(Name ='',State__c ='IL',isactive__c = true, Actual_Launch__c = system.today(),NOW_Actual_Launch_Date__c = system.today(),Home_Channel_Actual_Launch_Date__c = system.today(),Travel_Channel_Actual_Launch_Date__c = system.today(),Live_Events_Channel_Actual_Launch_Date__c = system.today(),
                                        Smart_Deals_Actual_Launch__c = system.today(),Sales_Reps__c = 'Sales Rep 1',Lead_Deal_Planner_s__c = 'LDP 1',Merchant_Researcher__c = 'Merchant Researcher 1',Market_Planner__c = u.id,DSM__c = u.id,
                                        City_CEO__c = u.id,Deal_Vetter__c = u.id,RVP__c = u.id,Region__c = 'North',DPM__c = u.id,Merchant_Managers__c = 'AM 1',Inside_Rep_Count__c = 5,Outside_Rep_Count__c = 5);
        insert d;
        
    marketrollout x = new marketrollout();
    List<Division__c> divcatch = x.getDivisions();
    string TesterGV = x.getMarketRolloutGV();
    GoogleViz.row r = new GoogleViz.row();
    

}
}