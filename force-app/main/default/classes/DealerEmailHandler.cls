public with sharing class DealerEmailHandler{
    
    //Auto-Populate Email for Lead
    public void getAccountEmail(List<Lead> LeadList ,List<Lead> oldLead) {
        
        Set<ID> AccId = new Set<ID>();
        Set<ID> AccId2 = new Set<ID>();   
        Set<ID> AccId3 = new Set<ID>(); 
        
        Set<ID> setAcctId = new Set<ID>();    
        Map<Lead,List<Id>> mapAcctId = new Map<Lead,List<Id>>();  
        For (Lead l: LeadList) {  
            
            If (l.Dealer__c != null) {
                setAcctId.add(l.Dealer__c);
            }
            If (l.Dealer_2__c != null) {
                setAcctId.add(l.Dealer_2__c);
            }
            If (l.Dealer_3__c != null) {
                setAcctId.add(l.Dealer_3__c);
            }
        }
        
        Map<Id, Account> AccountEntries = new Map<Id, Account>([select Id, Dealer_Lead_Primary_Contact_Email__c from Account where id in :setAcctId]);
        
        List<Contact> contactList = [SELECT ID, Primary_User__c, email, AccountId FROM Contact WHERE AccountId IN: setAcctId ];
        
        EmailTemplate templateId1 = [Select id from EmailTemplate where name = 'Lead has been assigned 1'];
        EmailTemplate templateId2 = [Select id from EmailTemplate where name = 'Lead has been assigned 2'];
        EmailTemplate templateId3 = [Select id from EmailTemplate where name = 'Lead has been assigned 3'];
        List<string> usedThisTemplate = new List<String>();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        
        
        For (Lead l: LeadList) {
            Lead oldLeadDetail = new Lead();
            for(lead old: oldLead){
                if(l.id == old.Id){
                    oldLeadDetail = old;
                }
            }
            
            List<string> dealers = new List<string>();
            if(l.Dealer__c != oldLeadDetail.Dealer__c){
                if(l.Dealer__c != null && l.OppOptOutEmail__c == FALSE){
                    dealers.add(l.Dealer__c);
                    usedThisTemplate.add(templateId1.id);
                }
            }
            
            if(l.Dealer_2__c != oldLeadDetail.Dealer_2__c){
                if(l.Dealer_2__c != null && l.OppOptOutEmail__c == FALSE){
                    dealers.add(l.Dealer_2__c);
                    usedThisTemplate.add(templateId2.id);
                }
            }
            
            if(l.Dealer_3__c != oldLeadDetail.Dealer_3__c ){
                if(l.Dealer_3__c != null && l.OppOptOutEmail__c == FALSE){
                    dealers.add(l.Dealer_3__c);
                    usedThisTemplate.add(templateId3.id);
                }
            }
            
            //For Dealer 1
            if (dealers.size() > 0) {
                for(integer i=0 ; i < dealers.size() ;i++){
                    Account acc = AccountEntries.get(dealers[i]);
                    string currentTemplate = usedThisTemplate[i];
                    List<string> toaddress = new List<string>();
                    if (acc.Dealer_Lead_Primary_Contact_Email__c != null){
                        toaddress =acc.Dealer_Lead_Primary_Contact_Email__c.split(';');
                    }
                    else {
                        String accountId = acc.id;
                        List<Contact> accContacts = new List<Contact>();
                        
                        for(Contact c: contactList){
                            if(c.AccountId == accountId){
                                accContacts.add(c);
                            }
                        }
                        
                        for(Contact c: accContacts){
                            if(c.Primary_User__c){
                                //l.Dealer1_Email__c = c.Email;
                                toaddress.add(c.Email);
                            }
                        }
                        
                    }
                    if(toaddress.size() > 0){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateID(currentTemplate); 
                        mail.setSaveAsActivity(false);
                        mail.setToAddresses(toaddress);
                        mail.setTargetObjectId(l.id);
                        mail.setTreatTargetObjectAsRecipient(false);
                        allmsg.add(mail);
                        Messaging.sendEmail(allmsg,false);
                    }
                    
                }
                
                
            }
        }
    }
} 
//END of Auto-Populate Email for Lead