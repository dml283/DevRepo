public class ExternalReferenceSourceTest {

    @istest
    public static void testCanGetSourceIdByName() {
        updateSources();
        
        String id = ExternalReferenceSource.getSourceIdByName('Facebook');
        
        System.AssertEquals('11',id);
    }
    
    @istest
    public static void testCanConstructFromReview() {
        updateSources();
        
        // setup
        Reviews__c review = new Reviews__c();
        review.Source__c = 'Facebook';
        
        // method under test
        ExternalReferenceSource source = new ExternalReferenceSource(review);
        
        // tests
        System.AssertEquals('11', source.source_id);   
    }
    
    @istest
    public static void testCanGetSourceName() {
        updateSources();
        
        // setup
        Reviews__c review = new Reviews__c();
        review.Source__c = 'Facebook';
        
        // method under test
        ExternalReferenceSource source = new ExternalReferenceSource(review);
        
        // tests
        System.AssertEquals('Facebook', source.getSourceName());   
    }
    
    @istest
    public static void testReturnsNullForInvalidSource() {
        updateSources();
        
        String id = ExternalReferenceSource.getSourceIdByName('xxxxx');
        
        System.AssertEquals(null,id);
    }
    
    @istest
    public static void testCanGetSourceIdForPoorlyFormattedSourceName() {
        updateSources();
        
        String id = ExternalReferenceSource.getSourceIdByName('  faceBook    ');
        
        System.AssertEquals('11',id);
    }
    
    private static void updateSources() {
        Map<String,Object> one = new Map<String,Object> {   'source_id' => '2f17a870-b57b-11e1-bf3d-3c0754656b18',
                                                            'name' => 'yelp',
                                                            'meta_data' => new Map<String,Object>{
                                                                'website' => 'http://www.yelp.com/',
                                                                'm3_id' => 7,
                                                                'salesforce_source_name' => 'Blah'
                                                            }};
                                                            
        Map<String,Object> two = new Map<String,Object> {   'source_id' => '30a5e990-b57b-11e1-ad3b-3c0754656b18',
                                                            'name' => 'facebook',
                                                            'meta_data' => new Map<String,Object>{
                                                                'website' => 'http://www.facebook.com/',
                                                                'm3_id' => 11,
                                                                'salesforce_source_name' => 'Facebook'
                                                            }};
                                                            
        Map<String,Object> three = new Map<String,Object> {   'source_id' => '30a5e990-b57b-11e1-ad3b-3c0754656b19',
                                                            'name' => 'tripadvisor',
                                                            'meta_data' => new Map<String,Object>{
                                                                'website' => 'http://www.tripadvisor.com/',
                                                                'salesforce_source_name' => 'hello'
                                                            }};
    
    
        List<Map<String,Object>> sources = new List<Map<String,Object>> {one,two,three};
        
        // update sources    
        ExternalReferenceSource.updateSourceIdMap(sources);
        
        // now make sure that we can query for them
        System.AssertEquals('7', ExternalReferenceSource.getSourceIdByName('Blah'));
    }
}