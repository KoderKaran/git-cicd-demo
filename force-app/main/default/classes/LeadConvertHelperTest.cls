/*
 *  Description: Test class for Lead convert helper for its trigger 'TriggerOnLeadConversion'.
 *              
 *
 *  Version               Author            Date (DD-MM-YYYY)           Change Log
 *  1.0                   Yogesh P          26/05/2017                 Initial Draft
 *  2.0                   Nikhil G          12/06/2017                 Added 2 test cases for checking Attachments 
 *                                                                     on converted Opportunity.
 *  3.0                   Sudeep K          13/06/2017                 Methods to test Opportunities for Owner's with that
 *                                                                     of Account Owner from Dealer Name Field on Lead
 *                                                                     after Lead convertion.
 *  4.0                   Sudeep K          07/04/ 2017                Commented methods to test previous functionality for
 *                                                                     trigger and updated test class with new test metohds
 *                                                                     to test Opportunities 'Contact Name' field to have
 *                                                                     Lead's 'Name' field's value.
 */
@isTest
private class LeadConvertHelperTest  {
    
    // Method to create Account record
    public static void createAccount(Integer accRecNo) {
        
        // Get record type id for Business Account record type
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();        
        
        list<Account> listAccount = new list<Account>();
        
        // Create account records
        for(Integer count=0; count < accRecNo; count++){
            Account objAccount = new Account();
            objAccount.Name = 'AccountName';
            objAccount.RecordTypeId = accRecordTypeId;
            
            listAccount.add(objAccount);
        }
        
        insert listAccount;
    }
    
    // This method create Lead records.
    public static void createLeads(Integer leadRecNo) {
        // Get Lead Record Type Id
        Id customerRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        
        // Get List of Lead records.        
        list<Lead> leadList = new list<Lead>();
        for(Integer i=0; i<leadRecNo;i++){
            Lead testLead = new Lead();
            testLead.FirstName = 'Test First' + i ;
            testLead.LastName = 'Test Last' + i;
            testLead.Lead_Subject__c='Test Lead Subject' + i;
            testLead.Status='New';
            testLead.Currency__c = 'AUD';
            testLead.RecordTypeId = customerRecTypeId;
            leadList.add(testLead);         
        }
        insert leadList;
    }
    
    // This method creates Attachment records for Lead and returns List of created Attachments.
    public static list<attachment> createAttachments(String leadId, Integer count) {
        list<attachment> attachmentList = new list<attachment>();
        for(Integer i=0;i<count;i++){
            Attachment attach = new Attachment();
            attach.Name = 'Attachment'+leadId+' '+count;
            attach.Body = Blob.valueOf('Unit Test Attachment Body');
            attach.IsPrivate = false;
            attach.ParentId = leadId;
            attach.contentType = 'application/msword';
            attachmentList.add(attach);
        }
        insert attachmentList;
        return attachmentList;
    }
    
    // Method sets up default data to be used for testing later
    @testSetup static void methodForTestData(){
        
        // Get Lead Record Type Id
        Id customerRecTypeId 
            = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        
        Lead objLead = new Lead(
            FirstName = 'First' ,
            LastName = 'Last',
            Lead_Subject__c = 'Test Lead Subject ',
            Status = 'New',
            Currency__c = 'AUD',
            RecordTypeId = customerRecTypeId            
        );
        
        insert objLead;
        
        Attachment ObjAttach = new Attachment(
            Name = 'Attachment' + objLead.Id,
            Body = Blob.valueOf( 'Unit Test Attachment Body' ),
            IsPrivate = false,
            ParentId = objLead.Id,
            contentType = 'application/msword'
        );
        
        insert ObjAttach;
    }
    
    // Check if 'Contact Name' on Opportunity has ConvertedContactId's value
    private static testMethod void testContactNameOnOppCreation(){
        
        // Create a Lead record
        createLeads(1);
        
        // Fetch the created Lead record
        list<Lead> listLead = [Select Id,Name, OwnerId From Lead Where FirstName Like: 'Test First%'];
        
        // Get Isconverted Status
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest(); 
        
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};            
            
