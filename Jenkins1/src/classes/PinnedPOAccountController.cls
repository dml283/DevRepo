global class PinnedPOAccountController {

    List<purchase_order__c> purchaseordersrelatetoAccount = new list<purchase_order__c>();
    Account Accountinfo                                      = new Account();
    List<pinnedmerchant__c> pinned                     = new List<pinnedmerchant__c>();
    public boolean renderoutpanel{get;set;}
    Account AllAccount;
    private id ctrlId ;
    public string todaysday{get;set;}
    list<string> subdivlist = new list<string>();
    public PinnedPOAccountController(ApexPages.StandardController controller)
    {
     ctrlId = controller.getID();
     renderoutpanel = false;
    }

    public Account getAccountInfo()
    {
    string[] accountsplit = new string[]{};
    Accountinfo = [select id,name,Division__c,Category_new__c,Subdivision__c,Category_v3__c  from Account where Id =: ctrlId ];
      if(Accountinfo.Subdivision__c !=null)
   {
    accountsplit  = (Accountinfo.Subdivision__c.split('\\;'));
    }
    for(string accounts : accountsplit)
    {
    subdivlist.add(accounts );
    }
      
    return Accountinfo;
    }
    public PageReference renderpanel()
    {
    renderoutpanel = true;
    return null;
    }
    public list<wrapperclass> getPOinfo()
    {
    Date d = date.today();  
datetime myDate = datetime.newInstance(d.year(), d.month(), d.day());  
todaysday = myDate.format('EEEE'); 
todaysday = todaysday.substring(0,3);

    list<wrapperclass> purchasewrapper = new list<wrapperclass>();
    getAccountInfo();
    //purchaseordersrelatetoAccount = [select id,name,division__c,PO_status__c from purchase_order__c limit 10 ];    

    purchaseordersrelatetoAccount = [SELECT id,name,category__c,Ideal_Price_Range__c,Target_GP__c,Subdivision__c,PO_Notes__c,Rep_PO_Notes__c ,Assigned_To_multi__c,Global_SFDC_Subcategory_1__c,Global_SFDC_Subcategory_2__c,division__r.name,Target_Feature_Date__c,PO_status__c,subdivision__r.name,Global_SFDC_Category__c 
                                  FROM   purchase_order__c 
                                  WHERE  Category__c                       =: Accountinfo.Category_v3__c  
                                  AND    Division__c                       =: Accountinfo.Division__c
                                 // AND    Subdivision__r.name              IN: subdivlist
                                  AND    PO_status__c                      =: 'Open' ];
     list<pinnedmerchant__c> pin = [select id,purchase_order__c from pinnedmerchant__c where Account__c =: ctrlId]; 
     system.debug('PINNED MERCHANT INFO' + pin );                             
            for(purchase_order__c purch: purchaseordersrelatetoAccount )
            {
            purchasewrapper.add(new wrapperclass(purch, ctrlId,pin ));
            }
      return purchasewrapper ;
    }
    public class wrapperclass
    {
     public purchase_order__c purchase{get;set;}
     public boolean selected{get;set;}
     public list<pinnedmerchant__c>  pinnedmerch {get;set;}
     public string repnotes{get;set;}
     public Id CurrentAccount;
     public id currid;
     
     public wrapperclass(purchase_order__c pur,Id curr,list<pinnedmerchant__c> pinned)
     {
      purchase= pur;
      pinnedmerch = pinned;
      selected = false;
      CurrentAccount = curr;
      if(purchase.Rep_PO_Notes__c != null)
      {
      if(purchase.Rep_PO_Notes__c.length() >= 30)
      {
      repnotes = (purchase.Rep_PO_Notes__c).substring(0,30)+'...';
      }
      }
       // list<pinnedmerchant__c> pin = [select id,purchase_order__c from pinnedmerchant__c where Account__c =: CurrentAccount];
       
       system.debug('Curernt Account' + CurrentAccount);
       system.debug('Pinned merch' + pinnedmerch .size() + 'Pinned' + pinnedmerch );
       
      for( pinnedmerchant__c pins : pinnedmerch )
      {
       if(pins.purchase_order__c == purchase.id)
       {
       selected = true;
       }
      }
      system.debug('Selected' + selected);
     }
}
 @isTest
 static void method1()
 {
    
    
    Division__c div = new Division__c();
    div.name  = 'testname';
    div.State__c = 'CA';
    Insert div;
    
    subdivision__c subdiv = new subdivision__c();
    subdiv.name ='test';
    insert subdiv;
    
    Account Accountval                    = new Account();
    Accountval.category_new__c            = 'Activities';
    Accountval.Division__c                = div.Id;
    Accountval.Subdivision__c             = subdiv.Id;
    Accountval.Name                    = 'Test Company';

    Insert Accountval;
    
    
    Apexpages.StandardController cont  = new Apexpages.StandardController(Accountval);
    PinnedPOAccountController pinnedinst  = new PinnedPOAccountController(cont);
    pinnedinst.getPOinfo();
    pinnedinst.getAccountInfo();
 }   
    
}