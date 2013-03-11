global class AM_StatusUpdater {
  private static Set<String> subjects = new Set<String>{
    'Prep: Intro Call',
    'Prep: Getting Ready',
    'Prep: Feature Date Confirmed',
    'Prep: MC Walkthrough',
    'Prep: Preview Delivered',
    'Prep: Preview Approved',
    'Maintenance: Day After',
    'Maintenance: Pre Expiration',
    'Maintenance: Merchant Temperature Follow Up'
  };

  public static void setAMStatusFields(List<Task> tasks) {
    Map<Id, Task> accountTasks = new Map<Id, Task>();
    List<Id> opportunityIds = new List<Id>();
    List<Task> opportunityTasks = new List<Task>();
    Map<Id, Merchant_Temperature__c> temperatureMap = new Map<Id, Merchant_Temperature__c>();
    Map<Id, Opportunity> oldOpportunityMap = new Map<Id, Opportunity>();
    Map<Id, Opportunity> newOpportunityMap = new Map<Id, Opportunity>();

    for (Task task : tasks) {
      if (task.WhatId != null && subjects.contains(task.Subject)) {
        String prefix = String.valueOf(task.WhatId).substring(0, 3);

        if (prefix == '001' && task.Status == 'Completed') {
          accountTasks.put(task.WhatId, task);
        } else if (prefix == '006') {
          opportunityIds.add(task.WhatId);
          opportunityTasks.add(task);
        }
      }
    }

    if (accountTasks.size() > 0) {
      temperatureMap = new Map<Id, Merchant_Temperature__c>([
        SELECT Id, Low_Merchant_Temp_Call_Status__c
        FROM Merchant_Temperature__c
        WHERE Account__c in :accountTasks.keySet()
          AND Low_Merchant_Temp_Call_Status__c != 'Completed'
          AND Overall_Experience_Ranking__c <= 3
      ]);

      for (Merchant_Temperature__c temperature : temperatureMap.values()) {
        temperature.Low_Merchant_Temp_Call_Status__c = 'Completed';
      }

      try {
        update temperatureMap.values();
      } catch (Exception e) {
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.sendEmail(email(temperatureMap.keySet(), e));
      }
    }

    if (opportunityTasks.size() > 0) {
      oldOpportunityMap = new Map<Id, Opportunity>([
        SELECT Id, Intro_Call_Status__c, Getting_Ready_Email_Status__c, Feature_Date_Confirmation_Status__c, Merchant_Center_Walkthrough_Status__c, Client_Preview_Status__c, Preview_Approval_Status__c, Day_After_Feature_Call_Status__c, Pre_Expiration_Call_Status__c
        FROM Opportunity
        WHERE Id IN :opportunityIds
      ]);

      Opportunity opportunity = new Opportunity();
      for (Task task : opportunityTasks) {
        if (newOpportunityMap.containsKey(task.WhatId)) {
          opportunity = newOpportunityMap.get(task.WhatId);
        } else {
          opportunity = oldOpportunityMap.get(task.WhatId);
        }

        if (task.Subject == 'Prep: Intro Call' && opportunity.Intro_Call_Status__c != task.Status) {
          opportunity.Intro_Call_Status__c = task.Status;
        } else if (task.Subject == 'Prep: Getting Ready' && opportunity.Getting_Ready_Email_Status__c != task.Status) {
          opportunity.Getting_Ready_Email_Status__c = task.Status;
        } else if (task.Subject == 'Prep: Feature Date Confirmed' && opportunity.Feature_Date_Confirmation_Status__c != task.Status) {
          opportunity.Feature_Date_Confirmation_Status__c = task.Status;
        } else if (task.Subject == 'Prep: MC Walkthrough' && opportunity.Merchant_Center_Walkthrough_Status__c != task.Status) {
          opportunity.Merchant_Center_Walkthrough_Status__c = task.Status;
        } else if (task.Subject == 'Prep: Preview Delivered' && opportunity.Client_Preview_Status__c != task.Status) {
          opportunity.Client_Preview_Status__c = task.Status;
        } else if (task.Subject == 'Prep: Preview Approved' && opportunity.Preview_Approval_Status__c != task.Status) {
          opportunity.Preview_Approval_Status__c = task.Status;
        } else if (task.Subject == 'Maintenance: Day After' && opportunity.Day_After_Feature_Call_Status__c != task.Status) {
          opportunity.Day_After_Feature_Call_Status__c = task.Status;
        } else if (task.Subject == 'Maintenance: Pre Expiration' && opportunity.Pre_Expiration_Call_Status__c != task.Status) {
          opportunity.Pre_Expiration_Call_Status__c = task.Status;
        }

        newOpportunityMap.put(task.WhatId, opportunity);
      }

      if (newOpportunityMap.size() > 0) {
        try {
          update newOpportunityMap.values();
        } catch (Exception e) {
          Messaging.reserveSingleEmailCapacity(1);
          Messaging.sendEmail(email(newOpportunityMap.keySet(), e));
        }
      }
    }
  }

  public static Messaging.SingleEmailMessage[] email(Set<Id> ids, Exception e) {
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.setSaveAsActivity(false);
    message.setTargetObjectId('005C00000045bmV');
    message.setSenderDisplayName('AM Workbench');
    message.setSubject('Workbench Validation Error');
    String text = '';
    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    text += 'User Profile: ' + baseUrl + '/' + UserInfo.getUserId() + '\n';
    text += 'Links: ';
    for (Id id : ids) {
      text += baseUrl + '/' + id + '\n';
    }
    text += 'Error Message: ' + e.getMessage();
    message.setPlainTextBody(text);
    return new Messaging.SingleEmailMessage[] { message };
  }
}