trigger trigger_Device_Request_mobile_sense_Integration on Device_Request__c (after update) 
{
System.debug('\n\nbatchapexstop.stopbatchapex  ='+batchapexstop.stopbatchapex+'\n\n');
//for the device request in current context find out the approval status.    
     if(batchapexstop.stopbatchapex ==false)
     {
        system.debug('##############ONLY RUN ME ONCE################');
            for(device_request__c d : trigger.new)
            {
                if(Trigger.newMap.get(d.Id).approval_status__c == Trigger.oldMap.get(d.Id).approval_status__c)
                //if(Trigger.new.approval_status__c == Trigger.old[0].approval_status__c)
                {
                 system.debug('$$$$ trigger ' + Trigger.newMap.get(d.Id).approval_status__c + Trigger.oldMap.get(d.Id).approval_status__c);
                //Do not process since the status are going to be the same or going to be approved
                }
                else
                {
                //If the approval status == 'Approved' then send the data to the 3rd party vendor through the HTTP Post method in the Devicerequest class.
                    if(Trigger.newMap.get(d.Id).approval_status__c == 'Approved' && Trigger.newMap.get(d.Id).Approved_flag__c)
                    {
                    system.debug('!!!! Calling Device request class');
                       
                          DeviceRequestJSON.sendDeviceRequest(d.Id);                                     
                    }
                }
            }
             batchapexstop.stopbatchapex =true;
    }
}