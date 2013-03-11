global class scheduleMerchantStatusUpdate implements schedulable{
    
    global void execute(SchedulableContext sc){
        insertMerchantStatusRecord updateMerchStatus = new insertMerchantStatusRecord();
        database.executebatch(updateMerchStatus);
    }
    
}