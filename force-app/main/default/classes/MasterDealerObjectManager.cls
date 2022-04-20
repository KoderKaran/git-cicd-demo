public class MasterDealerObjectManager {

    // This method is called from AccountTrigger.apxt
    public void CreateMasterDealer(List<Account> triggerNew)
    {
        Id businessAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(); 
            
        // Update new account with the Master Dealer ID
        for(Account a: triggerNew)
        {
             if(a.RecordTypeId == businessAccountRecordType)
             {   
                 Integer maxSize = 80;
                 if (a.Name.length() > maxSize )
                 {
                     a.Name = a.Name.substring(0, maxSize);
                 }
                 
                 Master_Dealer__c masterDealer = new Master_Dealer__c(Name = a.Name);
                 insert masterDealer;
                 a.Master_Dealer__c = masterDealer.id;
    		 }
        }
    } 
}