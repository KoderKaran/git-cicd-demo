@isTest
private class CustomProfileMenuControllerTest {

	@testSetup static void setup() {
		UserRole r = new UserRole(name = 'TEST ROLE 23');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role23', 
            email='userwithrole23@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing23', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole23@testorg.com'

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
	    }
	}
	
	@isTest static void testFetchUser() {

		User user = [
			SELECT Id, Name, Username, ContactId
			FROM User 
			WHERE Username = 'test@appirio.com'
			LIMIT 1
		];

        system.runas(user){ 

        	NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);

			test.StartTest();
				Contact result = CustomProfileMenuController.fetchUser();
			test.StopTest();
			System.assertEquals(user.ContactId, result.Id);
		}
	}
	
}