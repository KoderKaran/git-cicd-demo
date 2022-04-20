@isTest
private class AccountTriggerHandlerTest {

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
                Dealer_Type2__c = 'Control4'
            );
            
            insert acc;
            
            
            Account childAcc = new Account(
                Name              = 'childAccount1',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                ShippingPostalCode = '1234',
                Core_City_Manual_Override__c = false,
                Dealer_Type2__c = 'SnapAV',
                ParentId =acc.Id
            );
            Insert childAcc;
            
            Account childAcc2 = new Account(
                Name              = 'childAccount2',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                ShippingPostalCode = '1234',
                Core_City_Manual_Override__c = false,
                Dealer_Type2__c = 'Control4',
                ParentId =acc.Id
            );
            Insert childAcc2;
            
            
            System.debug('!@#Acc ' + acc);
            Contact con = new Contact(
                Firstname     = 'Firstname',
                Lastname      = 'Lastname',
                Avatar_URL__c = 'test',
                Email         = '',
                MobilePhone   = '',
                AccountId     = acc.Id,
                Description   = ''
            ); 
            
            insert con;
            System.debug('!@#Con ' + con);
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            Contact cn = [SELECT Id FROM Contact LIMIT 1];
            System.debug('!@#cn ' + cn);
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
                ContactId         = cn.Id
            );
            
            insert user;   
    }
    }

    @isTest static void createAccount(){
        Integer numsOfAccts = 3;
        List<Account> accts = new List<Account>();
        List<Core_City__c> lstCoreCity = new List<Core_City__c>();
        
        for(Integer j=0; j<numsOfAccts; j++){
            Core_City__c c = new Core_City__c();
            c.Name = 'Washington'+j;
            c.City__c = 'Washington'+j;
            c.Zip_Code__c = '1903';
            lstCoreCity.add(c);
        }
        insert lstCoreCity;
        
        for(Integer i=0; i<numsOfAccts; i++){
            Account a = new Account();
            a.Name = 'Test'+i;
            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            a.ShippingPostalCode = lstCoreCity[0].Zip_Code__c;
            a.Core_City_Manual_Override__c = false;
            accts.add(a);
        }
        insert accts;
        
    }
    
    @isTest static void updateUserPermissionSetMethod(){
        

            //user.ContactId = con.Id;
            //update user;
            
            User uCon = [SELECT Id,name, contactId,isActive,contact.AccountId,AccountId, Account.Name FROM User WHERE FirstName = 'firstu' LIMIT 1];
            system.debug('!@# user >>' + uCon);
			Account acc = [SELECT Id FROM Account WHERE Name = 'accounttriggertest'];
            
            system.debug('!!! user@@2 >>' + uCon);
			
            Test.startTest();
            acc.ShippingPostalCode = '12345';
            update acc;
			
            Test.stopTest();
            
        }

    @isTest static void removeUserPermissionSetMethod(){
        

            //user.ContactId = con.Id;
            //update user;
            
            User uCon = [SELECT Id,name, contactId,isActive,contact.AccountId,AccountId, Account.Name FROM User WHERE FirstName = 'firstu' LIMIT 1];
            system.debug('!@# user >>' + uCon);
			Account acc = [SELECT Id FROM Account WHERE Name = 'accounttriggertest'];
            
            system.debug('!!! user@@2 >>' + uCon);
			
            Test.startTest();
            
            acc.Dealer_Type2__c = 'SnapAV';
            update acc;
			
            Test.stopTest();
            
        }
    
    
    @isTest static void ParentwithChildAutomation(){
        User uCon = [SELECT Id,name, contactId,isActive,contact.AccountId,AccountId, Account.Name FROM User WHERE FirstName = 'firstu' LIMIT 1];
        system.debug('!@# user >>' + uCon);
        Account acc = [SELECT Id FROM Account WHERE Name = 'accounttriggertest'];
        Account childAcc = [SELECT Id FROM Account WHERE Name = 'childAccount1']; 

        Test.startTest();
        childAcc.ShippingPostalCode = '12345';
        update childAcc;
        
        Test.stopTest();
        
    }
    
 
    
}