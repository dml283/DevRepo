global class converter{

@RemoteAction
public static decimal convertMyLead(){
    converter conv = new converter();
    conv.run_converter();
    decimal d = 5;
    return d;
}

public decimal lead_count(){
    decimal d; 
    set<id> queues = new set<id>();
    list<QueueSobject> queue_sobj = [select QueueId from QueueSobject];
    
    for(QueueSobject q : queue_sobj){
        queues.add(q.QueueId);
    }
    list<lead> lead_list = database.query(get_count_query(queues));
    d = lead_list.size();
    return d;
}
public void run_converter(){
    id i;
    lead myLead;
    Database.LeadConvert lc;
    Database.LeadConvertResult lcr;
    
    set<id> queues = new set<id>();
    list<QueueSobject> queue_sobj = [select QueueId from QueueSobject];
    
    for(QueueSobject q : queue_sobj){
        queues.add(q.QueueId);
    }
    try{
        myLead = database.query(get_query(queues));
    }catch(exception e){system.debug(e);}
    try{
           lc = new database.LeadConvert();
           lc.setLeadId(myLead.id);
           lc.setDoNotCreateOpportunity(true);
           lc.setConvertedStatus('Prospecting');
        }catch(exception e){system.debug(e);}    
    
    try{
         lcr = Database.convertLead(lc);
         system.debug('==============='+lcr.getAccountId());
         //System.assert(lcr.isSuccess());
        }catch(exception e){system.debug(e);}  

}



//this method returns the query for one lead to select for the converter method
public string get_query(set<id> queues){
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
    query+=' AND Dynamic_Division__r.Conversion_Order__c != null ';
    query+=' LIMIT 1 ';
    query+=' FOR UPDATE';
    
    return query;
   
}
public string get_count_query(set<id> queues){
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
    query+=' LIMIT 400 ';
    return query;
}


}