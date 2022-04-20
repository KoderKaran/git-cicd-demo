global class SendEmailNotContacted implements Database.Batchable<sObject>, Database.Stateful {
    global EmailTemplate et = [Select Id from EmailTemplate where Name = 'Your Dealer needs to contact their industry professional opportunity!'];
    global contact tc = [Select Id, Email FROM Contact WHERE LastName = 'Test Simplus Batch' LIMIT 1];
   
    global String dummyContactStr = System.Label.Dummy_Contact;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT ID, ASM_email__c, Days_stage_is_Not_Contacted__c FROM Opportunity WHERE Days_stage_is_Not_Contacted__c = 7';
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        // process each batch of records
        
        for(Opportunity opp : scope){
            if(opp.Days_stage_is_Not_Contacted__c == 7){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {opp.ASM_email__c};
                if(Test.isRunningTest()){
                    mail.setTargetObjectId(tc.id);
                    mail.setToaddresses(new String[] {'test@salesforce.com'}); 
                }else{
                    mail.setToaddresses(toAddresses);
                    mail.setTargetObjectId(dummyContactStr); 
                }
                mail.setReplyTo('dkarr@control4.com');
                
                mail.setSenderDisplayName('Danielle Karr');
                
                mail.setWhatId(opp.Id);
                
                mail.setTemplateId(et.Id);
                
                //mail.setToaddresses(toAddresses);                             
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }
        }
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
}