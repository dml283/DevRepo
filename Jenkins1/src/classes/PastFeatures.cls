public class PastFeatures {
        public PastFeatures(ApexPages.StandardController controller) {}
        public list<Opportunity> getPastDeals()
        {
                ID OppId = ApexPages.currentPage().getParameters().get('id');
                list<Opportunity> theIds = [select Account.id from Opportunity where id = :OppID LIMIT 1];
                ID AcctID;
                
                for(Opportunity o : theIds)
                        {
                                AcctID = o.Account.id;
                        }
                
                List <Opportunity> past =
                [select id, Account.id, Name, Division__c, Feature_Date__c, Permalink__c, Copy_Coordinator__c, Deal_Strengh__c, PPM__c, ePPM__c, Total_GP__c, Total_Units_Sold__c, Researcher__c, Writeup_Status_del__c, DV__c
                FROM Opportunity
                WHERE Account.id = :AcctID AND StageName = 'Closed Won' AND id != :OppId
                ORDER BY Feature_Date__c DESC
                ];
                
                return past;
        }

}