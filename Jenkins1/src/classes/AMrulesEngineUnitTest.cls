@isTest
public class AMrulesEngineUnitTest {
  private static User createUser(String username, String localeKey) {
    Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    return new User(Alias = 'standt',
                    Email = 'standarduser@groupon.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'Testing',
                    LanguageLocaleKey = 'en_US',
                    LocalesIdKey = localeKey,
                    ProfileId = profile.Id,
                    TimezonesIdKey = 'America/Los_Angeles',
                    Username = username);
  }

  static testMethod void getCountry() {
    List<User> users = new List<User>();
    User usa = createUser('standarduser1@groupon.com', 'en_US');
    User uk = createUser('standarduser2@groupon.com', 'en_GB');
    users.add(usa);
    users.add(uk);

    insert users;

    System.RunAs(usa) {
      System.assertEquals('USA', AMrulesEngine.getCountry());
    }

    System.RunAs(uk) {
      System.assertEquals('UK', AMrulesEngine.getCountry());
    }
  }

  static testMethod void getCountryByLocaleKey() {
    List<User> users = new List<User>();

    System.assertEquals('USA', AMrulesEngine.getCountryByLocaleKey('en_US'));
    System.assertEquals('UK', AMrulesEngine.getCountryByLocaleKey('en_GB'));
    System.assertEquals('Ireland', AMrulesEngine.getCountryByLocaleKey('en_IE'));
    System.assertEquals('Germany', AMrulesEngine.getCountryByLocaleKey('de_DE'));
    System.assertEquals('Italian', AMrulesEngine.getCountryByLocaleKey('it_IT'));
    System.assertEquals('Brazil', AMrulesEngine.getCountryByLocaleKey('pt_BR'));
    System.assertEquals('Spain', AMrulesEngine.getCountryByLocaleKey('es_ES'));
    System.assertEquals('Netherlands', AMrulesEngine.getCountryByLocaleKey('nl_NL'));
  }
}