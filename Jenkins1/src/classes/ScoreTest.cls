public class ScoreTest {

    @istest
    public static void testSetGet() {

        Score score = new Score();
        score.value = '0.2432';
        System.assertEquals('0.2432', score.value);
    }

}