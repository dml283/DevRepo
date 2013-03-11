public class RefundedUnits {
    
    public static void ExecuteRefundedUnits(set<Id> OpportunityIds)
    {
         system.debug('Why hello there, we are now inside the future method');
         map<id,double>OpptyMap = new map <id,double>();
         map<id,double>OpptyMap2 = new map <id,double>();                                       
            
            for(AggregateResult q1:[SELECT Opportunity__c opid1, sum(units_refunded__c) opunitsref
                                    FROM Financial_Records__c
                                    WHERE Opportunity__c IN: OpportunityIds
                                    GROUP BY Opportunity__c])
                                    {
                                        OpptyMap.put(((ID)q1.get('opid1')),((double)q1.get('opunitsref')));
                                    }
            
            for(AggregateResult q3:[SELECT Opportunity__c opid1, sum(units_refunded__c) opunitsref
                                    FROM Financial_Records__c
                                    WHERE Valid_For_Escrow__c = 'True' AND Opportunity__c IN: OpportunityIds
                                    GROUP BY Opportunity__c])
                                    {
                                        OpptyMap2.put(((ID)q3.get('opid1')),((double)q3.get('opunitsref')));
                                    }
            
            list<opportunity>optemp = [SELECT Id, Rolling_Refund_Unit_Total__c, Feature_Date__c
                                    FROM Opportunity
                                    WHERE Id
                                    IN: OpportunityIds 
                                    FOR UPDATE];
                for(Opportunity o1: optemp)
                    {
                        date datebound = o1.feature_date__c;
                        datebound.adddays(55);
                        double RollupRefundUnits1=OpptyMap.get(o1.id);
                        o1.Rolling_Refund_Unit_Total__c=RollupRefundUnits1;
                        o1.Refund_Escrow_Quantity_Current__c=opptymap2.get(o1.id);    
                    }
            update optemp;
            
           // ExecuteMDRefundedUnits(MultiDealIds);          
    }
    
  
    public static void ExecuteMDRefundedUnits(set<Id> MultiDealIds)
    {
         system.debug('Why hello there, we are now inside the future method');
         map<id,double>MultiDealMap = new map <id,double>();
         map<id,double>MultiDealMap2 = new map <id,double>();                                         
                                   
            for(AggregateResult q2:[SELECT Multi_Deal__c mdid1, sum(units_refunded__c) mdunitsref
                                   FROM Financial_Records__c
                                   WHERE Multi_Deal__c
                                   IN: MultiDealIds
                                   GROUP BY Multi_Deal__c])                           
                                    {
                                         MultiDealMap.put(((ID)q2.get('mdid1')),((double)q2.get('mdunitsref')));
                                    }
            
            for(AggregateResult q4:[SELECT Multi_Deal__c mdid1, sum(units_refunded__c) mdunitsref
                                   FROM Financial_Records__c
                                   WHERE Valid_For_Escrow__c = 'True' AND Multi_Deal__c IN: MultiDealIds
                                   GROUP BY Multi_Deal__c])                           
                                    {
                                         MultiDealMap2.put(((ID)q4.get('mdid1')),((double)q4.get('mdunitsref')));
                                    }
            
            list<Multi_Deal__c> mdtemp = [SELECT Id, Rolling_Refund_Unit_Total__c, opportunity__r.feature_date__c
                                           FROM Multi_Deal__c
                                           WHERE Id
                                           In: MultiDealIds
                                           FOR UPDATE];
                for(Multi_Deal__c md1: mdtemp)
                    {
                        date datebound = md1.opportunity__r.feature_date__c;
                        datebound.adddays(55);
                        double RollupRefundUnits2=MultiDealMap.get(md1.id);
                        md1.Rolling_Refund_Unit_Total__c=RollupRefundUnits2;
                        md1.Refund_Escrow_Quantity_Current__c=multidealmap2.get(md1.id);    
                    }     
            update mdtemp;
    }
}