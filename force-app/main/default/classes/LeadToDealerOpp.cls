public class LeadToDealerOpp {
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Lead> oldMap;
    Map<Id, Lead> newMap;
    Id oppRT;
    Id oppBalihooRT;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public LeadToDealerOpp(
        Map<Id, Lead> oldTrigger, 
        Map<Id, Lead> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
            oppRT = [select Id from RecordType where SObjectType = 'Opportunity' AND DeveloperName = 'Telesales'].Id;
        }
    
    // The one method your master trigger will call
    public void CreateOpps() {
        //Set up the ID trackers
        Set<ID> leadids = new Set<ID>();
        Set<ID> dealer1ids = new Set<ID>();
        Set<ID> dealer2ids = new Set<ID>();
        Set<ID> dealer3ids = new Set<ID>();
        //Get the Opportunity lists
        list<Opportunity> opplist = new list<Opportunity>();
        Map<Id,Lead> leadsToUpdate = new Map<Id,Lead>();
        oppBalihooRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Balihoo').getRecordTypeId();
        
        // Process updated leads and check for the need to create new Opportunities
        for(Lead ld : newMap.values())
        {
            // Create new instance of lead to allow updating again
            Lead l = ld.clone(true, true, true, true);
            // Don't make changes to converted leads because the system gets angry
            if(l.IsConverted == false && (l.Status == 'Sent to dealer' || l.Status == 'Opportunity Created')){
                // If we have a new Dealer 1 that hasn't been processed before, then create the new Opp and tag the lead as processed
                if(l.Dealer__c != Null  && l.Opportunity_Created__c == false)
                {
                    opplist.add(createOppFromLead(l, l.Dealer__c));
                    l.Opportunity_Created__c = true;
                    l.Status = 'Opportunity Created';
                    leadsToUpdate.put(l.Id, l);
                }
                // If we have a new Dealer 2 that hasn't been processed before, then create the new Opp and tag the lead as processed
                if(l.Dealer_2__c != Null  && l.Opportunity_Created_2__c == false)
                {
                    opplist.add(createOppFromLead(l, l.Dealer_2__c));
                    l.Opportunity_Created_2__c = true;
                    l.Status = 'Opportunity Created';
                    leadsToUpdate.put(l.Id, l);
                }
                // If we have a new Dealer 3 that hasn't been processed before, then create the new Opp and tag the lead as processed
                if(l.Dealer_3__c != Null  && l.Opportunity_Created_3__c == false)
                {
                    opplist.add(createOppFromLead(l, l.Dealer_3__c));
                    l.Opportunity_Created_3__c = true;
                    l.Status = 'Opportunity Created';
                    leadsToUpdate.put(l.Id, l);
                }
            }
        }
        
        if(opplist.size() > 0)
            Database.Insert(opplist);
        
        if(leadsToUpdate.size() > 0)
            Database.Update(leadsToUpdate.values());
        
               
    }
    
    
    private Opportunity createOppFromLead(Lead ld, Id dealerId){
        //Create the opportunity based off lead information
        Opportunity lc = new Opportunity();
        if(ld.From_Balihoo__c){
            lc.RecordTypeId = oppBalihooRT;
        }else{
            lc.RecordTypeId = oppRT;
        }
        lc.Name = ld.Name == null? ld.FirstName + ' ' + ld.LastName : ld.Name;
        lc.Phone__c = ld.Phone;
        lc.City__c = ld.City;
        lc.Email__c = ld.Email;
        lc.State_Province__c = ld.State;
        lc.Country__c = ld.Country;
        lc.Zip_Postal_Code__c = ld.PostalCode;
        lc.Street__c = ld.Street;
        lc.Associated_Lead__c = ld.id;
        lc.AccountId = dealerId;
        lc.StageName = 'Sent to Dealer';
        lc.Entertainment__c = ld.Entertainment__c;
        lc.LightingSolutions__c = ld.Lighting__c;
        lc.Comfort_Convenience__c = ld.Comfort_Convenience__c;
        lc.Safety_Security__c = ld.Safety_Security__c;
        lc.Smart_Phone_User__c = ld.Smart_Phone_User__c;
        lc.Entertain_A_Lot__c = ld.Entertain_A_Lot__c;
        lc.Physical_Limitations__c = ld.Physical_Limitations__c;
        lc.Energy_Efficient__c = ld.Energy_Efficient__c;
        lc.Control4_Interest__c = ld.Control4_Interest__c;
        lc.Away_from_Home_Often__c = ld.Away_from_Home_Often__c;
        lc.Approximate_Home_Value__c = ld.Approximate_Home_Value__c;
        lc.Square_Footage__c = ld.Square_Footage__c;
        lc.Number_Of_Bathrooms__c = ld.Number_Of_Bathrooms__c;
        lc.Number_Of_Bedrooms__c = ld.Number_Of_Bedrooms__c;
        lc.Project_Spaces__c = ld.Project_Spaces__c;
        lc.Time_Frame__c = ld.Time_Frame__c;
        lc.Automation_Objective__c = ld.Automation_Objective__c;
        lc.Home_Entertainment__c = ld.Home_Entertainment__c;
        lc.Climate_Comfort__c = ld.Climate_Comfort__c;
        lc.Communication__c = ld.Communication__c;
        lc.Security_Monitoring__c = ld.Security_Monitoring__c;
        lc.Control_Objective__c = ld.Control_Objective__c;
        lc.Lighting__c = ld.LightingSolutions__c;
        lc.Music__c = ld.Music__c;
        lc.Subject__c = ld.Lead_Subject__c;
        lc.Description = ld.Description;
        lc.Balihoo_Comments__c = ld.Lead_Message__c;
        lc.CloseDate = system.today().addDays(180);
        return lc;
    }
}