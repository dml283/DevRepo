global class LibraryString {

  public static Boolean exists_and_is_not_blank( String providedString ) {

    return ( providedString != null && providedString != '' );
  }

  public static Boolean exist_and_are_not_blank( String string1, String string2 ) {
    return ( exists_and_is_not_blank( string1 ) && exists_and_is_not_blank( string2 ) );
  }

  public static String truncate( String givenString, Integer max_length ) {

    if ( LibraryString.exists_and_is_not_blank( givenString ) ) {

      Integer actual_length = givenString.length();
      return givenString.substring( 0, Math.min( actual_length, max_length ) );
    }
    else {
      return '';
    }
  }

}