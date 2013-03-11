public with sharing class deal_structure_emails_goods_controller {
public string assignedtoId{get;set;}
List<multi_deal__c> multideals = new list<multi_deal__c>();
public List<multi_deal__c> getmultideals()
{
multideals  = [select id,name,unit_buy_price__c, Cost_to_Purchase_All_Units__c, unit_sell_price__c, unit_value__c,Total_Deal_Max__c, margin__c, Discount__c, Product_SKU__c, Estimated_Shipping_Cost_per_Unit_3PL__c from multi_deal__c where opportunity__c =:assignedtoId];
return multideals;
}
public Opportunity getOpportunity ()
{
opportunity Opp = [select id,name,Feature_or_Refeature__c,Owner.name,Division__c,Subdivision__c,Freight_Terms__c,Fulfillment_Method__c,
                          Account.name,Merchant_Quality_Ranking__c,CC_Fee__c,Max_Units__c,Payment_Preference__c,Freight_Allowance__c, Total_Cost_to_Purchase_All_Units__c,
                          Payment_Terms__c,conditions__c,Deal_Structure_Approval_Notes__c,Amount_of_Multi_Deal_Children__c,Refund_Allowance__c, 
                          Now_Sales_Info__c, Total_Multi_Deal_Max__c,Rewards_Sales_Info__c from opportunity where ID =: assignedtoId];
return Opp;
}

@IsTest
public static void Testme()
    {
     deal_structure_emails_controller  tester = new deal_structure_emails_controller ();
     String rtTestOn = 'Food and Drink';
     Opportunity testOpp = TestUtil.createOppty(rtTestOn, 'Bars');
     tester.assignedtoId = testOpp .Id;
     tester.getmultideals();
     system.assertNOTequals(tester.getmultideals(),null);
     tester.getOpportunity();
     system.assertNOTequals(tester.getOpportunity(),null);

    }
}