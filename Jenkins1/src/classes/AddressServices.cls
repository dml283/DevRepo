public with sharing class AddressServices 
{
	public static Map<String, List<SObject>> assignZipCodeAndSubDivision(Map<String, List<SObject>> mapZipCodesToAddresses, String zipFieldName, String subDivFieldName)
	{
		
		if(mapZipCodesToAddresses.size() > 0)
		{
			//provide the set of qualified zip codes and retrieve the record IDs mapped by zip code string 
			Map<String, Zip_Code__c> mapZipCodeToZipRecord = ZipcodeServices.getZipCodeToZipRecordMap(mapZipCodesToAddresses.keySet());
			
			for(String zip: mapZipCodesToAddresses.keySet())
			{
				for(SObject sObj: mapZipCodesToAddresses.get(zip))
				{
					if(mapZipCodeToZipRecord.containsKey(zip))
					{
						sObj.put(zipFieldName, mapZipCodeToZipRecord.get(zip).ID) ;
						sObj.put(subDivFieldName, mapZipCodeToZipRecord.get(zip).Subdivision__c);
					}
					else
					{
						sObj.put(zipFieldName, null) ;
						sObj.put(subDivFieldName, null);
					}
				}
			}
		}
		
		return mapZipCodesToAddresses;
	}
	
	public static Map<String, List<SObject>> getQualifiedZipCodesToAddressObjectMap(List<SObject> newList, List<SObject> oldList, String zipFieldName, String stateFieldName)
	{
		Integer x= 0;
		Map<String, List<SObject>> mapZipCodesToAddresses = new Map<String, List<SObject>>(); 
		for(SObject sObj: newList)
		{
			if(oldList == null || (oldList != null && sObj.get(zipFieldName) != oldList[x].get(zipFieldName)))
			{
				String zip = ZipCodeServices.getStandardizedZipCodeByState(String.valueOf(sObj.get(zipFieldName)), String.valueOf(sObj.get(stateFieldName)));
				
				List<SObject> addList = new List<SObject>();
				
				if(mapZipCodesToAddresses.containsKey(zip))
					addList = mapZipCodesToAddresses.get(zip);
				
				addList.add(sObj);
				
				mapZipCodesToAddresses.put(zip, addList);
			}
			x++;
		}
		return mapZipCodesToAddresses;
	}
}