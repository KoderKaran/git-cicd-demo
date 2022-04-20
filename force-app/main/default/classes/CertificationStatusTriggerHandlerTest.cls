/**
 * Test class for CertificationStatusTriggerHandler
 */
 
 
@IsTest public with sharing class CertificationStatusTriggerHandlerTest {
    
    static User createUser(){
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
 		User u = new User(firstname= 'Test',
 						  lastname='User',
 						  Alias='Usert',
 						  email = 'test@ct4.com',
 						  username= 'test@ct4.com', 
 						  profileId= p.id, 
 						  emailencodingkey='UTF-8',
 						  languagelocalekey='en_US',
 						  localesidkey='en_US',
 						  timezonesidkey='America/Los_Angeles');
 		insert u;	
 	    return u;	
    }
     
    static Contact createContact(Boolean isInsert) {
        Contact objContact = new Contact();
        objContact.LastName = 'TestContact';
        objContact.FirstName = 'TestFirst';
        objContact.Email = 'testContact@ct4.com';
        objContact.Phone = '112232212';
        if(isInsert)
            insert objContact;
        return objContact;
    } 
    
    static Certification_Type__c createCertType(Boolean isInsert) {
        
        Certification_Type__c ct = new Certification_Type__c();
        ct.Name = 'PCNA';
        ct.Active__c = TRUE;
        if(isInsert)
            insert ct;
        return ct;
    } 
    
    static Certification_Status__c createCertStatus(Boolean isInsert,Id contactId,Id certTypeId,String status) {
        
        Certification_Status__c cs = new Certification_Status__c();
        cs.Certification_Type__c = certTypeId;
        cs.Contact__c = contactId;
        cs.Status__c = status;
        if(isInsert)
            insert cs;
        return cs;
    } 
     
     
    static testMethod void testPositiveRegistration() {
     User u = createUser();
     Contact c1 = createContact(true);
     Certification_Type__c ct = createCertType(true);
     Certification_Status__c cs = createCertStatus(false,c1.id,ct.id,'Registered' );
     
     System.RunAs(u){
     
         cs.Purchase_Date__c = System.Today();
         cs.Expiration_Date__c =  System.Today().AddDays(360);
         Test.StartTest();
            insert cs;
         Test.StopTest();
         
         Contact cExisting = [SELECT Id, Email, PCNA_Certified__c, PCNA_Purchase_Date__c, PCNA_Achieved_Date__c, PCNA_Expiration_Date__c FROM Contact WHERE Id =: cs.Contact__c LIMIT 1 ];
         System.assertEquals(cs.Purchase_Date__c, cExisting.PCNA_Purchase_Date__c);
         System.assertEquals(cs.Expiration_Date__c, cExisting.PCNA_Expiration_Date__c);
     }
    }
    
    static testMethod void testPositiveCertification() {
     User u = createUser();
     Contact c1 = createContact(true);
     Certification_Type__c ct = createCertType(true);
     Certification_Status__c cs = createCertStatus(false,c1.id,ct.id,'Certified' );
     
     System.RunAs(u){
     
         cs.Achieved_Date__c = System.Today();
         Test.StartTest();
            insert cs;
         Test.StopTest();
         
         Contact cExisting = [SELECT Id, PCNA_Certified__c, PCNA_Purchase_Date__c, PCNA_Achieved_Date__c, PCNA_Expiration_Date__c FROM Contact WHERE Id =: c1.id LIMIT 1 ];
         System.debug(cExisting);
         System.assert(cExisting.PCNA_Certified__c);
         System.assertEquals(cs.Achieved_Date__c, cExisting.PCNA_Achieved_Date__c);
     }
    }     
}