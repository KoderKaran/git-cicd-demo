@istest
public class LeadTrackingTriggerTest {
    static testmethod void testOpportunityCreated()
    {
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy'];
        test.startTest();
            le.Status = 'Opportunity Created';
            update le;
        test.stopTest();
    }  

    
    static testmethod void testInstalled()
    {
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy1';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy1'];
        test.startTest();
            le.Status = 'Installed';
            update le;
        test.stopTest();
    } 
    static testmethod void testTermLead()
    {
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy2';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy2'];
        test.startTest();
            le.Status = 'Term Lead';
            update le;
        test.stopTest();
    } 
    static testmethod void testRenewedInterest()
    {
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy3';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy3'];
        test.startTest();
            le.Status = 'Renewed Interest';
            update le;
        test.stopTest();
    } static testmethod void testNew()
    {
        Id recordTypeAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account a = new Account();
        a.RecordTypeId = recordTypeAccount;
        a.Name = 'Test';
        insert a;
        
        Contact con = new Contact();
        con.lastName = 'Test';
        con.accountId = a.id;
        insert con;
        
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy4';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        l.Dealer__c = a.id;
        l.Dealer_2__c = a.id;
        l.Dealer_3__c = a.id;
        insert l;
        
        Lead le= [Select Name,Id From Lead Where Name=:'Testy4'];
        test.startTest();
            le.Status = 'New';
            update le;
        test.stopTest();
    } 
    static testmethod void testAttemptingContact()
    {
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy5';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy5'];
        test.startTest();
            le.Status = 'Attempting Contact';
            update le;
        test.stopTest();
    } 
    
    static testmethod void testSentToDealer()
    {
        Account a = new Account();
        a.Name = 'SampleName';
        a.RecordTypeId = '012500000005B5m';
        a.Dealer_Lead_Primary_Contact_Email__c = 'jpPogi@yahoo.com';
        insert a;
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy5';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy5'];
        test.startTest();
            le.Status = 'Sent To Dealer';
        	le.Dealer__c = a.id;
            le.Dealer_2__c = a.id;
            le.Dealer_3__c = a.id;
            update le;
        test.stopTest();
    } 
    
    static testmethod void testSentToDealerNoEmail()
    {   
        Account a = new Account();
        a.Name = 'SampleName';
        a.RecordTypeId = '012500000005B5m';
        insert a;
        Contact c = new Contact();
        c.lastName = 'SampleContact';
        c.AccountId = a.Id;
        c.Primary_User__c = true;
        c.Email = 'sample@yahoo.com';
        insert c;
        Lead l = new Lead();
        l.Status = 'New';
        l.LastName = 'Testy5';
        l.Company = 'Test co.';
        l.RecordTypeId = '012500000005dac';
        insert l;
        Lead le= [Select Name,Id From Lead Where Name=:'Testy5'];
        test.startTest();
            le.Status = 'Sent To Dealer';
        	le.Dealer__c = a.id;
            le.Dealer_2__c = a.id;
            le.Dealer_3__c = a.id;
            update le;
        test.stopTest();
    } 
}