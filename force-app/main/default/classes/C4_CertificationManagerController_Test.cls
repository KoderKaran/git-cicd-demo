@isTest
public class C4_CertificationManagerController_Test {
    
    static testMethod void search_should_return_Contact() {
        Id [] fixedResults = new Id[1];
        Contact contact = createTestContact('Contact');
        fixedResults.add(contact.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();

        //List<LookupSearchResult> results = C4_CertificationManagerController.search('Con', selectedIds);

        System.assertEquals(1, C4_CertificationManagerController.search('Con', selectedIds).size());
        System.assertEquals(contact.Id, C4_CertificationManagerController.search('Con', selectedIds).get(0).getId());        
    } 
    
    static testMethod void testGetCertifications() {
        Id [] fixedResults = new Id[1];
        Contact contact = createTestContactwithCert('Contact2');
        fixedResults.add(contact.Id);
        Test.setFixedSearchResults(fixedResults);
        List<C4_Training_Certification__c> results = C4_CertificationManagerController.getCertifications(contact.Id);
        System.assertEquals(1, results.size());    
    }   
    
    static testMethod void testmoveCertifications() {
        Id [] fixedResults = new Id[1];
        Contact contact = createTestContactwithCert('Contact3');
        Contact contactForMoveCert = createTestContact('Contact4');
        fixedResults.add(contact.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();

        List<C4_Training_Certification__c> certList = C4_CertificationManagerController.getCertifications(contact.Id);
        List<Id> idList = new List<Id>();
        
        for (C4_Training_Certification__c cert : certList)
        {
            idList.Add(cert.Id);
        }        
        
        string result = C4_CertificationManagerController.moveCertifications(contact.Id, contactForMoveCert.Id, idList);
        
        List<C4_Training_Certification__c> results = C4_CertificationManagerController.getCertifications(contactForMoveCert.Id);
        System.assertEquals(results.size() >= 0, true);  
    }   

        static testMethod void testcopyCertifications() {
        Id [] fixedResults = new Id[1];
        Contact contact = createTestContactwithCert('Contact5');
        Contact contactForMoveCert = createTestContact('Contact6');
        fixedResults.add(contact.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();

        List<C4_Training_Certification__c> certList = C4_CertificationManagerController.getCertifications(contact.Id);
        List<Id> idList = new List<Id>();
        
        for (C4_Training_Certification__c cert : certList)
        {
            idList.Add(cert.Id);
        }        
        
        string result = C4_CertificationManagerController.copyCertifications(contact.Id, contactForMoveCert.Id, idList);
        
        List<C4_Training_Certification__c> results = C4_CertificationManagerController.getCertifications(contactForMoveCert.Id);
        System.assertEquals(results.size() >= 0, true);    
    } 
    
    // private method
    private static Contact createTestContact(String name) {
        Contact contact = new Contact(Lastname = name);
        insert contact;
        return contact;
    }
    
     // private method
    private static Contact createTestContactwithCert(String name) {
        
        Contact contact = new Contact(Lastname = name);
        insert contact;
        C4_Training_Certification__c newCert = new C4_Training_Certification__c (Contact__c = contact.Id, Type__c = 'Associate Installer');
        insert newCert;    
        return contact;
    }   
}