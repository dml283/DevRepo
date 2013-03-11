Global Class Division_Subdivision_API{

public map<id,list<subdivision>> sub_map = new map<id,list<subdivision>>();

global list<Division_Subdivision_API.division> getDivisions(){
        list<Division_Subdivision_API.division> Divisions = new list<Division_Subdivision_API.division>();
        list<Zip_Code__c> zips = [select id, name, subdivision__r.name from Zip_Code__c];
        map<string,list<string>> zip_map = new map<string,list<string>>();
        
        for(zip_code__c z: zips){
                if(zip_map.containsKey(z.subdivision__r.name)){
                    list<string> slist = zip_map.get(z.subdivision__r.name);
                    slist.add(z.name);
                    zip_map.put(z.subdivision__r.name,slist);
                }else{
                    list<string> slist = new list<string>();
                    slist.add(z.name);
                    zip_map.put(z.subdivision__r.name,slist);
                }
            }
        
        list<subdivision__c> slist = [select id, name, rank__c, division__c from subdivision__c WHERE division__c !=null ORDER BY Rank__c];
        list<division__c> dlist = [select id, name from division__c];
        
        for(subdivision__c s:slist){
                subdivision a = new subdivision(s);
                a.zip_codes = zip_map.get(s.name);
                updateMap(a);
            }
        for(division__c d: dlist){
                division a = new division(d, sub_map.get(d.id));
                divisions.add(a);
            }  
        return Divisions;        
    }

public void updateMap(subdivision s){
        if(sub_map.containsKey(s.division_id)){
                list<subdivision> slist = sub_map.get(s.division_id);
                slist.add(s);
                sub_map.put(s.division_id,slist);
            }else{
                list<subdivision> slist = new list<subdivision>();
                slist.add(s);
                sub_map.put(s.division_id,slist);
            }
    }

global class division{
        public string name {get;set;}
        public id salesforce_id {get;set;}
        public list<subdivision> subdivisions {get;set;}
        
        public division(division__c d, list<subdivision> slist){
                this.name = d.name;
                this.salesforce_id = d.id;
                this.subdivisions = slist;
            }
    }

global class subdivision{
        public string name{get;set;}
        public id salesforce_id {get;set;}
        public id division_id {get;set;}
        public list<string> zip_codes{get;set;}
        public double rank {get;set;}
        public subdivision(subdivision__c s){
                this.name = s.name;
                this.salesforce_id = s.id;
                this.division_id = s.division__c;
                this.rank=s.rank__c;
                this.zip_codes = new list<string>();
            }
    }    

}