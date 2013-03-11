global class sendmessage implements Database.Batchable<sObject>{

   public string Query;
   public static Boolean runTestMethod = false;
   public set<Id> Pousers = new set<Id>();
   public list<string> pouseremail = new list<string>();
   public List<Purchase_Order__c> Purchaseorders = new List<Purchase_Order__c>();
   public EmailTemplate et= [SELECT id FROM EmailTemplate WHERE name = 'Email_PO_Template'];
   public list<AssignedTo__c> assigned = new list<AssignedTo__c>();
   public list<pinnedmerchant__c> assignedleads = new list<pinnedmerchant__c> ();
   public string ownername;
   public set<Id> finalsalesgroupusers = new set<id>();
   public set<Id> finalusers = new set<Id>();
   public sendmessage()
   {
   
   }
   
   public void buildlistofusers()  
   {
         list<string> POdivision = new list<string>();
      Purchaseorders = [select Id,Name,division__c,ownerId from Purchase_order__c where PO_status__c = 'Open' and target_feature_date__c >=: system.today() AND  (target_feature_date__c >=: system.today() and target_feature_date__c <=: (system.today()+42))];
      assigned       = [select id,Assigned_to__c,Assigned_to__r.name from AssignedTo__c where Purchase_Order__c IN:Purchaseorders and purchase_order__c !=null ];
      assignedleads  = [select id,lead__r.ownerid,opportunity__r.account.ownerid,account__r.ownerid,purchase_order__r.division__c  from pinnedmerchant__c where purchase_order__c IN:purchaseorders];
if(runTestMethod )
{
      Purchaseorders = [select Id,Name,ownerId,Division__c from Purchase_order__c where PO_status__c = 'Open' and target_feature_date__c >=: system.today() AND  (target_feature_date__c >=: system.today() and target_feature_date__c <=: (system.today()+42)) limit 100 ];
      et             = [SELECT id FROM EmailTemplate WHERE name = 'Email_PO_Template'];
      assigned       = [select id,Assigned_to__c,Assigned_to__r.name from AssignedTo__c where Purchase_Order__c IN:Purchaseorders and purchase_order__c !=null limit 100];
      assignedleads  = [select id,lead__r.ownerid,opportunity__r.account.ownerid,account__r.ownerid,purchase_order__r.division__c from pinnedmerchant__c where purchase_order__c IN:purchaseorders limit 100];
}
       for(AssignedTo__c assign : assigned)
       {
          Pousers.add(assign.Assigned_to__c);
       }      
      for(pinnedmerchant__c pinnedlead : assignedleads )
      {          
           if(pinnedlead.lead__r.ownerid != null)
           {
           Pousers.add(pinnedlead.lead__r.ownerid);
           POdivision.add(pinnedlead.purchase_order__r.division__c);
           }
           else if (pinnedlead.account__r.ownerid != null)
           {
           Pousers.add(pinnedlead.account__r.ownerid);
           POdivision.add(pinnedlead.purchase_order__r.division__c);
           }
           else 
           {
           Pousers.add(pinnedlead.opportunity__r.Account.ownerid);
           POdivision.add(pinnedlead.purchase_order__r.division__c);
           }
      }


      list<sales_goal__c> salesgoal = new list<sales_goal__c>(); 
     
      salesgoal = [select Goal_Start_date__c,Goal_End_Date__c,division__c,ownerId from sales_goal__c where Goal_Start_date__c <=: system.today() and Goal_end_date__c >=: system.today() and Ownerid IN: Pousers and division__c IN: POdivision];
      // ('a0PC0000008CGh3','a0PC0000008CGh9','a0PC0000008CGh2')];
      if(runTestMethod )
      {
          salesgoal = [select Goal_Start_date__c,Goal_End_Date__c,division__c,ownerId from sales_goal__c where Goal_Start_date__c <=: system.today() and Goal_end_date__c >=: system.today() and Ownerid IN: Pousers limit 100];
    
      }
      for(sales_goal__c sales : salesgoal)
      {
      finalsalesgroupusers.add(sales.ownerid);
      }
      
      SYSTEM.DEBUG('FINALSALESGROUP USERS WITH VALID SALESGROUP' + finalsalesgroupusers);

   }


   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      buildlistofusers();
      if(finalsalesgroupusers.size()>0)
      {
      return Database.getQueryLocator([select id,name,email from user where Id IN:finalsalesgroupusers and Isactive=true]);
      }
      else
      {
      return null;
      }
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope)
    {
       System.debug('Entering Excecute method' + finalsalesgroupusers );
       string usertosendemailto;
       List<User> usertosendemail = (List<User>) Scope;   
           
       system.debug('User to send email to ' + usertosendemail );
       for(user finalIDS : usertosendemail)
       {
       finalusers.add(finalIDS.id);
       }
        if(runTestMethod )
        {
            // do nothing
        }     
        else
        {
            
            if(finalusers.size()>0)
            { 
                for(id usertosend :finalusers)
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();             
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(et.id);
                    mail.setTargetObjectId(usertosend);
                    mail.setSenderDisplayName('Salesforce.com');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
                }
            }
        }
    }
    
global void finish(Database.BatchableContext BC)
{

   
}
/*@istest(seeAllData = True)
public static void testBatch()
{
User u = [select id,name from user limit 1];
Division__c div = new division__c();
div.Name = 'TESTDIV';
div.state__c = 'CA';
Insert div;
date myDate =  date.newInstance(2008, 12, 1);
   //create a variable for use in our query later (it's declared here because we need it populated prior to creation of test accounts)
      DateTime createdDateValue = DateTime.now(); //DateTime variable
      String createdDate_Formatted_Date = createdDateValue.format('yyyy-MM-dd'); //date portion of the createdDateValue variable formatted as Strting
      String createdDate_Formatted_Time = createdDateValue.format('HH:mm:ss'); //time portion of the createdDateValue variable formatted as Strting
      String createdDate_Formatted_Zone = createdDateValue.format('Z'); //timezone offset of the createdDateValue variable formatted as Strting
      String finalDateTimeValue = createdDate_Formatted_Date+'T'+createdDate_Formatted_Time+createdDate_Formatted_Zone.substring(0, createdDate_Formatted_Zone.length()-2)+':00';
      
 List <Purchase_order__c> POS = new List<purchase_order__c>();
    purchase_order__c PO;
      for(integer i = 0; i<100; i++)
      {
         PO = new purchase_order__c(Division__c =div.id,target_feature_date__c = myDate ,example_deal_1__c ='test'+'i',
                   ownerid = u.Id ); 
         POS.add(PO);
      }
      Insert POS;
Test.startTest();
sendmessage instance = new sendmessage();
sendmessage.runTestMethod  = true;
instance.finalusers.add(PO.ownerid);
instance.Query ='select id,name'+ 'from user'+ 'where id=\''+ u.Id+'\''+' and createddate >= '+finalDateTimeValue+'Limit 200';
Id batchprocesid  = Database.executeBatch(instance,200);
Test.StopTest();
}*/
}