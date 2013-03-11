@RestResource(urlMapping='/v1.0/merchant/contacts/*')

global class RESTcontactAPI{

@HttpGET
global static list<contact> getMyContacts(){
     RestRequest req = RestContext.request;
     list<contact> contacts = new list<contact>();
     string theId = EncodingUtil.urlDecode(req.params.get('salesforce_id'),'UTF-8');
     contacts = [select id, name, phone, email from Contact where accountid = :theId];
     return contacts;
    }


}