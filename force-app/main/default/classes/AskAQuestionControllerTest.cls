@isTest
private class AskAQuestionControllerTest {

	@testSetup static void setup() {
		UserRole r = new UserRole(name = 'TEST ROLE 2');
		Database.insert(r);

		Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User userWithRole = new User(
			alias = 'role2', 
			email='userwithrole2@roletest11.com', 
			userroleid = r.id,
			emailencodingkey='UTF-8', 
			lastname='Testing2', 
			languagelocalekey='en_US', 
			localesidkey='en_US', 
			profileid = pf.Id, 
			timezonesidkey='America/Los_Angeles', 
			username='userwithrole12@testorg.com'

		);

		system.debug('userWithRole : ' + userWithRole);

		System.runAs(userWithRole) {

			Account account = new Account(
				Name = 'account',
				BillingStreet = '',
				BillingPostalCode = '',
				BillingCity = '',
				BillingCountry = '',
				BillingState = '',
				OwnerId = userWithRole.Id
			);
			insert account;
			
			Contact contact = new Contact(
				Firstname = 'Firstname',
				Lastname = 'Lastname',
				Avatar_URL__c = 'test',
				Email = '',
				MobilePhone = '',
				AccountId = account.Id,
				Description = '',
				OwnerId = userWithRole.Id
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
	    }
	}
	
	@isTest static void getUserPhotoTest() {

		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test@appirio.com'
		];

        system.runas(user){ 
        	NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        Test.startTest();
	        	String resultPhoto = AskAQuestionController.getUserPhoto(user.Id);
	        Test.stopTest();
	        System.assertNotEquals(resultPhoto.length(), 0);
	    }
	}
	
	@isTest static void testSaveQuestion() {

		UserRole r = [
			SELECT Id, Name 
			FROM UserRole 
			WHERE Name = 'TEST ROLE 2'
		];

		User user = [
			SELECT Id, Name, UserRoleId, Username
			FROM User 
			WHERE UserRoleId =: r.Id
			AND Username = 'userwithrole12@testorg.com'
			LIMIT 1
		];

        system.runas(user){ 

        	NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	            LIMIT 1
	        ];

        	system.debug('test user id: ' + userinfo.getuserid());
		    FeedItem post = new FeedItem(); 
		    post.ParentId = userinfo.getuserid(); 
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

			List<Topic> myFeedItemFeedAssignments = [
				SELECT
				    Id,
				    NetworkId,
				    Name
				FROM
				    Topic
				WHERE
				    NetworkId =: membership.networkID
		    ];
			List<String> recordIds = new List<String>();

			test.StartTest();
				String postId = AskAQuestionController.saveQuestion(user.Id, 'title', 'details', recordIds, membership.networkID);
				String postWithAttachId = AskAQuestionController.saveQuestionWithAttach(user.Id, 'title', 'details', recordIds, 'body', 'name', 'txt', membership.networkID);
			test.StopTest();

			System.assertNotEquals(null, postId);
			System.assertNotEquals(null, postWithAttachId);
		}
	}
	
}