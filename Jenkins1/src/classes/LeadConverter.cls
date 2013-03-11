global class LeadConverter implements Database.Batchable<SObject>, Database.Stateful{
    
    list<QueueSobject> queue_sobj {get;set;}
    set<id> queues {get;set;}
    string division {get;set;}
    global LeadConverter(){
        queue_sobj = [select QueueId from QueueSobject];
        queues = new set<id>();
        for(QueueSobject q : queue_sobj){
            queues.add(q.QueueId);
        }
    }
    global LeadConverter(string div){
        queue_sobj = [select QueueId from QueueSobject];
        queues = new set<id>();
        for(QueueSobject q : queue_sobj){
            queues.add(q.QueueId);
        }
        division = div;
    }
    
    
    global Database.queryLocator start(Database.BatchableContext ctx){
            string query;
                query =' SELECT id ';
                query+=' FROM LEAD ';
                query+=' WHERE isconverted = false  ';
                query+=' AND ownerid != \'00G80000001ePM4\'';
                query+=' AND (Research_Ranking__c = \'4\' OR Research_Ranking__c = \'6\' OR Research_Ranking__c = \'8\' OR Research_Ranking__c = \'10\') ';
                query+=' AND ownerid != :queues ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - Bankruptcy\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - Prior Poor Performance\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - CS Issues\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - High Refunds\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - Low Customer Satisfaction\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - Merchant Risk / Fraud\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Do Not Run - Low Quality / Merchant Pulls\' ';
                query+=' AND Merchant_Status_Reasons__c != \'Restricted Category\' ';
                if(division!=null){
                    query+=' AND Division__c = \''+division+'\' ';
                }
                
                
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope){
        List<Lead> leads = (List<Lead>)scope;
        
        for(Integer i = 0; i < leads.size(); i++){
               Database.LeadConvert lc;
               Database.LeadConvertResult lcr;
                   lc = new database.LeadConvert();
                   lc.setLeadId(leads[i].id);
                   lc.setDoNotCreateOpportunity(true);
                   lc.setConvertedStatus('Prospecting');
                   lcr = Database.convertLead(lc);
        }
     }
    
    global void finish(Database.BatchableContext ctx){
    
        AsyncApexJob a = [SELECT id, ApexClassId, 
                       JobItemsProcessed, TotalJobItems, 
                       NumberOfErrors, CreatedBy.Email 
                       FROM AsyncApexJob 
                       WHERE id = :ctx.getJobId()];
        /*
        String emailMessage = 'Your batch job '
             + 'AccountOwnerReassignment '
             + 'has finished.  It executed ' 
             + a.totalJobItems 
             + ' batches.  Of which, ' + a.jobitemsprocessed 
             + ' processed without any exceptions thrown and ' 
             + a.numberOfErrors +
             ' batches threw unhandled exceptions.'
             + '  Of the batches that executed without error '; 

        
        Messaging.SingleEmailMessage mail = 
              new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.createdBy.email};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('Batch Job Summary');
        mail.setSubject('Batch job completed');
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] 
                           { mail });
        */
    }

    public static testmethod void testBatchLeadConversion(){
       lead L = new lead();
           l.lastName = 'My Last Name';
           l.company ='Groupon.com Test'+system.now();
           l.division__c = 'Chicago';
           l.Status = 'Uncontacted';
           l.Research_Ranking__c='8';
      insert l;
           
           Test.startTest();
                Database.executeBatch(new LeadConverter());
           Test.stopTest();
            lead converted_lead = [select id, company, ConvertedAccountId FROM lead where id = :l.id];
            account a = [select id, name from Account where id = :converted_lead.ConvertedAccountId];
            
           system.assertEquals(a.id,converted_lead.convertedAccountId);
           system.assertEquals(a.name, converted_lead.company);
           

    }
}