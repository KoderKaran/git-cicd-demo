@isTest
private class LeadAssignmentControllerTest {
    
    @testSetup
    static void setup() {
        
        Lead testLead = new Lead();
        testLead.Company = 'Test';
        testLead.LastName = 'Test';
        testLead.Latitude = 0.101;  
        testLead.Longitude = 0.101;
        testLead.Email = 'Test@gmail.com';		
        insert testLead;
        
        Id dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LeadAssignmentController.ACCOUNT_RECORD_TYPE).getRecordTypeId();
        
        Account testAcc1 = new Account();
        testAcc1.Name = 'Test1';
        testAcc1.Dealer_Lead_Primary_Contact_Email__c = 'test@gmail.com';
        testAcc1.RecordTypeId = dealerRecordTypeId;
        testAcc1.BillingLatitude = 0.101;
        testAcc1.BillingLongitude = 0.102;
        testAcc1.Dealer_Type2__c = 'Control4';
        testAcc1.Account_Status__c = 'Active';
        testAcc1.SAP_BP_Status__c = 'Active';
        testAcc1.SAP_Termination_Status__c = 'Active';
        
        insert testAcc1;
        
        Account testAcc2 = new Account();
        testAcc2.Name = 'Test1';
        testAcc2.Dealer_Lead_Primary_Contact_Email__c = 'test@gmail.com';
        testAcc2.RecordTypeId = dealerRecordTypeId;
        testAcc2.BillingLatitude = 0.101;
        testAcc2.BillingLongitude = 0.102;
        testAcc2.Dealer_Type2__c = 'Control4';
        testAcc2.Account_Status__c = 'Active';
        testAcc2.Dealer__c = testAcc1.Id;
        insert testAcc2;  
        
        Account testAcc3 = new Account();
        testAcc3.Name = 'Test1';
        testAcc3.Dealer_Lead_Primary_Contact_Email__c = 'test@gmail.com';
        testAcc3.RecordTypeId = dealerRecordTypeId;
        testAcc3.BillingLatitude = 0.101;
        testAcc3.BillingLongitude = 0.102;
        testAcc3.Dealer_Type2__c = 'Control4';
        testAcc3.Account_Status__c = 'Active';
        testAcc3.SAP_BP_Status__c = 'Active';
        testAcc3.SAP_Termination_Status__c = 'Active';
        
        insert testAcc3;     
        
        Account testAcc4 = new Account();
        testAcc4.Name = 'Test1';
        testAcc4.Dealer_Lead_Primary_Contact_Email__c = 'test@gmail.com';
        testAcc4.RecordTypeId = dealerRecordTypeId;
        testAcc4.BillingLatitude = 0.101;
        testAcc4.BillingLongitude = 0.102;
        testAcc4.Dealer_Type2__c = 'Control4';
        testAcc4.Account_Status__c = 'Active';
        testAcc4.Dealer__c = testAcc3.Id;
        insert testAcc4; 
        
    }
    
    @isTest 
    static void getDealersTest() {
        
        String leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        
        Test.startTest();
        List<LeadAssignmentController.DealerWrapper> wrappers = LeadAssignmentController.getDealers(leadId);
        system.debug('getdealersWrapperTest>>>' + wrappers);
        Test.stopTest();
        
        Integer accNumber = [SELECT COUNT()FROM Account];
        
    }
    
    @isTest 
    static void validateLeadTest() {
        
        String leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        String excMessage;
        Test.startTest();
        try {
            LeadAssignmentController.validateLead(leadId);
        }
        catch(AuraHandledException exc) {
            excMessage = exc.getMessage();
        }
        Test.stopTest();
        
        System.assertNotEquals(null, excMessage);
    }
    
    @isTest 
    static void sendLeadsToDealersTest() {
        String a;
        LeadAssignmentController.getSettingURL(a);
        List<Account> acc = [Select Id, Account_Status__c,RecordType.Name,BillingLatitude,BillingLongitude, Dealer_Type2__c from Account];
        system.debug('acc>>' + acc);
        String leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        system.debug('leadId>>>' + leadId);
        List<LeadAssignmentController.DealerWrapper> wrappers = LeadAssignmentController.getDealers(leadId);
        system.debug('wrappers>>>>>>' + wrappers);
        List<LeadAssignmentController.DealerWrapper> sendNowList = new List<LeadAssignmentController.DealerWrapper>{ wrappers[0] };
        List<LeadAssignmentController.DealerWrapper> sendLaterList = new List<LeadAssignmentController.DealerWrapper>{ wrappers[1] };
                
                Test.startTest();
        LeadAssignmentController.sendLeadsToDealers(
            leadId, 
            JSON.serialize(sendNowList),
            '1',
            JSON.serialize(sendLaterList)
        );
        
        Test.stopTest();
        
        Integer oppoCount = [
            SELECT COUNT()
            FROM Opportunity
        ];
        
        System.assertEquals(2, oppoCount);
        
    }
}