@isTest
public class AM_workbenchMerchantTaskFactoryTest {
  static testMethod void defaultStatusIsCompleted() {
    Task t = new Task();
    t.WhatId = '00300000003T2PGAA0';
    t.Subject = 'Prep: Feature Date Confirmed';
    t.Status = 'Not Started';

    AM_workbench.MerchantTask mt = new AM_workbenchTaskFactory.Us().build( t, t.Subject, t.WhatId );
    System.assertEquals( 'Completed', mt.status );
  }

  static testMethod void featureDateConfirmedUSTest() {
    Task t = new Task();
    t.WhatId = '00300000003T2PGAA0';
    t.Subject = 'Prep: Feature Date Confirmed';
    t.Status = 'Not Started';

    AM_workbench.MerchantTask mt = new AM_workbenchTaskFactory.Us().build( t, t.Subject, t.WhatId );
    System.assertEquals( t.Id, mt.id );
    System.assertEquals( t.Subject, mt.subject );
    System.assertEquals( 4, mt.statuses.size() );
    System.assertEquals( 'Not Started', mt.statuses[0] );
    System.assertEquals( 'In Progress', mt.statuses[1] );
    System.assertEquals( 'Deferred', mt.statuses[2] );
    System.assertEquals( 'Completed', mt.statuses[3] );
    System.assertEquals( true, mt.openModal );
  }

  static testMethod void previewDeliveredUSTest() {
    Task t = new Task();
    t.WhatId = '00300000003T2PGAA0';
    t.Subject = 'Prep: Preview Delivered';
    t.Status = 'Not Started';

    AM_workbench.MerchantTask mt = new AM_workbenchTaskFactory.Us().build( t, t.Subject, t.WhatId );
    System.assertEquals( t.Id, mt.id );
    System.assertEquals( t.Subject, mt.subject );
    System.assertEquals( 3, mt.statuses.size() );
    System.assertEquals( 'Not Started', mt.statuses[0] );
    System.assertEquals( 'Waiting on someone else', mt.statuses[1] );
    System.assertEquals( 'Completed', mt.statuses[2] );
    System.assertEquals( true, mt.openModal );
  }

  static testMethod void previewDeliveredInternationalTest() {
    Task t = new Task();
    t.WhatId = '00300000003T2PGAA0';
    t.Subject = 'Prep: Preview Delivered';

    AM_workbench.MerchantTask mt = new AM_workbenchTaskFactory.International().build( t, t.Subject, t.WhatId );
    System.assertEquals( t.Id, mt.id );
    System.assertEquals( t.Subject, mt.subject );
    System.assertEquals( 4, mt.statuses.size() );
    System.assertEquals( 'Not Started', mt.statuses[0] );
    System.assertEquals( 'In Progress', mt.statuses[1] );
    System.assertEquals( 'Waiting on someone else', mt.statuses[2] );
    System.assertEquals( 'Completed', mt.statuses[3] );
    System.assertEquals( true, mt.openModal );
  }
}