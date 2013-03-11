global class scheduleBatchGeoCoder implements schedulable{
    
    global void execute(SchedulableContext sc){
        BatchGeocoder batchGeoCode = new BatchGeocoder();
        database.executebatch(batchGeoCode,1);
    }
    
}