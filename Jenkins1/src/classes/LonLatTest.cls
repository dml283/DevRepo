public class LonLatTest {

    @istest
    public static void testSetGet() {

        LonLat lonLat = new LonLat();
        lonLat.lon = -12.345;
        System.assertEquals(-12.345, lonLat.lon);
    }

}