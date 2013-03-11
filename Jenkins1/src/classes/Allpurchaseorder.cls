public class Allpurchaseorder 
{ 
//Declarations.here
    public List<AssignedTo__c> AssignedTo;
    public Id AssignedToID{get;set;}
    public string todaysdate{get;set;}
    public string AssignedToname{get;set;}
    public List<PinnedMerchant__c> pinnedmerchant;
    public List<Purchase_Order__c> Purchaseorders = new List<Purchase_Order__c>();  
    set<Id> purchaseslist = new set<id>();
    list<id> salesgoallist = new list<id>();
    list<purchase_order__c> purchaseids = new list<purchase_order__c>();
    list<purchase_order__c> POthathaveassignandLeadoppowner = new list<purchase_order__c>();
   
//This method is used to redirect the user to the perfect pipeline view when the user clicks the view pipeline button.
    public pagereference getpageredirect()
    {
        pagereference pageref = new pagereference('https://c.na8.visual.force.com/apex/PerfectPipeline');
        pageref.setredirect(true);
    return pageref;
    }

//This method generates the query for picking the assignedTo values and the salesgroup related to the user to be emailed out.
//Pickup the division from the salesgroup and find the assigned to values related to the user and the salesgoal division.
    public string AssignedSOQL()
    {     
      Purchaseorders = [select Id,Name,division__c,ownerId from Purchase_order__c where PO_status__c = 'Open' and target_feature_date__c >=: system.today() AND  (target_feature_date__c >=: system.today() and target_feature_date__c <=: (system.today()+42))];
       list<string> POdivision = new list<string>();

       for(purchase_order__c purch : Purchaseorders )
      {
      POdivision.add(purch.division__c);
      }
        list<sales_goal__c> salesgoal = new list<sales_goal__c>();  
        salesgoal = [select Goal_Start_date__c,Goal_End_Date__c,division__c,ownerId from sales_goal__c where Goal_Start_date__c <=: system.today()and Goal_end_date__c >=: system.today()and  division__c IN: POdivision ];
        //and ((Goal_end_date__c >=: system.today() and Goal_end_date__c <=: (system.today()+7))
         system.debug('SALESGOAL ' + salesgoal);
            if(salesgoal != null) 
            {       
                for(sales_goal__c sale : salesgoal)
                {
                    salesgoallist.add(sale.division__c);
                }
            }
            system.debug('SALESGOAL LIST' + salesgoallist);
        string AssignedToquery = 'select id,purchase_order__c,assigned_to__r.name,purchase_order__r.Target_feature_Date__c,purchase_order__r.subdivision__c,purchase_order__r.PO_Notes__c, purchase_order__r.subdivision__r.name, purchase_order__r.Ideal_Price_Range__c,purchase_order__r.Example_Deal_1__c,purchase_order__r.Example_Deal_2__c, purchase_order__r.Division__r.name,purchase_order__r.name,purchase_order__r.Global_SFDC_Category__c,purchase_order__r.Global_SFDC_Subcategory_1__c, purchase_order__r.Global_SFDC_Subcategory_2__c,purchase_order__r.opportunity__r.name,assigned_to__c,name from AssignedTo__c where assigned_to__r.Id =: AssignedToID and purchase_order__r.division__c IN: salesgoallist ';
        // string    AssignedToquery = 'select id,purchase_order__c,assigned_to__r.name,purchase_order__r.Target_feature_Date__c,purchase_order__r.subdivision__c,purchase_order__r.PO_Notes__c, purchase_order__r.subdivision__r.name, purchase_order__r.Ideal_Price_Range__c,purchase_order__r.Example_Deal_1__c,purchase_order__r.Example_Deal_2__c, purchase_order__r.Division__r.name,purchase_order__r.name,purchase_order__r.Global_SFDC_Category__c,purchase_order__r.Global_SFDC_Subcategory_1__c, purchase_order__r.Global_SFDC_Subcategory_2__c,purchase_order__r.opportunity__r.name,assigned_to__c,name from AssignedTo__c where assigned_to__r.Id =: AssignedToID ';
        
    return AssignedToquery ;                         
    }

//This metod prepares the purchaselist,purchasesids which holds the subdivision,purchaseorder info.
    public List<Assignedto__c> assigneduser()
    {
        string returnquery = AssignedSOQL();
        AssignedTo = database.query(returnquery);
            for(AssignedTo__c Assigned: AssignedTo)
            {
                purchaseslist.add(Assigned.purchase_order__r.subdivision__c);
                purchaseids.add(Assigned.purchase_order__r);
            }
    return AssignedTo ;
    }
//The below method is called by the page to display the header values for the email.
    public assignedto__c getassigneduserval()
    {
        assigneduser();
            for(assignedto__c assign: AssignedTo )
            {         
                return assign;
            }
    return null;
    }
   
//getSubdivisions method is called to iterate the whole list of purchase orders and the realted pinned merchants for every subdivision.
    public Subdivision__c getsubdivisions()
    {
        getassigneduserval();
        list<subdivision__c> sublist;        
        sublist = [select id,name from Subdivision__c where id IN: purchaseslist ];
            for(subdivision__c sub : sublist)
            {
                return sub;
            }
    return null;
    }

//Main method which populated the data to be sent over to the wrapper class.
    public list<wrapperclass> getpinnedlead()
    {
        List<wrapperclass> purchaselistwrap =new List<wrapperclass>();
        list<date> datelist = new list<date>{system.today(),(system.today()+1),(system.today()+2),(system.today()+3),(system.today()+4),(system.today()+5),(system.today()+6),(system.today()+7),(system.today()+8),(system.today()+9),(system.today()+10),(system.today()+11),(system.today()+12),(system.today()+13),(system.today()+14),(system.today()+15),(system.today()+ 16),(system.today()+17),(system.today()+18),(system.today()+19),(system.today()+20),(system.today()+21),
(system.today()+22),(system.today()+23),(system.today()+24),(system.today()+25),(system.today()+26),(system.today()+27),(system.today()+28),(system.today()+29),(system.today()+30),(system.today()+31),(system.today()+32),(system.today()+33),(system.today()+34),(system.today()+35),(system.today()+36),(system.today()+ 37),(system.today()+38),(system.today()+39),(system.today()+40),(system.today()+41),(system.today()+42)};
        set<id> purchaseids = new set<id>();
        
        //Get the purchase order which has atleast one assigneTo related to the PO.
        list<AssignedTo__c> assignedval = [select id,purchase_order__c,assigned_to__r.name,purchase_order__r.Target_feature_Date__c,purchase_order__r.subdivision__c,purchase_order__r.PO_Notes__c, purchase_order__r.subdivision__r.name, purchase_order__r.Ideal_Price_Range__c,purchase_order__r.Example_Deal_1__c,purchase_order__r.Example_Deal_2__c, purchase_order__r.Division__r.name,purchase_order__r.name,purchase_order__r.Global_SFDC_Category__c,purchase_order__r.Global_SFDC_Subcategory_1__c, purchase_order__r.Global_SFDC_Subcategory_2__c,purchase_order__r.opportunity__r.name,assigned_to__c,name from AssignedTo__c where (assigned_to__r.Id =: AssignedToID)];
            for(assignedTo__c purchases : assignedval )
            {
                purchaseids.add(purchases.purchase_order__c);        
            }
       //Get the purchase order which has atleast one pinned merchant related to the PO.
        list<pinnedmerchant__c> pinnedmerchants = [select id,purchase_order__c,ownerid,Lead__c,Lead__r.ownerid,Account__r.ownerId,Lead__r.Details__c,opportunity__c,opportunity__r.ownerid  from pinnedmerchant__c where Lead__r.ownerid=:AssignedToID OR opportunity__r.account.ownerid =:AssignedToID OR Account__r.ownerid =:AssignedToID ];
            for(pinnedmerchant__c pinned: pinnedmerchants)
            {
                purchaseids.add(pinned.purchase_order__c);
            }
        //Get the PO's that have atleast one assignedTo field or atleast having a lead/opportunity assocaited with the merchant associated with the user in the context.
        POthathaveassignandLeadoppowner  = [select id,name,Subdivision__r.name,target_feature_date__c,Rep_PO_Notes__c,Global_SFDC_Category__c,Global_SFDC_Subcategory_1__c,Global_SFDC_Subcategory_2__c,Ideal_Price_Range__c,example_deal_1__c,example_deal_2__c,PO_Notes__c from purchase_order__c where id =:purchaseids and (target_feature_date__c IN : datelist ) and division__c IN:salesgoallist  and PO_Status__c = 'Open' ORDER BY Target_feature_date__c ASC];
        //POthathaveassignandLeadoppowner  = [select id,name,Subdivision__r.name,Rep_PO_Notes__c,target_feature_date__c,Global_SFDC_Category__c,Global_SFDC_Subcategory_1__c,Global_SFDC_Subcategory_2__c,Ideal_Price_Range__c,example_deal_1__c,example_deal_2__c,PO_Notes__c from purchase_order__c where id =:purchaseids and (target_feature_date__c IN : datelist )  ORDER BY Target_feature_date__c DESC ];
            //send the purchaseids list to the wrapper class to access the data in the page.
            for(purchase_order__c purchases : POthathaveassignandLeadoppowner  )
            {   
                purchaselistwrap.add(new wrapperclass(purchases,datelist,AssignedToId));
            }    
    return purchaselistwrap;   
    }
//Wrapper class.
    public class wrapperclass
    {        
        public list<date> datemaster{get;set;}
        public purchase_order__c master {get; set;}
        public Id AssignedID{get;set;}
        public List<pinnedmerchant__c> related;
        public list<task> taskinfo = new list<task>();
        public list<pinnedmerchant__c> purchasesfromwrap;
        public contact contactrec{get;set;}

         public List<date> dateValue = new List<date>();
        list<purchase_order__c> purchasetoret = new list<purchase_order__c>();
        //constructor
        public wrapperclass(purchase_order__c purchasesmaster, list<date> datelist, Id AssignedtoId)
        {           
        master = purchasesmaster; 
        datemaster = datelist; 
        AssignedId = AssignedtoId;   
        }
        //Pinned merchant info related to the master.

        public List<Contactwrapper> getRelated()
        {    
           List<Contactwrapper> contwrap = new List<Contactwrapper>();
            if (null==related)
            {
                related= [SELECT    id,name, Opportunity__c , ownerId ,Account__r.RepnotesDate__c ,Account__r.Repnotes__c ,Account__r.ownerid,Account__r.Re_Feature_Status_Rep__c,Account__r.id,Account__r.name,Lead__r.Repnotes__c,Lead__r.RepnotesDate__c,opportunity__r.Account.RepnotesDate__c,
                                    opportunity__r.Account.Repnotes__c,Opportunity__r.Feature_Date__c, opportunity__r.StageName, Opportunity__r.Account.phone,
                                    Opportunity__r.name,opportunity__r.Account.Re_Feature_Status_Rep__c,opportunity__r.Account.name,lead__r.name,lead__r.status,
                                    lead__r.phone,Lead__r.Details__c,lead__r.company,Opportunity__r.Account.owner.name,lead__r.owner.name,
                                    Purchase_order__r.name 
                            FROM    PinnedMerchant__c  
                            WHERE  (Purchase_order__C =:master.Id) and (opportunity__r.Account.Ownerid =: AssignedId OR Lead__r.ownerid =: AssignedId OR Account__r.ownerid =: AssignedId) ];   
            }
         for(pinnedmerchant__c merch : related)
            contwrap.add(new contactwrapper(merch,merch.opportunity__r.accountId,merch.account__c));
        return contwrap;
        }
        
    }
    public class Contactwrapper
    {
    public string accountId{get;set;}
    public pinnedmerchant__c pinnedmerch{get;set;}
    public string accountOpp{get;set;}
    public contact contactval{get;set;}
    public contactwrapper(pinnedmerchant__c pinmer,Id accountOfOpp,Id account_Id)   
    {
    pinnedmerch = pinmer ;
    accountOpp  = accountOfOpp;
    accountId   = account_Id ;
    }
    public contact getcontactinfo()
    {
        if(accountOpp != null)
        {
        contactval = [select Id, name, phone from contact where AccountId =: accountOpp ORDER BY LASTMODIFIEDDATE DESC LIMIT 1];
        }

     return contactval;
    }  
    }
@Istest
public static void testme(){
Allpurchaseorder all_PO = new Allpurchaseorder();

division__c div = new division__c();
div.name = 'Chicago';
div.state__c = 'IL';
insert div;

subdivision__c subdiv = new subdivision__c();
subdiv.division__c = div.Id;
subdiv.name = 'Test subdiv';
Insert subdiv;

purchase_order__c PO = new purchase_order__c();
PO.Target_feature_date__c = date.today();
PO.PO_status__c = 'Open';
PO.division__c = div.Id;
po.ownerId = UserInfo.getUserId() ;
po.subdivision__c = subdiv.Id;
insert PO;

pinnedmerchant__c pinned = new pinnedmerchant__c();
pinned.purchase_order__c = PO.Id;
Insert pinned;

Account acc = new account();
acc.name = 'Test name';
acc.Billingstate = 'CA';
insert acc;
contact con = new contact();
con.accountId = acc.Id;
con.lastname  = 'Test name';
Insert con;

sales_goal__c sales = new sales_goal__c();
sales.goal_start_date__c = date.today()-1;
sales.goal_end_date__c   = date.today()+1;
sales.division__c = PO.division__c;
sales.ownerid     = po.ownerId;
Insert sales;

AssignedTo__c  assign = new AssignedTo__c ();
assign.purchase_order__c = PO.Id;
assign.assigned_to__c    = Po.ownerId;
Insert assign;
list<date> datelist = new list<date>{system.today(),(system.today()+1)};
Allpurchaseorder.wrapperclass wrapinst = new Allpurchaseorder.wrapperclass(PO,datelist,userinfo.getuserId());
Allpurchaseorder.contactwrapper continst = new Allpurchaseorder.contactwrapper(pinned,acc.Id,acc.Id);
all_PO.getpageredirect();
all_PO.getsubdivisions();
all_PO.getpinnedlead();
wrapinst.getRelated();
continst.getcontactinfo();
}
}