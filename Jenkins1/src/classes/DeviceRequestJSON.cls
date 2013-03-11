//This class is called by the trigger_Device_Request_mobile_sense_Integration  trigger when the Device Request is Edited/Inserted
Public class DeviceRequestJSON
{
//Marking this as a future method because HTTP callouts cannot be made from a trigger in a synchronous mode.
@FUTURE(callout = true)
public STATIC void sendDeviceRequest(Id DeviceID )
{
Opportunity    opps;
Account        accs;
contact        cons;
Grouponnow__c  now;
Address__c     Add;
string R1;
String encoded;
string endpoint = 'http://partners.mobilsense.com/groupon/Utility/Interfaces/Groupon/createOrder';
http h = new http();
device_request__c devs = [select id,Opportunity__c,Use_Alternate_Address__c,
                                 Shipping_City__c,Shipping_State_Province__c,
                                 Shipping_Country__c,Shipping_Zip_Postal_Code__c,
                                 device_type__c,request_date__c,Approval_Date__c,
                                 shipping_address__c,name,account__c,owner.name,
                                 Number_of_Devices__c,owner.email,Shipping_Street__c,
                                 Shipping_Method__c,Return_Tracking_Number__c,
                                 Device_ID_s__c,Return_Required__c
                          from   device_request__c
                          where  id=: DeviceID  ];
    if(devs !=null)
    {
        if(devs.Opportunity__c !=null)
        {
            opps = [select id,recordtype.name,feature_date__c,expiration_date__c from opportunity where id=: devs.Opportunity__c limit 1];
        }
        if(devs.account__c != null)
        {
            accs = [select id,name from Account where Id=:devs.account__c limit 1];
        }
        if(accs!= null)
        {
            cons = [select id,name,lastname,firstname,phone,email from contact where AccountId =: accs.ID limit 1];
        }
        if(devs.shipping_address__c != null)
        {
            Add  = [select id,Street_Line_1__c,Street_Line_2__c,city__c,state__c,Zip_Postal_Code__c,Country__c from Address__c where Id=: devs.Shipping_Address__c limit 1];
        }
    }
    try
    {
        //if(opps != null)
        //{
 
        R1 = formatdevicereq(devs,opps,accs,cons,Add);
        system.debug('!!!!! R1' + R1 );

        encoded = EncodingUtil.urlEncode(R1 , 'UTF-8');
        encoded = encoded.replace('+', '%20');
        system.debug('!!!!! R1' + encoded );
        //}
        
    }
    catch(exception ex)
    {
        system.debug('Exception occured' + ex);       
    }

    try
    {
    HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setHeader('Content-Type', ' application/x-www-form-urlencoded');         
                req.setMethod('POST');
                        system.debug('!!!!! R1 here ' + encoded);
                        req.setBody(encoded);
    HttpResponse res = h.send(req);
    system.debug('Response.getStatus()' + res.getbody());
 
    devs.Failure_Reason__c = res.getbody();
    if(res.getbody().contains('OK') ||res.getbody().contains('WARNING') )
    {
    devs.Device_Status_new__c = 'Ordered';
    devs.Device_Status__c     = 'Ordered';
    }
    devs.approved_flag__c = true;
    devs.device_id_s__c   = 'Pending';
    devs.shipping_tracking_number__c = 'Pending';
    try{
    update devs;
    batchapexstop.stopbatchapex = true; 
    }
    catch(exception ex)
    {
    system.debug('Exception occured when saving the failure reason' + ex);

    }

       }
    catch(Exception e)
    {
    system.debug('Exception occured when posting data' + e);
    }

}
public STATIC string formatdevicereq(device_request__c dev,opportunity opp,account acc,contact con,Address__c Adds)
{
Request Device = new Request();
Device.device_type                       =dev.device_type__c ;
Device.requester_name                    =dev.Owner.name;
Device.requester_email                   =dev.Owner.Email;
Device.merchant_contact_last_name        =con.lastname;
Device.merchant_contact_name             =con.name;
Device.merchant_contact_first_name       =con.firstname;
Device.account_id                        =acc.Id;
Device.account_name                      =acc.name;
if (opp != null){
    Device.opportunity_id                    =Opp.Id;
    Device.opportunity_record_type           =Opp.recordtype.name;
    Device.feature_date                      =opp.Feature_date__c;
    Device.expiration_date                   =opp.expiration_date__c;
}
Device.request_date                      =dev.request_date__c;
Device.approval_date                     =dev.Approval_Date__c;
Device.device_request_id                 =dev.Id;
Device.device_request_name               =dev.name;
Device.device_count                      =dev.Number_of_Devices__c;
Device.merchant_phone                    =con.phone;
Device.merchant_email                    =con.email;
if(dev.Use_Alternate_Address__c == true)
{
Device.shipping_address_1                =dev.shipping_street__c;
Device.shipping_city                     =dev.Shipping_City__c;
Device.shipping_state                    =dev.Shipping_State_Province__c;
Device.shipping_postal_code              =dev.Shipping_Zip_Postal_Code__c;
Device.shipping_country                  =dev.Shipping_Country__c; 
}
else
{
Device.shipping_address_1                = Adds.Street_Line_1__c;
Device.shipping_city                     = Adds.city__c;
Device.shipping_state                    = Adds.state__c;
Device.shipping_postal_code              = Adds.Zip_Postal_Code__c;
Device.shipping_country                  = Adds.country__c;
}
Device.shipping_method                   =dev.Shipping_Method__c;
Device.Return_Tracking_Number            =dev.Return_Tracking_Number__c;
Device.Device_ID                         =dev.Device_ID_s__c;
Device.Return_Required                   =dev.Return_Required__c;

JSONGenerator gen = JSON.createGenerator(true);
gen.writeStartObject();
if(Device.device_type != null)
{
gen.writeStringField('device_type',Device.device_type );
}
if(Device.requester_name != null)
{
gen.writeStringField('requester_name',Device.requester_name );
}
if(Device.requester_email != null)
{
gen.writeStringField('requester_email',Device.requester_email );
}
if(Device.merchant_contact_first_name != null)
{
gen.writeStringField('merchant_contact_first_name',Device.merchant_contact_first_name );
}
if(Device.merchant_contact_last_name != null)
{
gen.writeStringField('merchant_contact_last_name', Device.merchant_contact_last_name );
}
if(Device.account_id != null)
{
gen.writeIdField('account_id',Device.account_id );
}
if(Device.account_name != null)
{
gen.writeStringField('account_name',Device.account_name );
}
if(Device.opportunity_id != null)
{
gen.writeIdField('opportunity_id',Device.opportunity_id );
}
if(Device.opportunity_record_type != null)
{
gen.writeStringField('opportunity_record_type',Device.opportunity_record_type );
}
if(Device.feature_date != null)
{
gen.writedateField('feature_date',Device.feature_date );
}
if(Device.expiration_date != null)
{
gen.writeStringField('expiration_date',Device.expiration_date );
}
if(Device.request_date != null)
{
gen.writedateField('request_date',Device.request_date );
}
if(Device.approval_date != null)
{
gen.writedateField('approval_date', Device.approval_date );
}
if(Device.device_request_id != null)
{
gen.writeIdField('device_request_id',Device.device_request_id );
}
if(Device.device_request_name != null)
{
gen.writeStringField('device_request_name',Device.device_request_name );
}
if(Device.device_count != null)
{
gen.writeNumberField('device_count',Device.device_count );
}
if(Device.merchant_phone != null)
{
gen.writeStringField('merchant_phone',Device.merchant_phone );
}
if(Device.merchant_email != null)
{
gen.writeStringField('merchant_email',Device.merchant_email );
}
if(Device.shipping_address_1 != null)
{
gen.writeStringField('shipping_address_1',Device.shipping_address_1 );
}
if(Device.shipping_city != null)
{
gen.writeStringField('shipping_city',Device.shipping_city );
}
if(Device.shipping_state != null)
{
gen.writeStringField('shipping_state',Device.shipping_state );
}
if(Device.shipping_postal_code != null)
{
gen.writeStringField('shipping_postal_code',Device.shipping_postal_code );
}
if(Device.shipping_country != null)
{
gen.writeStringField('shipping_country',Device.shipping_country );
}
if(Device.shipping_method != null)
{
gen.writeStringField('shipping_method',Device.shipping_method );
}
if(Device.Return_Tracking_Number != null)
{
gen.writeStringField('return_tracking_number',Device.Return_Tracking_Number );
}
if(Device.Device_ID != null)
{
gen.writeStringField('device_id',Device.Device_ID );
}
if(Device.Return_Required != null)
{
gen.writeStringField('return_required',Device.Return_Required);
}
gen.writeEndObject();
String pretty = gen.getAsString();
return pretty;

}
public class Request
    {
    public string  device_type{get;set;}
    public string  requester_name{get;set;}
    public string  requester_email{get;set;}
    public string  merchant_contact_first_name{get;set;}
    public string  merchant_contact_last_name{get;set;}
    public string  merchant_contact_name{get;set;}
    public Id      account_id{get;set;}
    public string  account_name{get;set;}
    public Id      opportunity_id{get;set;}
    public string  opportunity_record_type{get;set;}
    public date    feature_date{get;set;}
    public string  expiration_date{get;set;}
    public date    request_date{get;set;}
    public date    approval_date{get;set;}
    public Id      device_request_id{get;set;}
    public string  device_request_name{get;set;}
    public decimal device_count{get;set;}
    public string  merchant_phone{get;set;}
    public string  merchant_email{get;set;}
    public string  shipping_address_1{get;set;}
    public string  shipping_address_2{get;set;}
    public string  shipping_city{get;set;}
    public string  shipping_state{get;set;}
    public string  shipping_postal_code{get;set;}
    public string  shipping_country{get;set;}
    public string  shipping_method{get;set;}
    public string  Return_Tracking_Number{get;set;}
    public string  Device_ID{get;set;}
    public string  Return_Required{get;set;}
    }
@Istest
public static void testmethod1()
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
device_request__c device2 = new device_request__c();
device2.device_type__c = 'iPhone ($400)';
device2.number_of_devices__c = 1;
device2.Are_Devices_Required_to_Close_Deal__c    = 'yes';
device2.Is_WiFi_available_at_Each_Location__c    = 'yes';
device2.Use_Alternate_Address__c                 = false;
device2.Shipping_Address__c                      = add.Id;
Device2.Opportunity__c                           = o.Id;
Insert Device2;
Test.startTest();
DeviceRequestJSON.sendDeviceRequest(Device.Id);
DeviceRequestJSON.sendDeviceRequest(Device2.Id);
Test.stopTest();
system.assert(Device.Opportunity__c != null);
system.assert(DeviceRequestJSON.formatdevicereq(device ,o,acc,c,add) != null);
}    
}