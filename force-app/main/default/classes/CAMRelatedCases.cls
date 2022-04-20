public class CAMRelatedCases 
{
    private final Account acct;
    public CAMRelatedCases(ApexPages.StandardController setCon) 
    {
        this.acct = (Account)setCon.getRecord();
    }
    public List<Case> getmyCaseList()
    {
        myCaseList = [SELECT ID,CaseNumber, CreatedDate, Subject, AccountID, OwnerID, Account.Name, Owner.Name FROM Case WHERE Account.Dealer_of_Record__c = :this.acct.Id];
        Return myCaseList;
    }
    List<Case> myCaseList = [SELECT ID, CaseNumber, AccountID, OwnerID, CreatedDate, Subject, Description, Account.Name, Owner.Name FROM Case LIMIT 4999];
}