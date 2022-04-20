@isTest
public class commUserPermSetBatchTest {
    
    @isTest static void updateUserPermissionSetMethod(){
        
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
                Name              = 'account',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = '',
                Dealer_Type2__c = 'Control4'
            );
            
            insert acc;
            
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
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            Contact cn = [SELECT Id FROM Contact LIMIT 1];
            System.debug('!@#cn ' + cn);
            User user = new User(
                EmailEncodingKey  = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey    = 'America/New_York',
                LocaleSidKey      = 'en_US',
                FirstName         = 'first',
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
            
            Permissionset ps = [SELECT Id,Name  from PermissionSet WHERE Name='AutomationDataCategory'];
            List<PermissionSetAssignment> psassign = new List<PermissionSetAssignment>();
            for (PermissionSetAssignment pa: [SELECT Id,PermissionSetId,AssigneeId from PermissionSetAssignment WHERE PermissionSetId =:ps.Id]){
                if(pa.AssigneeId == user.id){
                    psassign.add(pa);
                }
            }
            if(psassign.size() >0) delete psassign;
            
            
            Test.startTest();
            commUserPermSetBatch obj = new commUserPermSetBatch();
            DataBase.executeBatch(obj); 
            Test.stopTest();
        }
        
    }
    
}