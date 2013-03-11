/**
 * External Reference Source model, which is embedded in the External Reference model.
 *
**/
global class ExternalReferenceSource {
    public String source_id {get;set;}
    
    private static Map<String,String> sourceIdToNameMap = new Map<String,String>();
    
    static {
        sourceIdToNameMap = new Map<String,String>{
                //'1' => 'leadminer',
                //'2' => 'Salesforce',
                '3' => 'Account',
                '4' => 'Lead',
                //'5' => 'CrowdSource',
                //'6' => 'Localeze',
                '7' => 'Yelp',
                //'8' => 'Google',
                //'9' => 'Factual',
                //'10' => 'Foursquare',
                '11' => 'Facebook',
                //'12' => 'CitySearch',
                //'13' => 'Yahoo',
                //'14' => 'Zagat',
                //'15' => 'Urbanspoon',
                //'16' => 'MenuPages',
                //'17' => 'Chow',
                //'18' => 'Allmenus',
                //'19' => 'Unknown',
                //'20' => 'SpaFinder',
                //'21' => 'TripAdvisor',
                //'22' => 'OpenTable',
                //'23' => 'Insider Pages',
                //'24' => 'Expedia',
                //'25' => 'Factual',
                //'26' => 'Factual',
                //'27' => 'Groupon App',
                //'28' => 'Single Platform',
                //'29' => 'Grubhub',
                //'30' => 'Google Plus',
                //'31' => 'M3',
                '32' => 'Salesforce Account Address'
                //'33' => 'Judy\'s Book',
                //'34' => 'Better Business Bureau',
                //'35' => 'OpenTable',
                //'36' => 'Main Street',
                //'37' => 'Yahoo Travel',
                //'38' => 'SquareUp',
                //'39' => 'Restaurantica',
                //'42' => 'Merchant Data',
                //'43' => 'Uptake',
                //'44' => 'Salesforce Account International',
                //'45' => 'SEO',
                //'46' => 'GolfLink',
                //'47' => 'Chennai Operations'
        };
    }
    
    public ExternalReferenceSource() {}
    
    // construct an external reference source using the source in a Salesforce review object
    public ExternalReferenceSource(reviews__c review) {
        this.source_id = getSourceIdByName(review.Source__c);
    }
    
    public String getSourceName() {
        // convert from source_id to source name
        return sourceIdToNameMap.get(source_id);
    }
    
    
    public static String getSourceIdByName(String name) {
        // convert source name to id
        String trimmedName = null;
        if(name != null) {
            trimmedName = name.trim();
        } else {
            return null;
        }
        
        for(String sourceId : sourceIdToNameMap.keySet()) {
            if(sourceIdToNameMap.get(sourceId).equalsIgnoreCase(trimmedName)) {
                return sourceId;
            }
        }
        // haven't found the source name - return null
        return null;
    }
    
    public static Map<String,String> updateSourceIdMap(List<Object> sources) {
        Map<String,String> newSourceMap = new Map<String,String>();
        
        for (Object sourceObj : sources) {
            Map<String,Object> source = (Map<String,Object>)sourceObj;
            if(source.containsKey('meta_data')) {
                Map<String,Object> metadata = (Map<String,Object>)source.get('meta_data');
                if(metadata.containsKey('m3_id') && metadata.containsKey('salesforce_source_name')) {
                    Integer m3Id = (Integer)metadata.get('m3_id');
                    String salesforceSourceName = (String)metadata.get('salesforce_source_name');
                    
                    newSourceMap.put(m3Id + '', salesforceSourceName);
                }
            }  
        }
        
        sourceIdToNameMap = newSourceMap;
        
        return sourceIdToNameMap;
    }
    
    public static Map<String,String> getAllSourceData() {
        return sourceIdToNameMap;
    }
}