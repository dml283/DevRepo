Global class PerfectPipeline {

    public String Schedule { get; set; }

    public id userId = UserInfo.getUserId();
    public string division {get; set;}
    public string subdiv {get; set;}
    public string username = UserInfo.getName();
    public string DivisionName{get;set;}
    public string SubDivisionName{get;set;}
    public string CategoryInput{get;set;}
    public string Subcategory1Input{get;set;}
    public string Subcategory2Input{get;set;}
    public string PONotes{get;set;}
    public string AssignedTo {get;set;}
    public string ExDeal1 {get;set;}
    public string ExDeal2 {get;set;}
    public string DealBuilderTeamplate{get;set;}
    public string IdealPrice{get;set;}
    public string TargetGP {get;set;}
    public string TargetGMS{get;set;}
    public date TargetDate{get;set;}
    public date MinDate{get;set;}
    public date MaxDate{get;set;}
    public set<id> AssignedToMulti = new set<id>();
    public string AssignedToArray{get;set;}
    public id SelectedID{get;set;}
    public map<string,list<pipeline>> SubdivMap {get;set;}
    public list<Schedule> ScheduleData {get;set;}
    public list<string> assignedtoName = new list<string> ();
    public string POIdToUpdate {get;set;}
    public string RepNotes{get;set;}
    public map<id,list<pinnedMerchant>> contactMap = new map<id,list<pinnedMerchant>>();
    //PR
    public string nextstep{get;set;}
    
        public list<Pipeline> getResultList()
        {
                //SubdivMap.clear();
                list<pipeline> ResultList = new list<pipeline>();
                string queryPO = getSOQLpo();
                string queryDeal = getSOQLDeal();
                system.debug('++++++++QUERY PO'+queryPO);
                system.debug('++++++++QUERY Deal'+queryDeal);
                list<Purchase_Order__c> POlist = database.query(queryPO);
                list<opportunity> oList = database.query(queryDeal);
                for(Purchase_Order__c po :POList)
                        {
                                pipeline p = formatPipelinePO(po);
                    //            addToPipelineMap(p);
                                ResultList.add(p);
                        }
                for(opportunity o :OList)
                        {
                                pipeline p = formatPipelineDeal(o);
                  //              addToPipelineMap(p);
                                ResultList.add(p);
                        }
                //scheduleData = createSchedule();                
                return ResultList;
        }
       
     webService static void movePO(string TheId, string NewDate, string NewSubdivision)
         {
             string clipID = TheID.replaceAll('SCH','');
             Purchase_Order__c PO = new Purchase_Order__c(id=clipID);
             PO.Target_Feature_Date__c = date.parse(NewDate);
             PO.Subdivision__c = [select id from subdivision__c where name = :NewSubdivision limit 1].id;
             try{
                 database.update(PO);
             }catch(exception e){system.debug('oh noes...there was one of those errors and it was '+e);}
         } 

   
    webService static void createNewTask(string TaskBody, string TheId, string OwnerID, string RType) 
    {
        Task T = new Task();
        if(Rtype=='Contact')
            {
                t.WhatID = theId;
                t.ownerID = OwnerId;
                t.Subject = 'PO Follow Up Task';
                t.Description=TaskBody;
            }else
                {
                    t.WhoID = theId;
                    t.ownerID = OwnerId;
                    t.Subject = 'PO Follow Up Task';
                    t.Description=TaskBody;
                }
        try{insert T;}catch(exception e){system.debug(e);}
    }
    webService static Purchase_Order addPO(Purchase_Order po) 
    {
        
         Purchase_Order__c p = new Purchase_Order__c();
                     division__c div = [select id from division__c where name = :po.Division limit 1]; 
                     subdivision__c subdiv;
                     try{
                         subdiv = [select id from subdivision__c where name = :po.subDivision limit 1]; 
                         }catch(exception e){}
                     p.division__c =  div.id;
                     p.Target_Feature_Date__c = date.parse(po.TargetFeatureDate);  
                     if(subdiv!=null){p.subdivision__c = subdiv.id;}
                     p.global_sfdc_category__c = po.Category; 
                     p.Global_SFDC_Subcategory_1__c = po.SubCategory1;
                     p.Global_SFDC_Subcategory_2__c = po.SubCategory2;
                     p.PO_Notes__c = po.PONotes;
                     p.po_status__c = 'Open';
                     p.Example_deal_1__c = po.ExampleDeal1;
                     P.Example_deal_2__c = po.ExampleDeal2; 
                     P.Deal_Builder_Template__c = po.DealBuilder;     
                     p.Ideal_Price_Range__c = po.IdealPrice; 
                     
                     decimal d = 0;
                     if(po.TargetGP!=null)
                                {
                                    po.TargetGP = po.TargetGP.replace(',','');
                                    po.TargetGP =po.TargetGP.replace('$','');
                                    d=decimal.valueof(po.TargetGP);
                                }   
                     p.Target_GP__c=d; 
                     d = 0; 
                     if(po.TargetGMS!=null)
                                {
                                    po.TargetGMS = po.TargetGMS.replace(',','');
                                    po.TargetGMS = po.TargetGMS.replace('$','');
                                    d=decimal.valueof(po.TargetGMS);
                                } 
                     p.Target_Revenue__c=d;
                     system.debug(p);
               try{
                   insert p;
                       }catch (exception e){
                       system.debug('error msg here===================='+e);
                       }
           
           
                       //TODO null pointer exception. split out to separate method
               string[] AssignedArray = po.MultiAssign.split(';',8);
               list<assignedTo__c> InsertList = new list<AssignedTo__c>();
               //TODO should start catching errors when records aren't found.
               
               for(string username : AssignedArray)
                   {
                       if(username!=''){
                               try{
                                   user u = [select id from user where name =:username limit 1];
                                   AssignedTo__c AsTo = new AssignedTo__c(purchase_order__c=p.id, assigned_To__c=u.id);
                                    
                                   if (AsTo != null && AsTo.Assigned_To__c != null)
                                      {
                                            InsertList.add(AsTo);   
                                       }
                                  } catch (System.QueryException e) {
                                       system.debug('No matching User');
                                   }        
                   }}
               insert InsertList;
               string s = '';
               po.id = p.id;
         
               return po;  
}

   public static void updateNotes(String id, String notes){
       try{
            Purchase_order__c po = [select id, Rep_PO_Notes__C from Purchase_order__c where id =:id LIMIT 1];
            po.Rep_PO_Notes__c = notes;
            database.update(po);
               }catch(exception e){system.debug(e);}
          
       }
       
   public static void updateOpportunity(String id, String notes){
       Opportunity op = [Select id,Nextstep From Opportunity where id =:id LIMIT 1];
       op.Nextstep = notes;
       try{database.update(op);}catch(exception e){}
   }
       
    public static Opportunity findOpportunity(String id){
        Opportunity op = [Select id,Nextstep, Amount_of_Multi_Deal_Children__c, Total_GP__c, Feature_End_Date__c, Margin_Percent__c, Value_of_Unit__c, Projected_Multi_Deal_Share_of_GP__c, permalink__c, Subdivision_Dynamic__r.name, type, Unit_Sell_Price__c, Total_Projected_GMS__c, Total_Feature_Projected_GP__c, Owner.Name, OwnerId, Name, Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, Feature_Date__c, Division_Dynamic__r.Name, Division_Dynamic__c, Deal_Strengh__c From Opportunity where id =:id LIMIT 1];    
        return op;
    }   
   
    public Purchase_order__c findPO(String id){
        Purchase_Order__c po = [select id, Rep_PO_Notes__C,division__c,Target_Feature_Date__c,subdivision__c,global_sfdc_category__c,Global_SFDC_Subcategory_1__c,Global_SFDC_Subcategory_2__c,Target_GP__c,Example_deal_1__c,Example_deal_2__c,Deal_Builder_Template__c,Ideal_Price_Range__c
        from Purchase_Order__c where id =:id LIMIT 1];
        return po;
    }
   
    global class PipelineList {
        public list<Pipeline> pipelines {get;set;}
    
    }
    
    global class PipelineStringList {
        public list<string> stringlist {get;set;}
    }   
     
    global class Purchase_Order
         {   public string id {get;set;}
             public string Division {get;set;}
             public string Subdivision {get;set;}
             public string TargetFeatureDate {get;set;}
             public string Category {get;set;}
             public string Subcategory1 {get;set;}
             public string Subcategory2 {get;set;}
             public string PONotes {get;set;}
             public string MultiAssign {get;set;}
             public string ExampleDeal1 {get;set;}
             public string ExampleDeal2 {get;set;}
             public string DealBuilder {get;set;}
             public string IdealPrice {get;set;}
             public string TargetGP {get;set;}
             public string TargetGMS {get;set;}
         }
    
      public static String findObjType(String theid){
     
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, String> keyPrefixMap = new Map<String, String>{};
        //get the prefix of the objects in Ids
        Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet)
        {
        Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
        String tempName = r.getName();
        String tempPrefix = r.getKeyPrefix();
         //in this map, all the Objects with their prefixes will be stored
        keyPrefixMap.put(tempPrefix,tempName);
        }
        String tPrefix = theid;
        tPrefix = tPrefix.subString(0,3);
        //get the type of your specified object
        String objectType = keyPrefixMap.get(tPrefix);
        return objectType;
    
    }
    
    webService static void addPinnedNotes(string theid, string notes)
    {
        String ObjectType = findObjType(theid);

        if(objectType == 'Account')
        {
         account a = new account(id=theid);
            a.repNotes__c = notes;
        update a;
        }
        else 
        {
        try{    
            lead l = [select id, IsConverted, repNotes__c,ConvertedAccountId from lead where id=:theid];
            if(!l.isconverted){
                l.repNotes__c = notes;
                update l;
            }else{         
                        account a = new account(id=l.ConvertedAccountId);
                                a.repNotes__c = notes;
                       update a;
                       }
        }catch(exception e){}
        } 
    }
         
    webService static void addRepNotes(string theid, string notes) 
    {
        String ObjectType = findObjType(theid);

        if(objectType == 'Opportunity')
        {
         opportunity  opp = new opportunity(id=theid);
            opp.nextstep = notes;
        update opp;
        }
        else 
        {
        Purchase_order__c po = new Purchase_order__C(id=theid);
            po.Rep_PO_Notes__c = notes;
        update po;
        }   
     }

    public list<subdivision__c> getSubDiv()
        {
                list<subdivision__c> s = new list<subdivision__c>();
                if(division!=null)
                        {
                                string query = 'select name from Subdivision__c WHERE Division__r.Name = \''+division+'\'';
                                s = database.query(query);
                        }
                return s;
        }       
    public class SubDivision
        {
                public string name {get;set;}
                public list<Pipeline> P {get;set;}
        }
    public class Schedule
        {
                public string d {get;set;}
                public list<SubDivision> subdivisions {get;set;}
                public double width {get;set;}
                public string widthStyle{get;set;}
        }
    
    public void reloadDivs()
        {
                
        }
    
    public class Pipeline
        {
            public string type{get;set;}
            public string MerchantName{get;set;}
            public string subdivision{get;set;}
            public id RecordId{get;set;}
            public string ViewLink{get;set;}
            public string ExampleLink{get;set;}
            public string TargetDate{get;set;}
            public string Category{get;set;}
            public string Subcategory1{get;set;}
            public string Permalink{get;set;}
            public string Subcategory2{get;set;}
            public string PONotes{get;set;}
            public string Status{get;set;}
            public string AssignedTo{get;set;}
            public string ExampleDeal1{get;set;}
            public string ExampleDeal2{get;set;}
            public string DealBuilder{get;set;}
            public string PriceRange{get;set;}
            public string TargetGP{get;set;}
            public string TargetGMS{get;set;}
            public string WeekOf{get;set;}
            public string POtype{get;set;}
            public string RepNotes{get;set;}
            public string CategoryStyle{get;set;}
            public string StatusStyle{get;set;}
            public string HTMLlinks{get;set;}
            public string TotalGP{get;set;}
            public string DealType{get;set;}
            public string EndDate{get;set;}
            //PR
            public string NextStep{get;set;}
            public list<PinnedMerchant> PM {get;set;}
            //PR
        }
    public class PinnedMerchant{
        public string Name{get;set;}
        public string Company {get;set;}
        public id RecordID {get;set;}
        public string Rank {get;set;}
        public string Phone {get;set;}
        public string Status {get;set;}
        public string Notes {get;set;}
        public string NewOld {get;set;}
        public string Owner{get;set;}
        public string Type {get;set;}
        public string NotesUpdateDate {get;set;}
        public string RepNotes {get;set;}
        public id Parent {get;set;}
        public id OwnerID {get;set;}
        
        public pinnedMerchant()
            {
                name='Joe Smith';
                company = 'Some Company';
                Rank='10';
                phone='555-555-5555';
                status='Not Contacted';
                notes = 'Some Notes';
                owner='Some Person';
                type='somevar';
            }
    }    
    public void buildContactMap(list<Purchase_Order__c> poList)
        {
            
            map<id,id> idMap = new map<id,id>();
            
            list<pinnedMerchant__c> pmlist = [select id, account__c, Purchase_Order__c, Lead__c, opportunity__r.accountID from PinnedMerchant__c where Purchase_Order__c in :POlist];
            set<id> leadSet = new set<id>();
            set<id> actSet = new set<id>();
            for(PinnedMerchant__c p :pmlist)
                {
                    if(p.lead__c!=null){
                        leadSet.add(p.lead__c);
                        idMap.put(p.lead__c,p.Purchase_Order__c);}
                    if(p.opportunity__r.accountID!=null){
                        actSet.add(p.opportunity__r.accountID);
                        idMap.put(p.opportunity__r.accountID,p.Purchase_Order__c);}
                    if(p.account__c!=null){
                        actSet.add(p.account__c);
                        idMap.put(p.account__c,p.Purchase_Order__c);
                       }
                            
                }
                
            list<lead> leadlist = [select id, Phone, Company, Name, Research_Ranking__c, ownerID, owner.name, status, Last_Activity_Date__c, repNotes__c, RepnotesDate__c from lead where id in :leadSet];
            for(lead l:leadlist){
               // pm.add(formatLead(l));
                if(contactMap.get(idMap.get(l.id))==null)
                    {
                        list<pinnedMerchant> tempList = new list<pinnedMerchant>();
                        templist.add(formatLead(l));
                        contactMap.put(idMap.get(l.id),tempList);
                    }else{
                            list<pinnedMerchant> tempList = contactMap.get(idMap.get(l.id));
                            templist.add(formatLead(l));
                            contactMap.put(idMap.get(l.id),tempList);
                         }
                }
            list<contact> contactList =[select Contact.Account.Name, Contact.accountID, Contact.Account.ownerID, Contact.Account.owner.name, Contact.account.RepnotesDate__c, Contact.account.RepNotes__c, Contact.account.Research_Ranking__c, name, phone, Contact.account.Account_Status__c, Contact.account.Most_Recent_Feature__c, Contact.account.Total_Revenue__c from contact where accountID in :actSet];
            for(contact c:contactList){
                if(contactMap.get(idMap.get(c.accountID))==null)
                    {
                        list<pinnedMerchant> tempList = new list<pinnedMerchant>();
                        templist.add(formatContact(c));
                        contactMap.put(idMap.get(c.accountID),tempList);
                    }else{
                            list<pinnedMerchant> tempList = contactMap.get(idMap.get(c.accountID));
                            templist.add(formatContact(c));
                            contactMap.put(idMap.get(c.accountID),tempList);
                         }
                }
            
        }
    public PinnedMerchant formatContact(contact c)
        {
            PinnedMerchant P = new PinnedMerchant();
            p.name=c.name;
            p.RepNotes = c.account.RepNotes__c;
            p.NotesUpdateDate = string.ValueOf(c.account.RepnotesDate__c);
            p.company=c.account.Name;
            p.Rank=c.account.Research_Ranking__c;
            p.Phone=c.phone;
            p.owner=c.Account.owner.name;
            p.status=c.account.Account_Status__c;
            p.Type='Contact';
            p.Parent=c.AccountID;
            p.OwnerID = c.Account.ownerID;
            if(c.account.Total_Revenue__c>0){
                p.NewOld='Featured: '+String.valueof(c.account.Most_Recent_Feature__c);
                }else{ p.NewOld='New Business';}
            return p;
        }    
    public PinnedMerchant formatLead(lead l)
        {
            PinnedMerchant P = new PinnedMerchant();
            p.name=l.name;
            p.company=l.company;
            p.Parent=l.id;
            p.Type='Lead';
            p.Rank=l.Research_Ranking__c;
            p.Phone=l.phone;
            p.status=l.status;
            p.NewOld='New Business';
            p.Owner = l.owner.name;
            p.OwnerID = l.OwnerID;
            p.RepNotes = l.repNotes__c;
            p.NotesUpdateDate = string.ValueOf(l.RepnotesDate__c);
            return p;
        }    
    public string addLimit()
        {
                string s = 'Order by Global_SFDC_Category__c LIMIT ';
                if(division==null)
                        {
                                s+='1';
                        }else
                                {
                                        s+='500';
                                }       
                return s;       
        }    
    public string addWherePO(string s)
        {
                system.debug('=============WHAT IS THE MAX DATE?'+maxDate);
                system.debug('=============WHAT IS THE MIN DATE?'+minDate);
                s+=' WHERE ';
                s+='PO_Status__c != \'Approved\' AND PO_Status__c != \'Expired\' AND Type__c !=\'Now!\'';
                        if(division!=null)
                                s+=' AND division__r.name = \''+string.escapeSingleQuotes(division)+'\'';
                        if(MinDate==null)
                                s+=' AND Target_Feature_Date__c>= '+string.valueof(system.today().toStartOfWeek());
                        if(MinDate!=null)
                                s+=' AND Target_Feature_Date__c>= '+string.valueof(MinDate)+' ';
                        if(MaxDate!=null)
                                s+=' AND Target_Feature_Date__c<= '+string.valueof(MaxDate)+' ';     
                        s+=addLimit();
                        return s;       
        }
    public string addWhereDeal(string s)
        {
                system.debug('=============WHAT IS THE MAX DATE?'+maxDate);
                system.debug('=============WHAT IS THE MIN DATE?'+minDate);
                s+=' WHERE ';
                        s+=' Feature_Date__c !=null AND Type != \'Social Media\' AND Type != \'Sponsorship\' AND Type != \'G-Team\' AND Global_SFDC_Category__c != \'Charity\' ';
                        if(division!=null)
                                s+=' AND Division_Dynamic__r.Name = \''+string.escapeSingleQuotes(division)+'\'';
                        if(MinDate==Null)
                                s+='AND Feature_date__c >= ' +string.valueof(system.today().toStartOfWeek());
                        if(MinDate!=null)
                                s+=' AND feature_date__c >= '+string.valueof(MinDate)+' ';
                        if(MaxDate!=null)
                                s+=' AND feature_date__c <= '+string.valueof(MaxDate)+' ';    
                        s+=addLimit();
                        return s;       
        }
    public string getSOQLPO()
        {
                string soql ='select id, name, Subdivision__r.name, Assigned_To_multi__c, Rep_PO_Notes__c, Deal_Builder_Template__c, Assigned_to__r.name, Target_Revenue__c, Target_GP__c, Example_Deal_1__c, Example_Deal_2__c, Target_Feature_Date__c, Global_SFDC_Category__c,  Division__c,  Global_SFDC_Subcategory_1__c, Global_SFDC_Subcategory_2__c, Ideal_Price_Range__c, PO_notes__c,  PO_Status__c, Type__c FROM Purchase_Order__c'; 
                soql=addWherePO(soql);
                return soql;
        }
    public string getSOQLDeal()
        {
                string soql ='Select id,Nextstep, Account.Name, Amount_of_Multi_Deal_Children__c, Total_GP__c, Feature_End_Date__c, Margin_Percent__c, Value_of_Unit__c, Projected_Multi_Deal_Share_of_GP__c, permalink__c, Subdivision_Dynamic__r.name, type, Unit_Sell_Price__c, Total_Projected_GMS__c, Total_Feature_Projected_GP__c, Owner.Name, OwnerId, Name, Global_SFDC_Subcategory_2__c, Global_SFDC_Subcategory_1__c, Global_SFDC_Category__c, Feature_Date__c, Division_Dynamic__r.Name, Division_Dynamic__c, Deal_Strengh__c From Opportunity';
                soql=addWhereDeal(soql);
                return soql;
                // WHERE Division_Dynamic__r.Name = :division  AND Deal_Strengh__c ='A Sure Thing' ORDER BY feature_date__c ASC LIMIT 250];
        }       
        
        public Pipeline formatPipelineDeal(Opportunity o)
        {
                
            pipeline p = new pipeline();
                    
                   p.type='Deal';
                   if(o.Subdivision_Dynamic__r.name!=null && division!=null) 
                    if(o.Subdivision_Dynamic__r.name!=null && o.Subdivision_Dynamic__r.name.contains(division))
                        {
                            p.subdivision=o.Subdivision_Dynamic__r.name;
                        }else{
                                    p.subdivision='Other';
                                }
                    p.Permalink=o.permalink__c;
                    p.RecordId=o.id;
                    p.MerchantName = o.Account.Name;
                    p.TargetDate=string.valueof(o.feature_date__c);
                    p.category=o.Global_SFDC_Category__c;
                    p.CategoryStyle=formatColor(p.category);
                    p.Subcategory1=o.Global_SFDC_Subcategory_1__c;
                    p.Subcategory2=o.Global_SFDC_Subcategory_2__c;
                    p.PONotes=o.name;
                    p.status=o.deal_strengh__c;
                    p.TotalGP=string.valueof(o.Total_GP__c);
                    p.AssignedTo=o.Owner.name;
                    p.StatusStyle=formatColor(p.status);
                    p.PriceRange=dealStructure(o);
                    p.TargetGP=(string.valueof(o.Total_Feature_Projected_GP__c));
                    p.TargetGMS=(string.valueof(o.Total_Projected_GMS__c));                    
                    p.ViewLink=formatHTML(p,'view','Deal');
                    p.ExampleLink=formatHTML(p,'link','Deal');
                    p.DealType=(o.type);
                    p.EndDate=string.valueof(o.Feature_End_Date__c);
                    //PR
                    p.PM = new list<pinnedMerchant>();
                    p.NextStep=string.valueof(o.NextStep);
                    //PR
                    /*
                    if(p.Status=='A Sure Thing')
                        DB.SureThing=DB.SureThing+1;
                    if(p.status=='Merchant Manager Getting Info' || p.status=='Rep Getting Info')
                        DB.RGI=DB.RGI+1;
                    db.ProjGMS = db.ProjGMS+o.Total_Projected_GMS__c;
                    db.projGP = db.ProjGP+o.Total_Feature_Projected_GP__c;
                    */      
            return p;
        }
    public Pipeline formatPipelinePO(Purchase_order__c po)
        {
            pipeline p = new pipeline();
                    p.recordID=po.id;
                    p.type='PO';
                    if(po.Subdivision__r.name!=null)
                        {
                            p.subdivision=po.Subdivision__r.name;       
                        }else{
                                    p.subdivision='Other';
                                }
                    p.TargetDate=string.valueof(po.Target_feature_date__c);
                    p.category=po.Global_SFDC_Category__c;
                    p.CategoryStyle=formatColor(p.category);
                    p.Subcategory1=po.Global_SFDC_Subcategory_1__c;
                    p.Subcategory2=po.Global_SFDC_Subcategory_2__c;
                    p.PONotes=po.PO_Notes__c;
                    p.status=po.po_status__c;
                    p.TotalGP='';
                    p.AssignedTo=po.Assigned_To_multi__c;
                    p.ExampleDeal1=po.Example_Deal_1__c;
                    p.ExampleDeal2=po.Example_Deal_2__c;
                    p.StatusStyle=formatColor(p.status);
                    p.DealBuilder=po.Deal_Builder_Template__c;
                    p.PriceRange=po.Ideal_Price_Range__c;
                    p.TargetGP=(string.valueof(po.Target_GP__c));
                    p.TargetGMS=(string.valueof(po.Target_Revenue__c));
                    p.WeekOf=string.valueof(po.Target_Feature_Date__c.toStartOfWeek());
                    p.DealType='PO';
                    //Do the HTML formatting here
                    p.ViewLink=formatHTML(p,'view','PO');
                    p.RepNotes = po.Rep_PO_Notes__c;
                    p.PM=contactMap.get(p.RecordId);
                    p.ExampleLink=formatHTML(p,'link','PO');
                                        if(p.TargetGP==null)
                                                p.TargetGP='-';     
                                        if(p.TargetGMS==null)
                                                p.TargetGMS='-';
                                        if(p.subcategory2==null)
                                                p.subcategory2='-';              
                   
            return p;
        }
    public string formatHTML(pipeline p, string h, string t)
        {
                string html='';
                        if(h=='view')
                                {
                                        if(t=='PO')
                                                {
                                                        html='<a href=\"https://na8.salesforce.com/'+p.RecordId+'\" target=\"_blank\" >PO</a>';
                                                }else
                                        if(t=='Deal')
                                                {
                                                        html='<a href=\"https://na8.salesforce.com/'+p.RecordId+'\" target=\"_blank\">SF Deal</a><br/>';
                                                        if(p.Permalink!=null)
                                                                html+='<a href=\"http://www.groupon.com/deals/'+p.Permalink+'\" target=\"_blank\">Live Deal</a><br/>';
                                                }
                                }
                        if(h=='link')
                                {
                                        if(t=='PO')
                                                {
                                                        if(p.ExampleDeal1!=null)
                                                                html+='<a href=\"'+p.ExampleDeal1+'\"target=\"_blank\">Ex Deal 1</a><br/>';
                                                        if(p.ExampleDeal2!=null)
                                                                html+='<a href=\"'+p.ExampleDeal2+'\"target=\"_blank\">Ex Deal 2</a><br/>';
                                                        if(p.DealBuilder!=null)
                                                                html+='<a href=\"'+p.DealBuilder+'\"target=\"_blank\">Deal Builder</a><br/>';         
                                                }else
                                                if(t=='Deal')
                                                        {
                                                               html='';
                                                        }
                                }       
                return html;    
        }    

    public string dealStructure(opportunity o)
        {
                string a = 'Price: $'+ o.Unit_Sell_Price__c+' Value: $'+o.Value_of_Unit__c+' Margin: '+o.Margin_Percent__c+'%';
                if(o.Amount_of_Multi_Deal_Children__c>0)
                        {
                                a+=' # Options: ' +(1+o.Amount_of_Multi_Deal_Children__c);
                        }
                
                return a;
        }        
    public string formatColor(string s)
        {
                string style='';
                if(s=='Restaurant'){
                                                style='background-color:brown; color:white;';
                        }else if(s=='Beauty'){
                                style='background-color:#514689; color:white;';
                        }else if(s=='Wellness'){
                                style='background-color:#E35205; color:white;';
                        }else if(s=='Healthcare'){
                                style='background-color:#C5299B; color:white;';
                        }else if(s=='Leisure Offers'){
                                style='background-color:#F2A900;';
                        }else if(s=='Services'){
                                style='background-color:#89B555; color:white;';
                        }else if(s=='Shopping'){
                                style='background-color:#cfeef6;';
                        }else if(s=='GrouponLive' || s=='Tickets'){
                                style='background-color:#4BC1DE; color:white;';
                        }else if(s=='Approved'){
                                style='background-color:#2D2926; color:white;';
                        }else if(s=='Submitted' || s=='Recommended' || s=='Vetted'){
                                style='background-color:#C4BFB6;';
                        }else if(s=='A Sure Thing'){
                                style='background-color:#2D2926; color:white;';
                        }else if(s=='Rep Getting Info'){
                                style='background-color:#BA0C2F; color:white;';
                        }else if(s=='Merchant Manager Getting Info'){
                                style='background-color:#BA0C2F; color:white;';
                        }else if(s=='Open'){
                                style='background-color:white; color:black;';
                        }else if(s=='Expired'){
                                style='background-color:white; color:gray;';
                        }
                return style;           
        }


