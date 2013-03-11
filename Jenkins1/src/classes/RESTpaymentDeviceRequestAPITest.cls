@isTest
private class RESTpaymentDeviceRequestAPITest {

    static testMethod void testGetDeviceTypes() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/v1.0/merchant/device_request/types';
        RestContext.request = request;

        RestResponse response = new RestResponse();
        RestContext.response = response;

        RESTpaymentDeviceRequestAPI.doGet();
        System.assertEquals(JSON.serialize(deviceTypes()), response.responseBody.toString());
    }

    private static List<PickListEntry> deviceTypes() {
        return Device_Request__c.Device_Type__c.getDescribe().getPicklistValues();
    }

    static testMethod void testGetDeviceRequests() {
        Account testAccount = createTestAccount();
        List<RESTpaymentDeviceRequestAPI.DeviceRequestVo> deviceRequests =
               createDeviceRequests(testAccount);

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/v1.0/merchant/device_request';
        request.addParameter('salesforce_id', testAccount.id);
        RestContext.request = request;

        RestResponse response = new RestResponse();
        RestContext.response = response;

        RESTpaymentDeviceRequestAPI.doGet();
        List<RESTpaymentDeviceRequestAPI.DeviceRequestVo> actualRequests =
            (List<RESTpaymentDeviceRequestAPI.DeviceRequestVo>) JSON.deserialize(
                    response.responseBody.toString(), List<RESTpaymentDeviceRequestAPI.DeviceRequestVo>.class);

        System.assertEquals(deviceRequests.size(), actualRequests.size());
        Integer i = 0;
        for (RESTpaymentDeviceRequestAPI.DeviceRequestVo expectedDeviceRequest : deviceRequests) {
            assertRequestEquals(expectedDeviceRequest, actualRequests[i]);
            i++;
        }
    }

    static List<RESTpaymentDeviceRequestAPI.DeviceRequestVo> createDeviceRequests(
            Account testAccount) {
        Device_Request__c devRequest = new Device_Request__c(
                Account__c = testAccount.Id,
                Device_Type__c = 'Magtek USB Credit Card Swiper',
                Number_of_Devices__c = 1,
                Shipping_Street__c = '47 East 1st Street', Shipping_City__c = 'New York',
                Shipping_State_Province__c = 'NY', Shipping_Country__c = 'US',
                Shipping_Zip_Postal_Code__c = '10003', Use_Alternate_Address__c = true);
        insert devRequest;

        devRequest =
            [SELECT Id, Name, Account__c, Opportunity__c, Approval_Status__c,
                    Device_Type__c, Number_of_Devices__c,
                    Shipping_Street__c, Shipping_City__c, Shipping_State_Province__c,
                    Shipping_Country__c, Shipping_Zip_Postal_Code__c
               FROM Device_Request__c
              WHERE Id = :devRequest.Id];

        return new RESTpaymentDeviceRequestAPI.DeviceRequestVo[] {createRequestVo(devRequest)};
    }

    static RESTpaymentDeviceRequestAPI.DeviceRequestVo createRequestVo(
            Device_Request__c soDeviceRequest) {
        RESTpaymentDeviceRequestAPI.DeviceRequestVo requestVo =
                new RESTpaymentDeviceRequestAPI.DeviceRequestVo();
        requestVo.id = soDeviceRequest.Id;
        requestVo.name = soDeviceRequest.Name;
        requestVo.account_id = soDeviceRequest.Account__c;
        requestVo.approval_status = soDeviceRequest.Approval_Status__c;
        requestVo.device_type = soDeviceRequest.Device_Type__c;
        requestVo.number_of_devices = soDeviceRequest.Number_of_Devices__c;

        requestVo.shipping_address = new RESTpaymentDeviceRequestAPI.ShippingAddressVo();
        requestVo.shipping_address.street = soDeviceRequest.Shipping_Street__c;
        requestVo.shipping_address.city = soDeviceRequest.Shipping_City__c;
        requestVo.shipping_address.state = soDeviceRequest.Shipping_State_Province__c;
        requestVo.shipping_address.zip_code = soDeviceRequest.Shipping_Zip_Postal_Code__c;
        requestVo.shipping_address.country = soDeviceRequest.Shipping_Country__c;

        return requestVo;
    }

    static testMethod void testGetBadRequest() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/v1.0/merchant/device_request';
        RestContext.request = request;

        RestResponse response = new RestResponse();
        RestContext.response = response;

        RESTpaymentDeviceRequestAPI.doGet();
        System.assertEquals(400, response.statusCode);
    }

    static testMethod void testCreateDeviceRequest() {
    	Account testAccount = createTestAccount();
    	RESTpaymentDeviceRequestAPI.DeviceRequestVo input =
    	       new RESTpaymentDeviceRequestAPI.DeviceRequestVo();
        input.account_id = testAccount.Id;
        input.device_type = 'Magtek USB Credit Card Swiper';
        input.shipping_address = new RESTpaymentDeviceRequestAPI.ShippingAddressVo();
        input.shipping_address.street = '47 East 1st Street';
        input.shipping_address.city = 'New York';
        input.shipping_address.state = 'NY';
        input.shipping_address.zip_code = '10003';
        input.shipping_address.country = 'US';

        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(input));
        RestContext.request = request;

        RestResponse response = new RestResponse();
        RestContext.response = response;

        RESTpaymentDeviceRequestAPI.create();
        RESTpaymentDeviceRequestAPI.DeviceRequestVo output =
            (RESTpaymentDeviceRequestAPI.DeviceRequestVo) JSON.deserialize(
                response.responseBody.toString(), RESTpaymentDeviceRequestAPI.DeviceRequestVo.class);
        System.assertEquals(1, [SELECT COUNT() FROM Device_Request__c WHERE Id = :output.id]);
        System.assert(output.name != null);
        System.assert(output.approval_status != null);
    }

    static Account createTestAccount() {
        Account testAccount = new Account(Name = 'Test Account', Make_Checks_Payable_to__c = 'Test',
           BillingStreet ='42nd Street', BillingCity = 'Nowhere', BillingState = 'NO',
           Merchant_Permalink__c = 'test', Bank_Name__c = 'First Bank', Routing_Number_enc__c = '001',
           Account_Number__c = '100', Valid_Routing__c = 'N/A', Tax_ID__c = '111',
           Payment_Preference__c = 'ACH (Direct Deposit)');
        insert testAccount;

        return testAccount;
    }

    static void assertRequestEquals(RESTpaymentDeviceRequestAPI.DeviceRequestVo expected,
            RESTpaymentDeviceRequestAPI.DeviceRequestVo actual) {
        System.assertEquals(expected.id, actual.id);
        System.assertEquals(expected.name, actual.name);
        System.assertEquals(expected.account_id, actual.account_id);
        System.assertEquals(expected.approval_status, actual.approval_status);
        System.assertEquals(expected.device_type, actual.device_type);
        System.assertEquals(expected.number_of_devices, actual.number_of_devices);

        System.assertEquals(expected.shipping_address.street, actual.shipping_address.street);
        System.assertEquals(expected.shipping_address.city, actual.shipping_address.city);
        System.assertEquals(expected.shipping_address.state, actual.shipping_address.state);
        System.assertEquals(expected.shipping_address.zip_code, actual.shipping_address.zip_code);
        System.assertEquals(expected.shipping_address.country, actual.shipping_address.country);
    }
}