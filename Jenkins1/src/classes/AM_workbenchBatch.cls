public class AM_workbenchBatch {
  private Iterator< Id > iterator;
  private Integer batchSize;

  public AM_workbenchBatch(Set<Id> ids, Integer batchSize) {
    iterator = new List< Id >( ids ).iterator();
    this.batchSize = batchSize;
  }

  public boolean hasNext(){
    return iterator.hasNext();
  }

  public Set< id > next(){
    Set< id > result = new Set< Id >();
    for( Integer i = 0; (i < batchSize && iterator.hasNext()); i++ )
    {
      result.add( iterator.next() );
    }
    return result;
  }
}