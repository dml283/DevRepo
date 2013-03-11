trigger DynamicZipcodeNowRedAddress on Now_Redemption_Address__c (before update, before insert) {

//Build a map that will relate Redemption Address IDs to the text in the zip code
map<id,string> AddyZipMap = new map<id, string>();

set<string> ZipsinUpdate = new set<string>();

    for(Now_Redemption_Address__c RA: trigger.new)
        {
            if(ra.zip_code__c != null)
                {
                    if(ra.country__c == 'USA' && ra.zip_code__c.length() >= 5)
                        {
                            string USZip = ra.Zip_Code__c;
                            system.debug('----you will get here');
                            string USShortZip = USZip.substring(0,5);
                            
                            system.debug(usshortzip);
                            ZipsinUpdate.add(USshortzip);
                            AddyZipMap.put(RA.id,USshortzip);
                            system.debug('-------------champ------------');
                        }
                   
                    if(ra.country__c == 'Canada' && ra.zip_code__c.length() >= 3)
                        {
                            string CAZip = ra.Zip_Code__c;
                            string CATrimZip = CAZip.trim();
                            string CAShortZip = CATrimZip.substring(0,3);
                            
                            system.debug(CAshortzip);
                            ZipsinUpdate.add(CAshortzip);
                            AddyZipMap.put(RA.id,CAshortzip);
                            system.debug('-------------champ------------');
                        }
                }
        }
//Create a list of all of the zip codes that we will use to populate zipmap
list<zip_code__c> Ziplist = [select name, id From Zip_code__c where name IN:ZipsinUpdate];

//Build A Map that we can use to relate the auto assigned zip to the ID of the zip code
map<string, id> ZipMap = new map <string, id>();
    
    for(zip_code__c z: Ziplist)
        {
            zipmap.put(z.name,z.id);
        }
        
    for(Now_Redemption_Address__c RA: trigger.new)
        {
        //for each lead in this list we want to assign the now_zip_code__c to the id that has a name that matches the auto assigned zip code  
        string ZipCode = AddyZipMap.get(ra.id);
        if(ZipCode !=null)
            {
                ra.dynamic_zip_code__c = ZipMap.get(ZipCode);
            }
        
        }
   

}