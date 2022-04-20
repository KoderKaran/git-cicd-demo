global class checkExpiryBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query = 'SELECT Id,AccountName__c,PersonEmail,Primary_Email__c,X4Sight_Expiration__pc,Dealer_of_Record__c,X30_Days_Check__c,X60_Days_Check__c,X90_Days_Check__c,X30days4sight__c,X60days4sight__c,X90days4sight__c, ExpirationBoolean__c FROM  Account where isPersonAccount = TRUE and X4Sight_Expiration__pc != null and X4Sight_Expiration__pc >= TODAY and (X90_Days_Check__c != true OR X60_Days_Check__c != true OR X30_Days_Check__c != true)';
        String query = 'SELECT Id,AccountName__c,PersonEmail,Primary_Email__c,X4Sight_Expiration__pc,Dealer_of_Record__c,X30_Days_Check__c,X60_Days_Check__c,X90_Days_Check__c,X30days4sight__c,X60days4sight__c,X90days4sight__c, ExpirationBoolean__c FROM  Account WHERE isPersonAccount = TRUE AND  X4Sight_Expiration__pc != null and X4Sight_Expiration__pc >= TODAY AND X4Sight_Expiration__pc <= NEXT_N_DAYS:90';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList) {
        Map<Id,Account> mapOfAccount =new Map<Id,Account>();
        list<String> relatedAccount = new List<String>();
        for(Account acc : accList){        
            /*Date dt1 = acc.X30days4sight__c;
            Date dt2 = acc.X60days4sight__c;
            Date dt3 = acc.X90days4sight__c;
            //Date myDate = dt1;
            //Date myDate2 = dt2;
            //Date myDate3 = dt3;*/
            boolean isChecked = false;
            boolean oldData = false;

            if(date.today() == acc.X30days4sight__c){
                isChecked = true;
                acc.X30_Days_Check__c = true;
            }
            if(date.today() == acc.X60days4sight__c){
                isChecked = true;
                acc.X60_Days_Check__c = true;
            }
            if(date.today() == acc.X90days4sight__c){
                isChecked = true;
                acc.X90_Days_Check__c = true;
            }
            if(acc.X30days4sight__c < date.today()){
                isChecked  = true;
                acc.X30_Days_Check__c = true;
                acc.X60_Days_Check__c = true;
                acc.X90_Days_Check__c = true;
                oldData = true;
            }

            if(isChecked && !oldData){
                //relatedAccount.add(acc.Dealer_of_Record__c);
                mapOfAccount.put(acc.Dealer_of_Record__c , acc);
            }
 
        }
        List<Contact> listOfContact = [SELECT Id,Account.Id FROM Contact WHERE Account.Id IN: mapOfAccount.keySet() AND Primary_User__c = true];

        if(!listOfContact.isEmpty()){
            for(Contact curContact: listOfContact){
                //system.debug('curContact **** ' + curContact);           
                Account curAccount = mapOfAccount.get(curContact.Account.Id);
                //system.debug('before' + curContact.Dealer_Of_Record_4SightExpiration__c + '    ' + curAccount.X4Sight_Expiration__pc);
                Boolean changedExpiration = mapOfAccount.get(curContact.Account.Id).ExpirationBoolean__c;
                curContact.Dealer_Of_Record_Email__c = curAccount.Primary_Email__c;
                curContact.Dealer_Of_Record_4SightExpiration__c = curAccount.X4Sight_Expiration__pc;
                curContact.Dealer_of_record_Account_Email__c = curAccount.PersonEmail;
                curContact.Dealer_of_Record_Account_name__c = curAccount.AccountName__c;
                
               // system.debug('after' + curContact.Dealer_Of_Record_4SightExpiration__c + '    ' + curAccount.X4Sight_Expiration__pc);
                
                if(changedExpiration){
                    curContact.Pardot_Email_Sent_30days__c = FALSE;
                    curContact.Pardot_Email_Sent_60days__c = FALSE;
                    curContact.Pardot_Email_Sent_90days__c = FALSE;
                    curAccount.ExpirationBoolean__c = FALSE;
                }
                
                //system.debug('**** ' + curAccount.AccountName__c);
            }
            //system.debug('list of Update **** ' + listOfContact);
            //system.debug('list of Map **** ' +  mapOfAccount.values());
            update listOfContact;
            
            if(!mapOfAccount.isEmpty()){
                update mapOfAccount.values();
            }
        }   
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}