public class CertificationStatusTriggerHandler{

      // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Certification_Status__c  > oldMap;
    Map<Id, Certification_Status__c  > newMap;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public CertificationStatusTriggerHandler() {
    //Map<Id, Certification_Status__c  > oldTrigger, Map<Id, Certification_Status__c  > newTrigger
       //     this.oldMap = oldTrigger;
       //     this.newMap = newTrigger;
            
    }
    
    public void updateContact(List<Certification_Status__c> updateContactList){
        //Process updated Certification Status
        List<Id> contactId = new List<Id>();
        List<Contact> saveContact =  new List<Contact>();
        
        for(Certification_Status__c c: updateContactList ){
            contactId.add(c.Contact__c);
        }
        
        Map<Id,Contact> contactList = new Map<Id,Contact>([SELECT Id, PCNA_Certified__c, PCNA_Achieved_Date__c, PCNA_Purchase_Date__c, PCNA_Expiration_Date__c FROM Contact WHERE Id in:contactId ]);
        //Map<Id,Certification_Type__c> certTypeMap = new Map<Id,Certification_Type__c>([SELECT Id, Name FROM Certification_Type__c WHERE Active__c = TRUE]);
        
        for(Contact con : contactList.values() ){
            for(Certification_Status__c c: updateContactList ){
                if(con.Id == c.Contact__c){
                    if(c.Certification_Type_Name__c == 'PCNA' && c.Status__c == 'Certified'){
                        con.PCNA_Certified__c = true;
                        con.PCNA_Achieved_Date__c = c.Achieved_Date__c;
                    } else if(c.Certification_Type_Name__c == 'PCNA' && c.Status__c == 'Registered'){
                        con.PCNA_Purchase_Date__c = c.Purchase_Date__c;
                        con.PCNA_Expiration_Date__c = c.Expiration_Date__c;
                    
                    }
                }
            
            }
            saveContact.add(con);
        }
        
        if(!saveContact.isEmpty())
        update saveContact;
    }
 
}