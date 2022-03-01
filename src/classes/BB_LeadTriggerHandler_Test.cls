/**
 *  @group          Apex Classes
 *  @description    Contains all Apex Tests for BB_LeadTriggerHandler and BB_LeadTrigger
 */

@IsTest
public without sharing class BB_LeadTriggerHandler_Test {

    /**
     *  @description    Insert new lead with status to send to bankingbridge api mock and retrieve status
     */
    @IsTest
    static void testInsertLeadStatus(){

        //Retrieve the org defaults for BankingBridge_API_Settings__c custom setting
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //If there are no org defaults, create a new org default custom setting for BankingBridge_API_Settings__c
        if( bankingBridgeAPISettings == null || bankingBridgeAPISettings.Id == null ) {
            bankingBridgeAPISettings = new BankingBridge_API_Settings__c();
            bankingBridgeAPISettings.API_Key__c = '123';
            bankingBridgeAPISettings.Brand_ID__c = '1';
            upsert bankingBridgeAPISettings;
        }

        Test.startTest();

        //Set http response mock successful lead status response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.LeadStatusResponseSuccess() );

        //Create new lead with default status, trigger should update lead after callout to leadstatus api mock
        Lead lead = BB_Lead_DataFactory.createLeadStatus(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_DEFAULT);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert the status of response is success
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'success');

    }

    /**
     *  @description    Update lead with status to send to bankingbridge api mock and retrieve status
     */
    @IsTest
    static void testUpdateLeadStatus(){

        //Retrieve the org defaults for BankingBridge_API_Settings__c custom setting
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //If there are no org defaults, create a new org default custom setting for BankingBridge_API_Settings__c
        if( bankingBridgeAPISettings == null || bankingBridgeAPISettings.Id == null ) {
            bankingBridgeAPISettings = new BankingBridge_API_Settings__c();
            bankingBridgeAPISettings.API_Key__c = '123';
            bankingBridgeAPISettings.Brand_ID__c = '1';
            upsert bankingBridgeAPISettings;
        }

        Test.startTest();

        //Set http response mock successful lead status response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.LeadStatusResponseSuccess() );

        //Create new lead with null status
        Lead lead = BB_Lead_DataFactory.createLeadStatus(null);

        //Assert the status is blank
        System.assert(String.isBlank(lead.BB_Last_API_Sync_Status__c));

        //Update lead to approved status, trigger should update lead after callout to leadstatus api mock
        lead.Status = BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_APPROVED;
        update lead;

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert the status of response is success
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'success');

    }

    /**
     *  @description    Insert new lead with subscription to send to bankingbridge api mock and retrieve status
     */
    @IsTest
    static void testInsertLeadSubscription(){

        //Retrieve the org defaults for BankingBridge_API_Settings__c custom setting
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //If there are no org defaults, create a new org default custom setting for BankingBridge_API_Settings__c
        if( bankingBridgeAPISettings == null || bankingBridgeAPISettings.Id == null ) {
            bankingBridgeAPISettings = new BankingBridge_API_Settings__c();
            bankingBridgeAPISettings.API_Key__c = '123';
            upsert bankingBridgeAPISettings;
        }

        Test.startTest();

        //Set http response mock successful subscription response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseSuccess());

        //Create new lead without subscription id, trigger should update lead after callout to leadstatus api mock
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('');

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert subscription id is id returned within body of the mock
        System.assertEquals(updatedLead.BB_Subscription_ID__c, '1');

        //Assert dashboard link is link returned within body of the mock
        System.assertEquals(updatedLead.BB_Subscription_URL__c, 'http://dashboardlink.com');

        //Assert the status of response is success
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'success');

    }

    /**
     *  @description    Update lead with subscription to send to bankingbridge api mock and retrieve status
     */
    @IsTest
    static void testUpdateLeadSubscription(){

        //Retrieve the org defaults for BankingBridge_API_Settings__c custom setting
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //If there are no org defaults, create a new org default custom setting for BankingBridge_API_Settings__c
        if( bankingBridgeAPISettings == null || bankingBridgeAPISettings.Id == null ) {
            bankingBridgeAPISettings = new BankingBridge_API_Settings__c();
            bankingBridgeAPISettings.API_Key__c = '123';
            upsert bankingBridgeAPISettings;
        }

        Test.startTest();

        //Set http response mock successful lead status response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseSuccess() );

        //Create new lead with subscription id so initial api callout is not made
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('1234');

        //Pull lead information
        lead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert dashboard link is blank
        System.assert(String.isBlank(lead.BB_Subscription_URL__c));

        //Assert the status is blank
        System.assert(String.isBlank(lead.BB_Last_API_Sync_Status__c));

        //Update lead NMLS and null subscription, trigger should update lead after callout to subcription api mock
        lead.BB_Subscription_ID__c = null;
        lead.BB_NMLS__c = '999';
        update lead;

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert subscription id is id returned within body of the mock
        System.assertEquals(updatedLead.BB_Subscription_ID__c, '1');

        //Assert dashboard link is link returned within body of the mock
        System.assertEquals(updatedLead.BB_Subscription_URL__c, 'http://dashboardlink.com');

        //Assert the status of response is success
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'success');

    }

}