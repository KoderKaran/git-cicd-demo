trigger DealerVisit on Note (after insert) 
{
    id nid;
    String subject;
    for(Note nt : Trigger.new)
    {
        nid = nt.ParentId;
        subject = nt.Title;
    }
    If(subject == 'Dealer Visit')
    {
        List<Account> acct = [SELECT Id,Weekly_Dealer_Visits__c,Dealer_Visit__c FROM Account WHERE Id = :nid];
        for(Account account :acct)
        {
            If(account.Dealer_Visit__c != Date.today())
            {
                if(account.Weekly_Dealer_Visits__c == Null)
                {
                    account.Weekly_Dealer_Visits__c = + 1;
                    account.Dealer_Visit__c = system.today();
                    update account;
                }Else
                {
                    account.Weekly_Dealer_Visits__c = account.Weekly_Dealer_Visits__c + 1;
                    account.Dealer_Visit__c = system.today();
                    update account;
                }
            }
        }
    }
}