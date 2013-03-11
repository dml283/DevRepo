/**
 */
@isTest
private class UUiDTester {
/*
       static testMethod void UUidTester() {
               
            Account ac=TestUtil.createAccount();
            insert ac;
            Merchant_Addresses__c m=TestUtil.createMerchantAddress(ac);
            Address__c a=new Address__c(Opportunity__c=TestUtil.createOpptyWacct().id);
            insert a;
            m=[select UUID__c from Merchant_Addresses__c where id=:m.id ];
            a= [select UUiD__c,Merchant_Addresses__c from Address__c where id=:a.id];
            String uid=m.UUID__c;
            uid.remove('-');
            system.debug(uid.length());
            system.assert(uid!=null);
            uid=a.UUiD__c.replace('-','');
            system.assert(uid.length()==32);
            a.Merchant_Addresses__c=m.id;
            update a;
            a= [select UUiD__c,Merchant_Addresses__c from Address__c where id=:a.id];
            system.assert(m.UUID__c==a.UUiD__c);
    }
    */
}