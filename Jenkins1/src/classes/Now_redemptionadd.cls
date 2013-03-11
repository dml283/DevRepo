public with sharing class Now_redemptionadd {

    public boolean newmode{get;set;}
    public Boolean selecteddeal = true;
    public string strDelSelId{get;set;}
    public string strEditSelId{get;set;}
    public string strSelectedRec{get;set;}
    public Now_Redemption_Address__c md;
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    list<redeptionwrapper>  Redemptionlist = new list<redeptionwrapper>();
    public list<Now_Redemption_Address__c> selectedrecord = new list<Now_Redemption_Address__c>();
        public boolean pageflag{get;set;}

    public Now_Redemption_Address__c redemption = new Now_Redemption_Address__c();
    
    
    public Now_redemptionadd(ApexPages.StandardController controller) {
    newmode = false;
    //redemption = null;
    }

//GETTER METHOD TO RETURN REDEMPTION ADDRESSES.
    public Now_Redemption_Address__c getredemptionadd()
    {
        return redemption;      
    }

//SAVE NEW 

    public PageReference savenew ()
    {
system.debug('Called from Test method' + currentid);

        Now_Redemption_Address__c savenewrec = new Now_Redemption_Address__c
            (  
                
                Phone_Number__c                         = redemption.Phone_Number__c,
                Groupon_now__c                          = currentid,
                Address_Line_1__c                       = redemption.Address_Line_1__c,
                Address_Line_2__c                       = redemption.Address_Line_2__c,
                City__c                                 = redemption.City__c ,
                State__c                                = redemption.State__c,                                      
                Zip_code__c                             = redemption.Zip_code__c,
                Venue_Name__c                           = redemption.Venue_Name__c,
                Country__c                              = redemption.Country__c
                   
            );
 system.debug('CATCHING THE BUG' + savenewrec);            
        Database.SaveResult SR = database.insert(savenewrec);
        if(sr.isSuccess())
        {
redemption.Phone_Number__c = '';
redemption.Address_Line_1__c = '';
redemption.Address_Line_2__c = '';
redemption.City__c = '';
redemption.State__c = '';
redemption.Zip_code__c ='';
redemption.Venue_Name__c ='';
redemption.Country__c='';
            cancelnewmode();
            
        }
         return null;

}   

//CANCEL MODE
    public PageReference cancelnewmode()
    {
        newmode = false;
        selecteddeal = true;
        return null;
    }
    

//CANCEL MODE

 public PageReference cancel()
    {
       
        selecteddeal = true;
        strEditSelId = null;
        return null;
    }
//ADD ADDRESS 

   public PageReference addAddress()
    {
        newmode = true;
        selecteddeal = true;
        strDelSelId = null;
        strEditSelId = null;
        //multinew.clear();
        return null;
    }
     
        
//DELETE METHOD
  public void delredemptaddress()
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
            
    public boolean getselecteddeal()
    {
        return selecteddeal;
    }
  
    public void setselecteddeal(Boolean selecteddeal)
    {
        this.selecteddeal= selecteddeal;
    }
//GET ALL REDEMPTION ADDRESSES
  public List<redeptionwrapper> getalladdress()
    {
        Redemptionlist.clear();
        for(Now_Redemption_Address__c mul : [select Id,name,Phone_Number__c,Address_Line_1__c,Address_Line_2__c,City__c,State__c,Zip_code__c,Venue_Name__c,Country__c from Now_Redemption_Address__c where Groupon_Now__c =: CurrentId])
        Redemptionlist.add(new redeptionwrapper(mul));
        system.debug('Redemptionlist size' + Redemptionlist.size());
        return Redemptionlist;  
    }
    
  public PageReference getSelected()
            {
        
                selectedrecord.clear();
            if(strEditSelId != null)
            {
           
                    for(redeptionwrapper Infowrapper: Redemptionlist)
                {
                         if(Infowrapper.passId == strEditSelId)
                        {
                        selectedrecord.add(Infowrapper.redemption);
                        }
                        
                }
            }  
                return null;
            }
            
//RETURN SELECTED ADDRESSES
    public List<Now_Redemption_Address__c> Getselectedaddress()
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
    //Update method 
  public boolean getbacktomainpage()
    {
    pageflag = ApexPages.hasMessages(ApexPages.Severity.Error);
    return pageflag ; 
    }
    
public Pagereference Updatemethod()
{
        for(integer i=0;i<selectedrecord.size();i++)
        {
            if(strSelectedRec != '' || strSelectedRec != null)
            {
                if(selectedrecord[i].Id == strSelectedRec)
                {
                md = new Now_Redemption_Address__c
              
                (
                
                Phone_Number__c                         = selectedrecord[i].Phone_Number__c,
                id                                      = selectedrecord[i].Id,
                Address_Line_1__c                       = selectedrecord[i].Address_Line_1__c,
                Address_Line_2__c                       = selectedrecord[i].Address_Line_2__c,
                City__c                                 = selectedrecord[i].City__c ,
                State__c                                = selectedrecord[i].State__c,                                      
                Zip_code__c                             = selectedrecord[i].Zip_code__c,
                Venue_Name__c                           = selectedrecord[i].Venue_Name__c,
                Country__c                              = selectedrecord[i].Country__c
       
                );
                }
            }
            if(md != null)
            {
                Database.SaveResult SR = database.update(md);
                if(SR.IsSuccess())
                {
                   selectedrecord.remove(i);  
                   selecteddeal = true;

                }
            }
        break;
        }
    return null;
}
    //EDIT REDEMPTION ADDRESS
   public pagereference editRedemptionadd()
            {

                newmode = false;
                selecteddeal = false;
                return null;
            }     
    public class redeptionwrapper
    {
        public Now_Redemption_Address__c redemption{get; set;}
        public Id passId {get;set;}
        public redeptionwrapper(Now_Redemption_Address__c addy)
        {
            redemption = addy;
            passid = addy.id;
        }
    }
@istest 
static void testInformationrequest()
 {
//checkbox_class check = new checkbox_class();
account a = new account();
                         a.name = 'test acct';
                         insert a;  
system.assert( a!=null);

 GrouponNow__c grouponnow = new GrouponNow__c();
                      grouponnow.Account_Name__c = a.Id;
                      grouponnow.stage__c   = 'none';
                      insert grouponnow;
system.assert(grouponnow!=null);
 Now_Redemption_Address__c nowadd = new Now_Redemption_Address__c();
                nowadd.Phone_Number__c                         = '1234567890';
                nowadd.Groupon_now__c                          = grouponnow.id;
                nowadd.Address_Line_1__c                       = 'test addy 1';
                nowadd.Address_Line_2__c                       = 'test addy 2';
                nowadd.City__c                                 = 'sunnyvale' ;
                nowadd.State__c                                = 'CAL';                                      
                nowadd.Zip_code__c                             = '12345';
                nowadd.Venue_Name__c                           = 'test venue';
                nowadd.Country__c                              = 'USA';
                                         
 Test.starttest();
 insert nowadd;
 Test.stoptest();
 system.assert(nowadd!=null); 
 
PageReference pageRef = Page.now_redemptionadd;
string currentid = pageRef.getParameters().put('Id', grouponnow.id);
Test.setCurrentPage(pageRef);

//Pass to the controller the Grouponnow value
ApexPages.StandardController ApptController = new ApexPages.StandardController(grouponnow); 
Now_redemptionadd check = new  Now_redemptionadd(ApptController); 
 
check.redemption = nowadd;

check.Redemptionlist.add(new Now_redemptionadd.redeptionwrapper(nowadd));

//Set one of the wrapper values to be selected.
  for( Now_redemptionadd.redeptionwrapper checksel : check.Redemptionlist)
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
   if(check.strSelectedRec == check.strEditSelId)
   {
   system.debug('HERE' + check.strSelectedRec + check.strEditSelId);
    now_redemption_address__c newupdate =  new Now_Redemption_Address__c
      
       (      
        Phone_Number__c = check.selectedrecord[0].Phone_Number__c,
        id = check.selectedrecord[0].Id,
        Address_Line_1__c = 'updating address',
        Address_Line_2__c = check.selectedrecord[0].Address_Line_2__c,
        City__c = check.selectedrecord[0].City__c ,
        State__c = check.selectedrecord[0].State__c,
        Zip_code__c = check.selectedrecord[0].Zip_code__c,
        Venue_Name__c = check.selectedrecord[0].Venue_Name__c,
        Country__c = check.selectedrecord[0].Country__c     
        );
        update newupdate;
   }
   check.Updatemethod();
   check.getSelected();
   check.Getselectedaddress();
   check.delredemptaddress();
   check.editRedemptionadd();

  check.getalladdress();  
  check.cancelnewmode();
  check.addAddress();
  check.getredemptionadd();
  check.savenew();
  check.cancel();
  check.getselecteddeal();
  check.setselecteddeal(true);
  //check.savenew();
 }     
}