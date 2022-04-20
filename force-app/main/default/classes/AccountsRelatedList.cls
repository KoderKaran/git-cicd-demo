public class AccountsRelatedList 
{
    private final Account acct;
    public AccountsRelatedList(ApexPages.StandardController setCon) 
    {
        this.acct = (Account)setCon.getRecord();
    }
    public List<Task> getmyTasksList()
    {
        myTasksList = [SELECT ID,AccountId, OwnerID, Subject,ActivityDate, Description FROM Task WHERE OwnerID != Null AND AccountId != Null AND AccountId = :this.acct.Id 
                       AND (Not Subject Like '%Email%') AND (Not Subject Like '%PM%') AND (Not Subject Like '%AM%') ORDER By ActivityDate DESC Nulls LAST];
        Return myTasksList;
    }
    List<Task> myTasksList = [SELECT ID, AccountId, OwnerID, Subject,ActivityDate, Description FROM Task LIMIT 4999];
}