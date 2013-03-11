global class LibraryDate {

    public static Date toDate( String dateString ) {
        if ( dateString != '' && dateString != null ) {
            return Date.parse( dateString );
        } else {
            return null;
        }
    }

    public static String toStringUsingLocaleFormat( Date thisDate ) {
        if ( thisDate != null ) {
            return thisDate.format();    
        } else {
            return null;
        }
    }
}