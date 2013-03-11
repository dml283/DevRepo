trigger ACHcheckSum on Account (before update, before insert) {
    //Valid_Routing__c
    //routing_number__c
    /*
    Trigger: ACH Check Sum on Account
    Author: Chris Bland
    Purpose: To do a Check sum to verify valid banking information was entered
    v1.0
     
    Version History:
    1.5 - Updated to remove Transit to Routing function
    1.4 - Updated to set N/A based on Payment Preference field (JJ 10.18.2011)
    1.3 - Added "N/A" values and Yes, No to run workflow rules from
    1.2 - Updated to use Routing_Number_enc__c for deployment
    1.1 - != Null exception to routing number
    1.0 - Initial Build    
    Associated Test Class: testACHcheckSum
    
    Last Updated: 10/12/2011
    
    */

    //Declare the Variables we will use for the calulations

    for(Account a : trigger.new)
        {
            if(a.Payment_Preference__c!='ACH (Direct Deposit)')
                {
                    a.Valid_Routing__c = 'N/A';
                }
                else
                    {
                    a.Valid_Routing__c = 'N/A';
                    if(a.Payment_Preference__c=='ACH (Direct Deposit)' && a.TransitNumber__c!=null && a.BillingCountry=='CA')
                                {
                                    string newRouting='0';
                                    a.Valid_Routing__c = 'N/A';
                                    string rn = string.valueOf(a.TransitNumber__c);
                                    rn=rn.replaceAll(' ','');
                                    rn=rn.replaceAll('-','');
                                    if(rn.length()==8)
                                        {
                                            string var1=string.valueOf(rn.substring(0,1));
                                            string var2=string.valueOf(rn.substring(1,2));
                                            string var3=string.valueOf(rn.substring(2,3));
                                            string var4=string.valueOf(rn.substring(3,4));
                                            string var5=string.valueOf(rn.substring(4,5));
                                            string var6=string.valueOf(rn.substring(5,6));
                                            string var7=string.valueOf(rn.substring(6,7));
                                            string var8=string.valueOf(rn.substring(7,8));
                                            newRouting+=var6;
                                            newRouting+=var7;
                                            newRouting+=var8;
                                            newRouting+=var1;
                                            newRouting+=var2;
                                            newRouting+=var3;
                                            newRouting+=var4;
                                            newRouting+=var5;
                                            a.Routing_Number_enc__c = newRouting;
                                        }   
                                } 
                    }      
        }
    
    for(Account a : trigger.new)
        {
            boolean ValidAch=false;
            system.debug('---------------before first If--- '+a.routing_number_enc__c);
            
            if(a.Payment_Preference__c!='ACH (Direct Deposit)')
                {
                    a.Valid_Routing__c = 'N/A';
                }else if(a.Payment_Preference__c=='ACH (Direct Deposit)' && a.TransitNumber__c==null && a.routing_number_enc__c !=null && a.BillingCountry=='US')      
                                 {
                                 
                                     string rn = '-';
                                     if(a.Routing_Number_enc__c!=null)
                                         {
                                             rn = string.valueOf(a.Routing_Number_enc__c);
                                             system.debug('---------------Inside 2nd If--- '+a.routing_number_enc__c);
 
                                         }        
                                     if(rn.length()==9)
                                        {
                                            integer var1=integer.valueOf(rn.substring(0,1));
                                            integer var2=integer.valueOf(rn.substring(1,2));
                                            integer var3=integer.valueOf(rn.substring(2,3));
                                            integer var4=integer.valueOf(rn.substring(3,4));
                                            integer var5=integer.valueOf(rn.substring(4,5));
                                            integer var6=integer.valueOf(rn.substring(5,6));
                                            integer var7=integer.valueOf(rn.substring(6,7));
                                            integer var8=integer.valueOf(rn.substring(7,8));
                                            integer var9=integer.valueOf(rn.substring(8,9));
                                            
                                            integer CheckSum=((var1*3)+(var2*7)+(var3*1)+(var4*3)+(var5*7)+(var6*1)+(var7*3)+(var8*7)+(var9*1));
                                
                                            integer remainder = math.mod(checksum,10);
                                            if(checksum != 0 && remainder==0 && integer.valueOf(rn.substring(0,1))!=5)
                                                {
                                                    ValidAch=true;
                                                }

                                        }
                                   }    
                 if(validACH==true)
                      {
                        a.Valid_routing__c='Yes';
                      }else if(validACH==false && a.Payment_Preference__c=='ACH (Direct Deposit)' && a.routing_number_enc__c !=''&& a.billingcountry=='US')
                           {
                                a.Valid_routing__c='No';
                           }else
                                {
                                    a.Valid_Routing__c = 'N/A';
                                }
        }     

}