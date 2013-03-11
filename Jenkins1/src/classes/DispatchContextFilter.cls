public interface DispatchContextFilter {

  Boolean filter(SObject oldObject, SObject newObject);
    
}