/*
*       Description: Trigger handler for lead. This shows the order of execution of the methods defined in the helper class.
*
*       Sr.No.  Version     Author          Date(dd.MON.yyyy)       Description
*  
*       1       1.0         Team Simplus    16.AUG.2018             Initial Draft
*/

public with sharing class LeadTriggerHandler extends TriggerHandler {

    public LeadTriggerHandler() {
        //this.setMaxLoopCount(1);
    }
    
    public override void beforeInsert() {
        LeadTriggerHelper.checkLeadFields(Trigger.new);
        LeadTriggerHelper.recordCustomerContactAttempts((List<Lead>) Trigger.new);

        //These methods are process builder flows.
        LeadTriggerHelper.mapRecordTypeFromPardot(new Map<Id, Lead>(), Trigger.new);
        LeadTriggerHelper.assignPardotTypeToBuilder(Trigger.new);
        LeadTriggerHelper.determineLeadOwner(new Map<Id, Lead>(), Trigger.new);
    }

    public override void afterInsert() {
        //LeadTriggerHelper.leadToPersonAccount(Trigger.new);
        //LeadTriggerHelper.runLeadAssignmentRule(Trigger.new);
        //LeadTriggerHelper.leadToDealerOpp(Trigger.new); Commented out on May 5th, 2020
        LeadTriggerHelper.leadDesign(Trigger.new);

        //These methods are process builder flows.
        LeadTriggerHelper.designServicesCreated(Trigger.new);
    }

    public override void beforeUpdate() {
        LeadTriggerHelper.checkLeadFields(Trigger.new);
        LeadTriggerHelper.getAccountEmail((Map<Id, Lead>) Trigger.oldMap, (List<Lead>) Trigger.new);
        LeadTriggerHelper.assignLeadToTerritory((Map<Id, Lead>) Trigger.oldMap, Trigger.new);
        LeadTriggerHelper.leadTracking((Map<Id, Lead>) Trigger.oldMap, Trigger.new);
        LeadTriggerHelper.recordCustomerContactAttempts((Map<Id, Lead>) Trigger.oldMap, (List<Lead>) Trigger.new);

        //These methods are process builder flows.
        LeadTriggerHelper.mapRecordTypeFromPardot((Map<Id, Lead>) Trigger.oldMap, Trigger.new);
        LeadTriggerHelper.assignPardotTypeToBuilder(Trigger.new);
        LeadTriggerHelper.determineLeadOwner((Map<Id, Lead>) Trigger.oldMap, Trigger.new);
    }

    public override void afterUpdate() {
        //LeadTriggerHelper.leadToPersonAccount(Trigger.new);
        LeadTriggerHelper.recordLeadInfoToAccount((Map<Id, Lead>) Trigger.oldMap, Trigger.new);
        LeadTriggerHelper.updateLostOpps(Trigger.new);
        LeadTriggerHelper.updateOppNameToLeadSubject(Trigger.new);
        LeadTriggerHelper.updateDesignerServices(Trigger.new);
        //LeadTriggerHelper.leadToDealerOpp(Trigger.new); Commented out on May 5th, 2020
        LeadTriggerHelper.convertedUpdField(Trigger.new);
        //LeadTriggerHelper.runLeadAssignmentRule(Trigger.new);
    }

}