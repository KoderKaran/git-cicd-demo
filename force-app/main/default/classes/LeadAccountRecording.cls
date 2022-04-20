public class LeadAccountRecording {
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Lead> oldMap;
    Map<Id, Lead> newMap;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public LeadAccountRecording(
        Map<Id, Lead> oldTrigger, 
        Map<Id, Lead> newTrigger) {
            this.oldMap = oldTrigger;
            this.newMap = newTrigger;
        }
    
    // The one method your master trigger will call
    public void RecordLeadInfoToAccount() {
        //call handler.after method
        List<Id> accountIds=new list<ID>();
        for(Lead l: newMap.Values())
        {
            if(l.IsConverted==true && l.ConvertedAccountid!=null)
                accountIds.add(l.ConvertedAccountid);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([Select Id, Converted_from_Lead__c from Account where ID IN :accountIds]);
        System.debug('Account Map: ' + accountMap.Size());
        List<Account> updateAccount=new list<Account>();
        for(Lead l: newMap.Values())
        {
            System.debug('Old Vlaue: ' + oldMap.get(l.Id).IsConverted);
            if(l.IsConverted==true && oldMap.get(l.Id).IsConverted==false && l.ConvertedAccountid!=null)
            {
                System.debug(l.ConvertedDate);
                Date ConvertDate=l.ConvertedDate;
                if(convertDate==null) ConvertDate=Date.Today();
                accountMap.get(l.ConvertedAccountid).Converted_from_Lead__c=convertDate;
                Date createdDate=l.CreatedDate.Date();
                accountMap.get(l.ConvertedAccountid).Time_to_sell__c=createdDate.daysBetween(convertDate);
                updateAccount.add(accountMap.get(l.ConvertedAccountid));
            }
        }
        Update updateAccount;
    }
}