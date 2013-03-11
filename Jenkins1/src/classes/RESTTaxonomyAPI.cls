@RestResource(urlMapping='/v1.0/taxonomy')

global class RESTTaxonomyAPI{

@HttpGET
global static list<taxonomy> getTaxonomy(){
    RestRequest req = RestContext.request;
    string category = EncodingUtil.urlDecode(req.params.get('category'),'UTF-8');
    list<taxonomy>  tax = new list<taxonomy>();
    list<string> services = new list<string>();
    list<string> attributes = new list<string>();
    for(taxonomy_support__c t : [SELECT Name__c FROM Taxonomy_Support__c WHERE Category__c = :category AND Type__c ='Merchant Service']){
       services.add(t.name__c);
       }
    for(taxonomy_support__c t : [SELECT Name__c FROM Taxonomy_Support__c WHERE Category__c = :category AND Type__c ='Merchant Attribute']){
       attributes.add(t.name__c);
       }   
    for(Taxonomy_Support__c t : [select id, category__c, subcategory__c, header__c, name from Taxonomy_Support__c WHERE category__c = :category AND type__c ='taxonomy']){
            tax.add(new taxonomy(t,services,attributes));
        }
    return tax;
    
}
global class taxonomy{
        public string header {get;set;}
        public string category {get;set;}
        public string subcategory {get;set;}
        public list<string> services {get;set;}
        public list<string> attributes {get;set;}
        
        public taxonomy(){}
        public taxonomy(Taxonomy_Support__c t, list<string> services, list<string> attributes){
            this.category = t.category__c;
            this.subcategory = t.subcategory__c;
            this.header = t.header__c;
            this.services = services;
            this.attributes = attributes;
           
        }
    }
private static testMethod void myTest() {
    taxonomy_support__c t = new taxonomy_support__c();
        t.category__c='Food & Drink';
        t.subcategory__c='some other subcat';
        t.type__c = 'Merchant Service';
        insert t;
     taxonomy_support__c ta = new taxonomy_support__c();
        ta.category__c='Food & Drink';
        ta.subcategory__c='some other subcat';
        ta.type__c = 'taxonomy';
        insert ta;    
    //list<taxonomy> tax = RESTTaxonomyAPI.getTaxonomy();
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    
    RestContext.request = req;
    RestContext.response = res;
    string endcoded = EncodingUtil.urlencode('Food & Drink','UTF-8');
    RestContext.request.addParameter('category', endcoded);
    system.debug('+=========encoded'+endcoded);
    system.debug('+=========tax of Food & Drink'+t);
    
    
    list<RESTTaxonomyAPI.taxonomy> taxList = RESTTaxonomyAPI.getTaxonomy();
    system.debug(taxList);
    system.assert(taxlist.size()==1);
}        
}