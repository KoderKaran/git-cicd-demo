@isTest
private class CAPL_EmailNotificationsClassTest {
	
	@isTest static void testFetchUserId() {
		UserRole r = new UserRole(name = 'TEST ROLE 3');
		Database.insert(r);

		Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

		User userWithRole = new User(
			alias = 'role3', 
			email='userwithrole33@roletest1.com', 
			userroleid = r.id,
			emailencodingkey='UTF-8', 
			lastname='Testing3', 
			languagelocalekey='en_US', 
			localesidkey='en_US', 
			profileid = pf.Id, 
			timezonesidkey='America/Los_Angeles', 
			username='userwithrole3@testorg.com'

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

	        system.debug('test user : ' + user);

			NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);

	        system.runas(user){ 

				test.StartTest();
					String usrId = CAPL_EmailNotificationsClass.fetchUserId();
					NetworkMember networkMember = CAPL_EmailNotificationsClass.fetchEmailNotifications();
					CAPL_EmailNotificationsClass.updateEmailNotifications(membership);
				test.StopTest();
				System.assertEquals(user.Id, usrId);
			}

		}
	}
	
}