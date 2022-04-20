/**
 * @description       : Test class for FeedItemTriggerHandler
 * @author            : Simplus 
 * Modifications Log 
 * Ver   Date         Author   				Modification
 * 1.0   04-28-2021   Mozart Labao   		Initial Version
 * 1.x	 08-25-2021	  Raymart Tolentino   	Case-00026252
**/
@istest
public class FeedItemTriggerHandlerTest {
    @testSetup 
    static void setup(){
        UserRole userRoleRecord = new UserRole(name = 'TEST ROLE 14');
        insert userRoleRecord;
        
        Profile profileSystemAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userRecordWithRole = new User(
            alias             = 'role14', 
            email             = 'userwithrole14@roletest1.com', 
            userroleid        = userRoleRecord.id,
            emailencodingkey  = 'UTF-8', 
            lastname          = 'Testing14', 
            languagelocalekey = 'en_US', 
            localesidkey      = 'en_US', 
            profileid         = profileSystemAdmin.Id, 
            timezonesidkey    = 'America/Los_Angeles', 
            username          = 'userwithrole14@testorg.com'
        );
        
        insert userRecordWithRole;
        
        System.runAs(userRecordWithRole) {
            Account accountRecord = new Account(
                Name              = 'account',
                BillingStreet     = '',
                BillingPostalCode = '',
                BillingCity       = '',
                BillingCountry    = '',
                BillingState      = ''
            );
            
            insert accountRecord;
            
            Contact contactRecord = new Contact(
                Firstname     = 'Firstname',
                Lastname      = 'Lastname',
                Avatar_URL__c = 'test',
                Email         = '',
                MobilePhone   = '',
                AccountId     = accountRecord.Id,
                Description   = ''
            );
            
            insert contactRecord;
            
            Profile profileTechnicianCommunityUser = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            
            User userRecordTechnicianCommunityUser = new User(
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
                ProfileId         = profileTechnicianCommunityUser.Id,
                ContactId         = contactRecord.Id
            );
            
            insert userRecordTechnicianCommunityUser;
        }
    }
    
    @isTest static void testInsert(){
        Test.startTest();
        
        User userRecordWithRole = [SELECT Id FROM User WHERE Username = 'userwithrole14@testorg.com'];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE MemberID = :userRecordTechnicianCommunityUser.id];
        Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
        
        system.runAs(userRecordWithRole){
            CollaborationGroup colGroup = new CollaborationGroup();
            colGroup.Name               = 'Test1';
            colGroup.Description        = 'desc';
            colGroup.CollaborationType  = 'Public';
            colGroup.NetworkId          = networkRecord.id;
            
            insert colGroup;
            
            userRecordTechnicianCommunityUser.subscribeGroup__c = colgroup.id;
            update userRecordTechnicianCommunityUser;
            
            CollaborationGroupMember colGroupMem = new CollaborationGroupMember();
            colGroupMem.MemberId                 = userRecordTechnicianCommunityUser.Id;
            colGroupMem.CollaborationGroupId     = colGroup.Id;
            
            insert colGroupMem;
        }
        
        List<FeedItem> feedItemList = new List<FeedItem>();
        system.runAs(userRecordTechnicianCommunityUser){
            CollaborationGroup collaborationGroupRecord = [SELECT Id FROM CollaborationGroup LIMIT 1];
            
            //Post
            FeedItem fip     = new FeedItem();
            fip.Body         = 'Test Feed Item Post';
            fip.ParentId     = collaborationGroupRecord.Id;
            fip.Type         = 'TextPost';
            fip.NetworkScope = networkRecord.id;
            feedItemList.add(fip);
            
            //Question
            FeedItem fiq     = new FeedItem();
            fiq.Body         = 'Test Feed Item Question';
            fiq.Title        = 'Title';
            fiq.ParentId     = collaborationGroupRecord.Id;
            fiq.Type         = 'QuestionPost';
            fiq.NetworkScope = networkRecord.id;
            feedItemList.add(fiq);
            
            //Shared
            FeedItem fis     = new FeedItem();
            fis.Body         = null;
            fis.Title        = '';
            fis.ParentId     = collaborationGroupRecord.Id;
            fis.Type         = 'AdvancedTextPost';
            fis.NetworkScope = networkRecord.id;
            feedItemList.add(fis);
            
            insert feedItemList;
        }
        
        FeedItem fip = [SELECT Id FROM FeedItem WHERE Type = 'TextPost'];
        List<Feed_Item_Holder__c> fipHolders = [SELECT Id FROM Feed_Item_Holder__c WHERE FeedItem_Id__c =: fip.Id];
        System.assertNotEquals(0, fipHolders.size());
        
        FeedItem fiq = [SELECT Id FROM FeedItem WHERE Type = 'QuestionPost'];
        List<Feed_Item_Holder__c> fiqHolders = [SELECT Id FROM Feed_Item_Holder__c WHERE FeedItem_Id__c =: fiq.Id];
        System.assertNotEquals(0, fiqHolders.size());
        
        FeedItem fis = [SELECT Id FROM FeedItem WHERE Type = 'AdvancedTextPost'];
        List<Feed_Item_Holder__c> fisHolders = [SELECT Id FROM Feed_Item_Holder__c WHERE FeedItem_Id__c =: fis.Id];
        System.assertNotEquals(0, fisHolders.size());
        
        Test.stopTest();
    }
}