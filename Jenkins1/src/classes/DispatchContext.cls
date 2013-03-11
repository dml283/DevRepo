/**
 * Captures the state of System and Trigger context at a single point in time.
 *
 * Also used in tests to separate business logic from direct dependence on System and Trigger state.
 */
public virtual class DispatchContext {

  protected List<SObject> newList = new List<SObject>();
  protected List<SObject> oldList = new List<SObject>();
  protected Map<Id, SObject> newMap = new Map<Id, SObject>();
  protected Map<Id, SObject> oldMap = new Map<Id, SObject>();

  protected Boolean isFuture = false;
  protected Boolean isBatch = false;
  protected Boolean isScheduled = false;
  protected Boolean isTrigger = false;

  protected Boolean isInsert = false;
  protected Boolean isUpdate = false;
  protected Boolean isDelete = false;
  protected Boolean isUndelete = false;
  protected Boolean isBefore = false;
  protected Boolean isAfter = false;

  public DispatchContext() {
    initialize();
  }

  /**
   * Returns a list of the new versions of the sObject records.
   * Note that this sObject list is only available in insert and update triggers, and the records can only be modified in before triggers.
   */
  public List<SObject> newList() {
    return newList;
  }

  /**
   * A map of IDs to the new versions of the sObject records.
   * Note that this map is only available in before update, after insert, and after update triggers.
   */
  public Map<Id, SObject> newMap() {
    return newMap;
  }

  /**
   * Returns a list of the old versions of the sObject records.
   * Note that this sObject list is only available in update and delete triggers.
   */
  public List<SObject> oldList() {
    return oldList;
  }

  /**
   * A map of IDs to the old versions of the sObject records.
   * Note that this map is only available in update and delete triggers.
   */
  public Map<Id, SObject> oldMap() {
    return oldMap;
  }

  public List<SObject> changedList(DispatchContextFilter contextFilter) {
    if (! isUpdate()) {
      return newList();
    }

    List<SObject> newObjects = new List<SObject>();
    for (SObject newObject : newList()) {
      SObject oldObject = oldMap().get(newObject.Id);
      if (contextFilter.filter(oldObject, newObject)) {
        newObjects.add(newObject);
      }
    }
    return newObjects;
  }

  public Set<Id> changedIds(DispatchContextFilter contextFilter) {
    return changedIds(changedList(contextFilter));
  }

  public Set<Id> changedIds(List<SObject> newObjects) {
    return changedMap(newObjects).keySet();
  }

  public Map<Id, SObject> changedMap(DispatchContextFilter contextFilter) {
    return changedMap(changedList(contextFilter));
  }

  public Map<Id, SObject> changedMap(List<SObject> newObjects) {
    Map<Id, SObject> changed = new Map<Id, SObject>();
    for (SObject newObject : newObjects) {
      changed.put(newObject.Id, newObject);
    }
    return changed;
  }

  /**
   * Returns true if the currently executing code is invoked by code contained in a method annotated with future; false otherwise.
   * Since a future method can't be invoked from another future method, use this method to check if the current code is
   *  executing within the context of a future method before you invoke a future method.
   */
  public Boolean isFuture() {
    return isFuture;
  }

  /**
   * Returns true if the currently executing code is invoked by a batch Apex job; false otherwise.
   * Since a future method can't be invoked from a batch Apex job, use this method to check if the currently executing code is a batch Apex job before you invoke a future method.
   */
  public Boolean isBatch() {
    return isBatch;
  }

  /**
   * Returns true if the currently executing code is invoked by a scheduled Apex job; false otherwise.
   */
  public Boolean isScheduled() {
    return isScheduled;
  }

  /**
   * Returns true if the current context for the Apex code is a trigger, not a Visualforce page, a Web service, or an executeanonymous() API call.
   */
  public Boolean isTrigger() {
    return isTrigger;
  }

  /**
   * Returns true if this trigger was fired due to an insert operation, from the Salesforce user interface, Apex, or the API.
   */
  public Boolean isInsert() {
    return isInsert;
  }

  /**
   * Returns true if this trigger was fired due to an update operation, from the Salesforce user interface, Apex, or the API.
   */
  public Boolean isUpdate() {
    return isUpdate;
  }

  /**
   * Returns true if this trigger was fired due to a delete operation, from the Salesforce user interface, Apex, or the API.
   */
  public Boolean isDelete() {
    return isDelete;
  }

  /**
   * Returns true if this trigger was fired before any record was saved.
   */
  public Boolean isBefore() {
    return isBefore;
  }
  
  /**
   * Returns true if this trigger was fired after all records were saved.
   */
  public Boolean isAfter() {
    return isAfter;
  }
  
  /**
   * Returns true if this trigger was fired after a record is recovered from the Recycle Bin (that is, after an undelete operation from the Salesforce user interface, Apex, or the API.)
   */
  public Boolean isUndelete() {
    return isUndelete;
  }

  protected virtual void initialize() {
    newList = Trigger.new;
    oldList = Trigger.old;
    newMap = Trigger.newMap;
    oldMap = Trigger.oldMap;

    isFuture = System.isFuture();
    isBatch = System.isBatch();
    isScheduled = System.isScheduled();
    isTrigger = Trigger.isExecuting; 

    isInsert = Trigger.isInsert;
    isUpdate = Trigger.isUpdate;
    isDelete = Trigger.isDelete;
    isUndelete = Trigger.isUndelete;
    isBefore = Trigger.isBefore;
    isAfter = Trigger.isAfter;
  }

}