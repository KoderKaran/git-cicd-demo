@isTest
public class OpportunityTriggerHandler_test {
    @testSetup
    static void setupTestData(){
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        List<UserRole> bulkRole = new List<UserRole>();
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        bulkRole.add(r);
        UserRole x = new UserRole(DeveloperName = 'MyCustomRoleChild', Name = 'My Role Child' , ParentRoleId = r.Id);
        bulkRole.add(x);
        
        insert bulkRole;
        List<User> bulkUser = new List<User>();
        UserRole checkUserRole = [select Id,ParentRoleId from UserRole where ParentRoleId != null limit 1];
        User uu=new User( 
            ProfileId = pf.id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = checkUserRole.Id,
            IsActive = true
        ); 
        bulkUser.add(uu);
        User u=new User( 
            ProfileId = pf.id,
            LastName = 'sample',
            Email = 'puser000@amamama1.com',
            Username = 'puser000@amamama1.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = checkUserRole.Id
        );
        bulkUser.add(u);
        insert bulkUser;    
    }
    
    static testMethod void insertNewOpportunity() {
        User u = [select Id,UserRoleId from User where LastName='sample' limit 1];
        Id recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Showroom Event').getRecordTypeId(); 
        UserRole checkUserRole = [select Id,ParentRoleId from UserRole where ParentRoleId != null limit 1];
		Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.SAP_ACCOUNT_ID__c = 'E91231';
        insert acc;
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity Triggers',
            CloseDate = system.Date.today(),           
            StageName = 'Sourcing Demand',
            Showroom_Dealer_ID__c = acc.SAP_ACCOUNT_ID__c,
            RecordTypeId = recordType,
            AccountId = acc.Id
        );
        insert testOpportunity;
        Test.startTest();
        testOpportunity.OwnerId = u.Id;
        update testopportunity;
        Test.stopTest();               
    }
    
    static testMethod void insertNewOpportunityAndAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.SAP_ACCOUNT_ID__c = 'E91231';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opportunity Test 1';
        opp.StageName = 'Certified Showroom Onboarded';
        opp.ForecastCategoryName = 'Pipeline';
        opp.CloseDate = Date.Today();
        opp.Showroom_Dealer_ID__c = acc.SAP_ACCOUNT_ID__c;
        insert opp;      
    }
    
    @isTest
    static void testOpportunity_insertOppTeam() {
        User u = [select Id,UserRoleId from User where LastName='last'];
        UserRole checkUserRole = [select Id,ParentRoleId from UserRole where ParentRoleId != null and Id =: u.UserRoleId limit 1 ];

        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.SAP_ACCOUNT_ID__c = 'E91231';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opportunity Test 1';
        opp.StageName = 'Certified Showroom Onboarded';
        opp.ForecastCategoryName = 'Pipeline';
        opp.CloseDate = Date.Today();
        opp.Showroom_Dealer_ID__c = acc.SAP_ACCOUNT_ID__c;
        opp.OwnerId = u.Id;
        insert opp;
        
        OpportunityTeamMember oppmember = new OpportunityTeamMember(); 
        oppmember.OpportunityId = opp.Id;
        oppmember.UserId = u.Id;
        oppmember.is_Generated__c = true;
        insert oppmember;
    }

    @isTest
    static void testOpportunity_transferLeadMessage() {

        Test.startTest();

        Account testAccount = new Account(
            Name = 'testAcc1'
        );
        insert testAccount;

        Lead testLead = new Lead(
            LastName = 'testLead1',
            SDR_Notes__c = 'New Message'
        );
        insert testLead;

        Opportunity testOpportunity = new Opportunity(
            Associated_Lead__c = testLead.Id,
            Name = 'testOpp1',
            StageName = 'Certified Showroom Onboarded',
            CloseDate = Date.Today(),
            LeadGen_Notes__c = 'new Note'
        );
        insert testOpportunity;

       // System.assertEquals('New Message', [SELECT LeadGen_Notes__c FROM Opportunity LIMIT 1].LeadGen_Notes__c);

        Test.stopTest();

    }    
    
}