/*
*       Description: Master trigger for Lead
*
*       Sr.No.  Version     Author          Date(dd.MON.yyyy)       Description
*  
*       1       1.0         Team Simplus    16.AUG.2018             Initial Draft
*/

trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new LeadTriggerHandler().run();
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {

        } 
        if (Trigger.isUpdate) {
                        
        }
        if (Trigger.isDelete) {
            // Call class logic here!
        }
    }
    if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                
            } 
            if (Trigger.isUpdate) {
            
                LeadOppDesignerServices leaddesign = new LeadOppDesignerServices(Trigger.oldMap, Trigger.newMap);
                leaddesign.updateDesignerServices();    
                
                LeadConvertHelper leadConvert = new LeadConvertHelper();
                leadConvert.updateOpportunity(Trigger.new); 
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
}