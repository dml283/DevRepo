@isTest
public class AM_workbenchMerchantTest {
  static testMethod void sortMerchantByCLP() {
    Account account1 = new Account();
    AM_workbench.Merchant merchant1 = new AM_workbench.Merchant(account1);
    merchant1.sortStrategy = 'clp';

    Account account2 = new Account();
    AM_workbench.Merchant merchant2 = new AM_workbench.Merchant(account2);
    merchant2.sortStrategy = 'clp';

    List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();

    merchant1.clp = 1;
    merchants.add(merchant1);
    merchant2.clp = 2;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(1, merchants[0].clp);
    System.assertEquals(2, merchants[1].clp);

    merchants.clear();
    merchant1.clp = 2;
    merchants.add(merchant1);
    merchant2.clp = 1;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(1, merchants[0].clp);
    System.assertEquals(2, merchants[1].clp);
  }

  static testMethod void sortMerchantByPriority() {
    Account account1 = new Account();
    AM_workbench.Merchant merchant1 = new AM_workbench.Merchant(account1);
    merchant1.sortStrategy = 'priority';

    Account account2 = new Account();
    AM_workbench.Merchant merchant2 = new AM_workbench.Merchant(account2);
    merchant2.sortStrategy = 'priority';

    List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();

    merchant1.priority = 2;
    merchants.add(merchant1);
    merchant2.priority = 1;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(1, merchants[0].priority);
    System.assertEquals(2, merchants[1].priority);

    merchants.clear();
    merchant1.priority = 3;
    merchants.add(merchant1);
    merchant2.priority = 4;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(3, merchants[0].priority);
    System.assertEquals(4, merchants[1].priority);

    merchants.clear();
    merchant1.priority = 5;
    merchants.add(merchant1);
    merchant2.priority = 5;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(5, merchants[0].priority);
    System.assertEquals(5, merchants[1].priority);
  }

  static testMethod void sortMerchantByPriorityWithNull() {
    Account account1 = new Account();
    AM_workbench.Merchant merchant1 = new AM_workbench.Merchant(account1);
    merchant1.sortStrategy = 'priority';

    Account account2 = new Account();
    AM_workbench.Merchant merchant2 = new AM_workbench.Merchant(account2);
    merchant2.sortStrategy = 'priority';

    List<AM_workbench.Merchant> merchants = new List<AM_workbench.Merchant>();

    merchant1.priority = null;
    merchants.add(merchant1);
    merchant2.priority = 0;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(0, merchants[0].priority);
    System.assertEquals(null, merchants[1].priority);

    merchants.clear();
    merchant1.priority = 0;
    merchants.add(merchant1);
    merchant2.priority = null;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(0, merchants[0].priority);
    System.assertEquals(null, merchants[1].priority);

    merchants.clear();
    merchant1.priority = null;
    merchants.add(merchant1);
    merchant2.priority = null;
    merchants.add(merchant2);
    merchants.sort();

    System.assertEquals(null, merchants[0].priority);
    System.assertEquals(null, merchants[1].priority);
  }

  static testMethod void hasContactReason() {
    Account account = new Account(AM_Priority__c = 1, AM_Priority_Reason__c = 'Feature Date Not Confirmed');
    AM_workbench.Merchant merchant = new AM_workbench.Merchant(account);
    System.assertEquals('Feature Date Not Confirmed', merchant.contact_reason.value);
    System.assertEquals('label-danger', merchant.contact_reason.css);
  }

  static testMethod void hasNoContactReason() {
    Account account = new Account(AM_Priority__c = -1, AM_Priority_Reason__c = '');
    AM_workbench.Merchant merchant = new AM_workbench.Merchant(account);
    System.assertEquals('', merchant.contact_reason.value);
    System.assertEquals('label-info', merchant.contact_reason.css);
  }
}