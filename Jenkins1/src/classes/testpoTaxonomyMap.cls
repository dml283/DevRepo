@IsTest
private class testpoTaxonomyMap{
          static testMethod void testPoTaxonomyMap(){
              grouponTestUtil gTestUtil = new grouponTestUtil();
              User u = gTestUtil.createTestUser('System Administrator');
              u.UserName = 'poTaxonomyMapTrigger@test.com';
              insert u;
              System.RunAs(u){
                      
                      taxonmyMap__c tm = gTestUtil.createTaxonomyMap();
                      tm.Object__c = 'Lead/Account';
                      tm.Category_v3__c = 'Test Category';
                      tm.Subcategory_v3__c = 'Test Subcategory';
                      tm.newCategory__c = 'Test newCategory';
                      tm.newSubcategory__c = 'Test newSubcategory';
                      tm.newSubcategory1__c = 'Test newSubcateogry1';
                      insert tm;
                      
                      taxonmyMap__c tm2 = gTestUtil.createTaxonomyMap();
                      tm2.Object__c = 'Lead/Account';
                      tm2.Category_v3__c = 'Test Category Change';
                      tm2.Subcategory_v3__c = 'Test Subcategory Change';
                      tm2.newCategory__c = 'Test newCategory Change';
                      tm2.newSubcategory__c = 'Test newSubcategory Change';
                      tm2.newSubcategory1__c = 'Test newSubcateogry1 Change';
                      insert tm2;
                      
                      Purchase_Order__c po = gTestUtil.createPO();
                      po.Category_v3__c = 'Test Category';
                      po.Subcategory_v3__c = 'Test Subcategory';
                      insert po;
                      
                      po.Subcategory_v3__c = 'Test Subcategory Change';
                      update po;
                      
                      purchase_Order__c poAssert = [select id, Global_SFDC_Category__c FROM Purchase_Order__c WHERE id =: po.id];
                      
                      //system.assertequals('Test newCategory',poAssert.Global_SFDC_Category__c);
                      
                  }
          }    

    }