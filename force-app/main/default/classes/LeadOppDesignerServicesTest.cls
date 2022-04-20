@isTest
public class LeadOppDesignerServicesTest {
    @testSetup
    static void setupTestData(){
        
        Profile pf= [Select Id from profile where Name = 'System Administrator']; 
        User userObj = new User( 
            ProfileId = pf.id,
            LastName = 'last 101',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true
            ); 
        insert userObj;
    }
    
	static testmethod void LeadOppDesignServices_positive() {
        User userObj = [SELECT Id FROM User WHERE LastName = 'last 101' limit 1];
        System.RunAs(userObj){

        Account acc = new Account();
        acc.Name = 'testName';
        acc.ISM_Account_Owner__c = userObj.id;
        acc.OwnerId = userObj.id;
       
        insert acc;
              
        Lead objLead = new Lead();
        string recordTypeId1 = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services')
            .getRecordTypeId();
        objLead.RecordTypeId = recordTypeId1;
        objLead.LastName = 'Sample Lead';
        objLead.Status = 'New';
        objLead.Company = 'Test Company';
        objLead.Currency__c = 'AUD';
        // Insert the Lead
        insert objLead;
        
        Test.startTest();
        
        LeadStatus convert = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer'];
        //Lead Convert
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(objLead.Id);
        lc.setAccountId(acc.Id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus(convert.ApiName);
        lc.setOwnerId(userObj.Id);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);

        Test.stopTest();
        
        Lead updatedLead = [SELECT Id,OwnerId,ConvertedOpportunityId FROM Lead];
        Opportunity oppCheck = [SELECT Id,StageName,OwnerId,Account.ISM_Account_Owner__c,RecordType.Name FROM Opportunity 
        	WHERE Id =: updatedLead.ConvertedOpportunityId];
		System.assertEquals('New Design Opportunity', oppCheck.StageName);
        System.assertEquals('Design Services', oppCheck.RecordType.Name);
      }
      
    }
    
	static testmethod void LeadOppDesignServices_negative() {
        User userObj = [SELECT Id FROM User WHERE LastName = 'last 101' limit 1];
        System.RunAs(userObj){

        Account acc = new Account();
        acc.Name = 'testName';
        acc.OwnerId = userObj.id;
       
        insert acc;
              
        Lead objLead = new Lead();
        string recordTypeId1 = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Design Services')
            .getRecordTypeId();
        objLead.RecordTypeId = recordTypeId1;
        objLead.LastName = 'Sample Lead';
        objLead.Status = 'New';
        objLead.Company = 'Test Company';
        objLead.Currency__c = 'AUD';
        // Insert the Lead
        insert objLead;
        
        Test.startTest();
        
        LeadStatus convert = [SELECT Id, ApiName  FROM LeadStatus WHERE IsConverted = True AND ApiName  = 'Sent to Customer'];
        //Lead Convert
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(objLead.Id);
        lc.setAccountId(acc.Id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus(convert.ApiName);
        lc.setOwnerId(userObj.Id);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
       
        Test.stopTest();
        
        Lead updatedLead = [SELECT Id,OwnerId,ConvertedOpportunityId FROM Lead];
        Opportunity oppCheck = [SELECT Id,StageName,OwnerId,Account.ISM_Account_Owner__c,RecordType.Name FROM Opportunity 
        	WHERE Id =: updatedLead.ConvertedOpportunityId];
		System.assertEquals('New Design Opportunity', oppCheck.StageName);
        System.assertEquals('Design Services', oppCheck.RecordType.Name);
      }
      
    }
    
}