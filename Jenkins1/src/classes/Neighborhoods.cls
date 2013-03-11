public class Neighborhoods{
/*
public map<string,string> latlongHood = new map<string,string>();
public map<string,string> latlongID = new map<string,string>();
public map<string, double> IdRequestNum = new map<string,double>();
public map<double, string> RequestNumHood = new map<double,string>();

public class Request{
    public string geoId {get;set;}
    public decimal lat {get;set;}
    public decimal lng {get;set;}
    public string neighborhood {get;set;}
}

public id nextRecord()
    {
        id i;
        geopointe__Geocode__c g = [select id from geopointe__Geocode__c where neighborhood__c = null limit 1];
        i =g.id;
        return i;
    }

public PageReference nextGeoCode()
    {
        set<id> idset = new set<id>();

        list<geopointe__Geocode__c> glist = [select id from geopointe__Geocode__c where neighborhood__c =null limit 100];
        for(geopointe__Geocode__c g1 : glist)
            idset.add(g1.id);
        id i = nextRecord();
        idset.add(i);
        doNeighborhood(idset);
        PageReference nextPage = Page.NeighborhoodMapper;
        i = nextRecord();
        nextPage.getParameters().put('id', i);
        return nextPage.setRedirect(true);
    }
public lead nextLead()
    {
        id i = ApexPages.currentPage().getParameters().get('id');
        lead l = [select id, neighborhood__c from lead where geopointe__Geocode__r.neighborhood__c !=null AND neighborhood__c !='Missing' AND ID != :i  order by LastModifiedDate limit 1];
        return l;
    }
public opportunity nextOppty()
    {
        id i = ApexPages.currentPage().getParameters().get('id');
        opportunity o = [select id, neighborhood__c from opportunity where neighborhood__c !='Missing' AND ID != :i  order by LastModifiedDate limit 1];
        return o;
    }    
public PageReference updateOppty()
    {
        opportunity o = nextOppty();
        set<id> addyId = new set<id>();
        list<address__c> alist = [select id from address__c where opportunity__c = :o.id];
        for(address__c a : alist)
            addyId.add(a.id);
        list<geopointe__Geocode__c> glist = [select id, geopointe__Parent_Record_ID__c, neighborhood__c from geopointe__Geocode__c WHERE geopointe__Parent_Record_ID__c IN :addyId];
        map<string,list<string>> nmap = new map<string,list<string>>();
        
        list<string> nhood = new list<string>();

        for(geopointe__Geocode__c g: glist)
            {
                if(g.neighborhood__c!=null)
                    nhood.add(g.neighborhood__c);
            }
        
        list<sObject> updater = new list<sObject>();

        string s ='';
        for(string a :nhood)
            {
              s+=a+' ; ';
            }  
        if(s!=''){    
            o.neighborhood__c = s;
            updater.add(o);  
            }          
        
        try{
            database.update(updater);
            }catch(exception e){system.debug('-----WE GOT AN ERROR MSG AND IT WAS:   '+e);}
        PageReference nextPage = Page.updateNeighborhoodOppty;
        nextPage.getParameters().put('id', o.id);
        return nextPage.setRedirect(true);
    } 
    
public PageReference updateLead()
    {
        
        lead l = nextLead();
        list<geopointe__Geocode__c> glist = [select id, geopointe__Parent_Record_ID__c, neighborhood__c from geopointe__Geocode__c WHERE geopointe__Parent_Record_ID__c =:l.id];
        map<string,list<string>> nmap = new map<string,list<string>>();
        list<string> nlist = new list<string>();
        for(geopointe__Geocode__c g: glist)
            {
                if(g.neighborhood__c !='')
                    nlist.add(g.neighborhood__c);
            }
        
        list<sObject> updater = new list<sObject>();
        string s ='';
        for(string a :nlist)
          {
              if(a!='')
                  s+=a+' ; ';
          }
        l.neighborhood__c = s;
        updater.add(l);            
        
        database.update(updater);
        PageReference nextPage = Page.updateNeighborhood;
        nextPage.getParameters().put('id', l.id);
        return nextPage.setRedirect(true);
    }    

public request getReqFields(geopointe__Geocode__c g)
    {
        Request r = new Request();
            decimal offset = 0;
            //geopointe.API.getGeocodeOffset(g.geopointe__Parent_Object__c,'H67rG7wo5gnSJ_2FTkY8fVYQ_3D_3D');
                decimal lat = (g.geopointe__Latitude__c - offset);
                decimal lng = (g.geopointe__Longitude__c - offset);
            r.geoId=g.id;
            r.lat=lat;
            r.lng=lng;
        return r;
        
    }

public request getLeadRequest(geopointe__Geocode__c g)
    {
        Request r = new Request();
            r.lat=g.lead_lat__c;
            r.lng=g.lead_long__c;
            r.GeoId=g.id;
        return r;    
    }

public request getOpptyRequest(geopointe__Geocode__c g)
    {
        Request r = new Request();
            r.lat=g.Address_Latitude__c;
            r.lng=g.Address_Longitude__c;
            r.GeoId=g.id;
        return r;    
    }

public request getAcctRequest(geopointe__Geocode__c g)
    {
        Request r = new Request();
            r.lat=g.Merchant_Address_Latitude__c;
            r.lng=g.Merchant_Address_Longitude__c;
            r.GeoId=g.id;
        return r;    
    }    

public void run()
    {    
        set<id> gset = new set<id>();
        list<geopointe__Geocode__c> g = [select id from geopointe__Geocode__c where neighborhood__c =null limit 100];
        for(geopointe__Geocode__c g1 : g)
            gset.add(g1.id);
            
        doneighborhood(gset);
    }

public void init(string Obj, string Division, string Cat)
    {
        set<id> geoids = new set<id>();
        if(Obj=='lead')
            {
                string query = 'select geopointe__Geocode__c FROM lead where Global_SFDC_Category__c = \''+cat+'\' AND Dynamic_Division__r.name = \''+division+'\'';
                list<lead> llist= database.query(query);
                for (lead l : llist)
                    geoids.add(l.geopointe__Geocode__c);       
            }else if(Obj=='Opportunity')
                {
                    string query = 'select Address_GEO__c FROM Address__c where Opportunity__r.Global_SFDC_Category__c = \''+cat+'\' AND Opportunity__r.Division_Dynamic__r.name = \''+division+'\'';
                    list<Address__c> olist= database.query(query);
                    for (Address__c o : olist)
                        geoids.add(o.Address_GEO__c);       
                }else if(Obj=='Account')
                    {
                        string query = 'select geopointe__Geocode__c FROM Merchant_Addresses__c where Account__r.Global_SFDC_Category__c = \''+cat+'\' AND Account__r.division__r.name = \''+division+'\'';
                        list<Merchant_Addresses__c> alist= database.query(query);
                        for (Merchant_Addresses__c o : alist)
                            geoids.add(o.Geocode__c);       
                    }
        doNeighborhood(geoids);
    }
   
public void doNeighborhood(set<id> geoids)
    {
        double counter=1;
        list<geopointe__Geocode__c> glist = [select id, Lead_Lat__c, lead_long__c, Address_Latitude__c, Address_Longitude__c, NOW_Lat__c, NOW_Long__c, geopointe__Parent_Object__c, geopointe__Longitude__c, geopointe__Latitude__c from geopointe__Geocode__c where neighborhood__c =null AND id in :geoids limit 75];
        list<request> rlist = new list<request>();
        for(geopointe__Geocode__c g : glist)
            {
                Request r = new Request();
                    r = getReqFields(g);
                    rlist.add(r);
                IdRequestNum.put(r.geoId,counter);
                    counter++;
             }
        fetchNeighborhood(rlist);      
    }

public string getJSONRequest(list<request> rlist)
    {
        JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
                gen.writeFieldName('locations');
                    gen.writeStartArray();
                    for(request r:rlist)
                        {
                            gen.writeStartObject();
                                gen.writeNumberField('lat', r.lat);
                                gen.writeNumberField('lng', r.lng);
                            gen.writeEndObject();
                        }
                    gen.writeEndArray();
            gen.writeEndObject();
        
        // Get the JSON string. is
    
        String pretty = gen.getAsString();
        system.debug(pretty);
        return pretty;
        
    }

public void ParseResults(HttpResponse r)
    {
        JSONParser parser = JSON.createParser(r.getBody());
        system.debug(r.getbody());
        double latitude=0;
        double longitude=0;
        double counter =1;
        string neighborhood='';
        system.debug('--------ok step 1-----');
        system.debug(parser.getCurrentToken());
        system.debug(parser.getText());

           //if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'locations')) 
             
                   system.debug('--------ok step 2-----');
                    while (parser.nextToken() != null) 
                        {
                               if ((parser.getCurrentToken() ==JSONToken.FIELD_NAME)&& (parser.getText() == 'effectiveNeighborhood')) 
                                    {
                                        system.debug('---------------------COUNTER VAL----'+counter);
                                        parser.nextToken();
                                        parser.nextToken();
                                        parser.nextToken();
                                        // Store the longitude value in a variable. 
            
                                        neighborhood = parser.getText();
                                        system.Debug('-------------------- '+parser.getCurrentName() + '------:-----'+ neighborhood);
                                         
                                       if (neighborhood =='')
                                         neighborhood='Missing';     
                                           
                                        //string indexkey = string.valueof(latitude)+string.valueof(longitude);
                                        //latlongHood.put(indexkey,neighborhood);
                                        RequestNumHood.put(counter,neighborhood);
                                            counter++;
                                    }         
                          }
               }
                                 
 

public void fetchNeighborhood(list<request> rlist)
    {
        string jsonreq = getJSONRequest(rlist);
        
        http h = new http();
        HttpRequest req = getHttpRequest();
            req.setbody(JSONReq);
        HttpResponse res = h.send(req);
        ParseResults(res);
        updateGeo(rlist);
     
    }
    
public void updateGeo(list<request> rlist)
    {
        list<geopointe__Geocode__c> geosToUpdate = new list<geopointe__Geocode__c>();
        double counter = 1;
        for(request r : rlist)
            {
                string gid = r.GeoID;
  
                double reqNum = IdRequestNum.get(gid);
                    system.debug('-----------------Req Num'+reqNum);
                string dahood = RequestNumHood.get(reqNum);
                    system.debug('-----------------da hood'+dahood);
                geopointe__Geocode__c g = new geopointe__Geocode__c(id=r.GeoId, neighborhood__c=daHood);
                system.debug('-----------------geocode'+g);
                      geosToUpdate.add(g);
            }
        update geosToUpdate;    
    }    
    
public HttpRequest getHttpRequest()
    {
        string endpoint = 'http://geodetails.groupondev.com/v1/locations.json';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
        return req;    
    }    
static testMethod void TestHoods()
    {
        //lead l = [select id from lead limit 1];
        //acccount a = [select id from account limit 1];
        //opportunity o = [select id from opportunity limit 1];
        string someId = 'someidstring';
        string someId1 = 'someidstring232';
        string someId2 = 'someidstring231';
        request r = new request();
        string cat = 'Restaurant';
        string obj = 'lead';
        string division = 'Chicago';
        Neighborhoods N = new Neighborhoods();
        geopointe__Geocode__c g = new geopointe__Geocode__c();
           g.geopointe__Latitude__c =45.24542;
           g.geopointe__Longitude__c =-141.232323;
           g.geopointe__Parent_Object__c='lead';
           g.geopointe__Parent_Record_ID__c=someId;
           insert g;
       geopointe__Geocode__c g1 = new geopointe__Geocode__c();
           g1.geopointe__Latitude__c =45.24542;
           g1.geopointe__Longitude__c =-141.232323;
           g1.geopointe__Parent_Object__c='address__c';
           g1.geopointe__Parent_Record_ID__c=someId1;
           insert g1;
       geopointe__Geocode__c g2 = new geopointe__Geocode__c();
           g2.geopointe__Latitude__c =45.24542;
           g2.geopointe__Longitude__c =-141.232323;
           g2.geopointe__Parent_Object__c='merchant_addresses__c';
           g2.geopointe__Parent_Record_ID__c=someId2;
           insert g2;          
          r = n.getReqFields(g);   
          r = n.getReqFields(g1);   
          r = n.getReqFields(g2);  
            n.init(obj,division,cat);
            obj='opportunity';
            n.init(obj,division,cat);
            obj='Account';
            n.init(obj,division,cat);
          
    }
*/
}