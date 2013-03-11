trigger updateTaxonmyAccount on Account (before insert, before update) {

        list<taxonmyMap__c> taxList = [select id, Object__c, Category_v3__c, Subcategory_v3__c, newCategory__c, newSubcategory__c, newSubcategory1__c, direct__c from TaxonmyMap__c];
        map<string,taxonmyMap__c> taxMapNewV3 = new map<string,taxonmyMap__c>();
        
        for(taxonmyMap__c t : taxList)
            {
                taxMapNewV3.put(t.Subcategory_v3__c,t);
            }       
        
        
        if(trigger.isinsert) 
            {
                for(account a : trigger.new)
                    {
                        if(a.Subcategory_v3__c != null)
                            {
                                system.debug('---------inside the new map: v3 to global and old');
                                taxonmyMap__c t = new TaxonmyMap__c();
                                t = taxMapNewV3.get(a.Subcategory_v3__c);
                                if(t!=null && t.Object__c == 'Lead/Account')
                                    {   
                                        a.Global_SFDC_Category__c = t.newCategory__c;
                                        a.Global_SFDC_Subcategory_1__c = t.newSubcategory__c;
                                    }
                            }       
                    }
            } else {
        
                map<id,account> oldMap = new map<id,account>();
                map<id,account> newMap = new map<id,account>();
                
                for(account acctOld : trigger.old)
                    {                     
                        oldMap.put(acctOld.id, acctOld);              
                    }
                for(account acctNew : trigger.new)
                    {     
                        newMap.put(acctNew.id, acctNew);              
                    }

                for(account a : trigger.new)
                    {
                        account oldA = oldMap.get(a.id);
                        account newA = newMap.get(a.id);
                        system.debug('---------lets debug');
                    
                        // Maps from v3 taxonomy to global taxonomy
                        if(a.Subcategory_v3__c != null && oldA.Subcategory_v3__c  != newA.Subcategory_v3__c)
                            {
                                system.debug('---------inside the new map: v3 to global and old');
                                taxonmyMap__c t = new TaxonmyMap__c();
                                t = taxMapNewV3.get(a.Subcategory_v3__c);
                                if(t!=null && t.Object__c == 'Lead/Account')
                                    {   
                                        a.Global_SFDC_Category__c = t.newCategory__c;
                                        a.Global_SFDC_Subcategory_1__c = t.newSubcategory__c;
                                    }
                            }   
                    }
            }

}