/**
 * @description       : Test class for ForumCategoriesController/FeedItemTriggerHandler
 * @author            : Simplus 
 * Modifications Log 
 * Ver   Date         Author   				Modification
 * 1.0   12-17-2020   Mozart Labao   		Initial Version
 * 1.x	 08-25-2021	  Raymart Tolentino   	Case-00026252
**/
@istest
public class forumCategoriesController2Test {
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
                BillingState      = '',
                SAP_ACCOUNT_ID__c = 'S005471'
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
            Network networkRecord  = [SELECT Name FROM Network WHERE Id =: membership.networkID];
            
            CollaborationGroup colGroup = new CollaborationGroup();
            colGroup.Name               = 'Test1';
            colGroup.Description        = 'desc';
            colGroup.CollaborationType  = 'Public';
            colGroup.NetworkId          = networkRecord.id;
            
            insert colGroup;
            
            CollaborationGroupVisibility__c collabGroupVisibilityRecord = new CollaborationGroupVisibility__c();
            collabGroupVisibilityRecord.Name = colGroup.Name;
            collabGroupVisibilityRecord.CollaborationGroupId__c = colGroup.Id; 
            collabGroupVisibilityRecord.CollaborationGroupName__c = colGroup.Name;
            collabGroupVisibilityRecord.IsAutomation__c = True; 
            collabGroupVisibilityRecord.CollaborationType__c = colGroup.CollaborationType;
            collabGroupVisibilityRecord.CollaborationGroupDescription__c = colGroup.Description;
            insert collabGroupVisibilityRecord; 
            
            CollaborationGroupMember colGroupMem = new CollaborationGroupMember();
            colGroupMem.MemberId                 = userRecordTechnicianCommunityUser.Id;
            colGroupMem.CollaborationGroupId     = colGroup.Id;
            
