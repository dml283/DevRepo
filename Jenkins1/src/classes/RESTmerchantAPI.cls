@RestResource(urlMapping='/v1.0/merchants')

global class RESTmerchantAPI{

@HttpGET
global static list<MerchantAPI.merchant> getMyMerchants(){
    list<MerchantAPI.merchant> merchants = MerchantAPI.getMyMerchants();
    return merchants;
    }     
}