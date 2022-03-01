/**
 *  @group          Apex Classes
 *  @description    Contains all Apex Tests for BB_LeadSubscriptionController
 */

@IsTest
private class BB_LeadSubscriptionController_Test {

    /**
     *  @description    Save lead subscription successfully
     */
    @IsTest
    static void testSaveSubscription_Success() {

        //Create new lead with blank subscription id
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('');

        //Create new standard controller with lead
        Apexpages.StandardController sc = new Apexpages.StandardController(lead);

        //Create new BB_LeadSubscriptionController with standard controller
        BB_LeadSubscriptionController leadSubscriptionController = new BB_LeadSubscriptionController(sc);

        Test.startTest();

        //Update NMLS
        lead.BB_NMLS__c = '1';

        //Save lead
        leadSubscriptionController.saveSubscription();

        Test.stopTest();

        //Retrieve new lead information
        Lead updatedLead = [Select BB_NMLS__c from Lead where Id =: lead.Id];

        //Assert NMLS is updated
        System.assertEquals(updatedLead.BB_NMLS__c,'1');
    }


    /**
 *  @description    Save lead subscription with blank NMLS and LOID - error message shown
 */
    @IsTest
    static void testSaveSubscription_Failure() {

        //Create new lead with blank subscription id
        Lead lead = BB_Lead_DataFactory.createLeadSubscription('');

        //Create new standard controller with lead
        Apexpages.StandardController sc = new Apexpages.StandardController(lead);

        //Create new BB_LeadSubscriptionController with standard controller
        BB_LeadSubscriptionController leadSubscriptionController = new BB_LeadSubscriptionController(sc);

        Test.startTest();

        //Update NMLS
        lead.BB_NMLS__c = null;
        lead.BB_LOID__c = null;

        //Save lead
        leadSubscriptionController.saveSubscription();

        Test.stopTest();

        //Assert page message error
        System.assertEquals(ApexPages.getMessages()[0].getSummary(),'Please enter LOID if NMLS is blank');

        //Retrieve new lead information
        Lead updatedLead = [Select BB_NMLS__c,BB_LOID__c from Lead where Id =: lead.Id];

        //Assert NMLS is not updated
        System.assertNotEquals(updatedLead.BB_NMLS__c,null);

        //Assert LOID is not updated
        System.assertNotEquals(updatedLead.BB_LOID__c,null);
    }
}