//Class   : Opportunity_info_request
//Purpose : To create an inline view of the Information Requests realted to the opportunity. The page will let the users insert,delete,
//          Update the Information request realted to the opportunity without switching screens.

public class Opportunity_info_request
{

    public Opportunity_info_request(ApexPages.StandardController controller) {

    }

    public information_request__c infonew = new information_request__c();
    public List<Informationreqwrapper> inforeqlist = new List<Informationreqwrapper>();
    public List<Information_request__c> SelectedInforequest = new List<Information_request__c>();
    public string CurrentId = ApexPages.currentPage().getParameters().get('Id');
    public boolean fromsave;
    public string strSelectedRec { get; set;}
    public boolean newmode = false;
    public Boolean readonly = true;
    public boolean editmode;
    public Boolean selectedinfo = true;
    public OpportunityTeamMember oppteamfin;
/*Constructor   
    public checkbox_class()
    {

    }*/
   
 
// Method   :   getinfovalue()
// Called By:   VF Page (when the new button is hit the getinfovalue() method is called by the page to render each input field
//              on the page). The feilds are rendered on the page only when the newmode = true. when the user clicks on the new 
//              button the addAddress() method is called which sets the newmode = true. 
//**************************************************************************************
//Important :   The look and feel of the other pageblocks/pageblockstables are controlled from appearing/dissappearing 
//              by rendering the blocks based on the newmode flag. 
//              When the Pageblock needs to be rendered rendered="{!newmode}" and when it has to be hidden
//              rendered="{!IF(NOT(newmode),true,false)}" 
//**************************************************************************************
// Purpose  :   Created to get the value of the selected user input value from the page inorder to insert a new Information Request.
//              infonew is of type List<Information_Request__c> and by using . notation the fields of the Information Request object can be accessed 
//              in the page e.g infovalue.name   
    public Information_request__c getinfovalue()
    {
        return infonew;
    }

// Method    : savenew()
// Called By : VF Page ( When the save button is clicked on the page while inserting records). 
//             The save button is  rendered on the page only when the newmode = true. when the user clicks on the new 
//             button the addAddress() method is called which sets the newmode = true. 
//**************************************************************************************
//Important :   The look and feel of the other pageblocks/pageblockstables are controlled from appearing/dissappearing 
//              by rendering the blocks based on the newmode flag. 
//              When the Pageblock needs to be rendered rendered="{!newmode}" and when it has to be hidden
//              rendered="{!IF(NOT(newmode),true,false)}" 
//**************************************************************************************
//Purpose:      The savenew() method inserts a new informationrequest record and on successful save it calls the cancelnewmode(). 
//              The cancelnewmode() method displays all the available Information Request options to edit.
    public PageReference savenew()
    { 
system.debug('Called from Test method' + currentid);
        Information_request__c savenewrec = new Information_request__c
            (  
     
                opportunity__c                                = currentid,
                Requestor__c                                  = infonew.Requestor__c,
                Who_do_you_need_information_from__c           = infonew.Who_do_you_need_information_from__c,
                Issue_Resolved__c                             = infonew.Issue_Resolved__c,                 
                Date_Requested__c                             = infonew.Date_Requested__c,
                Information_Requested_By__c                   = infonew.Information_Requested_By__c,
                Date_Resolved__c                              = infonew.Date_Resolved__c,
                Response__c                                   = infonew.Response__c,
                Please_describe_the_information_you_need__c   = infonew.Please_describe_the_information_you_need__c
            );
        try
        {
        Database.SaveResult SR = database.insert(savenewrec);
            if(sr.isSuccess())
            {
                cancelnewmode();
            }
        }
       catch(Exception ex)
        {
          ApexPages.addMessages(ex);
        }
    return null;

    }
  
//Method   :   cancelnewmode()
//Called By:   VF page: when the user clicks new button he gets options to cancel and save.When the user clicks the cancel button 
//             the cancelnewmode() is called.savenew() calls this method to display the available options on successful save.
//Purpose  :   Cancels the page out of the newmode thus rendering the  pageblock table which shows list of all available Information Requests.
    public PageReference cancelnewmode()
    {
        newmode = false;
        return null;
    }

// Method   : addAddress()
// Called By: VF Page : When the user clicks the new button addAddress() is called. This method sets 
// Purpose  : This method sets the newmode flag on and displays the fields to the user to create a new Information request.  
    public PageReference addAddress()
    {
        newmode = true;
        infonew.clear();
        return null;
    }
//Method   : save()
//Called By: VF Page. when the user clicks on the checkbox next ot the record he gets options to cancel and save.
//           When the user clicks the save button the save() is called.
//Purpose  : The save() method updates the selected records based on the user input.
   
