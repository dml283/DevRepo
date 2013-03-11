trigger CaseRollup on Case (after insert, after update) {
  /*
  Set<ID> oppIds = new Set<ID>();
    
    
    for(Case c:[SELECT Id, Opportunity__c, Permalink__c, Bucket__c, Sheepdad_Reason_Code__c
                FROM Case
                WHERE Permalink__c <> '' AND Opportunity__c <> '006C000000bmGgs' AND Opportunity__c <> '' AND (Bucket__c = 'merchant' OR Bucket__c = 'sales') AND Sheepdad_Reason_Code__c = 1 AND Id IN:trigger.new])
        { oppIds.add(c.Opportunity__c);}
  
  Map<string,string> CountMap = new map<string,string>();
     
  AggregateResult[] groupedResults = [select count(Id) idcount, Opportunity__c from Case where Opportunity__c in :oppIds group by Opportunity__c];

  for (AggregateResult ar : groupedResults) {
    CountMap.put(string.valueof(ar.get('Opportunity__c')),string.valueof(ar.get('idcount')));
  }
  
  set<id>FiveCaseSet= new set<id>();
  set<id>FifteenCaseSet= new set<id>();
    
  for(Opportunity o: [SELECT Id, CS_Email_Alert__c, Division__c
                      FROM Opportunity
                      WHERE Id
                      IN: oppIds])
     {
       decimal caseCount=decimal.valueof(CountMap.get(o.id));
       if (caseCount >= 5 && caseCount < 15 && o.CS_Email_Alert__c <> '5 Case Email Sent' && (o.Division__c == 'Atlanta' || o.Division__c == 'Boston' || o.Division__c == 'Chicago' || o.Division__c == 'LA' || o.Division__c == 'New York' || o.Division__c == 'Toronto' || o.Division__c == 'DC' || o.Division__c == 'San Francisco' || o.Division__c == 'Seattle' || o.Division__c == 'Dallas')) 
         { FiveCaseSet.add(o.id);}
       if (caseCount >= 15 && o.CS_Email_Alert__c <> '15 Case Email Sent' && (o.Division__c == 'Atlanta' || o.Division__c == 'Boston' || o.Division__c == 'Chicago' || o.Division__c == 'LA' || o.Division__c == 'New York' || o.Division__c == 'Toronto' || o.Division__c == 'DC' || o.Division__c == 'San Francisco' || o.Division__c == 'Seattle' || o.Division__c == 'Dallas')) 
         { FifteenCaseSet.add(o.id);}
     }
  CaseCountRollup.UpdateCaseCount(FiveCaseSet, FifteenCaseSet);
  */
}