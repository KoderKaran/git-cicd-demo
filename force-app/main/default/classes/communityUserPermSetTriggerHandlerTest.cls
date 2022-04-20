@isTest
public class communityUserPermSetTriggerHandlerTest {

    @testSetup static void setup() {
        UserRole r = new UserRole(name = 'TEST ROLE 14');
        insert r;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userWithRole = new User(
            alias             = 'role14', 
            email             = 'userwithrole14@roletest1.com', 
            userroleid        = r.id,
            emailencodingkey  = 'UTF-8', 
            lastname          = 'Testing14', 
            languagelocalekey = 'en_US', 
            localesidkey      = 'en_US', 
            profileid         = pf.Id, 
            timezonesidkey    = 'America/Los_Angeles', 
            username          = 'userwithrole14@testorg.com',
            isActive = true
        );
        
        system.debug('userWithRole : ' + userWithRole);
        
        System.runAs(userWithRole) {
            
            Account acc = new Account(
                Name              = 'accounttriggertest',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                ShippingPostalCode = '1234',
                Core_City_Manual_Override__c = false,
                Dealer_Type2__c = 'SnapAV'
            );
            
            insert acc;
            
        List <Account> childAccList = new List<Account>();
        For(Integer i=1 ;i<=5 ; i++){
            Account Cacc = new Account();
            Cacc.Name              = 'accounttriggertest' + i;
            Cacc.BillingStreet     = '';
            Cacc.BillingPostalCode = '';
            Cacc.BillingCity       = '';
            Cacc.BillingCountry    = '';
            Cacc.BillingState      = '';
            Cacc.ShippingPostalCode = '1234';
            Cacc.Core_City_Manual_Override__c = false;
            Cacc.Dealer_Type2__c = 'Control4';
            Cacc.ParentId =acc.Id;
            childAccList.add(Cacc);
            
        }
        insert childAccList; 
            
            System.debug('!@#Acc ' + acc);
            List <Contact> conList = new List<Contact>();
            For(Integer i=1 ;i<=5 ; i++){
                Contact cc = new contact();
                cc.Firstname     = 'Firstname'+i;
                cc.Lastname      = 'Lastname'+i;
                cc.Avatar_URL__c = 'test';
                cc.Email         = '';
                cc.MobilePhone   = '';
                cc.AccountId     = acc.Id;
                cc.Description   = '';
                conlist.add(cc);
            }
            insert conList;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            User user = new User(
                EmailEncodingKey  = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey    = 'America/New_York',
                LocaleSidKey      = 'en_US',
                FirstName         = 'firstu',
                LastName          = 'last',
                Username          = 'test123555@appirio.com', 
                CommunityNickname = 'testUser123',
                Alias             = 't1',
                Email             = 'no@email.com',
                IsActive          = true,
                ProfileId         = p.Id,
                ContactId         = conList[0].Id
            );
            
            insert user;   
        }
    }
    
    @isTest static void createUserwithAutomationAccountwithChild(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
        List<Contact> conList = [SELECT Id FROM Contact LIMIT 10];
        User user = new User(
            EmailEncodingKey  = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey    = 'America/New_York',
            LocaleSidKey      = 'en_US',
            FirstName         = '12first',
            LastName          = '12last',
            Username          = '12test123555@appirio.com', 
            CommunityNickname = '12testUser123',
            Alias             = 't1',
            Email             = '2no@email.com',
            IsActive          = true,
            ProfileId         = p.Id,
            ContactId         = conList[2].Id
            
        );
        test.startTest();
        insert user;
        user.subscribeGroup__c = '';
        update user;
        
        user.subscribeGroup__c = '123456789';
        update user;
        test.stopTest();
        
    }
    
