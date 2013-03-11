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
private class StringUtilsTest {

    private static testmethod void testJoinArrayOneArg(){
        //test: global static String joinArray(Object[] objectArray) {
        assertJoinArrayOneArg(null, null);
        assertJoinArrayOneArg(new String[]{}, '');
        assertJoinArrayOneArg(new String[]{null}, '');
        assertJoinArrayOneArg(new String[]{'a', 'b', 'c'}, 'abc');
        assertJoinArrayOneArg(new String[]{null, '', 'a'}, 'a');
    }
    
    private static void assertJoinArrayOneArg(Object[] objectArray, String expected){
        String actual = StringUtils.joinArray(objectArray);
        System.assert(actual==expected, 'StringUtils.joinArray(\'' + ArrayUtils.toString(objectArray) + '\') returned \'' + actual + '\'; expected \'' + expected + '\'');
    }

    private static testmethod void testJoinArrayTwoArgs(){
        //test: global static String joinArray(Object[] objectArray, String separator) {
        assertJoinArrayTwoArgs(null, null, null);
        assertJoinArrayTwoArgs(new String[]{}, null, '');
        assertJoinArrayTwoArgs(new String[]{null}, null, '');
        assertJoinArrayTwoArgs(new String[]{'a', 'b', 'c'}, ';', 'a;b;c');
        assertJoinArrayTwoArgs(new String[]{'a', 'b', 'c'}, null, 'abc');
        assertJoinArrayTwoArgs(new String[]{null, '', 'a'}, ';', ';a');
    }
    
    private static void assertJoinArrayTwoArgs(Object[] objectArray, String separator, String expected){
        String actual = StringUtils.joinArray(objectArray,separator);
        System.assert(actual==expected, 'StringUtils.joinArray(\'' + ArrayUtils.toString(objectArray) + '\',\''
            + separator + '\') returned \'' + actual + '\'; expected \'' + expected + '\'');
    }

    private static testmethod void testJoinArrayFourArgs(){
        //test: global static String joinArray(Object[] objectArray, String separator, Integer startIndex, Integer endIndex) {
        assertJoinArrayFourArgs(null, null, 0, 2, null);
        assertJoinArrayFourArgs(new String[]{}, null, 0, 1, '');
        assertJoinArrayFourArgs(new String[]{null}, null, 0, 1, '');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '--', 0, 3, 'a--b--c');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, null, 0, 3, 'abc');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 0, 0, '');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 0, 1, 'a');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 0, 2, 'ab');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 0, 3, 'abc');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', -1, 4, 'abc');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 1, 1, '');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 1, 2, 'b');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 1, 3, 'bc');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 2, 2, '');
        assertJoinArrayFourArgs(new String[]{'a', 'b', 'c'}, '', 2, 3, 'c');
        assertJoinArrayFourArgs(new String[]{null, '', 'a'}, ',', 0, 3, ',a');
        assertJoinArrayFourArgs(new Long[]{3, 4, -1}, 'xyz', 0, 3, '3xyz4xyz-1');
    }

    private static void assertJoinArrayFourArgs(Object[] objectArray, String separator, Integer startIndex, Integer endIndex, String expected){
        String actual = StringUtils.joinArray(objectArray,separator,startIndex,endIndex);
        System.assert(actual==expected, 'StringUtils.joinArray(\'' + ArrayUtils.toString(objectArray) + '\',\''
            + separator + '\',' + startIndex + ',' + endIndex + ') returned \'' + actual + '\'; expected \'' + expected + '\'');
    }

    
}