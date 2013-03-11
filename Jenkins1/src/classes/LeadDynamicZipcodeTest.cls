@isTest
private class LeadDynamicZipcodeTest {

  static Zip_Code__c usZipCode;
  static Zip_Code__c caZipCode;

  static {
    GrouponTestUtil testData = new GrouponTestUtil();

    Division__c division = testData.createDivision();
    insert division;

    Subdivision__c subdivision = testData.createSubDiv();
    subdivision.Division__c = division.Id;
    insert subdivision;

    caZipCode = testData.createZipCode(division, subdivision);
    caZipCode.Name = 'V7T';
    insert caZipCode;

    usZipCode = testData.createZipCode(division, subdivision);
    usZipCode.Name = '60642';
    insert usZipCode;
  }

  static Lead refreshLead(Lead lead) {
    return [SELECT Id, Dynamic_Division__c, Subdivision_Dynamic__c, Division__c, Now_Zip_Code__c FROM Lead WHERE Id = :lead.Id];
  }

  static void assert(Zip_Code__c zipCode, Lead lead) {
    lead = refreshLead(lead);

    System.assertEquals(zipCode.Division__c, lead.Dynamic_Division__c);
    System.assertEquals(zipCode.Subdivision__c, lead.Subdivision_Dynamic__c);
    System.assertEquals(zipCode.Id, lead.Now_Zip_Code__c);

    Division__c division = [SELECT Id, Name FROM Division__c WHERE Id = :zipCode.Division__c];
    System.assertEquals(division.Name, lead.Division__c);
  }

  static testmethod void all_zip_formats() {
    Lead usLeadShort = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'US', PostalCode = '60642');
    Lead usLeadLong = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'US', PostalCode = '60642-1234');

    Lead caLeadShort = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'CA', PostalCode = 'v7t');
    Lead caLeadLong = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'CA', PostalCode = 'v7t 123');

    Test.startTest();    
    insert new List<Lead>{usLeadShort, usLeadLong, caLeadShort, caLeadLong};
    Test.stopTest();    

    assert(usZipCode, usLeadShort);
    assert(usZipCode, usLeadLong);
    assert(caZipCode, caLeadShort);
    assert(caZipCode, caLeadLong);
  }

  static testmethod void lookups_only_set_when_changing_PostalCode() {

    Lead lead = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'US', PostalCode = '60642');
    insert lead;

    Division__c otherDivision = new Division__c(name='Other Test Division', State__c='AR');
    insert otherDivision;    

    lead.LastName = 'Forest';
    lead.Dynamic_Division__c = otherDivision.Id;

    Test.startTest();
    update lead;
    Test.stopTest();

    lead = refreshLead(lead);

    System.assertEquals(otherDivision.Id, lead.Dynamic_Division__c);
  }

  static testmethod void lookups_not_set_when_missing_Zip_Code_objects() {
    Lead lead = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'US', PostalCode = '72714');

    Test.startTest();    
    insert lead;    
    Test.stopTest();    

    lead = refreshLead(lead);

    System.assertEquals(null, lead.Dynamic_Division__c);
    System.assertEquals(null, lead.Subdivision_Dynamic__c);
    System.assertEquals(null, lead.Now_Zip_Code__c);
  }

  static testmethod void lookups_removed_when_missing_Zip_Code_objects() {

    Lead lead = new Lead (Category__c='B2B', LastName = 'Forester',Company = 'Bryces Fried Sandwiches', Status = 'Uncontacted', Country = 'US', PostalCode = '60642');
    insert lead;

    lead.PostalCode = '72714';

    Test.startTest();    
    update lead;    
    Test.stopTest();    

    lead = refreshLead(lead);

    System.assertEquals(null, lead.Dynamic_Division__c);
    System.assertEquals(null, lead.Subdivision_Dynamic__c);
    System.assertEquals(null, lead.Now_Zip_Code__c);
  }

}