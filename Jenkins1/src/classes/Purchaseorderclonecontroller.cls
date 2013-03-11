public with sharing class Purchaseorderclonecontroller {
        
    public purchase_order__c clonePO {get; set;}
    public Id currentPOId {get; set;}
    public purchase_order__c currentPO {get; set;}
    public List <pinnedmerchant__c> clonedpinnedmerch {get; set;}
    public List <Assignedto__c>  clonedAssignedTo  {get;set;}
    public Purchaseorderclonecontroller (ApexPages.StandardController ctrl){
        //Grab Cloned Opp and all of the fields they wish to clone. 
        currentPOId = ctrl.getID();
        clonedpinnedmerch = new List<pinnedmerchant__c>();
        clonedAssignedTo  = new List<AssignedTo__c>();
    }
        
    public PageReference cloneAndRedirectTravel() {
        try {
            currentPO = [SELECT Id, OwnerId, Assigned_To__c, PO_Submitted_Date__c, Example_Deal_1__c, Example_Deal_2__c, Deal_Builder_Template__c, Merchant_Value_Prop__c, Assigned_To_multi__c, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Category_v3__c,
                                Subcategory_v3__c, Division__c, Subdivision__c, Location__c, Ideal_Price_Range__c, Target_Feature_Date__c, Target_Revenue__c, Target_GP__c, PO_Notes__c, Rep_PO_Notes__c, Services__c, Target_Bookings__c
                        FROM Purchase_order__c 
                        WHERE  Id =: currentPOId];    
          
            //Also Grab all related objects which in this case is Questions, Multi Deals and Addresses                      
            List<pinnedmerchant__c> pinnedmerchants = [SELECT Id,Lead__c,Lead__r.Isconverted,Lead__r.ConvertedAccountId,Account__c,Opportunity__c FROM Pinnedmerchant__c WHERE Purchase_order__c =: currentPOId ];                                                       
            List<AssignedTo__c> Assignedvals = [SELECT Id,Assigned_To__c,PO_Category__c,PO_Created_By__c,PO_Division__c,PO_Ideal_Price__c,PO_Location__c,PO_Subcategory_1__c,PO_Subcategory_2__c,PO_Subdivision__c,PO_Target_Feature_Date__c,PO_unique_id__c,Purchase_Order__c,Name FROM AssignedTo__c WHERE Purchase_order__c =: currentPOId];
            //Make copies of current Opp plus all its related objects
            
            clonePO                                         = currentPO.clone(false);
            clonePO.OwnerId                                 = currentPO.OwnerId;
            clonePO.Purchase_Order__c                       = currentPOId;
            clonePO.Assigned_To__c                          = currentPO.Assigned_To__c;
            clonePO.PO_Submitted_Date__c                    = currentPO.PO_Submitted_Date__c;
            clonePO.Example_Deal_1__c                       = currentPO.Example_Deal_1__c;
            clonePO.Example_Deal_2__c                       = currentPO.Example_Deal_2__c;
            clonePO.Deal_Builder_Template__c                = currentPO.Deal_Builder_Template__c;   
            clonePO.Merchant_Value_Prop__c                  = currentPO.Merchant_Value_Prop__c;
            clonePO.Assigned_To_multi__c                    = currentPO.Assigned_To_multi__c;
            clonePO.Global_SFDC_Category__c                 = currentPO.Global_SFDC_Category__c;
            clonePO.Global_SFDC_Subcategory_1__c            = currentPO.Global_SFDC_Subcategory_1__c;
            clonePO.Global_SFDC_Subcategory_2__c            = currentPO.Global_SFDC_Subcategory_2__c;
            clonePO.Division__c                             = currentPO.Division__c;
            clonePO.Subdivision__c                          = currentPO.Subdivision__c;
            clonePO.Location__c                             = currentPO.Location__c;
            clonePO.Ideal_Price_Range__c                    = currentPO.Ideal_Price_Range__c;   
            clonePO.Target_Feature_Date__c                  = currentPO.Target_Feature_Date__c;
            clonePO.Target_Revenue__c                       = currentPO.Target_Revenue__c;
            clonePO.Target_GP__c                            = currentPO.Target_GP__c;
            clonePO.PO_Notes__c                             = currentPO.PO_Notes__c;
            clonePO.Rep_PO_Notes__c                         = currentPO.Rep_PO_Notes__c;
            clonePO.Subcategory_v3__c                       = currentPO.Subcategory_v3__c;
            clonePO.Category_v3__c                          = currentPO.Category_v3__c;
            clonePO.Services__c                             = currentPO.Services__c;
            clonePO.Target_Bookings__c                      = currentPO.Target_Bookings__c;
            insert clonePO;                             
            
            for(AssignedTo__c assign : Assignedvals) {
                if(assign != null) {
                    AssignedTo__c  clonedAssign = new AssignedTo__c ();
                    clonedAssign = assign.clone(false);
                    clonedAssign.Purchase_order__c = clonePO.Id;
                    clonedAssign.Assigned_To__c = assign.Assigned_To__c;
                    clonedAssignedTo.add(clonedAssign);
                }      
            }
            
            Insert clonedAssignedTo;
                      
            for (Pinnedmerchant__c a: pinnedmerchants) {
                if(a != null) {
                    pinnedmerchant__c clonepinned = new pinnedmerchant__c();
                    clonepinned = a.clone(false); 
                    clonepinned.Purchase_order__c = clonePO.Id;
                    clonepinned.Account__c        = a.Account__c;
                    clonepinned.Opportunity__c    = a.Opportunity__c;
                    if(a.Lead__r.Isconverted == False) {
                        system.debug('Entered here' + a.Lead__r.Isconverted );
                        clonepinned.Lead__c = a.Lead__c; 
                        clonepinned.Account__c = a.account__c;  
                    } else {
                        system.debug('Entered here for Acc' + a.Lead__r.Isconverted );
                        clonepinned.Lead__c = null; 
                        clonepinned.Account__c = a.Lead__r.convertedaccountId;
                    }
                
                    clonedpinnedmerch.add(clonepinned);
                    system.debug('Cloned pinned merch' + clonedpinnedmerch);
                }
            }

            insert clonedpinnedmerch;
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        return new PageReference('/'+ clonePO.Id);
    }
        
    @Istest
    public static void testme() {
        Date myDate =  date.newinstance(1960, 2, 17);
        division__c div = new division__c();
        div.name = 'test div';
        div.state__c = 'CA';
        insert div;

        purchase_order__c currentPO = new purchase_order__c();
        currentpo.division__c = div.Id;
        currentpo.target_feature_date__c = myDate ;
        insert currentPO;

        Lead Leadval = new Lead();
        Leadval.company = 'test';
        Leadval.status  = 'contacted';
        Leadval.Lastname= 'Testlame';
        Leadval.division__c= 'Atlanta';
        Insert Leadval;

        pinnedmerchant__c clonepinned = new pinnedmerchant__c();
        clonepinned.purchase_order__c = currentPO.Id;
        clonepinned.Lead__c           = Leadval.Id;
        Insert clonepinned;                   

        Purchaseorderclonecontroller POinst = new Purchaseorderclonecontroller( new ApexPages.StandardController(currentPO));
        POinst.cloneAndRedirectTravel();
    }
}