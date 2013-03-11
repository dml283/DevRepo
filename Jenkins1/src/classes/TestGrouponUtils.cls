@isTest
class TestGrouponUtils 
{
	static testMethod void testIsNullOrEmpty_ReturnsBoolean()
    {
    	//isNullOrEmpty returns false on a null string or an empty string. true otherwise
        System.assert(GrouponUtils.isNullOrEmpty(null));
        System.assert(GrouponUtils.isNullOrEmpty(''));
        System.assert(!GrouponUtils.isNullOrEmpty('hello'));
    }
    
    static testMethod void testGetFormattedDMLErrorMessageForSameSObject()
    {
        System.assertEquals(GrouponUtils.getFormattedDMLErrorMessageForSameSObject(null), '');
        
        Account a = TestUtil.createAccount('ut acc1', false);
        a.BillingCountry = '\ntwinkle twinkle little star. \nhow i wonder what you are';
        a.BillingCountry += '\nup above the world so high \n like a diamond in the sky!';
        try
        {
            insert a;
        }
        catch(DMLException dmle)
        {
            String err = GrouponUtils.getFormattedDMLErrorMessageForSameSObject(dmle);
            System.assert(err.contains('Billing Country: data value too large'));
        }
        
    }
    
    static testMethod void testGetCSVFromSet()
    {
    	Set<String> testSet = new Set<String>();
    	//test with null and empty strings
    	System.assertEquals(GrouponUtils.getCSVFromSet(null, null), '');
    	System.assertEquals(GrouponUtils.getCSVFromSet(testSet, null), '');
    	System.assertEquals(GrouponUtils.getCSVFromSet(testSet, ','), '');
    	
    	//test with a set with single value and different delimiters
    	testSet.add('value1');
    	System.assertEquals(GrouponUtils.getCSVFromSet(testSet, null), 'value1');
    	System.assertEquals(GrouponUtils.getCSVFromSet(testSet, ''), 'value1');
    	System.assertEquals(GrouponUtils.getCSVFromSet(testSet, ','), 'value1');
    	System.assertEquals(GrouponUtils.getCSVFromSet(testSet, 'somebigvalue'), 'value1');
    	
    	//now play with multiple values in set
    	testSet.add('value2');
    	String testString = GrouponUtils.getCSVFromSet(testSet, ',');
    	System.assert(testString == 'value1,value2' || testString == 'value2,vaule1' );
    	
    }
    
    static testMethod void testGetCSVFromList()
    {
    	List<String> testSet = new List<String>();
    	//test with null and empty strings
    	System.assertEquals(GrouponUtils.getCSVFromList(null, null), '');
    	System.assertEquals(GrouponUtils.getCSVFromList(testSet, null), '');
    	System.assertEquals(GrouponUtils.getCSVFromList(testSet, ','), '');
    	
    	//test with a set with single value and different delimiters
    	testSet.add('value1');
    	System.assertEquals(GrouponUtils.getCSVFromList(testSet, null), 'value1');
    	System.assertEquals(GrouponUtils.getCSVFromList(testSet, ''), 'value1');
    	System.assertEquals(GrouponUtils.getCSVFromList(testSet, ','), 'value1');
    	System.assertEquals(GrouponUtils.getCSVFromList(testSet, 'somebigvalue'), 'value1');
    	
    	//now play with multiple values in set
    	testSet.add('value2');
    	String testString = GrouponUtils.getCSVFromList(testSet, ',');
    	System.assert(testString == 'value1,value2' || testString == 'value2,vaule1' );
    	
    }
}