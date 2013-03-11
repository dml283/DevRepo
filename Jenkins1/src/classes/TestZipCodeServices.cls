@isTest

class TestZipCodeServices 
{
	static testMethod void testGetZipCodeToZipRecordMap_FromSet()
	{
		Zip_Code__c zc1 = TestUtil.createZipCode('60651', true);
		Zip_Code__c zc2 = TestUtil.createZipCode('60652', true);
		
		
		System.assertNotEquals(ZipCodeServices.getZipCodeToZipRecordMap(null), null);
		System.assertEquals(ZipCodeServices.getZipCodeToZipRecordMap(null).size() , 0);
		
		Set<String> emptySet = new Set<String>();
		System.assertNotEquals(ZipCodeServices.getZipCodeToZipRecordMap(emptySet), null);
		System.assertEquals(ZipCodeServices.getZipCodeToZipRecordMap(emptySet).size() , 0);
		
		Set<String> myZips = new Set<String>();
		myZips.add(zc1.Name); myZips.add(zc2.Name);
		
		Map<String, Zip_Code__c> resultMap = ZipCodeServices.getZipCodeToZipRecordMap(myZips);
		System.assertNotEquals(resultMap, null);
		System.assertEquals(resultMap.size() , 2);
		System.assertEquals(resultMap.get('60651').ID, zc1.ID);
		System.assertEquals(resultMap.get('60652').ID, zc2.ID);
	}
	
	static testMethod void testGetZipCodeToZipRecordMap_FromList()
	{
		Zip_Code__c zc1 = TestUtil.createZipCode('60651', true);
		Zip_Code__c zc2 = TestUtil.createZipCode('60652', true);
		
		
		System.assertNotEquals(ZipCodeServices.getZipCodeToZipRecordMapFromList(null), null);
		System.assertEquals(ZipCodeServices.getZipCodeToZipRecordMapFromList(null).size() , 0);
		
		List<String> emptyList = new List<String>();
		System.assertNotEquals(ZipCodeServices.getZipCodeToZipRecordMapFromList(emptyList), null);
		System.assertEquals(ZipCodeServices.getZipCodeToZipRecordMapFromList(emptyList).size() , 0);
		
		List<String> myZips = new List<String>();
		myZips.add(zc1.Name); myZips.add(zc2.Name);
		
		Map<String, Zip_Code__c> resultMap = ZipCodeServices.getZipCodeToZipRecordMapFromList(myZips);
		System.assertNotEquals(resultMap, null);
		System.assertEquals(resultMap.size() , 2);
		System.assertEquals(resultMap.get('60651').ID, zc1.ID);
		System.assertEquals(resultMap.get('60652').ID, zc2.ID);
	}
	
	static testMethod void testGetStandardizedZipByCountry()
	{
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry(null, null), '');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry('', null), '');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry(null, ''), '');
		
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry('60656323', 'garbage'), '60656323');
		
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry('606512', Constants.COUNTRY_US), '60651');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry('60651', Constants.COUNTRY_US), '60651');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry('606512', Constants.COUNTRY_CA), '606');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByCountry('606', Constants.COUNTRY_CA), '606');
	}
	
	static testMethod void testGetStandardizedZipByState()
	{
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState(null, null), '');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('', null), '');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState(null, ''), '');
		
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('60656323', 'garbage'), '60656');
		
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('606512', 'IL'), '60651');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('60651', 'IL'), '60651');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('6065', 'IL'), '6065');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('606512', Constants.STATE_BC), '606');
		System.assertEquals(ZipCodeServices.getStandardizedZipCodeByState('606', Constants.STATE_BC), '606');
	}
}