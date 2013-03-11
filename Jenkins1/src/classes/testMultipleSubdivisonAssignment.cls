/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testMultipleSubdivisonAssignment {

  static testMethod void mySubdivTest() {
      
    Profile p = [select id from profile where name='System Administrator'];
    User u = new User(alias = 'standt', email='standarduser@groupon.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='testMultipleSubdivisonAssignment@groupon.com');
          insert u;
    //run as user
    System.RunAs(u) {     
        
      batchapexstop.stopbatchapex =false;

      Subdivision__c s = new Subdivision__c();
      s.Name = 'Downtown - South(Chicago)';
      s.Is_Active__c = True;
      insert s;
          
      Subdivision__c canSubDiv = new Subdivision__c();
      canSubDiv.Name = 'Outskirts (Vancouver)';
      canSubDiv.Is_Active__c = True;
      insert canSubDiv;
          
      Zip_Code__c z = new Zip_Code__c();
      z.Name = '60601';
      z.Subdivision__c = s.Id;
      insert z;
          
      Zip_Code__c canPostZip = new Zip_Code__c();
      canPostZip.Name = 'Y1A 1A2';
      canPostZip.Subdivision__c = CanSubDiv.Id;
      insert canPostZip;
          
      Account a = new Account();
      a.Name = 'test acct';
      insert a;       
          
      Merchant_Addresses__c maddy = new Merchant_Addresses__c();
      maddy.Account__c = a.Id;
      maddy.Street_Line_1__c = '303 E Wacker Dr';
      maddy.Street_Line_2__c = '26th Floor';
      maddy.City__c = 'Chicago';
      maddy.State_Province__c = 'IL';
      maddy.Zip_Postal_Code__c = '60601';
      insert maddy;
          
      Merchant_Addresses__c merchAddyCA = new Merchant_Addresses__c();
      merchAddyCA.Account__c = a.Id;
      merchAddyCA.Street_Line_1__c = 'Canadian Test Street';
      merchAddyCA.Street_Line_2__c = 'Canadian Street Line 2';
      merchAddyCA.City__c = 'Vancouver';
      merchAddyCA.State_Province__c = 'BC';
      merchAddyCA.Zip_Postal_Code__c = 'Y1A 1A2';
      insert merchAddyCA;               
                         
      Opportunity o = new Opportunity();
      o.Name = 'test oppty';
      o.StageName = 'Prospecting';
      o.CloseDate = date.today();
      o.Deal_Strengh__c = 'Rep Getting Info';
      o.Feature_Date__c = date.newinstance(2011, 7, 15);
      o.AccountId = a.Id;
      o.Subdivision__c = 'Online/No Location';
      insert o;
      
      batchapexstop.stopbatchapex =false;
          
      Address__c addy = new Address__c();
      addy.Opportunity__c = o.Id;
      addy.Street_Line_1__c = '303 E Wacker Dr';
      addy.Street_Line_2__c = '26th Floor';
      addy.City__c = 'Chicago';
      addy.State__c = 'IL';
      addy.Zip_Postal_Code__c = '60601';
      insert addy;

      batchapexstop.stopbatchapex =false;
          
      maddy.Zip_Postal_Code__c = '60654';
      update maddy;
          
      MerchAddyCA.Zip_Postal_Code__c = 'Y1A 4A5';
      update MerchAddyCA;
      
      addy.State__c = 'BC';
      addy.Zip_Postal_Code__c = 'Y1A 1A2';
      update addy;
      
    }  
  }
}