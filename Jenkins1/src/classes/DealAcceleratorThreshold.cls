public class DealAcceleratorThreshold{
    public map<string, map<string,Deal_Accelerator_Threshold__c>> thresholdMap {get;set;}
    public list<string> strings {get;set;}
    public DealAcceleratorThreshold(){
        this.thresholdMap = new map<string, map<string,Deal_Accelerator_Threshold__c>>();
        this.strings = new list<string>();
    }
    public void addThresholds(SalesGoal goal){
        if(goal.divisions!=null){
            list<Deal_Accelerator_Threshold__c> thresholds = [select id, Category__c, Division__r.name, DreamList_Threshold__c, Food_and_Drink_Threshold__c, HVA_Threshold__c, LS_Threshold__c FROM Deal_Accelerator_Threshold__c WHERE Division__r.name = :goal.divisions];
            for(Deal_Accelerator_Threshold__c dat : thresholds){
                strings.add(dat.category__c);
                map<string,Deal_Accelerator_Threshold__c> catMap;
                if(thresholdMap.containsKey(dat.Division__r.name)){
                    catMap  = thresholdMap.get(dat.Division__r.name);
                }else{
                    catMap = new map<string,Deal_Accelerator_Threshold__c>();
                }
                catMap.put(dat.category__c, dat);
                thresholdMap.put(dat.division__r.name, catMap);
            }
        }
    }
}