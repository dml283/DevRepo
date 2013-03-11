trigger DynamicZipcodeMerchAddress on Merchant_Addresses__c (before update, before insert) {
/*
//Build a map that will relate Merchant Address IDs to the text in the zip code
map<id,string> AddyZipMap = new map<id, string>();

set<string> ZipsinUpdate = new set<string>();

//Build the list of Addresses that we want to update with a Now! Zip Code
//list<Merchant_Addresses__c> AddysForUpdate = [Select id, Zip_Postal_Code__c, Country__c from Merchant_Addresses__c where id IN:trigger.new];

system.debug('-------------vonnnn------------');
    
    for(Merchant_Addresses__c MA: trigger.new){
        if(ma.zip_Postal_code__c != null)
            {
                if(ma.country__c == 'US' && ma.zip_postal_code__c.length() >= 5)
                    {
                        string USZip = ma.Zip_Postal_Code__c;
                        system.debug('----you will get here');
                        string USShortZip = USZip.substring(0,5);
                        
                        system.debug(usshortzip);
                        ZipsinUpdate.add(USshortzip);
                        AddyZipMap.put(MA.id,USshortzip);
                        system.debug('-------------champ------------');
                    }
               
                if(ma.country__c == 'CA' && ma.zip_postal_code__c.length() >= 3)
                    {
                        string CAZip = ma.Zip_Postal_Code__c;
                        string CATrimZip = CAZip.trim();
                        string CAShortZip = CATrimZip.substring(0,3);
                        
                        system.debug(CAshortzip);
                        ZipsinUpdate.add(CAshortzip);
                        AddyZipMap.put(MA.id,CAshortzip);
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
        
    for(Merchant_Addresses__c MA: trigger.new)
        {
        //for each lead in this list we want to assign the now_zip_code__c to the id that has a name that matches the auto assigned zip code  
        string ZipCode = AddyZipMap.get(ma.id);
        if(ZipCode !=null)
            {
                ma.zip_code__c = ZipMap.get(ZipCode.touppercase());
            }
        
        }

*/
}