    public PageReference save()
    {
    Information_Request__c md;
        for(integer i=0;i<SelectedInforequest.size();i++)
        {
            if(strSelectedRec != '' || strSelectedRec != null)
            {
                if(SelectedInforequest[i].Id == strSelectedRec)
                {
                md = new Information_Request__c
              
                (
                id                                           = SelectedInforequest[i].Id,
                Issue_Resolved__c                            = SelectedInforequest[i].Issue_Resolved__c,
                Requestor__c                                 = SelectedInforequest[i].Requestor__c,
                Who_do_you_need_information_from__c          = SelectedInforequest[i].Who_do_you_need_information_from__c,
                Date_Requested__c                            = SelectedInforequest[i].Date_Requested__c,
                Information_Requested_By__c                  = SelectedInforequest[i].Information_Requested_By__c,
                Date_Resolved__c                             = SelectedInforequest[i].Date_Resolved__c,
                Response__c                                  = SelectedInforequest[i].Response__c,
                Please_describe_the_information_you_need__c  = SelectedInforequest[i].Please_describe_the_information_you_need__c
                );
                }
            }
            if(md != null)
            {
              
               try
               {
                Database.SaveResult SR = database.update(md);
                    if(SR.IsSuccess())
                    {
                       SelectedInforequest.remove(i);  
                       selectedinfo = true;
    
                    }
                }
               catch(Exception ex)
                {
               ApexPages.addMessages(ex);

               }
                
            }
        break;
        }
    return null;
    }

//Method   : cancel()
//Called By: VF Page. when the user clicks on the checkbox next ot the record he gets options to cancel and save.
//           When the user clicks the cancel button the cancel() is called.
//Purpose  : The cancel() method cancels out of the Selected deal option pageblock table and shows the 
//           List of all deals table.  
    public PageReference cancel()
    {
        SelectedInforequest.clear();
        inforeqlist.clear();
        fromsave = true;
        inlineedit();
        selectedinfo = true;
        return null;
    }


       public boolean getselectedinfo()
    {
        return selectedinfo;
    }
  
    public void setselectedinfo(Boolean selectedinfo)
    {
        this.selectedinfo= selectedinfo;
    }
  
    //Read only mode.
         
    public boolean getreadonlymode()
    {
        return readonly;
    }
  
    public void setreadonlymode(Boolean readonly)
    {
        this.readonly= readonly;
    }
    //Edit mode
    public boolean geteditmode()
    {
        return editmode;
    }
  
    public void seteditmode(Boolean editmode)
    {
        this.editmode= editmode;
    }
  
  
    public PageReference inlineedit()
    {
        if(fromsave == true)
        {
            readonly = true;
            editmode = false;
        }
        else
        {
            readonly = false;
            editmode = true;

        }
        fromsave = false;
    return null;
    }
    //New mode.
    public boolean getnewmode()
    {
        return newmode;
    }
  
    public void setnewmode(Boolean newmode)
    {
        this.newmode= newmode;
    }
  
    //End new mode. 

