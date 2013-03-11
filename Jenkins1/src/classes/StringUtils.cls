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
/**
 * Port of the StringUtils class from Java to Apex.  This
 * class is part of the Apache Commons Lang project available
 * at http://commons.apache.org/lang/.
 */
global class StringUtils {

    global static final String EMPTY = '';
    
    global static boolean isBlank(String str) {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }

    global static String joinArray(Object[] objectArray) {
        return joinArray(objectArray, null);
    }
    
    global static String joinArray(Object[] objectArray, String separator) {
        if (objectArray == null) {
            return null;
        }
        return joinArray(objectArray, separator, 0, objectArray.size());
    }

    global static String joinArray(Object[] objectArray, String separator, Integer startIndex, Integer endIndex) {
        if (objectArray == null) {
            return null;
        }
        if (separator == null) {
            separator = EMPTY;
        }

        String buf = '';
        if(startIndex < 0){
            startIndex = 0;
        }
        Boolean isFirst = true;
        for (Integer i = startIndex; i < endIndex && i < objectArray.size(); i++) {
            if(objectArray[i] != null) {
                if(isFirst){
                    isFirst = false;
                } else {
                    buf += separator;
                }
                buf += objectArray[i];
            }
        }
        return buf;
    }

}