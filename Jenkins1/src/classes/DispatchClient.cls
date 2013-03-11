public abstract class DispatchClient {

  public abstract void execute(DispatchContext context);
  public abstract void resume(DispatchContext context);

  public String getName() {
    return String.valueOf(this).split(':')[0];
  }
  
}