global class QuantumLeadSync implements Database.Batchable<SObject>, Database.Stateful{

  global QuantumLeadSync() {}

  global Database.queryLocator start (Database.BatchableContext ctx) {
    string query;
    query = 'SELECT id, Name, Sales_Value__c, Sales_Value_Demand__c, Sales_Value_Reasons__c, (SELECT Id, Call_List_Priority__c, Sales_Value__c, Sales_Value_Demand__c, Sales_Value_Reasons__c from Quantum_Leads__r) FROM Account ';
    return Database.getQueryLocator (query);
  }

  global void execute (Database.BatchableContext ctx, List<Account> scope) {
    List<Account> accountsToUpdate = new List<Account>();
    for(Account a : scope){
        boolean updateAccount = false;
        if(a.Quantum_Leads__r.size()>0){
            if(a.Sales_Value__c != a.Quantum_Leads__r[0].Sales_Value__c){
                updateAccount = true;
                a.Sales_Value__c = a.Quantum_Leads__r[0].Sales_Value__c;
                a.Sales_Value_Reasons__c = a.Quantum_Leads__r[0].Sales_Value_Reasons__c;
            }
            if(a.Sales_Value_Demand__c != a.Quantum_Leads__r[0].Sales_Value_Demand__c){
                updateAccount = true;
                a.Sales_Value_Demand__c = a.Quantum_Leads__r[0].Sales_Value_Demand__c;
                a.Sales_Value_Reasons__c = a.Quantum_Leads__r[0].Sales_Value_Reasons__c;
            }
        }
     if(updateAccount){
         accountsToUpdate.add(a);
     }   
    }
    if(accountsToUpdate.size()>0){
        Database.update(accountsToUpdate);
    }
  }

  global void finish (Database.BatchableContext ctx) {

    AsyncApexJob a = [SELECT id, ApexClassId, createdDate,
                      JobItemsProcessed, TotalJobItems,
                      NumberOfErrors, CreatedBy.Email
                      FROM AsyncApexJob
                      WHERE id = : ctx.getJobId()];
    
    String emailMessage = 'Your batch job QuantumLeadAccountSync TESTING BATCH AT 10,000 has finished.  It executed ' + a.totalJobItems + ' batches.  Of which, ' + a.jobitemsprocessed + ' processed without any exceptions thrown and '+ a.numberOfErrors + ' batches threw unhandled exceptions.';
    emailMessage+='Your batch started at '+a.createdDate.format()+ 'and finished at '+system.now().format();

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {'cbland@groupon.com', 'shafiq@groupon.com'};
    mail.setToAddresses (toAddresses);
    mail.setReplyTo ('noreply@salesforce.com');
    mail.setSenderDisplayName ('Quantum Lead - Salesforce');
    mail.setSubject ('Quantum Lead Object => Account Sync has completed');
    mail.setPlainTextBody (emailMessage);
    mail.setHtmlBody (emailMessage);
    if(!Test.isRunningTest()) {
        Messaging.sendEmail (new Messaging.SingleEmailMessage[]
                         { mail });
    }
  }

  public static testmethod void testBatchLeadConversion() {
    Account acct = new Account();
    acct.name = 'Test Account' + system.now();
    insert acct;
    
    Quantum_Lead__c ql = new Quantum_Lead__c();
        ql.Call_List_Priority__c = '565';
        ql.Sales_Value__c =500;
        ql.Sales_Value_Demand__c = 30935353;
        ql.Sales_Value_Reasons__c = 'reasons';
        ql.Parent_Id__c = acct.id;
        ql.account__c = acct.id;
    insert ql;

    Test.startTest();
    Database.executeBatch (new QuantumLeadSync());
    //Test.stopTest();

  }
}