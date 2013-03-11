trigger UpdateNowCoordinator on GrouponNow__c (before update) 
{ 
//create a map of division to now coordinators that we will use to update later - this is only the framework of a table youre telling it what size to make the cells and giving it a reference title
map<id,id> DivIdToNowCoordId = new map<id,id>();

//build a list of divisions, this is done completely separately from the creation of the map
list<division__c> divlist = [select id, now_coordinator__c from division__c];

//populate the map the list of divisions that you just made with the key value being the first one so you "put" in the data
for(division__c d: divlist)
    {
       DivIdToNowCoordId.put(d.id, d.now_coordinator__c);
    }
//iterate over the NOW deals in the trigger to update the now coordinator by referencing the map    
for(grouponnow__c g: trigger.new)
    { 
        id divid = g.division__c;
        g.real_now_coordinator__c = DivIdToNowCoordId.get(divid);
    }
}