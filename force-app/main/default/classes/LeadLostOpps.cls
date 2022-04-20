public class LeadLostOpps {
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Lead> oldMap;
    Map<Id, Lead> newMap;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public LeadLostOpps(
        Map<Id, Lead> oldTrigger, 
        Map<Id, Lead> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
        }
    
    // The one method your master trigger will call
    public void updateLostOpps() {
        //Set up the ID trackers
        Set<ID> leadid = new Set<ID>();
        //Map the Lead IDs from the Trigger
        for(Lead l : newMap.values())
        {
            If(l.Status.equals('Installed'))
                leadid.add(l.Id);
        }
        //Get all the leads
        List<Opportunity> opplist = [SELECT Id, AccountID, Associated_Lead__c,StageName FROM Opportunity WHERE Associated_Lead__r.id IN : leadid AND StageName != 'Closed Won'];
        IF(opplist.size() > 0)
        {
            For(Opportunity op : opplist)
            {
                op.StageName = 'Closed Lost';
                update op;
            }
        }
    }
}