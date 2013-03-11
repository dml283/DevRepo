public class OpptyTriggerHelper {
    
    private static boolean alreadyFiredTrigger = false;
    
    public static boolean hasAlreadyFiredTrigger()
        {
            return alreadyFiredTrigger;
        }
        
   public static void setAlreadyFiredTrigger()
       {
           alreadyFiredTrigger = true;
       }
       
}