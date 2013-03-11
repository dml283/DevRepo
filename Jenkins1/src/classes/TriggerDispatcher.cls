public class TriggerDispatcher {
  
  private static Map<String, DispatchClient> activeClients = new Map<String, DispatchClient>();

  public static void dispatch(DispatchClient client) {
    String clientName = client.getName();
    DispatchClient active = activeClients.get(clientName);

    if (active == null) {
      try {
        activeClients.put(clientName, client);
        client.execute(getContext()); 
      } finally {
        activeClients.remove(clientName);
      }
    } else {
      client.resume(getContext());
    }
  }

  private static DispatchContext getContext() {
    return new DispatchContext();
  }

}