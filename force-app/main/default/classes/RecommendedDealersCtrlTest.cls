@isTest
public class RecommendedDealersCtrlTest {

    @testSetup
    private static void setup() {
        Account account = new Account(
            Name = 'test'
        );
        insert account;
        
        Contact contact = new Contact(
            LastName = 'test',
            AccountId = account.Id,
            Phone = '1234567890'
        );
        insert contact;
        
        account.Dealer_Contact_for_Leads__c = contact.Id;
        update account;
        
        Lead lead = new Lead(
            LastName = 'test',
            Company = 'test',
            Email = 'test@test.com'
        );
        insert lead;
        
        Opportunity opportunity = new Opportunity(
            Name = 'test',
            StageName = 'Closed Lost',
            CloseDate = Date.today(),
            AccountId = account.Id,
            Associated_Lead__c = lead.Id
        );
        insert opportunity;
    }
    
    @isTest
    private static void testComponentInitialization() {
        Test.startTest();
        
        RecommendedDealersCtrl ctrl = new RecommendedDealersCtrl();
        ctrl.leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        System.assert(ctrl.lead != null);
        
        Test.stopTest();
        
        System.assert(!ctrl.oppos.isEmpty());
    }

}