trigger AccountLeadChecker on Account (After Insert) 
{
    //Set the ID's and Strings
    Set<String> acctphones = new Set<String>();
    Set<String> acctemail = new Set<String>();
    Map<Id,Account> accounts = new Map<Id,Account>();
    Set<ID> dealerid = new Set<ID>();
    //Iterate through all New Person Accounts
    for (Account a : Trigger.new)
    {
        /*Check and make sure that Account is Person Account*/
        if(a.RecordTypeId == '012500000005JxsAAE' || a.RecordTypeId == '012500000005e0fAAA')
        {
            If(a.Dealer_of_Record__c != Null)
            {
                accounts.put(a.Dealer_of_Record__c,a);
                If(a.PersonEmail != Null)
                {
                    acctemail.add(a.PersonEmail);
                }
                if (a.Phone != null)
                {
                    acctphones.add(a.Phone);
                }
            }
        }
    }
    //Get all the Opportunities with same Dealer
    List<Opportunity> oppListwin = [SELECT ID, Email__c,AccountID, Phone__c  FROM Opportunity 
                                    WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountID IN :accounts.keySet() AND (Email__c IN :acctemail OR Phone__c IN :acctphones)];
    // Update these Opportunities to Won
    // Concerns about dealer + email/phone combo matching
    // How to deal with multiple accounts for same dealer
    for(Opportunity op : oppListwin)
    {
        op.StageName = 'Closed Won';
        //Update op;
    }
    if (oppListwin.size() > 0)
        Update oppListwin;
}