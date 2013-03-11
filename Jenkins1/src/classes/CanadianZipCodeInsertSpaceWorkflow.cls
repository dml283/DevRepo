public with sharing class CanadianZipCodeInsertSpaceWorkflow implements TriggerWorkflow
{
	List<Merchant_Addresses__c> newList, oldList;
	
	public CanadianZipCodeInsertSpaceWorkflow(List<Merchant_Addresses__c> newList, List<Merchant_Addresses__c> oldList)
	{
		this.newList = newList;	
		this.oldList = oldList;
	}
	
	private static Boolean hasExecuted{ get{if(hasExecuted == null) hasExecuted = false; return hasExecuted;} private set;}
	public void execute()
	{
		if(!hasExecuted)
		{
			formatCanadianZipCodes();
		}
		
		hasExecuted = true;
	}
	
	private void formatCanadianZipCodes()
	{
		integer x= 0;
		for(Merchant_Addresses__c ma: newList)
		{
			if( (oldList == null || (ma.Zip_Postal_Code__c != oldList[x].Zip_Postal_Code__c)) &&
				ma.Zip_Postal_code__c != null && 
				ma.Zip_Postal_Code__c.length() == 6 && 
				(ma.Country__c == 'Canada' || ma.Country__c == Constants.COUNTRY_CA)
			)
			{
				
		      	String CAZip = ma.Zip_Postal_Code__c;
		      	String CAZipFirstThree = CAZip.substring(0,3);
		      	String CAZipLastThree = CAZip.substring(3,6);
		      	String CAZipWithSpace = CAZipFirstThree + ' ' + CAZipLastThree;
		      	
		      	ma.Zip_Postal_Code__c = CAZipWithSpace;
		    }
		}
	}
}