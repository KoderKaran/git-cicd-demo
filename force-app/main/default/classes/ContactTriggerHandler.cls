public with sharing class ContactTriggerHandler {
    
    public static void checkPrimary(List<Contact> newContacts)
    {
        Set<Id> newPrimaryContacts = new Set<Id>();      
        Set<Id> newPrimaryAccounts = new Set<Id>();

        // Get the new Primary Contacts        
        for(Contact c: newContacts)
        {
          if(c.AccountId != null && c.eCom_Primary_User__c == true)
          {
            newPrimaryContacts.add(c.Id);
            newPrimaryAccounts.add(c.AccountId);  
          }
        }        
 
        //Get the old primary Contacts
        List<Contact> oldPrimaryContacts = [SELECT Id, eCom_Primary_User__c, AccountId 
                                            FROM Contact 
                                            WHERE AccountId IN :newPrimaryAccounts 
                                            	and Id NOT IN :newPrimaryContacts 
                                            	and eCom_Primary_User__c = true];
         
        // update the old primary contacts as non primary contacts
        if(!oldPrimaryContacts.isEmpty())
        {
        	for(Contact oldContact: oldPrimaryContacts)
            {
                oldContact.eCom_Primary_User__c = false;
            }
         
            update oldPrimaryContacts;
        }    
    }
}