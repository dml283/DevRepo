@RestResource(urlMapping = '/quantum-lead/update-quantum-leads')
global class RESTUpdateQuantumLeads {

    @HttpPOST
    global static List<Quantum_Lead__c> updateQuantumLead(List<Quantum_Lead__c> quantumLeads) {
        upsert quantumLeads Parent_Id__c;

        return [select Id, Sales_Value__c, Call_List_Priority__c, Sales_Value_Demand__c, Sales_Value_Reasons__c, quantum_lead_tag__c from Quantum_Lead__c where Id in :quantumLeads];
    }

    @IsTest
    public static void testmethod_REST_Valid_POST() {
        Account account = new Account();
        account.Name = 'Test';
        account.BillingStreet = '123 Main';
        account.BillingCity = 'Chicago';
        account.BillingState = 'IL';
        account.BillingPostalCode = '11111';
        account.BillingCountry = 'US';
        insert account;

        Quantum_Lead__c quantumLead = new Quantum_Lead__c();
        quantumLead.Account__c = account.id;
        quantumLead.Parent_Id__c = account.Id;
        insert quantumLead;

        User user = new GrouponTestUtil().createTestUser('API/DEV');
        insert user;

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/quantum-lead/update-quantum-leads';
        request.httpMethod = 'POST';
        RestContext.request = request;

        Quantum_Lead__c quantumLeadUpdate = (Quantum_Lead__c) JSON.deserialize(
            '{' +
                '"Sales_Value__c" : 42,' +
                '"Call_List_Priority__c" : "new call list priority",' +
                '"sales_value_demand__c" : "11111",' +
                '"sales_value_reasons__c" : "asdf|fda|fasdf",' +
                '"quantum_lead_tag__c" : "new_tag", ' +
                '"Account__c" : "' + account.Id + '", ' +
                '"Parent_Id__c" : "' + account.Id + '"' +
            '}',
            Quantum_Lead__c.class
        );

        List<Quantum_Lead__c> updatedQuantumLeads = RESTUpdateQuantumLeads.updateQuantumLead(new List<Quantum_Lead__c>{quantumLeadUpdate});

        System.Assert(updatedQuantumLeads.get(0).Sales_Value__c == 42);
    }

}