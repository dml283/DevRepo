@isTest
private class TestRewardsOfferStatus {
//Waiting to Delete
/*
  static testMethod void rewardsOfferStatusAcct(){
    Set<String> statusStringSet = new Set<String>();
    List<Opportunity> oList = new List<Opportunity>();
    List <RecordType> rtList = [SELECT Id, Name FROM RecordType where Name = 'Rewards'];
    String rtId = '';
    Account a;
    Opportunity o;

    for(recordType rt : rtList){
      if(rt.name == 'Rewards'){
        rtId = rt.id;
      }
    }
            
    a = TestUtil.createAccount('Test');
    insert a;
                        
    o = TestUtil.createDeal(a);
    o.Division__c = 'Training';
    o.RecordTypeId = rtId;
    o.Stagename = 'Not Contacted';
    insert o;

    oList = [SELECT Id, AccountId, StageName, Feature_date__c, Feature_end_date__c FROM Opportunity WHERE AccountId =: a.Id];
            
    Test.startTest();
            
    rewardsOfferStatus ros = new rewardsOfferStatus(a, oList);
    string setOfferStatus = '';
    setOfferStatus = ros.offerStatus.get(o.AccountId);
    string returnOfferStatus = '';

    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Not Contacted', returnOfferStatus);
            
    o.Stagename = 'Rejected';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Rejected', returnOfferStatus);
            
    o.StageName = 'Closed Lost';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Closed Lost', returnOfferStatus);
            
    o.stagename = 'Closed Expired';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Closed Expired', returnOfferStatus);
            
    o.stagename = 'Contacted';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Contacted', returnOfferStatus);
            
    o.stagename = 'In Negotiations';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('In Negotiations', returnOfferStatus);
            
    o.stagename = 'Contract Sent';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Contract Sent', returnOfferStatus);
            
    o.stagename = 'Closed Won';
    update o;
    statusStringSet.add(o.Stagename);
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Closed Won', returnOfferStatus);
            
    o.feature_date__c = system.today()-10;
    o.feature_end_date__c = system.today()-5;
    update o;
    statusStringSet.add('Pulled');
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Pulled', returnOfferStatus);
            
    o.feature_date__c = system.today() -1;
    o.feature_end_date__c = system.today() +5;
    update o;
    statusStringSet.add('Live');
    returnOfferStatus = ros.getOfferStatus(statusStringSet);
    System.assertEquals('Live', returnOfferStatus);      
            
    Test.stopTest();    
  }
*/
}