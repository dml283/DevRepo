@isTest
public class NetsuiteUpdateObject_Test{

  static testMethod void testConstructor(){
    NetsuiteUpdateObject obj = new NetsuiteUpdateObject('PO Signed', '21213', 'PO_USGG006c0000002tQLeAAM', 
      '006c0000002tQLeAAM', '1', '09012012131059', '09022013011059', '1', 
      'https://system.sandbox.netsuite.com/core/media/media.nl?id=41459&c=3579761&h=bf5565f616cf6fd5f5ec&_xt=.pdf', '11202012', '12212012'); 
  
    System.assertEquals('PO Signed', obj.po_es_status);
    System.assertEquals('21213', obj.internalID);
    System.assertEquals('PO_USGG006c0000002tQLeAAM', obj.tranID);
    System.assertEquals('006c0000002tQLeAAM', obj.custbody_po_sf_opp_id);
    System.assertEquals('1', obj.po_es_error_code);
    System.assertEquals('09012012131059', obj.po_create_datetime);
    System.assertEquals('09022013011059', obj.po_update_datetime);
    System.assertEquals('1', obj.po_revision);
    System.assertEquals('https://system.sandbox.netsuite.com/core/media/media.nl?id=41459&c=3579761&h=bf5565f616cf6fd5f5ec&_xt=.pdf', obj.echosign_link); 
  }
  
  
  static testMethod void testEmptyField(){
    NetsuiteUpdateObject obj = new NetsuiteUpdateObject('PO Signed', '21213', 'PO_USGG006c0000002tQLeAAM', 
      '006c0000002tQLeAAM', '', '09012012131059', '09022013011059', '1', 
      'https://system.sandbox.netsuite.com/core/media/media.nl?id=41459&c=3579761&h=bf5565f616cf6fd5f5ec&_xt=.pdf', '', '');  
    System.assertEquals('', obj.po_es_error_code);
  }
}