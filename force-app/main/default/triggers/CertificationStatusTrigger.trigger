trigger CertificationStatusTrigger on Certification_Status__c (before insert, after update, after insert) {
   
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
            }
            if (Trigger.isUpdate) {
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
        
        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                List< Certification_Status__c  > updateContactList = new  List< Certification_Status__c  >();
                for(Certification_Status__c cert: Trigger.new){
                    if(cert.Status__c == 'Registered' || cert.Status__c == 'Certified' ){
                        updateContactList.add(cert);
                    }
                } 
                
                CertificationStatusTriggerHandler cHandler = new CertificationStatusTriggerHandler();
                cHandler.updateContact(updateContactList);
            
            }
            if (Trigger.isUpdate) {
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }

}