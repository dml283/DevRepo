global class financialbatchclass  implements  Database.Batchable<sObject> 
{
public boolean runTestMethod ;
String Query;
List<Id>                            OpprtunityId                   = new List<Id>();
List<Opportunity>                   Opp                            = new List<Opportunity>();
List<financial_records__c>          finallistoffinancial           = new List<financial_records__c>();
Map<Id,list<financial_records__c> > fiancialmap                    = new Map<Id,list<financial_records__c> >();
decimal decval = 0;
decimal decvalref = 0;
global Database.QueryLocator start(Database.BatchableContext BC)
{
        //String query = 'Select Department, COUNT(Name) From Contact GROUP BY Department';
        Query ='select Opportunity__c,sum_of_refunds__c,units_refunded__c  from financial_records__c where opportunity__c != null and createddate = today' ;
       
       if(runTestMethod  == true)
       {
               Query ='select Opportunity__c,sum_of_refunds__c,units_refunded__c from financial_records__c where opportunity__c != null limit 100' ;

       } //where createddate = Today()';
        return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC, List<sObject> scope)
{
    List<financial_records__c> financialrecords = (List<financial_records__c>) Scope;

    for(financial_records__c fin : financialrecords)
    {
    OpprtunityId.add(fin.Opportunity__c);
    }
    
    //Get all Opportunity related to the financial records that were created today.
    opp = [select Id,Refund_dollars__c,refund_units__c from Opportunity where Id IN: OpprtunityId];
    //Get all financial records related to this all the Opportunities.
    finallistoffinancial  = [select id,opportunity__r.Id,Sum_of_Refunds__c,units_refunded__c from financial_records__c where Opportunity__c IN: Opp];
    
    //create a map to get the financials related to every individual opportunity or a mutli deal.
    for(financial_records__c  mapval : finallistoffinancial )
    {
        if(fiancialmap.containsKey(mapval.opportunity__r.id)){
            list<financial_records__c> frlist = fiancialmap.get(mapval.opportunity__r.id);
            frlist.add(mapval);
            fiancialmap.put(mapval.opportunity__r.id,frlist);
        }else{
            list<financial_records__c> frlist = new list<financial_records__c>();
            frlist.add(mapval);
            fiancialmap.put(mapval.opportunity__r.id,frlist);
        }
    }    
    
    for(opportunity O: Opp)
    {
        if(fiancialmap.containskey(O.Id))
        {
            for(financial_records__c fin: fiancialmap.get(O.Id))
            {
            if(decval  !=null && fin.Sum_of_Refunds__c != null)
            {
             decval += fin.Sum_of_Refunds__c;
            }
            if(decvalref  !=null && fin.units_refunded__c!=null)
            {
             decvalref += fin.units_refunded__c;
             }
            }
             O.Refund_dollars__c = decval;
             o.refund_units__c   = decvalref ;
             decval =0; 
             decvalref =0;    
        }
    }
    

    try
    {
    batchapexstop.stopbatchapex = true;
    update Opp ;
    batchapexstop.stopbatchapex = false;
    }
    
    catch(Exception ex)
    {
    }

}

global void finish(Database.BatchableContext BC)
{

}
@Istest(SeeallData = true)
public static void testscenarioone()
{
    financialbatchclass  batch = new financialbatchclass  ();
    batch.runTestMethod  = true;
    Test.startTest();
    ID batchprocessid = Database.executeBatch(batch,200);
    Test.stopTest();
    system.assertnotequals(batch.Opp,null);
    system.assertnotequals(batch.finallistoffinancial,null);
    for(Opportunity O : batch.Opp)
    {
    system.assertnotequals(O.Refund_dollars__c,null);
    system.assertnotequals(O.refund_units__c,null);
    }
}
}