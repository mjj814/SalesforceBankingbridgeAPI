/**
 *  @group          Apex Classes
 *  @description    Controller for BB_LeadSubscription page
 */

public with sharing class BB_LeadSubscriptionController {

    //Lead used to update
    private final Lead lead;
    ApexPages.StandardController controller;

    //Pull in lead from standard controller
    public BB_LeadSubscriptionController(ApexPages.StandardController stdController) {

        this.lead = (Lead)stdController.getRecord();
        controller = stdController;

    }

    //Standard save method override for additional validation
    public PageReference saveSubscription(){

        //If NMLS is left blank, LOID is required
        if(lead.BB_NMLS__c == null && lead.BB_LOID__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter LOID if NMLS is blank'));
            return null;
        }else {
            return controller.save();
        }

    }

}