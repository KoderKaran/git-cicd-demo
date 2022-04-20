@isTest
private class PrivacyAndLanguageCtrlTest {

	@testSetup static void setup() {
		UserRole r = new UserRole(name = 'TEST ROLE 24');
        Database.insert(r);

        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User userWithRole = new User(
            alias = 'role24', 
            email='userwithrole24@roletest1.com', 
            userroleid = r.id,
            emailencodingkey='UTF-8', 
            lastname='Testing24', 
            languagelocalekey='en_US', 
            localesidkey='en_US', 
            profileid = pf.Id, 
            timezonesidkey='America/Los_Angeles', 
            username='userwithrole24@testorg.com'

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
	
	@isTest static void test_getUserSettings() {
		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test@appirio.com'
			LIMIT 1
		];

        system.runas(user){ 

			test.StartTest();
				User result = PrivacyAndLanguageCtrl.getUserSettings(user.Id);
			test.StopTest();
			System.assertEquals(user.Id, result.Id);
		}
	}
	
	@isTest static void test_saveUserSettings() {
		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test@appirio.com'
			LIMIT 1
		];

        system.runas(user){ 

			test.StartTest();
				Boolean result = PrivacyAndLanguageCtrl.saveUserSettings(user);
			test.StopTest();
			System.assertEquals(true, result);
		}
	}
	
	@isTest static void test_getOptions() {

		User user = [
			SELECT Id, Name, Username 
			FROM User 
			WHERE Username = 'test@appirio.com'
			LIMIT 1
		];

		system.runas(user){ 

	        system.debug('test user : ' + user);

			NetworkMember membership = [SELECT networkID, memberID 
				FROM NetworkMember 
	            WHERE memberID = :user.id
	        ];

	        System.debug('member : ' + membership);

	        Id objId = user.Id;

			SObject record = objId.getSObjectType().newSObject(objId);	        

			test.StartTest();
				List<String> result = PrivacyAndLanguageCtrl.getOptions(record, 'LanguageLocaleKey');
			test.StopTest();
		}
	}
}