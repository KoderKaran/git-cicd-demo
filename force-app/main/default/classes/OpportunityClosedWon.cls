public class OpportunityClosedWon {
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Opportunity> oldMap;
    Map<Id, Opportunity> newMap;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public OpportunityClosedWon(
        Map<Id, Opportunity> oldTrigger, 
        Map<Id, Opportunity> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
        }
    
    // The one method your master trigger will call
    // Functional Concern over multiple opps pointing to the same lead
    public void updateLeadStatus() {
        //Set up the ID trackers
        Set<ID> oppid = new Set<ID>();
        Map<Id,Opportunity> oppStatus = new Map<Id,Opportunity>();
        //Iterate through updated opportunity
        for(Opportunity opp : newMap.values())
        {
            // Check the old status vrs the new status for change
            if(opp.Associated_Lead__c != null && (oldMap.get( opp.Id ).StageName != opp.StageName ||  oldMap.get( opp.Id ).Probability != opp.Probability))
                oppStatus.put(opp.Associated_Lead__c, opp);
        }
        //Get the associated Lead's information to update
        List<Lead> lds = [SELECT Status, ID, Opportunity_Stage__c, Opportunity_Probability__c FROM Lead WHERE ID IN :oppStatus.keySet() AND Status != 'Installed'];
        List<Lead> toUpd = new List<Lead>();
        for(Lead ld : lds)
        {
            Boolean add = false;
            if(ld.Opportunity_Probability__c == null || oppStatus.get(ld.Id).Probability > ld.Opportunity_Probability__c){
                add = true;
                ld.Opportunity_Stage__c = oppStatus.get(ld.Id).StageName;
                ld.Opportunity_Probability__c = oppStatus.get(ld.Id).Probability;
            }
            if(oppStatus.get(ld.Id).StageName.equals('Closed Won') && !ld.Status.equals('Installed')){
                ld.Status = 'Installed';
                add = true;
            }
            if(add)
                toUpd.add(ld);
        }
        if(toUpd.size() > 0)
            Update toUpd;
    }
}