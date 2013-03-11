public class TargetZips {
public string zip {get;set;}
public id ThisId; 


public TargetZips(ApexPages.StandardController ctrl) 
        {
             ThisId = ctrl.getID();
        }

public PageReference deleteTargetZip()
        {
            string IdToDelete = ApexPages.currentPage().getParameters().get('ZipIdToDelete');
            Target_Zip__c z = new Target_Zip__c(id = idToDelete);
            try {delete z;} 
                        catch (DMLException e) 
                            {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Salesforce@groupon.com if you beleive this is in error'));
                            }
            return null;              
        }
public PageReference addZip()
    {
        if(Zip!='')
            {
                Target_Zip__c z = new Target_Zip__c (opportunity__c = ThisId, Target_Zip_Code__c = zip);
                     try {insert z;} 
                        catch (DMLException e) 
                            {
                               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Salesforce@groupon.com if you beleive this is in error'));
                               return null;
                            }
            }        
           zip=null;
           return null;     
                
    }
list<target_zip__c> allZips;
public list<Target_Zip__c> getAllZips()
    {
        system.debug('--------------------Ok we got the this-----');
         AllZips = [select id, Target_Zip_Code__c, opportunity__c from Target_Zip__c where opportunity__c = :ThisId AND Target_zip_code__c !=null];
         return AllZips;
    }        
private static testMethod void  ZipTest()
    {    Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id,
                        timezonesidkey='America/Los_Angeles', username='standarduser@groupon.com');
                        insert u;
                //run as user
                System.RunAs(u)
                    {   
                         opportunity o = [select id from opportunity limit 1];
                         PageReference pageRef = Page.TargetZip;
                            Test.setCurrentPageReference(pageRef);
                         ApexPages.currentPage().getParameters().put('Id', o.id);
                         ApexPages.StandardController sc = new ApexPages.standardController(o);
                         TargetZips myPageCon = new TargetZips(sc);
                         
                         myPageCon.addZip();
                         Target_Zip__c z = [select id from Target_Zip__c where opportunity__c = :o.id];
                         ApexPages.currentPage().getParameters().put('ZipIdToDelete', z.id);
                         myPageCon.deleteTargetZip();
                         list<target_zip__c> allZips = myPageCon.getAllZips();
                         
                    }     
    }
}