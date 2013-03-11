@Istest
public class testclassDevicereqformobilsense
{   
    static testmethod void testme()
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
    
    device_request__c device = new device_request__c();
    device.device_type__c = 'iPhone ($400)';
    device.number_of_devices__c = 1;
    device.Approval_status__c     = 'Approved';
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
//Update Device request
    device.number_of_devices__c = 2; 
    update device;
    }
}