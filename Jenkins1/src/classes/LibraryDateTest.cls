@isTest
public class LibraryDateTest {

  static void setUp() {
    System.assertEquals( 'en_US', UserInfo.getLocale() );
  }

  // NOTE: unspecified locale

  // Format 1: MM/DD/YYYY
  static testMethod void testParseFormat01WithNoLeadingZeros() {
    setUp();
    Date newDate = LibraryDate.toDate( '12/10/2012' );
    System.assertEquals( '12/10/2012', newDate.format() );
  }

  static testMethod void testParseFormat01WithLeadingZeroOnDay() {
    setUp();
    Date newDate = LibraryDate.toDate( '12/01/2012' );
    System.assertEquals( '12/1/2012', newDate.format() );
  }

  static testMethod void testParseFormat01WithLeadingZeroOnMonth() {
    setUp();
    Date newDate = LibraryDate.toDate( '02/11/2012' );
    System.assertEquals( '2/11/2012', newDate.format() );
  }

  static testMethod void testParseFormat01WithLeadingZeroOnDayAndMonth() {
    setUp();
    Date newDate = LibraryDate.toDate( '02/01/2012' );
    System.assertEquals( '2/1/2012', newDate.format() );
  }

  // Format 2: M/D/YYYY

  static testMethod void testParseFormat01WithSingleDigitOnDay() {
    setUp();
    Date newDate = LibraryDate.toDate( '12/1/2012' );
    System.assertEquals( '12/1/2012', newDate.format() );
  }

  static testMethod void testParseFormat01WithSingleDigitOnMonth() {
    setUp();
    Date newDate = LibraryDate.toDate( '2/11/2012' );
    System.assertEquals( '2/11/2012', newDate.format() );
  }

  static testMethod void testParseFormat01WithSingleDigitOnDayAndMonth() {
    setUp();
    Date newDate = LibraryDate.toDate( '2/1/2012' );
    System.assertEquals( '2/1/2012', newDate.format() );
  }

}