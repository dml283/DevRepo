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
global class ArrayUtils {
    
    global static String[] EMPTY_STRING_ARRAY = new String[]{};
    global static Integer MAX_NUMBER_OF_ELEMENTS_IN_LIST {get{return 1000;}}
    
    global static List<String> objectToString(List<Object> objects){
        List<String> strings = null;
        if(objects != null){
            strings = new List<String>();
            if(objects.size() > 0){
                for(Object obj : objects){
                    if(obj instanceof String){
                        strings.add((String)obj);
                    }
                }
            }
        }
        return strings;
    }

    
    global static Boolean isEmpty(Object[] objectArray){
        if(objectArray == null){
            return true;
        }
        return objectArray.size() == 0;
    }
    
    global static Boolean isEmpty(SObject[] objectArray){
        if(objectArray == null){
            return true;
        }
        return objectArray.size() == 0;
    }
    
    global static Boolean isNotEmpty(Object[] objectArray){
        return !isEmpty(objectArray);
    }
    
    global static Boolean isNotEmpty(SObject[] objectArray){
        return !isEmpty(objectArray);
    }
    
    
    global static String toString(Object[] objectArray){
        if(objectArray == null){
            return 'null';    
        }
        String returnValue = '{';
        for(Integer i = 0; i < objectArray.size(); i++){
            if(i!=0){ returnValue += ','; }
            returnValue += '\'' + objectArray[i] + '\'';
        }
        returnValue += '}';
        return returnValue; 
    }
    
    global static void assertArraysAreEqual(Object[] expected, Object[] actual){
        //check to see if one param is null but the other is not
        System.assert((expected == null && actual == null)|| (expected != null && actual != null),
            'Assertion failed, the following two arrays are not equal.  Expected: ' 
                    + ArrayUtils.toString(expected) + ', Actual: ' + ArrayUtils.toString(actual));
        if(expected != null && actual != null){
            System.assert(expected.size() == actual.size(), 'Assertion failed, the following two arrays are not equal.  Expected: ' 
                    + ArrayUtils.toString(expected) + ', Actual: ' + ArrayUtils.toString(actual));
            for(Integer i = 0; i < expected.size(); i++){
                System.assert(expected[i] == actual[i], 'Assertion failed, the following two arrays are not equal.  Expected: ' 
                    + ArrayUtils.toString(expected) + ', Actual: ' + ArrayUtils.toString(actual));
            }
        }
    }

}