            insert colGroupMem;
            
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
        }
    }
    
    @isTest static void testGetCollaborationData(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        
        String collaborationGroupName = forumCategoriesController.getCollaborationData(collaborationGroup.Id);
        System.assertNotEquals(null, collaborationGroupName);
        Test.stopTest();
    }
    
    @isTest static void testSaveShadowObjecta(){
        Test.startTest();
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE MemberID = :userRecordTechnicianCommunityUser.id];
        Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
        
        FeedItem fip = [SELECT Id FROM FeedItem WHERE Type = 'TextPost'];
        
        forumCategoriesController.saveShadowObject(fip.Id, true);
        List<Feed_Item_Holder__c> holderRecords = [SELECT Id, is_pinned__c FROM Feed_Item_Holder__c WHERE feedItem_Id__c =: fip.Id];
        System.assertNotEquals(0, holderRecords.size());
        Test.stopTest();
    }
    
    @isTest static void testGetCollaborations(){
        Test.startTest();
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        System.runAs(userRecordTechnicianCommunityUser) {
            forumCategoriesController.collabListWrapperClass wrapper1 = forumCategoriesController.getCollaborations();
            System.assertNotEquals(0, wrapper1.collabList.size());
        }
        Test.stopTest();
    }
    
    @isTest static void testGetListCollaborationFeed(){
        Test.startTest();
        Filter_Since_Last_Visit__c csFilterRecord = new Filter_Since_Last_Visit__c();
        csFilterRecord.Name = 'Internal Testing';
        csFilterRecord.Day__c = '16';
        csFilterRecord.Year__c = '2021';
        csFilterRecord.Month__c = '7';
        csFilterRecord.is_Active__c = true;
        insert csFilterRecord;
        
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        
        List<CollaborationGroupFeed> collabGroupFeeds = forumCategoriesController.getListCollaborationFeed(collaborationGroup.Id, 'default');
        System.assertNotEquals(0, collabGroupFeeds.size());
        
        List<CollaborationGroupFeed> collabGroupFeeds2 = forumCategoriesController.getListCollaborationFeed(collaborationGroup.Id, 'today');
        System.assertNotEquals(0, collabGroupFeeds2.size());
        
        List<CollaborationGroupFeed> collabGroupFeeds3 = forumCategoriesController.getListCollaborationFeed(collaborationGroup.Id, 'sincelastvisit');
        System.assertNotEquals(0, collabGroupFeeds3.size());
        
        List<CollaborationGroupFeed> collabGroupFeeds4 = forumCategoriesController.getListCollaborationFeed(collaborationGroup.Id, 'trending');
        System.assertNotEquals(0, collabGroupFeeds4.size());
        
        Test.stopTest();
    }
    
    @isTest static void testGetFeedComments(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        List<FeedComment> feedComments = forumCategoriesController.getFeedComments(collaborationGroup.Id);
        System.assertEquals(0, feedComments.size());
        Test.stopTest();
    }
    
    @isTest static void testGetFeedItem(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        forumCategoriesController.feedItemWrapper wrapper1 = forumCategoriesController.getFeedItem(collaborationGroup.Id, 'default');
        System.assertNotEquals(0, wrapper1.feedItemList.size());
        
        forumCategoriesController.feedItemWrapper wrapper2 = forumCategoriesController.getFeedItem(collaborationGroup.Id, 'today');
        System.assertNotEquals(0, wrapper2.feedItemList.size());
        
        forumCategoriesController.feedItemWrapper wrapper3 = forumCategoriesController.getFeedItem(collaborationGroup.Id, 'sincelastvisit');
        System.assertNotEquals(0, wrapper3.feedItemList.size());
        
        forumCategoriesController.feedItemWrapper wrapper4 = forumCategoriesController.getFeedItem(collaborationGroup.Id, 'trending');
        System.assertNotEquals(0, wrapper4.feedItemList.size());
        Test.stopTest();
    }
    
    @isTest static void testGetFeedItemHolder(){
        Test.startTest();
        List<Feed_Item_Holder__c> feedItemHolders = forumCategoriesController.getFeedItemHolder();
        System.assertNotEquals(0, feedItemHolders.size());
        Test.stopTest();
    }
    
    @isTest static void testListUser(){
        
        Contact Contact_SAP_AccountId;
        Account Account_SAP_Id;
        List<User> users;

		Test.startTest();
        Contact_SAP_AccountId = [SELECT Id,Account.SAP_ACCOUNT_ID__c,AccountId FROM Contact WHERE FirstName ='Firstname' LIMIT 1];
        Account_SAP_Id = [SELECT id, SAP_ACCOUNT_ID__c FROM Account WHERE Id =:Contact_SAP_AccountId.AccountId LIMIT 1];
        users = forumCategoriesController.listUser('first');
        Test.stopTest();
        
        System.assertNotEquals(0, users.size());
        System.assertNotEquals(null, users[0].LastLoginDate);
        System.assertNotEquals(null, Account_SAP_Id.SAP_ACCOUNT_ID__c);
    }
    
    @isTest static void testFindByName(){
        Test.startTest();
        List<User> users = forumCategoriesController.findByName('first');
        System.assertNotEquals(0, users.size());
        Test.stopTest();
    }
    
    @isTest static void testEditCollaborationGroup(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        CollaborationGroupVisibility__c collabGroupVisibilityRecord = forumCategoriesController.editCollaborationGroup(collaborationGroup.Id);
        System.assertNotEquals(null, collabGroupVisibilityRecord);
        Test.stopTest();
    }
    
    @isTest static void testFetchUser(){
        Test.startTest();
        User userRecord = forumCategoriesController.fetchUser();
        System.assertNotEquals(null, userRecord);
        Test.stopTest();
    }
    
    @isTest static void testManageCollaborationGroupMember(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        List<CollaborationGroupMember> collabGroupMembers = forumCategoriesController.ManageCollaborationGroupMember(collaborationGroup.Id);
        System.assertNotEquals(0, collabGroupMembers.size());
        Test.stopTest();
    }
    
    @isTest static void testGetSeconds(){
        Test.startTest();
        Integer dateSeconds = forumCategoriesController.getSeconds(System.today());
        System.assertNotEquals(null, dateSeconds);
        Test.stopTest();
    }
    
    @isTest static void testGetMinutes(){
        Test.startTest();
        String dateMinutes = forumCategoriesController.getMinutes(System.today());
        System.assertNotEquals(null, dateMinutes);
        Test.stopTest();
    }
    
    @isTest static void testUpdateUserSubscriptionGroup(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        forumCategoriesController.updateUserSubscriptionGroup(collaborationGroup.Id, userRecordTechnicianCommunityUser.Id);
        
        User userAfterUpdate = [SELECT Id, subscribeGroup__c FROM User WHERE UserName = 'test123555@appirio.com'];
        System.assertNotEquals(null, userAfterUpdate.subscribeGroup__c);
        Test.stopTest();
    }
    
    @isTest static void testRemoveUserSubscriptionGroup(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        forumCategoriesController.updateUserSubscriptionGroup(collaborationGroup.Id, userRecordTechnicianCommunityUser.Id);
        forumCategoriesController.removeUserSubscriptionGroup(collaborationGroup.Id, userRecordTechnicianCommunityUser.Id);
        
        User userAfterUpdate = [SELECT Id, subscribeGroup__c FROM User WHERE UserName = 'test123555@appirio.com'];
        System.assertEquals(null, userAfterUpdate.subscribeGroup__c);
        Test.stopTest();
    }
    
    @isTest static void testUpdateUserSubscriptionPost(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        forumCategoriesController.updateUserSubscriptionPost(collaborationGroup.Id, userRecordTechnicianCommunityUser.Id);
        
        User userAfterUpdate = [SELECT Id, subscribePost__c FROM User WHERE UserName = 'test123555@appirio.com'];
        System.assertEquals(null, userAfterUpdate.subscribePost__c);
        Test.stopTest();
    }
    
    @isTest static void testRemoveUserSubscriptionPost(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        forumCategoriesController.removeUserSubscriptionPost(collaborationGroup.Id, userRecordTechnicianCommunityUser.Id);
        
        User userAfterUpdate = [SELECT Id, subscribePost__c FROM User WHERE UserName = 'test123555@appirio.com'];
        System.assertEquals(null, userAfterUpdate.subscribePost__c);
        Test.stopTest();
    }
    
    @isTest static void testRemoveUserAccessToGroup(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        User userRecordTechnicianCommunityUser = [SELECT Id FROM User WHERE UserName = 'test123555@appirio.com'];
        
        forumCategoriesController.removeUserAccessToGroup(userRecordTechnicianCommunityUser.Id, collaborationGroup.Id);
        List<CollaborationGroupMember> collabGroupMembers = [
            SELECT Id FROM CollaborationGroupMember WHERE MemberId =: userRecordTechnicianCommunityUser.Id AND CollaborationGroupId =: collaborationGroup.Id
        ];
        System.assertEquals(0, collabGroupMembers.size());
        Test.stopTest();
    }
    
    @isTest static void testDeleteCollaborationGroup(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        
        forumCategoriesController.deleteCollaborationGroup(collaborationGroup.Id);
        List<CollaborationGroup> collabGroups = [
            SELECT Id FROM CollaborationGroup WHERE Id =: collaborationGroup.Id
        ];
        System.assertNotEquals(null, collabGroups.size());
        Test.stopTest();
    }
    
    @isTest static void testGetFeedNameData(){
        Test.startTest();
        FeedItem feedItemRecord = [SELECT Id FROM FeedItem LIMIT 1];
        String feedItemName = forumCategoriesController.getFeedNameData(feedItemRecord.Id);
        System.assertNotEquals('', feedItemName);
        
        Test.stopTest();
    }
    
    @isTest static void testDeleteCollaborationGroupFeed(){
        Test.startTest();
        CollaborationGroupFeed collabGroupFeed = [SELECT Id FROM CollaborationGroupFeed LIMIT 1];
        List<CollaborationGroupFeed> collabGroupFeeds = forumCategoriesController.deleteCollaborationGroupFeed(collabGroupFeed.Id, 'default');
        
        List<CollaborationGroupFeed> collabGroupFeedsAfterDelete = [SELECT Id FROM CollaborationGroupFeed];
        System.assertNotEquals(0, collabGroupFeedsAfterDelete.size());
        Test.stopTest();
    }
    
    @isTest static void testSaveRecord(){
        Test.startTest();
        forumCategoriesController.saveRecord('Sample', 'Public', 'Sample', false, false);
        List<CollaborationGroup> collabList = [SELECT Id FROM CollaborationGroup WHERE Name = 'Sample'];
        System.assertNotEquals(0, collabList.size());
        Test.stopTest();
    }
    
    @isTest static void testSendMailMethod(){
        Test.startTest();
        String mMail = 'Test@gmail.com';
        String mSubject = 'testSubject';
        String eSubject = 'eSubject';
        String mBodyLink = 'bodytest';
        String getUserName = 'testUser';
        
        forumCategoriesController.sendMailMethod(mMail,mSubject,eSubject,mBodyLink,getUserName);
        Test.stopTest();
    }
    
    @isTest static void testSaveChunks(){
        Test.startTest();
        String mMail = 'Test@gmail.com';
        String mSubject = 'testSubject';
        String eSubject = '';
        String mBodyLink = 'bodytest';
        String getUserName = '';
        
        Id attachmentId = forumCategoriesController.saveChunk(mMail,mSubject,eSubject,mBodyLink,getUserName);
        System.assertNotEquals(null, attachmentId);
        
        Id attachmentId2 = forumCategoriesController.saveTheFile(mMail,mSubject,eSubject,mBodyLink);
        System.assertNotEquals(null, attachmentId2);
        Test.stopTest();
    }
    
    @isTest static void testGetFeedItem1(){
        Test.startTest();
        List<FeedItem> feedItemList = new List<FeedItem>();
        CollaborationGroup collaborationGroup = [SELECT Id, Name, Description, CollaborationType FROM CollaborationGroup LIMIT 1];
        List<FeedItem> newFeedItemList = forumCategoriesController.getFeedItem1(collaborationGroup.Id, feedItemList);
        System.assertNotEquals(0, newFeedItemList.size());
        Test.stopTest();
    }
    
    @isTest static void testLockCustomCollab(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [SELECT Id, Name, Description, CollaborationType FROM CollaborationGroup LIMIT 1];
        forumCategoriesController.lockCustomCollab(collaborationGroup.Id, 'false');
        
        CollaborationGroup collabGroupAfterLock = [SELECT id, isBroadcast FROM CollaborationGroup WHERE Id =: collaborationGroup.Id];
        System.assertEquals(false, collabGroupAfterLock.isBroadcast);
        Test.stopTest();
    }
    
    @isTest static void testLockFeedItem(){
        Test.startTest();
        FeedItem feedItemRecord = [SELECT Id FROM FeedItem LIMIT 1];
        forumCategoriesController.lockFeedItem(feedItemRecord.Id, 'false');
        
        Feed_Item_Holder__c feedItemAfterLock = [SELECT id,FeedItem_Id__c,Is_Lock__c FROM Feed_Item_Holder__c WHERE feedItem_Id__c =: feedItemRecord.Id];
        System.assertEquals(false, feedItemAfterLock.Is_Lock__c);
        Test.stopTest();
    }
    
    @isTest static void testGetNewCollaborationGroupFeeds(){
        Test.startTest();
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        Integer newRecordCount = forumCategoriesController.getNewCollaborationGroupFeeds(collaborationGroup.Id, new List<String>());
        System.assertNotEquals(0, newRecordCount);
        Test.stopTest();
    }
    
    @isTest static void testGetCollaborationGroupFeeds(){
        Test.startTest();
        Filter_Since_Last_Visit__c csFilterRecord = new Filter_Since_Last_Visit__c();
        csFilterRecord.Name = 'Internal Testing';
        csFilterRecord.Day__c = '16';
        csFilterRecord.Year__c = '2021';
        csFilterRecord.Month__c = '7';
        csFilterRecord.is_Active__c = true;
        insert csFilterRecord;
        
        CollaborationGroup collaborationGroup = [Select Id, Name, Description, CollaborationType From CollaborationGroup LIMIT 1];
        List<forumCategoriesController.CollaborationGroupFeedWrapper> wrapperList = forumCategoriesController.getCollaborationGroupFeeds(collaborationGroup.Id, 'default');
        System.assertNotEquals(0, wrapperList.size());
        
        List<forumCategoriesController.CollaborationGroupFeedWrapper> wrapperList2 = forumCategoriesController.getCollaborationGroupFeeds(collaborationGroup.Id, 'today');
        System.assertNotEquals(0, wrapperList2.size());
        
        List<forumCategoriesController.CollaborationGroupFeedWrapper> wrapperList3 = forumCategoriesController.getCollaborationGroupFeeds(collaborationGroup.Id, 'sincelastvisit');
        System.assertNotEquals(0, wrapperList3.size());
        
        List<forumCategoriesController.CollaborationGroupFeedWrapper> wrapperList4 = forumCategoriesController.getCollaborationGroupFeeds(collaborationGroup.Id, 'trending');
        System.assertNotEquals(0, wrapperList4.size());
        Test.stopTest();
    }
}