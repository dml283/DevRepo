//
// This class is versioned: git clone github:sales-and-planning-tools/mocha-apex-endpoints
//

@isTest
global class LibrarySimpleISODatetimeTests {

    static testMethod void testFormat() {
        Datetime datetimeValue = Datetime.newInstanceGmt(2012, 1, 1, 12, 0, 0);

        LibrarySimpleISODatetime libraryDatetimeValue = new LibrarySimpleISODatetime(datetimeValue);
        String formattedDateTime = libraryDatetimeValue.formatISO8601();

        Integer current = Integer.valueOf(formattedDateTime.substring(11, 13));
        Integer offset = Integer.valueOf(formattedDateTime.substring(19, 22).replace('+', ''));

        System.assertEquals(12, current - offset);
    }

    static testMethod void testFormatGmt() {
        String correctString = '2012-08-31T02:12:18+0000';
        Datetime datetimeValue = Datetime.newInstanceGmt(2012, 8, 31, 2, 12, 18);

        LibrarySimpleISODatetime libraryDatetimeValue = new LibrarySimpleISODatetime(datetimeValue);
        String formattedDateTime = libraryDatetimeValue.formatISO8601Gmt();

        System.assertEquals(correctString, formattedDateTime);
    }

    static testMethod void testParseGmt() {
        Datetime correctDate = Datetime.newInstanceGmt(2012, 8, 31, 2, 12, 18);

        String datetimeString = '2012-08-31T02:12:18Z';
        Datetime datetimeValue = LibrarySimpleISODatetime.parseISO8601(datetimeString);

        System.assertEquals(correctDate, datetimeValue);
    }

    static testMethod void testParseTimezoneWithColon() {
        Datetime correctDate = Datetime.newInstanceGmt(2012, 8, 31, 3, 12, 18);

        String datetimeString = '2012-08-31T02:12:18-01:00';
        Datetime datetimeValue = LibrarySimpleISODatetime.parseISO8601(datetimeString);

        System.assertEquals(correctDate, datetimeValue);
    }

    static testMethod void testParseTimezoneWithFractionalHour() {
        Datetime correctDate = Datetime.newInstanceGmt(2012, 8, 31, 3, 42, 18);

        String datetimeString = '2012-08-31T02:12:18-01:30';
        Datetime datetimeValue = LibrarySimpleISODatetime.parseISO8601(datetimeString);

        System.assertEquals(correctDate, datetimeValue);
    }

    static testMethod void testParseTimezoneWithoutColon() {
        Datetime correctDate = Datetime.newInstanceGmt(2012, 8, 31, 3, 42, 18);

        String datetimeString = '2012-08-31T02:12:18-0130';
        Datetime datetimeValue = LibrarySimpleISODatetime.parseISO8601(datetimeString);

        System.assertEquals(correctDate, datetimeValue);
    }

    static testMethod void testParseTimezoneNextDayInGmt() {
        Datetime correctDate = Datetime.newInstanceGmt(2012, 8, 31, 4, 12, 18);

        String datetimeString = '2012-08-30T23:12:18-05:00';
        Datetime datetimeValue = LibrarySimpleISODatetime.parseISO8601(datetimeString);

        System.assertEquals(correctDate, datetimeValue);
    }

    static testMethod void testParseTimezonePreviousDayInGmt() {
        Datetime correctDate = Datetime.newInstanceGmt(2012, 8, 29, 21, 12, 18);

        String datetimeString = '2012-08-30T02:12:18+05:00';
        Datetime datetimeValue = LibrarySimpleISODatetime.parseISO8601(datetimeString);

        System.assertEquals(correctDate, datetimeValue);
    }
}