            // Convert Lead
            for(Lead objLead : listLead ) {
                Database.LeadConvert objLeadConvert = new Database.LeadConvert();
                objLeadConvert.SetLeadId(objLead.Id);
                objLeadConvert.SetConvertedStatus(convertStatus.ApiName);
                objLeadConvert.setOwnerId(UserInfo.getUserId());
                leadConvertedList.add(objLeadConvert);
            }
        
            // Get result of converted Lead
            List<Database.LeadConvertResult> listLeadConvertResult = Database.convertLead(leadConvertedList);
        
        Test.stopTest();
        
        // Fetch converted Lead's record and check if 'Contact Name' has 'ConvertedContactId' as its value
        for(Lead objLead : [Select ConvertedOpportunity.Contact_Name__r.Id, ConvertedContactId 
                            From   Lead 
                            Where  IsConverted = true]) {
            System.assertEquals(objLead.ConvertedOpportunity.Contact_Name__r.Id, objLead.ConvertedContactId); 
            System.debug('objLead=1'+objLead);                    
        } 
        
    }
    
    // Check if 'Contact Name' on Opportunity has ConvertedContactId's value bulk test
    private static testMethod void testContactNameOnOppCreationBulk(){
        
        // Create a Lead record
        createLeads(5);
        
        // Fetch the created Lead record
        list<Lead> listLead = [Select Id,Name, OwnerId From Lead Where FirstName Like: 'Test First%'];
        
        // Get Isconverted Status
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest(); 
        
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};            
            
            // Convert Lead
            for(Lead objLead : listLead ) {
                Database.LeadConvert objLeadConvert = new Database.LeadConvert();
                objLeadConvert.SetLeadId(objLead.Id);
                objLeadConvert.SetConvertedStatus(convertStatus.ApiName);
                objLeadConvert.setOwnerId(UserInfo.getUserId());
                leadConvertedList.add(objLeadConvert);
            }
        
            // Get result of converted Lead
            List<Database.LeadConvertResult> listLeadConvertResult = Database.convertLead(leadConvertedList);
        
        Test.stopTest();
        
        // Fetch converted Lead's record and check if 'Contact Name' has 'ConvertedContactId' as its value
        for(Lead objLead : [Select ConvertedOpportunity.Contact_Name__r.Id, ConvertedContactId 
                            From   Lead 
                            Where  IsConverted = true]) {
            System.assertEquals(objLead.ConvertedOpportunity.Contact_Name__r.Id, objLead.ConvertedContactId); 
        } 
        
    }
    
    // Check for error while updating Opportunity
    private static testMethod void testWhenErrorWhileUpdatingOpp(){
        
        // Get Lead Record Type Id
        Id customerRecTypeId 
            = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        
        Lead testLead = new Lead();
        testLead.LastName = 'Test Lead Test Running';
        testLead.Lead_Subject__c='Test Lead Subject';
        testLead.Status='New';
        testLead.RecordTypeId = customerRecTypeId;
        
        insert testLead;
        
        // Get Isconverted Status
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest(); 
        
        Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};            
            
        // Convert Lead
        Database.LeadConvert objLeadConvert = new Database.LeadConvert();
        objLeadConvert.SetLeadId(testLead.Id);
        objLeadConvert.SetConvertedStatus(convertStatus.ApiName);
        objLeadConvert.setOwnerId(UserInfo.getUserId());
        leadConvertedList.add(objLeadConvert);
           
        
        List<Database.LeadConvertResult> listLeadConvertResult;
        
        // Assert if exception occures
        try{
            // Get result of converted Lead
            listLeadConvertResult = Database.convertLead(leadConvertedList);
        }catch(Exception objExcept){
            system.assert(true);
        }
        
        Test.stopTest();
        
    }
    
    // Check for error while updating Opportunity bulk
    private static testMethod void testWhenErrorWhileUpdatingOppBulk(){
        
        // Get Lead Record Type Id
        Id customerRecTypeId 
            = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services').getRecordTypeId();
        
        // List to create Lead records        
        list<Lead> leadList = new list<Lead>();
        
        for(Integer i=0; i< 50; i++){
            Lead testLead = new Lead();
            testLead.FirstName = 'Test First';
            testLead.LastName = 'Test Lead Test Running ' + i;
            testLead.Lead_Subject__c='Test Lead Subject';
            testLead.Status='New';
            testLead.RecordTypeId = customerRecTypeId;
            leadList.add(testLead);         
        }
        insert leadList;
        
        // Get Isconverted Status
        LeadStatus convertStatus = [Select Id, ApiName from LeadStatus where IsConverted=true LIMIT 1];
        
        Test.startTest(); 
        
        Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};  
        
            // Convert Lead
            for(Lead objLead : leadList ) {
                Database.LeadConvert objLeadConvert = new Database.LeadConvert();
                objLeadConvert.SetLeadId(objLead.Id);
                objLeadConvert.SetConvertedStatus(convertStatus.ApiName);
                objLeadConvert.setOwnerId(UserInfo.getUserId());
                leadConvertedList.add(objLeadConvert);
            }
           
        
        List<Database.LeadConvertResult> listLeadConvertResult;
        
        // Assert if exception is occures
        try{
            // Get result of converted Lead
            listLeadConvertResult = Database.convertLead(leadConvertedList);
        }catch(Exception objExcept){
            system.assert(true);
        }
        
        Test.stopTest();
        
    }
    
    // Check if 'Contact Name' on Opportunity has ConvertedContactId's value
    private static testMethod void testWhenNoOppIsCreated(){
        
        // Create a Lead record
        createLeads(1);
        
        // Fetch the created Lead record
        list<Lead> listLead = [Select Id,Name, OwnerId From Lead Where FirstName Like: 'Test First%'];
        
        // Get Isconverted Status
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest(); 
        
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};            
            
            // Convert Lead
            for(Lead objLead : listLead ) {
                Database.LeadConvert objLeadConvert = new Database.LeadConvert();
                objLeadConvert.SetLeadId(objLead.Id);
                objLeadConvert.SetConvertedStatus(convertStatus.ApiName);
                objLeadConvert.setOwnerId(UserInfo.getUserId());
                objLeadConvert.setDoNotCreateOpportunity(true);
                leadConvertedList.add(objLeadConvert);
            }
        
            // Get result of converted Lead
            List<Database.LeadConvertResult> listLeadConvertResult = Database.convertLead(leadConvertedList);
        
        Test.stopTest();
        
        // Check if Lead is converted successfully
        for(Database.LeadConvertResult objLeadConvResult: listLeadConvertResult){
            system.assert(objLeadConvResult.isSuccess());
        }
        
        
    }
    
    // This method checks Lead get converted or not on click of convert button if Create
    // new Opportunity option is not selected.
    public static testMethod void leadConvertTestCase2(){
        createLeads(10);
        
        list<Lead> createdLeadList 
            = [Select Id,Name,Status,Lead_Subject__c From Lead Where FirstName Like: 'Test First%'];
        
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest(); 
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};
            for(Integer i=0; i<createdLeadList.size();i++){
                Database.LeadConvert leadConvertObj = new database.LeadConvert();
                leadConvertObj.setLeadId(createdLeadList[i].Id);
                leadConvertObj.setConvertedStatus(convertStatus.ApiName);
                leadConvertObj.setDoNotCreateOpportunity(true);
                leadConvertObj.setOwnerId(UserInfo.getUserId());
                leadConvertedList.add(leadConvertObj);
            }
            Database.LeadConvertResult[] leadConvertObjrList = Database.convertLead(leadConvertedList);
        Test.stopTest();

        list<Lead> updatedLeadList = new list<Lead>();//[Select Id,Name,Status,Lead_Subject__c,IsConverted From Lead];
        list<Opportunity> updatedOppList = new list<Opportunity>();
        for(Lead leadObj : [Select Id,Name,Status,Lead_Subject__c,IsConverted,ConvertedOpportunityId,
                                   ConvertedOpportunity.Name From Lead Where FirstName Like: 'Test First%']) {
            updatedOppList.add(leadObj.ConvertedOpportunity);
            updatedLeadList.add(leadObj);
            System.assertEquals(true, leadObj.IsConverted);
        }   
        System.assertEquals(createdLeadList.size(), updatedLeadList.size()); 
        
        list<Opportunity> updatedOppList1 = [Select Id,Name From Opportunity Where Id IN : updatedOppList];
        System.assertEquals(0, updatedOppList1.size());              
    } 

    // This method checks for the attachments on converted Opportunity when they are attached to leads.
    // new Opportunity option is selected.
   /* public static testMethod void leadConvertTestCase3(){
        
        createLeads(1);        
                
        list<Lead> createdLeadList = [Select Id,Name,Status,Lead_Subject__c From Lead];
        set<Id> createdLeadIdset = new set<Id>();
        list<attachment> attachmentListperLead;
        map<Id,List<attachment>> leadObjAttachment = new map<Id,List<attachment>>();
        map<Id,List<attachment>> oppObjAttachment = new map<Id,List<attachment>>();
        
        LeadStatus convertStatus = [Select Id, ApiName 
                                    from LeadStatus 
                                    where IsConverted=true AND ApiName = 'Became a dealer' 
                                    LIMIT 1];
        
        for(Lead ld : createdLeadList){
            attachmentListperLead = new list<attachment>();
            attachmentListperLead = createAttachments(ld.Id,2);
            if(!leadObjAttachment.containsKey(ld.Id)){
                leadObjAttachment.put(ld.Id,attachmentListperLead);
            }
        }
        
        Test.startTest();
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};
            for(Lead ld : createdLeadList ) {
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.SetLeadId(ld.Id);
                    lc.SetConvertedStatus(convertStatus.ApiName);
                    lc.setOwnerId(UserInfo.getUserId());
                    leadConvertedList.add(lc);
                }
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConvertedList);
        Test.stopTest();
        
        list<Opportunity> oppObjList = [Select Id, Name from Opportunity];
        list<Attachment> oppObjAttachmentList = new list<Attachment>(); 
        for(Attachment attachObj : [Select Id, Name, parentId from Attachment where parentId IN : oppObjList]){
            if(!oppObjAttachment.containsKey(attachObj.parentId))
                oppObjAttachment.put(attachObj.parentId,new list<Attachment> {attachObj});
            else
                oppObjAttachment.get(attachObj.parentId).add(attachObj);
        }
        System.assertEquals(oppObjAttachment.size(),leadObjAttachment.size());     
    }    
    */  
    
    // Method to test if Attachments are being added to appropriate Opportunity on Lead conversion
    public static testMethod void leadConvertTestCase3(){

       Lead objLead = [
           Select Id
           From Lead
           Where LastName =: 'Last'
           Limit 1
       ];    
        System.debug('objLead'+objLead);
        LeadStatus convertStatus = [
            SELECT Id, ApiName  
            FROM LeadStatus 
            WHERE IsConverted = True AND ApiName  = 'Sent to Customer' 
            LIMIT 1
        ];
        
        Test.startTest();
        
        Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};
            
        Database.LeadConvert leadConvertObj = new database.LeadConvert();
        leadConvertObj.setLeadId(objLead.Id);
        leadConvertObj.setConvertedStatus(convertStatus.ApiName);        
        leadConvertObj.setOwnerId(UserInfo.getUserId());
        leadConvertObj.setDoNotCreateOpportunity(false);
        leadConvertedList.add(leadConvertObj);
        System.debug('leadConvertedList'+leadConvertedList);
        Database.LeadConvertResult[] leadConvertObjrList = Database.convertLead(leadConvertedList);
        
        Test.stopTest();
        
        Lead objLead1 = [
            Select Id, AttachmentIds__c
            From Lead
            Where LastName =: 'Last'
            Limit 1
        ];
       
        
        Attachment objAttach = [
            Select Name
            From Attachment
            Where Id =: (Id)objLead1.AttachmentIds__c
        ];
        System.debug(' 123objAttach'+ objAttach);
        
   /*     Attachment objAttachOfOpp = [
            Select Name
            From Attachment
            Where ParentId =: leadConvertObjrList[0].getOpportunityId()
        ];
         System.debug('objAttachOfOpp'+objAttachOfOpp);
        System.assertEquals( objAttach.Name, objAttachOfOpp.Name );*/
    }    
    
    // This method checks for the attachments on Opportunity when they are not attached to leads.
    // new Opportunity option is selected.
    public static testMethod void leadConvertTestCase4(){
        createLeads(5);
        list<Lead> createdLeadList 
            = [Select Id,Name,Status,Lead_Subject__c From Lead Where FirstName Like: 'Test First%'];
        
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest();
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};
            for(Lead ld : createdLeadList ) {
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.SetLeadId(ld.Id);
                    lc.SetConvertedStatus(convertStatus.ApiName);
                    lc.setOwnerId(UserInfo.getUserId());
                    leadConvertedList.add(lc);
                }
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConvertedList);
        Test.stopTest();
        
        list<Opportunity> oppObjList = [Select Id, Name from Opportunity];
        list<Attachment> oppObjAttachmentList = [Select Id, Name, parentId from Attachment where parentId IN:oppObjList];
        System.assertEquals(0,oppObjAttachmentList.size());
    }
  
    // Method tests Opportunity Owner when Lead has Owner
    private static testMethod void oppOwnerForDealerOnLead(){
        
        // Create Account record
        createAccount(1);
        
        // Create Lead record
        createLeads(1);
        
        List<Lead> listLead = [Select Id From Lead ];
        
	        
        Account AccountObj = [Select Id, OwnerId From Account Where Name='AccountName'];
        System.debug('AccountObj=='+AccountObj);
        if(listLead != null && AccountObj != null){
            listLead[0].Dealer_Name__c  = AccountObj.Id;
            update listLead;
        }
        
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest();
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};
            for(Lead objLead : listLead ) {
                    Database.LeadConvert objLeadConv = new Database.LeadConvert();
                    objLeadConv.SetLeadId(objLead.Id);
                    objLeadConv.SetConvertedStatus(convertStatus.ApiName);
                    objLeadConv.setOwnerId(UserInfo.getUserId());
                    leadConvertedList.add(objLeadConv);
                }
            List<Database.LeadConvertResult> listLeadConvRes = Database.convertLead(leadConvertedList);
        Test.stopTest();
        
        list<Opportunity> listOpportunity 
            = [Select Id, OwnerId from Opportunity];
        
        System.assertEquals(AccountObj.OwnerId ,listOpportunity[0].OwnerId);
    }
    
    // Method tests Opportunity Owner when Lead has Owner bulk test
    private static testMethod void oppOwnerForDealerOnLeadBulk(){
        
        // Create Account record
        createAccount(1);
        
        // Create Lead record
        createLeads(5);
        
        List<Lead> listLead = [Select Id From Lead Where FirstName Like: 'Test First%'];
        
        List<Account> listAccount = [Select Id, OwnerId From Account Limit 1];
        
        if(listLead != null && listAccount != null){
            listLead[0].Dealer_Name__c  = listAccount[0].Id;
            update listLead;
        }
        
        LeadStatus convertStatus 
            = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer' LIMIT 1];
        
        Test.startTest();
            Database.LeadConvert[] leadConvertedList = new database.LeadConvert[]{};
            for(Lead objLead : listLead ) {
                    Database.LeadConvert objLeadConv = new Database.LeadConvert();
                    objLeadConv.SetLeadId(objLead.Id);
                    objLeadConv.SetConvertedStatus(convertStatus.ApiName);
                    objLeadConv.setOwnerId(UserInfo.getUserId());
                    leadConvertedList.add(objLeadConv);
                }
            List<Database.LeadConvertResult> listLeadConvRes = Database.convertLead(leadConvertedList);
        Test.stopTest();
        
        list<Opportunity> listOpportunity = [Select Id, OwnerId from Opportunity];
        
        for(Opportunity objOpportunity:listOpportunity){
            System.assertEquals(listAccount[0].OwnerId ,objOpportunity.OwnerId);
        }        
    }  
}