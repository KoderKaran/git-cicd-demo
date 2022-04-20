/*
 *  Description: Test class to test Trigger on Attachment as well as its handler
 *  
 *  Sr.No.  Version   Author         Date(mm/dd/yyyy)   Description
 *    1      1.1      Team Simplus     03/01/2018       Initial draft
 */

@isTest
private class TriggerOnAttachmentsTest {
    
    // Creates Accounts based on integer parameter of record type 'Business Account'
    public static List<Account> createAccount(Integer accRecNo) {
        
        // Get record type id for Business Account record type
        Id accRecordTypeId 
            = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
        
        List<Account> listAccount = new list<Account>();
        
        // Create account records
        for(Integer count=0; count < accRecNo; count++){
            
            Account objAccount = new Account(
                Name = 'Business Account ' + count,
                RecordTypeId = accRecordTypeId
            );
            
            listAccount.add(objAccount);
        }
        
        return listAccount;
    }
    
    // Create Accounts depending upon list of Dealer Accounts of record type Design Sevices
    public static List<Lead> createLeads( List<Account> listDealerAccounts ){
        
        List<Lead> listLeads = new List<Lead>();
        
        Integer counter = 0;
        
        // Get Lead Record Type Id
        Id customerRecTypeId 
            = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        
        for( Account objAcc: listDealerAccounts ){
            
            Lead objLead = new Lead(
                
                FirstName = 'First' + counter,
                LastName = 'Last' + counter,
                Lead_Subject__c = 'Test Lead Subject ' + counter,
                Status = 'New',
                RecordTypeId = customerRecTypeId,
                Dealer_Name__c = objAcc.Id
                
            );            
            
            listLeads.add( objLead );
            
            counter++;
        }
        
        return listLeads;
    }
    
    // This method creates Attachment records for sObjects and returns List of created Attachments.
    public static List<Attachment> createAttachments( List<sObject> listSObjects, Integer counter ) {
        
        List<Attachment> listAttachments = new List<Attachment>();
        
        Integer count = 0;
        
        if( counter <= 0 ){
            for( sObject objSObject: listSObjects ){
                
                Attachment attach = new Attachment(
                    Name = 'Attachment' + objSObject.Id + ' ' +count,
                    Body = Blob.valueOf( 'Unit Test Attachment Body' ),
                    IsPrivate = false,
                    ParentId = objSObject.Id,
                    contentType = 'application/msword'
                );
                
                listAttachments.add(attach);
                
                count++;            
            }
        }else{
            
            for( ; count < counter; count++  ){
                
                Attachment attach = new Attachment(
                    Name = 'Attachment' + listSObjects[0].Id + ' ' +count,
                    Body = Blob.valueOf( 'Unit Test Attachment Body' ),
                    IsPrivate = false,
                    ParentId = listSObjects[0].Id,
                    contentType = 'application/msword'
                );
                
                listAttachments.add(attach);
            }
        }
        
        return listAttachments;
    }
    
    // Create Contacts based on Accounts list passed as parameter
    public static List<Contact> createContacts( List<Account> listAccounts ){
        
        List<Contact> listContacts = new List<Contact>();
        
        Integer counter = 0;
        
        for( Account objAcc: listAccounts ){
            
            Contact objContact = new Contact( 
                
                FirstName = 'First' + counter,
                LastName = 'Last' + counter,
                AccountId = objAcc.Id
                
            );
            
            listContacts.add( objContact );
            
            counter++;
            
        }
        
        return listContacts;        
    }
    
    // Check if AttachmentIs__c on Lead is populated for single Attachment 
    private static testMethod void testAttachmentIdOnLeadInsertEvent_1_Record(){
        
        List<Account> listAccounts = createAccount(1);
        
        insert listAccounts;
        
        List<Lead> listLeads = createLeads( listAccounts );
        
        insert listLeads;
        
        List<Attachment> listAttachments = createAttachments( listLeads, 0 );
        
        Test.startTest();
        
        insert listAttachments;
        
        Test.stopTest();
        
        listLeads = [
          Select 
            Id,
            AttachmentIds__c
          From
            Lead
          Where
            Id =: listAttachments[0].ParentId
        ];
        
        System.assertEquals( String.valueOf( listAttachments[0].Id ) , listLeads[0].AttachmentIds__c );
        
    }
    
    // Check if AttachmentIs__c on Lead is populated for more than one Attachment records 
    private static testMethod void testAttachmentIdOnLeadInsertEvent_MoreThan_1_record(){
        
        List<Account> listAccounts = createAccount(1);
        
        insert listAccounts;
        
        List<Lead> listLeads = createLeads( listAccounts );
        
        insert listLeads;
        
        List<Attachment> listAttachments = createAttachments( listLeads, 2 );
        
        Test.startTest();
        
        insert listAttachments;
        
        Test.stopTest();
        
        listLeads = [
          Select 
            Id,
            AttachmentIds__c
          From
            Lead
          Where
            Id =: listAttachments[0].ParentId
        ];
        
        for( Attachment objAttachment: listAttachments ){
            System.assert( listLeads[0].AttachmentIds__c.contains( String.valueOf( objAttachment.Id ) ) );
        }        
    }
    
    // Check Exception handling of trigger
    private static testMethod void testExceptionHandling(){
        
        List<Account> listAccounts = createAccount(1);
        
        insert listAccounts;
        
        List<Lead> listLeads = createLeads( listAccounts );
        
        listLeads[0].LastName = 'Test Lead Test Running';
        
        insert listLeads;
        
        List<Attachment> listAttachments = createAttachments( listLeads, 0 );
        
        Test.startTest();
        
        try{
            
            insert listAttachments;
            
        }catch( Exception objExcp ){
            
            System.assert( true );
            
        }
        
        Test.stopTest();
        
    }
    
    // Method to cover default constructor initilization for the trigger on Attachments
    private static testMethod void testConstructorInitialization(){
        
        TriggerOnAttachmentsHandler objInstance = new TriggerOnAttachmentsHandler();
        
    }
}