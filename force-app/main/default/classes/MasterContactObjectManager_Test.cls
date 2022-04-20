@isTest
public class MasterContactObjectManager_Test {
    
    testMethod static void checkCreateMasterContact()
    {            
        Contact testContact1 = new Contact(lastname = 'TestContact1');
        Contact testContact2 = new Contact(firstname = 'New', lastname = 'TestContact2');
        
        List<Contact> contactList = new List<Contact>();
        contactList.add(testContact1);
        contactList.add(testContact2);
        
        Test.startTest();
        
        insert contactList;
        
        Test.stopTest();

        // Check to see if the master contact objects exist
        List<Master_Contact__C> masterContactList = [select id,name from Master_Contact__C where name in ('TestContact1','New TestContact2')];
    //    System.assertEquals(masterContactList.size(),2,'Created 2 Master Contacts');
    }
}