    @isTest static void createUserwithNonAutomationAccountnoChild(){
        
        Account acc = new Account(
            Name              = 'accounttriggertest2',
            BillingStreet     = '',
            BillingPostalCode = '',
            BillingCity       = '',
            BillingCountry    = '',
            BillingState      = '',
            ShippingPostalCode = '1234',
            Core_City_Manual_Override__c = false,
            Dealer_Type2__c = 'SnapAV'
        );
        
        insert acc;
        
        Contact cc = new Contact();
        cc.Firstname     = 'NewConFirst';
        cc.Lastname      = 'NewConLast';
        cc.Avatar_URL__c = 'test';
        cc.Email         = '';
        cc.MobilePhone   = '';
        cc.AccountId     = acc.Id;
        cc.Description   = '';
        insert cc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
        User user = new User(
            EmailEncodingKey  = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey    = 'America/New_York',
            LocaleSidKey      = 'en_US',
            FirstName         = '12first',
            LastName          = '12last',
            Username          = '12test123555@appirio.com', 
            CommunityNickname = '12testUser123',
            Alias             = 't1',
            Email             = '2no@email.com',
            IsActive          = true,
            ProfileId         = p.Id,
            ContactId         = cc.Id
            
        );
        test.startTest();
        insert user; 
        test.stopTest();
        
    }
    
    @isTest static void createUserwithAutomationAccountnoChild(){
        UserRole r = new UserRole(name = 'TEST ROLE 14');
        insert r;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userWithRole = new User(
            alias             = 'role14', 
            email             = 'userwithrole14@roletest12.com', 
            userroleid        = r.id,
            emailencodingkey  = 'UTF-8', 
            lastname          = 'Testing14', 
            languagelocalekey = 'en_US', 
            localesidkey      = 'en_US', 
            profileid         = pf.Id, 
            timezonesidkey    = 'America/Los_Angeles', 
            username          = 'userwithrole124@testorg.com',
            isActive = true
        );
        
        system.debug('userWithRole : ' + userWithRole);
        
        System.runAs(userWithRole) {
            Account acc = new Account(
                Name              = 'accounttriggertest2',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                ShippingPostalCode = '1234',
                Core_City_Manual_Override__c = false,
                Dealer_Type2__c = 'Control4'
            );
            
            insert acc;
            
            Contact cc = new Contact();
            cc.Firstname     = 'NewConFirst';
            cc.Lastname      = 'NewConLast';
            cc.Avatar_URL__c = 'test';
            cc.Email         = '';
            cc.MobilePhone   = '';
            cc.AccountId     = acc.Id;
            cc.Description   = '';
            insert cc;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            User user = new User(
                EmailEncodingKey  = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey    = 'America/New_York',
                LocaleSidKey      = 'en_US',
                FirstName         = '12first',
                LastName          = '12last',
                Username          = '12test123555@appirio.com', 
                CommunityNickname = '12testUser123',
                Alias             = 't1',
                Email             = '2no@email.com',
                IsActive          = true,
                ProfileId         = p.Id,
                ContactId         = cc.Id
                
            );
            test.startTest();
            insert user;
            test.stopTest();
            
        }
    }
    
