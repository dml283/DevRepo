trigger updateTime on NOW_Schedule__c (before update) {

/*
Trigger: Update NOW Times to Object
Author: Chris Bland
v1.0

Version History:
Created, built and all that fun stuff in a day

Associated Test Class: TBD

Last Updated: 5/9/2011

*/

    // build a map of Schedules keyed by Time name
    Map<String, List<NOW_Schedule__c>> SchdTimes=new Map<String, List<NOW_Schedule__c>>();
    Map<String, List<NOW_Schedule__c>> SchdTimesEnd=new Map<String, List<NOW_Schedule__c>>();
    
    //Go Through the list in the trigger
    for (NOW_Schedule__c schd : trigger.new)
    {
        //build a list of all Schedules by StartTimes       
        List<NOW_Schedule__c> st = SchdTimes.get(schd.Start_Time__c);
        if (null==st)
        {
            //add the Schedules to the map by creatinga  new list
            st=new List<NOW_Schedule__c>();
            SchdTimes.put(schd.Start_Time__c, st);
        }
        st.add(schd);
    }
    Set<String> TimeNames = SchdTimes.keySet();
    // query all times in one go based on the names from the map
    List<Time__c> myTimes=[select id, Name, Minutes__c from Time__c where Name IN :TimeNames ];
    for (Time__c t : myTimes)
    {
       // find the Schds with the matching name
       List<NOW_Schedule__c> timelistz = SchdTimes.get(t.name);
       
       if (null!=timelistz)
       {
        for (NOW_Schedule__c l : timelistz)

              {
                  l.StartTime__c = t.id;
              }
           
       }
    }
    for (NOW_Schedule__c schdet : trigger.new)
    {
        List<NOW_Schedule__c> et = SchdTimesEnd.get(schdet.End_Time__c);
        if (null==et)
        {
            et=new List<NOW_Schedule__c>();
            SchdTimesEnd.put(schdet.End_Time__c, et);
        }
        et.add(schdet);
    }
    Set<String> TimeNameset = SchdTimesEnd.keySet();
    
    List<Time__c> myTimeset=[select id, Name, Minutes__c from Time__c where Name IN :TimeNameset ];
    for (Time__c t1 : myTimeset)
    {
       List<NOW_Schedule__c> timelistzet = SchdTimesEnd.get(t1.name);
       
         for (NOW_Schedule__c l : timelistzet)
           {
                  l.EndTime__c = t1.id;
           }
       
    }

    
}