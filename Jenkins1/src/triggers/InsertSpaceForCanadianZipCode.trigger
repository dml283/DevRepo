trigger InsertSpaceForCanadianZipCode on Merchant_Addresses__c (before insert, before update) {
	/*
  for(Merchant_Addresses__c ma: trigger.new) {
    if(ma.zip_Postal_code__c != null) {
      if((ma.Country__c == 'Canada' || ma.Country__c == 'CA') && ma.zip_postal_code__c.length() == 6) {
        String CAZip = ma.Zip_Postal_Code__c;
        String CAZipFirstThree = CAZip.substring(0,3);
        String CAZipLastThree = CAZip.substring(3,6);
        String CAZipWithSpace = CAZipFirstThree + ' ' + CAZipLastThree;
        
        ma.Zip_Postal_Code__c = CAZipWithSpace;
      }
    }
  }
  */
}