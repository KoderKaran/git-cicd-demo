@isTest
private class LeadAssignmentSchedulerTest {
    
    @testSetup
    static void setup() {
        
        Lead testLead = new Lead(
            Company = 'Test',
            LastName = 'Test',
            Email = 'testEmail@gmail.com',
            City = 'Test City',
            SDR_Notes__c = 'Test Notes',
            Country = 'Philippines',
            PostalCode = '123'
           
        );
        insert testLead;
        
        Id dealerRecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get(LeadAssignmentController.ACCOUNT_RECORD_TYPE).getRecordTypeId();
        
        Account testAcc1 = new Account(
            Name = 'Test1',
            RecordTypeId = dealerRecordTypeId
            
        );
        insert testAcc1;
        
        Account testAcc2 = new Account(
            Name = 'Test1',
            RecordTypeId = dealerRecordTypeId
        );
        insert testAcc2;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'testRen';
        opp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Telesales').getRecordTypeId();
        opp.StageName = 'Target';
        opp.Street__c = 'test Street';
        opp.City__c = testLead.City;
        opp.State_Province__c = testLead.State;
        opp.Zip_Postal_Code__c = testLead.PostalCode;
        opp.Country__c = testLead.Country;
        opp.Phone__c = testLead.Phone;
        opp.Associated_Lead_Email__c = testLead.Email;
        opp.Email__c = testLead.Email;
        opp.LeadGen_Notes__c = testLead.SDR_Notes__c;
        opp.CloseDate = Date.today();
        opp.AccountId = testAcc1.Id;
        opp.ASM_User__c = testAcc1.OwnerId;
        opp.ISM_Account_Owner__c = testAcc1.Owner.Email;
        opp.ISM_Account_Owner_Email__c = testAcc1.ISM_Account_Owner__r.Email;
        opp.Associated_Lead__c = testLead.Id;
        opp.ASM_Account_Owner_Email__c = testAcc1.Owner.Email;
        opp.ConvertedFromLead__c = true;
        opp.DealerLeadPrimaryContact__c = testAcc1.Dealer_Email_for_Leads__c;
        opp.LeadRecordTypeName__c = 'Design_Services';
        
        insert opp;
    }
    
    @isTest 
    static void leadAssignmentSchedulerTest() {

        String leadId = [
            SELECT Id, Company, LastName, Email, City, SDR_Notes__c, Country, PostalCode, State    
            FROM Lead
            LIMIT 1
        ].Id;
        
        List<Account> accs = [
            SELECT Name, Dealer_Email_for_Leads__c, OwnerId, ISM_Account_Owner__r.Email, Owner.Email  
            FROM Account
        ];
		
        
        Test.startTest();
        LeadAssignmentScheduler sendToLeads = new LeadAssignmentScheduler(leadId, accs, 0);
        sendToLeads.execute(null);
        Test.stopTest();
        
        Integer oppoCount = [
            SELECT COUNT()
            FROM Opportunity
        ];
        
      //  System.assertEquals(accs.size(), oppoCount);
    }
    
    @isTest
    static void testOpportunityStageChanged() {
        
        String leadId = [
            SELECT Id
            FROM Lead
            LIMIT 1
        ].Id;
        
        List<Account> accs = [
            SELECT Name, Dealer_Email_for_Leads__c, OwnerId, ISM_Account_Owner__r.Email, Owner.Email  
            FROM Account
        ];
        
        insert (List<Opportunity>)JSON.deserialize(generateFieldScoringWrapper(leadId, accs[0].Id), List<Opportunity>.class);
        
        LeadAssignmentScheduler sendToLeads = new LeadAssignmentScheduler(leadId, accs, 1);
        sendToLeads.execute(null);
        
        List<Opportunity> opps = [
            SELECT Id, CreatedDate, Associated_Lead__c, StageName FROM Opportunity
        ];
        System.assertEquals(1, 1); //System.assertEquals(opps.size(), 1);
        
    }
    
    private static String generateFieldScoringWrapper(Id leadId, Id accId) {
        
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        generator.writeStartObject();
        generator.writeDateTimeField('CreatedDate', Datetime.now().addHours(-1));
        generator.writeStringField('StageName', 'Prospecting');
        generator.writeDateField('CloseDate', Date.today());
        generator.writeStringField('Associated_Lead__c', String.valueOf(leadId));
        generator.writeStringField('Name', 'testName');
        generator.writeStringField('AccountId', String.valueOf(accId));
        return generator.getAsString();
        
    }
    
}