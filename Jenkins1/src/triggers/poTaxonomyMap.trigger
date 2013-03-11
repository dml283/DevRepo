trigger poTaxonomyMap on Purchase_Order__c (before insert, before update) {
    //LIST OF TAXONOMY MAPPING RECORDS WHERE OBJECT IS EQUAL TO 'LEAD/ACCOUNT'
    list<taxonmyMap__c> taxonomyMapList = [SELECT id, Object__c, Category_v3__c, Subcategory_v3__c, newCategory__c, newSubcategory__c, newSubcategory1__c, direct__c
                                           FROM TaxonmyMap__c WHERE Object__c = 'Lead/Account'];   
    
    //CREATE MAP TO SET SUBCAT AS KEY AND THE RECORD IT RELATES TO AS PAIR
    map<string,taxonmyMap__c> v3TaxonomyMap = new map<string,taxonmyMap__c>();
    
    //POPULATE V3 TAXONOMY MAP
    for(taxonmyMap__c t : taxonomyMapList){
            v3TaxonomyMap.put(t.Subcategory_v3__c,t);
        }
    
    if(trigger.isInsert){
            for(purchase_order__c poIns : trigger.new){
                if(poIns.subcategory_v3__c != null){
                    taxonmyMap__c taxMapRec = new taxonmyMap__c();
                    taxMapRec =  v3TaxonomyMap.get(poIns.Subcategory_v3__c);
                 if(taxMapRec != null)
                 {
                    poIns.Global_SFDC_Category__c = taxMapRec.newCategory__c;
                    poIns.Global_SFDC_Subcategory_1__c = taxMapRec.newSubcategory__c;
                    poIns.Global_SFDC_Subcategory_2__c = taxMapRec.newSubcategory1__c;
                  }
                }
            }
        }
    
    if(trigger.isUpdate){
    //CREATE MAP FOR PURCHASE ORDER AND THE PREVIOUS VALUES AFTER DML    
    map<id, purchase_order__c> newPOmap = new map<id,purchase_order__c>();
    
    //CREATE MAP FOR PURCHASE ORDER AND THE PREVIOUS VALUES BEFORE DML
    map<id, purchase_order__c> oldPOmap = new map<id,purchase_order__c>();
    
    //POPULATE NEW PO MAP BASED ON TRIGGER NEW
    for(purchase_order__c newPO : trigger.new){
            newPOmap.put(newPO.id, newpo);
        }
                    
    //POPULATE OLD PO MAP BASED ON TRIGGER OLD
    for(purchase_order__c oldPO : trigger.old){
            oldPOmap.put(oldPO.id, oldpo);
        }

        //ITERATE OVER PURCHASER ORDER IN TRIGGER NEW
        for(purchase_order__c po : trigger.new){
                //PURCHASE ORDER WITH OLD VALUES TO REFERENCE
                purchase_Order__c oldPurchOrd = oldPOmap.get(po.id);
               
                //PURCHASE ORDER WITH NEW VALUES TO REFERENCE
                purchase_Order__c newPurchOrd = newPOmap.get(po.id);
                
                if(newPurchOrd.subcategory_v3__c != oldPurchOrd.subcategory_v3__c){
               
                        //INITIATE TAXONOMY RECORD TO REFERENCE VALUES TO POPULATE GLOBAL TAXONOMY ON PURCHASE ORDER
                        taxonmyMap__c taxMapRec = new taxonmyMap__c();
               
                        //POPULATE TAXONOMY RECORD BY REFERENCING MAP
                        taxMapRec =  v3TaxonomyMap.get(newPurchOrd.Subcategory_v3__c);
                        if(taxMapRec!= null)
                        {
                        //SET VALUES ON PURCHASE ORDER TO VALUES IN MAPPING RECORD
                        newPurchOrd.Global_SFDC_Category__c = taxMapRec.newCategory__c;
                        newPurchOrd.Global_SFDC_Subcategory_1__c = taxMapRec.newSubcategory__c;
                        newPurchOrd.Global_SFDC_Subcategory_2__c = taxMapRec.newSubcategory1__c;
                        }
                    }
                }
        }    
}