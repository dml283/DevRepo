trigger MultiAssignPOnew on AssignedTo__c (after insert, after update, before delete){
   id PoIds;
   string MultiAssignVal = ''; 
   set<string> MultiAssignSet = new set<string>();
   id DelAsToIds;
   //lets get all of the IDs of the POs we will work with
   IF(Trigger.isAfter){
       for (AssignedTo__c AsToObj :Trigger.new){
               PoIds = AsToObj.Purchase_Order__c;
           }
       }
   IF(Trigger.isDelete){
       for (AssignedTo__c AsToObj :Trigger.old){
               PoIds = AsToObj.Purchase_Order__c;
               DelAsToIds = AsToObj.Id;
           }    
       }        
   //now lets get a list of POs we will work with
   List<Purchase_Order__c> relatedPOs = [SELECT id, Assigned_To_Multi__c
                                         FROM Purchase_Order__c
                                         WHERE id = :PoIds]; 
       //iterate over the list of POs                                     
       for(Purchase_order__c p :relatedPOs){
               string name ='';
               //iterate over the assigned to
               for(AssignedTo__c a : [SELECT id, Purchase_Order__c, Assigned_To__r.Full_Name__c
                                      FROM AssignedTo__c
                                      WHERE Purchase_Order__c = :p.id]){
                       //now we check if the assigned to belongs to the PO we are iterating over in the first loop, if it is, add it to the string name
                       if(a.Purchase_Order__c == p.id){
                               if(a.Assigned_To__r.Full_Name__c !=null){
                                      if(a.Purchase_Order__c == PoIds){
                                              MultiAssignVal += a.Assigned_To__r.Full_Name__c + '; ';
                                              name = MultiAssignVal;
                                          }
                                      if(a.id == DelAsToIds){
                                              p.Assigned_To_Multi__c = '';
                                              MultiAssignVal = p.Assigned_To_Multi__c;
                                              name = MultiAssignVal.replace(a.Assigned_To__r.Full_Name__c,'');
                                          }    
                                   }    
                           }
                   }
                //set the value of the multi-assigned in the PO   
                p.Assigned_To_Multi__c = name;
           }
           //make a DML statement to update the POs
           update relatedPOs;
}