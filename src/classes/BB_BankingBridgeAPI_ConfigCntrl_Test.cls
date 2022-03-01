/**
 *  @group          Apex Classes
 *  @description    Contains all Apex Tests for BB_BankingBridgeAPI_ConfigController
 */

@IsTest
public without sharing class BB_BankingBridgeAPI_ConfigCntrl_Test {

    /**
     *  @description    Test creation of BankingBridge_API_Settings__c defaults
     */
    @IsTest
    static void testCreateBankingBridgeAPISettings() {

        //Pull default BankingBridge_API_Settings__c
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //Assert without creating a default the Id is blank
        System.assert(bankingBridgeAPISettings.Id == null);

        //Create new BankingBridge_API_Settings__c default
        BB_BankingBridgeAPI_ConfigController configController = new BB_BankingBridgeAPI_ConfigController();
        configController.createBankingBridgeAPISettings();

        //Pull default BankingBridge_API_Settings__c now created
        bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //Assert the Id is not blank
        System.assert(bankingBridgeAPISettings.Id != null);

    }

    /**
     *  @description    Test update of Banking_Bridge_API_Settings__c.API_Key__c
     */
    @IsTest
    static void testUpdateAPIKey() {

        //Create new BankingBridge_API_Settings__c default
        BB_BankingBridgeAPI_ConfigController configController = new BB_BankingBridgeAPI_ConfigController();
        configController.createBankingBridgeAPISettings();

        //Add API Key
        configController.bankingBridgeAPISettings.API_Key__c = '1';

        //Save API key
        configController.saveAPIKey();

        //Retrieve Banking_Bridge_API_Settings__c defaults
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //Assert the key was updated
        System.assertEquals(bankingBridgeAPISettings.API_Key__c,'1');

    }

    /**
    *  @description    Test update of Banking_Bridge_API_Settings__c.Band_ID__c
    */
    @IsTest
    static void testUpdateBrandID() {

        //Create new BankingBridge_API_Settings__c default
        BB_BankingBridgeAPI_ConfigController configController = new BB_BankingBridgeAPI_ConfigController();
        configController.createBankingBridgeAPISettings();

        //Add Brand ID
        configController.bankingBridgeAPISettings.Brand_ID__c = '2';

        //Save Brand ID
        configController.saveBrandID();

        //Retrieve Banking_Bridge_API_Settings__c defaults
        BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //Assert the key was updated
        System.assertEquals(bankingBridgeAPISettings.Brand_ID__c,'2');

    }


    /**
     *  @description    Test testConnection method with success response
     */
    @IsTest
    static void testTestConnectionSuccess() {

        //Create new BB_BankingBridgeAPI_ConfigController
        BB_BankingBridgeAPI_ConfigController configController = new BB_BankingBridgeAPI_ConfigController();

        Test.startTest();

        //Set http response mock success response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseSuccess() );

        //Retrieve connection from success mock
        configController.testConnection();

        Test.stopTest();

        //Assert page message success
        System.assertEquals(ApexPages.getMessages()[0].getSummary(),BB_BankingBridgeAPI_CONSTANTS.CONNECTION_SUCCESS);

    }

    /**
     *  @description    Test testConnection method with error response
     */
    @IsTest
    static void testTestConnectionError() {

        //Create new BB_BankingBridgeAPI_ConfigController
        BB_BankingBridgeAPI_ConfigController configController = new BB_BankingBridgeAPI_ConfigController();

        Test.startTest();

        //Set http response mock error response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.SubscriptionResponseError() );

        //Retrieve connection from error mock
        configController.testConnection();

        Test.stopTest();

        //Assert page message error
        System.assertEquals(ApexPages.getMessages()[0].getSummary(),BB_BankingBridgeAPI_CONSTANTS.CONNECTION_FAILURE+'error');

    }

    /**
     *  @description    Test testConnection method with unauthorized response
     */
    @IsTest
    static void testTestConnectionUnauthorized() {

        //Create new BB_BankingBridgeAPI_ConfigController
        BB_BankingBridgeAPI_ConfigController configController = new BB_BankingBridgeAPI_ConfigController();

        Test.startTest();

        //Set http response mock error response
        Test.setMock( HttpCalloutMock.class, new BB_BankingBridgeAPI_Mock.UnauthorizedEndpointResponse() );

        //Retrieve connection from error mock
        configController.testConnection();

        Test.stopTest();

        //Assert page message unauthorized
        System.assertEquals(ApexPages.getMessages()[0].getSummary(),BB_BankingBridgeAPI_CONSTANTS.CONNECTION_FAILURE+'unauthorized');

    }

}