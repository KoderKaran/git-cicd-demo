@IsTest(SeeAllData=true)
public class CustomChatterFeedListControllerTest {
    
    @isTest static void testGetFeeds() {
        
        UserRole r = new UserRole(name = 'TEST ROLE 15');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role15', 
            email='userwithrole15@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing15', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole15@testorg.com'

        );

        system.debug('userWithRole : ' + userWithRole);

        System.runAs(userWithRole) {

			Account account = new Account(
				Name = 'account',
				BillingStreet = '',
				BillingPostalCode = '',
				BillingCity = '',
				BillingCountry = '',
				BillingState = ''
			);
			insert account;
			
			Contact contact = new Contact(
				Firstname = 'Firstname',
				Lastname = 'Lastname',
				Avatar_URL__c = 'test',
				Email = '',
				MobilePhone = '',
				AccountId = account.Id,
				Description = ''
			);
			insert contact;

			Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
	        User user = new User(
	        	EmailEncodingKey = 'ISO-8859-1',
	            LanguageLocaleKey = 'en_US',
	            TimeZoneSidKey = 'America/New_York',
	            LocaleSidKey = 'en_US',
	            FirstName = 'first',
	            LastName = 'last',
	            Username = 'test@appirio.com', 
	            CommunityNickname = 'testUser123',
	            Alias = 't1',
	            Email = 'no@email.com',
	            IsActive = true,
	            ProfileId = p.Id,
	            ContactId = contact.Id
	        );
	        insert user;

	        system.debug('test user : ' + user);

			NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);
			
            Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
               
            CollaborationGroup colGroup = new CollaborationGroup();
            colGroup.Name               = 'Test1';
            colGroup.Description        = 'desc';
            colGroup.CollaborationType  = 'Public';
            colGroup.NetworkId          = networkRecord.id;
            
            insert colGroup;
            
