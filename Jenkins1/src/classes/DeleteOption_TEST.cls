@isTest
private class DeleteOption_TEST {
  public static testMethod void testPreventOptionsFromDelete() {
    Database.DeleteResult DR_Dels;

    GrouponTestUtil util = new GrouponTestUtil();

    Opportunity deal = util.createDeal();
    database.insert (deal);

    Multi_deal__c option = util.CreateOption (deal);

    system.assertEquals (null, option.id);
    database.insert (option);
    system.assertNotEquals (null, option.id);

    //now we test if we can delete succesfully
    DR_Dels = Database.delete (option);
    system.assertEquals (true, DR_Dels.isSuccess());

    //now we test if we cahnge it to closed won, that no delete can happen
    deal.StageName = 'Closed Won';
    database.update (deal);

    Multi_deal__c optionToDelete = util.CreateOption (deal);
    database.insert (optionToDelete);
    system.assertNotEquals (null, optionToDelete.id);

    DR_Dels = Database.delete (optionToDelete, false);
    system.assertEquals (false, DR_Dels.isSuccess());

  }
}