    @isTest static void createUserwithParentAutomationAccountwithChild(){
        UserRole r = new UserRole(name = 'TEST ROLE 14');
        insert r;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userWithRole = new User(
            alias             = 'role14', 
            email             = 'userwithrole314@roletest12.com', 
            userroleid        = r.id,
            emailencodingkey  = 'UTF-8', 
            lastname          = 'Testing14', 
            languagelocalekey = 'en_US', 
            localesidkey      = 'en_US', 
            profileid         = pf.Id, 
            timezonesidkey    = 'America/Los_Angeles', 
            username          = 'userwithrole1324@testorg.com',
            isActive = true
        );
        
        system.debug('userWithRole : ' + userWithRole);
        
        System.runAs(userWithRole) {
            Account acc = new Account(
                Name              = 'accounttriggertest',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                ShippingPostalCode = '1234',
                Core_City_Manual_Override__c = false,
                Dealer_Type2__c = 'Control4'
            );
            
            insert acc;
            
            List <Account> childAccList = new List<Account>();
            For(Integer i=1 ;i<=5 ; i++){
                Account Cacc = new Account();
                Cacc.Name              = 'accounttriggertest' + i;
                Cacc.BillingStreet     = '';
                Cacc.BillingPostalCode = '';
                Cacc.BillingCity       = '';
                Cacc.BillingCountry    = '';
                Cacc.BillingState      = '';
                Cacc.ShippingPostalCode = '1234';
                Cacc.Core_City_Manual_Override__c = false;
                Cacc.Dealer_Type2__c = 'Control4';
                Cacc.ParentId =acc.Id;
                childAccList.add(Cacc);
                
            }
            insert childAccList; 
            
            Contact cc = new Contact();
            cc.Firstname     = 'NewConFirst';
            cc.Lastname      = 'NewConLast';
            cc.Avatar_URL__c = 'test';
            cc.Email         = '';
            cc.MobilePhone   = '';
            cc.AccountId     = acc.Id;
            cc.Description   = '';
            insert cc;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            User user = new User(
                EmailEncodingKey  = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey    = 'America/New_York',
                LocaleSidKey      = 'en_US',
                FirstName         = '12first',
                LastName          = '12last',
                Username          = '12test123555@appirio.com', 
                CommunityNickname = '12testUser123',
                Alias             = 't1',
                Email             = '2no@email.com',
                IsActive          = true,
                ProfileId         = p.Id,
                ContactId         = cc.Id
                
            );
            test.startTest();
            insert user; 
            test.stopTest();
            
        }
    }
    
    @isTest static void createUserwithParentNonAutoAccountwithChild(){
        UserRole r = new UserRole(name = 'TEST ROLE 14');
        insert r;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userWithRole = new User(
            alias             = 'role14', 
            email             = 'userwi3throle314@roletest12.com', 
            userroleid        = r.id,
            emailencodingkey  = 'UTF-8', 
            lastname          = 'Testing14', 
            languagelocalekey = 'en_US', 
            localesidkey      = 'en_US', 
            profileid         = pf.Id, 
            timezonesidkey    = 'America/Los_Angeles', 
            username          = 'userwithr3ole1324@testorg.com',
            isActive = true
        );
        
        system.debug('userWithRole : ' + userWithRole);
        
        System.runAs(userWithRole) {
            Account acc = new Account(
                Name              = 'accounttriggertest',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                ShippingPostalCode = '1234',
                Core_City_Manual_Override__c = false,
                Dealer_Type2__c = 'SnapAV'
            );
            
            insert acc;
            
            List <Account> childAccList = new List<Account>();
            For(Integer i=1 ;i<=5 ; i++){
                Account Cacc = new Account();
                Cacc.Name              = 'accounttriggertest' + i;
                Cacc.BillingStreet     = '';
                Cacc.BillingPostalCode = '';
                Cacc.BillingCity       = '';
                Cacc.BillingCountry    = '';
                Cacc.BillingState      = '';
                Cacc.ShippingPostalCode = '1234';
                Cacc.Core_City_Manual_Override__c = false;
                Cacc.Dealer_Type2__c = 'SnapAV';
                Cacc.ParentId =acc.Id;
                childAccList.add(Cacc);
                
            }
            insert childAccList; 
            
            Contact cc = new Contact();
            cc.Firstname     = 'NewConFirst';
            cc.Lastname      = 'NewConLast';
            cc.Avatar_URL__c = 'test';
            cc.Email         = '';
            cc.MobilePhone   = '';
            cc.AccountId     = acc.Id;
            cc.Description   = '';
            insert cc;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            User user = new User(
                EmailEncodingKey  = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey    = 'America/New_York',
                LocaleSidKey      = 'en_US',
                FirstName         = '12first',
                LastName          = '12last',
                Username          = '12test123555@appirio.com', 
                CommunityNickname = '12testUser123',
                Alias             = 't1',
                Email             = '2no@email.com',
                IsActive          = true,
                ProfileId         = p.Id,
                ContactId         = cc.Id
                
            );
            test.startTest();
            insert user; 
            
            test.stopTest();
            
        }
    }
}