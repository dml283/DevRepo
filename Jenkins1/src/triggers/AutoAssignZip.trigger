trigger AutoAssignZip on Purchase_Order__c (before insert) {

map<string,id> POZipMap = new map<string,id>();
map<string,id> ZipMap = new map<string,id>();
set<string> ZipsInTrigger = new set<string>();
list<Purchase_Order__c> POtoUpdate = new list<Purchase_Order__c>();

for(Purchase_Order__c p:trigger.new)
    {
        if(p.Source__c=='SmartLeads')
            {
                POtoUpdate.add(p);
            }
    }

for(Purchase_Order__c p:POtoUpdate)
    {
        //POZipMap.put(p.Ideal_Zip_Code__c,p.id);
        ZipsInTrigger.add(p.Ideal_Zip_Code__c);
        ZipsInTrigger.add('60656');
    }

    list<Zip_Code__c> SubDivId = [select Name, Subdivision__c from Zip_Code__c WHERE Name in :ZipsInTrigger];
    for(Zip_Code__c z :SubDivId)
        {
            ZipMap.put(z.name,z.Subdivision__c);
        }

for(Purchase_Order__c po:POtoUpdate)
    {
        po.Subdivision__c = ZipMap.get(po.Ideal_Zip_Code__c);
    }


}