	        system.runas(user){ 
	        	system.debug('test user id: ' + userinfo.getuserid());
			    FeedItem post = new FeedItem(); 
			    post.ParentId = colGroup.Id;
			    post.Body = 'test post';   
			    post.Title = 'testTitletest';
				post.Type = 'QuestionPost';
				post.IsRichText = true;
			    post.NetworkScope = membership.networkID;   //set the network ID of the post
			    insert post;

			    System.debug('post: ' + post);

				FeedItemViewsCounter__c counter = new FeedItemViewsCounter__c(
					FeedItemIdValue__c = post.Id,
					NumberOfViews__c = 0
				);
				try {
					insert counter;
				}
				catch (DmlException e) {
					throw new AuraHandledException(e.getMessage());
				}
            
            
            test.StartTest();
            List<WrapperFeedItem> wrapperFeeds = CustomChatterFeedListController.getFeeds(1, membership.networkID);
            
            test.StopTest();
            System.assertNotEquals(0, wrapperFeeds.size());
            
        }
    }
    }
    
    
    
    
    
   @isTest static void testGetQuestions() {
        
        UserRole r = new UserRole(name = 'TEST ROLE 17');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role17', 
            email='userwithrole17@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing17', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole17@testorg.com'

        );

        system.debug('userWithRole : ' + userWithRole);

        System.runAs(userWithRole) {

			Account account = new Account(
				Name = 'account',
				BillingStreet = '',
				BillingPostalCode = '',
				BillingCity = '',
				BillingCountry = '',
				BillingState = ''
			);
			insert account;
			
			Contact contact = new Contact(
				Firstname = 'Firstname',
				Lastname = 'Lastname',
				Avatar_URL__c = 'test',
				Email = '',
				MobilePhone = '',
				AccountId = account.Id,
				Description = ''
			);
			insert contact;

			Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
	        User user = new User(
	        	EmailEncodingKey = 'ISO-8859-1',
	            LanguageLocaleKey = 'en_US',
	            TimeZoneSidKey = 'America/New_York',
	            LocaleSidKey = 'en_US',
	            FirstName = 'first',
	            LastName = 'last',
	            Username = 'test@appirio.com', 
	            CommunityNickname = 'testUser123',
	            Alias = 't1',
	            Email = 'no@email.com',
	            IsActive = true,
	            ProfileId = p.Id,
	            ContactId = contact.Id
	        );
	        insert user;

	        system.debug('test user : ' + user);

			NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);
				
            Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
               
            CollaborationGroup colGroup = new CollaborationGroup();
            colGroup.Name               = 'Test1';
            colGroup.Description        = 'desc';
            colGroup.CollaborationType  = 'Public';
            colGroup.NetworkId          = networkRecord.id;
            
            insert colGroup;
            
	        system.runas(user){ 
	        	system.debug('test user id: ' + userinfo.getuserid());
			    FeedItem post = new FeedItem(); 
			    post.ParentId = colGroup.Id; 
			    post.Body = 'test post';   
			    post.Title = 'testTitletest';
				post.Type = 'QuestionPost';
				post.IsRichText = true;
			    post.NetworkScope = membership.networkID;   //set the network ID of the post
			    insert post;

			    System.debug('post: ' + post);

				FeedItemViewsCounter__c counter = new FeedItemViewsCounter__c(
					FeedItemIdValue__c = post.Id,
					NumberOfViews__c = 0
				);
				try {
					insert counter;
				}
				catch (DmlException e) {
					throw new AuraHandledException(e.getMessage());
				}

            test.StartTest();
            List<WrapperFeedItem> latestWrapperFeeds = CustomChatterFeedListController.getQuestions('Latest', 1, 1, membership.networkID);
            List<WrapperFeedItem> weekWrapperFeeds = CustomChatterFeedListController.getQuestions('Week', 1, 1, membership.networkID);
            test.StopTest();
            System.assertNotEquals(0, latestWrapperFeeds.size());
        }
        
    }
    }
    
    

 
    
    @isTest static void testGetUserPhoto() {
        
        UserRole r = new UserRole(name = 'TEST ROLE 11');
        Database.insert(r);
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userWithRole = new User(
            alias = 'role11', 
            email='userwithrole11@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing11', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole11@testorg.com'
            
        );
        
        system.debug('userWithRole : ' + userWithRole);
        
        System.runAs(userWithRole) {
            
            Account account = new Account(
                Name = 'account3',
                BillingStreet = '',
                BillingPostalCode = '',
                BillingCity = '',
                BillingCountry = '',
                BillingState = ''
            );
            insert account;
            
            Contact contact = new Contact(
                Firstname = 'Firstname3',
                Lastname = 'Lastname3',
                Avatar_URL__c = 'test',
                Email = '',
                MobilePhone = '',
                AccountId = account.Id,
                Description = ''
            );
            insert contact;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            User user = new User(
                EmailEncodingKey = 'ISO-8859-1',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                FirstName = 'first',
                LastName = 'last',
                Username = 'test@appirio.com', 
                CommunityNickname = 'testUser123',
                Alias = 't1',
                Email = 'no@email.com',
                IsActive = true,
                ProfileId = p.Id,
                ContactId = contact.Id
            );
            insert user;
            
            system.debug('test user : ' + user);
            
            NetworkMember membership = [SELECT networkID, memberID 
                                        FROM NetworkMember 
                                        WHERE memberID = :user.id
                                       ];
            
            System.debug('member : ' + membership);
            
            system.runas(user){
                Test.startTest();
                String resultPhoto = CustomChatterFeedListController.getUserPhoto(user.Id);
                Test.stopTest();
                System.assertNotEquals(resultPhoto.length(), 0);
            }
            
        }
    }
    
    @isTest static void testGetTotalNumberOfPages() {
        
        UserRole r = new UserRole(name = 'TEST ROLE 12');
        Database.insert(r);
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User userWithRole = new User(
            alias = 'role12', 
            email='userwithrole12@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing12', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole12@testorg.com'
            
        );
        
        system.debug('userWithRole : ' + userWithRole);
        
        System.runAs(userWithRole) {
            
            Account account = new Account(
                Name = 'account4',
                BillingStreet = '',
                BillingPostalCode = '',
                BillingCity = '',
                BillingCountry = '',
                BillingState = ''
            );
            insert account;
            
            Contact contact = new Contact(
                Firstname = 'Firstname4',
                Lastname = 'Lastname4',
                Avatar_URL__c = 'test',
                Email = '',
                MobilePhone = '',
                AccountId = account.Id,
                Description = ''
            );
            insert contact;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
            User user = new User(
                EmailEncodingKey = 'ISO-8859-1',
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                FirstName = 'first',
                LastName = 'last',
                Username = 'test@appirio.com', 
                CommunityNickname = 'testUser123',
                Alias = 't1',
                Email = 'no@email.com',
                IsActive = true,
                ProfileId = p.Id,
                ContactId = contact.Id
            );
            insert user;
            
            system.debug('test user : ' + user);
            
            NetworkMember membership = [SELECT networkID, memberID 
                                        FROM NetworkMember 
                                        WHERE memberID = :user.id
                                       ];
            
            System.debug('member : ' + membership);
            
            system.runas(user){
                Test.startTest();
                Integer weekWrapperFeeds = CustomChatterFeedListController.getTotalNumberOfPages('Week', 1, membership.networkID);
                Integer allTimeWrapperFeeds = CustomChatterFeedListController.getTotalNumberOfPages('All Time', 1, membership.networkID);
                Integer unansweredWrapperFeeds = CustomChatterFeedListController.getTotalNumberOfPages('Unanswered', 1, membership.networkID);
                Test.stopTest();
                
            }
        }
    }
    
    @isTest static void testUpvoteDownvoteThisFeedItem() {
        
        UserRole r = new UserRole(name = 'TEST ROLE 15');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role15', 
            email='userwithrole15@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing15', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole15@testorg.com'

        );

        system.debug('userWithRole : ' + userWithRole);

        System.runAs(userWithRole) {

			Account account = new Account(
				Name = 'account',
				BillingStreet = '',
				BillingPostalCode = '',
				BillingCity = '',
				BillingCountry = '',
				BillingState = ''
			);
			insert account;
			
			Contact contact = new Contact(
				Firstname = 'Firstname',
				Lastname = 'Lastname',
				Avatar_URL__c = 'test',
				Email = '',
				MobilePhone = '',
				AccountId = account.Id,
				Description = ''
			);
			insert contact;

			Profile p = [SELECT Id FROM Profile WHERE Name='Technician Community User']; 
	        User user = new User(
	        	EmailEncodingKey = 'ISO-8859-1',
	            LanguageLocaleKey = 'en_US',
	            TimeZoneSidKey = 'America/New_York',
	            LocaleSidKey = 'en_US',
	            FirstName = 'first',
	            LastName = 'last',
	            Username = 'test@appirio.com', 
	            CommunityNickname = 'testUser123',
	            Alias = 't1',
	            Email = 'no@email.com',
	            IsActive = true,
	            ProfileId = p.Id,
	            ContactId = contact.Id
	        );
	        insert user;

	        system.debug('test user : ' + user);

			NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);
			
            Network networkRecord  = [ SELECT Name FROM Network WHERE Id =: membership.networkID];
               
            CollaborationGroup colGroup = new CollaborationGroup();
            colGroup.Name               = 'Test1';
            colGroup.Description        = 'desc';
            colGroup.CollaborationType  = 'Public';
            colGroup.NetworkId          = networkRecord.id;
            
            insert colGroup;
            
	        system.runas(user){ 
	        	system.debug('test user id: ' + userinfo.getuserid());
			    FeedItem post = new FeedItem(); 
			    post.ParentId = colGroup.Id;
			    post.Body = 'test post';   
			    post.Title = 'testTitletest';
				post.Type = 'QuestionPost';
				post.IsRichText = true;
			    post.NetworkScope = membership.networkID;   //set the network ID of the post
			    insert post;

			    System.debug('post: ' + post);

				FeedItemViewsCounter__c counter = new FeedItemViewsCounter__c(
					FeedItemIdValue__c = post.Id,
					NumberOfViews__c = 0
				);
				try {
					insert counter;
				}
				catch (DmlException e) {
					throw new AuraHandledException(e.getMessage());
				}
 
            test.startTest();
            CustomChatterFeedListController.upvoteThisFeedItem(post.Id, 'Down', membership.networkID);
            CustomChatterFeedListController.downvoteThisFeedItem(post.Id, 'Up', membership.networkID);
            test.StopTest();
        }
    }
}
}