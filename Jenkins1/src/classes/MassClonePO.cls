public class MassClonePO {
    
    //class constructor that calls getDivisionOptions method to populate DivSelect element
    public MassClonePO(){
        getDivisionOptions();
    }
    
    //method to return a list of all divisions to populate DivSelect element
    public list<division__c> getDivisionOptions(){
            list<division__c> divs = [SELECT Name FROM Division__c ORDER BY Name];
            return divs;
        }
    /*
    //remote action that populates SubDivSelect element based on division that is selected    
    @RemoteAction
    public static list<subdivision__c> getSubDivisionOptions(string divName){
            list<subdivision__c> subdivs = [SELECT Name FROM Subdivision__c WHERE Division__r.Name =: divName ORDER BY Name];
            return subdivs;  
        }
    */    
    //remote action to populate poTable element based on purchase orders that match the division and subdivision selected and are marked as Evergreen in the Source field  
    @RemoteAction
    public static list<purchase_order__c> getPurchaseOrderByDivisions(string div){
            list<purchase_order__c> pos = [SELECT id, name, Subdivision__r.Name, category_v3__c, subcategory_v3__c, PO_Notes__c, Ideal_Price_Range__c FROM Purchase_Order__c WHERE Division__r.Name =: div AND Source__c = 'Evergreen'];
            return pos;
        }
        
    //remote action to clone purchase order that is selected
    @RemoteAction
    public static void clonePO(string purchOrdId, string TargetFeatureDate){
         
        string currentPOId = purchOrdId;
        list<pinnedmerchant__c> clonedpinnedmerch = new List<pinnedmerchant__c>();
        list<AssignedTo__c> clonedAssignedTo  = new List<AssignedTo__c>();

        Purchase_Order__c currentPO = [SELECT Id, OwnerId, Assigned_To__c, PO_Submitted_Date__c, Example_Deal_1__c, Example_Deal_2__c, Deal_Builder_Template__c, Merchant_Value_Prop__c, Assigned_To_multi__c,
                            Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Category_v3__c, Subcategory_v3__c, division__c, Subdivision__c, Location__c,
                            Ideal_Price_Range__c, Target_Feature_Date__c, Target_Revenue__c, Target_GP__c, PO_Notes__c, Rep_PO_Notes__c, services__c
                     FROM   purchase_order__c 
                     WHERE  Id =: currentPOId];    
          
        //Also Grab all related objects (Pinned Merchants & AssignedTo)                      
        List<pinnedmerchant__c> pinnedmerchants = [SELECT Id,Lead__c,Lead__r.Isconverted,Lead__r.ConvertedAccountId,Account__c,Opportunity__c FROM pinnedmerchant__c WHERE purchase_order__c =: currentPOId ];                                                       
            
        List<AssignedTo__c> Assignedvals = [select Id,Assigned_To__c,PO_Category__c,PO_Created_By__c,PO_Division__c,PO_Ideal_Price__c,PO_Location__c,PO_Subcategory_1__c,PO_Subcategory_2__c,PO_Subdivision__c,PO_Target_Feature_Date__c,PO_unique_id__c,Purchase_Order__c,Name from AssignedTo__c where purchase_order__c =: currentPOId];
            
        Purchase_Order__c clonePO = currentPO.clone(false);
        //clonePO.OwnerId = currentPO.OwnerId;
        clonePO.OwnerId = UserInfo.getUserId();
        clonePO.Purchase_Order__c = currentPOId;
        clonePO.Assigned_To__c = currentPO.Assigned_To__c;
        clonePO.PO_Submitted_Date__c = currentPO.PO_Submitted_Date__c;
        clonePO.Example_Deal_1__c = currentPO.Example_Deal_1__c;
        clonePO.Example_Deal_2__c = currentPO.Example_Deal_2__c;
        clonePO.Deal_Builder_Template__c = currentPO.Deal_Builder_Template__c;   
        clonePO.Merchant_Value_Prop__c = currentPO.Merchant_Value_Prop__c;
        clonePO.Assigned_To_multi__c = currentPO.Assigned_To_multi__c;
        clonePO.Global_SFDC_Category__c = currentPO.Global_SFDC_Category__c;
        clonePO.Global_SFDC_Subcategory_1__c = currentPO.Global_SFDC_Subcategory_1__c;
        clonePO.Global_SFDC_Subcategory_2__c = currentPO.Global_SFDC_Subcategory_2__c;
        clonePO.division__c = currentPO.division__c;
        clonePO.Subdivision__c = currentPO.Subdivision__c;
        clonePO.Location__c = currentPO.Location__c;
        clonePO.Ideal_Price_Range__c = currentPO.Ideal_Price_Range__c;
        /*
        if(currentPO.Target_Feature_Date__c != null){
                clonePO.Target_Feature_Date__c = currentPO.Target_Feature_Date__c.addMonths(1).addDays(Date.daysInMonth(currentPO.Target_Feature_Date__c.addMonths(1).year(), currentPO.Target_Feature_Date__c.addMonths(1).month()) - 1);   
            }else{
                clonePO.Target_Feature_Date__c = system.today().addMonths(1).addDays(Date.daysInMonth(system.today().addMonths(1).year(), system.Today().addMonths(1).month())-1);   
            }
        */    
        //clonePO.Target_Feature_Date__c = currentPO.Target_Feature_Date__c;
        if(TargetFeatureDate != ''){
            clonePO.Target_Feature_Date__c = date.parse(TargetFeatureDate);
        }else{
            clonePO.Target_Feature_Date__c = system.today().addMonths(1).addDays(Date.daysInMonth(system.today().addMonths(1).year(), system.Today().addMonths(1).month())-1);    
        }
        clonePO.Target_Revenue__c = currentPO.Target_Revenue__c;
        clonePO.Target_GP__c = currentPO.Target_GP__c;
        clonePO.PO_Notes__c = currentPO.PO_Notes__c;
        clonePO.Rep_PO_Notes__c = currentPO.Rep_PO_Notes__c;
        clonePO.Subcategory_v3__c = currentPO.Subcategory_v3__c;
        clonePO.category_v3__c = currentPO.category_v3__c;
        clonePO.services__c = currentPO.services__c;
            
        insert clonePO;                             
            
        for(AssignedTo__c assign : Assignedvals ){
                if(assign != null){
                    AssignedTo__c  clonedAssign = new AssignedTo__c ();
                    clonedAssign = assign.clone(false);
                    clonedAssign.Purchase_order__c = clonePO.Id;
                    clonedAssign.Assigned_To__c = assign.Assigned_To__c;
                    clonedAssignedTo.add(clonedAssign);
                }      
            }
        Insert clonedAssignedTo;
                      
        for (pinnedmerchant__c a: pinnedmerchants){
                if(a != null){
                    pinnedmerchant__c clonepinned = new pinnedmerchant__c();
                    clonepinned =  a.clone(false); 
                    clonepinned.purchase_order__c = clonePO.Id;
                    clonepinned.Account__c = a.Account__c;
                    clonepinned.Opportunity__c = a.Opportunity__c;
                    if(a.Lead__r.Isconverted == False){
                        clonepinned.Lead__c = a.Lead__c; 
                        clonepinned.Account__c = a.account__c;  
                        }else{
                            clonepinned.Lead__c = null; 
                            clonepinned.Account__c = a.Lead__r.convertedaccountId;
                        }             
                    clonedpinnedmerch.add(clonepinned);
                }
            }
            insert clonedpinnedmerch;
            }
        
    //tests
    @isTest
    static void poCloneMaticTest(){
              Profile p = [select id from profile where name='System Administrator'];
                        User u1 = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='poCloneTest@groupon.com');
                        insert u1;
                //run as user
                System.RunAs(u1){
                
                lead l1 = new lead();
                l1.LastName = system.now() + 'CloneMatic';
                l1.company = system.now() + 'CloneMatic';
                insert l1;
                
                Division__c d = new Division__c();
                d.name = 'TestDiv';
                d.state__c = 'IL';
                insert d;
                
                Subdivision__c sd = new SubDivision__c();
                sd.name = 'TestSubDiv';
                sd.Division__c = d.id;
                insert sd;
                
                purchase_order__c po1 = new purchase_order__c();
                po1.division__c = d.id;
                po1.subdivision__c = sd.id;
                insert po1;
                
                purchase_order__c po2 = new purchase_order__c();
                po2.division__c = d.id;
                po2.subdivision__c = sd.id;
                po2.Target_Feature_Date__c = system.Today();
                insert po2;
                
                AssignedTo__c as1 = new assignedTo__c();
                as1.Purchase_Order__c = po2.id;
                as1.Assigned_To__c = u1.id;
                insert as1;
                
                PinnedMerchant__c pm = new PinnedMerchant__c();
                pm.Purchase_Order__c = po2.id;
                pm.lead__c = l1.id;
                insert pm;
                
                string SelDate = system.today().format();
                
                test.StartTest();
                MassClonePO mcpo = new MassClonePO();
                mcpo.getDivisionOptions();
                MassClonePO.getPurchaseOrderByDivisions(d.name);   
                MassClonePO.clonePO(po1.id, '');
                MassClonePO.clonePO(po2.id, SelDate);
                test.StopTest();
                
                }
        }      
}