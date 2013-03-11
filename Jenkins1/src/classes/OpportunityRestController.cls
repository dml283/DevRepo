@RestResource(urlMapping='/opportunity/*')
global class OpportunityRestController{

@HttpPut
   global static Opportunity updateOpportunity(String id, String notes){
   
   PerfectPipeline.addRepNotes(id,notes);
   Opportunity op = PerfectPipeline.findOpportunity(id);
   return op;
   
   }

   
   }