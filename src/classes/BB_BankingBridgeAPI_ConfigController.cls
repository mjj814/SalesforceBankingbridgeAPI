/**
 *	@group 			BankingBridge API
 * 	@description	Class used to control BankingBridge API Configuration page
 */
public without sharing class BB_BankingBridgeAPI_ConfigController {

    public BankingBridge_API_Settings__c bankingBridgeAPISettings {get;set;}

    //Action initiated on page load. If there are no org default custom settings for BankingBridge_API_Settings__c, create them
    public void createBankingBridgeAPISettings(){

        //Retrieve the org defaults for BankingBridge_API_Settings__c custom setting
        bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();

        //If there are no org defaults, create a new org default custom setting for BankingBridge_API_Settings__c
        if( bankingBridgeAPISettings == null || bankingBridgeAPISettings.Id == null ) {
            bankingBridgeAPISettings = new BankingBridge_API_Settings__c();
            upsert bankingBridgeAPISettings;
        }
    }


    //Method used ot save the API key in the page to the custom setting
    public PageReference saveAPIKey(){

        //Update custom setting
        update bankingBridgeAPISettings;

        //Add message to page API Key is saved
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'API Key Saved'));

        //Return null to refresh page state
        return null;
    }


    //Method used ot save the Brand ID in the page to the custom setting
    public PageReference saveBrandID(){

        //Update custom setting
        update bankingBridgeAPISettings;

        //Add message to page Brand ID is saved
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Brand ID Saved'));

        //Return null to refresh page state
        return null;
    }


    //Method used to check if API key entered is valid by doing a callout to the BankingBridge API
    public PageReference testConnection(){

        //Perform callout to BankingBridge API to check the connection status
        String connectionStatus = BB_BankingBridgeAPI.getConnectionStatus();

        //If the connection status retrieved is success, display green success message
        if(connectionStatus == BB_BankingBridgeAPI_CONSTANTS.CONNECTION_SUCCESS){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, connectionStatus));

        //If the connection status retrieved is not success, show red connection error with connection message
        }else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, connectionStatus));
        }

        //Return null to refresh page state
        return null;
    }

}