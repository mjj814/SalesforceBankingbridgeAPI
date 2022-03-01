/**
 *	@group BankingBridge API
 * 	@description Constants for all variables related to BankingBridge API
 */
public without sharing class BB_BankingBridgeAPI_CONSTANTS {

    private static final String CLASS_NAME = 'BankingBridgeAPI_CONSTANTS';

    //End point of the BankingBridge API for Lead Status
    public static final String ENDPOINT_LEAD_STATUS  = 'https://api.bankingbridge.com/lead-status';

    //End point of the BankingBridge API for Subscription
    public static final String ENDPOINT_SUBSCRIPTION  = 'https://api.bankingbridge.com/subscription';

    //API Key of BankingBridge API
    public static BankingBridge_API_Settings__c bankingBridgeAPISettings = BankingBridge_API_Settings__c.getOrgDefaults();
    public static final String API_KEY  = String.valueOf(bankingBridgeAPISettings.API_Key__c)==null?'':String.valueOf(bankingBridgeAPISettings.API_Key__c);

    //Brand ID of BankingBridge API
    public static final String BRAND_ID  = String.valueOf(bankingBridgeAPISettings.Brand_ID__c)==null?'':String.valueOf(bankingBridgeAPISettings.Brand_ID__c);

    //Message for successful connection to BankingBridge API
    public static final String CONNECTION_SUCCESS  = 'Connection Successful';

    //Message for failed connection to BankingBridge API
    public static final String CONNECTION_FAILURE  = 'Connection Error: ';

    //Default lead status
    public static final String LEADSTATUS_DEFAULT  = 'applied';

    //Lead status for approved leads
    public static final String LEADSTATUS_APPROVED  = 'approved';

    //Lead status for locked leads
    public static final String LEADSTATUS_LOCKED  = 'locked';

    //Lead status for closed leads
    public static final String LEADSTATUS_CLOSED  = 'closed';

}