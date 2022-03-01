/**
 *  @group          Apex Classes
 *  @description    Contains all Apex Tests for BB_BankingBridgeAPI
 */

@IsTest
public without sharing class BB_BankingBridgeAPI_Test {

    /**
     *  @description    Update Lead Subscription with success result
     */
    @IsTest
    static void testUpdateLeadStatus_Success(){

        //Create new lead with default status
        Lead lead = BB_Lead_DataFactory.createLeadStatus(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_DEFAULT);

        Test.startTest();

        //Create new lead response based on lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Assert response is not null or blank
        System.assertNotEquals( null, leadJSON );
        System.assertNotEquals( '', leadJSON );

        //Set http response mock successful lead status response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.LeadStatusResponseSuccess() );

        //Send lead status data to BankingBridge API returning success response mock
        BB_BankingBridgeAPI.sendLeadData(leadJSON, lead.Id);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert the status of response is success
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'success');

    }

    /**
     *  @description    Update Lead Status with error result
     */
    @IsTest
    static void testUpdateLeadStatus_Error(){

        //Create new lead with default status
        Lead lead = BB_Lead_DataFactory.createLeadStatus(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_DEFAULT);

        Test.startTest();

        //Create new lead response based on lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Assert response is not null or blank
        System.assertNotEquals( null, leadJSON );
        System.assertNotEquals( '', leadJSON );

        //Set http response mock error lead status response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.LeadStatusResponseError() );

        //Send subscription data to BankingBridge API returning error response mock
        BB_BankingBridgeAPI.sendLeadData(leadJSON, lead.Id);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];


        //Assert the status of response is error
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'error');

    }

    /**
     *  @description    Update Lead Status with unauthorized result
     */
    @IsTest
    static void testUpdateLeadStatus_Unauthorized(){

        //Create new lead with default status
        Lead lead = BB_Lead_DataFactory.createLeadStatus(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_DEFAULT);

        Test.startTest();

        //Create new lead response based on lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Assert response is not null or blank
        System.assertNotEquals( null, leadJSON );
        System.assertNotEquals( '', leadJSON );

        //Set http response mock unauthorized callout exception lead response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.UnauthorizedEndpointResponse() );

        //Send subscription data to BankingBridge API returning unauthorized callout exception response mock
        BB_BankingBridgeAPI.sendLeadData(leadJSON, lead.Id);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert the status of response is unauthorized
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'unauthorized');

    }

    /**
     *  @description    Update Lead Subscription with success result
     */
    @IsTest
    static void testUpdateLeadSubscription_Success(){

        //Create new lead with blank subscription id
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('');

        Test.startTest();

        //Create new subscription response based on lead data
        String subscriptionJSON = BB_BankingBridgeAPI.createSubscriptionResponse(lead);

        //Assert response is not null or blank
        System.assertNotEquals( null, subscriptionJSON );
        System.assertNotEquals( '', subscriptionJSON );

        //Set http response mock successful subscription response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseSuccess() );

        //Send subscription data to BankingBridge API returning success response mock
        BB_BankingBridgeAPI.sendSubscriptionData(subscriptionJSON, lead.Id);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert subscription id is id returned within body of the mock
        System.assertEquals(updatedLead.BB_Subscription_ID__c, '1');

        //Assert subscription url returned within body of the mock
        System.assertEquals(updatedLead.BB_Subscription_URL__c, 'http://dashboardlink.com');

        //Assert the status of response is success
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'success');

    }

    /**
     *  @description    Update Lead Subscription with error result
     */
    @IsTest
    static void testUpdateLeadSubscription_Error(){

        //Create new lead with blank subscription id
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('');

        Test.startTest();

        //Create new subscription response based on lead data
        String subscriptionJSON = BB_BankingBridgeAPI.createSubscriptionResponse(lead);

        //Assert response is not null or blank
        System.assertNotEquals( null, subscriptionJSON );
        System.assertNotEquals( '', subscriptionJSON );

        //Set http response mock error subscription response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseError() );

        //Send subscription data to BankingBridge API returning error response mock
        BB_BankingBridgeAPI.sendSubscriptionData(subscriptionJSON, lead.Id);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert no subscription id was entered from error response
        System.assertEquals(updatedLead.BB_Subscription_ID__c, null);

        //Assert no subscription url was entered from error response
        System.assertEquals(updatedLead.BB_Subscription_URL__c, null);

        //Assert the status of response is error
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'error');

    }

    /**
     *  @description    Update Lead Subscription with unauthorized result
     */
    @IsTest
    static void testUpdateLeadSubscription_Unauthorized(){

        //Create new lead with blank subscription id
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('');

        Test.startTest();

        //Create new subscription response based on lead data
        String subscriptionJSON = BB_BankingBridgeAPI.createSubscriptionResponse(lead);

        //Assert response is not null or blank
        System.assertNotEquals( null, subscriptionJSON );
        System.assertNotEquals( '', subscriptionJSON );

        //Set http response mock unauthorized callout exception subscription response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.UnauthorizedEndpointResponse() );

        //Send subscription data to BankingBridge API returning unauthorized callout exception response mock
        BB_BankingBridgeAPI.sendSubscriptionData(subscriptionJSON, lead.Id);

        Test.stopTest();

        //Pull new lead data updated based on http response
        Lead updatedLead = [SELECT BB_Subscription_ID__c, BB_Subscription_URL__c, BB_Last_API_Sync_Status__c FROM Lead WHERE Id =: lead.Id];

        //Assert no subscription id was entered from unauthorized response
        System.assertEquals(updatedLead.BB_Subscription_ID__c, null);

        //Assert no subscription url was entered from unauthorized response
        System.assertEquals(updatedLead.BB_Subscription_URL__c, null);

        //Assert the status of response is unauthorized
        System.assertEquals(updatedLead.BB_Last_API_Sync_Status__c, 'unauthorized');

    }

    /**
     *  @description    Update Lead Subscription with success result
     */
    @IsTest
    static void testGetConnectionStatus_Success(){

        //String to capture connection status
        String responseStatus;

        Test.startTest();

        //Set http response mock successful response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseSuccess() );

        //Retrieve connection from successful mock
        responseStatus = BB_BankingBridgeAPI.getConnectionStatus();

        Test.stopTest();

        //Assert connection is success
        System.assertEquals(responseStatus,BB_BankingBridgeAPI_CONSTANTS.CONNECTION_SUCCESS);

    }

    /**
     *  @description    Update Lead Subscription with error result
     */
    @IsTest
    static void testGetConnectionStatus_Error(){

        //String to capture connection status
        String responseStatus;

        Test.startTest();

        //Set http response mock error response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseError() );

        //Retrieve connection from error mock
        responseStatus = BB_BankingBridgeAPI.getConnectionStatus();

        Test.stopTest();

        //Assert connection is error
        System.assertEquals(responseStatus,BB_BankingBridgeAPI_CONSTANTS.CONNECTION_FAILURE+'error');

    }

    /**
     *  @description    Update Lead Subscription with unauthorized result
     */
    @IsTest
    static void testGetConnectionStatus_Unauthorized(){

        //String to capture connection status
        String responseStatus;

        Test.startTest();

        //Set http response mock unauthorized response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.UnauthorizedEndpointResponse() );

        //Retrieve connection from unauthorized mock
        responseStatus = BB_BankingBridgeAPI.getConnectionStatus();

        Test.stopTest();

        //Assert connection is unauthorized
        System.assertEquals(responseStatus,BB_BankingBridgeAPI_CONSTANTS.CONNECTION_FAILURE+'unauthorized');

    }

    /**
     *  @description    Update Lead Status
     */
    @IsTest
    static void testCreateSubscriptionResponse(){

        //Create new lead with new subscription id
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('14302');

        //Create new subscriptionResponse response using lead data
        String subscriptionJSON = BB_BankingBridgeAPI.createSubscriptionResponse(lead);

        //Deserialize JSON into subscriptionResponse class
        BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse subscriptionResponse = (BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse) JSON.deserialize(subscriptionJSON, BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse.class);

        //Verify all subscription data is what was entered on lead
        System.assertEquals(subscriptionResponse.id,'14302');
        System.assertEquals(subscriptionResponse.nmls,'222222');
        System.assertEquals(subscriptionResponse.loid,'3333333');
        System.assertEquals(subscriptionResponse.first_name,'Test');
        System.assertEquals(subscriptionResponse.last_name,'Lead');
        System.assertEquals(subscriptionResponse.email,'testlead@gmail.com');
        System.assertEquals(subscriptionResponse.phone,'1234567890');
        System.assertEquals(subscriptionResponse.active,true);

        //Verify all quote info data is what was entered on lead
        BB_BankingBridgeAPI_ResponseTypes.quote_infoResponse quote_info = subscriptionResponse.quote_info;
        System.assertEquals(quote_info.credit_score,'700');
        System.assertEquals(quote_info.list_price,'450000');
        System.assertEquals(quote_info.loan_amount,'450000');
        System.assertEquals(quote_info.loan_purpose,'purchase');
        System.assertEquals(quote_info.loan_term,'30');
        System.assertEquals(quote_info.debt_to_income,'20');
        System.assertEquals(quote_info.loan_type,'conventional');
        System.assertEquals(quote_info.military_eligible,'yes');
        System.assertEquals(quote_info.property_type,'single_family_home');
        System.assertEquals(quote_info.residency_type,'primary_home');

        //Verify all location data is what was entered on lead
        BB_BankingBridgeAPI_ResponseTypes.locationResponse location = quote_info.location;
        System.assertEquals(location.city,'Beverly Hills');
        System.assertEquals(location.state,'CA');
        System.assertEquals(location.zipcode,'90210');
        System.assertEquals(location.street_address,'101 Sunset blvd');

        //Verify settings data exists
        BB_BankingBridgeAPI_ResponseTypes.settingsResponse settings = subscriptionResponse.settings;
        System.assertEquals(settings.frequency,'default');

    }

    /**
    *  @description    Update Lead Status
    */
    @IsTest
    static void testCreateLeadResponse_Default() {

        //Create new lead with new status
        Lead lead = BB_Lead_DataFactory.createLeadStatus('New');

        //Create new leadResponse response using lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Deserialize JSON into leadResponse class
        BB_BankingBridgeAPI_ResponseTypes.leadResponse leadResponse = (BB_BankingBridgeAPI_ResponseTypes.leadResponse) JSON.deserialize(leadJSON, BB_BankingBridgeAPI_ResponseTypes.leadResponse.class);

        //Verify leadResponse has correct lead email and status data
        System.assertEquals(leadResponse.email,'testlead@gmail.com');
        System.assertEquals(leadResponse.status,BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_DEFAULT);

    }


    /**
    *  @description    Update Lead Status
    */
    @IsTest
    static void testCreateLeadResponse_Approved() {

        //Create new lead with approved status
        Lead lead = BB_Lead_DataFactory.createLeadStatus('Loan Approved');

        //Create new leadResponse response using lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Deserialize JSON into leadResponse class
        BB_BankingBridgeAPI_ResponseTypes.leadResponse leadResponse = (BB_BankingBridgeAPI_ResponseTypes.leadResponse) JSON.deserialize(leadJSON, BB_BankingBridgeAPI_ResponseTypes.leadResponse.class);

        //Verify leadResponse has correct lead email and status data
        System.assertEquals(leadResponse.email,'testlead@gmail.com');
        System.assertEquals(leadResponse.status,BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_APPROVED);

    }

    /**
    *  @description    Update Lead Status
    */
    @IsTest
    static void testCreateLeadResponse_Locked() {

        //Create new lead with locked status
        Lead lead = BB_Lead_DataFactory.createLeadStatus('Locked');

        //Create new leadResponse response using lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Deserialize JSON into leadResponse class
        BB_BankingBridgeAPI_ResponseTypes.leadResponse leadResponse = (BB_BankingBridgeAPI_ResponseTypes.leadResponse) JSON.deserialize(leadJSON, BB_BankingBridgeAPI_ResponseTypes.leadResponse.class);

        //Verify leadResponse has correct lead email and status data
        System.assertEquals(leadResponse.email,'testlead@gmail.com');
        System.assertEquals(leadResponse.status,BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_LOCKED);

    }


    /**
    *  @description    Update Lead Status
    */
    @IsTest
    static void testCreateLeadResponse_Closed() {

        //Create new lead with closed status
        Lead lead = BB_Lead_DataFactory.createLeadStatus('Closed Won');

        //Create new leadResponse response using lead data
        String leadJSON = BB_BankingBridgeAPI.createLeadResponse(lead);

        //Deserialize JSON into leadResponse class
        BB_BankingBridgeAPI_ResponseTypes.leadResponse leadResponse = (BB_BankingBridgeAPI_ResponseTypes.leadResponse) JSON.deserialize(leadJSON, BB_BankingBridgeAPI_ResponseTypes.leadResponse.class);

        //Verify leadResponse has correct lead email and status data
        System.assertEquals(leadResponse.email,'testlead@gmail.com');
        System.assertEquals(leadResponse.status,BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_CLOSED);

    }

}