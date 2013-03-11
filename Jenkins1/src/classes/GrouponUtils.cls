/* ===================================================================
* GrouponUtils

* @author.....: Naushad Rafique

* @date.......: 2013/12/18

* @Last Change: 2013/12/18

* Description.: Generic Utility methods

* Known Dependencies: List too big to display :)
* ===================================================================
*/
public with sharing class GrouponUtils 
{
	//returns truee if the parameter string is either null or an empty string
    public static Boolean isNullOrEmpty(String rawInputString)
    {
        return (rawInputString == null || rawInputString.trim().length() == 0);
    }
    
    //converts a List of string to delimited string
    public static String getCSVFromList(List<String> stringList, String delimiter)
    {
    	String delimitedString = '';
    	
    	if(stringList != null && stringList.size() > 0)
    	{
    		Set<String> stringSet = new Set<String>();
    		stringSet.addAll(stringList);
    		return getCSVFromSet(stringSet, delimiter) ;
    	}
    	
    	return delimitedString;
    }
    
    //converts a Set of string to delimited string
    public static String getCSVFromSet(Set<String> stringSet, String delimiter)
    {
    	String delimitedString = '';
    	if(isNullOrEmpty(delimiter)) delimiter = ' ';
    	
    	if(stringSet != null && stringSet.size() > 0)
    	{
    		integer x= 0;
    		for(String s: stringSet)
    		{
    			if(x == 0)
    				delimitedString = s;
    			else
    				delimitedString += delimiter+s;
    			
    			x++;
    		}
    	}
    	
    	return delimitedString;
    }
    
    //returns a single string of consolidated DML error messages
    public static String getFormattedDMLErrorMessageForSameSObject(DMLException dmle)
    {
        String error = '';
        if(dmle != null)
        {
            for(Integer x = 0; x<=dmle.getNumDML()-1; x++)
                error += (x+1)+' - '+dmle.getDMLMessage(x)+', ';
        }
        return error;
    }
}