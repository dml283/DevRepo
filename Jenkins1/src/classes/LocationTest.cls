public class LocationTest {

    @istest
    public static void testSetGet() {

        Location location = new Location();
        location.city = 'Chicago';
        System.assertEquals('Chicago', location.city);
    }

}