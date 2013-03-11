global class ACHChecksum {
//Waiting to Delete
/*
    public static void checkForValidRoutingNumber(List<Account> accountsInTrigger) {
        for (Account account : accountsInTrigger) {
      account.Valid_Routing__c = 'N/A';

      if (account.Payment_Preference__c == 'ACH (Direct Deposit)' && account.TransitNumber__c != null && account.BillingCountry == 'CA') {
        String transitNumber = String.valueOf(account.TransitNumber__c);
        transitNumber = transitNumber.replaceAll(' ', '');
        transitNumber = transitNumber.replaceAll('-', '');

        if (transitNumber.length() == 8) {
          String routingNumber = '0';
          routingNumber += String.valueOf(transitNumber.substring(5, 6));
          routingNumber += String.valueOf(transitNumber.substring(6, 7));
          routingNumber += String.valueOf(transitNumber.substring(7, 8));
          routingNumber += String.valueOf(transitNumber.substring(0, 1));
          routingNumber += String.valueOf(transitNumber.substring(1, 2));
          routingNumber += String.valueOf(transitNumber.substring(2, 3));
          routingNumber += String.valueOf(transitNumber.substring(3, 4));
          routingNumber += String.valueOf(transitNumber.substring(4, 5));
          account.Routing_Number_enc__c = routingNumber;
        }
      }

      Boolean validAch = false;

            if (account.Payment_Preference__c == 'ACH (Direct Deposit)' && account.TransitNumber__c == null && account.Routing_Number_enc__c != null && account.BillingCountry == 'US') {
        String routingNumber = String.valueOf(account.Routing_Number_enc__c);
        if (routingNumber.length() == 9) {
          Integer var1 = Integer.valueOf(routingNumber.substring(0, 1));
          Integer var2 = Integer.valueOf(routingNumber.substring(1, 2));
          Integer var3 = Integer.valueOf(routingNumber.substring(2, 3));
          Integer var4 = Integer.valueOf(routingNumber.substring(3, 4));
          Integer var5 = Integer.valueOf(routingNumber.substring(4, 5));
          Integer var6 = Integer.valueOf(routingNumber.substring(5, 6));
          Integer var7 = Integer.valueOf(routingNumber.substring(6, 7));
          Integer var8 = Integer.valueOf(routingNumber.substring(7, 8));
          Integer var9 = Integer.valueOf(routingNumber.substring(8, 9));

          Integer checkSum = ((var1*3) + (var2*7) + (var3*1) + (var4*3) + (var5*7) + (var6*1) + (var7*3) + (var8*7) + (var9*1));

          Integer remainder = Math.mod(checksum, 10);
          if (checksum != 0 && remainder == 0 && Integer.valueOf(routingNumber.substring(0, 1)) != 5) {
            validAch = true;
          }
        }
      }    

      if (validACH == true) {
        account.Valid_routing__c='Yes';
      } else if (account.Payment_Preference__c=='ACH (Direct Deposit)' && account.routing_number_enc__c != '' && account.BillingCountry == 'US') {
        account.Valid_routing__c = 'No';
      } else {
        account.Valid_Routing__c = 'N/A';
      }
    }
    }
*/
}