@RestResource(urlMapping='/v1.0/calendar')

global class RESTCalendarAPI{

@HttpGET
global static list<calendar.cal> getCalendar(){
    return calendar.getmycalendar();
    } 
}