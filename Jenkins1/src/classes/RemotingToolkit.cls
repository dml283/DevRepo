global with sharing class RemotingToolkit {

public set<string> getCategoryList(){
set<string> catlist = new set<string>();
date now = system.today();
date sixtydays = now.adddays(-30);
list<opportunity> cat = [select category__c from Opportunity WHERE Feature_date__c <= :now OR Feature_date__c >= :sixtydays limit 10000];

for(opportunity c:cat)
    {
        catlist.add(c.category__c);
    }
    return catlist;
}    

public list<string> getDivisionList(){
list<division__c> alldivs = [select name from Division__c where isactive__c = true order by name];
list<string> divnames = new list <string>();
for(division__c d:alldivs)
    {
        divnames.add(d.name);
    }

return divnames;
}
// Perform a with-sharing, JS Remoting query
@RemoteAction
global static SObject[] query(String soql) {

List <sobject>SObjects = new List<sobject>();
try {
SObjects = Database.query(soql);
} catch (Exception e) {
return null;
}
return SObjects;
}

}