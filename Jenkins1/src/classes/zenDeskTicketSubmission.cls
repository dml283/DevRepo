Public class zenDeskTicketSubmission {
  //Method             : postRequest
  //Parameters         : XMLString to be set as HTTP body

	public STATIC void postRequest(string XMLforbody)
	{  
		/* 
		String username = 'sfzdintegration@groupon.com/token' ;
		String password = 'ZISStf9U4IqAastIzgukxFDES2HbJqV6bDfu3vL8';
		Blob headerValue = Blob.valueOf(username + ':' + password);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		http h = new http();
		HttpRequest req = new HttpRequest(); 
		req.setEndpoint('https://grouhelpon.zendesk.com/tickets.xml');
		req.setHeader('Content-Type', 'application/xml'); 
		req.setHeader('Authorization', authorizationHeader);       
		req.setMethod('POST');
		req.setBody(XMLforbody);
		System.debug('\n\nreq = '+req+'\n\n');
		HttpResponse res = h.send(req);
		//system.debug('RESPONSE FROM ZENDESK SERVER' + res.getHeaderKeys());
		*/
		postRequest('sfzdintegration@groupon.com/token', 'ZISStf9U4IqAastIzgukxFDES2HbJqV6bDfu3vL8', 'https://grouhelpon.zendesk.com/tickets.xml', xmlForBody);
	}

	public STATIC void postRequest(String userName, String password, String endPoint, String XMLforbody)
	{   
	    Blob headerValue = Blob.valueOf(username + ':' + password);
	    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
	    http h = new http();
	    HttpRequest req = new HttpRequest(); 
	    req.setEndpoint(endPoint);
	    req.setHeader('Content-Type', 'application/xml'); 
	    req.setHeader('Authorization', authorizationHeader);       
	    req.setMethod('POST');
	    req.setBody(XMLforbody);
	    System.debug('\n\nreq = '+req+'\n\n');
	    HttpResponse res = h.send(req);
	    //res.toString()
	    system.debug('RESPONSE FROM ZENDESK SERVER' + res.getHeaderKeys());
	    for(String s: res.getHeaderKeys())
	    {
	    	if(s != null)
	    		System.debug('\n\nHeader:'+s+' = '+res.getHeader(s)+'\n\n');
	    }
	    System.debug('\n\nresponse body = '+res.getBody()+'\n\n');
	    
	}

  //Method         : callZenddeskAPIforOpp
  @FUTURE (callout = true)
  public STATIC void  callZenddeskAPIforOpp (string triggerNew, string triggerOld, string triggerNewMap, string triggerOldMap, string accountInfo, string userinfo) {
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<Opportunity> oldList = (List<Opportunity>) JSON.Deserialize (triggerOld, List<Opportunity>.class);
    List<Opportunity> newList = (List<Opportunity>) JSON.Deserialize (triggerNew, List<Opportunity>.class);
    Map<id, Opportunity> oldListMap = (Map<id, Opportunity>) JSON.Deserialize (triggerOldMap, Map<id, Opportunity>.class);
    Map<id, Opportunity> newListMap = (Map<id, Opportunity>) JSON.Deserialize (triggerNewMap, Map<id, Opportunity>.class);

    Account accountvals = (Account) JSON.Deserialize (accountInfo, Account.class);
    user userinfoval = (user) JSON.Deserialize (userinfo, User.class);

    String returnXML;
    for (Id OppId : oldListMap.Keyset()) {
      returnXML = formatOpportunity (newListMap.get (OppId), oldListMap.get (OppId), accountvals, userinfoval);
    }

    system.debug ('Return XML for Opportunity' + returnXML);

    if (returnXML != null) {
      postRequest (returnXML);
    }
  }

  //Method         : callZenddeskAPIformultideal
  @Future (callout = true)
  public STATIC void  callZenddeskAPIformultideal (string triggerNew, string triggerOld, string triggerNewMap, string triggerOldMap, string UserInfo, String oppInfo) {
    List<Multi_deal__c> oldList = (List<Multi_deal__c>) JSON.Deserialize (triggerOld, List<Multi_deal__c>.class);
    List<Multi_deal__c> newList = (List<Multi_deal__c>) JSON.Deserialize (triggerNew, List<Multi_deal__c>.class);
    Map<id, Multi_deal__c> oldListMap = (Map<id, Multi_deal__c>) JSON.Deserialize (triggerOldMap, Map<id, Multi_deal__c>.class);
    Map<id, Multi_deal__c> newListMap = (Map<id, Multi_deal__c>) JSON.Deserialize (triggerNewMap, Map<id, Multi_deal__c>.class);
    User Userinfoval = (User) JSON.Deserialize (UserInfo, User.class);
    Opportunity OpportunityInfo = (Opportunity) JSON.Deserialize (oppInfo, Opportunity.class);
    String returnXML;

    for (Id multiId : oldListMap.Keyset()) {
      returnXML = formatMultiDeals (newListMap.get (multiId), oldListMap.get (multiId), Userinfoval, OpportunityInfo);
    }

    system.debug ('Return XML for MultiDeal' + returnXML);

    if (returnXML != null) {
      postRequest (returnXML);
    }
  }

  @Future (callout = true)
  public STATIC void  callZenddeskAPIforAddress (string triggerNew, string triggerOld, string triggerNewMap, string triggerOldMap, string UserInfo, string oppInfo) {
    List<Address__c> oldList = (List<Address__c>) JSON.Deserialize (triggerOld, List<Address__c>.class);
    List<Address__c> newList = (List<Address__c>) JSON.Deserialize (triggerNew, List<Address__c>.class);
    Map<id, Address__c> oldListMap = (Map<id, Address__c>) JSON.Deserialize (triggerOldMap, Map<id, Address__c>.class);
    Map<id, Address__c> newListMap = (Map<id, Address__c>) JSON.Deserialize (triggerNewMap, Map<id, Address__c>.class);
    User Userinfoval = (User) JSON.Deserialize (UserInfo, User.class);
    Opportunity OpportunityInfo = (Opportunity) JSON.Deserialize (oppInfo, Opportunity.class);
    String returnXML;

    for (Id AddressId : oldListMap.Keyset()) {
      returnXML = formatAddresses (newListMap.get (AddressId), oldListMap.get (AddressId), Userinfoval, OpportunityInfo);
    }

    system.debug ('Return XML for Address' + returnXML);

    if (returnXML != null) {
      postRequest (returnXML);
    }
  }

  ///Naushads Additions
  static Boolean isNullXML = true;
  private static String setupXMLString (String acctName, Opportunity oppty, User userVal, String finalDescription) {
    String xmlString = '';

    if (acctName != null && oppty != null && userVal != null && finalDescription != null) {
      xmlString =  '<ticket>';
      xmlString += '\n<description>'  + finalDescription  + '</description>';
      xmlString += '<subject>' + acctName + '-' + oppty.Type + '</subject>';
      xmlString += '<requester-email>' + userVal.email + '</requester-email>';
      xmlString += '<requester-name>' + userVal.name + '</requester-name>';
    }
    return xmlString;
  }

  private static String getDescription (SObject newRecord, SObject oldRecord, String fieldLabel, String fieldName) {
    String description = '';
    if (newRecord != null && oldRecord != null && fieldName != null) {
      if (newRecord.get (fieldName) != oldRecord.get (fieldName)) {
        description = fieldLabel + ' changed from ' + oldRecord.get (fieldName) + ' to ' + newRecord.get (fieldName) + '\n';
        isNullXML = false;
      }
    }
    return description;
  }

  private static String addAdditionalTags (String tag) {
    if (tag != null) {
      tag = '<additional-tags>' + tag + '</additional-tags>';
    }

    return tag;
  }

  private static String addTicketFieldEntries (Opportunity oppty, Boolean checkOnGoLiveDate) {
    String tfeString = '';
    if (oppty != null) {
      //113268 -- Deal URL Id in Zendesk.
      tfeString = ' <ticket-field-entries type="array">';
      tfeString += ' <ticket-field-entry> <ticket-field-id>' + 113268 + '</ticket-field-id><value> ' + 'http://www.groupon.com/deals/' + oppty.Permalink__c + '</value> </ticket-field-entry> ' ;
      //113212-- Image/Copy Id in Zendesk.
      tfeString += ' <ticket-field-entry> <ticket-field-id>' + 113212 + '</ticket-field-id><value> ' + 'Copy' + '</value> </ticket-field-entry> ';
      //166523-- Feature Date Id in Zendesk.
      if (checkOnGoLiveDate != null && checkOnGoLiveDate) {
        if (oppty.Go_Live_Date__c != null) {
          tfeString += ' <ticket-field-entry> <ticket-field-id>' + 166523 + '</ticket-field-id><value> ' + String.valueof (oppty.Go_Live_Date__c) + '</value> </ticket-field-entry> ';
        } else {
          tfeString += ' <ticket-field-entry> <ticket-field-id>' + 166523 + '</ticket-field-id><value> ' + String.valueof ('1989-01-01') + '</value> </ticket-field-entry> ';
        }
      } else {
        tfeString += ' <ticket-field-entry> <ticket-field-id>' + 166523 + '</ticket-field-id><value> ' + String.valueof (oppty.Go_Live_Date__c) + '</value> </ticket-field-entry> ';
      }
      tfeString += ' </ticket-field-entries>' ;
      tfeString += '</ticket>';
    }
    return tfeString;
  }

  private static String formatOpportunity (Opportunity oppty, Opportunity oldOppty, Account acct, User userVal) {
    String xmlString;
    Zendesk_User_Categories__c zc = Zendesk_User_Categories__c.getValues (userval.Id);

    String finalDescription = 'SFDC Opportunity ID: https://na8.salesforce.com/' + oppty.Id + '\n';
    isNullXML = true;

    for (Zendesk_Field_Mappings__c zfm : Zendesk_Field_Mappings__c.getAll().values()) {
      if (zfm.Opportunity__c) {

        if(zc != null) {
          // Populate tickets for Account Managers
          if(zc.Account_Manager__c) {
            if(!zfm.Ignore_For_Account_Manager__c) {
              finalDescription += getDescription (oppty, oldOppty, zfm.Field_Label__c, zfm.API_Name__c);
            } else if (zfm.Ignore_For_Account_Manager__c && zfm.Ignore_For_Feature_Dates_In_Future__c && (oppty.Feature_Date__c < System.Today() || (oldOppty.Feature_Date__c == null && oppty.Feature_Date__c == null))) {
              finalDescription += getDescription (oppty, oldOppty, zfm.Field_Label__c, zfm.API_Name__c);
            }
          }

          // Populate tickets for City Planners
          if(zc.City_Planner__c) {
            if(!zfm.Ignore_For_City_Planner__c) {
              finalDescription += getDescription (oppty, oldOppty, zfm.Field_Label__c, zfm.API_Name__c);
            } else if (zfm.Ignore_For_City_Planner__c && zfm.Ignore_For_Feature_Dates_In_Future__c && (oppty.Feature_Date__c < System.Today() || (oldOppty.Feature_Date__c == null && oppty.Feature_Date__c == null))) {
              finalDescription += getDescription (oppty, oldOppty, zfm.Field_Label__c, zfm.API_Name__c);
            }
          }

          if(!zc.Account_Manager__c && !zc.City_Planner__c) {
            finalDescription += getDescription (oppty, oldOppty, zfm.Field_Label__c, zfm.API_Name__c);
          }
        } else {
          finalDescription += getDescription (oppty, oldOppty, zfm.Field_Label__c, zfm.API_Name__c);
        }
      }
    }

    if (isNullXML || oppty.Permalink__c == null) {
      xmlString = null;
    } else {
      xmlString = setupXMLString (acct.Name, oppty, userVal, finalDescription);
      //--Tags in Zenddesk
      xmlString += addAdditionalTags ('Automation');
      xmlString += addAdditionalTags ('Opportunity');
      //all exceptions and tagging here.
      if (oppty.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get (Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_GROUPON_GETAWAYS)) { //'012C0000000UKMI') {
        xmlString += addAdditionalTags ('ga');
      }

      if (oppty.RecordTypeID == OpportunityServices.mapRecordTypeNamesToID.get (Constants.OPPORTUNITY_RECORD_TYPE_DEV_NAME_REWARDS)) { // '012C0000000UK9N') {
        xmlString += addAdditionalTags ('rew');
      }

      //fine print is true
      if (oppty.Conditions__c != oldOppty.Conditions__c) {
        xmlString += addAdditionalTags ('f_p');
      }

      if (oppty.Division__c != null) {
        string divsion = string.valueof (oppty.Division__c).replaceAll ('[\\s+,+/+.]', '').toLowerCase();
        xmlString += addAdditionalTags (divsion);
      }

      if (oppty.Feature_Date__c != null && oldOppty.Feature_Date__c != null) {
        if (oppty.Feature_Date__c > oldOppty.Feature_Date__c) {
          xmlString += addAdditionalTags ('FD');
        }
      }

      xmlString += addTicketFieldEntries (oppty, true);
    }

    return xmlString;
  }

  private static String formatMultiDeals (Multi_Deal__c multiDeal, Multi_Deal__c oldMultiDeal, User userval, Opportunity oppty) {
    String xmlString;
    Zendesk_User_Categories__c zc = Zendesk_User_Categories__c.getValues (userval.Id);

    String finalDescription = '';
    isNullXML = true;

    for (Zendesk_Field_Mappings__c zfm : Zendesk_Field_Mappings__c.getAll().values()) {
      if (zfm.Multi_Deal__c) {

        if(zc != null) {
          // Populate tickets for Account Managers
          if(zc.Account_Manager__c) {
            if(!zfm.Ignore_For_Account_Manager__c) {
              finalDescription += getDescription (multiDeal, oldMultiDeal, zfm.Field_Label__c, zfm.API_Name__c);
            } else if (zfm.Ignore_For_Account_Manager__c && zfm.Ignore_For_Feature_Dates_In_Future__c && (oppty.Feature_Date__c < System.Today() || oppty.Feature_Date__c == null)) {
              finalDescription += getDescription (multiDeal, oldMultiDeal, zfm.Field_Label__c, zfm.API_Name__c);
            }
          }

          // Populate tickets for City Planners
          if(zc.City_Planner__c) {
            if(!zfm.Ignore_For_City_Planner__c) {
              finalDescription += getDescription (multiDeal, oldMultiDeal, zfm.Field_Label__c, zfm.API_Name__c);
            } else if (zfm.Ignore_For_City_Planner__c && zfm.Ignore_For_Feature_Dates_In_Future__c && (oppty.Feature_Date__c < System.Today() || oppty.Feature_Date__c == null)) {
              finalDescription += getDescription (multiDeal, oldMultiDeal, zfm.Field_Label__c, zfm.API_Name__c);
            }
          }

          if(!zc.Account_Manager__c && !zc.City_Planner__c) {
            finalDescription += getDescription (multiDeal, oldMultiDeal, zfm.Field_Label__c, zfm.API_Name__c);
          }
        } else {
          finalDescription += getDescription (multiDeal, oldMultiDeal, zfm.Field_Label__c, zfm.API_Name__c);
        }
      }
    }

    if (isNullXML || oppty.Permalink__c == null) {
      xmlString = null;
    } else {
      xmlString = setupXMLString (oppty.Account.Name, oppty, userVal, finalDescription);
      //--Tags in Zenddesk
      xmlString += addAdditionalTags ('Automation');
      xmlString += addAdditionalTags ('multi');

      if (multiDeal.Unit_Sell_Price__c != oldMultiDeal.Unit_Sell_Price__c) {
        xmlString += addAdditionalTags ('s_p');
      }

      if (multiDeal.Unit_Buy_Price__c != oldMultiDeal.Unit_Buy_Price__c) {
        xmlString += addAdditionalTags ('b_p');
      }

      if (multiDeal.Unit_Value__c != oldMultiDeal.Unit_Value__c) {
        xmlString += addAdditionalTags ('u_v');
      }

      if (oppty.Division__c != null) {
        String divsion = String.valueof (oppty.Division__c).replaceAll ('[\\s+,+/+.]', '').toLowerCase();
        xmlString += addAdditionalTags (Divsion);
      }

      xmlString += addTicketFieldEntries (oppty, false);
    }

    return xmlString;
  }

  private static String formatAddresses (Address__c add, Address__c oldAdd, User userVal, Opportunity oppty) {
    String xmlString;
    Zendesk_User_Categories__c zc = Zendesk_User_Categories__c.getValues (userval.Id);

    String finalDescription = '';
    isNullXML = true;

    for (Zendesk_Field_Mappings__c zfm : Zendesk_Field_Mappings__c.getAll().values()) {
      if (zfm.Address__c) {
        if(zc != null) {
          // Populate tickets for Account Managers
          if(zc.Account_Manager__c) {
            if(!zfm.Ignore_For_Account_Manager__c) {
              finalDescription += getDescription (add, oldAdd, zfm.Field_Label__c, zfm.API_Name__c);
            } else if (zfm.Ignore_For_Account_Manager__c && zfm.Ignore_For_Feature_Dates_In_Future__c && (oppty.Feature_Date__c < System.Today() || oppty.Feature_Date__c == null)) {
              finalDescription += getDescription (add, oldAdd, zfm.Field_Label__c, zfm.API_Name__c);
            }
          }

          // Populate tickets for City Planners
          if(zc.City_Planner__c) {
            if(!zfm.Ignore_For_City_Planner__c) {
              finalDescription += getDescription (add, oldAdd, zfm.Field_Label__c, zfm.API_Name__c);
            } else if (zfm.Ignore_For_City_Planner__c && zfm.Ignore_For_Feature_Dates_In_Future__c && (oppty.Feature_Date__c < System.Today() || oppty.Feature_Date__c == null)) {
              finalDescription += getDescription (add, oldAdd, zfm.Field_Label__c, zfm.API_Name__c);
            }
          }

          if(!zc.Account_Manager__c && !zc.City_Planner__c) {
            finalDescription += getDescription (add, oldAdd, zfm.Field_Label__c, zfm.API_Name__c);
          }
        } else {
          finalDescription += getDescription (add, oldAdd, zfm.Field_Label__c, zfm.API_Name__c);
        }
      }
    }

    if (isNullXML || oppty.Permalink__c == null) {
      xmlString = null;
    } else {
      xmlString = setupXMLString (oppty.Account.Name, oppty, userVal, finalDescription);
      //--Tags in Zenddesk
      xmlString += addAdditionalTags ('Automation');
      xmlString += addAdditionalTags ('redem');

      if (oppty.Division__c != null) {
        String divsion = String.valueof (oppty.Division__c).replaceAll ('[\\s+,+/+.]', '').toLowerCase();
        xmlString += addAdditionalTags (Divsion);
      }

      xmlString += addTicketFieldEntries (oppty, false);
    }

    return xmlString;
  }

  //expose private methods for Unit Tests
  public static String exposeForUT_setupXMLString (String acctName, Opportunity oppty, User userVal, String finalDescription) {
    TestUtil.checkForUnitTestExecution();

    return setupXMLString (acctName, oppty, userVal, finalDescription);
  }
  public static String exposeForUT_getDescription (SObject newRecord, SObject oldRecord, String fieldLabel, String fieldName) {
    TestUtil.checkForUnitTestExecution();

    return getDescription (newRecord, oldRecord, fieldLabel, fieldName);
  }
  public static String exposeForUT_addAdditionalTags (String tag) {
    TestUtil.checkForUnitTestExecution();

    return addAdditionalTags (tag);
  }
  public static String exposeForUT_addTicketFieldEntries (Opportunity oppty, Boolean checkOnGoLiveDate) {
    TestUtil.checkForUnitTestExecution();

    return addTicketFieldEntries (oppty, checkOnGoLiveDate);
  }
  public static String exposeForUT_formatOpportunity (Opportunity oppty, Opportunity oldOppty, Account acct, User userVal) {
    TestUtil.checkForUnitTestExecution();

    return formatOpportunity (oppty, oldOppty, acct, userVal);
  }
  public static String exposeForUT_formatMultiDeals (Multi_Deal__c multiDeal, Multi_Deal__c oldMultiDeal, User userval, Opportunity oppty) {
    TestUtil.checkForUnitTestExecution();

    return formatMultiDeals (multiDeal, oldMultiDeal, userVal, oppty);
  }
  public static String exposeForUT_formatAddresses (Address__c add, Address__c oldAdd, User userVal, Opportunity oppty) {
    TestUtil.checkForUnitTestExecution();

    return formatAddresses (add, oldAdd, userVal, oppty);
  }
}