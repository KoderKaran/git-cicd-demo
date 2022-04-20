public class UpdateOpportunityFromAccountChange
{
    public void UpdateOpportunityStage(List<Account> triggerNew, Map<Id,Account> triggerOldMap)
    { 
        Id businessAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(); 
        
        Set<Id> accountswithSAPUpdates = new Set<Id>();
        
        for (Account a: triggerNew)
        {
            if(a.RecordTypeId == businessAccountRecordType && !string.isBlank(a.SAP_Account_ID__c))
            {
                Account oldAccount = triggerOldMap.get(a.ID);
                if (oldAccount != null)
                {
                    if (string.isBlank(oldAccount.SAP_Account_ID__c)) 
                    {
                        accountswithSAPUpdates.Add(a.Id); 
                    }
                }
            }
        }    
        
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        for(Opportunity opp : [select id, StageName from Opportunity where AccountId in: accountswithSAPUpdates and recordtypeID = '01238000000UWriAAG'])
        {
            opp.StageName='Account Created in SAP';
            oppsToUpdate.add(opp);
        }
        
        if (oppsToUpdate != null && !oppsToUpdate.isEmpty())
        {
        	update oppsToUpdate;
        }
    }
}