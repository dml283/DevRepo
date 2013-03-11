@RestResource(urlMapping='/v1.0/merchant/device_request/*')
global class RESTpaymentDeviceRequestAPI {

    @HttpGET
    global static void doGet() {
        final RestRequest request = RestContext.request;
        final RestResponse response = RestContext.response;

        final String requestUri = request.requestURI;
        final String method = requestUri.substring(requestUri.lastIndexOf('/') + 1);
        if (method == 'types') {
            sendResponse(response, getDeviceTypes());
            return;
        }

        String salesforceId = request.params.get('salesforce_id');
        if (salesforceId != null && salesforceId != '') {
            salesforceId = EncodingUtil.urlDecode(salesforceId, 'UTF-8');
            sendResponse(response, getDeviceRequests(salesforceId));
            return;
        }

        response.StatusCode=400;
    }

    private static List<DeviceRequestVo> getDeviceRequests(String accountId) {
    	final List<Device_Request__c> requests =
    	       [SELECT Id, Name, Account__c, Opportunity__c, Approval_Status__c,
    	               Device_Type__c, Number_of_Devices__c,
    	               Shipping_Street__c, Shipping_City__c, Shipping_State_Province__c,
    	               Shipping_Country__c, Shipping_Zip_Postal_Code__c
                  FROM Device_Request__c
                 WHERE Account__r.Id =:accountId];

        final List<DeviceRequestVo> requestsVo = new List<DeviceRequestVo>();
        for (Device_Request__c dr : requests) {
            requestsVo.add(new DeviceRequestVo(dr));
        }
        return requestsVo;
    }

    private static List<PicklistEntry> getDeviceTypes() {
        return Device_Request__c.Device_Type__c.getDescribe().getPicklistValues();
    }

    private static void sendResponse(RestResponse response, Object body) {
        response.addHeader('Content-Type', 'application/json;');
        response.responseBody = Blob.valueof(JSON.serialize(body));
    }

    /** Value Object for creating and query device requests. */
    public class DeviceRequestVo {
    	public ID id { get; set; }
    	public String name { get; set; }
        public ID account_id { get; set; }
        public String approval_status { get; set; }

        public String device_type { get; set; }
        public decimal number_of_devices { get; set; }

        public ShippingAddressVo shipping_address { get; set; }

        /** Default constructor. */
        public DeviceRequestVo() {}

        public DeviceRequestVo(Device_Request__c pDeviceRequest) {
        	this.id = pDeviceRequest.Id;
        	this.name = pDeviceRequest.Name;
        	this.account_id = pDeviceRequest.Account__c;
        	this.approval_status = pDeviceRequest.Approval_Status__c;

            this.device_type = pDeviceRequest.Device_Type__c;
            this.number_of_devices = pDeviceRequest.Number_of_Devices__c;

            this.shipping_address = new ShippingAddressVo(pDeviceRequest);
        }
    }

    public class ShippingAddressVo {
        public String street { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String zip_code { get; set; }
        public String country { get; set; }

        /** Default constructor. */
        public ShippingAddressVo() {}

        public ShippingAddressVo(Device_Request__c pDeviceRequest) {
        	this.street = pDeviceRequest.Shipping_Street__c;
        	this.city = pDeviceRequest.Shipping_City__c;
        	this.state = pDeviceRequest.Shipping_State_Province__c;
        	this.zip_code = pDeviceRequest.Shipping_Zip_Postal_Code__c;
        	this.country = pDeviceRequest.Shipping_Country__c;
        }
    }

    @HttpPOST
    global static void create() {
    	final RestRequest request = RestContext.request;
    	final DeviceRequestVo device_request = (DeviceRequestVo) JSON.deserialize(
    	       request.requestBody.toString(), DeviceRequestVo.class);
        Device_Request__c devRequest = createSalesforceDeviceRequest(device_request);
        insert devRequest;
        devRequest = reloadDeviceRequest(devRequest);

        final RestResponse response = RestContext.response;
        sendResponse(response, new DeviceRequestVo(devRequest));
    }

    static Device_Request__c createSalesforceDeviceRequest(DeviceRequestVo pDeviceRequest) {
    	final ShippingAddressVo pAddress = pDeviceRequest.shipping_address;
        final Device_Request__c devRequest =
            new Device_Request__c(
                Account__c = pDeviceRequest.account_id,
                Device_Type__c = pDeviceRequest.device_type,
                Number_of_Devices__c = pDeviceRequest.number_of_devices,
                Shipping_Street__c = pAddress.street, Shipping_City__c = pAddress.city,
                Shipping_State_Province__c = pAddress.state, Shipping_Country__c = pAddress.country,
                Shipping_Zip_Postal_Code__c = pAddress.zip_code, Use_Alternate_Address__c = true);

        return devRequest;
    }

    static Device_Request__c reloadDeviceRequest(Device_Request__c devRequest) {
        return [SELECT Id, Name, Account__c, Opportunity__c, Approval_Status__c,
                       Device_Type__c, Number_of_Devices__c,
                       Shipping_Street__c, Shipping_City__c, Shipping_State_Province__c,
                       Shipping_Country__c, Shipping_Zip_Postal_Code__c
                  FROM Device_Request__c
                 WHERE Id = :devRequest.Id];
    }
}