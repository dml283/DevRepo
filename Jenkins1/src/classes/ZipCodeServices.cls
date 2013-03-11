public with sharing class ZipCodeServices 
{
	public static Map<String, Zip_Code__c> getZipCodeToZipRecordMap(Set<String> zipCodes)
	{
		Map<String, Zip_Code__c> mapZipCodeToZipRecord = new Map<String, Zip_Code__c>();
		if(zipCodes != null && zipCodes.size() > 0)
		{
			for(Zip_Code__c zc: [Select ID, Name, Subdivision__c, Subdivision__r.name From Zip_Code__c Where Name IN: zipCodes])
				mapZipCodeToZipRecord.put(zc.Name, zc);
		}
		
		return mapZipCodeToZipRecord;
	}
	
	public static Map<String, Zip_Code__c> getZipCodeToZipRecordMapFromList(List<String> zipCodes)
	{
		Map<String, Zip_Code__c> mapZipCodeToZipRecord = new Map<String, Zip_Code__c>();
		if(zipCodes != null && zipCodes.size() > 0)
		{
			Set<String> zipCodeSet = new Set<String>();
			zipCodeSet.addAll(zipCodes);
			
			mapZipCodeToZipRecord = getZipCodeToZipRecordMap(zipCodeSet);
		}
		return mapZipCodeToZipRecord;
	}
	
	public static String getStandardizedZipCodeByCountry(String zipCode, String country)
	{
		String correctedZipCode = '';
		if(zipCode != null && country != null)
		{
			if(country == Constants.COUNTRY_US && zipCode.length() >= 5)
				correctedZipCode = zipCode.trim().subString(0,5);
			else if(country == Constants.COUNTRY_CA && zipCode.length() >= 3)
				correctedZipCode = zipCode.trim().subString(0,3);
			else
				correctedZipCode = zipCode;	
		}
		
		return correctedZipCode;
	}
	
	public static String getStandardizedZipCodeByState(String zipCode, String state)
	{
		String correctedZipCode = '';
		if(zipCode != null && state != null)
		{
			if(CAStates.contains(state) && zipCode.length() >= 3)
				correctedZipCode = zipCode.trim().subString(0,3);
			else
			{
				if(zipCode.length() >= 5)
					correctedZipCode = zipCode.trim().subString(0,5);
				else
					correctedZipCode = zipCode;
			}	
		}
		
		return correctedZipCode;
	}
	
	private static Set<String> CAStates
	{
		get
		{
			if(CAStates == null) 
			{
				CAStates = new Set<String>();
				CAStates.add(Constants.STATE_AB);
				CAStates.add(Constants.STATE_BC);
				CAStates.add(Constants.STATE_MB);
				CAStates.add(Constants.STATE_NB);
				CAStates.add(Constants.STATE_NL);
				CAStates.add(Constants.STATE_NT);
				CAStates.add(Constants.STATE_NS);
				CAStates.add(Constants.STATE_NU);
				CAStates.add(Constants.STATE_ON);
				CAStates.add(Constants.STATE_PC);
				CAStates.add(Constants.STATE_QC);
				CAStates.add(Constants.STATE_SK);
				CAStates.add(Constants.STATE_YT);
			}
			
			return CAStates;
		}
		
		set;
	}
	
	
	
	
}