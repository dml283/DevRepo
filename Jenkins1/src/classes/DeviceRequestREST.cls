@RestResource(urlMapping='/v1.0/DeviceRequest/')
global  class DeviceRequestREST
{
    @HttpPost
    global static String UpdateDevicerequest(RestRequest req, RestResponse res)
    {
      string responsestring = (req.requestBody).toString();
      DevicerequestUpdate.UpdateDevreq(responsestring);
      return DevicerequestUpdate.UpdateDevreq(responsestring);
    }  
    
@isTest

 public static void testDoGet() 
{
Account acc = new Account();
acc.name = 'Test Account';
insert acc;
opportunity o = new opportunity();
o.name = 'test oppty';
o.StageName = 'Prospecting';
o.CloseDate = date.today();
o.Deal_Strengh__c = 'Rep Getting Info';
o.Feature_Date__c = date.newinstance(2011, 7, 15);
o.AccountId = acc.Id;
insert o; 
contact c = new contact();
c.Lastname = 'TestLastname';
c.AccountId = acc.Id;
insert c;
Address__c add = new Address__c();
add.Opportunity__c                      = o.Id;
Add.Street_Line_1__c                   = 'test street 1';
Add.Street_Line_2__c                   = 'test street 2';
Add.state__c                           = 'CA';
Add.Zip_Postal_Code__c                 = '12345';
Add.country__c                         = 'USA';
insert add;
device_request__c device = new device_request__c();
device.device_type__c = 'iPhone ($400)';
device.number_of_devices__c = 1;
device.Are_Devices_Required_to_Close_Deal__c    = 'yes';
device.Is_WiFi_available_at_Each_Location__c    = 'yes';
device.Use_Alternate_Address__c                 = true;
Device.Shipping_street__c                       ='Test street 1';
Device.shipping_city__c                         ='Test City';
Device.Shipping_State_Province__c               ='CA';
Device.Shipping_Zip_Postal_Code__c              ='12345';
Device.shipping_country__c                      ='USA'; 
Device.Opportunity__c                           = o.Id;
Insert Device;
    
    //string reques =  '{\"shipping_tracking_number\":\"12345\",\"device_request_id\":\"+Device.Id+\"}';
  string reques =  '{\"shipping_tracking_number\":\"12345\",\"device_request_id\":\"'+Device.Id+'\"}';
        // pass the req and resp objects to the method
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestBody = blob.valueof(reques) ;
    req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';
    req.httpMethod = 'GET';
    DevicerequestUpdate.UpdateDevreq(reques);
    DeviceRequestREST.UpdateDevicerequest(req,res);
}


}