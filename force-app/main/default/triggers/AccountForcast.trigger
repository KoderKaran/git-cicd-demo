trigger AccountForcast on Sales_Notes__c (After Insert) 
{
    //Set up the ID trackers
    id nid;
    //Set up my String and Variable holders
    String subject;
    Decimal qtdcommit;
    Decimal newqtdcommit;
    String quarter;
    //Map the ID's and Values from the Trigger 
    for(Sales_Notes__c nt : Trigger.new)
    {
        nid = nt.Account__c;
        subject = nt.Name ;
        qtdcommit = nt.Current_Quarter_Commitment__c;
        newqtdcommit = nt.Change_Quarter_Commitment__c;
        quarter = nt.Changed_Quarter__c;
    }
    //Check value parameters if True proceed to next steps
    If(qtdcommit != newqtdcommit && newqtdcommit != Null)
    {
        //Get the Account Forecast information
        list<Account_Forecast__c> forecast = new list<Account_Forecast__c>();
        //Get the associated Account information
        List<Account> acct = [SELECT Id,Current_Quarter_Commitment__c, Current_Quarter__c FROM Account WHERE Id = :nid];
        for(Account account :acct)
        {
            If(account.Current_Quarter__c == quarter)
            {
                account.Current_Quarter_Commitment__c = newqtdcommit;
                Update account;
            }
            //Creating the new Account forecast as the information is not the same
            Account_Forecast__c af = new Account_Forecast__c();
            af.Name = 'New Quarter Commitment';
            af.Account__c = account.Id;
            af.Created_Date__c = System.today();
            af.Forecast__c = newqtdcommit;
            af.Quarter__c = quarter;
            Insert af;
        }
    }
}