   public  OpportunityTeamMember getoppteammem()
    {

       List<OpportunityTeamMember> oppteammember = [Select o.CreatedById, o.CreatedDate, o.Id, o.IsDeleted, o.OpportunityAccessLevel, o.OpportunityId, o.TeamMemberRole, o.UserId, o.User.Name from OpportunityTeamMember o where o.OpportunityId=: CurrentId and o.TeamMemberRole =: 'Account Coordinator' Order BY lastmodifieddate];
       if(oppteammember.size()>0)
       {
           for(OpportunityTeamMember oppteam: oppteammember )
           {
            oppteamfin = oppteam;
           }
           return oppteamfin;
       }
       else
       {
        return null;
       }
       
    }
//Method   : getinfodata()
//Called By: VF page:  when the page loads the List of Deal options are displayed by calling this method.
//Purpose  : Queries the Information Request  associated with the opportunity and displays to the user.
    public List<Informationreqwrapper> getinfodata()
    {
        system.debug('Current ID' + currentid);
        inforeqlist.clear();
        for(Information_Request__c Info : [select    id,name,Date_Requested__c,Information_Requested_By__c, 
                                                     Please_describe_the_information_you_need__c ,Date_Resolved__c,
                                                     opportunity__c, opportunity__r.DV__c, opportunity__r.DV__r.name, 
                                                     opportunity__r.AccountCoordinator__c,opportunity__r.AccountCoordinator__r.name,
                                                     opportunity__r.User__c,opportunity__r.User__r.name,
                                                     opportunity__r.Owner_lookup__c,opportunity__r.Owner_lookup__r.name,
                                                     opportunity__r.Divisional_Sales_Manager__c,opportunity__r.Divisional_Sales_Manager__r.name,
                                                     opportunity__r.Reviews_Writer__c,opportunity__r.Researcher__c,
                                                     opportunity__r.Fact_Checker__c,opportunity__r.Voice_Editor__c,
                                                     opportunity__r.Copy_Editor__c,opportunity__r.Image_Designer__c,
                                                     opportunity__r.Site_Editor__c,opportunity__r.Deal_Creator__c,                                                    
                                                     Who_do_you_need_information_from__c,Response__c,
                                                     Requestor__c,Requestor__r.name,
                                                     Issue_Resolved__c                                                    
                                           from      Information_request__c 
                                           where     opportunity__c=: CurrentId ORDER BY Issue_resolved__c asc])
        inforeqlist.add(new Informationreqwrapper(Info));
        system.debug('inforeqlist size' + inforeqlist.size());
        return inforeqlist;
  
    }
//Method   : getSelected()
//Called By: VF page:  when the user clicks the checkbox next to the list of available deals the selected records are store in a list to 
//           be rendered in another pageblocktable.
//Purpose  : Checks if the user selected any record from the List of available deals and if the user selected aleast one record
//           the records are added to the SelectedInforequest list.
    public PageReference getSelected()
    {

        SelectedInforequest.clear();
        for(Informationreqwrapper Infowrapper: inforeqlist)
        if(Infowrapper.selected == true)
        {
        SelectedInforequest.add(Infowrapper.InformationRequest);
        readonly = false;
        editmode = true;
        selectedinfo = false;
        }
        return null;
    }
//Method   : GetSelectedInforequest()
//Called By: VF page:  when the user clicks the checkbox next to the list of available deals the selected records are rendered
//           in a pageblocktable by calling this method.
//Purpose  : The list "SelectedInforequest" is displayed to the user when the Pageblocktable calls this method.
    public List<Information_request__c> GetSelectedInforequest()
    {
        if(SelectedInforequest.size()>0)
        return SelectedInforequest;
        else
        return null;
    }
  
//Method   : deleteSelected()
//Called By: VF page:  when the user clicks the checkbox next to the list of available deals the delete button is rendered
//           on the page and when the user clicks on delete the deleteSelected() is called .
//Purpose  : The  "SelectedInforequest" list is deleted in this method.
    public PageReference deleteSelected()
    {
     
        if(SelectedInforequest.size()>0)
        {
        try
        {
            database.delete(SelectedInforequest); 
           //inforeqlist.clear();
            SelectedInforequest.clear();
            selectedinfo = true;
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        }
    return null;            
    }
//Class    : Informationreqwrapper()
//Called By: Checkbox_class .
//Purpose  : This wrapper class contains the user inputs. The wrapper class is a temproary holder where the basic data types
//           when not available, we can create a holder and get the user selected values.
  
    public class Informationreqwrapper
    {
        public Information_request__c InformationRequest{get; set;}
        public opportunity opport{get;set;}
        public Boolean selected {get; set;}
        public Informationreqwrapper(Information_request__c a)
        {
            InformationRequest = a;
            selected = false;
        }
    }
@istest 
static void testInformationrequest()
 {

//checkbox_class check = new checkbox_class();


 account a = new account();
                         a.name = 'Opportunity_info_request' + system.now();
                         insert a;                       
 system.assert(a.id!= null);                        
                         opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.StageName = 'Prospecting';
                         o.CloseDate = date.today();
                         o.Deal_Strengh__c = 'Rep Getting Info';
                         o.Feature_Date__c = date.newinstance(2011, 7, 15);
                         o.AccountId = a.Id;
                         insert o; 
                       
 system.assert(o.id!= null);  
 User U = [select id from user where id!= null limit 1];
 Information_request__c md2 = new Information_request__c();
                         md2.Opportunity__c                                =  o.id;
                         md2.Who_do_you_need_information_from__c           = 'DSM';
                         md2.Information_Requested_By__c                   =  U.Id;
                         md2.What_is_Missing__c                            = 'other';
                         md2.Please_describe_the_information_you_need__c   = 'Test';
 Test.starttest();
 insert md2;
 Test.stoptest();
system.assert(md2.id!=null);

PageReference p = Page.oppinformationrequest;
Test.setCurrentPageReference(p);

//add the current page id.
string currentid = ApexPages.currentPage().getParameters().put('id', o.id);

//Pass to the controller the Opportunity value
ApexPages.StandardController ApptController = new ApexPages.StandardController(o); 
Opportunity_info_request check = new  Opportunity_info_request(ApptController);  

 check.inforeqlist.add(new Opportunity_info_request.Informationreqwrapper(md2));
 System.Assert(check.inforeqlist != null);


//Set one of the wrapper values to be selected.
  for( Opportunity_info_request.Informationreqwrapper checksel : check.inforeqlist)
  {
  checksel.selected = true;  
  check.Selectedinforequest.add(checksel.InformationRequest);
  }
   check.save();
   check.strSelectedRec = md2.id;
   check.getSelected();
   check.GetSelectedInforequest();
   check.deleteSelected();
   check.getselectedinfo();
   check.setselectedinfo(true);
//call the subsequent methods.

  check.getinfodata();  
  check.getreadonlymode();
  check.geteditmode();
  check.cancelnewmode();
  check.addAddress();
  check.getinfovalue();
  check.cancel();
  check.savenew();
  check.inlineedit();
  check.getnewmode();
  check.setnewmode(true);
  check.setreadonlymode(false);
  check.seteditmode(true); 
  check.getoppteammem();   
 }   
}