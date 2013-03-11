public class InlineOptionsExt {
    
    public id dealId{get;set;}
    public list<Multi_Deal__c> optionsList{get;set;}
    public string delSelectedId{get;set;}
    
    public InlineOptionsExt(ApexPages.StandardController controller){
            dealId = ApexPages.currentPage().getParameters().get('Id');
        }

    
    public string getOptions(){
            list<Multi_Deal__c> optionsList = new list<Multi_Deal__c>();
            for(Multi_Deal__c option : [SELECT id, Name, Display_Order__c, Product_SKU__c, Unit_Buy_Price__c, Unit_Sell_Price__c, Unit_Value__c, Margin_Percent__c, Discount__c, Total_Deal_Max__c, Option_Services__c, Option_Attributes__c, GrouponLite_Monthly_Cap__c
                                        FROM Multi_Deal__c
                                        WHERE Opportunity__c =: dealId]){
                                                optionsList.add(option);        
                                            }
             return JSON.serialize(optionsList);
        }
    /*
    @RemoteAction
    public static void delOption(string optId){
            //system.debug('DID I MAKE IT TO THE REMOTE ACTION?');
            database.delete(optId);
        }
    */  

    @isTest
    public static void testInlineOptionsExt(){
            grouponTestUtil gTestUtil = new grouponTestUtil();
            User u = gTestUtil.createTestUser('System Administrator');
            u.username = 'inlineOptions@test.com';
            insert u;
            System.RunAs(u){
                    Account Acct = gTestUtil.createAccount();
                    insert Acct;
                    
                    Opportunity oppty = gTestUtil.createDeal();
                    oppty.AccountId = Acct.Id;
                    insert oppty;
                    
                    Multi_Deal__c md = gTestUtil.createOption();
                    md.Opportunity__c = oppty.Id;
                    md.Option_Services__c = 'Test 1 | Test 2';
                    md.Option_Attributes__c = 'Test Attributes';
                    insert md;

                    Multi_Deal__c md1 = gTestUtil.createOption();
                    md1.Opportunity__c = oppty.Id;
                    md1.Option_Services__c = null;
                    insert md1;
                    
                    PageReference pr = page.inlineOptions;
                    Test.setCurrentPageReference(pr);
                    
                    ApexPages.currentPage().getParameters().put('id',oppty.id);
                    ApexPages.StandardController opptyController = new ApexPages.StandardController(oppty);
                     
                    InlineOptionsExt inlineOppty = new InlineOptionsExt(opptyController);
                    inlineOppty.getOptions(); 
                    
                    
                    //InlineOptionsExt.delOption(md1.id);
                     
                           
                }
            
        }

}