public void getaddUserToMultiAssign()
         {
              //list<string> assignedtoName = new list<string> ();
              assignedtoName.add(assignedto);
         }                     
public void addMultiAssign(string splitString, id poID)
         {
           string[] AssignedArray = splitString.split(';',8);
           list<assignedTo__c> InsertList = new list<AssignedTo__c>();
           for(string s : AssignedArray)
               {
                   id i = getUserId(s);
                   user u = new user(id=i);
                   //system.debug('++++++++++++++++++++++hello'+u.id);
                   AssignedToMulti.add(u.id);
                   system.debug('!!!!!!!!!!!!!!!!!!!!!hello'+AssignedToMulti);
               }
           for(id u: AssignedToMulti)
               {
                   AssignedTo__c AsTo = new AssignedTo__c(purchase_order__c=poID, assigned_To__c=u);
                   //system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~hello'+poID);
                   IF (AsTo.Assigned_To__c != null)
                       {
                            InsertList.add(AsTo);   
                       }
               }
            insert InsertList;       
         }


    public list<string> getuserNames()
        {
            list<string> returnString = new list<string>();
            list<user> ulist = [select name from user where isactive=true order by name];
            for(user u: ulist)
                { 
                    returnString.add('\"'+u.name+'\"');
                }
           return ReturnString;     
        }  
    
    global id getDivisionId(string divname)
        {
            Division__c d = [select id from division__c where name =:divname limit 1];
            id i = d.id;
            return i;
        }
    global id getSubdivisionId(string subdivname)
        {
                id i = null;
            List<Subdivision__c> s = [select id from subdivision__c where name =:subdivname limit 1];
            if(s!=null)
                {
                            for(Subdivision__c sn: s)
                                {
                                        i = sn.id;
                                }
                }       
            return i;
        }
      public id getUserId(string assigned)
        {
            id i = null;
            list<user> u = [select id from user where name =:Assigned limit 1];
            if(u!=null)
                {
                    for(user un:u)
                        i=un.id;
                }
                
            return i;
        }  
     public decimal ConvertString(string x) 
        {
                decimal d =0;
                if(x!=null)
                        {
                            x = x.replace(',','');
                            x = x.replace('$','');
                            d=decimal.valueof(x);
                        }   
                return d;       
        }                  
    
     public void createPO()
         {
             system.debug('---------------------CREATING A PO');
             Purchase_Order__c p = new Purchase_Order__c();
                     p.division__c = getDivisionId(division);  
                     p.Target_Feature_Date__c = TargetDate;   
                     if(SubdivisionName!=null && subdivisionName!='Other')p.subdivision__c = getSubdivisionID(SubdivisionName); 
                     p.global_sfdc_category__c = CategoryInput; 
                     p.Global_SFDC_Subcategory_1__c = SubCategory1Input;
                     p.Global_SFDC_Subcategory_2__c = SubCategory2Input;
                     p.PO_Notes__c = PONotes;
                     p.po_status__c = 'Open';
                     //p.Assigned_to__c = getUserId(AssignedTo);  
                     p.Example_deal_1__c = ExDeal1;
                     P.Example_deal_2__c = ExDeal2; 
                     P.Deal_Builder_Template__c = dealbuilderteamplate;     
                     p.Ideal_Price_Range__c = IdealPrice; 
                     p.Target_GP__c=ConvertString(TargetGP);  
                     p.Target_Revenue__c=ConvertString(TargetGMS);
                     system.debug(p);
               try{
                   insert p;
                       }catch (exception e){
                       system.debug('error msg here===================='+e);
                       }
                if(assignedToArray!=null)addMultiAssign(AssignedToArray,p.ID);
             
              resetVars(); 

         }
     public void resetVars()
         {
             TargetDate=null;
             AssignedToArray=null;

         }
     public string getAllDivisions()
         {
                list <string> divList = new list<string>();
                list <division__c> allDivs = [select name from Division__c order by name asc];
                for(division__c d: allDivs)
                        {
                               string a = d.name;
                               a = a.replaceAll('/','');
                               divList.add(a);
                        }
               string s = JSON.serialize(divList);   
               return s;      
         }     
     public list <string> getDivisionList()
        {
                list <string> divList = new list<string>();
                list <division__c> allDivs = [select name from Division__c order by name asc];
                for(division__c d: allDivs)
                        {
                                divList.add('\"'+d.name+'\"');

                        }
                return divList; 
        }
     public list<division__c> getDivList()
         {
             list <division__c> allDivs = [select name from Division__c order by name asc];
             return allDivs;
         }   
   
     public list<string> getSubdivisionList()
         {
             string query = 'select id, name from subdivision__c order by Name ASC';
             //query+=' WHERE Division__r.name = \''+division+'\'';
             list<subdivision__c> subDivList= database.query(query);
             list<string> returnString = new list<string>();
             for(subdivision__c s:subDivList)
                 returnString.add('\"'+s.name+'\"');
                 
             return returnString;    
         }  
     @RemoteAction    
     public static list<string> getSubdivisionList(string division)
         {
             string query = 'select id, name from subdivision__c';
             query+=' WHERE Division__r.name = \''+division+'\' ORDER BY Rank__c';
             list<subdivision__c> subDivList= database.query(query);
             list<string> returnString = new list<string>();
             for(subdivision__c s:subDivList)
                 returnString.add(''+s.name+'');
             returnString.add('Other');    
             return returnString;    
         }
     @RemoteAction     
     public static list<Pipeline> getPipelineResultList(string division, string startDate, string endDate )
        {
                perfectPipeline pp = new PerfectPipeline();
                
                pp.Division=division;
                pp.MinDate=date.parse(startDate);
                pp.MaxDate=date.parse(endDate);
                
                list<pipeline> ResultList = new list<pipeline>();
                string queryPO = pp.getSOQLpo();
                string queryDeal = pp.getSOQLDeal();
                list<Purchase_Order__c> POlist = database.query(queryPO);
                list<opportunity> oList = database.query(queryDeal);
                pp.buildContactMap(POlist);
                for(Purchase_Order__c po :POList)
                        {
                                pipeline p = pp.formatPipelinePO(po);
                    //            addToPipelineMap(p);
                                ResultList.add(p);
                        }
                for(opportunity o :OList)
                        {
                                pipeline p = pp.formatPipelineDeal(o);
                  //              addToPipelineMap(p);
                                ResultList.add(p);
                        }
                //scheduleData = createSchedule();
                resultList = pp.sortResults(resultList,startDate,endDate);                
                return ResultList;
        }   
     public list<pipeline> sortResults(list<pipeline> plist,string startDate, string endDate)
         {
             map<string,list<pipeline>> sorter = new map<string,list<pipeline>>();
             list<pipeline> ReturnList = new list<pipeline>();
             date tempDate = date.parse(startDate);
             do{
                list<pipeline> r = new list<pipeline>();
                sorter.put(string.valueOf(tempDate), r);
                tempDate= tempDate.addDays(1);
             }while(tempDate<=date.parse(endDate));
             for(pipeline p:plist)
                 {
                     list<pipeline> a = sorter.get(p.TargetDate);
                     a.add(p);
                     sorter.put(p.TargetDate,a);
                 }
            tempDate = date.parse(startDate);
             do{
                ReturnList.addAll(sorter.get(string.valueOf(tempDate)));
                tempDate= tempDate.addDays(1);
             }while(tempDate<=date.parse(endDate));     
            return ReturnList;    
         }                   
        
