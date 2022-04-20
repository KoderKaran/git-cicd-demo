@IsTest(SeeAllData=true)
private class CustomChatterFeedPostControllerTest {
	
	@isTest static void testGetUserPhoto() {

		UserRole r = new UserRole(name = 'TEST ROLE 14');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role14', 
            email='userwithrole14@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing14', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole14@testorg.com'

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

	        system.runas(user){
				Test.startTest();
		        	User resultPhoto = CustomChatterFeedPostController.getUserPhoto(user.Id);
		        Test.stopTest();
		        System.assertEquals(resultPhoto.Contact.Avatar_URL__c, 'test');
			}

		}
	}
	
	@isTest static void testGetFeedComments() {

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

				FeedComment firstComment = new FeedComment(
					FeedItemId = post.Id,
					CommentBody = 'test comment',
					Status = 'Published'
				);

				insert firstComment;

				FeedComment secondComment = new FeedComment(
					FeedItemId = post.Id,
					CommentBody = 'test comment',
					Status = 'Published'
				);

				insert secondComment;

				FeedComment thirdComment = new FeedComment(
					FeedItemId = post.Id,
					CommentBody = 'test comment',
					Status = 'Published'
				);

				insert thirdComment;

				FeedComment fourthComment = new FeedComment(
					FeedItemId = post.Id,
					CommentBody = 'test comment',
					Status = 'Published'
				);

				insert fourthComment;

				test.StartTest();
					List<WrapperFeedComment> wrapperFeeds = CustomChatterFeedPostController.getFeedComments(post.Id, membership.networkID);
					CustomChatterFeedPostController.updateBestComment(post.Id, firstComment.Id, membership.networkID);
				test.StopTest();

				//WrapperFeedItem result = wrapperFeeds.get(0);
				System.assertEquals(wrapperFeeds.size(), 4);
			}

		}
	}

	@isTest static void testGetFeedItem() {

		UserRole r = new UserRole(name = 'TEST ROLE 16');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role16', 
            email='userwithrole16@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing16', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole16@testorg.com'

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
					WrapperFeedItem wrapperFeed = CustomChatterFeedPostController.getFeedItem(post.Id, membership.networkID);
					CustomChatterFeedPostController.updateViewsForFeedItem(post.Id);
				test.StopTest();

				//WrapperFeedItem result = wrapperFeeds.get(0);
				System.assertEquals(wrapperFeed.feedItem.get('Title'), 'testTitletest');
			}

		}
	}

	@isTest static void testUpvoteThisComment() {

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

				FeedComment firstComment = new FeedComment(
					FeedItemId = post.Id,
					CommentBody = 'test comment',
					Status = 'Published'
				);

				insert firstComment;

				test.StartTest();
					CustomChatterFeedPostController.upvoteThisComment(firstComment.Id, 'Down', membership.networkID);
				test.StopTest();
			}

		}
	}

	@isTest static void testDownvoteThisComment() {

		UserRole r = new UserRole(name = 'TEST ROLE 18');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role18', 
            email='userwithrole18@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing18', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole18@testorg.com'

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

				FeedComment firstComment = new FeedComment(
					FeedItemId = post.Id,
					CommentBody = 'test comment',
					Status = 'Published'
				);

				insert firstComment;

				test.StartTest();
					CustomChatterFeedPostController.downvoteThisComment(firstComment.Id, 'Up', membership.networkID);
				test.StopTest();
			}

		}
	}

	@isTest static void testUpvoteThisFeedItem() {

		UserRole r = new UserRole(name = 'TEST ROLE 19');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role19', 
            email='userwithrole19@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing19', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole19@testorg.com'

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
					CustomChatterFeedPostController.upvoteThisFeedItem(post.Id, 'Down', membership.networkID);
				test.StopTest();
			}
		}
	}

	@isTest static void testDownvoteThisFeedItem() {

		UserRole r = new UserRole(name = 'TEST ROLE 20');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role20', 
            email='userwithrole20@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing20', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole20@testorg.com'

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
					CustomChatterFeedPostController.downvoteThisFeedItem(post.Id, 'Up', membership.networkID);
				test.StopTest();
			}
		}
	}

	@isTest static void testSubmitThisCommentWithoutAndWithAttachment() {

		UserRole r = new UserRole(name = 'TEST ROLE 20');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role21', 
            email='userwithrole21@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing21', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole21@testorg.com'

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
					CustomChatterFeedPostController.submitThisCommentWithoutAttachment(post.Id, 'some test text', membership.networkID);
					CustomChatterFeedPostController.submitThisCommentWithAttachment(post.Id, 'some test text', 'some body', 'some name', 'txt', membership.networkID);
				test.StopTest();
			}

		}
	}

	@isTest static void testGetFeedAttach() {

		UserRole r = new UserRole(name = 'TEST ROLE 22');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role22', 
            email='userwithrole22@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing22', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole22@testorg.com'

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

			   	/*ContentVersion file = new ContentVersion(
					versionData = EncodingUtil.base64Decode('fileBody'),
					title = 'somefile.txt',
					pathOnClient = '/' + 'somefile.txt'
				);

				insert file;*/

				/*FeedAttachment feedAttachment = new FeedAttachment(
				    feedEntityId = post.Id,
				    recordId = 'testId',
				    type = 'Content'
				);

		   		insert feedAttachment;*/

				test.StartTest();
					String result = CustomChatterFeedPostController.getFeedAttach(post.Id);
				test.StopTest();
			}

		}
	}
	
}