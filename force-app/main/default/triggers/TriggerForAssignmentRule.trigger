/*
 *  Description: Trigger on Lead to auto-populate 'Assign using active assignment rule'
 */
trigger TriggerForAssignmentRule on Lead (after insert) {    
    
    // Check if trigger is on after insert
    if(trigger.isInsert && trigger.isAfter){
        
        // Get an Active Lead Assignement Rule Id
        Id leadAssignmentRuleId = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' AND Active = true][0].Id;
        
        // Call the handler by passing list of new Leads and Active Assignment Rule Id
        new LeadAssignmentTriggerHandler(trigger.new, leadAssignmentRuleId);
    }
}