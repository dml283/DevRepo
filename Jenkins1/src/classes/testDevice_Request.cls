@istest   
 public class testDevice_Request
 {
     static testMethod void testdevicereq()
         {
            account a = new account();
                         a.name = 'testDeviceREq' + system.now();
                         a.billingcountry = 'CA';
                         a.Now_Category__c = 'Restaurants';
                         insert a;
            //grouponnow__c grpnow = [select id from grouponnow__c where id!=null limit 1];
            grouponnow__c grpnow = new grouponnow__c();
            grpnow.account_name__c = a.id;
            insert grpnow;
             
            opportunity o = new opportunity();
                         o.name = 'test oppty';
                         o.StageName = 'Prospecting';
                         o.CloseDate = date.today();
                         o.Deal_Strengh__c = 'Rep Getting Info';
                         o.Feature_Date__c = date.newinstance(2011, 7, 15);
                         o.AccountId = a.Id;
                         insert o;             
           //Address__c add = [select id from Address__c where id != null and Country__c ='CA' limit 1];
           Address__c addy = new address__c();
           addy.opportunity__c = o.id;
           insert addy;
                 
           device_request__c devreq = new device_request__c(
           Use_Alternate_Address__c = true,
           Shipping_Street__c = 'test',
           Shipping_City__c = 'test',
           Shipping_State_Province__c = 'CA',
           Shipping_Zip_Postal_Code__c = '12345',
           Shipping_Country__c ='CA',
           Opportunity__c = o.Id,
           Device_Type__c = 'iPhone (4S) + Linea ($550)',
           Number_of_Devices__c =1,
           Are_Devices_Required_to_Close_Deal__c = 'Yes',
           Is_WiFi_available_at_Each_Location__c = 'Yes'
           );
           insert devreq;
            device_request__c devreqgrouponow = new device_request__c(
           Use_Alternate_Address__c = true,
           Shipping_Street__c = 'test',
           Shipping_City__c = 'test',
           Shipping_State_Province__c = 'CA',
           Shipping_Zip_Postal_Code__c = '12345',
           Shipping_Country__c ='CA',
           groupon_now__c = grpnow.Id,
           Device_Type__c = 'iPhone (4S) + Linea ($550)',
           Number_of_Devices__c =1,
           Are_Devices_Required_to_Close_Deal__c = 'Yes',
           Is_WiFi_available_at_Each_Location__c = 'Yes'
           );
           insert devreqgrouponow;
         }
 }