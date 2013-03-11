public class AM_workbenchBatchTest {
  private static Id id1 = '00300000003T2PGAA0';
  private static Id id2 = '00300000003T2PGAA1';
  private static Id id3 = '00300000003T2PGAA2';

  static testMethod void test1Item() {
    Set< id > ids = new Set< id >();
    ids.add( id1 );

    AM_WorkbenchBatch batcher = new AM_WorkbenchBatch( ids, 1 );
    System.assertEquals( true, batcher.hasNext() );
    System.assertEquals( true, batcher.next().contains( id1 ));
    System.assertEquals( false, batcher.hasNext() );
  }

  static testMethod void test2Items() {
    Set< id > ids = new Set< id >();
    ids.add( id1 );
    ids.add( id2 );

    AM_WorkbenchBatch batcher = new AM_WorkbenchBatch( ids, 1 );
    Set< Id > result = new Set< Id >();
    System.assertEquals( true, batcher.hasNext() );
    result.addAll( batcher.next() );
    System.assertEquals( true, batcher.hasNext() );
    result.addAll( batcher.next() );
    System.assertEquals( true, result.contains( id1 ));
    System.assertEquals( true, result.contains( id2 ));
    System.assertEquals( false, batcher.hasNext() );
  }

  static testMethod void testBatchSize2() {
    Set< id > ids = new Set< id >();
    ids.add( id1 );
    ids.add( id2 );

    AM_WorkbenchBatch batcher = new AM_WorkbenchBatch( ids, 2 );
    Set< Id > result = new Set< Id >();
    System.assertEquals( true, batcher.hasNext() );
    result.addAll( batcher.next() );
    System.assertEquals( false, batcher.hasNext() );
    System.assertEquals( true, result.contains( id1 ));
    System.assertEquals( true, result.contains( id2 ));
  }

  static testMethod void testUnevenBatches() {
    Set< id > ids = new Set< id >();
    ids.add( id1 );
    ids.add( id2 );
    ids.add( id3 );
  
    AM_WorkbenchBatch batcher = new AM_WorkbenchBatch( ids, 2 );
    Set< Id > result = new Set< Id >();
    System.assertEquals( true, batcher.hasNext() );
    result.addAll( batcher.next() );
    System.assertEquals( true, batcher.hasNext() );
    result.addAll( batcher.next() );
    System.assertEquals( false, batcher.hasNext() );
    System.assertEquals( true, result.contains( id1 ));
    System.assertEquals( true, result.contains( id2 ));
    System.assertEquals( true, result.contains( id3 ));
  }
}