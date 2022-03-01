/**
 *	@group          Triggers
 * 	@description    Lead Trigger
 */
trigger BB_LeadTrigger on Lead (after insert, after update) {

    BB_LeadTriggerHandler leadTriggerHandler = new BB_LeadTriggerHandler();
    leadTriggerHandler.run();

}