/**
 *  @group          Apex Classes
 *  @description    Contains Apex logic for LeadTriggerHandler
 */
public without sharing class BB_LeadTriggerHandler extends BB_TriggerHandler{

    // reserved for the old leads from the trigger, will be assigned in the constructor
    @TestVisible
    private List<Lead> oldLeads = null;

    // reserved for the new leads from the trigger, will be assigned in the constructor
    @TestVisible
    private List<Lead> newLeads = null;


    public BB_LeadTriggerHandler() {
        newLeads = Trigger.new;
        oldLeads = Trigger.old;
    }

    /**
	 *	@description	Handles the logic of this trigger after insert
	 */
    public override void afterInsert() {

        if(!String.isBlank(BB_BankingBridgeAPI_CONSTANTS.API_KEY)) {
            for (Integer i = 0; i < newLeads.size(); i++) {
                //If Lead Status is not blank with a Brand ID, send to BankingBridge API
                if (newLeads[i].Status != null && !String.isBlank(newLeads[i].Email) && !String.isBlank(BB_BankingBridgeAPI_CONSTANTS.BRAND_ID)) {
                    BB_BankingBridgeAPI.sendLeadData(BB_BankingBridgeAPI.createLeadResponse(newLeads[i]), newLeads[i].Id);
                }
                //If NMLS entered and all required subscription fields have a value, push subscription info
                if (newLeads[i].BB_Property_Zipcode__c != null && newLeads[i].BB_Credit_Score__c != null && newLeads[i].BB_Loan_Amount__c != null && newLeads[i].BB_Property_Value__c != null && !String.isBlank(newLeads[i].Email) && (newLeads[i].BB_NMLS__c != null || newLeads[i].BB_LOID__c != null) && String.isBlank(newLeads[i].BB_Subscription_ID__c)) {
                    BB_BankingBridgeAPI.sendSubscriptionData(BB_BankingBridgeAPI.createSubscriptionResponse(newLeads[i]), newLeads[i].Id);
                }
            }
        }

    }

    /**
	 *	@description	Handles the logic of this trigger after update
	 */
    public override void afterUpdate() {

        if(!String.isBlank(BB_BankingBridgeAPI_CONSTANTS.API_KEY)) {
            for (Integer i = 0; i < newLeads.size(); i++) {
                //If Lead Status is changed with a Brand ID, send to BankingBridge API
                if (newLeads[i].Status != oldLeads[i].Status && !String.isBlank(newLeads[i].Email) && !String.isBlank(BB_BankingBridgeAPI_CONSTANTS.BRAND_ID)) {
                    BB_BankingBridgeAPI.sendLeadData(BB_BankingBridgeAPI.createLeadResponse(newLeads[i]), newLeads[i].Id);
                }
                //If NMLS or LOID changed and all required subscription fields have a value, push subscription info if no subscription Id exists
                if (newLeads[i].BB_Property_Zipcode__c != null && newLeads[i].BB_Credit_Score__c != null && newLeads[i].BB_Loan_Amount__c != null && newLeads[i].BB_Property_Value__c != null && (newLeads[i].BB_NMLS__c != null || newLeads[i].BB_LOID__c != null) && (newLeads[i].BB_NMLS__c != oldLeads[i].BB_NMLS__c || newLeads[i].BB_LOID__c != oldLeads[i].BB_LOID__c)&& !String.isBlank(newLeads[i].Email) && String.isBlank(newLeads[i].BB_Subscription_ID__c)) {
                    BB_BankingBridgeAPI.sendSubscriptionData(BB_BankingBridgeAPI.createSubscriptionResponse(newLeads[i]), newLeads[i].Id);
                }
            }
        }

    }


}