/*
Owner: Naushad Rafique
Created Date: 1/29/2013
TestClass : TestEventServices
Last Modified By: Naushad Rafique
Last Modified Date: 1/29/2013 
Batch class to stamp certain fields on the Event record that were completed today
*/
global without sharing class BatchCompletedEventUpdates implements Database.Batchable<SObject>, Schedulable
{
	public String query{get; private set;}
	public static final String EVENT_TYPE_MERCHANT_CALL = '';
	public static final String EVENT_TYPE_MERCHANT_MEETING = '';
	
	public BatchCompletedEventUpdates()
	{
		query = 'Select ID, WhatID, WhoID, StartDateTime, EndDateTime, Completed_Date_Time__c, Completed_Date__c, Completed_By__c, ';
		query += ' Call_List_Priority__c, Sales_Value__c, DurationInMinutes, IsAllDayEvent ';
		query += ' from Event where EndDateTime != null ';
		query += ' and ( (isAllDayEvent = false and EndDateTime = TODAY) or (isAllDayEvent = true and EndDateTime = YESTERDAY) ) ';
		query += ' and Completed_Date_Time__c = null ';
		query += ' and (Type = \''+EVENT_TYPE_MERCHANT_CALL+'\' OR Type = \''+EVENT_TYPE_MERCHANT_MEETING+'\' )';
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext bc, List<SObject> batchRecords)
	{
		List<Event> events = (List<Event>) batchRecords;
		EventServices.stampCompletedFieldsOnCompletedEvents(events);
	}
	
	global void finish(Database.BatchableContext bc)
	{
	}
	
	public static void startBatch()
	{
		BatchCompletedEventUpdates bceu = new BatchCompletedEventUpdates();
		Database.executeBatch(bceu, 200);
	}
	
	public void execute(SchedulableContext sc)
	{
		startBatch();
	}
	
}