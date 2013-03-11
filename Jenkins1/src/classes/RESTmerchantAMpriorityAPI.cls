@RestResource(urlMapping='/v1.0/merchants/am-priority')

global class RESTmerchantAMpriorityAPI {
  @HttpPOST
  global static List<Account> updateAMpriority(List<Account> accounts, List<Task> tasks) {
    try {
      Database.update(accounts);
      Database.update(tasks);
    } catch(Exception e) {
      System.debug(e);
    }

    return accounts;
  }

  @HttpGET
  global static list<AMrulesEngine.merchant> getMyMerchants(){
    AMrulesEngine engine = new AMrulesEngine();
    set<id> ids = new set<id>();
    ids.add('0018000000SeH2R');
    ids.add('0018000000SdEAcAAN');
    ids.add('0018000000SdERMAA3');
    ids.add('0018000000Se0rBAAR');
    list<account> accounts = [select id from account limit 75];
    for(account a : accounts){ids.add(a.id);}
    list<AMrulesEngine.merchant> merchants = engine.getMerchants(ids);
    return merchants;
  }
}