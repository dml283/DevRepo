global class MerchantStatusUpdateTask {
    public static void setMerchantStatus(List<Task> beforeInsertTasks) {
    
        for(task t :beforeInsertTasks) {
            if(t.Merchant_Disposition__c != null && (t.Merchant_Status__c == null || t.Merchant_Status__c == 'Prospecting')){            
                t.Merchant_Status__c = t.Merchant_Disposition__c;
            }
        }
    }
}