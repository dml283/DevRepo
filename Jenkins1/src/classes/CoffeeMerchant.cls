@RestResource (urlMapping='/v1.0/coffee/merchant/*')

global class CoffeeMerchant {

  @HttpGET
  global static Merchant get() {
    RestRequest req = RestContext.Request;
    if (req.params.containsKey('id')) {
      Account account = findAccount(req.params.get('id'));
      if (account != null) {
        return new Merchant(account);
      } else {
        RestContext.Response.statusCode = 404;
      }
    } else {
      RestContext.Response.statusCode = 404;
    }
    return null;
  }

  global class Merchant {
    public id             id                { get; set; }
    public String         owner_id          { get; set; }
    public String         name              { get; set; }
    public Decimal        m3_id             { get; set; }
    public String         permalink         { get; set; }
    public String         research_ranking  { get; set; }
    public String         website           { get; set; }
    public String         subdivision       { get; set; }
    public String         country_code      { get; set; }
    public String         currency_code     { get; set; }
    public Taxonomy       taxonomy          { get; set; }
    public Division       division          { get; set; }
    public List<Address>  addresses         { get; set; }

    public Merchant(Account a) {
      this.id               = a.id;
      this.owner_id         = a.OwnerId;
      this.name             = a.name;
      this.m3_id            = a.M3_Id__c;
      this.permalink        = a.Merchant_Permalink__c;
      this.research_ranking = a.Research_Ranking__c;
      this.website          = a.Website;
      this.country_code     = a.Division__r.Country__r.ISO_Code__c;
      this.currency_code    = 'USD';
      this.subdivision      = a.Subdivision__c;
      this.taxonomy         = new Taxonomy(a);

      if (a.Division__c != null) {
        this.division = new Division(findDivision(a.Division__c));
      }

      this.addresses = new List<Address>();
      for (Merchant_Addresses__c address : a.Merchant_Addresses__r) {
        this.addresses.add(new Address(address));
      }
    }
  }

  global class Taxonomy {
    public String       category     { get; set; }
    public String       subcategory  { get; set; }
    public String       attributes   { get; set; }
    public List<String> services     { get; set; }

    public Taxonomy(Account a) {
      this.category      = a.Category_v3__c;
      this.subcategory   = a.Subcategory_v3__c;
      this.attributes    = a.Merchant_Attributes__c;
      this.services      = new List<String>();
      if (a.Services_Offered__c != null) {
        for (String s : a.Services_Offered__c.split('\\s*\\|\\s*')) {
          services.add(s);
        }
      }
    }
  }

  global class Division {
    public Id                id            { get; set; }
    public String            name          { get; set; }
    public List<Subdivision> subdivisions  { get; set; }

    public Division(Division__c d) {
      this.id   = d.id;
      this.name = d.name;

      this.subdivisions = new List<Subdivision>();
      for (Subdivision__c subdivision : d.Subdivisions1__r) {
        subdivisions.add(new Subdivision(subdivision));
      }
    }
  }

  public class Subdivision {
    public Id           id            { get; set; }
    public Id           division_id   { get; set; }
    public String       name          { get; set; }
    public Double       rank          { get; set; }
    public List<String> zip_codes     { get; set; }

    public Subdivision(Subdivision__c s) {
      this.id          = s.Id;
      this.division_id = s.Division__c;
      this.name        = s.Name;
      this.rank        = s.Rank__c;
      this.zip_codes   = new List<String>();

      for (Zip_Code__c zip : findZipCodes()) {
        this.zip_codes.add(zip.Name);
      }
    }

    private List<Zip_Code__c> findZipCodes() {
      return [
        SELECT Name FROM Zip_Code__c WHERE Subdivision__c = :this.id
      ];
    }
  }

  global class Address {
    public Id      id            { get; set; }
    public String  street1       { get; set; }
    public String  street2       { get; set; }
    public String  city          { get; set; }
    public String  state         { get; set; }
    public String  country       { get; set; }
    public String  zip           { get; set; }
    public Decimal lat           { get; set; }
    public Decimal lng           { get; set; }
    public String  subdivision   { get; set; }

    public Address(Merchant_Addresses__c a) {
      this.id           = a.Id;
      this.street1      = a.Street_Line_1__c;
      this.street2      = a.Street_Line_2__c;
      this.city         = a.City__c;
      this.state        = a.State_Province__c;
      this.country      = a.Country__c;
      this.zip          = a.Zip_Postal_Code__c;
      this.lat          = a.Latitude__c;
      this.lng          = a.Longitude__c;
      this.subdivision  = a.Subdivision__r.Name;
    }
  }

  public static Account findAccount(string Id) {
    Account[] results = [
      SELECT
        Id,
        OwnerId,
        Name,
        M3_Id__c,
        Merchant_Permalink__c,
        Research_Ranking__c,
        Division__c, // this is an id
        Subdivision__c,
        Website,
        Division__r.Country__r.ISO_Code__c,

        // taxonomy attributes
        Category_v3__c,
        Subcategory_v3__c,
        Merchant_Attributes__c,
        Services_Offered__c,

        // addresses
        (
          SELECT
              Id,
              Street_Line_1__c,
              Street_Line_2__c,
              City__c,
              State_Province__c,
              Country__c,
              Zip_Postal_Code__c,
              Latitude__c,
              Longitude__c,
              Subdivision__r.Name
          FROM Merchant_Addresses__r
        )
      FROM Account
      WHERE Id = :id
      LIMIT 1
    ];

    if (results.size() > 0) {
      return results[0];
    } else {
      return null;
    }
  }

  public static Division__c findDivision(String id) {
    Division__c[] results = [
      SELECT
        Id, Name,
        (
          SELECT
            Id,
            Name,
            Division__c,
            Rank__c
          FROM Subdivisions1__r
        )
      FROM Division__c
      WHERE Id = :id
      LIMIT 1
    ];

    if (results.size() > 0) {
      return results[0];
    } else {
      return null;
    }
  }

  static testMethod void test() {
    GrouponTestUtil util = new GrouponTestUtil();
    
    Division__c div = new Division__c(Name ='test',State__c ='IL');
    insert div;
    
    Subdivision__c subdiv = new Subdivision__c(Name = 'Test Subdiv', Division__c = div.Id);
    insert subdiv;
    
    Account account = util.createAccount();
    insert account;
    
    account.Division__c = div.Id;
    update account;
    
    merchant_addresses__c m = new merchant_addresses__c();     
    m.street_line_1__c = '600 W. Chicago';
    m.Street_Line_2__c = '';
    m.City__c = '';
    m.State_Province__c = '';
    m.Zip_Postal_Code__c = '';
    m.Phone_Number__c = '';
    m.account__c = account.id;
    insert m; 

    RestRequest req = new RestRequest();
    req.params.put('id', account.id);
    RestContext.Request = req;
    CoffeeMerchant.get();
  }
}