private testMethod static void testRelevantLeads(){
        
        
        user u = [select id, name from user where lastname='Bland' limit 1];
        Purchase_Order__c po = new Purchase_Order__c();
        
        
        Division__c d = new Division__c(name='Hampton Roads', State__c = 'VA');
        insert d;
        
        Date date1 = date.newinstance(2011, 10, 09);
        Date date2 = date.newinstance(2011, 10, 25);
        
        Subdivision__c s = new Subdivision__c(name='TestSubdiv');
        
        try{insert s;}catch(exception e){system.debug(e);}
        
        
        Lead L = new lead(company='Some Company', status='Status', Lastname='First name', Division__c='Chicago');
        try{database.insert(l);}catch(exception e){}
        
        po.assigned_to__c = '00580000003PoQL';
        po.Global_SFDC_Category__c = 'Restaurant';
        po.Global_SFDC_Subcategory_1__c = 'Bar';
        po.assigned_to__c=u.id;
        po.division__c = d.id;
        po.subdivision__c=s.id;
        po.Global_SFDC_Category__c='Test';
        po.Global_SFDC_Subcategory_1__c='Test1';
        po.Global_SFDC_Subcategory_2__c='Test2';
        po.PO_notes__c='Notes';
        po.PO_Status__c='Open';
        po.Target_Feature_Date__c = system.today();
        
        insert po;
        
        PerfectPipeline con = new PerfectPipeline();
        //string tester = con.getPerfectPipeline();
        con.division='Hampton Roads';
        PageReference pref = Page.POSystem;
        Test.setCurrentPage(pref); 
        pref.getParameters().put('division', 'Hampton Roads');
        
        con.DivisionName ='Hampton Roads';
        con.SubDivisionName='Peninsula(Hampton Roads)';
        con.CategoryInput ='Food & Drink';
        con.Subcategory1Input = 'Sub1';
        con.Subcategory2Input = 'sub2';
        con.PONotes='Po Notes';
        con.AssignedToArray='Chris Bland;';
        con.TargetDate = date1;
        con.ExDeal1='Ex1';
        con.ExDeal2='ex2';
        con.DealBuilderTeamplate='Dbtemplate';
        con.IdealPrice='15';
        con.TargetGP='5';
        con.TargetGMS='6';
        con.MaxDate=date2;
        con.minDate=date1;

        con.createPO();
        list<string> div = con.getDivisionList();
        list<string> un = con.getuserNames();
        //list<schedule> sch = con.getSchedule();
        list<string> sibdv = PerfectPipeline.getSubdivisionList('Chicago');
        list<string> somesoubdivs = con.getSubdivisionList();
        list<division__c> divlist = con.getDivList();
        string AllDivs = con.getAllDivisions();
        Pipeline Pipeline_test = con.formatPipelinePO(po); 
        //Purchase_order__c FindPO = con.findPO(po.id);
        list<pipeline> pipeline_list = PerfectPipeline.getPipelineResultList('chicago','12/15/2011','12/16/2011');
        list<Pipeline> resultsListtest = con.getResultList();
        list<subdivision__c> subdivisionListTest = con.getSubDiv();
        movePO(po.id, '12/15/2011', sibdv[0]);
        createNewTask('taks body', u.id, u.id, 'contact');
        updateNotes(po.id, 'some notes');
        addPinnedNotes(l.id, 'some notes');
        addRepNotes(po.id, 'some notes'); 
        pinnedMerchant PMtest = new pinnedMerchant();
        PMtest = con.formatLead(l);
        /*
        //list<string> status = con.status();
        list<string> un = con.getuserNames();
        list<string> sd = con.getSubdivisionList();
        list<purchase_order__c> polost = con.getpomy();
        list<string> divlist = con.getDivisionList();
        tester = con.getPerfectPipeline();
        */

        //System.assertEquals(expected, actual);
    }

