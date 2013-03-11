@RestResource(urlMapping = '/quantum_lead/merchant_info_ql')
global class RESTMerchantInfoQL {

    @HttpPost
    global static List<RESTMerchantInfo.Merchant> post(List<String> merchant_ids) {
        List<RESTMerchantInfo.Merchant> merchants = RESTMerchantInfo.post(merchant_ids);

        Map<Id, Quantum_Lead__c> accountQuantumLeads = new Map<Id, Quantum_Lead__c>();

        for (Quantum_Lead__c quantumLead : [select Account__c, Sales_Value__c, Call_List_Priority__c from Quantum_Lead__c where Account__c in :merchant_ids]) {
            accountQuantumLeads.put(quantumLead.Account__c, quantumLead);
        }

        for (RESTMerchantInfo.Merchant merchant : merchants) {
            Quantum_Lead__c quantumLead = accountQuantumLeads.get(merchant.id);
            if (quantumLead != null) {
                merchant.sales_value = quantumLead.Sales_Value__c;
                merchant.call_list_priority = quantumLead.Call_List_Priority__c;
            }
        }

        return merchants;
    }


    @isTest
    static void testPost() {
        Account account = new Account();
        account.Name = 'Test';
        account.BillingStreet = '123 Main';
        account.BillingCity = 'Chicago';
        account.BillingState = 'IL';
        account.BillingPostalCode = '11111';
        account.BillingCountry = 'US';
        insert account;

        Quantum_Lead__c quantumLead = new Quantum_Lead__c();
        quantumLead.Account__c = account.Id;
        quantumLead.Parent_Id__c = account.Id;
        quantumLead.Sales_Value__c = 5;
        insert quantumLead;

        List<RESTMerchantInfo.Merchant> merchants = RESTMerchantInfoQL.post(new List<String>{account.Id});

        System.assertEquals(1, merchants.size());
        System.assertEquals(5, merchants[0].sales_value);
    }

}