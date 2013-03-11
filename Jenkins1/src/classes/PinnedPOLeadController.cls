global class PinnedPOLeadController {

    List<purchase_order__c> purchaseordersrelatetoLead = new list<purchase_order__c>();
    Lead Leadinfo                                      = new Lead();
    List<pinnedmerchant__c> pinned                     = new List<pinnedmerchant__c>();
    public boolean renderoutpanel{get;set;}
    Lead AllLead;
    private id ctrlId ;
    public string todaysday{get;set;}

    public PinnedPOLeadController(ApexPages.StandardController controller)
    {
     ctrlId = controller.getID();
     renderoutpanel = false;
    }

    public lead getLeadInfo()
    {
    leadinfo = [select id,name,Dynamic_Division__c,Subdivision_Dynamic__c,Category__c,Category_v3__c  from Lead where Id =: ctrlId ];
    return Leadinfo;
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
    getLeadInfo();
    //purchaseordersrelatetoLead = [select id,name,division__c,PO_status__c from purchase_order__c limit 10 ];    

    purchaseordersrelatetoLead = [SELECT id,name,category__c,Ideal_Price_Range__c,Target_GP__c,Subdivision__c,PO_Notes__c,Rep_PO_Notes__c ,Assigned_To_multi__c,Global_SFDC_Subcategory_1__c,Global_SFDC_Subcategory_2__c,division__r.name,Target_Feature_Date__c,PO_status__c,subdivision__r.name,Global_SFDC_Category__c 
                                  FROM   purchase_order__c 
                                  WHERE  category_V3__c                    =: Leadinfo.category_V3__c
                                  AND    Division__c                       =: Leadinfo.Dynamic_Division__c
                                  AND    Subdivision__c                    =: Leadinfo.Subdivision_Dynamic__c
                                  AND    PO_status__c                      =: 'Open'];
            for(purchase_order__c purch: purchaseordersrelatetoLead )
            {
            purchasewrapper.add(new wrapperclass(purch, ctrlId ));
            }
      return purchasewrapper ;
    }
    public class wrapperclass
    {
     public purchase_order__c purchase{get;set;}
     public boolean selected{get;set;}
     public string repnotes{get;set;}
     public Id CurrentLead;
     public id currid;
     
     public wrapperclass(purchase_order__c pur,Id curr)
     {
      purchase= pur;
      selected = false;
      CurrentLead = curr;
      if(purchase.Rep_PO_Notes__c != null)
      {
      if(purchase.Rep_PO_Notes__c.length() >= 30)
      {
      repnotes = (purchase.Rep_PO_Notes__c).substring(0,30)+'...';
      }
      }
       list<pinnedmerchant__c> pin = [select id,purchase_order__c from pinnedmerchant__c where Lead__c =: CurrentLead];
       
       system.debug('Curernt Lead' + CurrentLead);
       system.debug('Pinned merch' + pin.size() + 'Pinned' + pin);
       
      for( pinnedmerchant__c pins : pin)
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
    
    Lead Leadval                       = new Lead();
    Leadval.category__c                = 'Activities';
    Leadval.Dynamic_Division__c        = div.Id;
    Leadval.Subdivision_Dynamic__c     = subdiv.Id;
    Leadval.Company                    = 'Test Company';
    Leadval.status                     = 'Uncontacted';
    Leadval.Subcategory__c             = 'Alcohol Event';
    Leadval.Lastname                   = 'Groupon';
    Insert Leadval;
    
    
    Apexpages.StandardController cont  = new Apexpages.StandardController(Leadval);
    PinnedPOLeadController pinnedinst  = new PinnedPOLeadController(cont);
    pinnedinst.getPOinfo();
    pinnedinst.getLeadInfo();
 }   
    
}