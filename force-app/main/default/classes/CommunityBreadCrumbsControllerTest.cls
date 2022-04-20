/**
 * @description       : Test class for FeedItemTriggerHandler
 * @author            : Simplus 
 * Modifications Log 
 * Ver   Date         Author   				Modification
 * 1.0   02-04-2021   Mozart Labao   		Initial Version
 * 1.x	 08-25-2021	  Raymart Tolentino   	Case-00026252
**/
@istest
public class CommunityBreadCrumbsControllerTest {
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
            
            NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE MemberID = :userRecordTechnicianCommunityUser.id];
            Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
            
            CollaborationGroup colGroup = new CollaborationGroup();
            colGroup.Name               = 'Test1';
            colGroup.Description        = 'desc';
            colGroup.CollaborationType  = 'Public';
            colGroup.NetworkId          = networkRecord.id;
            
            insert colGroup;
        }
    }
    
    @isTest static void testCommunityURLSinceLastVisit(){
        Test.startTest();
        CollaborationGroup collaborationGroupRecord = [SELECT Id FROM CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE MemberID = :userRecordTechnicianCommunityUser.id];
        Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
        
        String feedItemId = '';
        system.runAs(userRecordTechnicianCommunityUser){
            FeedItem fis     = new FeedItem();
            fis.Body         = null;
            fis.Title        = '';
            fis.ParentId     = collaborationGroupRecord.Id;
            fis.Type         = 'AdvancedTextPost';
            fis.NetworkScope = networkRecord.id;
            
            insert fis;
            feedItemId = fis.Id;
        }
        
        CommunityBreadCrumbsController.wrapperClass wrapper1 = CommunityBreadCrumbsController.communityURL(collaborationGroupRecord.Id, 'view=sincelastvisit');
        System.assertEquals(true, wrapper1.isGroupURL);
        
        CommunityBreadCrumbsController.wrapperClass wrapper2 = CommunityBreadCrumbsController.communityURL(feedItemId, 'view=sincelastvisit');
        System.assertEquals(true, wrapper2.isFeedURL);
        
        CommunityBreadCrumbsController.wrapperClass wrapper3 = CommunityBreadCrumbsController.communityURL(null, 'view=sincelastvisit');
        System.assertEquals(true, wrapper3.isFilter);
        Test.stopTest();
    }
    
    @isTest static void testCommunityURLToday(){
        Test.startTest();
        CollaborationGroup collaborationGroupRecord = [SELECT Id FROM CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE MemberID = :userRecordTechnicianCommunityUser.id];
        Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
        
        String feedItemId = '';
        system.runAs(userRecordTechnicianCommunityUser){
            FeedItem fip     = new FeedItem();
            fip.Body         = 'Test Feed Item Post';
            fip.ParentId     = collaborationGroupRecord.Id;
            fip.Type         = 'TextPost';
            fip.NetworkScope = networkRecord.id;
            
            insert fip;
            feedItemId = fip.Id;
        }
        
        CommunityBreadCrumbsController.wrapperClass wrapper1 = CommunityBreadCrumbsController.communityURL(feedItemId, 'view=today');
        System.assertEquals(true, wrapper1.isFeedURL);
        
        CommunityBreadCrumbsController.wrapperClass wrapper2 = CommunityBreadCrumbsController.communityURL(null, 'view=today');
        System.assertEquals(true, wrapper2.isFilter);
        Test.stopTest();
    }
    
    @isTest static void testCommunityURLTrending(){
        Test.startTest();
        CollaborationGroup collaborationGroupRecord = [SELECT Id FROM CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE MemberID = :userRecordTechnicianCommunityUser.id];
        Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
        
        String feedItemId = '';
        system.runAs(userRecordTechnicianCommunityUser){
            FeedItem fiq     = new FeedItem();
            fiq.Body         = 'Test Feed Item Question';
            fiq.Title        = 'Title';
            fiq.ParentId     = collaborationGroupRecord.Id;
            fiq.Type         = 'QuestionPost';
            fiq.NetworkScope = networkRecord.id;
            
            insert fiq;
            feedItemId = fiq.Id;
        }
        
        CommunityBreadCrumbsController.wrapperClass wrapper1 = CommunityBreadCrumbsController.communityURL(feedItemId, 'view=trending');
        System.assertEquals(true, wrapper1.isFeedURL);
        
        CommunityBreadCrumbsController.wrapperClass wrapper2 = CommunityBreadCrumbsController.communityURL(null, 'view=trending');
        System.assertEquals(true, wrapper2.isFilter);
        Test.stopTest();
    }
}