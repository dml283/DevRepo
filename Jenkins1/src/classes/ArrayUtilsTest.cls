/*
 *
 * This isn't actually directly from apex-lang. It's trimmed down to just the
 * stuff we need because apex-lang in it's entirity is HUGE.
 *
*/


/* ============================================================
 * This code is part of the "apex-lang" open source project avaiable at:
 * 
 *      http://code.google.com/p/apex-lang/
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
@IsTest
private class ArrayUtilsTest {

    private static testmethod void testObjectToString(){ 
        //test: global static List<String> objectToString(List<Object> objectList){ 
        assertObjectToString(null, null);
        assertObjectToString(new List<Object>{}, new List<String>{});
        final String str1 = 'xyz';
        final String str2 = 'abc';
        assertObjectToString(new List<Object>{str1}, new List<String>{str1});
        assertObjectToString(new List<Object>{str1,str2}, new List<String>{str1,str2});
    }
    
    private static void assertObjectToString(List<Object> objectList, List<String> expected){
        ArrayUtils.assertArraysAreEqual(expected, ArrayUtils.objectToString(objectList));
    }

    private static testmethod void testIsEmpty(){
        //test: global static Boolean isEmpty(Object[] objectArray){
        String[] aNull = null;
        Account[] aNull2 = null;
        System.assertEquals(true,    ArrayUtils.isEmpty(aNull)); 
        System.assertEquals(true,    ArrayUtils.isEmpty(new String[]{})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new String[]{'a'})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new String[]{'a','b'})); 
        System.assertEquals(true,    ArrayUtils.isEmpty(new Integer[]{})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new Integer[]{1})); 
        System.assertEquals(false,    ArrayUtils.isEmpty(new Integer[]{1,2})); 
        System.assertEquals(true,    ArrayUtils.isEmpty(aNull2)); 
        System.assertEquals(true,    ArrayUtils.isEmpty(new Account[]{}));  
        System.assertEquals(false,    ArrayUtils.isEmpty(new Account[]{new Account(name='test')}));  
        System.assertEquals(true,    ArrayUtils.isEmpty(new Contact[]{}));  
        System.assertEquals(false,    ArrayUtils.isEmpty(new Contact[]{new Contact(lastname='test')})); 
        System.assertEquals(true,    ArrayUtils.isEmpty(new Integer[]{}));  
        System.assertEquals(false,    ArrayUtils.isEmpty(new Integer[]{1}));  
    }
    
    private static testmethod void testIsNotEmpty(){
        //test: global static Boolean isNotEmpty(Object[] objectArray){
        String[] aNull = null;
        Account[] aNull2 = null;
        System.assertEquals(false,    ArrayUtils.isNotEmpty(aNull)); 
        System.assertEquals(false,    ArrayUtils.isNotEmpty(new String[]{})); 
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new String[]{'a'})); 
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new String[]{'a','b'})); 
        System.assertEquals(false,    ArrayUtils.isNotEmpty(new Integer[]{})); 
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new Integer[]{1})); 
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new Integer[]{1,2})); 
        System.assertEquals(false,    ArrayUtils.isNotEmpty(aNull2)); 
        System.assertEquals(false,    ArrayUtils.isNotEmpty(new Account[]{}));  
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new Account[]{new Account(name='test')}));  
        System.assertEquals(false,    ArrayUtils.isNotEmpty(new Contact[]{}));  
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new Contact[]{new Contact(lastname='test')}));  
        System.assertEquals(false,    ArrayUtils.isNotEmpty(new Integer[]{}));  
        System.assertEquals(true,    ArrayUtils.isNotEmpty(new Integer[]{1}));  
    }
    
    private static testmethod void testToString(){
        List<Object> aList = null;
        ArrayUtils.toString(aList);
        aList = new List<Object>();
        ArrayUtils.toString(aList);
        aList.add(12);
        aList.add(15);
        ArrayUtils.toString(aList);
    }
        
}