/**
 *	@group 			Apex Classes
 * 	@description	Data Factory for Leads
 */
@IsTest
public without sharing class BB_Lead_DataFactory {

    /**
     *	@description 			Creates a test lead with quote information
     * 	@param subscriptionId 	subscription Id assigned to the lead
     * 	@return 				The created lead
     */
    public static Lead createLeadSubscription( String subscriptionId) {

        Lead lead = new Lead();
        lead.BB_Subscription_ID__c = subscriptionId;
        lead.BB_NMLS__c = '222222';
        lead.BB_LOID__c = '3333333';
        lead.FirstName = 'Test';
        lead.LastName = 'Lead';
        lead.Company = 'Test Company';
        lead.Email = 'testlead@gmail.com';
        lead.Phone = '1234567890';
        lead.BB_Credit_Score__c = 700;
        lead.BB_Property_Value__c = 450000;
        lead.BB_Loan_Amount__c = 450000;
        lead.BB_Loan_Purpose__c = 'purchase';
        lead.BB_Loan_Term__c = '30';
        lead.BB_Debt_to_Income__c = 20;
        lead.BB_Loan_Type__c = 'conventional';
        lead.BB_Military_Eligible__c = true;
        lead.BB_Property_Type__c = 'single_family_home';
        lead.BB_Residency_Type__c = 'primary_home';
        lead.BB_Property_City__c = 'Beverly Hills';
        lead.BB_Property_State__c = 'CA';
        lead.BB_Property_Zipcode__c = '90210';
        lead.BB_Property_Street_Address__c = '101 Sunset blvd';
        insert lead;
        return lead;

    }


    /**
     *	@description 			Creates a test lead with a lead status
     * 	@param leadStatus 	    Lead status string assigned to the lead
     * 	@return 				The created lead
     */
    public static Lead createLeadStatus( String leadStatus) {

        Lead lead = new Lead();
        lead.Status = leadStatus;
        lead.FirstName = 'Test';
        lead.LastName = 'Lead';
        lead.Company = 'Test Company';
        lead.Email = 'testlead@gmail.com';
        insert lead;
        return lead;

    }

}