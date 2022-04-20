/*
 *    Description: Handler class for trigger on Lead to Update Lead Owner with respect to Assignment Rule
 * 
 */
public with sharing class LeadAssignmentTriggerHandler {
    
    // Controller method to assign appropriate User, Queue or Group based on an active assignment rule
    public LeadAssignmentTriggerHandler(List<Lead> listLeads, Id leadAssignmentRuleId){
        
        // Set Assignment Rule Header with an active assignment rule id
        Database.DMLOptions dmlOptInst = new Database.DMLOptions();
        dmlOptInst.assignmentRuleHeader.assignmentRuleId = leadAssignmentRuleId;
        
        // Set to hold Id's for Leads recently inserted
        Set<Id> setLeadId = new Set<Id>();
        
        // List of Leads to update
        List<Lead> listLeadToUpdate = new List<Lead>();
        
        // Get set of Lead ids
        for(Lead objLead : listLeads) {
            setLeadId.add(objLead.Id);
        }
        
        // Query on Leads to get all the Leads in the set and update the list of Leads
        for(Lead objLead : [SELECT Id FROM Lead WHERE Id IN: setLeadId]) {
            objLead.setOptions(dmlOptInst);
            listLeadToUpdate.add(objLead);
        }
        
        // Carry out update activity on Leads
        Database.update(listLeadToUpdate);
    }
}