trigger OpportunityTrigger on Opportunity (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
        
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                // OpportunityTriggerHandler.opp populates Opportunity.AccountID if Opportunity.RecordType = "Showroom Event"
                OpportunityTriggerHandler oppHandler =  new OpportunityTriggerHandler(Trigger.oldMap, Trigger.newMap);
                oppHandler.opp(Trigger.new);
            } 
            if (Trigger.isUpdate) {
                			
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                OpportunityTriggerHandler oppHandler =  new OpportunityTriggerHandler(Trigger.oldMap, Trigger.newMap); 
                oppHandler.insertOppTeam(true);
                oppHandler.transferLeadMessage(Trigger.new);
            } 
            if (Trigger.isUpdate) {
                // This updates the associate lead to 'Installed' if the opportunity stage is closed won.
                OpportunityClosedWon ocw = new OpportunityClosedWon(Trigger.oldMap, Trigger.newMap);
                ocw.updateLeadStatus();       
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }