public class DevicerequestUpdate
{


public static String UpdateDevreq(string req)
{
String Exp;
Id validid;
devreq dev = (devreq)JSON.deserialize(req,DevicerequestUpdate.devreq.class);
if(dev.device_request_id == null || dev.device_request_id == '')
{
Exp = 'Id is empty.Please provide a valid Device Request ID. ';
}
else
{   

    if(((dev.device_request_id).length() <=18)   &&(!(dev.device_request_id).startswith('a2Z')))
    {
      system.debug('Right path ' + dev.device_request_id.length() + (!(dev.device_request_id).startswith('a2Z')));
    Exp = 'Id not Valid, unable to find the record.Please provide a valid Device Request ID. ';
    }
    else
    {
      system.debug('wrong path' + dev.device_request_id.length() + (!(dev.device_request_id).startswith('a2Z')));

        Device_request__c devicetoupdate = [select Id,shipping_tracking_number__c from Device_request__c where Id =: dev.device_request_id];
        
        if(dev.shipping_tracking_number == null || dev.shipping_tracking_number == '')
        {
            Exp = 'Shipping tracking not Provided in update call.Please provide a valid Shipping Tracking number. ';
        }
        else
        {
            try
            {
                devicetoupdate.shipping_tracking_number__c = dev.shipping_tracking_number ;
                devicetoupdate.Approved_flag__c = true;
                devicetoupdate.Device_Status_new__c = 'Shipped';
                devicetoupdate.Device_status__c     = 'Shipped';
                database.saveresult SR = database.update(devicetoupdate);
                if(Sr.ISsuccess())
                {
                    Exp = 'Updated';
                }
             }
             catch(Exception ex)
             {
                Exp = 'Unable to update. Exception Occured';
                
             }
         }
     }
}
return Exp;
}

public class devreq
{
    public string device_request_id;
    public string shipping_tracking_number;

    public devreq(string dev_Id,string Ship_track)
    {
        device_request_id        = dev_Id;
        shipping_tracking_number = Ship_track;
    }    
}
@Istest

public static void testme()
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

DevicerequestUpdate dev = new DevicerequestUpdate();
DevicerequestUpdate.devreq instance = new DevicerequestUpdate.devreq(string.valueof(Device.Id),'12345');    

string reques =  '{\"shipping_tracking_number\":\"12345\",\"device_request_id\":\"'+Device.Id+'\"}';
system.debug('REQUEST VALUE IS' + reques );
DevicerequestUpdate.UpdateDevreq(reques );

string reques2 =  '{\"shipping_tracking_number\":\"\",\"device_request_id\":\"'+Device.Id+'\"}';
system.debug('REQUEST VALUE IS' + reques2 );
DevicerequestUpdate.UpdateDevreq(reques2 );

string reques1 =  '{\"shipping_tracking_number\":\"12345\",\"device_request_id\":\"\"}';
system.debug('REQUEST VALUE IS' + reques1 );
DevicerequestUpdate.UpdateDevreq(reques1 );

string badId = 'Badid';
string reques3 =  '{\"shipping_tracking_number\":\"12345\",\"device_request_id\":\"'+badId+'\"}';
system.debug('REQUEST VALUE IS' + reques3 );
DevicerequestUpdate.UpdateDevreq(reques3 );

string reques5 =  '{\"shipping_tracking_number\":\"1234544444444444444445555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555\",\"device_request_id\":\"'+Device.Id+'\"}';
system.debug('REQUEST VALUE IS' + reques5 );
DevicerequestUpdate.UpdateDevreq(reques5 );
}

}