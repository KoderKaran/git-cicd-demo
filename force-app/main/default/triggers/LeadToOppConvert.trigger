trigger LeadToOppConvert on Lead (Before Update) 
{
    //Set up the ID trackers
    Set<ID> leadid = new Set<ID>();
    Set<ID> dealerid = new Set<ID>();
    String status;
    //Map the Lead IDs from the Trigger
    for(Lead l : trigger.new)
    {
        If(l.Status == 'Committed')
        {
            leadid.add(l.Id);
            dealerid.add(l.Dealer__r.ID);
            status = l.Status;
        }
    }
    //Get all the leads
    List<Opportunity> opplist = [SELECT Id, AccountID, Associated_Lead__c,StageName FROM Opportunity WHERE Associated_Lead__r.id IN : leadid];
    IF(opplist.size() > 0)
    {
        For(Opportunity op : opplist)
        {
            op.StageName = 'Closed Lost';
            update op;
        }
    }
}