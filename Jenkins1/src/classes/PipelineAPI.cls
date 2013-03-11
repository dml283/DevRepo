public class PipelineAPI{

public list<string> getAllDivisions(){
                list <string> divList = new list<string>();
                list <division__c> allDivs = [select name from Division__c order by name asc];
                for(division__c d: allDivs){
                               string a = d.name;
                               a = a.replaceAll('/','');
                               divList.add(a);
                        }
               return divList;     
         }
public list<string> getSubdivisions(String division){
       list<subdivision__c> subdivisions = new list<subdivision__c>();
       list <string> SubdivList = new list<string>();
       if(division!=null){subdivisions = [select name from Subdivision__c WHERE Division__r.Name = :division ORDER BY Rank__c];
       for(subdivision__c s: subdivisions){
           subdivlist.add(s.name);
       }
    }
    return SubdivList;
}
public list<string> getAllPipelineUsers(){
    list<string> users = new list<string>();
    list<user> uList = [select name from User ORDER BY Name];
    for(user u: uList){
        users.add(u.name);}
    return users;     
}
public list<Division__c> getDivisionTaxonomyMap(){
      
        list<Division__c> taxonomyList =[Select Name,(select Name FROM  Subdivisions1__r)From Division__c ];
        return taxonomyList;
    }
private testMethod static void testPipelineAPI(){
    PipelineAPI API = new PipelineAPI();
    division__c div = new Division__c(name='Division',State__c='IL');
    insert div;
    subdivision__c sd = new Subdivision__c(name='subdivision', division__c = div.id);
    insert sd;
    list<string> division_test = API.getAllDivisions();
    list<string> subdivision_test = API.getSubdivisions(div.name);
    list<string> users_test = API.getALlPipelineUsers();
    list<division__c> Taxonomy = API.getDivisionTaxonomyMap();
    //system.assertEquals(division_test.size(),1);
    
}          
}