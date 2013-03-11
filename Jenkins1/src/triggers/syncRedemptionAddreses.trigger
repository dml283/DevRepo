trigger syncRedemptionAddreses on Merchant_Addresses__c (after update) {
/*
if(!system.isBatch() && !system.isScheduled() && !system.isFuture()){
    list< Address__c > redemption_addys = new list< Address__c >();
    list<Merchant_Addresses__c> merch_addy = [SELECT City__c, Country__c, State_Province__c, Street_Line_1__c, Street_Line_2__c, Zip_Code__c, Zip_Postal_Code__c, neighborhood__c, Phone_Number__c, Venue_Name__c, (SELECT Country__c,City__c,State__c,Phone_Number__c,Zip_Postal_Code__c,Street_Line_2__c,Street_Line_1__c,Venue_Name__c,Neighborhood__c FROM Addresses__r) FROM Merchant_Addresses__c WHERE id IN :Trigger.new];
    
    for(Merchant_Addresses__c ma : merch_addy){
        for(Address__c a : ma.Addresses__r){
            a.City__c = ma.City__c;
            a.Country__c = ma.Country__c;
            a.State__c = ma.State_Province__c;
            a.Street_Line_1__c = ma.Street_Line_1__c;
            a.Street_Line_2__c = ma.Street_Line_2__c;
            a.Zip_Postal_Code__c = ma.Zip_Postal_Code__c;
            a.Phone_Number__c = ma.Phone_Number__c;
            a.Venue_Name__c = ma.Venue_Name__c;
            redemption_addys.add(a);
        }
    }
    database.update(redemption_addys);
}*/
}