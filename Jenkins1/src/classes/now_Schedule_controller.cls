public with sharing class now_Schedule_controller {

    public boolean newmode{get;set;}
    public Boolean selectedschedule = true;
    public string strDelSelId{get;set;}
    public string strEditSelId{get;set;}
    public string strSelectedRec{get;set;}    
    public now_schedule__c md;
    public Boolean Errormessage;
    public NOW_Schedule__c schedule = new NOW_Schedule__c ();
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    list<NOW_Schedule__c > selectedrecord = new list<NOW_Schedule__c >();
    list<schedulewrapper>  schedulelist = new list<schedulewrapper>();
   
    public now_Schedule_controller(ApexPages.StandardController controller) {
   
    }

   
    
    public NOW_Schedule__c getschedule()
    {
        return schedule;      
    }    
    //SAVE NEW 

    public PageReference savenew ()
    {

        NOW_Schedule__c savenewrec = new NOW_Schedule__c
            (  
            groupon_now__c                             = currentId,
            Daily_Unit_Max_for_this_Schedule__c        = schedule.Daily_Unit_Max_for_this_Schedule__c,
            NOW_Start_Date__c                          = schedule.NOW_Start_Date__c,
            NOW_End_Date__c                            = schedule.NOW_End_Date__c,
            Start_Time__c                              = schedule.Start_Time__c,    
            End_Time__c                                = schedule.End_Time__c,      
            Monday__c                                  = schedule.Monday__c,        
            Tuesday__c                                 = schedule.Tuesday__c,       
            Wednesday__c                               = schedule.Wednesday__c,     
            Thursday__c                                = schedule.Thursday__c,      
            Friday__c                                  = schedule.Friday__c,        
            Saturday__c                                = schedule.Saturday__c,      
            sunday__c                                  = schedule.sunday__c                  
            );
        if(schedule.Monday__c                            != false||
            schedule.Tuesday__c                          != false||
            schedule.Wednesday__c                        != false||
            schedule.Thursday__c                         != false||
            schedule.Friday__c                           != false||
            schedule.Saturday__c                         != false||
            schedule.sunday__c                           != false)
            {
                
                try
                {
                Database.SaveResult SR = database.insert(savenewrec);
                    if(sr.isSuccess())
                    {
                        schedule.Daily_Unit_Max_for_this_Schedule__c = null;
                        schedule.NOW_Start_Date__c                   = null;
                        schedule.NOW_End_Date__c                     = null;
                        schedule.Start_Time__c                       = '';
                        schedule.End_Time__c                         = '';
                        schedule.Monday__c                           = null;
                        schedule.Tuesday__c                          = null;
                        schedule.Wednesday__c                        = null;
                        schedule.Thursday__c                         = null;
                        schedule.Friday__c                           = null;
                        schedule.Saturday__c                         = null;
                        schedule.sunday__c                           = null;
            
                        cancelnewmode();     
                    }
                }
                catch(exception e)
                {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
              }
              else
              {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one day for the Groupon Now! deal from the Days Valid section.');
                 ApexPages.addMessage(myMsg);
              }
         return null;

} 

//CANCEL MODE
    public PageReference cancelnewmode()
    {
        newmode = false;
        selectedschedule = true;        
        return null;
    }
    

//CANCEL MODE

 public PageReference cancel()
    {
       
        selectedschedule = true;
        strEditSelId = null;
        return null;
    }
//ADD ADDRESS 

   public PageReference addAddress()
    {
        newmode = true;
        selectedschedule = true;
        strDelSelId = null;
        strEditSelId = null;
        //multinew.clear();
        return null;
    }
     
 //DELETE METHOD
  public void delschedules()
            { 
         
                try
                    {
                        database.delete(strDelSelId);
                        strDelSelId = null;
                        strEditSelId = null;

                    }
                    catch (Exception e)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                       strDelSelId = null;
                       strEditSelId = null;


                    }                
            }   
    public boolean getselectedschedule()
    {
        return selectedschedule;
    }
  
    public void setselectedschedule(Boolean selecteddeal)
    {
        this.selectedschedule= selecteddeal;
    }
   //GET ALL REDEMPTION ADDRESSES
  public List<schedulewrapper> getallschedule()
    {
        schedulelist.clear();
            
        for(NOW_Schedule__c mul : [select Id,name,Daily_Unit_Max_for_this_Schedule__c,NOW_Start_Date__c ,NOW_End_Date__c,Start_Time__c,End_Time__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,sunday__c                            from NOW_Schedule__c where Groupon_Now__c =: CurrentId])
       // for(now_schedule__c mul : (List<now_schedule__c>)con.getRecords())
        schedulelist.add(new schedulewrapper(mul));
        return schedulelist;  
    }
    
     public PageReference getSelected()
            {
        
                selectedrecord.clear();
            if(strEditSelId != null)
            {
           
                    for(schedulewrapper Infowrapper: schedulelist )
                {
                         if(Infowrapper.passId == strEditSelId)
                        {
                        selectedrecord.add(Infowrapper.schedulewrap);
                        }
                        
                }
            }  
                return null;
            }
            
//RETURN SELECTED ADDRESSES
    public List<NOW_Schedule__c> Getselectedaddress()
    {
        getSelected();    
           
     
        if(selectedrecord.size()>0)
            {

            return selectedrecord;
            }
        else
            {
            return null;
            }

    }
    public Pagereference Updatemethod()
{
        for(integer i=0;i<selectedrecord.size();i++)
        {
            if(strSelectedRec != '' || strSelectedRec != null)
            {
                if(selectedrecord[i].Id == strSelectedRec)
                {
                    md = new NOW_Schedule__c 
                  
                    (
                    Id                                         = selectedrecord[i].Id,
                    Daily_Unit_Max_for_this_Schedule__c        = selectedrecord[i].Daily_Unit_Max_for_this_Schedule__c,
                    NOW_Start_Date__c                          = selectedrecord[i].NOW_Start_Date__c,
                    NOW_End_Date__c                            = selectedrecord[i].NOW_End_Date__c,
                    Start_Time__c                              = selectedrecord[i].Start_Time__c,    
                    End_Time__c                                = selectedrecord[i].End_Time__c,      
                    Monday__c                                  = selectedrecord[i].Monday__c,        
                    Tuesday__c                                 = selectedrecord[i].Tuesday__c,       
                    Wednesday__c                               = selectedrecord[i].Wednesday__c,     
                    Thursday__c                                = selectedrecord[i].Thursday__c,      
                    Friday__c                                  = selectedrecord[i].Friday__c,        
                    Saturday__c                                = selectedrecord[i].Saturday__c,      
                    sunday__c                                  = selectedrecord[i].sunday__c  
                 
                    );
                    if( selectedrecord[i].Monday__c                           != false||
                        selectedrecord[i].Tuesday__c                          != false||
                        selectedrecord[i].Wednesday__c                        != false||
                        selectedrecord[i].Thursday__c                         != false||
                        selectedrecord[i].Friday__c                           != false||
                        selectedrecord[i].Saturday__c                         != false||
                        selectedrecord[i].sunday__c                           != false)
                     {
                     
                     Errormessage = false;                     
                     }
                     else
                     {                   
                     Errormessage  = true;                       
                     }
                }
            }
              
              if(Errormessage  == false)
              {
                if(md != null)
                {
                    try
                    {
                        Database.SaveResult SR = database.update(md);
                        if(SR.IsSuccess())
                        {
                           selectedrecord.remove(i);  
                           selectedschedule  = true;
        
                        }
                    }
                    catch(exception e)
                    {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                    }
                } 
              }
                else
                {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one day for the Groupon Now! deal from the Days Valid section.');
                 ApexPages.addMessage(myMsg);
                }
                        
            
        break;
        }
    return null;
}
   //EDIT REDEMPTION ADDRESS
   public pagereference editschedule()
            {

                newmode = false;
                selectedschedule = false;
                return null;
            }    
    
    public class schedulewrapper
    {
     public NOW_Schedule__c schedulewrap{get; set;}
        public Id passId {get;set;}
        public schedulewrapper(NOW_Schedule__c addy)
        {
            schedulewrap = addy;
            passid = addy.id;
        }
    }

@istest 
static void testInformationrequest()
 {
//checkbox_class check = new checkbox_class();
account a = new account();
                         a.name = 'nowSchedCont' + system.now();
                         insert a;  
system.assert( a!=null);

 GrouponNow__c grouponnow = new GrouponNow__c();
                      grouponnow.Account_Name__c = a.Id;
                      grouponnow.stage__c   = 'none';
                      insert grouponnow;
system.assert(grouponnow!=null);
date startDate =  date.newInstance(2008, 1, 1);
date endDate   =  date.newInstance(2008, 1, 30);
 Now_schedule__c nowadd = new Now_schedule__c();
 
            nowadd.groupon_now__c                             = grouponnow.Id;
            nowadd.Daily_Unit_Max_for_this_Schedule__c        = 12;
            nowadd.NOW_Start_Date__c                          = startDate ;
            nowadd.NOW_End_Date__c                            = endDate   ;
            nowadd.Start_Time__c                              = null;
            nowadd.End_Time__c                                = null;      
            nowadd.Monday__c                                  = false;        
            nowadd.Tuesday__c                                 = false;       
            nowadd.Wednesday__c                               = false;     
            nowadd.Thursday__c                                = false;      
            nowadd.Friday__c                                  = false;       
            nowadd.Saturday__c                                = false;      
            nowadd.sunday__c                                  = true;             
                                         
 Test.starttest();
 insert nowadd;
 Test.stoptest();
 system.assert(nowadd!=null); 
 
PageReference pageRef = Page.now_schedule;
string currentid = pageRef.getParameters().put('Id', grouponnow.id);
Test.setCurrentPage(pageRef);

//Pass to the controller the Grouponnow value
ApexPages.StandardController ApptController = new ApexPages.StandardController(grouponnow); 
now_Schedule_controller check = new  now_Schedule_controller(ApptController); 
 
check.schedule = nowadd;
check.schedulelist.add(new now_Schedule_controller.schedulewrapper(nowadd));

//Set one of the wrapper values to be selected.
  for( now_Schedule_controller.schedulewrapper checksel : check.schedulelist)
  {
  checksel.passid = nowadd.Id;  
  }
//call the subsequent methods.
  check.selectedrecord.add(nowadd);
   check.strSelectedRec = nowadd.id;
   check.strEditSelId  = nowadd.Id;
   system.assert(check.strEditSelId !=null || check.strEditSelId != '');
   system.assert(check.strSelectedRec != null ||check.strSelectedRec != '');
   system.assertequals(check.strEditSelId,check.selectedrecord[0].Id);  
   check.Updatemethod();
   check.getSelected();
   check.Getselectedaddress();
   check.delschedules();
   check.editschedule();

  check.getallschedule();  
  check.cancelnewmode();
  check.addAddress();
  check.getschedule();
  check.savenew();
  check.cancel();
  check.getselectedschedule();
  check.setselectedschedule(true);
  //check.savenew();
 }     
    
}