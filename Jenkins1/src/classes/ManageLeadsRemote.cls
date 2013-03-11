global with sharing class ManageLeadsRemote {
    @RemoteAction
    global static boolean updateMerchantProduct(String MerchantType, String recordID, String ProductLine) 
        {
        system.debug('------------------------DEBUG---if you can read this we got in to this fx');
            boolean updateCheck = false;
            string cp = ProductLine.replaceAll('\"','');
            if(MerchantType=='Account')
                {
                    update new Account(Id = recordID, CurrentProduct__c = cp);
                    updateCheck = true;
                }
            if(MerchantType=='Lead')
                {
                    update new lead(Id = recordID, CurrentProduct__c = cp);
                    updateCheck = true;
                }
            return updateCheck;
        }
        
    @RemoteAction
    global static sObject[] searchMerchants(String divisionName, string MerchantType, string cat, string zip, string CurrentProduct) 
        {    
            if(MerchantType == 'Account' && zip!='No Zip')
                {
                  return [select id, LastActivityDate, name, Most_Recent_Feature__c, Merchant_Value__c, Now_Deal_Owner__r.Name, CurrentProduct__c, Now_Zip_Code__r.Name, ownerid, owner.name, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Current_Product_Transfer_Date__c from Account where Division__r.name like :divisionName AND Now_Zip_Code__r.Name !=null AND Global_SFDC_Category__c = :cat AND Now_Zip_Code__r.Name =:zip  AND Now_Deal_Owner__r.Name !=null AND LastActivityDate!=null AND CurrentProduct__c = :CurrentProduct ORDER BY Merchant_Value__c asc];
                }else if(MerchantType == 'Account' && zip=='No Zip')
                    {
                      return [select id, LastActivityDate, name, Most_Recent_Feature__c, Merchant_Value__c, Now_Deal_Owner__r.Name, CurrentProduct__c, Now_Zip_Code__r.Name, ownerid, owner.name, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Current_Product_Transfer_Date__c from Account where Division__r.name like :divisionName AND Now_Zip_Code__r.Name !=null AND Global_SFDC_Category__c = :cat AND Now_Deal_Owner__r.Name !=null AND LastActivityDate!=null AND CurrentProduct__c = :CurrentProduct ORDER BY Merchant_Value__c asc];
                    }else if(MerchantType == 'Lead' && zip!='No Zip')
                        {
                          return [select id, company, LastActivityDate, NOW_Deal_Vetter__r.Name, Merchant_Value__c, Last_Activity_Date__c, name, CurrentProduct__c, Now_Zip_Code__r.Name, ownerid, owner.name, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Current_Product_Transfer_Date__c from Lead where Dynamic_Division__r.name like :divisionName AND isconverted = false AND Now_Zip_Code__r.Name !=null AND Global_SFDC_Category__c = :cat AND Now_Zip_Code__r.Name =:zip AND Now_Deal_Vetter__r.Name !=null AND LastActivityDate!=null AND CurrentProduct__c = :CurrentProduct ORDER BY Merchant_Value__c asc];
                        }else if(MerchantType == 'Lead' && zip=='No Zip')
                            {
                            return [select id, company, NOW_Deal_Vetter__r.Name, LastActivityDate, Merchant_Value__c, Last_Activity_Date__c, name, CurrentProduct__c, Now_Zip_Code__r.Name, ownerid, owner.name, Global_SFDC_Category__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Current_Product_Transfer_Date__c from Lead where Dynamic_Division__r.name like :divisionName AND isconverted = false AND Now_Zip_Code__r.Name !=null AND Global_SFDC_Category__c = :cat AND Now_Deal_Vetter__r.Name !=null AND LastActivityDate!=null  AND CurrentProduct__c = :CurrentProduct ORDER BY Merchant_Value__c asc];
                            }else
                                {
                                    return [select id, name, CurrentProduct__c, NOW_Deal_Vetter__c from Lead where Dynamic_Division__r.name like :divisionName limit 1];
                                }      
        }
   public List<String> GlobalCategories {
    get {
      if (GlobalCategories == null) {
 
        GlobalCategories = new List<String>();
        Schema.DescribeFieldResult field = lead.Global_SFDC_Category__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          GlobalCategories.add('\"'+f.getLabel()+'\"');
 
      }
      return GlobalCategories;          
    }
    set;
  }
        

}