private testMethod static void testCreatePO(){
    string poJSonString = '{\"Category\":\"Beauty\",\"SubCategory1\":\"Beauty\",\"SubCategory2\":\"Makeup\",\"Division\":\"Chicago\",\"subDivision\":\"TestSubdiv\",\"PONotes\":\"Rails notes\",\"DealBuilder\":\"\",\"IdealPrice\":\"20-30\",\"TargetGP\":\"1000\",\"TargetGMS\":\"1000\",\"MultiAssign\":\"Aaron Bedra;Aaron Cooper;\",\"TargetFeatureDate\":\"02/10/2012\"}"';

 //  string poJsonString = '{\"PONotes\":\"po notes again\",\"TargetFeatureDate\":\"02/14/2012\",\"DealBuilder\":\"Deal Builder Link\",\"ExampleDeal1\":\"Example Deal 1\",\"TargetGP\":5000,\"IdealPrice\":\"$50-$100\",\"Division\":\"Chicago\",\"subDivision\":\"Downtown - North(Chicago)\",\"SubCategory1\":\"Flying\",\"Category\":\"Leisure Offers\",\"SubCategory2\":\"Helicopter Rides\",\"ExampleDeal2\":\"Example Deal 2\",\"MultiAssign\":\"Aaron Bedra;Aaron Cooper\"}';
   
    Purchase_order po = new Purchase_Order();
    po = (Purchase_Order)JSON.deserialize(poJsonString, Purchase_order.class);

    Purchase_Order po_new = addPO(po);
   
    string expected = 'Chicago';
    string actual = po_new.division;
    system.assertEquals(expected,actual);
    
}     
    
}