global class Dealer4SightExpireProcessor implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //system.debug('Executing Dealer4SightExpireProcessor');    
 			//String query = 'SELECT Id, Account.Name, PersonEmail, X4Sight_Expiration__pc, Dealer_of_Record__c FROM Account WHERE isPersonAccount = TRUE and X4Sight_Auto_Renewal__c = FALSE and X4Sight_Expiration__pc != null and X4Sight_Expiration__pc = NEXT_N_DAYS:90 and Dealer_of_Record__c in (\'0015000000MlqpO\', \'0015000000Gf8nX\', \'0015000000LJ80o\', \'0015000000iq3SV\') order by X4Sight_Expiration__pc';
 			  String query = 'SELECT Id, Account.Name, PersonEmail, X4Sight_Expiration__pc, Dealer_of_Record__c FROM Account WHERE isPersonAccount = TRUE and X4Sight_Auto_Renewal__c = FALSE and X4Sight_Expiration__pc != null and X4Sight_Expiration__pc = NEXT_N_DAYS:90 order by X4Sight_Expiration__pc';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList) {
		//system.debug('Executing the Execute method in Dealer4SightExpireProcessor');     
        
        Map<Id,List<Account>> mapOfAccount =new Map<Id,List<Account>>();

        for(Account acc : accList){  
           	acc.Dealer_4Sight_Expire_List__c = '';
            
            if(date.today().AddDays(30) == acc.X4Sight_Expiration__pc.date()){
                acc.Dealer_4Sight_Expire_List__c = '30 Days until expire: &nbsp;&nbsp;' + acc.X4Sight_Expiration__pc.format('yyyy-MM-dd') + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + acc.Name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + acc.PersonEmail;         	
            	AddtoMap(mapOfAccount, acc);
            }
            else if(date.today().AddDays(60) == acc.X4Sight_Expiration__pc.date()){
                acc.Dealer_4Sight_Expire_List__c = '60 Days until expire: &nbsp;&nbsp;' + acc.X4Sight_Expiration__pc.format('yyyy-MM-dd') + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + acc.Name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + acc.PersonEmail;
            	AddtoMap(mapOfAccount, acc);
            }
            else if(date.today().AddDays(90) == acc.X4Sight_Expiration__pc.date()){
                acc.Dealer_4Sight_Expire_List__c = '90 Days until expire: &nbsp;&nbsp;' + acc.X4Sight_Expiration__pc.format('yyyy-MM-dd') + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + acc.Name + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + acc.PersonEmail;   
            	AddtoMap(mapOfAccount, acc);
            }
        }

        // This is how it was originally done without using the AccountcontactRelation object
        //List<Contact> listOfContact = [SELECT Id, Account.Id, Dealer_4Sight_Expire_List__c, Pardot_4Sight_Expire_Notify__c FROM Contact WHERE isPersonAccount = false AND Account.Id IN: mapOfAccount.keySet() AND X4Sight_Subscription_Notifications__c = true];

        // Using AccountContactRelation
        Set<Id> contactIds = new Set<Id>();
        List<AccountContactRelation> acr = [SELECT Id, ContactId, AccountId FROM AccountContactRelation WHERE roles != 'NLWC' AND Contact.isPersonAccount = false AND AccountId IN :mapOfAccount.keySet() AND Contact.X4Sight_Subscription_Notifications__c = true];
        for(AccountContactRelation r : acr){
    		contactIds.add(r.ContactId);
		}      
        
        List<Contact> listOfContact = [SELECT Id, Account.Id, Dealer_4Sight_Expire_List__c, Pardot_4Sight_Expire_Notify__c FROM Contact WHERE Id IN :contactIds];    
       
        // THIS IS THE NEW WAY (Uses the accountcontactrelation table)
        if(!listOfContact.isEmpty())
        {
            // Initialize the 2Sight Expire field
            for (Contact c : listOfContact)
            {
        		c.Dealer_4Sight_Expire_List__c = '';                
            }
            
			for (ID accountId : mapOfAccount.keySet())
            {
            	for(AccountContactRelation r: acr)
                {                  
                    if (r.AccountId == accountId)
                    {                        
                        for (Account curAccount : mapOfAccount.get(accountId))
                        {    
                            for (Contact c : listOfContact)
                            {                                
                                if (c.Id == r.ContactId)
                                {
                                    c.Pardot_4Sight_Expire_Notify__c = true; 
                                    c.Dealer_4Sight_Expire_List__c += '<br>' + curAccount.Dealer_4Sight_Expire_List__c; 
                                }
                            }            
                        }
                    }
                }          
            }
            
            update listOfContact;
        }
         
        
        
        
        // THIS IS THE ORIGIONAL WAY  (DOES NOT USE the accountcontactrelation table)
        //if(!listOfContact.isEmpty())
        //{
        //    for(Contact curContact: listOfContact)
        //    {
        //        curContact.Pardot_4Sight_Expire_Notify__c = true; 
        //        curContact.Dealer_4Sight_Expire_List__c = ''; I think this is a bug???? it truncates the list every time?                
		//		for (ID aID : mapOfAccount.keySet())
        //        {                   
        //            if (curContact.Account.Id == aID)
        //            {                        
        //                for (Account curAccount : mapOfAccount.get(curContact.Account.Id))
        //                {                           
        //                  curContact.Dealer_4Sight_Expire_List__c += '<br>' + curAccount.Dealer_4Sight_Expire_List__c;                       
        //                }
        //            }
        //        }          
        //    }
            
        //   update listOfContact;
        //}   
    }
    
    private void AddtoMap(Map<Id,List<Account>> mapOfAccount, Account acc)
    {
        List<Account> tempAcc = mapOfAccount.get(acc.Dealer_of_Record__c );
        
        if (tempAcc == null && acc.Dealer_4Sight_Expire_List__c != ''){
            mapOfAccount.put(acc.Dealer_of_Record__c, new List<Account>{acc});
        } 
        else if (tempAcc != null && acc.Dealer_4Sight_Expire_List__c != ''){
            tempAcc.add(acc);
        }  
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}