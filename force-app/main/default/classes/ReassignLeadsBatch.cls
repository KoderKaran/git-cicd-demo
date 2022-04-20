global class ReassignLeadsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    String query;
    //Boolean isActive = false;
    Map<Id, Lead> leadmap = new Map<Id, Lead>();
    
    public ReassignLeadsBatch(String query, Map<Id, Lead> leadmap) {
        this.query = query;
        this.leadmap = leadmap; 

        //String customerSTatus = CheckTPSStatus.checkimmestatus();
        //if(customerSTatus == 'Active')
        //{
            //isActive = true;
        //}      
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        //String customerSTatus = CheckTPSStatus.checkimmestatus();
        //if(customerSTatus == 'Active') {
            List<Lead> leads = (List<Lead>)scope;

            //Lead thisLead = leadmap.get(leads[0].Id);
            if(!leads.isEmpty()) {
                //thisLead = leads.get(0);
                for(Lead l : leads) {
                    update ReassignLeadsHelper.assignLeadTerr(l);
                }
            }
            if(!leadmap.isEmpty()) {
                for(Lead l : leadmap.values()) {
                    update ReassignLeadsHelper.assignLeadTerr(l);
                }
            }
            
            //update thisLead;
        //}
        
    }
    
    global void finish(Database.BatchableContext bc) {

    }
}