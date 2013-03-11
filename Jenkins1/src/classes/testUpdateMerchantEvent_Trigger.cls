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
private class testUpdateMerchantEvent_Trigger {

    static testMethod void myUnitTest() {
    
      Profile p = [select id from profile where name='System Administrator'];
                        User u = new User(alias = 'standt', email='standarduser@groupon.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id, phone = '303-933-1414', 
                        timezonesidkey='America/Los_Angeles', username='UpdateMerchantEventTest@groupon.com');
                        insert u;
                        
      Division__c D = new Division__c(name='Test Division', State__c='IL');
      insert D;
      Zip_Code__c Z = new Zip_Code__c(name='60642', Division__c= D.id);
      insert Z;
      Zip_Code__c Z2 = new Zip_Code__c(name='V7T', Division__c= D.id);
      insert Z2;
        
      Lead L = new Lead (Category__c='B2B', Division__c = D.id, LastName = 'Forester',Company = 'Bryces Fried Sandwiches', country = 'US' , Status = 'Uncontacted', PostalCode = '60642');
      insert l;
      l.country = 'ca';
      l.postalcode = 'v7t345v';
      update l;
      
      Account A = new Account (name = 'dynamicZipTest' + system.now(), ownerid = u.id, now_category__c = 'Food & Drink');
      insert a;
      
      Contact c = new Contact(accountId = a.id,firstName='Matt',lastName='Koss');
      insert c;
      
      Merchant_Addresses__c ma = new Merchant_Addresses__c (country__c = 'CA', Zip_Postal_Code__c = 'v7twerwe', account__c = a.id);
      insert ma;
      ma.country__c = 'US';
      ma.zip_postal_code__c = '65738';
      update ma;  
      
      Reviews__c rev = new Reviews__c (Type__c = 'Rating', Source__c = 'Yelp', lead__c = l.id);
      insert rev;
      rev.Rating__c = 9;
      rev.Max_Possible_Rating__c = 10;
      rev.Number_of_Ratings__c = 1000;
      rev.account__c = a.id;
      update rev;
      
      Merchant_Events__c me = new Merchant_Events__c (Lead__c = l.id);
      insert me;
      me.Account__c = a.id;
      update me;
      
      Database.LeadConvert lc = new database.LeadConvert();
      lc.setLeadId(l.id);
      lc.setAccountId(a.id);
      lc.setContactId(c.id);
      lc.setOverwriteLeadSource(false);
      lc.setSendNotificationEmail(false);
      lc.setConvertedStatus('Prospecting');
      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());
    }
}